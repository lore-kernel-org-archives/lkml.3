Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbaIOWSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:18:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51131 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbaIOWSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:18:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 042/187] x86, espfix: Make espfix64 a Kconfig option, fix UML
Date: Mon, 15 Sep 2014 15:07:32 -0700
Message-Id: <1410818997-9432-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/Kconfig          | 4 ++++
 arch/x86/kernel/Makefile  | 2 +-
 arch/x86/kernel/smpboot.c | 2 +-
 init/main.c               | 2 +-
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9562fc3..ea1c3af 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -983,6 +983,10 @@ config VM86
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
index 92450ee..eb1d03b 100644
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
index b5c176a..a965665 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -245,7 +245,7 @@ static void notrace start_secondary(void *unused)
 	/*
 	 * Enable the espfix hack for this CPU
 	 */
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_ESPFIX64
 	init_espfix_ap();
 #endif
 
diff --git a/init/main.c b/init/main.c
index da5d829..aca4f33 100644
--- a/init/main.c
+++ b/init/main.c
@@ -619,7 +619,7 @@ asmlinkage void __init start_kernel(void)
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

