Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3AVHuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:50:00 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:49458 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3AVHt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:49:56 -0500
Message-ID: <50FE4497.3050306@synopsys.com>
Date: Tue, 22 Jan 2013 13:19:43 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 29/76] ARC: Boot #1: low-level, setup_arch(), /proc/cpuinfo,
 mem init
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-30-git-send-email-vgupta@synopsys.com> <201301181445.39050.arnd@arndb.de>
In-Reply-To: <201301181445.39050.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 08:15 PM, Arnd Bergmann wrote:
> On Friday 18 January 2013, Vineet Gupta wrote:
>> +       /* setup bootmem allocator */
>> +       bootmap_sz = init_bootmem_node(NODE_DATA(0),
>> +                                      first_free_pfn,/* bitmap start */
>> +                                      min_low_pfn,   /* First pg to track */
>> +                                      max_low_pfn);  /* Last pg to track */
>> +
>> +       /*
>> +        * init_bootmem above marks all tracked Page-frames as inuse "allocated"
>> +        * This includes pages occupied by kernel's elf segments.
>> +        * Beyond that, excluding bootmem bitmap itself, mark the rest of
>> +        * free-mem as "allocatable"
>> +        */
>> +       alloc_start = kernel_img_end + bootmap_sz;
>> +       free_bootmem(alloc_start, end_mem - alloc_start);
>> +
>> +       memset(zones_size, 0, sizeof(zones_size));
>> +       zones_size[ZONE_NORMAL] = num_physpages;
>> +
> IIRC, the bootmem allocator is no longer recommended for new architecture.
> You should use the "memblock" interface instead, as arm64 and tile do.
>
> I just saw that this is still listed as TODO for openrisc, sorry if I
> put you on the wrong track there by recommending to copy from openrisc.
>
> 	Arnd

How does the following look like. This is RFC only and I'll squash it into Boot #1
patch.

From: Vineet Gupta <vgupta@synopsys.com>
Date: Tue, 22 Jan 2013 13:03:50 +0530
Subject: [PATCH] RFC: Convert ARC port from bootmem to memblock

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig          |    2 ++
 arch/arc/kernel/devtree.c |    4 ++--
 arch/arc/mm/init.c        |   35 +++++++++--------------------------
 3 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index e8947c7..76ead56 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -29,11 +29,13 @@ config ARC
     select HAVE_IRQ_WORK
     select HAVE_KPROBES
     select HAVE_KRETPROBES
+    select HAVE_MEMBLOCK
     select HAVE_MOD_ARCH_SPECIFIC if ARC_DW2_UNWIND
     select HAVE_OPROFILE
     select HAVE_PERF_EVENTS
     select IRQ_DOMAIN
     select MODULES_USE_ELF_RELA
+    select NO_BOOTMEM
     select OF
     select OF_EARLY_FLATTREE
     select PERF_USE_VMALLOC
diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index 626fba14..051ec8b 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -14,7 +14,7 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/reboot.h>
-#include <linux/bootmem.h>
+#include <linux/memblock.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/of_irq.h>
@@ -26,7 +26,7 @@
 /* called from unflatten_device_tree() to bootstrap devicetree itself */
 void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
-    return alloc_bootmem_align(size, align);
+    return __va(memblock_alloc(size, align));
 }
 
 /**
diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index 8c173f9..80dbdc7 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/bootmem.h>
+#include <linux/memblock.h>
 #ifdef CONFIG_BLOCK_DEV_RAM
 #include <linux/blk.h>
 #endif
@@ -42,6 +43,7 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
     arc_mem_sz = size & PAGE_MASK;
     pr_info("Memory size set via devicetree %ldM\n", TO_MB(arc_mem_sz));
+    memblock_add(CONFIG_LINUX_LINK_BASE, arc_mem_sz);
 }
 
 /*
@@ -52,9 +54,6 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
  */
 void __init setup_arch_memory(void)
 {
-    int bootmap_sz;
-    unsigned int first_free_pfn;
-    unsigned long kernel_img_end, alloc_start;
     unsigned long zones_size[MAX_NR_ZONES] = { 0, 0 };
     unsigned long end_mem = CONFIG_LINUX_LINK_BASE + arc_mem_sz;
 
@@ -63,39 +62,23 @@ void __init setup_arch_memory(void)
     init_mm.end_data = (unsigned long)_edata;
     init_mm.brk = (unsigned long)_end;
 
-    /* _end needs to be page aligned */
-    kernel_img_end = (unsigned long)_end;
-    BUG_ON(kernel_img_end & ~PAGE_MASK);
+    /*------------- externs in mm need setting up ---------------*/
 
     /* first page of system - kernel .vector starts here */
     min_low_pfn = PFN_DOWN(CONFIG_LINUX_LINK_BASE);
 
-    /* First free page beyond kernel image */
-    first_free_pfn = PFN_DOWN(kernel_img_end);
-
-    /*
-     * Last usable page of low mem (no HIGHMEM yet for ARC port)
-     * -must be BASE + SIZE
-     */
+    /* Last usable page of low mem (no HIGHMEM yet for ARC port) */
     max_low_pfn = max_pfn = PFN_DOWN(end_mem);
 
     max_mapnr = num_physpages = max_low_pfn - min_low_pfn;
 
-    /* setup bootmem allocator */
-    bootmap_sz = init_bootmem_node(NODE_DATA(0),
-                       first_free_pfn,/* bitmap start */
-                       min_low_pfn,   /* First pg to track */
-                       max_low_pfn);  /* Last pg to track */
+    /*------------- reserve kernel image -----------------------*/
+    memblock_reserve(CONFIG_LINUX_LINK_BASE,
+             __pa(_end) - CONFIG_LINUX_LINK_BASE);
 
-    /*
-     * init_bootmem above marks all tracked Page-frames as inuse "allocated"
-     * This includes pages occupied by kernel's elf segments.
-     * Beyond that, excluding bootmem bitmap itself, mark the rest of
-     * free-mem as "allocatable"
-     */
-    alloc_start = kernel_img_end + bootmap_sz;
-    free_bootmem(alloc_start, end_mem - alloc_start);
+    memblock_dump_all();
 
+    /*-------------- node setup --------------------------------*/
     memset(zones_size, 0, sizeof(zones_size));
     zones_size[ZONE_NORMAL] = num_physpages;
 
-- 
1.7.4.1




