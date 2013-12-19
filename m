Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3LSShO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:37:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab3LSShJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:37:09 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: [PATCH] fs/proc/page.c: add PageAnon check to surely detect thp
Date: Thu, 19 Dec 2013 13:36:54 -0500
Message-Id: <1387478214-10369-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stable_page_flags() checks !PageHuge && PageTransCompound && PageLRU to
know that a specified page is thp or not. But sometimes it's not enough
and we fail to detect thp when the thp is on pagevec. This happens only
for a few seconds after LRU list operations, but it makes it difficult to
control our applications depending on this flag.

So this patch adds another check PageAnon to detect thps on pagevec.
It might not give the future extensibility for thp pagecache, but it's
OK at least for now.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/proc/page.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git v3.13-rc4.orig/fs/proc/page.c v3.13-rc4/fs/proc/page.c
index b8730d9ebaee..cab84b6272ed 100644
--- v3.13-rc4.orig/fs/proc/page.c
+++ v3.13-rc4/fs/proc/page.c
@@ -118,10 +118,12 @@ u64 stable_page_flags(struct page *page)
 	/*
 	 * PageTransCompound can be true for non-huge compound pages (slab
 	 * pages or pages allocated by drivers with __GFP_COMP) because it
-	 * just checks PG_head/PG_tail, so we need to check PageLRU to make
-	 * sure a given page is a thp, not a non-huge compound page.
+	 * just checks PG_head/PG_tail, so we need to check PageLRU/PageAnon
+	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
-	else if (PageTransCompound(page) && PageLRU(compound_trans_head(page)))
+	else if (PageTransCompound(page) &&
+		 (PageLRU(compound_trans_head(page)) ||
+		  PageAnon(compound_trans_head(page))))
 		u |= 1 << KPF_THP;
 
 	/*
-- 
1.8.3.1

