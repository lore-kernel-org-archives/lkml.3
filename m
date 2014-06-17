Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967325AbaFQWXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:23:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965034AbaFQVuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xuelin Shi <xuelin.shi@freescale.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 160/212] dmaengine: fix dmaengine_unmap failure
Date: Tue, 17 Jun 2014 14:44:14 -0700
Message-Id: <1403041506-13646-161-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuelin Shi <xuelin.shi@freescale.com>

commit c1f43dd9c20d85e66c4d77e284f64ac114abe3f8 upstream.

The count which is used to get_unmap_data maybe not the same as the
count computed in dmaengine_unmap which causes to free data in a
wrong pool.

This patch fixes this issue by keeping the map count with unmap_data
structure and use this count to get the pool.

Signed-off-by: Xuelin Shi <xuelin.shi@freescale.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/dma/dmaengine.c   | 2 ++
 include/linux/dmaengine.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index ef63b90..b4c711d 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -959,6 +959,7 @@ static void dmaengine_unmap(struct kref *kref)
 		dma_unmap_page(dev, unmap->addr[i], unmap->len,
 			       DMA_BIDIRECTIONAL);
 	}
+	cnt = unmap->map_cnt;
 	mempool_free(unmap, __get_unmap_pool(cnt)->pool);
 }
 
@@ -1024,6 +1025,7 @@ dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
 	memset(unmap, 0, sizeof(*unmap));
 	kref_init(&unmap->kref);
 	unmap->dev = dev;
+	unmap->map_cnt = nr;
 
 	return unmap;
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 41cf0c3..ed6c1f1 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -405,6 +405,7 @@ typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
 typedef void (*dma_async_tx_callback)(void *dma_async_param);
 
 struct dmaengine_unmap_data {
+	u8 map_cnt;
 	u8 to_cnt;
 	u8 from_cnt;
 	u8 bidi_cnt;
-- 
1.9.1

