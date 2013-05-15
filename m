Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab3EOJ60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:58:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62777 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab3EOJwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 23/39] usb: musb: ux500: harden checks for platform data
Date: Wed, 15 May 2013 10:51:46 +0100
Message-Id: <1368611522-9984-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In its current state, the ux500-musb driver uses platform data pointers
blindly with no prior checking. If no platform data pointer is passed
this will Oops the kernel. In this patch we ensure platform data and
board data are present prior to using them.

Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/usb/musb/ux500_dma.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 382291b..4bd5400 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -289,7 +289,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 	struct musb *musb = controller->private_data;
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *plat = dev->platform_data;
-	struct ux500_musb_board_data *data = plat->board_data;
+	struct ux500_musb_board_data *data;
 	struct dma_channel *dma_channel = NULL;
 	u32 ch_num;
 	u8 dir;
@@ -299,14 +299,19 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 	struct ux500_dma_channel *channel_array;
 	dma_cap_mask_t mask;
 
+	if (!plat) {
+		dev_err(musb->controller, "No platform data\n");
+		return -EINVAL;
+	}
 
+	data = plat->board_data;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
 	/* Prepare the loop for RX channels */
 	channel_array = controller->rx_channel;
-	param_array = data->dma_rx_param_array;
+	param_array = data ? data->dma_rx_param_array : NULL;
 
 	for (dir = 0; dir < 2; dir++) {
 		for (ch_num = 0;
@@ -339,7 +344,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 
 		/* Prepare the loop for TX channels */
 		channel_array = controller->tx_channel;
-		param_array = data->dma_tx_param_array;
+		param_array = data ? data->dma_tx_param_array : NULL;
 		is_tx = 1;
 	}
 
-- 
1.7.10.4

