Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaFEOix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:38:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48590 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaFEOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:38:51 -0400
Date: Thu, 5 Jun 2014 07:37:54 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e3baac47f0e82c4be632f4f97215bb93bf16b342@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, umgwanakikbuti@gmail.com,
        luto@amacapital.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, umgwanakikbuti@gmail.com,
        luto@amacapital.net, tglx@linutronix.de
In-Reply-To: <ce06f8b02e7e337be63e97597fc4b248d3aa6f9b.1401902905.git.luto@amacapital.net>
References: <ce06f8b02e7e337be63e97597fc4b248d3aa6f9b.1401902905.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle: Optimize try-to-wake-up IPI
Git-Commit-ID: e3baac47f0e82c4be632f4f97215bb93bf16b342
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

Commit-ID:  e3baac47f0e82c4be632f4f97215bb93bf16b342
Gitweb:     http://git.kernel.org/tip/e3baac47f0e82c4be632f4f97215bb93bf16b342
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 4 Jun 2014 10:31:18 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:09:53 +0200

sched/idle: Optimize try-to-wake-up IPI

[ This series reduces the number of IPIs on Andy's workload by something like
  99%. It's down from many hundreds per second to very few.

  The basic idea behind this series is to make TIF_POLLING_NRFLAG be a
  reliable indication that the idle task is polling.  Once that's done,
  the rest is reasonably straightforward. ]

When enqueueing tasks on remote LLC domains, we send an IPI to do the
work 'locally' and avoid bouncing all the cachelines over.

However, when the remote CPU is idle (and polling, say x86 mwait), we
don't need to send an IPI, we can simply kick the TIF word to wake it
up and have the 'idle' loop do the work.

So when _TIF_POLLING_NRFLAG is set, but _TIF_NEED_RESCHED is not (yet)
set, set _TIF_NEED_RESCHED and avoid sending the IPI.

Much-requested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
[Edited by Andy Lutomirski, but this is mostly Peter Zijlstra's code.]
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: nicolas.pitre@linaro.org
Cc: daniel.lezcano@linaro.org
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: umgwanakikbuti@gmail.com
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/ce06f8b02e7e337be63e97597fc4b248d3aa6f9b.1401902905.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 54 ++++++++++++++++++++++++++++++++++++++++++++++------
 kernel/sched/idle.c  | 10 +++++++---
 kernel/sched/sched.h |  6 ++++++
 3 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6afbfee..60d4e05 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -519,7 +519,7 @@ static inline void init_hrtick(void)
  	__old;								\
 })
 
-#ifdef TIF_POLLING_NRFLAG
+#if defined(CONFIG_SMP) && defined(TIF_POLLING_NRFLAG)
 /*
  * Atomically set TIF_NEED_RESCHED and test for TIF_POLLING_NRFLAG,
  * this avoids any races wrt polling state changes and thereby avoids
@@ -530,12 +530,44 @@ static bool set_nr_and_not_polling(struct task_struct *p)
 	struct thread_info *ti = task_thread_info(p);
 	return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
 }
+
+/*
+ * Atomically set TIF_NEED_RESCHED if TIF_POLLING_NRFLAG is set.
+ *
+ * If this returns true, then the idle task promises to call
+ * sched_ttwu_pending() and reschedule soon.
+ */
+static bool set_nr_if_polling(struct task_struct *p)
+{
+	struct thread_info *ti = task_thread_info(p);
+	typeof(ti->flags) old, val = ACCESS_ONCE(ti->flags);
+
+	for (;;) {
+		if (!(val & _TIF_POLLING_NRFLAG))
+			return false;
+		if (val & _TIF_NEED_RESCHED)
+			return true;
+		old = cmpxchg(&ti->flags, val, val | _TIF_NEED_RESCHED);
+		if (old == val)
+			break;
+		val = old;
+	}
+	return true;
+}
+
 #else
 static bool set_nr_and_not_polling(struct task_struct *p)
 {
 	set_tsk_need_resched(p);
 	return true;
 }
+
+#ifdef CONFIG_SMP
+static bool set_nr_if_polling(struct task_struct *p)
+{
+	return false;
+}
+#endif
 #endif
 
 /*
@@ -1490,13 +1522,17 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 }
 
 #ifdef CONFIG_SMP
-static void sched_ttwu_pending(void)
+void sched_ttwu_pending(void)
 {
 	struct rq *rq = this_rq();
 	struct llist_node *llist = llist_del_all(&rq->wake_list);
 	struct task_struct *p;
+	unsigned long flags;
 
-	raw_spin_lock(&rq->lock);
+	if (!llist)
+		return;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	while (llist) {
 		p = llist_entry(llist, struct task_struct, wake_entry);
@@ -1504,7 +1540,7 @@ static void sched_ttwu_pending(void)
 		ttwu_do_activate(rq, p, 0);
 	}
 
-	raw_spin_unlock(&rq->lock);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 void scheduler_ipi(void)
@@ -1550,8 +1586,14 @@ void scheduler_ipi(void)
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
-	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
-		smp_send_reschedule(cpu);
+	struct rq *rq = cpu_rq(cpu);
+
+	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list)) {
+		if (!set_nr_if_polling(rq->idle))
+			smp_send_reschedule(cpu);
+		else
+			trace_sched_wake_idle_without_ipi(cpu);
+	}
 }
 
 bool cpus_share_cache(int this_cpu, int that_cpu)
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index fe4b24b..cf009fb 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -12,6 +12,8 @@
 
 #include <trace/events/power.h>
 
+#include "sched.h"
+
 static int __read_mostly cpu_idle_force_poll;
 
 void cpu_idle_poll_ctrl(bool enable)
@@ -237,12 +239,14 @@ static void cpu_idle_loop(void)
 		__current_clr_polling();
 
 		/*
-		 * We promise to reschedule if need_resched is set while
-		 * polling is set.  That means that clearing polling
-		 * needs to be visible before rescheduling.
+		 * We promise to call sched_ttwu_pending and reschedule
+		 * if need_resched is set while polling is set.  That
+		 * means that clearing polling needs to be visible
+		 * before doing these things.
 		 */
 		smp_mb__after_atomic();
 
+		sched_ttwu_pending();
 		schedule_preempt_disabled();
 	}
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 956b8ca..2f86361 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -670,6 +670,8 @@ extern int migrate_swap(struct task_struct *, struct task_struct *);
 
 #ifdef CONFIG_SMP
 
+extern void sched_ttwu_pending(void);
+
 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
 			      lockdep_is_held(&sched_domains_mutex))
@@ -787,6 +789,10 @@ static inline unsigned int group_first_cpu(struct sched_group *group)
 
 extern int group_balance_cpu(struct sched_group *sg);
 
+#else
+
+static inline void sched_ttwu_pending(void) { }
+
 #endif /* CONFIG_SMP */
 
 #include "stats.h"
