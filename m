Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaAXOPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:15:19 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55284 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbaAXOPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:15:14 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, George Cherian <george.cherian@ti.com>
Subject: [PATCH 1/3] usb: musb: musb_host: Enable ISOCH IN handling for AM335x host
Date: Fri, 24 Jan 2014 19:44:53 +0530
Message-ID: <1390572895-26428-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1390572895-26428-1-git-send-email-george.cherian@ti.com>
References: <1390572895-26428-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the isochrounous IN handling for AM335x HOST.
Reprogram CPPI to receive consecutive ISOCH frames in the same URB.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_host.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index ed45572..5b6482c 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1689,9 +1689,11 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 			| MUSB_RXCSR_H_AUTOREQ
 			| MUSB_RXCSR_AUTOCLEAR
 			| MUSB_RXCSR_RXPKTRDY);
+
 		musb_writew(hw_ep->regs, MUSB_RXCSR, val);
 
-#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA)
+#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA) || \
+	defined(CONFIG_USB_TI_CPPI41_DMA)
 		if (usb_pipeisoc(pipe)) {
 			struct usb_iso_packet_descriptor *d;
 
@@ -1706,8 +1708,28 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 
 			if (++qh->iso_idx >= urb->number_of_packets)
 				done = true;
-			else
+			else {
+#if defined(CONFIG_USB_TI_CPPI41_DMA)
+				struct dma_controller   *c;
+				dma_addr_t *buf;
+				u32 length, ret;
+
+				c = musb->dma_controller;
+				buf = (void *)
+					urb->iso_frame_desc[qh->iso_idx].offset
+					+ (u32)urb->transfer_dma;
+
+				length =
+					urb->iso_frame_desc[qh->iso_idx].length;
+
+				val |= MUSB_RXCSR_DMAENAB;
+				musb_writew(hw_ep->regs, MUSB_RXCSR, val);
+
+				ret = c->channel_program(dma, qh->maxpacket,
+						0, (u32) buf, length);
+#endif
 				done = false;
+			}
 
 		} else  {
 		/* done if urb buffer is full or short packet is recd */
@@ -1747,7 +1769,8 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 		}
 
 		/* we are expecting IN packets */
-#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA)
+#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA) || \
+	defined(CONFIG_USB_TI_CPPI41_DMA)
 		if (dma) {
 			struct dma_controller	*c;
 			u16			rx_count;
-- 
1.8.1

