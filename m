Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3KTQdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:33:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46529 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3KTQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:32:56 -0500
Message-Id: <20131120162736.446984500@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 20 Nov 2013 17:04:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 2/7] sched, preempt: Fixup missed PREEMPT_NEED_RESCHED folding
References: <20131120160450.072555619@infradead.org>
Content-Disposition: inline; filename=peterz-preempt_fold_need_resched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With various drivers wanting to inject idle time; we get people
calling idle routines outside of the idle loop proper.

Therefore we need to be extra careful about not missing
TIF_NEED_RESCHED -> PREEMPT_NEED_RESCHED propagations.

While looking at this, I also realized there's a small window in the
existing idle loop where we can miss TIF_NEED_RESCHED; when it hits
right after the tif_need_resched() test at the end of the loop but
right before the need_resched() test at the start of the loop.

So move preempt_fold_need_resched() out of the loop where we're
guaranteed to have TIF_NEED_RESCHED set.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/mwait.h |    2 +-
 include/linux/preempt.h      |   10 ++++++++++
 include/linux/sched.h        |   15 +++++++++++++++
 kernel/cpu/idle.c            |   14 +++++++-------
 kernel/sched/core.c          |    3 +--
 5 files changed, 34 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -50,7 +50,7 @@ static inline void mwait_idle_with_hints
 		if (!need_resched())
 			__mwait(eax, ecx);
 	}
-	__current_clr_polling();
+	current_clr_polling();
 }
 
 #endif /* _ASM_X86_MWAIT_H */
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -116,6 +116,16 @@ do { \
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
+#ifdef CONFIG_PREEMPT
+#define preempt_fold_need_resched() \
+do { \
+	if (tif_need_resched()) \
+		set_preempt_need_resched(); \
+} while (0)
+#else
+#define preempt_fold_need_resched() do { } while (0)
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 struct preempt_notifier;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2630,6 +2630,21 @@ static inline bool __must_check current_
 }
 #endif
 
+static inline void current_clr_polling(void)
+{
+	__current_clr_polling();
+
+	/*
+	 * Ensure we check TIF_NEED_RESCHED after we clear the polling bit.
+	 * Once the bit is cleared, we'll get IPIs with every new
+	 * TIF_NEED_RESCHED and the IPI handler, scheduler_ipi(), will also
+	 * fold.
+	 */
+	smp_mb(); /* paired with resched_task() */
+
+	preempt_fold_need_resched();
+}
+
 static __always_inline bool need_resched(void)
 {
 	return unlikely(tif_need_resched());
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -105,14 +105,14 @@ static void cpu_idle_loop(void)
 				__current_set_polling();
 			}
 			arch_cpu_idle_exit();
-			/*
-			 * We need to test and propagate the TIF_NEED_RESCHED
-			 * bit here because we might not have send the
-			 * reschedule IPI to idle tasks.
-			 */
-			if (tif_need_resched())
-				set_preempt_need_resched();
 		}
+
+		/*
+		 * We need to test and propagate the TIF_NEED_RESCHED bit here
+		 * because we might not have send the reschedule IPI to idle
+		 * tasks.
+		 */
+		preempt_fold_need_resched();
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
 	}
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1499,8 +1499,7 @@ void scheduler_ipi(void)
 	 * TIF_NEED_RESCHED remotely (for the first time) will also send
 	 * this IPI.
 	 */
-	if (tif_need_resched())
-		set_preempt_need_resched();
+	preempt_fold_need_resched();
 
 	if (llist_empty(&this_rq()->wake_list)
 			&& !tick_nohz_full_cpu(smp_processor_id())


