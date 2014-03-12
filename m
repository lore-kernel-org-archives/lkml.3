Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaCLWwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:52:55 -0400
Received: from www84.your-server.de ([213.133.104.84]:55110 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaCLWwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:52:01 -0400
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 2/3] x86, vdso32: remove vsyscall_32.c
Date: Wed, 12 Mar 2014 23:51:19 +0100
Message-Id: <1394664680-17799-3-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394664680-17799-1-git-send-email-stefani@seibold.net>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vsyscall_32.c has not much code in it and the only function map_vsyscall()
was invoked prior to vdso_setup() which results in wrong conditional
mapping of VVAR_PAGE.

Moving the whole fixmap initialization into map_compat_vdso() will
solve this calling dependences.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/kernel/Makefile      |  1 -
 arch/x86/kernel/hpet.c        |  6 ------
 arch/x86/kernel/setup.c       |  2 ++
 arch/x86/kernel/vsyscall_32.c | 24 ------------------------
 arch/x86/vdso/vdso32-setup.c  |  5 +++++
 5 files changed, 7 insertions(+), 31 deletions(-)
 delete mode 100644 arch/x86/kernel/vsyscall_32.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3282eda..f4d9600 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -27,7 +27,6 @@ obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-y			+= syscall_$(BITS).o vsyscall_gtod.o
-obj-$(CONFIG_X86_32)	+= vsyscall_32.o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-$(CONFIG_SYSFS)	+= ksysfs.o
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index b99544b..1129f79 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -12,7 +12,6 @@
 #include <linux/pm.h>
 #include <linux/io.h>
 
-#include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
 #include <asm/elf.h>
@@ -75,11 +74,6 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-#ifdef CONFIG_X86_32
-	if (vdso_enabled != VDSO_COMPAT)
-		return;
-#endif
-	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
 }
 
 static inline void hpet_clear_mapping(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 56ff330..ebf1c00 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1182,7 +1182,9 @@ void __init setup_arch(char **cmdline_p)
 
 	tboot_probe();
 
+#ifndef CONFIG_X86_32
 	map_vsyscall();
+#endif
 
 	generic_apic_probe();
 
diff --git a/arch/x86/kernel/vsyscall_32.c b/arch/x86/kernel/vsyscall_32.c
deleted file mode 100644
index 0cbf94b..0000000
--- a/arch/x86/kernel/vsyscall_32.c
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
- *  Copyright 2003 Andi Kleen, SuSE Labs.
- *
- *  Modified for x86 32 bit arch by Stefani Seibold <stefani@seibold.net>
- *
- *  Thanks to hpa@transmeta.com for some useful hint.
- *  Special thanks to Ingo Molnar for his early experience with
- *  a different vsyscall implementation for Linux/IA32 and for the name.
- *
- */
-
-#include <asm/vsyscall.h>
-#include <asm/pgtable.h>
-#include <asm/fixmap.h>
-#include <asm/elf.h>
-
-void __init map_vsyscall(void)
-{
-	if (vdso_enabled != VDSO_COMPAT)
-		return;
-
-	__set_fixmap(VVAR_PAGE, __pa_symbol(&__vvar_page), PAGE_KERNEL_VVAR);
-}
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index b37aa1d..1a9f8c3 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -262,6 +262,11 @@ static void map_compat_vdso(int map)
 
 	vdso_mapped = map;
 
+	if (hpet_address)
+		__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
+
+	__set_fixmap(VVAR_PAGE, __pa_symbol(&__vvar_page), PAGE_KERNEL_VVAR);
+
 	__set_fixmap(FIX_VDSO, page_to_pfn(vdso32_pages[0]) << PAGE_SHIFT,
 		     map ? PAGE_READONLY_EXEC : PAGE_NONE);
 
-- 
1.9.0

