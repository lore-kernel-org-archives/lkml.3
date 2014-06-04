Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaFEADQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:03:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaFDXW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xuelin Shi <xuelin.shi@freescale.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3.14 190/228] dmaengine: fix dmaengine_unmap failure
Date: Wed,  4 Jun 2014 16:23:39 -0700
Message-Id: <20140604232354.125682418@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dmaengine.c   |    2 ++
 include/linux/dmaengine.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1014,6 +1014,7 @@ static void dmaengine_unmap(struct kref
 		dma_unmap_page(dev, unmap->addr[i], unmap->len,
 			       DMA_BIDIRECTIONAL);
 	}
+	cnt = unmap->map_cnt;
 	mempool_free(unmap, __get_unmap_pool(cnt)->pool);
 }
 
@@ -1079,6 +1080,7 @@ dmaengine_get_unmap_data(struct device *
 	memset(unmap, 0, sizeof(*unmap));
 	kref_init(&unmap->kref);
 	unmap->dev = dev;
+	unmap->map_cnt = nr;
 
 	return unmap;
 }
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -433,6 +433,7 @@ typedef bool (*dma_filter_fn)(struct dma
 typedef void (*dma_async_tx_callback)(void *dma_async_param);
 
 struct dmaengine_unmap_data {
+	u8 map_cnt;
 	u8 to_cnt;
 	u8 from_cnt;
 	u8 bidi_cnt;


