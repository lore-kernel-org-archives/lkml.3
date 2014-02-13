Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaBMCmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:42:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34615 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaBMCmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:42:05 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-63-52fc30fa7b2a
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Mel Gorman'" <mgorman@suse.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, riel@redhat.com,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] mm/vmscan: not check compaction_ready on promoted zones
Date: Thu, 13 Feb 2014 10:41:21 +0800
Message-id: <000101cf2865$2a8411a0$7f8c34e0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8oZPwRHH9P4onKTC22Hc18MFTqDg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t9jQd3fBn+CDPpcLOasX8NmcXnXHDaL
	e2v+s1pMfveM0WLZ1/fsFn+vrGexeHLiP4sDu8fOWXfZPTat6mTz2PRpErvHiRm/WTze77vK
	5rH5dLXH501yAexRXDYpqTmZZalF+nYJXBnPjyxkLejhqXjy5idbA+NZzi5GTg4JAROJgy8v
	sULYYhIX7q1n62Lk4hASmM4osfzpWVYI5w+jxP3T+xhBqtgEtCXu9m8E6xARUJI4/ecrWAez
	wCVGiUfnO8CKhAV8JD7/amHpYuTgYBFQlfj0SxLE5BWwkzjdXgVSwSsgKPFj8j2wCmYBdYkp
	U3JBwswC8hKb17xlBglLAIUf/dWFWKQnsf74HUaIEnGJjUdusUxgFJiFZNAshEGzkAyahaRj
	ASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgOHgmtYNxZYPFIUYBDkYlHt4Hi38HCbEm
	lhVX5h5ilOBgVhLhlZH4EyTEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampB
	ahFMlomDU6qBkV3McxaP0+ET3lczFkw4oGG59NTBlycYNr+v8n/b+2uJqe85tpDQTXfkpGdt
	kJAXfmelIFs399XpPYfUW2Xi42o4tZo33Qgw1zorFno68GFL9qXN0zSjexz9Vz8y6mhfaW/6
	OaQyZttc7hY5dXb77R1tesaq3H9MF7rnKuVL5S7Z93Bf+7/1SizFGYmGWsxFxYkAEKOODn8C	AAA=
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

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35879f0..73e2577 100755
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2299,6 +2299,7 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 	unsigned long nr_soft_scanned;
 	bool aborted_reclaim = false;
 	bool promoted_mask = false;
+	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2334,7 +2335,8 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
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


