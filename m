Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaAGPRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:17:17 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:57840 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaAGPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:17:07 -0500
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, tangchen@cn.fujitsu.com, tj@kernel.org,
        toshi.kani@hp.com, Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: [PATCH 2/2] mm: free memblock.memory in free_all_bootmem
Date: Tue,  7 Jan 2014 16:16:14 +0100
Message-Id: <1389107774-54978-3-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1389107774-54978-1-git-send-email-phacht@linux.vnet.ibm.com>
References: <1389107774-54978-1-git-send-email-phacht@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010715-4966-0000-0000-0000080167B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling free_all_bootmem() the free areas under memblock's
control are released to the buddy allocator. Additionally the
reserved list is freed if it was reallocated by memblock.
The same should apply for the memory list.

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
---
 include/linux/memblock.h |  1 +
 mm/memblock.c            | 12 ++++++++++++
 mm/nobootmem.c           |  7 ++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 77c60e5..d174922 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,7 @@ phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
+phys_addr_t get_allocated_memblock_memory_regions_info(phys_addr_t *addr);
 void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index 53e477b..1a11d04 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -271,6 +271,18 @@ phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
 			  memblock.reserved.max);
 }
 
+phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
+					phys_addr_t *addr)
+{
+	if (memblock.memory.regions == memblock_memory_init_regions)
+		return 0;
+
+	*addr = __pa(memblock.memory.regions);
+
+	return PAGE_ALIGN(sizeof(struct memblock_region) *
+			  memblock.memory.max);
+}
+
 /**
  * memblock_double_array - double the size of the memblock regions array
  * @type: memblock type of the regions array being doubled
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 3a7e14d..83f36d3 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -122,11 +122,16 @@ static unsigned long __init free_low_memory_core_early(void)
 	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
-	/* free range that is used for reserved array if we allocate it */
+	/* Free memblock.reserved array if it was allocated */
 	size = get_allocated_memblock_reserved_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
 
+	/* Free memblock.memory array if it was allocated */
+	size = get_allocated_memblock_memory_regions_info(&start);
+	if (size)
+		count += __free_memory_core(start, start + size);
+
 	return count;
 }
 
-- 
1.8.4.5

