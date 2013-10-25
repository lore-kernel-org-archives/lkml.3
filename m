Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab3JYEyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 00:54:45 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:60042 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3JYEyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 00:54:43 -0400
MIME-Version: 1.0
Date: Thu, 24 Oct 2013 21:54:42 -0700
Message-ID: <CANXG-LJ699jUyw19pVnSdAtXdHof4u+YRnvK1A6O9MMrtu+X0Q@mail.gmail.com>
Subject: [Patch] arm/arm64: Thumb=>ARM signal handling setup skips the a few
 instructions on Snapdragon S4/Krait
From: "T.J. Purtell" <tj@mobisocial.us>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Rodrigo Kumpera <kumpera@xamarin.com>,
        Mark Probst <mark@xamarin.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Thumb instruction set include an If-Then instruction.  If an ARM
function is registered as a signal handler, and that signal is
delivered inside the block of instructions follow the IT instruction,
some of the instructions at the beginning of the signal handler are
skipped.  This occurs because the IT state bits of the Program Status
Register are not cleared by the kernel.

The ARM architecture reference specifies that the IT state bits in the
PSR must be all zeros in ARM mode or behavior is unspecified.  On the
Qualcomm Snapdragon S4/Krait architecture CPUs the processor continues
to consider the IT state bits while in ARM mode.  This makes it so
that some instructions are skipped by the CPU.

The relevant clipping of the ARM architecture  document is available
here: https://www.dropbox.com/s/6hpwey3kklw20c1/ITState-ARM-Architecture.pdf

This manifests itself in code that uses a lot of signal handling
concurrently with complicated logic code compiled for thumb when the
signal handler compiled as ARM code.  One example is the mono runtime.
 It uses a signal based mechanism to perform stop the world operation
needed by its garbage collector.  It is compiled for ARM and generates
ARM code, however, bionic (libc for android) is compiled for thumb.
During a test case involving native allocation in parallel with
garbage collection (signal handling), we found that the test case
would crash only when running on a Krait architecture CPU.  We found
the preceding instructions before the signal to always point to
something inside an IT sequence, in this case the logic in the dlfree
merging of free heap blocks.  After adding a sequence of NOPs to the
beginning of the signal handlers, the problem disappeared.  We applied
the attached patch to the kernel on one of the Krait devices and found
that it also alleviated the crashes.


The patch simply clears the IT State bits regardless of if the signal
handler is an ARM/Thumb function.  It also includes the same fix
applied to the arm64 compat handler.

-tj



diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index ab33042..782657a 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -375,12 +375,16 @@ setup_return(struct pt_regs *regs, struct ksignal *ksig,
  */
  thumb = handler & 1;

+#if __LINUX_ARM_ARCH__ >= 7
+ /*
+  * Clear the If-Then Thumb-2 execution state
+  * ARM spec requires this to be all 000s in ARM mode
+ */
+ cpsr &= ~PSR_IT_MASK;
+#endif
+
  if (thumb) {
  cpsr |= PSR_T_BIT;
-#if __LINUX_ARM_ARCH__ >= 7
- /* clear the If-Then Thumb-2 execution state */
- cpsr &= ~PSR_IT_MASK;
-#endif
  } else
  cpsr &= ~PSR_T_BIT;
  }
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index e393174..8f6c3be 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -474,9 +474,11 @@ static void compat_setup_return(struct pt_regs
*regs, struct k_sigaction *ka,
  /* Check if the handler is written for ARM or Thumb */
  thumb = handler & 1;

+ /* ARM spec requires this to be all 000s in ARM mode */
+ spsr &= ~COMPAT_PSR_IT_MASK;
+
  if (thumb) {
  spsr |= COMPAT_PSR_T_BIT;
- spsr &= ~COMPAT_PSR_IT_MASK;
  } else {
  spsr &= ~COMPAT_PSR_T_BIT;
  }
