Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaEHOao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:30:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:37474 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaEHOan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:30:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535919110"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] spi/pxa2xx: Prevent DMA from transferring too many bytes
Date: Thu,  8 May 2014 17:30:31 +0300
Message-Id: <1399559431-2065-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case we are doing DMA transfer and the size of the buffer is not multiple
of 4 bytes the driver truncates that to 4-byte boundary and tries to handle
remaining bytes using PIO.

Or that is what it tried to do. What actually happens is that it calls
ALIGN() to the buffer size which aligns it to the next 4-byte boundary
(doesn't truncate). Doing this results 1-3 bytes extra to be transferred.
Furthermore we handle remaining bytes using PIO which results one extra
byte to be transferred. In worst case the driver transfers 4 extra bytes.

While investigating this it turned out that the DMA hardware doesn't even
have such limitation so we can solve this by dropping the code that tries
to handle unaligned bytes.

Reported-by: Chiau Ee Chew <chiau.ee.chew@intel.com>
Reported-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx-dma.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-dma.c b/drivers/spi/spi-pxa2xx-dma.c
index 713af4806f26..f6759dc0153b 100644
--- a/drivers/spi/spi-pxa2xx-dma.c
+++ b/drivers/spi/spi-pxa2xx-dma.c
@@ -29,18 +29,6 @@ static int pxa2xx_spi_map_dma_buffer(struct driver_data *drv_data,
 	struct sg_table *sgt;
 	void *buf, *pbuf;
 
-	/*
-	 * Some DMA controllers have problems transferring buffers that are
-	 * not multiple of 4 bytes. So we truncate the transfer so that it
-	 * is suitable for such controllers, and handle the trailing bytes
-	 * manually after the DMA completes.
-	 *
-	 * REVISIT: It would be better if this information could be
-	 * retrieved directly from the DMA device in a similar way than
-	 * ->copy_align etc. is done.
-	 */
-	len = ALIGN(drv_data->len, 4);
-
 	if (dir == DMA_TO_DEVICE) {
 		dmadev = drv_data->tx_chan->device->dev;
 		sgt = &drv_data->tx_sgt;
@@ -144,12 +132,8 @@ static void pxa2xx_spi_dma_transfer_complete(struct driver_data *drv_data,
 		if (!error) {
 			pxa2xx_spi_unmap_dma_buffers(drv_data);
 
-			/* Handle the last bytes of unaligned transfer */
 			drv_data->tx += drv_data->tx_map_len;
-			drv_data->write(drv_data);
-
 			drv_data->rx += drv_data->rx_map_len;
-			drv_data->read(drv_data);
 
 			msg->actual_length += drv_data->len;
 			msg->state = pxa2xx_spi_next_transfer(drv_data);
-- 
2.0.0.rc2

