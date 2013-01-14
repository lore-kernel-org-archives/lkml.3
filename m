Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3ANJRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:17:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:22288 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab3ANJQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:16:16 -0500
X-IronPort-AV: E=Sophos;i="4.84,466,1355068800"; 
   d="scan'208";a="6582719"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v5 3/5] page_alloc: Introduce zone_movable_limit[] to keep movable limit for nodes
Date: Mon, 14 Jan 2013 17:15:23 +0800
Message-Id: <1358154925-21537-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 17:15:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 17:15:29,
	Serialize complete at 2013/01/14 17:15:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new array zone_movable_limit[] to store the
ZONE_MOVABLE limit from movablecore_map boot option for all nodes.
The function sanitize_zone_movable_limit() will find out to which
node the ranges in movable_map.map[] belongs, and calculates the
low boundary of ZONE_MOVABLE for each node.

change log:
Do find_usable_zone_for_movable() to initialize movable_zone
so that sanitize_zone_movable_limit() could use it.

Reported-by: Wu Jianguo <wujianguo@huawei.com>

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Liu Jiang <jiang.liu@huawei.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/page_alloc.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1a7a88..093b953 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -209,6 +209,7 @@ static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+static unsigned long __meminitdata zone_movable_limit[MAX_NUMNODES];
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -4370,6 +4371,77 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
+/**
+ * sanitize_zone_movable_limit - Sanitize the zone_movable_limit array.
+ *
+ * zone_movable_limit is initialized as 0. This function will try to get
+ * the first ZONE_MOVABLE pfn of each node from movablecore_map, and
+ * assigne them to zone_movable_limit.
+ * zone_movable_limit[nid] == 0 means no limit for the node.
+ *
+ * Note: Each range is represented as [start_pfn, end_pfn)
+ */
+static void __meminit sanitize_zone_movable_limit(void)
+{
+	int map_pos = 0, i, nid;
+	unsigned long start_pfn, end_pfn;
+
+	if (!movablecore_map.nr_map)
+		return;
+
+	/* Iterate all ranges from minimum to maximum */
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		/*
+		 * If we have found lowest pfn of ZONE_MOVABLE of the node
+		 * specified by user, just go on to check next range.
+		 */
+		if (zone_movable_limit[nid])
+			continue;
+
+#ifdef CONFIG_ZONE_DMA
+		/* Skip DMA memory. */
+		if (start_pfn < arch_zone_highest_possible_pfn[ZONE_DMA])
+			start_pfn = arch_zone_highest_possible_pfn[ZONE_DMA];
+#endif
+
+#ifdef CONFIG_ZONE_DMA32
+		/* Skip DMA32 memory. */
+		if (start_pfn < arch_zone_highest_possible_pfn[ZONE_DMA32])
+			start_pfn = arch_zone_highest_possible_pfn[ZONE_DMA32];
+#endif
+
+#ifdef CONFIG_HIGHMEM
+		/* Skip lowmem if ZONE_MOVABLE is highmem. */
+		if (zone_movable_is_highmem() &&
+		    start_pfn < arch_zone_lowest_possible_pfn[ZONE_HIGHMEM])
+			start_pfn = arch_zone_lowest_possible_pfn[ZONE_HIGHMEM];
+#endif
+
+		if (start_pfn >= end_pfn)
+			continue;
+
+		while (map_pos < movablecore_map.nr_map) {
+			if (end_pfn <= movablecore_map.map[map_pos].start_pfn)
+				break;
+
+			if (start_pfn >= movablecore_map.map[map_pos].end_pfn) {
+				map_pos++;
+				continue;
+			}
+
+			/*
+			 * The start_pfn of ZONE_MOVABLE is either the minimum
+			 * pfn specified by movablecore_map, or 0, which means
+			 * the node has no ZONE_MOVABLE.
+			 */
+			zone_movable_limit[nid] = max(start_pfn,
+					movablecore_map.map[map_pos].start_pfn);
+
+			break;
+		}
+	}
+}
+
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -4388,6 +4460,10 @@ static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return zholes_size[zone_type];
 }
 
+static void __meminit sanitize_zone_movable_limit(void)
+{
+}
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
@@ -4831,7 +4907,6 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
-	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
 restart:
@@ -4990,6 +5065,8 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
+	find_usable_zone_for_movable();
+	sanitize_zone_movable_limit();
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
-- 
1.7.1

