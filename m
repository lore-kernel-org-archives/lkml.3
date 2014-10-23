Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaJWWdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:33:09 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:54428 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaJWWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:33:06 -0400
X-Greylist: delayed 1350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2014 18:33:06 EDT
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Thu, 23 Oct 2014 23:10:13 +0100 (BST)
From: Ben Harris <bjh21@bjh21.me.uk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Don't allow stackprotector without TSC
Message-ID: <alpine.DEB.2.10.1410232227580.28125@snap.ds.cam.ac.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86, boot_init_stack_canary() unconditionally calls 
__native_read_tsc().  This means that when a kernel with 
CONFIG_CC_STACKPROTECTOR enabled is booted on a CPU without a TSC, the 
kernel hangs at startup.  See <https://bugs.debian.org/766105> for an 
example.

To avoid this, make HAVE_CC_STACKPROTECTOR dependent on X86_TSC, which is 
defined iff all supported processors have a TSC.  Setting the minimum 
processor type to one without TSC thus disables the stack protector, 
making the kernel bootable on such processors.

Signed-off-by: Ben Harris <bjh21@bjh21.me.uk>

---

This patch is against v3.18-rc1.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f2327e8..5acee0f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -129,7 +129,6 @@ config X86
  	select RTC_LIB
  	select HAVE_DEBUG_STACKOVERFLOW
  	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
-	select HAVE_CC_STACKPROTECTOR
  	select GENERIC_CPU_AUTOPROBE
  	select HAVE_ARCH_AUDITSYSCALL
  	select ARCH_SUPPORTS_ATOMIC_RMW
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 6983314..9626e47 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -360,6 +360,7 @@ config X86_P6_NOP
  config X86_TSC
  	def_bool y
  	depends on (MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MATOM) || X86_64
+	select HAVE_CC_STACKPROTECTOR

  config X86_CMPXCHG64
  	def_bool y

-- 
Ben Harris
