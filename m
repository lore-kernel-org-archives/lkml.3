Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab3FMCN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:13:29 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60282 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab3FMCN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:13:27 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Colin Cross <ccross@android.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ARM: convert max_pfn and max_low_pfn to be relative to PFN0
Date: Wed, 12 Jun 2013 19:13:23 -0700
Message-Id: <1371089603-22601-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM max_pfn and max_low_pfn have always been relative to the
first valid PFN, apparently due to ancient kernels being unable
to properly handle physical memory at addresses other than 0.
A comment was added:
   Note: max_low_pfn and max_pfn reflect the number of _pages_ in
   the system, not the maximum PFN.
which conflicts with the comment in include/linux/bootmem.h that
says max_pfn is the highest page.  Since then, the number of users
of max_pfn has proliferated, and they all seem to assume that
max_pfn is the highest valid pfn.  The only user of max_low_pfn
as a number of pfns instead of the highest pfn is kcore, which
conflates max_low_pfn with the size of low memory, but it is not
supported on ARM.

Remove the PHYS_PFN_OFFSET subtraction from max_pfn and max_low_pfn,
and fix up the rest of ARM mm init that adds it back again.

This fixes reading page map counts and flags from /proc/kpagecount
and /proc/kpageflags, which will return a short read when reading
pfns that overlap with max_pfn, and return 0 when reading pfn
max_pfn, making it impossible to read the flags and count for pfn
max_pfn.

>From code inspection, I believe this will also improve block device
performance where the bounce limit was set to BLK_BOUNCE_HIGH, which
was bouncing unnecessarily for the top PHYS_PFN_OFFSET pages of low
memory.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mm/init.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

Boot tested on 3.4 and filled up all of memory without any issues.

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 9a5cdc0..b4e4051 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -415,16 +415,8 @@ void __init bootmem_init(void)
 	 */
 	arm_bootmem_free(min, max_low, max_high);
 
-	/*
-	 * This doesn't seem to be used by the Linux memory manager any
-	 * more, but is used by ll_rw_block.  If we can get rid of it, we
-	 * also get rid of some of the stuff above as well.
-	 *
-	 * Note: max_low_pfn and max_pfn reflect the number of _pages_ in
-	 * the system, not the maximum PFN.
-	 */
-	max_low_pfn = max_low - PHYS_PFN_OFFSET;
-	max_pfn = max_high - PHYS_PFN_OFFSET;
+	max_low_pfn = max_low;
+	max_pfn = max_high;
 }
 
 /*
@@ -530,7 +522,6 @@ static inline void free_area_high(unsigned long pfn, unsigned long end)
 static void __init free_highpages(void)
 {
 #ifdef CONFIG_HIGHMEM
-	unsigned long max_low = max_low_pfn + PHYS_PFN_OFFSET;
 	struct memblock_region *mem, *res;
 
 	/* set highmem page free */
@@ -539,12 +530,12 @@ static void __init free_highpages(void)
 		unsigned long end = memblock_region_memory_end_pfn(mem);
 
 		/* Ignore complete lowmem entries */
-		if (end <= max_low)
+		if (end <= max_low_pfn)
 			continue;
 
 		/* Truncate partial highmem entries */
-		if (start < max_low)
-			start = max_low;
+		if (start < max_low_pfn)
+			start = max_low_pfn;
 
 		/* Find and exclude any reserved regions */
 		for_each_memblock(reserved, res) {
@@ -591,7 +582,7 @@ void __init mem_init(void)
 	extern u32 itcm_end;
 #endif
 
-	max_mapnr   = pfn_to_page(max_pfn + PHYS_PFN_OFFSET) - mem_map;
+	max_mapnr   = pfn_to_page(max_pfn) - mem_map;
 
 	/* this will put all unused low memory onto the freelists */
 	free_unused_memmap(&meminfo);
-- 
1.8.3

