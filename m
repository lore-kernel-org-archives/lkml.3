Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3LPJCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:02:54 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:20829 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3LPJCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:02:52 -0500
Message-ID: <52AEC122.2000609@huawei.com>
Date: Mon, 16 Dec 2013 17:00:18 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>
CC: Xishi Qiu <qiuxishi@huawei.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: fix huge page reallocated in soft_offline_page
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The huge page may be reallocated in soft_offline_page, because
MIGRATE_ISOLATE can not keep the page until after setting PG_hwpoison.
alloc_huge_page()
	dequeue_huge_page_vma()
		dequeue_huge_page_node()
If the huge page was reallocated, we need to try offline it again.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/memory-failure.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b7c1716..f384249 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1505,8 +1505,11 @@ static int soft_offline_huge_page(struct page *page, int flags)
 		if (ret > 0)
 			ret = -EIO;
 	} else {
+		ret = dequeue_hwpoisoned_huge_page(hpage);
+		/* If the page was reallocated, we need to try again. */
+		if (ret)
+			return -EAGAIN;
 		set_page_hwpoison_huge_page(hpage);
-		dequeue_hwpoisoned_huge_page(hpage);
 		atomic_long_add(1 << compound_order(hpage),
 				&num_poisoned_pages);
 	}
@@ -1624,10 +1627,11 @@ static int __soft_offline_page(struct page *page, int flags)
  */
 int soft_offline_page(struct page *page, int flags)
 {
-	int ret;
+	int ret, retry_max = 3;
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_trans_head(page);
 
+retry:
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		return -EBUSY;
@@ -1663,8 +1667,15 @@ int soft_offline_page(struct page *page, int flags)
 			ret = __soft_offline_page(page, flags);
 	} else if (ret == 0) { /* for free pages */
 		if (PageHuge(page)) {
+			ret = dequeue_hwpoisoned_huge_page(hpage);
+			/* If the page was reallocated, we need to try again. */
+			if (ret) {
+				unset_migratetype_isolate(page,
+						MIGRATE_MOVABLE);
+				if (retry_max-- > 0)
+					goto retry;
+			}
 			set_page_hwpoison_huge_page(hpage);
-			dequeue_hwpoisoned_huge_page(hpage);
 			atomic_long_add(1 << compound_order(hpage),
 					&num_poisoned_pages);
 		} else {
@@ -1673,5 +1684,9 @@ int soft_offline_page(struct page *page, int flags)
 		}
 	}
 	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
+
+	if (ret == -EAGAIN && retry_max-- > 0)
+		goto retry;
+
 	return ret;
 }
-- 
1.7.1


