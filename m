Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3LMWlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:41:53 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57333 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3LMW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:12 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 040/115] gpu: ion: Fix lockdep issue in ion_page_pool
Date: Fri, 13 Dec 2013 14:24:14 -0800
Message-Id: <1386973529-4884-41-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Currently the mutex is held while kmalloc is called, under a low memory
condition this might trigger the shrinker which also takes this mutex.
Refactor so the mutex is not held during allocation.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_page_pool.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index ea45380..20790eb 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -53,6 +53,8 @@ static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
 	item = kmalloc(sizeof(struct ion_page_pool_item), GFP_KERNEL);
 	if (!item)
 		return -ENOMEM;
+
+	mutex_lock(&pool->mutex);
 	item->page = page;
 	if (PageHighMem(page)) {
 		list_add_tail(&item->list, &pool->high_items);
@@ -61,6 +63,7 @@ static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
 		list_add_tail(&item->list, &pool->low_items);
 		pool->low_count++;
 	}
+	mutex_unlock(&pool->mutex);
 	return 0;
 }
 
@@ -110,9 +113,7 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page* page)
 {
 	int ret;
 
-	mutex_lock(&pool->mutex);
 	ret = ion_page_pool_add(pool, page);
-	mutex_unlock(&pool->mutex);
 	if (ret)
 		ion_page_pool_free_pages(pool, page);
 }
-- 
1.8.3.2

