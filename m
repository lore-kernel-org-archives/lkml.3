Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaFGBXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:23:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35944 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <ak@linux.intel.com>, "Chen Yucong" <slaoub@gmail.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.959160530@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 85/92] hwpoison, hugetlb: lock_page/unlock_page does
 not match for handling a free hugepage
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yucong <slaoub@gmail.com>

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
[bwh: Backported to 3.2: s/num_poisoned_pages/bad_mce_pages/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/memory-failure.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1033,15 +1033,16 @@ int __memory_failure(unsigned long pfn,
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
-				atomic_long_sub(nr_pages, &mce_bad_pages);
-				return 0;
+			if (PageHWPoison(hpage)) {
+				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
+				    || (p != hpage && TestSetPageHWPoison(hpage))) {
+					atomic_long_sub(nr_pages, &mce_bad_pages);
+					unlock_page(hpage);
+					return 0;
+				}
 			}
 			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);

