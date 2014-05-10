Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaEJCUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 22:20:16 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49402 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaEJCUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 22:20:14 -0400
Message-ID: <1399688409.28090.0.camel@cyc>
Subject: [PATCH] HWPOSION, hugetlb: lock_page/unlock_page does not match for
 handling a free hugepage
From: Chen Yucong <slaoub@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>
Date: Sat, 10 May 2014 10:20:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For handling a free hugepage in memory failure, the race will happen if
another thread hwpoisoned this hugepage concurrently. So we need to
check PageHWPoison instead of !PageHWPoison.

If hwpoison_filter(p) returns true or a race happens, then we need to
unlock_page(hpage).

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
mm/memory-failure.c |   15 ++++++++-------
1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 35ef28a..dbf8922 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1081,15 +1081,16 @@ int memory_failure(unsigned long pfn, int
trapno, int flags)
 			return 0;
 		} else if (PageHuge(hpage)) {
 			/*
-			 * Check "just unpoisoned", "filter hit", and
-			 * "race with other subpage."
+			 * Check "filter hit" and "race with other subpage."
 			 */
 			lock_page(hpage);
-			if (!PageHWPoison(hpage)
-			    || (hwpoison_filter(p) && TestClearPageHWPoison(p))
-			    || (p != hpage && TestSetPageHWPoison(hpage))) {
-				atomic_long_sub(nr_pages, &num_poisoned_pages);
-				return 0;
+			if (PageHWPoison(hpage)) {
+				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
+				    || (p != hpage && TestSetPageHWPoison(hpage))) {
+					atomic_long_sub(nr_pages, &num_poisoned_pages);
+					unlock_page(hpage);
+					return 0;
+				}
 			}
 			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);
-- 
1.7.10.4




