Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaKFIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:09:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14899 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaKFIJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:09:55 -0500
X-AuditID: cbfee61a-f79c06d000004e71-0f-545b2cd1b97c
From: Weijie Yang <weijie.yang@samsung.com>
To: kamezawa.hiroyu@jp.fujitsu.com, "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        mina86@mina86.com, "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: [PATCH 2/2] mm: page_isolation: fix zone_freepage accounting
Date: Thu, 06 Nov 2014 16:09:08 +0800
Message-id: <000101cff999$09225070$1b66f150$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/5mNNMPGw6AOdSRUi8KMXwgDh7GA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jAd2LOtEhBsumGFnMWb+GzWLm7NlM
	Fpd3zWGzuLfmP6vF5HfPGC0WHG9htVj29T27xZMT/1kcODx2zrrL7nHiySU2j02rOoHEp0lA
	7ozfLB7r/rxi8th8utrj8ya5AI4oLpuU1JzMstQifbsErox5j7ewFUzjqlj8ZyprA+MMji5G
	Tg4JAROJPTe2MELYYhIX7q1n62Lk4hASWMQocXzOc2YI5w+jxKV5u9lBqtgEtCXu9m9kBbFF
	BNwkjuzdxwhSxCxwkVHi2PSLzCAJYQFXicnXG1hAbBYBVYnO3mdgcV4BO4kjy+6xQtiCEj8m
	3wOq4QBqVpeYMiUXJMwsIC+xec1bZpCwBFD40V9diFV6Ej8OXGeBKBGX2HjkFssERoFZSAbN
	Qhg0C8mgWUg6FjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjpBnUjsYVzZYHGIU4GBU
	4uHdcTQqRIg1say4MvcQowQHs5IIb690dIgQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFC
	AumJJanZqakFqUUwWSYOTqkGxinPjxSEHNj+/szl41UH7Xlu3ZPftop9jrJoskbQp93/rTcu
	nmr7NCgvJd3/nG/79mWrHjVLPPP+kxfSKlW8hG3Klv3HGON3lNbPiHzk3SQv6qiqd+0Ij6Zz
	vvms61Ok9V+sVskNvqkrcvn47/I0+aTkyLLyT3G6OVftnK7YG9Vu5PfqXXPnmhJLcUaioRZz
	UXEiABURjMCMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If race between isolatation and allocation happens, we could need to move
some freepages to MIGRATE_ISOLATE in __test_page_isolated_in_pageblock().
The current code ignores the zone_freepage accounting after the move,
which cause the zone NR_FREE_PAGES and NR_FREE_CMA_PAGES statistics incorrect.

This patch fixes this rare issue.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/page_isolation.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 3ddc8b3..15b51de 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -193,12 +193,15 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
 			 * is MIGRATE_ISOLATE. Catch it and move the page into
 			 * MIGRATE_ISOLATE list.
 			 */
-			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE) {
+			int migratetype = get_freepage_migratetype(page);
+			if (migratetype != MIGRATE_ISOLATE) {
 				struct page *end_page;
 
 				end_page = page + (1 << page_order(page)) - 1;
 				move_freepages(page_zone(page), page, end_page,
 						MIGRATE_ISOLATE);
+				__mod_zone_freepage_state(zone,
+					-(1 << page_order(page)), migratetype);
 			}
 			pfn += 1 << page_order(page);
 		}
-- 
1.7.0.4


