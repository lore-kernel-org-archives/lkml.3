Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab3CPLLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 07:11:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50161 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab3CPLLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 07:11:34 -0400
X-IronPort-AV: E=Sophos;i="4.84,856,1355068800"; 
   d="scan'208";a="6882737"
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
Subject: [PATCH v1 8/9] x86, mm, numa, acpi: make movablemem_map have higher priority
Date: Sat, 16 Mar 2013 18:35:41 +0800
Message-Id: <1363430142-14563-9-git-send-email-tangchen@cn.fujitsu.com>
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

If kernelcore or movablecore is specified at the same time with
movablemem_map, movablemem_map will have higher priority to be
satisfied.  This patch will make find_zone_movable_pfns_for_nodes()
calculate zone_movable_pfn[] with the limit from zone_movable_limit[].

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/page_alloc.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 70ed381..bdde30d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4873,9 +4873,17 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 		required_kernelcore = max(required_kernelcore, corepages);
 	}
 
-	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
-	if (!required_kernelcore)
+	/*
+	 * If neither kernelcore/movablecore nor movablemem_map is specified,
+	 * there is no ZONE_MOVABLE. But if movablemem_map is specified, the
+	 * start pfn of ZONE_MOVABLE has been stored in zone_movable_limit[].
+	 */
+	if (!required_kernelcore) {
+		if (movablemem_map.nr_map)
+			memcpy(zone_movable_pfn, zone_movable_limit,
+				sizeof(zone_movable_pfn));
 		goto out;
+	}
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
@@ -4905,10 +4913,24 @@ restart:
 		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 			unsigned long size_pages;
 
+			/*
+			 * Find more memory for kernelcore in
+			 * [zone_movable_pfn[nid], zone_movable_limit[nid]).
+			 */
 			start_pfn = max(start_pfn, zone_movable_pfn[nid]);
 			if (start_pfn >= end_pfn)
 				continue;
 
+			if (zone_movable_limit[nid]) {
+				end_pfn = min(end_pfn, zone_movable_limit[nid]);
+				/* No range left for kernelcore in this node */
+				if (start_pfn >= end_pfn) {
+					zone_movable_pfn[nid] =
+							zone_movable_limit[nid];
+					break;
+				}
+			}
+
 			/* Account for what is only usable for kernelcore */
 			if (start_pfn < usable_startpfn) {
 				unsigned long kernel_pages;
@@ -4968,12 +4990,12 @@ restart:
 	if (usable_nodes && required_kernelcore > usable_nodes)
 		goto restart;
 
+out:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
 	for (nid = 0; nid < MAX_NUMNODES; nid++)
 		zone_movable_pfn[nid] =
 			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 
-out:
 	/* restore the node_state */
 	node_states[N_MEMORY] = saved_node_state;
 }
-- 
1.7.1

