Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356Ab3JPMcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:32:04 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:42131 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271Ab3JPMb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:31:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 09/16] m68k/UAPI: Move generic definitions to <asm/bootinfo.h>
Date: Wed, 16 Oct 2013 14:31:26 +0200
Message-Id: <1381926693-6392-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move generic definitions used by bootstraps to uapi/asm/bootinfo.h:
  - Machine types,
  - CPU, FPU, and MMU types,
  - struct mem_info.

Keep a copy of struct mem_info for in-kernel use, and rename it to struct
m68k_mem_info, as the exported one will be modified later.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/m68k/include/asm/setup.h         |    5 +-
 arch/m68k/include/uapi/asm/bootinfo.h |   80 +++++++++++++++++++++++++++++-
 arch/m68k/include/uapi/asm/setup.h    |   87 ---------------------------------
 arch/m68k/kernel/setup_mm.c           |    4 +-
 arch/m68k/mm/init.c                   |    2 +-
 arch/m68k/mm/motorola.c               |    2 +-
 6 files changed, 85 insertions(+), 95 deletions(-)

diff --git a/arch/m68k/include/asm/setup.h b/arch/m68k/include/asm/setup.h
index 65e78a2dad64..8f2023f8c1c4 100644
--- a/arch/m68k/include/asm/setup.h
+++ b/arch/m68k/include/asm/setup.h
@@ -22,6 +22,7 @@
 #ifndef _M68K_SETUP_H
 #define _M68K_SETUP_H
 
+#include <uapi/asm/bootinfo.h>
 #include <uapi/asm/setup.h>
 
 
@@ -297,14 +298,14 @@ extern int m68k_is040or060;
 #define NUM_MEMINFO	4
 
 #ifndef __ASSEMBLY__
