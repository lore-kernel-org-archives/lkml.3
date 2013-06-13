Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab3FMNhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:37:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63792 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757305Ab3FMN2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:28:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537692"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [Part1 PATCH v5 12/22] x86, mm, numa: Move node_map_pfn_alignment() to x86
Date: Thu, 13 Jun 2013 21:02:59 +0800
Message-Id: <1371128589-8953-13-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:25,
	Serialize complete at 2013/06/13 20:58:25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Move node_map_pfn_alignment() to arch/x86/mm as there is no
other user for it.

Will update it to use numa_meminfo instead of memblock.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h |    1 -
 mm/page_alloc.c    |   50 --------------------------------------------------
 3 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 1bb565d..10c6240 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -474,6 +474,56 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
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
index 28e9470..b827743 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1384,7 +1384,6 @@ static inline unsigned long free_initmem_default(int poison)
  * CONFIG_HAVE_MEMBLOCK_NODE_MAP.
  */
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
-unsigned long node_map_pfn_alignment(void);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 74e3428..7ba7703 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4762,56 +4762,6 @@ void __init setup_nr_node_ids(void)
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
1.7.1

