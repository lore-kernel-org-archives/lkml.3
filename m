Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3LRVNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:13:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3LRVNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.12 034/118] usb: musb: musb_cppi41: factor most of cppi41_dma_callback() into cppi41_trans_done()
Date: Wed, 18 Dec 2013 13:11:11 -0800
Message-Id: <20131218211220.439451714@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit d373a8534d5e1e7a350e40d3c11961a7cd8d530b upstream.

This patch moves most of the logic in cppi41_dma_callback() into
cppi41_trans_done() where it can be called from another function.
Instead of computing "transferred" (the number of bytes transferred in
the last transaction) in cppi41_trans_done() the member
"cppi41_channel->prog_len" is now set to 0 if the transfer as a whole
can be considered as done. If it is != 0 then the next iteration is
assumed.
This is a preparation for a workaround.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_cppi41.c |   59 +++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 23 deletions(-)

--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -96,31 +96,15 @@ static void update_rx_toggle(struct cppi
 	cppi41_channel->usb_toggle = toggle;
 }
 
-static void cppi41_dma_callback(void *private_data)
+static void cppi41_dma_callback(void *private_data);
+
+static void cppi41_trans_done(struct dma_channel *channel)
 {
-	struct dma_channel *channel = private_data;
 	struct cppi41_dma_channel *cppi41_channel = channel->private_data;
 	struct musb_hw_ep *hw_ep = cppi41_channel->hw_ep;
 	struct musb *musb = hw_ep->musb;
-	unsigned long flags;
-	struct dma_tx_state txstate;
-	u32 transferred;
 
-	spin_lock_irqsave(&musb->lock, flags);
-
-	dmaengine_tx_status(cppi41_channel->dc, cppi41_channel->cookie,
-			&txstate);
-	transferred = cppi41_channel->prog_len - txstate.residue;
-	cppi41_channel->transferred += transferred;
-
-	dev_dbg(musb->controller, "DMA transfer done on hw_ep=%d bytes=%d/%d\n",
-		hw_ep->epnum, cppi41_channel->transferred,
-		cppi41_channel->total_len);
-
-	update_rx_toggle(cppi41_channel);
-
-	if (cppi41_channel->transferred == cppi41_channel->total_len ||
-			transferred < cppi41_channel->packet_sz) {
+	if (!cppi41_channel->prog_len) {
 
 		/* done, complete */
 		cppi41_channel->channel.actual_len =
@@ -150,10 +134,8 @@ static void cppi41_dma_callback(void *pr
 				remain_bytes,
 				direction,
 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-		if (WARN_ON(!dma_desc)) {
-			spin_unlock_irqrestore(&musb->lock, flags);
+		if (WARN_ON(!dma_desc))
 			return;
-		}
 
 		dma_desc->callback = cppi41_dma_callback;
 		dma_desc->callback_param = channel;
@@ -166,6 +148,37 @@ static void cppi41_dma_callback(void *pr
 			musb_writew(epio, MUSB_RXCSR, csr);
 		}
 	}
+}
+
+static void cppi41_dma_callback(void *private_data)
+{
+	struct dma_channel *channel = private_data;
+	struct cppi41_dma_channel *cppi41_channel = channel->private_data;
+	struct musb_hw_ep *hw_ep = cppi41_channel->hw_ep;
+	struct musb *musb = hw_ep->musb;
+	unsigned long flags;
+	struct dma_tx_state txstate;
+	u32 transferred;
+
+	spin_lock_irqsave(&musb->lock, flags);
+
+	dmaengine_tx_status(cppi41_channel->dc, cppi41_channel->cookie,
+			&txstate);
+	transferred = cppi41_channel->prog_len - txstate.residue;
+	cppi41_channel->transferred += transferred;
+
+	dev_dbg(musb->controller, "DMA transfer done on hw_ep=%d bytes=%d/%d\n",
+		hw_ep->epnum, cppi41_channel->transferred,
+		cppi41_channel->total_len);
+
+	update_rx_toggle(cppi41_channel);
+
+	if (cppi41_channel->transferred == cppi41_channel->total_len ||
+			transferred < cppi41_channel->packet_sz)
+		cppi41_channel->prog_len = 0;
+
+	cppi41_trans_done(channel);
+
 	spin_unlock_irqrestore(&musb->lock, flags);
 }
 


