Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab3EOJxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:53:01 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50180 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666Ab3EOJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/39] usb: musb: ux500: attempt to find channels by name before using pdata
Date: Wed, 15 May 2013 10:51:47 +0100
Message-Id: <1368611522-9984-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we can ever get to a state where we can solely search for DMA channels
by name, this will almost completely alleviate the requirement to pass
copious amounts of information though platform data. Here we take the
first step towards this. The next step will be to enable Device Tree
complete with name<->event_line mapping.

Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/usb/musb/ux500_dma.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 4bd5400..7d80699 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -34,6 +34,11 @@
 #include <linux/platform_data/usb-musb-ux500.h>
 #include "musb_core.h"
 
+static const char *iep_chan_names[] = { "iep_1_9", "iep_2_10", "iep_3_11", "iep_4_12",
+					"iep_5_13", "iep_6_14", "iep_7_15", "iep_8" };
+static const char *oep_chan_names[] = { "oep_1_9", "oep_2_10", "oep_3_11", "oep_4_12",
+					"oep_5_13", "oep_6_14", "oep_7_15", "oep_8" };
+
 struct ux500_dma_channel {
 	struct dma_channel channel;
 	struct ux500_dma_controller *controller;
@@ -291,6 +296,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 	struct musb_hdrc_platform_data *plat = dev->platform_data;
 	struct ux500_musb_board_data *data;
 	struct dma_channel *dma_channel = NULL;
+	char **chan_names;
 	u32 ch_num;
 	u8 dir;
 	u8 is_tx = 0;
@@ -312,6 +318,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 	/* Prepare the loop for RX channels */
 	channel_array = controller->rx_channel;
 	param_array = data ? data->dma_rx_param_array : NULL;
+	chan_names = (char **)iep_chan_names;
 
 	for (dir = 0; dir < 2; dir++) {
 		for (ch_num = 0;
@@ -327,9 +334,15 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 			dma_channel->status = MUSB_DMA_STATUS_FREE;
 			dma_channel->max_len = SZ_16M;
 
-			ux500_channel->dma_chan = dma_request_channel(mask,
-							data->dma_filter,
-							param_array[ch_num]);
+			ux500_channel->dma_chan =
+				dma_request_slave_channel(dev, chan_names[ch_num]);
+
+			if (!ux500_channel->dma_chan)
+				ux500_channel->dma_chan =
+					dma_request_channel(mask,
+							    data->dma_filter,
+							    param_array[ch_num]);
+
 			if (!ux500_channel->dma_chan) {
 				ERR("Dma pipe allocation error dir=%d ch=%d\n",
 					dir, ch_num);
@@ -345,6 +358,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 		/* Prepare the loop for TX channels */
 		channel_array = controller->tx_channel;
 		param_array = data ? data->dma_tx_param_array : NULL;
+		chan_names = (char **)oep_chan_names;
 		is_tx = 1;
 	}
 
-- 
1.7.10.4

