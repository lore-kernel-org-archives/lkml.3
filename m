Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaJXGqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:46:42 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:39510 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaJXGqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:46:40 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com, gioh.kim@lge.com
Subject: [RFCv2 3/3] staging: ion: limit pool size
Date: Fri, 24 Oct 2014 15:47:28 +0900
Message-Id: <1414133248-639-4-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414133248-639-1-git-send-email-gioh.kim@lge.com>
References: <1414133248-639-1-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch limits pool size by page unit.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/staging/android/ion/Kconfig         |    4 ++++
 drivers/staging/android/ion/ion_page_pool.c |   26 ++++++++++++++++----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index 3452346..e6b1a54 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -33,3 +33,7 @@ config ION_TEGRA
 	help
 	  Choose this option if you wish to use ion on an nVidia Tegra.
 
+config ION_POOL_LIMIT
+	int "Limit count of pages in pool"
+	depends on ION
+	default "0"
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 165152f..d63e93f 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -22,8 +22,11 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
+#include <linux/kconfig.h>
 #include "ion_priv.h"
 
+#define POOL_LIMIT CONFIG_ION_POOL_LIMIT
+
 static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
 {
 	struct page *page = alloc_pages(pool->gfp_mask, pool->order);
@@ -41,8 +44,21 @@ static void ion_page_pool_free_pages(struct ion_page_pool *pool,
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
+	if (POOL_LIMIT && ion_page_pool_total(pool, 1) > POOL_LIMIT)
+		return 1;
+
 	mutex_lock(&pool->mutex);
 	if (PageHighMem(page)) {
 		list_add_tail(&page->lru, &pool->high_items);
@@ -103,16 +119,6 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
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

