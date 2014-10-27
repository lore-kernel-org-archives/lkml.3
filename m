Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaJ0S61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:58:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaJ0S6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:58:25 -0400
Date: Mon, 27 Oct 2014 20:54:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Christoph Lameter <cl@linux.com>
Subject: [PATCH 3/3] introduce task_rcu_dereference()
Message-ID: <20141027195446.GD11736@redhat.com>
References: <1413962231.19914.130.camel@tkhai> <20141027195339.GA11736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027195339.GA11736@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_struct is only protected by RCU if it was found on a RCU protected
list (say, for_each_process() or find_task_by_vpid()).

And as Kirill pointed out rq->curr isn't protected by RCU, the scheduler
drops the (potentially) last reference without RCU gp, this means that we
need to fix the code which uses foreign_rq->curr under rcu_read_lock().

Add a new helper which can be used to dereferene rq->curr or any other
pointer to task_struct assuming that it should be cleared or updated
before the final put_task_struct(). It returns non-NULL only if this
task can't go away before rcu_read_unlock().

Suggested-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    1 +
 kernel/exit.c         |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 857ba40..0ba420e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2300,6 +2300,7 @@ extern void block_all_signals(int (*notifier)(void *priv), void *priv,
 			      sigset_t *mask);
 extern void unblock_all_signals(void);
 extern void release_task(struct task_struct * p);
+extern struct task_struct *task_rcu_dereference(struct task_struct **ptask);
 extern int send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7..d8b95c2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -213,6 +213,55 @@ repeat:
 		goto repeat;
 }
 
+struct task_struct *task_rcu_dereference(struct task_struct **ptask)
+{
+	struct task_struct *task;
+	struct sighand_struct *sighand;
+
+	/*
+	 * We need to verify that release_task() was not called and thus
+	 * delayed_put_task_struct() can't run and drop the last reference
+	 * before rcu_read_unlock(). We check task->sighand != NULL, but
+	 * we can read the already freed and reused memory.
+	 */
+ retry:
+	task = rcu_dereference(*ptask);
+	if (!task)
+		return NULL;
+
+	probe_slab_address(&task->sighand, sighand);
+	/*
+	 * Pairs with atomic_dec_and_test(usage) in put_task_struct(task).
+	 * If this task was already freed we can not miss the preceding
+	 * update of this pointer.
+	 */
+	smp_rmb();
+	if (unlikely(task != ACCESS_ONCE(*ptask)))
+		goto retry;
+
+	/*
+	 * Either this is the same task and we can trust sighand != NULL, or
+	 * its memory was re-instantiated as another instance of task_struct.
+	 * In the latter case the new task can not go away until another rcu
+	 * gp pass, so the only problem is that sighand == NULL can be false
+	 * positive but we can pretend we got this NULL before it was freed.
+	 */
+	if (sighand)
+		return task;
+
+	/*
+	 * We could even eliminate the false positive mentioned above:
+	 *
+	 *	probe_slab_address(&task->sighand, sighand);
+	 *	if (sighand)
+	 *		goto retry;
+	 *
+	 * if sighand != NULL because we read the freed memory we should
+	 * see the new pointer, otherwise we will likely return this task.
+	 */
+	return NULL;
+}
+
 /*
  * This checks not only the pgrp, but falls back on the pid if no
  * satisfactory pgrp is found. I dunno - gdb doesn't work correctly
-- 
1.5.5.1


