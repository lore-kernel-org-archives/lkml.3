Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3HZIrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:47:31 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57325 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab3HZIqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:46:36 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 3/10] mm/hwpoison: fix race against poison thp
Date: Mon, 26 Aug 2013 16:46:07 +0800
Message-Id: <1377506774-5377-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377506774-5377-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377506774-5377-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082619-3568-0000-0000-0000042343CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2:
 * unpoison thp fail  

There is a race between hwpoison page and unpoison page, memory_failure
set the page hwpoison and increase num_poisoned_pages without hold page
lock, and one page count will be accounted against thp for num_poisoned_pages.
However, unpoison can occur before memory_failure hold page lock and
split transparent hugepage, unpoison will decrease num_poisoned_pages
by 1 << compound_order since memory_failure has not yet split transparent
hugepage with page lock held. That means we account one page for hwpoison
and 1 << compound_order for unpoison. This patch fix it by inserting a 
PageTransHuge check before doing TestClearPageHWPoison, unpoison failed 
without clearing PageHWPoison and decreasing num_poisoned_pages.


            A                                                 	B
    	memory_failue
        TestSetPageHWPoison(p);
        if (PageHuge(p))
            nr_pages = 1 << compound_order(hpage);
        else
            nr_pages = 1;
        atomic_long_add(nr_pages, &num_poisoned_pages);
															unpoison_memory
															nr_pages = 1<< compound_trans_order(page);
															if(TestClearPageHWPoison(p))
																atomic_long_sub(nr_pages, &num_poisoned_pages);
        lock page
        if (!PageHWPoison(p))
        	unlock page and return
        hwpoison_user_mappings
        if (PageTransHuge(hpage))
        	split_huge_page(hpage);


Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5a4f4d6..a6c4752 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1339,6 +1339,16 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
+	/*
+	 * unpoison_memory() can encounter thp only when the thp is being
+	 * worked by memory_failure() and the page lock is not held yet.
+	 * In such case, we yield to memory_failure() and make unpoison fail.
+	 */
+	if (PageTransHuge(page)) {
+		pr_info("MCE: Memory failure is now running on %#lx\n", pfn);
+			return 0;
+	}
+
 	nr_pages = 1 << compound_order(page);
 
 	if (!get_page_unless_zero(page)) {
-- 
1.8.1.2

