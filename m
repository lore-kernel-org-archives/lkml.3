Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3AaP0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:26:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab3AaP0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:26:16 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HWPOISON: fix wrong num_poisoned_pages in handling memory error on thp
Date: Thu, 31 Jan 2013 10:25:58 -0500
Message-Id: <1359645958-9127-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

num_poisoned_pages counts up the number of pages isolated by memory errors.
But for thp, only one subpage is isolated because memory error handler
splits it, so it's wrong to add (1 << compound_trans_order).

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git mmotm-2013-01-23-17-04.orig/mm/memory-failure.c mmotm-2013-01-23-17-04/mm/memory-failure.c
index 9cab165..d5c50d6 100644
--- mmotm-2013-01-23-17-04.orig/mm/memory-failure.c
+++ mmotm-2013-01-23-17-04/mm/memory-failure.c
@@ -1039,7 +1039,14 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 		return 0;
 	}
 
-	nr_pages = 1 << compound_trans_order(hpage);
+	/*
+	 * If a thp is hit by a memory failure, it's supposed to be split.
+	 * So we should add only one to num_poisoned_pages for that case.
+	 */
+	if (PageHuge(p))
+		nr_pages = 1 << compound_trans_order(hpage);
+	else /* normal page or thp */
+		nr_pages = 1;
 	atomic_long_add(nr_pages, &num_poisoned_pages);
 
 	/*
-- 
1.7.11.7

