Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaIKTb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:31:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:42850 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaIKTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:31:28 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] mm: dmapool: add/remove sysfs file outside of the pool lock
Date: Thu, 11 Sep 2014 21:31:16 +0200
Message-Id: <1410463876-21265-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cat /sys/…/pools followed by removal the device leads to:

|======================================================
|[ INFO: possible circular locking dependency detected ]
|3.17.0-rc4+ #1498 Not tainted
|-------------------------------------------------------
|rmmod/2505 is trying to acquire lock:
| (s_active#28){++++.+}, at: [<c017f754>] kernfs_remove_by_name_ns+0x3c/0x88
|
|but task is already holding lock:
| (pools_lock){+.+.+.}, at: [<c011494c>] dma_pool_destroy+0x18/0x17c
|
|which lock already depends on the new lock.

The problem is the lock order of pools_lock and kernfs_mutex in
dma_pool_destroy() vs show_pools().

This patch breaks out the creation of the sysfs file outside of the
pools_lock mutex.
In theory we would have to create the link in the error path of
device_create_file() in case the dev->dma_pools list is not empty. In
reality I doubt that there will be a single device creating dma-pools in
parallel where it would matter.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 mm/dmapool.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 306baa594f95..0cad8ee7891f 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -132,6 +132,7 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 {
 	struct dma_pool *retval;
 	size_t allocation;
+	bool empty = false;
 
 	if (align == 0) {
 		align = 1;
@@ -173,14 +174,22 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	INIT_LIST_HEAD(&retval->pools);
 
 	mutex_lock(&pools_lock);
-	if (list_empty(&dev->dma_pools) &&
-	    device_create_file(dev, &dev_attr_pools)) {
-		kfree(retval);
-		return NULL;
-	} else
-		list_add(&retval->pools, &dev->dma_pools);
+	if (list_empty(&dev->dma_pools))
+		empty = true;
+	list_add(&retval->pools, &dev->dma_pools);
 	mutex_unlock(&pools_lock);
-
+	if (empty) {
+		int err;
+
+		err = device_create_file(dev, &dev_attr_pools);
+		if (err) {
+			mutex_lock(&pools_lock);
+			list_del(&retval->pools);
+			mutex_unlock(&pools_lock);
+			kfree(retval);
+			return NULL;
+		}
+	}
 	return retval;
 }
 EXPORT_SYMBOL(dma_pool_create);
@@ -251,11 +260,15 @@ static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
  */
 void dma_pool_destroy(struct dma_pool *pool)
 {
+	bool empty = false;
+
 	mutex_lock(&pools_lock);
 	list_del(&pool->pools);
 	if (pool->dev && list_empty(&pool->dev->dma_pools))
-		device_remove_file(pool->dev, &dev_attr_pools);
+		empty = true;
 	mutex_unlock(&pools_lock);
+	if (empty)
+		device_remove_file(pool->dev, &dev_attr_pools);
 
 	while (!list_empty(&pool->page_list)) {
 		struct dma_page *page;
-- 
2.1.0

