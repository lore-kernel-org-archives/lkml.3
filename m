Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaBNGnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:43:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40640 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaBNGnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:43:13 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-52-52fdbb00bb9f
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Mel Gorman'" <mgorman@suse.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, riel@redhat.com,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 2/2] mm/vmscan: not check compaction_ready on promoted zones
Date: Fri, 14 Feb 2014 14:42:34 +0800
Message-id: <000201cf2950$07a17ce0$16e476a0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8pT+G8WIoMnkgpS0ia60jsWOQ39A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jQV2G3X+DDM4elLCYs34Nm8XlXXPY
	LO6t+c9qMfndM0aLZV/fs1v8vbKexeLJif8sDuweO2fdZffYtKqTzWPTp0nsHidm/GbxeL/v
	KpvH5tPVHp83yQWwR3HZpKTmZJalFunbJXBlTHq0lLFgB0/FtN7DbA2MXzm7GDk5JARMJJoP
	zGSDsMUkLtxbD2RzcQgJTGeUuHjvGTOE84dR4suf2UwgVWwC2hJ3+zeygtgiAkoSp/98Betg
	FrjEKPHofAcjSEJYwF+i68ZUFhCbRUBV4s+rxWANvAJ2Es/vrWKHsAUlfky+B1bDLKAuMWne
	ImYIW15i85q3QDYH0EnqEo/+6kLs0pOY1vkQqlxcYuORWywTGAVmIZk0C8mkWUgmzULSsoCR
	ZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcEQ8k97BuKrB4hCjAAejEg+vx4M/QUKsiWXF
	lbmHGCU4mJVEeJnS/gYJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoE
	k2Xi4JRqYFybcHG+k+iD94pvb29hDmAqnBx0rrP7+qJJrsI963okj/N87fEQEr9UKxr9c3+Q
	55GbBq/cS+UuSasJpLpJzyrWb6/Y0H/EZ1UAo1cX97GNNxfK2FqZL7zW+UstZn2t6yfT9d37
	Ba4qaL9aPG+ygIf+NO8ncWFSylNPr5m6Lv7X16N8T7YumKTEUpyRaKjFXFScCAC5+Ka0hAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We abort direct reclaim if find the zone is ready for compaction.
Sometimes the zone is just a promoted highmem zone to force scan
pinning highmem, which is not the intended zone the caller want to
alloc page from. In this situation, setting aborted_reclaim to
indicate the caller turn back to retry allocation is waste of time
and could cause a loop in __alloc_pages_slowpath().

This patch do not check compaction_ready() on promoted zones to avoid
the above situation, only set aborted_reclaim if the caller intended
zone is ready to compaction.

Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index da0a87c..9ec6519 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2299,6 +2299,7 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 	unsigned long nr_soft_scanned;
 	bool aborted_reclaim = false;
 	gfp_t orig_mask = sc->gfp_mask;
+	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2332,7 +2333,8 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 				 * noticeable problem, like transparent huge
 				 * page allocations.
 				 */
-				if (compaction_ready(zone, sc)) {
+				if ((zonelist_zone_idx(z) <= requested_highidx)
+				    && compaction_ready(zone, sc)) {
 					aborted_reclaim = true;
 					continue;
 				}
-- 
1.7.10.4


