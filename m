Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaBMClJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:41:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21472 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaBMClH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:41:07 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-6c-52fc30c17fb7
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Mel Gorman'" <mgorman@suse.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, riel@redhat.com,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] mm/vmscan: restore sc->gfp_mask after promoting it to
 __GFP_HIGHMEM
Date: Thu, 13 Feb 2014 10:39:58 +0800
Message-id: <000001cf2865$0aa2c0c0$1fe84240$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8oZOL3M2IMgqo9SBOvycqIFQ+XkA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t9jQd2DBn+CDNYdlrSYs34Nm8XlXXPY
	LO6t+c9qMfndM0aLZV/fs1v8vbKexeLJif8sDuweO2fdZffYtKqTzWPTp0nsHidm/GbxeL/v
	KpvH5tPVHp83yQWwR3HZpKTmZJalFunbJXBl9JyLKHjCU3FxeX4D4yquLkZODgkBE4n+z6+Y
	IWwxiQv31rN1MXJxCAlMZ5RonzmfEcL5wyjxetpBNpAqNgFtibv9G1lBbBEBJYnTf76CdTAL
	XGKUeHS+gxEkISwQJfHx9iOwIhYBVYmtmz8ygdi8AnYSGyZAxHkFBCV+TL7H0sXIAdSsLjFl
	Si5ImFlAXmLzmrfMIGEJoPCjv7oQq/Qkuh+8Z4MoEZfYeOQWywRGgVlIBs1CGDQLyaBZSDoW
	MLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOhGdSOxhXNlgcYhTgYFTi4X2w+HeQEGti
	WXFl7iFGCQ5mJRFeGYk/QUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphak
	FsFkmTg4pRoY1yxzr3kqJV6yR6neQXwJU4iI+XY+nutPfq9vkZ6zM35OBc+KE6955189a1B1
	5nvVHibbqXPcvzoZKs+XDGAun3Gr/Mt27dctjcr3/QX032Xe+b3vf8F7Ll4Oz9z9rqmGS4NX
	8GyK0Fd4dak2TcRujuVnzalHqtJDhbdxVp6Z+JrfdGvqOgsFJZbijERDLeai4kQA8aH7uIAC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We promote sc->gfp_mask to __GFP_HIGHMEM to forcibly scan highmem if
there are too many buffer_heads pinning highmem. see: cc715d99e5

This patch restores sc->gfp_mask to its caller original value after
finishing the scan job, to avoid the impact on other invocations from
its upper caller, such as vmpressure_prio(), shrink_slab().

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/vmscan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 mm/vmscan.c

diff --git a/mm/vmscan.c b/mm/vmscan.c
old mode 100644
new mode 100755
index a9c74b4..35879f0
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2298,14 +2298,17 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
 	bool aborted_reclaim = false;
+	bool promoted_mask = false;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
 	 * allowed level, force direct reclaim to scan the highmem zone as
 	 * highmem pages could be pinning lowmem pages storing buffer_heads
 	 */
-	if (buffer_heads_over_limit)
+	if (buffer_heads_over_limit) {
+		promoted_mask = !(sc->gfp_mask & __GFP_HIGHMEM);
 		sc->gfp_mask |= __GFP_HIGHMEM;
+	}
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2354,6 +2357,9 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		shrink_zone(zone, sc);
 	}
 
+	if (promoted_mask)
+		sc->gfp_mask &= ~__GFP_HIGHMEM;
+
 	return aborted_reclaim;
 }
 
-- 
1.7.10.4


