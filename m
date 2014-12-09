Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaLIHxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:53:01 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54173 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLIHw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:52:59 -0500
X-AuditID: cbfee61a-f79c06d000004e71-74-5486aa595d5a
From: Weijie Yang <weijie.yang@samsung.com>
To: iamjoonsoo.kim@lge.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        "'Rik van Riel'" <riel@redhat.com>, vbabka@suse.cz,
        "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Minchan Kim'" <minchan@kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/3] mm: page_isolation: remove unnecessary
 freepage_migratetype check for unused page
Date: Tue, 09 Dec 2014 15:51:49 +0800
Message-id: <000201d01385$25a6c950$70f45bf0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAThN1KjmiC0dJjTJCURinwlAL8Yg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xgG7kqrYQgykTLSzmrF/DZrF6k6/F
	yu5mNovLu+awWdxb85/VYvK7Z4wWy76+Z7f4e2U9i8Xsxj5Giycn/rM4cHkcfvOe2WPnrLvs
	HptWdbJ5bPo0id2j6+0VJo8TM36zeLzfd5XN48yCI+wem09Xe3zeJBfAFcVlk5Kak1mWWqRv
	l8CV8bXjCkvBJJ6KMw2X2BoYv3F2MXJySAiYSEzrm88CYYtJXLi3nq2LkYtDSGARo8T7c3uY
	IJw/jBK7L11jB6liE9CWuNu/kRXEFhGQkjj1/QQjSBGzwCImiXO9z5lAEsICGRI3pj1jA7FZ
	BFQlXq7aB9bAK2An0XHiDRuELSjxY/I9oNUcQM3qElOm5IKEmQXkJTavecsMEpYACj/6qwux
	Sk9iybOLzBAl4hIbj9ximcAoMAvJoFkIg2YhGTQLSccCRpZVjKKpBckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGMFx9ExqB+PKBotDjAIcjEo8vJqWbSFCrIllxZW5hxglOJiVRHiVlgKFeFMSK6tS
	i/Lji0pzUosPMUpzsCiJ8yrZA6UE0hNLUrNTUwtSi2CyTBycUg2MwVIzrj9+tcTa2Thbpdun
	4UjzZ4WjjEUu886d9XNU3ftIoVRXI+fQW6H39zqvaT/5wdhYMzGPIerqt523io+cnzzh6PEj
	5ZdEqzx2+KvJB/RGM/ZUXjXh6Kr1CNfoWG8TqLVwwT8RtosdiWqT8/oXdJ4sMjioPrd7brlZ
	W81cPXZGM8EaXTslluKMREMt5qLiRAAYcnfGnwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when we test the pages in a range is free or not, there is a little
chance we encounter some page which is not in buddy but page_count is 0.
That means that page could be in the page-freeing path but not in the
buddy freelist, such as in pcplist or wait for the zone->lock which the
tester is holding.

Back to the freepage_migratetype, we use it for a cached value for decide
which free-list the page go when freeing page. If the pageblock is isolated
the page will go to free-list[MIGRATE_ISOLATE] even if the cached type is
not MIGRATE_ISOLATE, the commit ad53f92e(fix incorrect isolation behavior
by rechecking migratetype) patch series have ensure this.

So the freepage_migratetype check for page_count==0 page in
__test_page_isolated_in_pageblock() is meaningless.
This patch removes the unnecessary freepage_migratetype check.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/page_isolation.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 6e5174d..f7c9183 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -223,8 +223,7 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
 		page = pfn_to_page(pfn);
 		if (PageBuddy(page))
 			pfn += 1 << page_order(page);
-		else if (page_count(page) == 0 &&
-			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
+		else if (page_count(page) == 0)
 			pfn += 1;
 		else if (skip_hwpoisoned_pages && PageHWPoison(page)) {
 			/*
-- 
1.7.10.4


