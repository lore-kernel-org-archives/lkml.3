Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855Ab3ECOli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:41:38 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48909 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab3ECOfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:35:01 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Subject: [PATCH 44/63] usb: musb: ux500: move channel number knowledge into the driver
Date: Fri,  3 May 2013 15:32:30 +0100
Message-Id: <1367591569-32197-45-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all ux500 based platforms the maximum number of end-points are used.
Move this knowledge into the driver so we can relinquish the burden from
platform data. This also removes quite a bit of complexity from the driver
and will aid us when we come to enable the driver for Device Tree.

Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/usb.c                    |   14 ++++++------
 drivers/usb/musb/ux500_dma.c                 |   30 ++++++++------------------
 include/linux/platform_data/usb-musb-ux500.h |    5 +----
 3 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
index 821703d..8aff9a4 100644
--- a/arch/arm/mach-ux500/usb.c
+++ b/arch/arm/mach-ux500/usb.c
@@ -22,7 +22,7 @@
 		.dir = STEDMA40_MEM_TO_PERIPH, \
 	}
 
-static struct stedma40_chan_cfg musb_dma_rx_ch[UX500_MUSB_DMA_NUM_RX_CHANNELS]
+static struct stedma40_chan_cfg musb_dma_rx_ch[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS]
 	= {
 	MUSB_DMA40_RX_CH,
 	MUSB_DMA40_RX_CH,
@@ -34,7 +34,7 @@ static struct stedma40_chan_cfg musb_dma_rx_ch[UX500_MUSB_DMA_NUM_RX_CHANNELS]
 	MUSB_DMA40_RX_CH
 };
 
-static struct stedma40_chan_cfg musb_dma_tx_ch[UX500_MUSB_DMA_NUM_TX_CHANNELS]
+static struct stedma40_chan_cfg musb_dma_tx_ch[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS]
 	= {
 	MUSB_DMA40_TX_CH,
 	MUSB_DMA40_TX_CH,
@@ -46,7 +46,7 @@ static struct stedma40_chan_cfg musb_dma_tx_ch[UX500_MUSB_DMA_NUM_TX_CHANNELS]
 	MUSB_DMA40_TX_CH,
 };
 
