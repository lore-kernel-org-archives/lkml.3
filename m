Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3KLT5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:57:03 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:44134 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3KLT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:56:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>, Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] openrisc: Use the declarations provided by <asm/sections.h>
Date: Tue, 12 Nov 2013 20:56:20 +0100
Message-Id: <1384286181-16137-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Openrisc's private vmlinux.h duplicates a few definitions that are already
provided by asm-generic/sections.h. The former is used by setup.c only,
while the latter is already used everywhere else.

Convert setup.c to use the generic version:
  - Include <asm/sections.h>,
  - Remove the (slightly different) extern declarations,
  - Remove the no longer needed address-of ('&') operators.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/openrisc/kernel/setup.c   |   11 ++++++-----
 arch/openrisc/kernel/vmlinux.h |    1 -
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index ecc1c8850a11..c9b880d64bb8 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -40,6 +40,7 @@
 #include <linux/device.h>
 #include <linux/of_platform.h>
 
+#include <asm/sections.h>
 #include <asm/segment.h>
 #include <asm/pgtable.h>
 #include <asm/types.h>
@@ -75,7 +76,7 @@ static unsigned long __init setup_memory(void)
 
 	ram_start_pfn = PFN_UP(memory_start);
 	/* free_ram_start_pfn is first page after kernel */
-	free_ram_start_pfn = PFN_UP(__pa(&_end));
+	free_ram_start_pfn = PFN_UP(__pa(_end));
 	ram_end_pfn = PFN_DOWN(memblock_end_of_DRAM());
 
 	max_pfn = ram_end_pfn;
@@ -288,10 +289,10 @@ void __init setup_arch(char **cmdline_p)
 	setup_cpuinfo();
 
 	/* process 1's initial memory region is the kernel code/data */
-	init_mm.start_code = (unsigned long)&_stext;
-	init_mm.end_code = (unsigned long)&_etext;
-	init_mm.end_data = (unsigned long)&_edata;
-	init_mm.brk = (unsigned long)&_end;
+	init_mm.start_code = (unsigned long)_stext;
+	init_mm.end_code = (unsigned long)_etext;
+	init_mm.end_data = (unsigned long)_edata;
+	init_mm.brk = (unsigned long)_end;
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	initrd_start = (unsigned long)&__initrd_start;
diff --git a/arch/openrisc/kernel/vmlinux.h b/arch/openrisc/kernel/vmlinux.h
index 653728abcc7c..6c0b24772f85 100644
--- a/arch/openrisc/kernel/vmlinux.h
+++ b/arch/openrisc/kernel/vmlinux.h
@@ -1,7 +1,6 @@
 #ifndef __OPENRISC_VMLINUX_H_
 #define __OPENRISC_VMLINUX_H_
 
-extern char _stext, _etext, _edata, _end;
 #ifdef CONFIG_BLK_DEV_INITRD
 extern char __initrd_start, __initrd_end;
 extern char __initramfs_start;
-- 
1.7.9.5

