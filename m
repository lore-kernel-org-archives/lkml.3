Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3DVIZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:25:03 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48921 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3DVIZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:25:02 -0400
X-AuditID: 9c930197-b7bb3ae000000fa9-4d-5174f3db2feb
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] mm, highmem: remove useless virtual variable in page_address_map
Date: Mon, 22 Apr 2013 17:26:28 +0900
Message-Id: <1366619188-28087-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get virtual address without virtual field.
So remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/highmem.c b/mm/highmem.c
index b32b70c..8f4c250 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -320,7 +320,6 @@ EXPORT_SYMBOL(kunmap_high);
  */
 struct page_address_map {
 	struct page *page;
-	void *virtual;
 	struct list_head list;
 };
 
@@ -362,7 +361,10 @@ void *page_address(const struct page *page)
 
 		list_for_each_entry(pam, &pas->lh, list) {
 			if (pam->page == page) {
-				ret = pam->virtual;
+				int nr;
+
+				nr = pam - page_address_map;
+				ret = PKMAP_ADDR(nr);
 				goto done;
 			}
 		}
@@ -391,7 +393,6 @@ void set_page_address(struct page *page, void *virtual)
 	if (virtual) {		/* Add */
 		pam = &page_address_maps[PKMAP_NR((unsigned long)virtual)];
 		pam->page = page;
-		pam->virtual = virtual;
 
 		spin_lock_irqsave(&pas->lock, flags);
 		list_add_tail(&pam->list, &pas->lh);
-- 
1.7.9.5

