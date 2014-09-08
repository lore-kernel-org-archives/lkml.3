Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaIHXib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:38:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54967 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaIHXi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:38:28 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 2/3] x86: use memblock_alloc_range()
Date: Tue,  9 Sep 2014 08:38:03 +0900
Message-Id: <1410219484-8038-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410219484-8038-1-git-send-email-akinobu.mita@gmail.com>
References: <1410219484-8038-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_alloc_range() is equivalent to memblock_find_in_range()
followed by memblock_reserve().  Convert to use it where possible.

This is mainly a cleanup.  Also, memblock_alloc_range() calls
kmemleak_alloc() for allocated memory block with min_count of 0, so that
it is never reported as leaks.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-mm@kvack.org
---
* v2: split from membloc_alloc_base() conversions.

 arch/x86/kernel/aperture_64.c |  6 +++---
 arch/x86/kernel/setup.c       | 17 ++++++++---------
 arch/x86/mm/init.c            |  7 +++----
 3 files changed, 14 insertions(+), 16 deletions(-)

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
index 41ead8d..7d32406 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -545,8 +545,8 @@ static void __init reserve_crashkernel_low(void)
 			return;
 	}
 
-	low_base = memblock_find_in_range(low_size, (1ULL<<32),
-					low_size, alignment);
+	low_base = memblock_alloc_range(low_size, alignment,
+					low_size, 1ULL << 32);
 
 	if (!low_base) {
 		if (!auto_set)
@@ -555,7 +555,6 @@ static void __init reserve_crashkernel_low(void)
 		return;
 	}
 
-	memblock_reserve(low_base, low_size);
 	pr_info("Reserving %ldMB of low memory at %ldMB for crashkernel (System low RAM: %ldMB)\n",
 			(unsigned long)(low_size >> 20),
 			(unsigned long)(low_base >> 20),
@@ -593,10 +592,10 @@ static void __init reserve_crashkernel(void)
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
@@ -606,14 +605,14 @@ static void __init reserve_crashkernel(void)
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
-- 
1.9.1

