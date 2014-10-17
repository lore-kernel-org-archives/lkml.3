Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaJQVkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 17:40:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaJQVkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 17:40:10 -0400
Date: Fri, 17 Oct 2014 23:36:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: [PATCH] sched/numa: fix unsafe get_task_struct() in
	task_numa_assign()
Message-ID: <20141017213641.GB32576@redhat.com>
References: <1413376300.24793.55.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413376300.24793.55.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lockless get_task_struct(tsk) is only safe if tsk == current
and didn't pass exit_notify(), or if this tsk was found on a rcu
protected list (say, for_each_process() or find_task_by_vpid()).
IOW, it is only safe if release_task() was not called before we
take rcu_read_lock(), in this case we can rely on the fact that
delayed_put_pid() can not drop the (potentially) last reference
until rcu_read_unlock().

And as Kirill pointed out task_numa_compare()->task_numa_assign()
path does get_task_struct(dst_rq->curr) and this is not safe. The
task_struct itself can't go away, but rcu_read_lock() can't save
us from the final put_task_struct() in finish_task_switch(); this
reference goes away without rcu gp.

Reported-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/fair.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0090e8c..52049b9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1158,7 +1158,13 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
-	if (cur->pid == 0) /* idle */
+	/*
+	 * No need to move the exiting task, and this ensures that ->curr
+	 * wasn't reaped and thus get_task_struct() in task_numa_assign()
+	 * is safe; note that rcu_read_lock() can't protect from the final
+	 * put_task_struct() after the last schedule().
+	 */
+	if (is_idle_task(cur) || (cur->flags & PF_EXITING))
 		cur = NULL;
 
 	/*
-- 
1.5.5.1


