Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaAMND4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:03:56 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:40948 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaAMNDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:03:50 -0500
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, qiuxishi@huawei.com, dhowells@redhat.com,
        daeseok.youn@gmail.com, liuj97@gmail.com, yinghai@kernel.org,
        phacht@linux.vnet.ibm.com, zhangyanfei@cn.fujitsu.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        tangchen@cn.fujitsu.com
Subject: [PATCH V3 1/2] mm/nobootmem: free_all_bootmem again
Date: Mon, 13 Jan 2014 14:03:36 +0100
Message-Id: <1389618217-48166-2-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1389618217-48166-1-git-send-email-phacht@linux.vnet.ibm.com>
References: <1389618217-48166-1-git-send-email-phacht@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011313-2966-0000-0000-000009EB0FCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_allocated_memblock_reserved_regions_info() should work if it is
compiled in. Extended the ifdef around
get_allocated_memblock_memory_regions_info() to include
get_allocated_memblock_reserved_regions_info() as well.
Similar changes in nobootmem.c/free_low_memory_core_early() where
the two functions are called.

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
---
 mm/memblock.c  | 17 ++---------------
 mm/nobootmem.c |  4 ++--
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 64ed243..9c0aeef 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -266,33 +266,20 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
 	}
 }
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
 phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
 					phys_addr_t *addr)
 {
 	if (memblock.reserved.regions == memblock_reserved_init_regions)
 		return 0;
 
-	/*
-	 * Don't allow nobootmem allocator to free reserved memory regions
-	 * array if
-	 *  - CONFIG_DEBUG_FS is enabled;
-	 *  - CONFIG_ARCH_DISCARD_MEMBLOCK is not enabled;
-	 *  - reserved memory regions array have been resized during boot.
-	 * Otherwise debug_fs entry "sys/kernel/debug/memblock/reserved"
-	 * will show garbage instead of state of memory reservations.
-	 */
-	if (IS_ENABLED(CONFIG_DEBUG_FS) &&
-	    !IS_ENABLED(CONFIG_ARCH_DISCARD_MEMBLOCK))
-		return 0;
-
 	*addr = __pa(memblock.reserved.regions);
 
 	return PAGE_ALIGN(sizeof(struct memblock_region) *
 			  memblock.reserved.max);
 }
 
-#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
-
 phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
 					phys_addr_t *addr)
 {
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 17c8902..e2906a5 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -122,13 +122,13 @@ static unsigned long __init free_low_memory_core_early(void)
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
 	/* Free memblock.reserved array if it was allocated */
 	size = get_allocated_memblock_reserved_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
 
-#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
-
 	/* Free memblock.memory array if it was allocated */
 	size = get_allocated_memblock_memory_regions_info(&start);
 	if (size)
-- 
1.8.4.5

