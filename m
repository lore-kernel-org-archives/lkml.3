Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaHRJn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:43:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaHRJgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 110/137] x86, espfix: Make espfix64 a Kconfig option, fix UML
Date: Mon, 18 Aug 2014 10:32:51 +0100
Message-Id: <1408354398-10226-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/Kconfig          | 4 ++++
 arch/x86/kernel/Makefile  | 2 +-
 arch/x86/kernel/smpboot.c | 2 +-
 init/main.c               | 2 +-
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf92b0ce..ba5fdd09c61e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -967,6 +967,10 @@ config VM86
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
index b347fabda159..b714a3537683 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-y			+= syscall_$(BITS).o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
-obj-$(CONFIG_X86_64)	+= espfix_64.o
+obj-$(CONFIG_X86_ESPFIX64)	+= espfix_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a2475d0f3af0..af9296c6c9ed 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -267,7 +267,7 @@ static void notrace start_secondary(void *unused)
 	/*
 	 * Enable the espfix hack for this CPU
 	 */
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_ESPFIX64
 	init_espfix_ap();
 #endif
 
diff --git a/init/main.c b/init/main.c
index 1f93d4080aa8..e4c1b0173c87 100644
--- a/init/main.c
+++ b/init/main.c
@@ -608,7 +608,7 @@ asmlinkage void __init start_kernel(void)
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
 #endif
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_ESPFIX64
 	/* Should be run before the first non-init thread is created */
 	init_espfix_bsp();
 #endif
-- 
1.9.1

