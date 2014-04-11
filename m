Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbaDKN5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:57:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39771 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbaDKNzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:55:53 -0400
Message-Id: <20140411135218.478299389@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Apr 2014 15:42:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 6/8] sched,idle: Avoid spurious wakeup IPIs
References: <20140411134243.160989490@infradead.org>
Content-Disposition: inline; filename=peterz-sched-resched_cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because mwait_idle_with_hints() gets called from !idle context it must
call current_clr_polling(). This however means that resched_task() is
very likely to send an IPI even when we were polling:

  CPU0					CPU1

  if (current_set_polling_and_test())
    goto out;

  __monitor(&ti->flags);
  if (!need_resched())
    __mwait(eax, ecx);
					set_tsk_need_resched(p);
					smp_mb();
out:
  current_clr_polling();
					if (!tsk_is_polling(p))
					  smp_send_reschedule(cpu);


So while it is correct (extra IPIs aren't a problem, whereas a missed
IPI would be) it is a performance problem (for some).

Avoid this issue by using fetch_or() to atomically set NEED_RESCHED
and test if POLLING_NRFLAG is set.

Since a CPU stuck in mwait is unlikely to modify the flags word,
contention on the cmpxchg is unlikely and thus we should mostly
succeed in a single go.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -505,6 +505,39 @@ static inline void init_hrtick(void)
 #endif	/* CONFIG_SCHED_HRTICK */
 
 /*
+ * cmpxchg based fetch_or, macro so it works for different integer types
+ */
+#define fetch_or(ptr, val)						\
+({	typeof(*(ptr)) __old, __val = *(ptr);				\
+ 	for (;;) {							\
+ 		__old = cmpxchg((ptr), __val, __val | (val));		\
+ 		if (__old == __val)					\
+ 			break;						\
+ 		__val = __old;						\
+ 	}								\
+ 	__old;								\
+})
+
+#ifdef TIF_POLLING_NRFLAG
+/*
+ * Atomically set TIF_NEED_RESCHED and test for TIF_POLLING_NRFLAG,
+ * this avoids any races wrt polling state changes and thereby avoids
+ * spurious IPIs.
+ */
+static bool set_nr_and_not_polling(struct task_struct *p)
+{
+	struct thread_info *ti = task_thread_info(p);
+	return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
+}
+#else
+static bool set_nr_and_not_polling(struct task_struct *p)
+{
+	set_tsk_need_resched(p);
+	return true;
+}
+#endif
+
+/*
  * resched_task - mark a task 'to be rescheduled now'.
  *
  * On UP this means the setting of the need_resched flag, on SMP it
@@ -520,17 +553,15 @@ void resched_task(struct task_struct *p)
 	if (test_tsk_need_resched(p))
 		return;
 
-	set_tsk_need_resched(p);
-
 	cpu = task_cpu(p);
+
 	if (cpu == smp_processor_id()) {
+		set_tsk_need_resched(p);
 		set_preempt_need_resched();
 		return;
 	}
 
-	/* NEED_RESCHED must be visible before we test polling */
-	smp_mb();
-	if (!tsk_is_polling(p))
+	if (set_nr_and_not_polling(p))
 		smp_send_reschedule(cpu);
 }
 


