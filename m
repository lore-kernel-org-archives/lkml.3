Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3HBCIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:08:47 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62998 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3HBCIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:08:04 -0400
X-AuditID: 9c93016f-b7b05ae000002bbd-50-51fb1481721a
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 2/4] mm, migrate: allocation new page lazyily in unmap_and_move()
Date: Fri,  2 Aug 2013 11:07:57 +0900
Message-Id: <1375409279-16919-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a new page and then go out immediately if some condition
is met. Allocation has overhead in comparison with some condition check,
so allocating lazyily is preferable solution.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/migrate.c b/mm/migrate.c
index 6f0c244..86db87e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -864,10 +864,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 {
 	int rc = 0;
 	int *result = NULL;
-	struct page *newpage = get_new_page(page, private, &result);
-
-	if (!newpage)
-		return -ENOMEM;
+	struct page *newpage = NULL;
 
 	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -878,6 +875,10 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 		if (unlikely(split_huge_page(page)))
 			goto out;
 
+	newpage = get_new_page(page, private, &result);
+	if (!newpage)
+		return -ENOMEM;
+
 	rc = __unmap_and_move(page, newpage, force, mode);
 
 	if (unlikely(rc == MIGRATEPAGE_BALLOON_SUCCESS)) {
@@ -908,7 +909,8 @@ out:
 	 * Move the new page to the LRU. If migration was not successful
 	 * then this will free the page.
 	 */
-	putback_lru_page(newpage);
+	if (newpage)
+		putback_lru_page(newpage);
 	if (result) {
 		if (rc)
 			*result = rc;
-- 
1.7.9.5

