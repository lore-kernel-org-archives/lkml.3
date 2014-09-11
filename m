Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaIKUyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:54:53 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38294 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbaIKUyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:54:51 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 02/10] zsmalloc: add fullness group list for ZS_FULL zspages
Date: Thu, 11 Sep 2014 16:53:53 -0400
Message-Id: <1410468841-320-3-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
References: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ZS_FULL into section of fullness_group entries that are tracked in
the class fullness_lists.  Without this change, full zspages are untracked
by zsmalloc; they are only moved back onto one of the tracked lists
(ZS_ALMOST_FULL or ZS_ALMOST_EMPTY) when a zsmalloc user frees one or more
of its contained objects.

This is required for zsmalloc shrinking, which needs to be able to search
all zspages in a zsmalloc pool, to find one to shrink.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 03aa72f..fedb70f 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -159,16 +159,19 @@
 					ZS_SIZE_CLASS_DELTA + 1)
 
 /*
- * We do not maintain any list for completely empty or full pages
+ * We do not maintain any list for completely empty zspages,
+ * since a zspage is freed when it becomes empty.
  */
 enum fullness_group {
 	ZS_ALMOST_FULL,
 	ZS_ALMOST_EMPTY,
+	ZS_FULL,
+
 	_ZS_NR_FULLNESS_GROUPS,
 
 	ZS_EMPTY,
-	ZS_FULL
 };
+#define _ZS_NR_AVAILABLE_FULLNESS_GROUPS ZS_FULL
 
 /*
  * We assign a page to ZS_ALMOST_EMPTY fullness group when:
@@ -722,12 +725,12 @@ cleanup:
 	return first_page;
 }
 
-static struct page *find_get_zspage(struct size_class *class)
+static struct page *find_available_zspage(struct size_class *class)
 {
 	int i;
 	struct page *page;
 
-	for (i = 0; i < _ZS_NR_FULLNESS_GROUPS; i++) {
+	for (i = 0; i < _ZS_NR_AVAILABLE_FULLNESS_GROUPS; i++) {
 		page = class->fullness_list[i];
 		if (page)
 			break;
@@ -1013,7 +1016,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 	BUG_ON(class_idx != class->index);
 
 	spin_lock(&class->lock);
-	first_page = find_get_zspage(class);
+	first_page = find_available_zspage(class);
 
 	if (!first_page) {
 		spin_unlock(&class->lock);
-- 
1.8.3.1

