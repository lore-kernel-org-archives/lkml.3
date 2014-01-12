Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaALSoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:44:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46331 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaALSoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:44:32 -0500
Date: Sun, 12 Jan 2014 10:43:59 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-x9jgh45oeayzajz2mjt0y7d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/idle] sched/preempt:
  Fix up missed PREEMPT_NEED_RESCHED folding
Git-Commit-ID: eb797bf5bba817f2178e6126fb01efee27192a2d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:44:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb797bf5bba817f2178e6126fb01efee27192a2d
Gitweb:     http://git.kernel.org/tip/eb797bf5bba817f2178e6126fb01efee27192a2d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 20 Nov 2013 12:22:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:48:23 +0100

sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding

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

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-x9jgh45oeayzajz2mjt0y7d6@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/mwait.h |  2 +-
 include/linux/preempt.h      | 15 +++++++++++++++
 include/linux/sched.h        | 15 +++++++++++++++
 kernel/cpu/idle.c            | 17 ++++++++++-------
 kernel/sched/core.c          |  3 +--
 5 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 19b71c4..1da25a5 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -53,7 +53,7 @@ static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 		if (!need_resched())
 			__mwait(eax, ecx);
 	}
-	__current_clr_polling();
+	current_clr_polling();
 }
 
 #endif /* _ASM_X86_MWAIT_H */
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index a3d9dc8..ef4e80c 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -116,6 +116,21 @@ do { \
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
+#ifdef CONFIG_PREEMPT
+#define preempt_set_need_resched() \
+do { \
+	set_preempt_need_resched(); \
+} while (0)
+#define preempt_fold_need_resched() \
+do { \
+	if (tif_need_resched()) \
+		set_preempt_need_resched(); \
+} while (0)
+#else
+#define preempt_set_need_resched() do { } while (0)
+#define preempt_fold_need_resched() do { } while (0)
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 struct preempt_notifier;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53f97eb..6340654 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2627,6 +2627,21 @@ static inline bool __must_check current_clr_polling_and_test(void)
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
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 988573a..277f494 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -105,14 +105,17 @@ static void cpu_idle_loop(void)
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
+		 * Since we fell out of the loop above, we know
+		 * TIF_NEED_RESCHED must be set, propagate it into
+		 * PREEMPT_NEED_RESCHED.
+		 *
+		 * This is required because for polling idle loops we will
+		 * not have had an IPI to fold the state for us.
+		 */
+		preempt_set_need_resched();
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
 	}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a4..98a7a1c 100644
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
