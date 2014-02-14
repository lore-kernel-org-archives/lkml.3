Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBNIaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:30:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaBNIa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:30:28 -0500
Date: Fri, 14 Feb 2014 00:29:17 -0800
Message-Id: <201402140829.s1E8THo9031714@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.14-rc3
Cc: <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Jakub Jelinek <jakub@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Richard Henderson <rth@twiddle.net>,
        Steven Noonan <steven@uplinklabs.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 14 Feb 2014 00:29:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A collection of small fixes:

1. There still seem to be problems with asm goto which requires the
   empty asm hack.
2. If SMAP is disabled at compile time, don't enable it nor try to
   interpret a page fault as an SMAP violation.
3. Fix a case of unbounded recursion while tracing.

The following changes since commit 494479038d97f1b9f76fc633a360a681acdf035c:

  Merge tag 'pinctrl-v3.14-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl (2014-02-08 14:31:39 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 4640c7ee9b8953237d05a61ea3ea93981d1bc961:

  x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off (2014-02-13 08:40:52 -0800)

----------------------------------------------------------------
H. Peter Anvin (2):
      x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
      x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off

Steven Noonan (1):
      compiler/gcc4: Make quirk for asm_volatile_goto() unconditional

Steven Rostedt (1):
      x86: Use preempt_disable_notrace() in cycles_2_ns()

 arch/x86/kernel/cpu/common.c  |  7 ++++++-
 arch/x86/kernel/tsc.c         |  4 ++--
 arch/x86/mm/fault.c           | 14 +++++++++-----
 include/linux/compiler-gcc4.h |  6 +-----
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 24b6fd10625a..8e28bf2fc3ef 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -284,8 +284,13 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 	raw_local_save_flags(eflags);
 	BUG_ON(eflags & X86_EFLAGS_AC);
 
-	if (cpu_has(c, X86_FEATURE_SMAP))
+	if (cpu_has(c, X86_FEATURE_SMAP)) {
+#ifdef CONFIG_X86_SMAP
 		set_in_cr4(X86_CR4_SMAP);
+#else
+		clear_in_cr4(X86_CR4_SMAP);
+#endif
+	}
 }
 
 /*
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 19e5adb49a27..acb3b606613e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -209,7 +209,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 	 * dance when its actually needed.
 	 */
 
-	preempt_disable();
+	preempt_disable_notrace();
 	data = this_cpu_read(cyc2ns.head);
 	tail = this_cpu_read(cyc2ns.tail);
 
@@ -229,7 +229,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 		if (!--data->__count)
 			this_cpu_write(cyc2ns.tail, data);
 	}
-	preempt_enable();
+	preempt_enable_notrace();
 
 	return ns;
 }
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9d591c895803..6dea040cc3a1 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1001,6 +1001,12 @@ static int fault_in_kernel_space(unsigned long address)
 
 static inline bool smap_violation(int error_code, struct pt_regs *regs)
 {
+	if (!IS_ENABLED(CONFIG_X86_SMAP))
+		return false;
+
+	if (!static_cpu_has(X86_FEATURE_SMAP))
+		return false;
+
 	if (error_code & PF_USER)
 		return false;
 
@@ -1087,11 +1093,9 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
 
-	if (static_cpu_has(X86_FEATURE_SMAP)) {
-		if (unlikely(smap_violation(error_code, regs))) {
-			bad_area_nosemaphore(regs, error_code, address);
-			return;
-		}
+	if (unlikely(smap_violation(error_code, regs))) {
+		bad_area_nosemaphore(regs, error_code, address);
+		return;
 	}
 
 	/*
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index ded429966c1f..2507fd2a1eb4 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -75,11 +75,7 @@
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
-#if GCC_VERSION <= 40801
-# define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
-#else
-# define asm_volatile_goto(x...)	do { asm goto(x); } while (0)
-#endif
+#define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
 #if GCC_VERSION >= 40400
