Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaLFSBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:01:13 -0500
Received: from 1wt.eu ([62.212.114.60]:40690 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaLFRyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:49 -0500
Message-Id: <20141206174148.808498059@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:41:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 09/25] x86, espfix: Make espfix64 a Kconfig option, fix UML
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
(cherry picked from 3.2 commit da22646d97b7322c757f3a7a21805a3475fed231)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/Kconfig          | 4 ++++
 arch/x86/kernel/Makefile  | 2 +-
 arch/x86/kernel/smpboot.c | 2 +-
 init/main.c               | 2 +-
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee0168d..026fe60 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -887,6 +887,10 @@ config VM86
 	  XFree86 to initialize some video cards via BIOS. Disabling this
 	  option saves about 6k.
 
+config X86_ESPFIX64
+	def_bool y
+	depends on X86_64
+
 config TOSHIBA
 	tristate "Toshiba Laptop support"
 	depends on X86_32
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f58fd89..945ad6f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -40,7 +40,7 @@ obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
-obj-$(CONFIG_X86_64)	+= espfix_64.o
+obj-$(CONFIG_X86_ESPFIX64)	+= espfix_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0854448..ca6b3f9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -328,7 +328,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	/*
 	 * Enable the espfix hack for this CPU
 	 */
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_ESPFIX64
 	init_espfix_ap();
 #endif
 
diff --git a/init/main.c b/init/main.c
index 0dfcc1a..00e6286 100644
--- a/init/main.c
+++ b/init/main.c
@@ -659,7 +659,7 @@ asmlinkage void __init start_kernel(void)
 	if (efi_enabled)
 		efi_enter_virtual_mode();
 #endif
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_ESPFIX64
 	/* Should be run before the first non-init thread is created */
 	init_espfix_bsp();
 #endif
-- 
1.7.12.2.21.g234cd45.dirty



