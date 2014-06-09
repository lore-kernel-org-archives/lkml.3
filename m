Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaFIJSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:18:12 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58382 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754702AbaFIIvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:23 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chen Yucong <slaoub@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 032/146] hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage
Date: Mon,  9 Jun 2014 10:49:27 +0200
Message-Id: <62e9f1db76bbf65753ad64f66dabce32438488c9.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Yucong <slaoub@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b985194c8c0a130ed155b71662e39f7eaea4876f upstream.

For handling a free hugepage in memory failure, the race will happen if
another thread hwpoisoned this hugepage concurrently.  So we need to
check PageHWPoison instead of !PageHWPoison.

If hwpoison_filter(p) returns true or a race happens, then we need to
unlock_page(hpage).

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/memory-failure.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5ea3cf734138..9f1b0ff6cb65 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1085,15 +1085,16 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
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
1.9.3

