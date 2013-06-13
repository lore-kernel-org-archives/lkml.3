Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab3FMNiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:38:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8481 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758153Ab3FMN2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:28:03 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537686"
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
Subject: [Part1 PATCH v5 11/22] x86, mm, numa: Call numa_meminfo_cover_memory() checking early
Date: Thu, 13 Jun 2013 21:02:58 +0800
Message-Id: <1371128589-8953-12-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:31,
	Serialize complete at 2013/06/13 20:58:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

In order to seperate parsing numa info procedure into two steps,
we need to set memblock nid later, as it could change memblock
array, and possible doube memblock.memory array which will need
to allocate buffer.

We do not need to use nid in memblock to find out absent pages.
So we can move that numa_meminfo_cover_memory() early.

Also we could change __absent_pages_in_range() to static and use
absent_pages_in_range() directly.

Later we will set memblock nid only once on successful path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |    7 ++++---
 include/linux/mm.h |    2 --
 mm/page_alloc.c    |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 07ae800..1bb565d 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -457,7 +457,7 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 		u64 s = mi->blk[i].start >> PAGE_SHIFT;
 		u64 e = mi->blk[i].end >> PAGE_SHIFT;
 		numaram += e - s;
-		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
+		numaram -= absent_pages_in_range(s, e);
 		if ((s64)numaram < 0)
 			numaram = 0;
 	}
@@ -485,6 +485,9 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
+	if (!numa_meminfo_cover_memory(mi))
+		return -EINVAL;
+
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *mb = &mi->blk[i];
 		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
@@ -503,8 +506,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 		return -EINVAL;
 	}
 #endif
-	if (!numa_meminfo_cover_memory(mi))
-		return -EINVAL;
 
 	return 0;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e0c8528..28e9470 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1385,8 +1385,6 @@ static inline unsigned long free_initmem_default(int poison)
  */
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
-unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
-						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3edb62..74e3428 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4397,7 +4397,7 @@ static unsigned long __meminit zone_spanned_pages_in_node(int nid,
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-unsigned long __meminit __absent_pages_in_range(int nid,
+static unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
-- 
1.7.1

