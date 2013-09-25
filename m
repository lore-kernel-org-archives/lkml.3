Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3IYQj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:39:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3IYQjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:39:52 -0400
Date: Wed, 25 Sep 2013 09:39:20 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-4k0b7oy1rcdyzochwiixuwi9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Prepare for per-cpu preempt_count
Git-Commit-ID: a233f1120c37724938f7201fe2353b2577adaaf9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:39:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a233f1120c37724938f7201fe2353b2577adaaf9
Gitweb:     http://git.kernel.org/tip/a233f1120c37724938f7201fe2353b2577adaaf9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 23 Sep 2013 19:04:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 14:07:55 +0200

sched: Prepare for per-cpu preempt_count

When using per-cpu preempt_count variables we need to save/restore the
preempt_count on context switch (into per task storage; for instance
the old thread_info::preempt_count variable) because of
PREEMPT_ACTIVE.

However, this means that on fork() the preempt_count value of the last
context switch gets copied and if we had a PREEMPT_ACTIVE switch right
before cloning a child task the child task will now too have
PREEMPT_ACTIVE set and start its life with an extra PREEMPT_ACTIVE
count.

Therefore we need to make init_task_preempt_count() unconditional;
this resets whatever preempt_count we inherited from our parent
process.

Doing so for !per-cpu implementations is harmless.

For !PREEMPT_COUNT kernels we need to be careful not to start life
with an increased preempt_count.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-4k0b7oy1rcdyzochwiixuwi9@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 12 +++++++++---
 kernel/sched/core.c   |  2 --
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 06ac17c..b09798b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -428,6 +428,14 @@ struct task_cputime {
 		.sum_exec_runtime = 0,				\
 	}
 
+#define PREEMPT_ENABLED		(PREEMPT_NEED_RESCHED)
+
+#ifdef CONFIG_PREEMPT_COUNT
+#define PREEMPT_DISABLED	(1 + PREEMPT_ENABLED)
+#else
+#define PREEMPT_DISABLED	PREEMPT_ENABLED
+#endif
+
 /*
  * Disable preemption until the scheduler is running.
  * Reset by start_kernel()->sched_init()->init_idle().
@@ -435,9 +443,7 @@ struct task_cputime {
  * We include PREEMPT_ACTIVE to avoid cond_resched() from working
  * before the scheduler is active -- see should_resched().
  */
-#define INIT_PREEMPT_COUNT	(1 + PREEMPT_ACTIVE + PREEMPT_NEED_RESCHED)
-#define PREEMPT_ENABLED		(PREEMPT_NEED_RESCHED)
-#define PREEMPT_DISABLED	(1 + PREEMPT_NEED_RESCHED)
+#define INIT_PREEMPT_COUNT	(PREEMPT_DISABLED + PREEMPT_ACTIVE)
 
 /**
  * struct thread_group_cputimer - thread group interval timer counts
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9c84a9a..f575d5b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1722,9 +1722,7 @@ void sched_fork(struct task_struct *p)
 #if defined(CONFIG_SMP)
 	p->on_cpu = 0;
 #endif
-#ifdef CONFIG_PREEMPT_COUNT
 	init_task_preempt_count(p);
-#endif
 #ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
 #endif
