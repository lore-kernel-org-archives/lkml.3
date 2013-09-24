Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3IXSZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:25:47 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44686 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab3IXSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:25:44 -0400
Message-ID: <5241D90D.6030203@gmail.com>
Date: Wed, 25 Sep 2013 02:25:17 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com
CC: "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v5 1/6] memblock: Factor out of top-down allocation
References: <5241D897.1090905@gmail.com>
In-Reply-To: <5241D897.1090905@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

This patch creates a new function __memblock_find_range_rev
to factor out of top-down allocation from memblock_find_in_range_node.
This is a preparation because we will introduce a new bottom-up
allocation mode in the following patch.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/memblock.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 0ac412a..3d80c74 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -83,33 +83,25 @@ static long __init_memblock memblock_overlaps_region(struct memblock_type *type,
 }
 
 /**
- * memblock_find_in_range_node - find free area in given range and node
+ * __memblock_find_range_rev - find free area utility, in reverse order
  * @start: start of candidate range
  * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
  * @size: size of free area to find
  * @align: alignment of free area to find
  * @nid: nid of the free area to find, %MAX_NUMNODES for any node
  *
- * Find @size free area aligned to @align in the specified range and node.
+ * Utility called from memblock_find_in_range_node(), find free area top-down.
  *
  * RETURNS:
  * Found address on success, %0 on failure.
  */
-phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
-					phys_addr_t end, phys_addr_t size,
-					phys_addr_t align, int nid)
+static phys_addr_t __init_memblock
+__memblock_find_range_rev(phys_addr_t start, phys_addr_t end,
+			  phys_addr_t size, phys_addr_t align, int nid)
 {
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
 
-	/* pump up @end */
-	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
-		end = memblock.current_limit;
-
-	/* avoid allocating the first page */
-	start = max_t(phys_addr_t, start, PAGE_SIZE);
-	end = max(start, end);
-
 	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
@@ -121,10 +113,39 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 		if (cand >= this_start)
 			return cand;
 	}
+
 	return 0;
 }
 
 /**
+ * memblock_find_in_range_node - find free area in given range and node
+ * @start: start of candidate range
+ * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
+ * @size: size of free area to find
+ * @align: alignment of free area to find
+ * @nid: nid of the free area to find, %MAX_NUMNODES for any node
+ *
+ * Find @size free area aligned to @align in the specified range and node.
+ *
+ * RETURNS:
+ * Found address on success, %0 on failure.
+ */
+phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
+					phys_addr_t end, phys_addr_t size,
+					phys_addr_t align, int nid)
+{
+	/* pump up @end */
+	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
+		end = memblock.current_limit;
+
+	/* avoid allocating the first page */
+	start = max_t(phys_addr_t, start, PAGE_SIZE);
+	end = max(start, end);
+
+	return __memblock_find_range_rev(start, end, size, align, nid);
+}
+
+/**
  * memblock_find_in_range - find free area in given range
  * @start: start of candidate range
  * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
-- 
1.7.1
