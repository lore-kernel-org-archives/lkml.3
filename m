Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbaIKNQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:16:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51503 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Richard Weinberger" <richard@nod.at>,
        "Ingo Molnar" <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Thu, 11 Sep 2014 13:32:14 +0100
Message-ID: <lsq.1410438734.656065065@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 127/131] x86, espfix: Make espfix64 a Kconfig option,
 fix UML
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit 197725de65477bc8509b41388157c1a2283542bb upstream.

Make espfix64 a hidden Kconfig option.  This fixes the x86-64 UML
build which had broken due to the non-existence of init_espfix_bsp()
in UML: since UML uses its own Kconfig, this option does not appear in
the UML build.

This also makes it possible to make support for 16-bit segments a
configuration option, for the people who want to minimize the size of
the kernel.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/r/1398816946-3351-1-git-send-email-hpa@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/Kconfig          | 4 ++++
 arch/x86/kernel/Makefile  | 2 +-
 arch/x86/kernel/smpboot.c | 2 +-
 init/main.c               | 2 +-
 4 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -901,6 +901,10 @@ config VM86
 	  XFree86 to initialize some video cards via BIOS. Disabling this
 	  option saves about 6k.
 
+config X86_ESPFIX64
+	def_bool y
+	depends on X86_64
+
 config TOSHIBA
 	tristate "Toshiba Laptop support"
 	depends on X86_32
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_X86_32)	+= sys_i386_32.o i3
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
-obj-$(CONFIG_X86_64)	+= espfix_64.o
+obj-$(CONFIG_X86_ESPFIX64)	+= espfix_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -268,7 +268,7 @@ notrace static void __cpuinit start_seco
 	/*
 	 * Enable the espfix hack for this CPU
 	 */
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_ESPFIX64
 	init_espfix_ap();
 #endif
 
--- a/init/main.c
+++ b/init/main.c
@@ -610,7 +610,7 @@ asmlinkage void __init start_kernel(void
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
 #endif
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_ESPFIX64
 	/* Should be run before the first non-init thread is created */
 	init_espfix_bsp();
 #endif

