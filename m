Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaLSNNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:13:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:34234 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSNNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:13:47 -0500
Date: Fri, 19 Dec 2014 14:13:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86/mpx fixes for 3.19
Message-ID: <alpine.DEB.2.11.1412191411040.17382@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-mpx-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mpx-for-linus

Three updates for the new MPX infrastructure:
  - Use the proper error check in the trap handler
  - Add a proper config option for it
  - Bring documentation up to date

Thanks,

	tglx

------------------>
Dan Carpenter (1):
      x86_64/traps: Fix always true condition

Dave Hansen (2):
      x86, mpx: Update documentation
      x86, mpx: Give MPX a real config option prompt


 Documentation/x86/intel_mpx.txt | 18 ++++++++++++++----
 arch/x86/Kconfig                | 30 ++++++++++++++++++++++++++----
 arch/x86/kernel/traps.c         |  2 +-
 3 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/Documentation/x86/intel_mpx.txt b/Documentation/x86/intel_mpx.txt
index 4472ed2ad921..818518a3ff01 100644
--- a/Documentation/x86/intel_mpx.txt
+++ b/Documentation/x86/intel_mpx.txt
@@ -7,11 +7,15 @@ that can be used in conjunction with compiler changes to check memory
 references, for those references whose compile-time normal intentions are
 usurped at runtime due to buffer overflow or underflow.
 
+You can tell if your CPU supports MPX by looking in /proc/cpuinfo:
+
+	cat /proc/cpuinfo  | grep ' mpx '
+
 For more information, please refer to Intel(R) Architecture Instruction
 Set Extensions Programming Reference, Chapter 9: Intel(R) Memory Protection
 Extensions.
 
-Note: Currently no hardware with MPX ISA is available but it is always
+Note: As of December 2014, no hardware with MPX is available but it is
 possible to use SDE (Intel(R) Software Development Emulator) instead, which
 can be downloaded from
 http://software.intel.com/en-us/articles/intel-software-development-emulator
@@ -30,9 +34,15 @@ is how we expect the compiler, application and kernel to work together.
    instrumentation as well as some setup code called early after the app
    starts. New instruction prefixes are noops for old CPUs.
 2) That setup code allocates (virtual) space for the "bounds directory",
-   points the "bndcfgu" register to the directory and notifies the kernel
-   (via the new prctl(PR_MPX_ENABLE_MANAGEMENT)) that the app will be using
-   MPX.
+   points the "bndcfgu" register to the directory (must also set the valid
+   bit) and notifies the kernel (via the new prctl(PR_MPX_ENABLE_MANAGEMENT))
+   that the app will be using MPX.  The app must be careful not to access
+   the bounds tables between the time when it populates "bndcfgu" and
+   when it calls the prctl().  This might be hard to guarantee if the app
+   is compiled with MPX.  You can add "__attribute__((bnd_legacy))" to
+   the function to disable MPX instrumentation to help guarantee this.
+   Also be careful not to call out to any other code which might be
+   MPX-instrumented.
 3) The kernel detects that the CPU has MPX, allows the new prctl() to
    succeed, and notes the location of the bounds directory. Userspace is
    expected to keep the bounds directory at that locationWe note it
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 967dfe0ba85e..cc91e5e55d13 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -248,10 +248,6 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on INTEL_IOMMU && ACPI
 
-config X86_INTEL_MPX
-	def_bool y
-	depends on CPU_SUP_INTEL
-
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
@@ -1575,6 +1571,32 @@ config X86_SMAP
 
 	  If unsure, say Y.
 
+config X86_INTEL_MPX
+	prompt "Intel MPX (Memory Protection Extensions)"
+	def_bool n
+	depends on CPU_SUP_INTEL
+	---help---
+	  MPX provides hardware features that can be used in
+	  conjunction with compiler-instrumented code to check
+	  memory references.  It is designed to detect buffer
+	  overflow or underflow bugs.
+
+	  This option enables running applications which are
+	  instrumented or otherwise use MPX.  It does not use MPX
+	  itself inside the kernel or to protect the kernel
+	  against bad memory references.
+
+	  Enabling this option will make the kernel larger:
+	  ~8k of kernel text and 36 bytes of data on a 64-bit
+	  defconfig.  It adds a long to the 'mm_struct' which
+	  will increase the kernel memory overhead of each
+	  process and adds some branches to paths used during
+	  exec() and munmap().
+
+	  For details, see Documentation/x86/intel_mpx.txt
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 651d5d4f7558..f73fc4a22a4d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -323,7 +323,7 @@ dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
 		break; /* Success, it was handled */
 	case 1: /* Bound violation. */
 		info = mpx_generate_siginfo(regs, xsave_buf);
-		if (PTR_ERR(info)) {
+		if (IS_ERR(info)) {
 			/*
 			 * We failed to decode the MPX instruction.  Act as if
 			 * the exception was not caused by MPX.
