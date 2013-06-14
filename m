Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3FNVcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:32:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3FNVco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:32:44 -0400
Date: Fri, 14 Jun 2013 14:32:32 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-076d2bd696f8fc47c881a92dd1e5b203ef556f51@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1371128589-8953-13-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-13-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm, numa: Move node_map_pfn_alignment() to x86
Git-Commit-ID: 076d2bd696f8fc47c881a92dd1e5b203ef556f51
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:32:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  076d2bd696f8fc47c881a92dd1e5b203ef556f51
Gitweb:     http://git.kernel.org/tip/076d2bd696f8fc47c881a92dd1e5b203ef556f51
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:59 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:04:58 -0700

x86, mm, numa: Move node_map_pfn_alignment() to x86

Move node_map_pfn_alignment() to arch/x86/mm as there is no
other user for it.

Will update it to use numa_meminfo instead of memblock.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-13-git-send-email-tangchen@cn.fujitsu.com
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h |  1 -
 mm/page_alloc.c    | 50 --------------------------------------------------
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
index c427f46..28c4a97 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4760,56 +4760,6 @@ void __init setup_nr_node_ids(void)
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
