Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbbANODx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:03:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbbANODv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:03:51 -0500
Date: Wed, 14 Jan 2015 06:02:29 -0800
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-bb04159df99fa353d0fb524574aca03ce2c6515b@git.kernel.org>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        ktkhai@parallels.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, bsegall@google.com
Reply-To: bsegall@google.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ktkhai@parallels.com, hpa@zytor.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
In-Reply-To: <1418644618.6074.13.camel@tkhai>
References: <1418644618.6074.13.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Fix sched_entity::avg::
 decay_count initialization
Git-Commit-ID: bb04159df99fa353d0fb524574aca03ce2c6515b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb04159df99fa353d0fb524574aca03ce2c6515b
Gitweb:     http://git.kernel.org/tip/bb04159df99fa353d0fb524574aca03ce2c6515b
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Mon, 15 Dec 2014 14:56:58 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 13:34:16 +0100

sched/fair: Fix sched_entity::avg::decay_count initialization

Child has the same decay_count as parent. If it's not zero,
we add it to parent's cfs_rq->removed_load:

wake_up_new_task()->set_task_cpu()->migrate_task_rq_fair().

Child's load is a just garbade after copying of parent,
it hasn't been on cfs_rq yet, and it must not be added to
cfs_rq::removed_load in migrate_task_rq_fair().

The patch moves sched_entity::avg::decay_count intialization
in sched_fork(). So, migrate_task_rq_fair() does not change
removed_load.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1418644618.6074.13.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 3 +++
 kernel/sched/fair.c | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 816c172..95ac795 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1832,6 +1832,9 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
 	p->se.vruntime			= 0;
+#ifdef CONFIG_SMP
+	p->se.avg.decay_count		= 0;
+#endif
 	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 97000a9..2a0b302 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -676,7 +676,6 @@ void init_task_runnable_average(struct task_struct *p)
 {
 	u32 slice;
 
-	p->se.avg.decay_count = 0;
 	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
 	p->se.avg.runnable_avg_sum = slice;
 	p->se.avg.runnable_avg_period = slice;
