Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaKFIJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:09:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51207 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaKFIJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:09:14 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-5c-545b2ca085bf
From: Weijie Yang <weijie.yang@samsung.com>
To: kamezawa.hiroyu@jp.fujitsu.com, "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        mina86@mina86.com, "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: [PATCH 1/2] mm: page_isolation: check pfn validity before access
Date: Thu, 06 Nov 2014 16:08:02 +0800
Message-id: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/5mMkxtvfMxgbZT5m84Ibv7FhLiA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jAd0FOtEhBmu+6lrMWb+GzWLm7NlM
	Fpd3zWGzuLfmP6vF5HfPGC0WHG9htVj29T27xZMT/1kcODx2zrrL7nHiySU2j02rOoHEp0lA
	7ozfLB7r/rxi8th8utrj8ya5AI4oLpuU1JzMstQifbsErozlzR2sBUvZK+7tXc7ewPiZtYuR
	k0NCwETiz6IWZghbTOLCvfVsILaQwCJGidnnnLsYuYDsP4wSbz+2sIMk2AS0Je72bwRrFhFw
	kziydx8jSBGzwEVGiWPTL4JNEhbwlFg8/QpLFyMHB4uAqsSGnQUgYV4BO4lN7b/YIGxBiR+T
	74GVMAuoS0yZkgsSZhaQl9i85i0zSFgCKPzory7EJj2JX92fmSBKxCU2HrnFMoFRYBaSQbMQ
	Bs1CMmgWko4FjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKj45n0DsZVDRaHGAU4GJV4
	eHccjQoRYk0sK67MPcQowcGsJMLbKx0dIsSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBA
	emJJanZqakFqEUyWiYNTqoFRMXzxVtP9E+d8a+aUu3Zk+ruNt7drVXH9XSqVtIHdqrs37k12
	2szbl28pHpA55LLtDZvP/sUrvJ3rq6ea9z96o2RVdezOxomsN1dy9fzi/8ooXzejzUVybgBf
	WaXMEaYnDVcyBKzDNQ5cuzv3rdtWDiH+L4n5QolH8o3+5VvfT1aWOpMhzt2jxFKckWioxVxU
	nAgAWIwlyooCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the undo path of start_isolate_page_range(), we need to check
the pfn validity before access its page, or it will trigger an
addressing exception if there is hole in the zone.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/page_isolation.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index d1473b2..3ddc8b3 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -137,8 +137,11 @@ int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 undo:
 	for (pfn = start_pfn;
 	     pfn < undo_pfn;
-	     pfn += pageblock_nr_pages)
-		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
+	     pfn += pageblock_nr_pages) {
+		page = __first_valid_page(pfn, pageblock_nr_pages);
+		if (page)
+			unset_migratetype_isolate(page, migratetype);
+	}
 
 	return -EBUSY;
 }
-- 
1.7.0.4


