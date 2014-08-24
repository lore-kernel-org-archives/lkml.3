Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaHXO43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:56:29 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63104 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaHXO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:56:25 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/2] x86: use memblock_alloc_range() or memblock_alloc_base()
Date: Sun, 24 Aug 2014 23:56:02 +0900
Message-Id: <1408892163-8073-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace memblock_find_in_range() and memblock_reserve() with
memblock_alloc_range() or memblock_alloc_base().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-mm@kvack.org
---
 arch/x86/kernel/aperture_64.c |  6 +++---
 arch/x86/kernel/setup.c       | 22 ++++++++++------------
 arch/x86/mm/init.c            |  7 +++----
 arch/x86/mm/numa.c            |  4 +---
 arch/x86/mm/numa_emulation.c  |  5 ++---
 arch/x86/realmode/init.c      |  3 +--
 6 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 76164e1..baaa7c9 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -74,14 +74,14 @@ static u32 __init allocate_aperture(void)
 	 * memory. Unfortunately we cannot move it up because that would
 	 * make the IOMMU useless.
 	 */
-	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
-				      aper_size, aper_size);
+	addr = memblock_alloc_range(aper_size, aper_size,
+				    GART_MIN_ADDR, GART_MAX_ADDR);
+
 	if (!addr) {
 		pr_err("Cannot allocate aperture memory hole [mem %#010lx-%#010lx] (%uKB)\n",
 		       addr, addr + aper_size - 1, aper_size >> 10);
 		return 0;
 	}
-	memblock_reserve(addr, aper_size);
 	pr_info("Mapping aperture over RAM [mem %#010lx-%#010lx] (%uKB)\n",
 		addr, addr + aper_size - 1, aper_size >> 10);
 	register_nosave_region(addr >> PAGE_SHIFT,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d..fa609c9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -327,8 +327,8 @@ static void __init relocate_initrd(void)
 	char *p, *q;
 
 	/* We need to move the initrd down into directly mapped mem */
-	relocated_ramdisk = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
-						   area_size, PAGE_SIZE);
+	relocated_ramdisk = memblock_alloc_base(area_size, PAGE_SIZE,
+						PFN_PHYS(max_pfn_mapped));
 
 	if (!relocated_ramdisk)
 		panic("Cannot find place for new RAMDISK of size %lld\n",
@@ -336,7 +336,6 @@ static void __init relocate_initrd(void)
 
 	/* Note: this includes all the mem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	memblock_reserve(relocated_ramdisk, area_size);
 	initrd_start = relocated_ramdisk + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
@@ -545,8 +544,8 @@ static void __init reserve_crashkernel_low(void)
 			return;
 	}
 
-	low_base = memblock_find_in_range(low_size, (1ULL<<32),
-					low_size, alignment);
+	low_base = memblock_alloc_range(low_size, alignment,
+					low_size, 1ULL << 32);
 
 	if (!low_base) {
 		if (!auto_set)
@@ -555,7 +554,6 @@ static void __init reserve_crashkernel_low(void)
 		return;
 	}
 
-	memblock_reserve(low_base, low_size);
 	pr_info("Reserving %ldMB of low memory at %ldMB for crashkernel (System low RAM: %ldMB)\n",
 			(unsigned long)(low_size >> 20),
 			(unsigned long)(low_base >> 20),
@@ -593,10 +591,10 @@ static void __init reserve_crashkernel(void)
 		/*
 		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
-		crash_base = memblock_find_in_range(alignment,
+		crash_base = memblock_alloc_range(crash_size, alignment,
+					alignment,
 					high ? CRASH_KERNEL_ADDR_HIGH_MAX :
-					       CRASH_KERNEL_ADDR_LOW_MAX,
-					crash_size, alignment);
+					       CRASH_KERNEL_ADDR_LOW_MAX);
 
 		if (!crash_base) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
@@ -606,14 +604,14 @@ static void __init reserve_crashkernel(void)
 	} else {
 		unsigned long long start;
 
-		start = memblock_find_in_range(crash_base,
-				 crash_base + crash_size, crash_size, 1<<20);
+		start = memblock_alloc_range(crash_size, 1 << 20,
+					     crash_base,
+					     crash_base + crash_size);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
 		}
 	}
-	memblock_reserve(crash_base, crash_size);
 
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
 			"for crashkernel (System RAM: %ldMB)\n",
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 66dba36..76f67be 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -61,12 +61,11 @@ __ref void *alloc_low_pages(unsigned int num)
 		unsigned long ret;
 		if (min_pfn_mapped >= max_pfn_mapped)
 			panic("alloc_low_pages: ran out of memory");
-		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
-					max_pfn_mapped << PAGE_SHIFT,
-					PAGE_SIZE * num , PAGE_SIZE);
+		ret = memblock_alloc_range(PAGE_SIZE * num, PAGE_SIZE,
+					   min_pfn_mapped << PAGE_SHIFT,
+					   max_pfn_mapped << PAGE_SHIFT);
 		if (!ret)
 			panic("alloc_low_pages: can not alloc memory");
-		memblock_reserve(ret, PAGE_SIZE * num);
 		pfn = ret >> PAGE_SHIFT;
 	} else {
 		pfn = pgt_buf_end;
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index a32b706..f7c0718 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -375,15 +375,13 @@ static int __init numa_alloc_distance(void)
 	cnt++;
 	size = cnt * cnt * sizeof(numa_distance[0]);
 
-	phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
-				      size, PAGE_SIZE);
+	phys = memblock_alloc_base(size, PAGE_SIZE, PFN_PHYS(max_pfn_mapped));
 	if (!phys) {
 		pr_warning("NUMA: Warning: can't allocate distance table!\n");
 		/* don't retry until explicitly reset */
 		numa_distance = (void *)1LU;
 		return -ENOMEM;
 	}
-	memblock_reserve(phys, size);
 
 	numa_distance = __va(phys);
 	numa_distance_cnt = cnt;
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index a8f90ce..341d5ae 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -357,13 +357,12 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	if (numa_dist_cnt) {
 		u64 phys;
 
-		phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
-					      phys_size, PAGE_SIZE);
+		phys = memblock_alloc_base(phys_size, PAGE_SIZE,
+					   PFN_PHYS(max_pfn_mapped));
 		if (!phys) {
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
 			goto no_emu;
 		}
-		memblock_reserve(phys, phys_size);
 		phys_dist = __va(phys);
 
 		for (i = 0; i < numa_dist_cnt; i++)
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index bad628a..7867ae6 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -15,12 +15,11 @@ void __init reserve_real_mode(void)
 	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
 
 	/* Has to be under 1M so we can execute real-mode AP code. */
-	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
+	mem = memblock_alloc_base(size, PAGE_SIZE, 1 << 20);
 	if (!mem)
 		panic("Cannot allocate trampoline\n");
 
 	base = __va(mem);
-	memblock_reserve(mem, size);
 	real_mode_header = (struct real_mode_header *) base;
 	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
 	       base, (unsigned long long)mem, size);
-- 
1.9.1

