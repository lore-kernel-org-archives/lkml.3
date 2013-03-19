Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab3CSHxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:53:09 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:44774 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753683Ab3CSHxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:53:08 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <broonie@opensource.wolfsonmicro.com>,
        <richard.genoud@gmail.com>, <plagnioj@jcrosoft.com>,
        <nicolas.ferre@atmel.com>, <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 10/14] spi/spi-atmel: correct 16 bits transfers with DMA
Date: Tue, 19 Mar 2013 15:49:01 +0800
Message-ID: <1363679341-4087-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
[wenyou.yang@atmel.com: submit the patch]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/spi/spi-atmel.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 3aa3809..e6539b7 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -388,12 +388,18 @@ static inline int atmel_spi_xfer_can_be_chained(struct spi_transfer *xfer)
 }
 
 static int atmel_spi_dma_slave_config(struct atmel_spi *as,
-				struct dma_slave_config *slave_config)
+				struct dma_slave_config *slave_config,
+				u8 bits_per_word)
 {
 	int err = 0;
 
-	slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
-	slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	if (bits_per_word > 8) {
+		slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	} else {
+		slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	}
 
 	slave_config->dst_addr = (dma_addr_t)as->phybase + SPI_TDR;
 	slave_config->src_addr = (dma_addr_t)as->phybase + SPI_RDR;
@@ -454,7 +460,7 @@ static int atmel_spi_configure_dma(struct atmel_spi *as)
 		goto error;
 	}
 
-	err = atmel_spi_dma_slave_config(as, &slave_config);
+	err = atmel_spi_dma_slave_config(as, &slave_config, 8);
 	if (err)
 		goto error;
 
@@ -588,10 +594,9 @@ static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 
 	*plen = len;
 
-	if (atmel_spi_dma_slave_config(as, &slave_config))
+	if (atmel_spi_dma_slave_config(as, &slave_config, 8))
 		goto err_exit;
 
-
 	/* Send both scatterlists */
 	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
 					&as->dma.sgrx,
-- 
1.7.9.5

