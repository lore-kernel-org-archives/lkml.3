Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbaJIVJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557AbaJIVJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nathan Lynch <nathan_lynch@mentor.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 097/163] ARM: 8148/1: flush TLS and thumbee register state during exec
Date: Thu,  9 Oct 2014 14:02:02 -0700
Message-Id: <1412888588-26755-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathan_lynch@mentor.com>

commit fbfb872f5f417cea48760c535e0ff027c88b507a upstream.

The TPIDRURO and TPIDRURW registers need to be flushed during exec;
otherwise TLS information is potentially leaked.  TPIDRURO in
particular needs careful treatment.  Since flush_thread basically
needs the same code used to set the TLS in arm_syscall, pull that into
a common set_tls helper in tls.h and use it in both places.

Similarly, TEEHBR needs to be cleared during exec as well.  Clearing
its save slot in thread_info isn't right as there is no guarantee
that a thread switch will occur before the new program runs.  Just
setting the register directly is sufficient.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/tls.h | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/process.c  |  2 ++
 arch/arm/kernel/thumbee.c  |  2 +-
 arch/arm/kernel/traps.c    | 17 +------------
 4 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 83259b8..36172ad 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -1,6 +1,9 @@
 #ifndef __ASMARM_TLS_H
 #define __ASMARM_TLS_H
 
+#include <linux/compiler.h>
+#include <asm/thread_info.h>
+
 #ifdef __ASSEMBLY__
 #include <asm/asm-offsets.h>
 	.macro switch_tls_none, base, tp, tpuser, tmp1, tmp2
@@ -50,6 +53,47 @@
 #endif
 
 #ifndef __ASSEMBLY__
+
+static inline void set_tls(unsigned long val)
+{
+	struct thread_info *thread;
+
+	thread = current_thread_info();
+
+	thread->tp_value[0] = val;
+
+	/*
+	 * This code runs with preemption enabled and therefore must
+	 * be reentrant with respect to switch_tls.
+	 *
+	 * We need to ensure ordering between the shadow state and the
+	 * hardware state, so that we don't corrupt the hardware state
+	 * with a stale shadow state during context switch.
+	 *
+	 * If we're preempted here, switch_tls will load TPIDRURO from
+	 * thread_info upon resuming execution and the following mcr
+	 * is merely redundant.
+	 */
+	barrier();
+
+	if (!tls_emu) {
+		if (has_tls_reg) {
+			asm("mcr p15, 0, %0, c13, c0, 3"
+			    : : "r" (val));
+		} else {
+			/*
+			 * User space must never try to access this
+			 * directly.  Expect your app to break
+			 * eventually if you do so.  The user helper
+			 * at 0xffff0fe0 must be used instead.  (see
+			 * entry-armv.S for details)
+			 */
+			*((unsigned int *)0xffff0ff0) = val;
+		}
+
+	}
+}
+
 static inline unsigned long get_tpuser(void)
 {
 	unsigned long reg = 0;
@@ -59,5 +103,23 @@ static inline unsigned long get_tpuser(void)
 
 	return reg;
 }
+
+static inline void set_tpuser(unsigned long val)
+{
+	/* Since TPIDRURW is fully context-switched (unlike TPIDRURO),
+	 * we need not update thread_info.
+	 */
+	if (has_tls_reg && !tls_emu) {
+		asm("mcr p15, 0, %0, c13, c0, 2"
+		    : : "r" (val));
+	}
+}
+
+static inline void flush_tls(void)
+{
+	set_tls(0);
+	set_tpuser(0);
+}
+
 #endif
 #endif	/* __ASMARM_TLS_H */
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92f7b15..5f6e650 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -334,6 +334,8 @@ void flush_thread(void)
 	memset(&tsk->thread.debug, 0, sizeof(struct debug_info));
 	memset(&thread->fpstate, 0, sizeof(union fp_state));
 
+	flush_tls();
+
 	thread_notify(THREAD_NOTIFY_FLUSH, thread);
 }
 
diff --git a/arch/arm/kernel/thumbee.c b/arch/arm/kernel/thumbee.c
index 7b8403b..80f0d69 100644
--- a/arch/arm/kernel/thumbee.c
+++ b/arch/arm/kernel/thumbee.c
@@ -45,7 +45,7 @@ static int thumbee_notifier(struct notifier_block *self, unsigned long cmd, void
 
 	switch (cmd) {
 	case THREAD_NOTIFY_FLUSH:
-		thread->thumbee_state = 0;
+		teehbr_write(0);
 		break;
 	case THREAD_NOTIFY_SWITCH:
 		current_thread_info()->thumbee_state = teehbr_read();
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 4636d56..318fc36 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -578,7 +578,6 @@ do_cache_op(unsigned long start, unsigned long end, int flags)
 #define NR(x) ((__ARM_NR_##x) - __ARM_NR_BASE)
 asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 {
-	struct thread_info *thread = current_thread_info();
 	siginfo_t info;
 
 	if ((no >> 16) != (__ARM_NR_BASE>> 16))
@@ -629,21 +628,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 		return regs->ARM_r0;
 
 	case NR(set_tls):
-		thread->tp_value[0] = regs->ARM_r0;
-		if (tls_emu)
-			return 0;
-		if (has_tls_reg) {
-			asm ("mcr p15, 0, %0, c13, c0, 3"
-				: : "r" (regs->ARM_r0));
-		} else {
-			/*
-			 * User space must never try to access this directly.
-			 * Expect your app to break eventually if you do so.
-			 * The user helper at 0xffff0fe0 must be used instead.
-			 * (see entry-armv.S for details)
-			 */
-			*((unsigned int *)0xffff0ff0) = regs->ARM_r0;
-		}
+		set_tls(regs->ARM_r0);
 		return 0;
 
 #ifdef CONFIG_NEEDS_SYSCALL_FOR_CMPXCHG
-- 
1.9.1