-static void *ux500_dma_rx_param_array[UX500_MUSB_DMA_NUM_RX_CHANNELS] = {
+static void *ux500_dma_rx_param_array[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS] = {
 	&musb_dma_rx_ch[0],
 	&musb_dma_rx_ch[1],
 	&musb_dma_rx_ch[2],
@@ -57,7 +57,7 @@ static void *ux500_dma_rx_param_array[UX500_MUSB_DMA_NUM_RX_CHANNELS] = {
 	&musb_dma_rx_ch[7]
 };
 
-static void *ux500_dma_tx_param_array[UX500_MUSB_DMA_NUM_TX_CHANNELS] = {
+static void *ux500_dma_tx_param_array[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS] = {
 	&musb_dma_tx_ch[0],
 	&musb_dma_tx_ch[1],
 	&musb_dma_tx_ch[2],
@@ -71,8 +71,6 @@ static void *ux500_dma_tx_param_array[UX500_MUSB_DMA_NUM_TX_CHANNELS] = {
 static struct ux500_musb_board_data musb_board_data = {
 	.dma_rx_param_array = ux500_dma_rx_param_array,
 	.dma_tx_param_array = ux500_dma_tx_param_array,
-	.num_rx_channels = UX500_MUSB_DMA_NUM_RX_CHANNELS,
-	.num_tx_channels = UX500_MUSB_DMA_NUM_TX_CHANNELS,
 	.dma_filter = stedma40_filter,
 };
 
@@ -119,7 +117,7 @@ static inline void ux500_usb_dma_update_rx_ch_config(int *dev_type)
 {
 	u32 idx;
 
-	for (idx = 0; idx < UX500_MUSB_DMA_NUM_RX_CHANNELS; idx++)
+	for (idx = 0; idx < UX500_MUSB_DMA_NUM_RX_TX_CHANNELS; idx++)
 		musb_dma_rx_ch[idx].dev_type = dev_type[idx];
 }
 
@@ -127,7 +125,7 @@ static inline void ux500_usb_dma_update_tx_ch_config(int *dev_type)
 {
 	u32 idx;
 
-	for (idx = 0; idx < UX500_MUSB_DMA_NUM_TX_CHANNELS; idx++)
+	for (idx = 0; idx < UX500_MUSB_DMA_NUM_RX_TX_CHANNELS; idx++)
 		musb_dma_tx_ch[idx].dev_type = dev_type[idx];
 }
 
diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 039e567d..c75e07a 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -47,10 +47,8 @@ struct ux500_dma_channel {
 
 struct ux500_dma_controller {
 	struct dma_controller controller;
-	struct ux500_dma_channel rx_channel[UX500_MUSB_DMA_NUM_RX_CHANNELS];
-	struct ux500_dma_channel tx_channel[UX500_MUSB_DMA_NUM_TX_CHANNELS];
-	u32	num_rx_channels;
-	u32	num_tx_channels;
+	struct ux500_dma_channel rx_channel[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS];
+	struct ux500_dma_channel tx_channel[UX500_MUSB_DMA_NUM_RX_TX_CHANNELS];
 	void *private_data;
 	dma_addr_t phy_base;
 };
@@ -142,19 +140,15 @@ static struct dma_channel *ux500_dma_channel_allocate(struct dma_controller *c,
 	struct ux500_dma_channel *ux500_channel = NULL;
 	struct musb *musb = controller->private_data;
 	u8 ch_num = hw_ep->epnum - 1;
-	u32 max_ch;
 
-	/* Max 8 DMA channels (0 - 7). Each DMA channel can only be allocated
+	/* 8 DMA channels (0 - 7). Each DMA channel can only be allocated
 	 * to specified hw_ep. For example DMA channel 0 can only be allocated
 	 * to hw_ep 1 and 9.
 	 */
 	if (ch_num > 7)
 		ch_num -= 8;
 
-	max_ch = is_tx ? controller->num_tx_channels :
-			controller->num_rx_channels;
-
-	if (ch_num >= max_ch)
+	if (ch_num >= UX500_MUSB_DMA_NUM_RX_TX_CHANNELS)
 		return NULL;
 
 	ux500_channel = is_tx ? &(controller->tx_channel[ch_num]) :
@@ -262,7 +256,7 @@ static int ux500_dma_controller_stop(struct dma_controller *c)
 	struct dma_channel *channel;
 	u8 ch_num;
 
-	for (ch_num = 0; ch_num < controller->num_rx_channels; ch_num++) {
+	for (ch_num = 0; ch_num < UX500_MUSB_DMA_NUM_RX_TX_CHANNELS; ch_num++) {
 		channel = &controller->rx_channel[ch_num].channel;
 		ux500_channel = channel->private_data;
 
@@ -272,7 +266,7 @@ static int ux500_dma_controller_stop(struct dma_controller *c)
 			dma_release_channel(ux500_channel->dma_chan);
 	}
 
-	for (ch_num = 0; ch_num < controller->num_tx_channels; ch_num++) {
+	for (ch_num = 0; ch_num < UX500_MUSB_DMA_NUM_RX_TX_CHANNELS; ch_num++) {
 		channel = &controller->tx_channel[ch_num].channel;
 		ux500_channel = channel->private_data;
 
@@ -301,26 +295,21 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 
 	void **param_array;
 	struct ux500_dma_channel *channel_array;
-	u32 ch_count;
 	dma_cap_mask_t mask;
 
-	if ((data->num_rx_channels > UX500_MUSB_DMA_NUM_RX_CHANNELS) ||
-		(data->num_tx_channels > UX500_MUSB_DMA_NUM_TX_CHANNELS))
-		return -EINVAL;
 
-	controller->num_rx_channels = data->num_rx_channels;
-	controller->num_tx_channels = data->num_tx_channels;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
 	/* Prepare the loop for RX channels */
 	channel_array = controller->rx_channel;
-	ch_count = data->num_rx_channels;
 	param_array = data->dma_rx_param_array;
 
 	for (dir = 0; dir < 2; dir++) {
-		for (ch_num = 0; ch_num < ch_count; ch_num++) {
+		for (ch_num = 0;
+		     ch_num < UX500_MUSB_DMA_NUM_RX_TX_CHANNELS;
+		     ch_num++) {
 			ux500_channel = &channel_array[ch_num];
 			ux500_channel->controller = controller;
 			ux500_channel->ch_num = ch_num;
@@ -348,7 +337,6 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 
 		/* Prepare the loop for TX channels */
 		channel_array = controller->tx_channel;
-		ch_count = data->num_tx_channels;
 		param_array = data->dma_tx_param_array;
 		is_tx = 1;
 	}
diff --git a/include/linux/platform_data/usb-musb-ux500.h b/include/linux/platform_data/usb-musb-ux500.h
index 4c1cc50..dd9c83a 100644
--- a/include/linux/platform_data/usb-musb-ux500.h
+++ b/include/linux/platform_data/usb-musb-ux500.h
@@ -9,14 +9,11 @@
 
 #include <linux/dmaengine.h>
 
-#define UX500_MUSB_DMA_NUM_RX_CHANNELS 8
-#define UX500_MUSB_DMA_NUM_TX_CHANNELS 8
+#define UX500_MUSB_DMA_NUM_RX_TX_CHANNELS 8
 
 struct ux500_musb_board_data {
 	void	**dma_rx_param_array;
 	void	**dma_tx_param_array;
-	u32	num_rx_channels;
-	u32	num_tx_channels;
 	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
 };
 
-- 
1.7.10.4

