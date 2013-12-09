Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761829Ab3LIVwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:52:53 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39094 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761701Ab3LIVw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:52:27 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v3 06/23] mm/memblock: reorder parameters of memblock_find_in_range_node
Date: Mon, 9 Dec 2013 16:50:39 -0500
Message-ID: <1386625856-12942-7-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Reorder parameters of memblock_find_in_range_node to be consistent
with other memblock APIs.

The change was suggested by Tejun Heo <tj@kernel.org>.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 include/linux/memblock.h |    5 +++--
 mm/memblock.c            |   16 ++++++++--------
 mm/nobootmem.c           |    2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 77c60e5..dca4533 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -47,8 +47,9 @@ extern int memblock_debug;
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
-phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
-				phys_addr_t size, phys_addr_t align, int nid);
+phys_addr_t memblock_find_in_range_node(phys_addr_t size, phys_addr_t align,
+					    phys_addr_t start, phys_addr_t end,
+					    int nid);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
diff --git a/mm/memblock.c b/mm/memblock.c
index 784958d..8786503 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -154,10 +154,10 @@ __memblock_find_range_top_down(phys_addr_t start, phys_addr_t end,
 
 /**
  * memblock_find_in_range_node - find free area in given range and node
- * @start: start of candidate range
- * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
  * @size: size of free area to find
  * @align: alignment of free area to find
+ * @start: start of candidate range
+ * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
  * @nid: nid of the free area to find, %MAX_NUMNODES for any node
  *
  * Find @size free area aligned to @align in the specified range and node.
@@ -173,9 +173,9 @@ __memblock_find_range_top_down(phys_addr_t start, phys_addr_t end,
  * RETURNS:
  * Found address on success, 0 on failure.
  */
-phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
-					phys_addr_t end, phys_addr_t size,
-					phys_addr_t align, int nid)
+phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
+					phys_addr_t align, phys_addr_t start,
+					phys_addr_t end, int nid)
 {
 	int ret;
 	phys_addr_t kernel_end;
@@ -238,8 +238,8 @@ phys_addr_t __init_memblock memblock_find_in_range(phys_addr_t start,
 					phys_addr_t end, phys_addr_t size,
 					phys_addr_t align)
 {
-	return memblock_find_in_range_node(start, end, size, align,
-					   MAX_NUMNODES);
+	return memblock_find_in_range_node(size, align, start, end,
+					    MAX_NUMNODES);
 }
 
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
@@ -889,7 +889,7 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 	/* align @size to avoid excessive fragmentation on reserved array */
 	size = round_up(size, align);
 
-	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
+	found = memblock_find_in_range_node(size, align, 0, max_addr, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
 
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 2c254d3..59777e0 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -41,7 +41,7 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 	if (limit > memblock.current_limit)
 		limit = memblock.current_limit;
 
-	addr = memblock_find_in_range_node(goal, limit, size, align, nid);
+	addr = memblock_find_in_range_node(size, align, goal, limit, nid);
 	if (!addr)
 		return NULL;
 
-- 
1.7.9.5