-struct mem_info {
+struct m68k_mem_info {
 	unsigned long addr;		/* physical address of memory chunk */
 	unsigned long size;		/* length of memory chunk (in bytes) */
 };
 
 extern int m68k_num_memory;		/* # of memory blocks found (and used) */
 extern int m68k_realnum_memory;		/* real # of memory blocks found */
-extern struct mem_info m68k_memory[NUM_MEMINFO];/* memory description */
+extern struct m68k_mem_info m68k_memory[NUM_MEMINFO];/* memory description */
 #endif
 
 #endif /* _M68K_SETUP_H */
diff --git a/arch/m68k/include/uapi/asm/bootinfo.h b/arch/m68k/include/uapi/asm/bootinfo.h
index 74a6fae2a5bf..9d64599d7bf5 100644
--- a/arch/m68k/include/uapi/asm/bootinfo.h
+++ b/arch/m68k/include/uapi/asm/bootinfo.h
@@ -11,8 +11,6 @@
 #ifndef _UAPI_ASM_M68K_BOOTINFO_H
 #define _UAPI_ASM_M68K_BOOTINFO_H
 
-#include <linux/types.h>
-
 
 #ifndef __ASSEMBLY__
 
@@ -35,6 +33,12 @@ struct bi_record {
 	unsigned long data[0];		/* data */
 };
 
+
+struct mem_info {
+	unsigned long addr;		/* physical address of memory chunk */
+	unsigned long size;		/* length of memory chunk (in bytes) */
+};
+
 #endif /* __ASSEMBLY__ */
 
 
@@ -59,6 +63,78 @@ struct bi_record {
 
 
     /*
+     *  Linux/m68k Architectures (BI_MACHTYPE)
+     */
+
+#define MACH_AMIGA		1
+#define MACH_ATARI		2
+#define MACH_MAC		3
+#define MACH_APOLLO		4
+#define MACH_SUN3		5
+#define MACH_MVME147		6
+#define MACH_MVME16x		7
+#define MACH_BVME6000		8
+#define MACH_HP300		9
+#define MACH_Q40		10
+#define MACH_SUN3X		11
+#define MACH_M54XX		12
+
+
+    /*
+     *  CPU, FPU and MMU types (BI_CPUTYPE, BI_FPUTYPE, BI_MMUTYPE)
+     *
+     *  Note: we may rely on the following equalities:
+     *
+     *      CPU_68020 == MMU_68851
+     *      CPU_68030 == MMU_68030
+     *      CPU_68040 == FPU_68040 == MMU_68040
+     *      CPU_68060 == FPU_68060 == MMU_68060
+     */
+
+#define CPUB_68020		0
+#define CPUB_68030		1
+#define CPUB_68040		2
+#define CPUB_68060		3
+#define CPUB_COLDFIRE		4
+
+#define CPU_68020		(1 << CPUB_68020)
+#define CPU_68030		(1 << CPUB_68030)
+#define CPU_68040		(1 << CPUB_68040)
+#define CPU_68060		(1 << CPUB_68060)
+#define CPU_COLDFIRE		(1 << CPUB_COLDFIRE)
+
+#define FPUB_68881		0
+#define FPUB_68882		1
+#define FPUB_68040		2	/* Internal FPU */
+#define FPUB_68060		3	/* Internal FPU */
+#define FPUB_SUNFPA		4	/* Sun-3 FPA */
+#define FPUB_COLDFIRE		5	/* ColdFire FPU */
+
+#define FPU_68881		(1 << FPUB_68881)
+#define FPU_68882		(1 << FPUB_68882)
+#define FPU_68040		(1 << FPUB_68040)
+#define FPU_68060		(1 << FPUB_68060)
+#define FPU_SUNFPA		(1 << FPUB_SUNFPA)
+#define FPU_COLDFIRE		(1 << FPUB_COLDFIRE)
+
+#define MMUB_68851		0
+#define MMUB_68030		1	/* Internal MMU */
+#define MMUB_68040		2	/* Internal MMU */
+#define MMUB_68060		3	/* Internal MMU */
+#define MMUB_APOLLO		4	/* Custom Apollo */
+#define MMUB_SUN3		5	/* Custom Sun-3 */
+#define MMUB_COLDFIRE		6	/* Internal MMU */
+
+#define MMU_68851		(1 << MMUB_68851)
+#define MMU_68030		(1 << MMUB_68030)
+#define MMU_68040		(1 << MMUB_68040)
+#define MMU_68060		(1 << MMUB_68060)
+#define MMU_SUN3		(1 << MMUB_SUN3)
+#define MMU_APOLLO		(1 << MMUB_APOLLO)
+#define MMU_COLDFIRE		(1 << MMUB_COLDFIRE)
+
+
+    /*
      * Stuff for bootinfo interface versioning
      *
      * At the start of kernel code, a 'struct bootversion' is located.
diff --git a/arch/m68k/include/uapi/asm/setup.h b/arch/m68k/include/uapi/asm/setup.h
index 85579bff455c..6a6dc636761e 100644
--- a/arch/m68k/include/uapi/asm/setup.h
+++ b/arch/m68k/include/uapi/asm/setup.h
@@ -6,98 +6,11 @@
 ** This file is subject to the terms and conditions of the GNU General Public
 ** License.  See the file COPYING in the main directory of this archive
 ** for more details.
-**
-** Created 09/29/92 by Greg Harp
-**
-** 5/2/94 Roman Hodek:
-**   Added bi_atari part of the machine dependent union bi_un; for now it
-**   contains just a model field to distinguish between TT and Falcon.
-** 26/7/96 Roman Zippel:
-**   Renamed to setup.h; added some useful macros to allow gcc some
-**   optimizations if possible.
-** 5/10/96 Geert Uytterhoeven:
-**   Redesign of the boot information structure; moved boot information
-**   structure to bootinfo.h
 */
 
 #ifndef _UAPI_M68K_SETUP_H
 #define _UAPI_M68K_SETUP_H
 
-
-
-    /*
-     *  Linux/m68k Architectures
-     */
-
-#define MACH_AMIGA    1
-#define MACH_ATARI    2
-#define MACH_MAC      3
-#define MACH_APOLLO   4
-#define MACH_SUN3     5
-#define MACH_MVME147  6
-#define MACH_MVME16x  7
-#define MACH_BVME6000 8
-#define MACH_HP300    9
-#define MACH_Q40     10
-#define MACH_SUN3X   11
-#define MACH_M54XX   12
-
 #define COMMAND_LINE_SIZE 256
 
-
-
-    /*
-     *  CPU, FPU and MMU types
-     *
-     *  Note: we may rely on the following equalities:
-     *
-     *      CPU_68020 == MMU_68851
-     *      CPU_68030 == MMU_68030
-     *      CPU_68040 == FPU_68040 == MMU_68040
-     *      CPU_68060 == FPU_68060 == MMU_68060
-     */
-
-#define CPUB_68020     0
-#define CPUB_68030     1
-#define CPUB_68040     2
-#define CPUB_68060     3
-#define CPUB_COLDFIRE  4
-
-#define CPU_68020      (1<<CPUB_68020)
-#define CPU_68030      (1<<CPUB_68030)
-#define CPU_68040      (1<<CPUB_68040)
-#define CPU_68060      (1<<CPUB_68060)
-#define CPU_COLDFIRE   (1<<CPUB_COLDFIRE)
-
-#define FPUB_68881     0
-#define FPUB_68882     1
-#define FPUB_68040     2                       /* Internal FPU */
-#define FPUB_68060     3                       /* Internal FPU */
-#define FPUB_SUNFPA    4                       /* Sun-3 FPA */
-#define FPUB_COLDFIRE  5                       /* ColdFire FPU */
-
-#define FPU_68881      (1<<FPUB_68881)
-#define FPU_68882      (1<<FPUB_68882)
-#define FPU_68040      (1<<FPUB_68040)
-#define FPU_68060      (1<<FPUB_68060)
-#define FPU_SUNFPA     (1<<FPUB_SUNFPA)
-#define FPU_COLDFIRE   (1<<FPUB_COLDFIRE)
-
-#define MMUB_68851     0
-#define MMUB_68030     1                       /* Internal MMU */
-#define MMUB_68040     2                       /* Internal MMU */
-#define MMUB_68060     3                       /* Internal MMU */
-#define MMUB_APOLLO    4                       /* Custom Apollo */
-#define MMUB_SUN3      5                       /* Custom Sun-3 */
-#define MMUB_COLDFIRE  6                       /* Internal MMU */
-
-#define MMU_68851      (1<<MMUB_68851)
-#define MMU_68030      (1<<MMUB_68030)
-#define MMU_68040      (1<<MMUB_68040)
-#define MMU_68060      (1<<MMUB_68060)
-#define MMU_SUN3       (1<<MMUB_SUN3)
-#define MMU_APOLLO     (1<<MMUB_APOLLO)
-#define MMU_COLDFIRE   (1<<MMUB_COLDFIRE)
-
-
 #endif /* _UAPI_M68K_SETUP_H */
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index b979a3781dcb..d3f3fe6374c6 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -71,10 +71,10 @@ EXPORT_SYMBOL(m68k_num_memory);
 int m68k_realnum_memory;
 EXPORT_SYMBOL(m68k_realnum_memory);
 unsigned long m68k_memoffset;
-struct mem_info m68k_memory[NUM_MEMINFO];
+struct m68k_mem_info m68k_memory[NUM_MEMINFO];
 EXPORT_SYMBOL(m68k_memory);
 
-static struct mem_info m68k_ramdisk __initdata;
+static struct m68k_mem_info m68k_ramdisk __initdata;
 
 static char m68k_command_line[CL_SIZE] __initdata;
 
diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 6b4baa6e4d31..acaff6a49e35 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -59,7 +59,7 @@ EXPORT_SYMBOL(pg_data_table);
 void __init m68k_setup_node(int node)
 {
 #ifndef CONFIG_SINGLE_MEMORY_CHUNK
-	struct mem_info *info = m68k_memory + node;
+	struct m68k_mem_info *info = m68k_memory + node;
 	int i, end;
 
 	i = (unsigned long)phys_to_virt(info->addr) >> __virt_to_node_shift();
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 251c5437787b..7d4024432163 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -233,7 +233,7 @@ void __init paging_init(void)
 			printk("Fix your bootloader or use a memfile to make use of this area!\n");
 			m68k_num_memory--;
 			memmove(m68k_memory + i, m68k_memory + i + 1,
-				(m68k_num_memory - i) * sizeof(struct mem_info));
+				(m68k_num_memory - i) * sizeof(struct m68k_mem_info));
 			continue;
 		}
 		addr = m68k_memory[i].addr + m68k_memory[i].size;
-- 
1.7.9.5

