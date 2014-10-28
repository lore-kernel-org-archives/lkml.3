Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaJ1Afy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:35:54 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63132 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaJ1Afw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:35:52 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        lauraa@codeaurora.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com, gioh.kim@lge.com
Subject: [PATCH 3/3] staging: ion: limit pool size
Date: Tue, 28 Oct 2014 09:36:45 +0900
Message-Id: <1414456605-26049-4-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414456605-26049-1-git-send-email-gioh.kim@lge.com>
References: <1414456605-26049-1-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch limits pool size by page unit.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/staging/android/ion/Kconfig         |    8 ++++++++
 drivers/staging/android/ion/ion_page_pool.c |   24 ++++++++++++++----------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index 3452346..06b4466 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -33,3 +33,11 @@ config ION_TEGRA
 	help
 	  Choose this option if you wish to use ion on an nVidia Tegra.
 
+config ION_POOL_LIMIT
+	int "Limit count of pages in pool"
+	depends on ION
+	default "0"
+	help
+	  Set the maximum number of pages the individual pool can have.
+	  This doesn't care the total pages of all pools.
+	  0 means no limit.
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 165152f..15d1ac8 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
+#include <linux/kconfig.h>
 #include "ion_priv.h"
 
 static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
@@ -41,8 +42,21 @@ static void ion_page_pool_free_pages(struct ion_page_pool *pool,
 	__free_pages(page, pool->order);
 }
 
+static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
+{
+	int count = pool->low_count;
+
+	if (high)
+		count += pool->high_count;
+
+	return count << pool->order;
+}
+
 static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
 {
+	if (CONFIG_ION_POOL_LIMIT && ion_page_pool_total(pool, 1) > POOL_LIMIT)
+		return 1;
+
 	mutex_lock(&pool->mutex);
 	if (PageHighMem(page)) {
 		list_add_tail(&page->lru, &pool->high_items);
@@ -103,16 +117,6 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
 		ion_page_pool_free_pages(pool, page);
 }
 
-static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
-{
-	int count = pool->low_count;
-
-	if (high)
-		count += pool->high_count;
-
-	return count << pool->order;
-}
-
 int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
 				int nr_to_scan)
 {
-- 
1.7.9.5

