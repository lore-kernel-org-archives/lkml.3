Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3CJGrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:47:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48183 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3CJGrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:47:03 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 10/20] x86, mm, numa: Call numa_meminfo_cover_memory() checking early
Date: Sat,  9 Mar 2013 22:44:37 -0800
Message-Id: <1362897887-30808-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the separation, we need to set memblock nid later, as it
could change memblock array, and possible doube memblock.memory
array that will need to allocate buffer.

We do not need to use nid in memblock to find out absent pages.
So we can move that numa_meminfo_cover_memory() early.

Also could change __absent_pages_in_range() to static and use
absent_pages_in_range() directly.

Later we can only set memblock nid one time on successful path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa.c |    7 ++++---
 include/linux/mm.h |    2 --
 mm/page_alloc.c    |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index d545638..b7173f6 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -460,7 +460,7 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 		u64 s = mi->blk[i].start >> PAGE_SHIFT;
 		u64 e = mi->blk[i].end >> PAGE_SHIFT;
 		numaram += e - s;
-		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
+		numaram -= absent_pages_in_range(s, e);
 		if ((s64)numaram < 0)
 			numaram = 0;
 	}
@@ -488,6 +488,9 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
+	if (!numa_meminfo_cover_memory(mi))
+		return -EINVAL;
+
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *mb = &mi->blk[i];
 		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
@@ -506,8 +509,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 		return -EINVAL;
 	}
 #endif
-	if (!numa_meminfo_cover_memory(mi))
-		return -EINVAL;
 
 	return 0;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7acc9dc..2ae2050 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1324,8 +1324,6 @@ extern void free_initmem(void);
  */
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
-unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
-						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8fcced7..580d919 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4356,7 +4356,7 @@ static unsigned long __meminit zone_spanned_pages_in_node(int nid,
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-unsigned long __meminit __absent_pages_in_range(int nid,
+static unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
-- 
1.7.10.4

