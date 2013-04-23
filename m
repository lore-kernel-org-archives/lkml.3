Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3DWPDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:03:48 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51503 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab3DWPDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:03:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Subject: [PATCH 04/10] usb: musb: ux500: harden checks for platform data
Date: Tue, 23 Apr 2013 16:03:08 +0100
Message-Id: <1366729394-11406-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In its current state, the ux500-musb driver uses platform data pointers
blindly with no prior checking. If no platform data pointer is passed
this will Oops the kernel. In this patch we ensure platform data and
board data are present prior to using them.

Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/usb/musb/ux500_dma.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index c75e07a..02b4a6e 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -287,7 +287,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 	struct musb *musb = controller->private_data;
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *plat = dev->platform_data;
-	struct ux500_musb_board_data *data = plat->board_data;
+	struct ux500_musb_board_data *data;
 	struct dma_channel *dma_channel = NULL;
 	u32 ch_num;
 	u8 dir;
@@ -297,14 +297,19 @@ static int ux500_dma_controller_start(struct dma_controller *c)
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
+	param_array = (data) ? data->dma_rx_param_array : NULL;
 
 	for (dir = 0; dir < 2; dir++) {
 		for (ch_num = 0;
@@ -337,7 +342,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 
 		/* Prepare the loop for TX channels */
 		channel_array = controller->tx_channel;
-		param_array = data->dma_tx_param_array;
+		param_array = (data) ? data->dma_tx_param_array : NULL;
 		is_tx = 1;
 	}
 
-- 
1.7.10.4

