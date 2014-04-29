Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaD2Cxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:53:41 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60426 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaD2Cxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:53:40 -0400
Date: Tue, 29 Apr 2014 11:53:10 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: akpm@linux-foundation.org
Cc: daeseok.youn@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dmapool: remove redundant NULL check for dev in
 dma_pool_create()
Message-ID: <20140429025310.GA5913@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"dev" cannot be NULL because it is already checked before
calling dma_pool_create().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
If dev can be NULL, it has NULL deferencing when kmalloc_node()
is called after enabling CONFIG_NUMA.

 mm/dmapool.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index c69781e..38dfcdd 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -170,24 +170,16 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	retval->boundary = boundary;
 	retval->allocation = allocation;
 
-	if (dev) {
-		int ret;
+	INIT_LIST_HEAD(&retval->pools);
 
-		mutex_lock(&pools_lock);
-		if (list_empty(&dev->dma_pools))
-			ret = device_create_file(dev, &dev_attr_pools);
-		else
-			ret = 0;
-		/* note:  not currently insisting "name" be unique */
-		if (!ret)
-			list_add(&retval->pools, &dev->dma_pools);
-		else {
-			kfree(retval);
-			retval = NULL;
-		}
-		mutex_unlock(&pools_lock);
+	mutex_lock(&pools_lock);
+	if (list_empty(&dev->dma_pools) &&
+	    device_create_file(dev, &dev_attr_pools)) {
+		kfree(retval);
+		return NULL;
 	} else
-		INIT_LIST_HEAD(&retval->pools);
+		list_add(&retval->pools, &dev->dma_pools);
+	mutex_unlock(&pools_lock);
 
 	return retval;
 }
-- 
1.7.4.4

