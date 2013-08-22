Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3HVJsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:48:46 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37933 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3HVJso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:48:44 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 3/6] mm/hwpoison: fix num_poisoned_pages error statistics for thp 
Date: Thu, 22 Aug 2013 17:48:24 +0800
Message-Id: <1377164907-24801-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082220-3568-0000-0000-0000041F2DA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between hwpoison page and unpoison page, memory_failure 
set the page hwpoison and increase num_poisoned_pages without hold page 
lock, and one page count will be accounted against thp for num_poisoned_pages.
However, unpoison can occur before memory_failure hold page lock and 
split transparent hugepage, unpoison will decrease num_poisoned_pages 
by 1 << compound_order since memory_failure has not yet split transparent 
hugepage with page lock held. That means we account one page for hwpoison
and 1 << compound_order for unpoison. This patch fix it by decrease one 
account for num_poisoned_pages against no hugetlbfs pages case.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5092e06..6bfd51e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1350,7 +1350,7 @@ int unpoison_memory(unsigned long pfn)
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
-			atomic_long_sub(nr_pages, &num_poisoned_pages);
+			atomic_long_dec(&num_poisoned_pages);
 		pr_info("MCE: Software-unpoisoned free page %#lx\n", pfn);
 		return 0;
 	}
-- 
1.8.1.2

