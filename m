Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3HVJtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:49:32 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54152 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3HVJsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:48:45 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 2/6] mm/hwpoison: don't need to hold compound lock for hugetlbfs page 
Date: Thu, 22 Aug 2013 17:48:23 +0800
Message-Id: <1377164907-24801-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082209-7014-0000-0000-0000037FAA17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compound lock is introduced by commit e9da73d67("thp: compound_lock."), 
it is used to serialize put_page against __split_huge_page_refcount(). 
In addition, transparent hugepages will be splitted in hwpoison handler 
and just one subpage will be poisoned. There is unnecessary to hold 
compound lock for hugetlbfs page. This patch replace compound_trans_order 
by compond_order in the place where the page is hugetlbfs page.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2c13aa7..5092e06 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -206,7 +206,7 @@ static int kill_proc(struct task_struct *t, unsigned long addr, int trapno,
 #ifdef __ARCH_SI_TRAPNO
 	si.si_trapno = trapno;
 #endif
-	si.si_addr_lsb = compound_trans_order(compound_head(page)) + PAGE_SHIFT;
+	si.si_addr_lsb = compound_order(compound_head(page)) + PAGE_SHIFT;
 
 	if ((flags & MF_ACTION_REQUIRED) && t == current) {
 		si.si_code = BUS_MCEERR_AR;
@@ -983,7 +983,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 static void set_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
-	int nr_pages = 1 << compound_trans_order(hpage);
+	int nr_pages = 1 << compound_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		SetPageHWPoison(hpage + i);
 }
@@ -991,7 +991,7 @@ static void set_page_hwpoison_huge_page(struct page *hpage)
 static void clear_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
-	int nr_pages = 1 << compound_trans_order(hpage);
+	int nr_pages = 1 << compound_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		ClearPageHWPoison(hpage + i);
 }
@@ -1491,7 +1491,7 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	} else {
 		set_page_hwpoison_huge_page(hpage);
 		dequeue_hwpoisoned_huge_page(hpage);
-		atomic_long_add(1 << compound_trans_order(hpage),
+		atomic_long_add(1 << compound_order(hpage),
 				&num_poisoned_pages);
 	}
 	return ret;
@@ -1551,7 +1551,7 @@ int soft_offline_page(struct page *page, int flags)
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
 			dequeue_hwpoisoned_huge_page(hpage);
-			atomic_long_add(1 << compound_trans_order(hpage),
+			atomic_long_add(1 << compound_order(hpage),
 					&num_poisoned_pages);
 		} else {
 			SetPageHWPoison(page);
-- 
1.8.1.2

