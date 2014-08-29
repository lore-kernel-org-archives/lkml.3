Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaH2HEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:04:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29954 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaH2HEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:04:22 -0400
X-AuditID: cbfee61b-f79f86d00000144c-42-540025f4b98a
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Mel Gorman'" <mgorman@suse.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Rik van Riel'" <riel@redhat.com>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>, rientjes@google.com,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Subject: [PATCH] mm: page_alloc: avoid wakeup kswapd on the unintended node
Date: Fri, 29 Aug 2014 15:03:19 +0800
Message-id: <000001cfc357$74db64a0$5e922de0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/DV1CF+wuLaLymR0uaEFzkDvedew==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQd0vqgwhBjcnWFnMWb+GzWL1Jl+L
	y7vmsFncW/Of1WLyu2eMFn+vrGexaFuykcniyYn/LA4cHoffvGf22DnrLrvHgk2lHps+TWL3
	ODHjN4vH+31X2Tw2n672+LxJLoAjissmJTUnsyy1SN8ugStj25XagjM8Fbs7VrM2MM7n6mLk
	5JAQMJFoOb2EFcIWk7hwbz1bFyMXh5DAdEaJ/ecvgyWEBP4wSjTctQex2QS0Je72bwSLiwgo
	SZz+8xWsgVmgj0ni0dFvzCAJYQFvib5fC8BsFgFVibddb5lAbF4BO4nZX46xQtiCEj8m32Pp
	YuQAalaXmDIlFyTMLCAvsXnNW2aQsARQ+NFfXYhVehKPt69lhygRl9h45BbLBEaBWUgGzUIY
	NAvJoFlIOhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6MZ9I7GFc1WBxiFOBgVOLh
	7Tj5P1iINbGsuDL3EKMEB7OSCG/hM6AQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJ
	JanZqakFqUUwWSYOTqkGRlHJEFsG64qaCwbfKnwiVXwmmW6P+vSovVEoeEZtF0PpKo8mkT+h
	GtqlRgtDPsXaOBrtW95puGN7Z2aCgfuZuV+ST6f6/LEJzV50XCbxbp+9vcX+zl2PRBcp/j8b
	PGc/z6Nmg5rYueyac05F7S3IaKuf78ymbKXHrN5786TyLXuTZU0ChplKLMUZiYZazEXFiQCQ
	Wg3hiAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enter page_alloc slowpath, we wakeup kswapd on every pgdat
according to the zonelist and high_zoneidx. However, this doesn't
take nodemask into account, and could prematurely wakeup kswapd on
some unintended nodes.

This patch uses for_each_zone_zonelist_nodemask() instead of
for_each_zone_zonelist() in wake_all_kswapds() to avoid the above situation.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 18cee0d..29b595a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2457,12 +2457,14 @@ __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 static void wake_all_kswapds(unsigned int order,
 			     struct zonelist *zonelist,
 			     enum zone_type high_zoneidx,
-			     struct zone *preferred_zone)
+			     struct zone *preferred_zone,
+			     nodemask_t *nodemask)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+						high_zoneidx, nodemask)
 		wakeup_kswapd(zone, order, zone_idx(preferred_zone));
 }
 
@@ -2560,7 +2562,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 restart:
 	if (!(gfp_mask & __GFP_NO_KSWAPD))
-		wake_all_kswapds(order, zonelist, high_zoneidx, preferred_zone);
+		wake_all_kswapds(order, zonelist, high_zoneidx,
+				preferred_zone, nodemask);
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
-- 
1.7.10.4


