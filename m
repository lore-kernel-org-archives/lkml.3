Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaLIHvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:51:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42401 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaLIHvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:51:47 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-63-5486aa1147e3
From: Weijie Yang <weijie.yang@samsung.com>
To: iamjoonsoo.kim@lge.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        "'Rik van Riel'" <riel@redhat.com>, vbabka@suse.cz,
        "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Minchan Kim'" <minchan@kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/3] mm: page_isolation: remove redundant moving for isolated
 buddy pages
Date: Tue, 09 Dec 2014 15:50:35 +0800
Message-id: <000101d01384$fac61240$f05236c0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAThNCVxbEy5RTzQtSFUnDi5nPgOQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xgK7QqrYQg58eFnPWr2GzWL3J12Jl
	dzObxeVdc9gs7q35z2ox+d0zRotlX9+zW/y9sp7FYnZjH6PFkxP/WRy4PA6/ec/ssXPWXXaP
	Tas62Tw2fZrE7tH19gqTx4kZv1k83u+7yuZxZsERdo/Np6s9Pm+SC+CK4rJJSc3JLEst0rdL
	4MqYcec5e8EnvorLH7cxNTD+5e5i5OSQEDCRePDyPjOELSZx4d56ti5GLg4hgUWMEl//PWKG
	cP4wSizYvpMNpIpNQFvibv9GVhBbREBK4tT3E4wgRcwCi5gkzvU+ZwJJCAtESzydeBtsLIuA
	qsS7iWsZQWxeATuJzon72SFsQYkfk++xdDFyADWrS0yZkgsSZhaQl9i85i0zSFgCKPzory7E
	Kj2JLbu+MEKUiEtsPHKLZQKjwCwkg2YhDJqFZNAsJB0LGFlWMYqmFiQXFCel5xrpFSfmFpfm
	pesl5+duYgRH0TPpHYyrGiwOMQpwMCrx8GpYtoUIsSaWFVfmHmKU4GBWEuFVWgoU4k1JrKxK
	LcqPLyrNSS0+xCjNwaIkzqtkD5QSSE8sSc1OTS1ILYLJMnFwSjUwpsUzZZdXxWXsYVzRsHmW
	1roZSw8vvxPD962scJqz5ETL+W/Z786VT2CM+rH1WsokDna9C1v/aq1auXvilvts3ML/TJzi
	K+QlLl1jrFKf8PpafVJAQO8pbedS24ZdzzRae9Y7rpzu4MQyxX27Xaqw7Fkn9c1CXRFmBi2G
	LGtCsr7f5dY8dm2REktxRqKhFnNRcSIARCRisp4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ad53f92e(fix incorrect isolation behavior by rechecking migratetype)
patch series describe the race between page isolation and alloc/free path, and
fix the race.

Now, after the pageblock has been isolated, free buddy pages are already in
the free_list[MIGRATE_ISOLATE] and will not be allocated for usage. So the
current freepage_migratetype check is unnecessary and it will cause redundant
page move. That is to say, even if the buddy page's migratetype is not
MIGRATE_ISOLATE, the page is in free_list[MIGRATE_ISOLATE], we just move it
from free_list[MIGRATE_ISOLATE] to free_list[MIGRATE_ISOLATE].

This patch removes the unnecessary freepage_migratetype check and the
redundant page moving.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/page_isolation.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index c8778f7..6e5174d 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -221,23 +221,8 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
 			continue;
 		}
 		page = pfn_to_page(pfn);
-		if (PageBuddy(page)) {
-			/*
-			 * If race between isolatation and allocation happens,
-			 * some free pages could be in MIGRATE_MOVABLE list
-			 * although pageblock's migratation type of the page
-			 * is MIGRATE_ISOLATE. Catch it and move the page into
-			 * MIGRATE_ISOLATE list.
-			 */
-			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE) {
-				struct page *end_page;
-
-				end_page = page + (1 << page_order(page)) - 1;
-				move_freepages(page_zone(page), page, end_page,
-						MIGRATE_ISOLATE);
-			}
+		if (PageBuddy(page))
 			pfn += 1 << page_order(page);
-		}
 		else if (page_count(page) == 0 &&
 			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
 			pfn += 1;
-- 
1.7.10.4


