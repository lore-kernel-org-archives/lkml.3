Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3DXPF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:05:29 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:58614 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab3DXPF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:05:27 -0400
Date: Wed, 24 Apr 2013 16:05:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 05/10 v2] usb: musb: ux500: attempt to find channels by name
 before using pdata
Message-ID: <20130424150521.GE9652@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <1366729394-11406-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366729394-11406-6-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 8d5128d..99ad1fe 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -33,6 +33,11 @@
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
@@ -289,6 +294,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 	struct musb_hdrc_platform_data *plat = dev->platform_data;
 	struct ux500_musb_board_data *data;
 	struct dma_channel *dma_channel = NULL;
+	char **chan_names;
 	u32 ch_num;
 	u8 dir;
 	u8 is_tx = 0;
@@ -310,6 +316,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 	/* Prepare the loop for RX channels */
 	channel_array = controller->rx_channel;
 	param_array = data ? data->dma_rx_param_array : NULL;
+	chan_names = (char **)iep_chan_names;
 
 	for (dir = 0; dir < 2; dir++) {
 		for (ch_num = 0;
@@ -325,9 +332,15 @@ static int ux500_dma_controller_start(struct dma_controller *c)
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
@@ -343,6 +356,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 		/* Prepare the loop for TX channels */
 		channel_array = controller->tx_channel;
 		param_array = data ? data->dma_tx_param_array : NULL;
+		chan_names = (char **)oep_chan_names;
 		is_tx = 1;
 	}
