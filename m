Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3CPLLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 07:11:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57260 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab3CPLLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 07:11:35 -0400
X-IronPort-AV: E=Sophos;i="4.84,856,1355068800"; 
   d="scan'208";a="6882738"
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
Subject: [PATCH v1 5/9] x86, mm, numa, acpi: Extend movablemem_map to the end of each node.
Date: Sat, 16 Mar 2013 18:35:38 +0800
Message-Id: <1363430142-14563-6-git-send-email-tangchen@cn.fujitsu.com>
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

When implementing movablemem_map boot option, we introduced an array
movablemem_map.map[] to store the memory ranges to be set as ZONE_MOVABLE.

Since ZONE_MOVABLE is the latst zone of a node, if user didn't specify
the whole node memory range, we need to extend it to the node end so that
we can use it to prevent memblock from allocating memory in the ranges
user didn't specify.

We now implement movablemem_map boot option like this:
        /*
         * For movablemem_map=nn[KMG]@ss[KMG]:
         *
         * SRAT:                |_____| |_____| |_________| |_________| ......
         * node id:                0       1         1           2
         * user specified:                |__|                 |___|
         * movablemem_map:                |___| |_________|    |______| ......
         *
         * Using movablemem_map, we can prevent memblock from allocating memory
         * on ZONE_MOVABLE at boot time.
         *
         * NOTE: In this case, SRAT info will be ingored.
         */

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/srat.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 6cd4d33..ee888a2 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -150,16 +150,42 @@ static void __init sanitize_movablemem_map(int nid, u64 start, u64 end)
 	start_pfn = PFN_DOWN(start);
 	end_pfn = PFN_UP(end);
 
+	/*
+	 * For movablecore_map=nn[KMG]@ss[KMG]:
+	 *
+	 * SRAT:                |_____| |_____| |_________| |_________| ......
+	 * node id:                0       1         1           2
+	 * user specified:                |__|                 |___|
+	 * movablemem_map:                |___| |_________|    |______| ......
+	 *
+	 * Using movablemem_map, we can prevent memblock from allocating memory
+	 * on ZONE_MOVABLE at boot time.
+	 */
 	overlap = movablemem_map_overlap(start_pfn, end_pfn);
 	if (overlap >= 0) {
+		/*
+		 * If this range overlaps with movablemem_map, then update
+		 * zone_movable_limit[nid] if it has lower start pfn.
+		 */
 		start_pfn = max(start_pfn,
 				movablemem_map.map[overlap].start_pfn);
 
-		if (zone_movable_limit[nid])
-			zone_movable_limit[nid] = min(zone_movable_limit[nid],
-						      start_pfn);
-		else
+		if (!zone_movable_limit[nid] ||
+		    zone_movable_limit[nid] > start_pfn)
 			zone_movable_limit[nid] = start_pfn;
+
+		/* Insert the higher part of the overlapped range. */
+		if (movablemem_map.map[overlap].end_pfn < end_pfn)
+			insert_movablemem_map(start_pfn, end_pfn);
+	} else {
+		/*
+		 * If this is a range higher than zone_movable_limit[nid],
+		 * insert it to movablemem_map because all ranges higher than
+		 * zone_movable_limit[nid] on this node will be ZONE_MOVABLE.
+		 */
+		if (zone_movable_limit[nid] &&
+		    start_pfn > zone_movable_limit[nid])
+			insert_movablemem_map(start_pfn, end_pfn);
 	}
 }
 #else		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-- 
1.7.1

