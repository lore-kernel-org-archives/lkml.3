Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3BDK1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:27:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:27445 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3BDK12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:27:28 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-99-510f8d0f4dd9
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: m.szyprowski@samsung.com, akpm@linux-foundation.org, minchan@kernel.org,
        mgorman@suse.de, kyungmin.park@samsung.com
Subject: [PATCH] mm: cma: fix accounting of CMA pages placed in high memory
Date: Mon, 04 Feb 2013 11:27:05 +0100
Message-id: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t9jQV3+Xv5AgylfRCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG6etNTAX9bBVfT71la2DsZe1i5OCQEDCRuN9l1cXICWSKSVy4
	t56ti5GLQ0hgOqPEt2OvWCCcFUwSO9/PYQKpYhMwlOh628UGYosANe9unssIYjMLVErMXLab
	GWSosIC3xLuP5SBhFgFViTMvt7KD2LwC7hJrH71lg9irIDFnks0ERu4FjAyrGEVTC5ILipPS
	c430ihNzi0vz0vWS83M3MYK990x6B+OqBotDjAIcjEo8vAy/+AKFWBPLiitzDzFKcDArifBe
	NQIK8aYkVlalFuXHF5XmpBYfYpTmYFES52U89SRASCA9sSQ1OzW1ILUIJsvEwSkFDITre4rn
	LJ6hHNryR7ZhUek5lj27Glg27tjeton93oyf0gYsSea5N4NVmeJtApaYTLzY4r7xf4h35QWL
	rtlnVrHM39p6iHn13gcFHvv9NPXzvjRaXLS6czxM3J7D8PKdkK033fdVlMksv9xcYF+vOPu7
	i1Igp+axTT94P3iv+ap6me3swZtHNyuxFGckGmoxFxUnAgBloUCd2gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The total number of low memory pages is determined as
totalram_pages - totalhigh_pages, so without this patch all CMA
pageblocks placed in highmem were accounted to low memory.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f5bab0a..6415d93 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -773,6 +773,10 @@ void __init init_cma_reserved_pageblock(struct page *page)
 	set_pageblock_migratetype(page, MIGRATE_CMA);
 	__free_pages(page, pageblock_order);
 	totalram_pages += pageblock_nr_pages;
+#ifdef CONFIG_HIGHMEM
+	if (PageHighMem(page))
+		totalhigh_pages += pageblock_nr_pages;
+#endif
 }
 #endif
 
-- 
1.7.9.5

