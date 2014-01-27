Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaA0Jiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:38:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41531 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbaA0Jhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:37:40 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 2/3] usb: musb: musb_cppi41: Make CPPI aware of high bandwidth transfers
Date: Mon, 27 Jan 2014 15:07:25 +0530
Message-ID: <1390815446-1236-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1390815446-1236-1-git-send-email-george.cherian@ti.com>
References: <1390815446-1236-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable CPPI to handle high bandwidth transfers, especially to support
webcam captures. Use a single bd to get the whole of the data in case of
high bandwidth transfers.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_cppi41.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
index f889296..39ee516 100644
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -448,12 +448,25 @@ static int cppi41_dma_channel_program(struct dma_channel *channel,
 				dma_addr_t dma_addr, u32 len)
 {
 	int ret;
+	struct cppi41_dma_channel *cppi41_channel = channel->private_data;
+	int hb_mult = 0;
 
 	BUG_ON(channel->status == MUSB_DMA_STATUS_UNKNOWN ||
 		channel->status == MUSB_DMA_STATUS_BUSY);
 
+	if (is_host_active(cppi41_channel->controller->musb)) {
+		if (cppi41_channel->is_tx)
+			hb_mult = cppi41_channel->hw_ep->out_qh->hb_mult;
+		else
+			hb_mult = cppi41_channel->hw_ep->in_qh->hb_mult;
+	}
+
 	channel->status = MUSB_DMA_STATUS_BUSY;
 	channel->actual_len = 0;
+
+	if (hb_mult)
+		packet_sz = hb_mult * (packet_sz & 0x7FF);
+
 	ret = cppi41_configure_channel(channel, packet_sz, mode, dma_addr, len);
 	if (!ret)
 		channel->status = MUSB_DMA_STATUS_FREE;
-- 
1.8.1

