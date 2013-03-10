Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3CJGrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:47:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19088 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3CJGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:47:11 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 11/20] x86, mm, numa: Move node_map_pfn alignment() to x86
Date: Sat,  9 Mar 2013 22:44:38 -0800
Message-Id: <1362897887-30808-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move node_map_pfn_alignment() to arch/x86/mm as no other user for it.

Will update it to use numa_meminfo instead of memblock.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h |    1 -
 mm/page_alloc.c    |   50 --------------------------------------------------
 3 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index b7173f6..24155b2 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -477,6 +477,56 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 	return true;
 }
 
+/**
+ * node_map_pfn_alignment - determine the maximum internode alignment
+ *
+ * This function should be called after node map is populated and sorted.
+ * It calculates the maximum power of two alignment which can distinguish
+ * all the nodes.
+ *
+ * For example, if all nodes are 1GiB and aligned to 1GiB, the return value
+ * would indicate 1GiB alignment with (1 << (30 - PAGE_SHIFT)).  If the
+ * nodes are shifted by 256MiB, 256MiB.  Note that if only the last node is
+ * shifted, 1GiB is enough and this function will indicate so.
+ *
+ * This is used to test whether pfn -> nid mapping of the chosen memory
+ * model has fine enough granularity to avoid incorrect mapping for the
+ * populated node map.
+ *
+ * Returns the determined alignment in pfn's.  0 if there is no alignment
+ * requirement (single node).
+ */
+unsigned long __init node_map_pfn_alignment(void)
+{
+	unsigned long accl_mask = 0, last_end = 0;
+	unsigned long start, end, mask;
+	int last_nid = -1;
+	int i, nid;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
+		if (!start || last_nid < 0 || last_nid == nid) {
+			last_nid = nid;
+			last_end = end;
+			continue;
+		}
+
+		/*
+		 * Start with a mask granular enough to pin-point to the
+		 * start pfn and tick off bits one-by-one until it becomes
+		 * too coarse to separate the current node from the last.
+		 */
+		mask = ~((1 << __ffs(start)) - 1);
+		while (mask && last_end <= (start & (mask << 1)))
+			mask <<= 1;
+
+		/* accumulate all internode masks */
+		accl_mask |= mask;
+	}
+
+	/* convert mask to number of pages */
+	return ~accl_mask + 1;
+}
+
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
 	unsigned long uninitialized_var(pfn_align);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2ae2050..1c79b10 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1323,7 +1323,6 @@ extern void free_initmem(void);
  * CONFIG_HAVE_MEMBLOCK_NODE_MAP.
  */
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
-unsigned long node_map_pfn_alignment(void);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 580d919..f368db4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4725,56 +4725,6 @@ static inline void setup_nr_node_ids(void)
 }
 #endif
 
-/**
- * node_map_pfn_alignment - determine the maximum internode alignment
- *
- * This function should be called after node map is populated and sorted.
- * It calculates the maximum power of two alignment which can distinguish
- * all the nodes.
- *
- * For example, if all nodes are 1GiB and aligned to 1GiB, the return value
- * would indicate 1GiB alignment with (1 << (30 - PAGE_SHIFT)).  If the
- * nodes are shifted by 256MiB, 256MiB.  Note that if only the last node is
- * shifted, 1GiB is enough and this function will indicate so.
- *
- * This is used to test whether pfn -> nid mapping of the chosen memory
- * model has fine enough granularity to avoid incorrect mapping for the
- * populated node map.
- *
- * Returns the determined alignment in pfn's.  0 if there is no alignment
- * requirement (single node).
- */
-unsigned long __init node_map_pfn_alignment(void)
-{
-	unsigned long accl_mask = 0, last_end = 0;
-	unsigned long start, end, mask;
-	int last_nid = -1;
-	int i, nid;
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
-		if (!start || last_nid < 0 || last_nid == nid) {
-			last_nid = nid;
-			last_end = end;
-			continue;
-		}
-
-		/*
-		 * Start with a mask granular enough to pin-point to the
-		 * start pfn and tick off bits one-by-one until it becomes
-		 * too coarse to separate the current node from the last.
-		 */
-		mask = ~((1 << __ffs(start)) - 1);
-		while (mask && last_end <= (start & (mask << 1)))
-			mask <<= 1;
-
-		/* accumulate all internode masks */
-		accl_mask |= mask;
-	}
-
-	/* convert mask to number of pages */
-	return ~accl_mask + 1;
-}
-
 /* Find the lowest pfn for a node */
 static unsigned long __init find_min_pfn_for_node(int nid)
 {
-- 
1.7.10.4

