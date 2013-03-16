Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3CPLLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 07:11:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50161 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab3CPLLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 07:11:36 -0400
X-IronPort-AV: E=Sophos;i="4.84,856,1355068800"; 
   d="scan'208";a="6882739"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com, mgorman@suse.de,
        walken@google.com, riel@redhat.com, khlebnikov@openvz.org,
        tj@kernel.org, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linfeng@cn.fujitsu.com,
        jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v1 7/9] x86, mm, numa, acpi: Sanitize zone_movable_limit[].
Date: Sat, 16 Mar 2013 18:35:40 +0800
Message-Id: <1363430142-14563-8-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1363430142-14563-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1363430142-14563-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 18:31:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 18:31:59,
	Serialize complete at 2013/03/16 18:31:59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned by Liu Jiang and Wu Jiangguo, users could specify DMA,
DMA32, and HIGHMEM as movable. In order to ensure the kernel will
work correctly, we should exclude these memory ranges out from
zone_movable_limit[].

NOTE: Do find_usable_zone_for_movable() to initialize movable_zone
      so that sanitize_zone_movable_limit() could use it. This is
      pointed out by Wu Jianguo <wujianguo@huawei.com>.

Reported-by: Wu Jianguo <wujianguo@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Liu Jiang <jiang.liu@huawei.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/page_alloc.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 31d27af..70ed381 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4412,6 +4412,58 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
+/**
+ * sanitize_zone_movable_limit - Sanitize the zone_movable_limit array.
+ *
+ * zone_movable_limit[] have been initialized when parsing SRAT or
+ * movablemem_map. This function will try to exclude ZONE_DMA, ZONE_DMA32,
+ * and HIGHMEM from zone_movable_limit[].
+ *
+ * zone_movable_limit[nid] == 0 means no limit for the node.
+ *
+ * Note: Need to be called with movable_zone initialized.
+ */
+static void __meminit sanitize_zone_movable_limit(void)
+{
+	int i, nid;
+	unsigned long start_pfn, end_pfn;
+
+	if (!movablemem_map.nr_map)
+		return;
+
+	/* Iterate each node id. */
+	for_each_node(nid) {
+		/* If we have no limit for this node, just skip it. */
+		if (!zone_movable_limit[nid])
+			continue;
+
+#ifdef CONFIG_ZONE_DMA
+		/* Skip DMA memory. */
+		if (zone_movable_limit[nid] <
+		    arch_zone_highest_possible_pfn[ZONE_DMA])
+			zone_movable_limit[nid] =
+				arch_zone_highest_possible_pfn[ZONE_DMA];
+#endif
+
+#ifdef CONFIG_ZONE_DMA32
+		/* Skip DMA32 memory. */
+		if (zone_movable_limit[nid] <
+		    arch_zone_highest_possible_pfn[ZONE_DMA32])
+			zone_movable_limit[nid] =
+				arch_zone_highest_possible_pfn[ZONE_DMA32];
+#endif
+
+#ifdef CONFIG_HIGHMEM
+		/* Skip lowmem if ZONE_MOVABLE is highmem. */
+		if (zone_movable_is_highmem() &&
+		    zone_movable_limit[nid] <
+		    arch_zone_lowest_possible_pfn[ZONE_HIGHMEM])
+			zone_movable_limit[nid] =
+				arch_zone_lowest_possible_pfn[ZONE_HIGHMEM];
+#endif
+	}
+}
+
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -4826,7 +4878,6 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
-	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
 restart:
@@ -4985,6 +5036,8 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
+	find_usable_zone_for_movable();
+	sanitize_zone_movable_limit();
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
-- 
1.7.1

