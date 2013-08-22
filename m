Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3HVJsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:48:50 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35788 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3HVJss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:48:48 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 6/6] mm/hwpoison: centralize set PG_hwpoison flag and increase num_poisoned_pages
Date: Thu, 22 Aug 2013 17:48:27 +0800
Message-Id: <1377164907-24801-6-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082209-5490-0000-0000-00000406A153
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

soft_offline_page will invoke __soft_offline_page for in-use normal pages 
and soft_offline_huge_page for in-use hugetlbfs pages. Both of them will 
done the same effort as for soft offline free pages set PG_hwpoison, increase 
num_poisoned_pages etc, this patch centralize do them in soft_offline_page.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 0a52571..3226de1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1486,15 +1486,9 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL,
 				MIGRATE_SYNC);
 	put_page(hpage);
-	if (ret) {
+	if (ret)
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
-	} else {
-		set_page_hwpoison_huge_page(hpage);
-		dequeue_hwpoisoned_huge_page(hpage);
-		atomic_long_add(1 << compound_order(hpage),
-				&num_poisoned_pages);
-	}
 	return ret;
 }
 
@@ -1530,8 +1524,6 @@ static int __soft_offline_page(struct page *page, int flags)
 	if (ret == 1) {
 		put_page(page);
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
-		SetPageHWPoison(page);
-		atomic_long_inc(&num_poisoned_pages);
 		return 0;
 	}
 
@@ -1572,11 +1564,9 @@ static int __soft_offline_page(struct page *page, int flags)
 				lru_add_drain_all();
 			if (!is_free_buddy_page(page))
 				drain_all_pages();
-			SetPageHWPoison(page);
 			if (!is_free_buddy_page(page))
 				pr_info("soft offline: %#lx: page leaked\n",
 					pfn);
-			atomic_long_inc(&num_poisoned_pages);
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
@@ -1633,7 +1623,9 @@ int soft_offline_page(struct page *page, int flags)
 			ret = soft_offline_huge_page(page, flags);
 		else
 			ret = __soft_offline_page(page, flags);
-	} else { /* for free pages */
+	}
+
+	if (!ret) {
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
 			dequeue_hwpoisoned_huge_page(hpage);
-- 
1.8.1.2

