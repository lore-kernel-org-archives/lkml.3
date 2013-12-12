Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3LLNP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:15:27 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:6425 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3LLNPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:15:25 -0500
Message-ID: <52A9B69D.50307@huawei.com>
Date: Thu, 12 Dec 2013 21:14:05 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Mel Gorman <mgorman@suse.de>,
        "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, qiuxishi <qiuxishi@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/memory-failure.c: recheck PageHuge() after hugetlb page
 migrate successfull
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a successful hugetlb page migration by soft offline, the source page
will either be freed into hugepage_freelists or buddy(over-commit page). If page is in
buddy, page_hstate(page) will be NULL. It will hit a NULL pointer
dereference in dequeue_hwpoisoned_huge_page().

[  890.677918] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000058
[  890.685741] IP: [<ffffffff81163761>]
dequeue_hwpoisoned_huge_page+0x131/0x1d0
[  890.692861] PGD c23762067 PUD c24be2067 PMD 0
[  890.697314] Oops: 0000 [#1] SMP

So check PageHuge(page) after call migrate_pages() successfull.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/memory-failure.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b7c1716..e5567f2 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1471,7 +1471,8 @@ static int get_any_page(struct page *page, unsigned long pfn, int flags)
 
 static int soft_offline_huge_page(struct page *page, int flags)
 {
-	int ret;
+	int ret, i;
+	unsigned long nr_pages;
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_head(page);
 	LIST_HEAD(pagelist);
@@ -1489,6 +1490,8 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	}
 	unlock_page(hpage);
 
+	nr_pages = 1 << compound_order(hpage);
+
 	/* Keep page count to indicate a given hugepage is isolated. */
 	list_move(&hpage->lru, &pagelist);
 	ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
@@ -1505,10 +1508,16 @@ static int soft_offline_huge_page(struct page *page, int flags)
 		if (ret > 0)
 			ret = -EIO;
 	} else {
-		set_page_hwpoison_huge_page(hpage);
-		dequeue_hwpoisoned_huge_page(hpage);
-		atomic_long_add(1 << compound_order(hpage),
-				&num_poisoned_pages);
+		/* over-commit hugetlb page will be freed into buddy */
+		if (PageHuge(page)) {
+			set_page_hwpoison_huge_page(hpage);
+			dequeue_hwpoisoned_huge_page(hpage);
+		} else {
+			for (i = 0; i < nr_pages; i++)
+				SetPageHWPoison(hpage + i);
+		}
+
+		atomic_long_add(nr_pages, &num_poisoned_pages);
 	}
 	return ret;
 }
-- 
1.8.2.2


