Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3LLJyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:54:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45838 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3LLJw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:52:26 -0500
Date: Thu, 12 Dec 2013 01:51:41 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ba1f14fbe70965ae0fb1655a5275a62723f65b77@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        agraf@suse.de, torvalds@linux-foundation.org, peterz@infradead.org,
        benh@kernel.crashing.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        agraf@suse.de, torvalds@linux-foundation.org, peterz@infradead.org,
        benh@kernel.crashing.org, tglx@linutronix.de
In-Reply-To: <20131128132641.GP10022@twins.programming.kicks-ass.net>
References: <20131128132641.GP10022@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Remove PREEMPT_NEED_RESCHED from generic code
Git-Commit-ID: ba1f14fbe70965ae0fb1655a5275a62723f65b77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 12 Dec 2013 01:51:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba1f14fbe70965ae0fb1655a5275a62723f65b77
Gitweb:     http://git.kernel.org/tip/ba1f14fbe70965ae0fb1655a5275a62723f65b77
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 28 Nov 2013 14:26:41 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 11 Dec 2013 15:52:32 +0100

sched: Remove PREEMPT_NEED_RESCHED from generic code

While hunting a preemption issue with Alexander, Ben noticed that the
currently generic PREEMPT_NEED_RESCHED stuff is horribly broken for
load-store architectures.

We currently rely on the IPI to fold TIF_NEED_RESCHED into
PREEMPT_NEED_RESCHED, but when this IPI lands while we already have
a load for the preempt-count but before the store, the store will erase
the PREEMPT_NEED_RESCHED change.

The current preempt-count only works on load-store archs because
interrupts are assumed to be completely balanced wrt their preempt_count
fiddling; the previous preempt_count load will match the preempt_count
state after the interrupt and therefore nothing gets lost.

This patch removes the PREEMPT_NEED_RESCHED usage from generic code and
pushes it into x86 arch code; the generic code goes back to relying on
TIF_NEED_RESCHED.

Boot tested on x86_64 and compile tested on ppc64.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reported-and-Tested-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131128132641.GP10022@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/preempt.h | 11 +++++++++++
 include/asm-generic/preempt.h  | 35 +++++++++++------------------------
 include/linux/sched.h          |  2 --
 3 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 8729723..c8b0519 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -8,6 +8,12 @@
 DECLARE_PER_CPU(int, __preempt_count);
 
 /*
+ * We use the PREEMPT_NEED_RESCHED bit as an inverted NEED_RESCHED such
+ * that a decrement hitting 0 means we can and should reschedule.
+ */
+#define PREEMPT_ENABLED	(0 + PREEMPT_NEED_RESCHED)
+
+/*
  * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
  * that think a non-zero value indicates we cannot preempt.
  */
@@ -74,6 +80,11 @@ static __always_inline void __preempt_count_sub(int val)
 	__this_cpu_add_4(__preempt_count, -val);
 }
 
+/*
+ * Because we keep PREEMPT_NEED_RESCHED set when we do _not_ need to reschedule
+ * a decrement which hits zero means we have no preempt_count and should
+ * reschedule.
+ */
 static __always_inline bool __preempt_count_dec_and_test(void)
 {
 	GEN_UNARY_RMWcc("decl", __preempt_count, __percpu_arg(0), "e");
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index ddf2b42..1cd3f5d 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -3,13 +3,11 @@
 
 #include <linux/thread_info.h>
 
-/*
- * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
- * that think a non-zero value indicates we cannot preempt.
- */
+#define PREEMPT_ENABLED	(0)
+
 static __always_inline int preempt_count(void)
 {
-	return current_thread_info()->preempt_count & ~PREEMPT_NEED_RESCHED;
+	return current_thread_info()->preempt_count;
 }
 
 static __always_inline int *preempt_count_ptr(void)
@@ -17,11 +15,6 @@ static __always_inline int *preempt_count_ptr(void)
 	return &current_thread_info()->preempt_count;
 }
 
-/*
- * We now loose PREEMPT_NEED_RESCHED and cause an extra reschedule; however the
- * alternative is loosing a reschedule. Better schedule too often -- also this
- * should be a very rare operation.
- */
 static __always_inline void preempt_count_set(int pc)
 {
 	*preempt_count_ptr() = pc;
@@ -41,28 +34,17 @@ static __always_inline void preempt_count_set(int pc)
 	task_thread_info(p)->preempt_count = PREEMPT_ENABLED; \
 } while (0)
 
-/*
- * We fold the NEED_RESCHED bit into the preempt count such that
- * preempt_enable() can decrement and test for needing to reschedule with a
- * single instruction.
- *
- * We invert the actual bit, so that when the decrement hits 0 we know we both
- * need to resched (the bit is cleared) and can resched (no preempt count).
- */
-
 static __always_inline void set_preempt_need_resched(void)
 {
-	*preempt_count_ptr() &= ~PREEMPT_NEED_RESCHED;
 }
 
 static __always_inline void clear_preempt_need_resched(void)
 {
-	*preempt_count_ptr() |= PREEMPT_NEED_RESCHED;
 }
 
 static __always_inline bool test_preempt_need_resched(void)
 {
-	return !(*preempt_count_ptr() & PREEMPT_NEED_RESCHED);
+	return false;
 }
 
 /*
@@ -81,7 +63,12 @@ static __always_inline void __preempt_count_sub(int val)
 
 static __always_inline bool __preempt_count_dec_and_test(void)
 {
-	return !--*preempt_count_ptr();
+	/*
+	 * Because of load-store architectures cannot do per-cpu atomic
+	 * operations; we cannot use PREEMPT_NEED_RESCHED because it might get
+	 * lost.
+	 */
+	return !--*preempt_count_ptr() && tif_need_resched();
 }
 
 /*
@@ -89,7 +76,7 @@ static __always_inline bool __preempt_count_dec_and_test(void)
  */
 static __always_inline bool should_resched(void)
 {
-	return unlikely(!*preempt_count_ptr());
+	return unlikely(!preempt_count() && tif_need_resched());
 }
 
 #ifdef CONFIG_PREEMPT
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 768b037..96d674b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -440,8 +440,6 @@ struct task_cputime {
 		.sum_exec_runtime = 0,				\
 	}
 
-#define PREEMPT_ENABLED		(PREEMPT_NEED_RESCHED)
-
 #ifdef CONFIG_PREEMPT_COUNT
 #define PREEMPT_DISABLED	(1 + PREEMPT_ENABLED)
 #else
