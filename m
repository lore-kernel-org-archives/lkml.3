Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaA0Jh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:37:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44730 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbaA0Jhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:37:42 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 3/3] usb: musb: musb_cppi41: Handle ISOCH differently and not use the hrtimer.
Date: Mon, 27 Jan 2014 15:07:26 +0530
Message-ID: <1390815446-1236-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1390815446-1236-1-git-send-email-george.cherian@ti.com>
References: <1390815446-1236-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of ISOCH transfers the hrtimer workaround for the hardware issue
is not very reliable. Instead of checking musb_is_tx_fifo_empty() in hrtimer
routine, schedule a completion work and check the same in completion work.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_cppi41.c | 53 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
index 39ee516..5b0f2a5 100644
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -39,6 +39,7 @@ struct cppi41_dma_channel {
 	u32 transferred;
 	u32 packet_sz;
 	struct list_head tx_check;
+	struct work_struct dma_completion;
 };
 
 #define MUSB_DMA_NUM_CHANNELS 15
@@ -112,6 +113,18 @@ static bool musb_is_tx_fifo_empty(struct musb_hw_ep *hw_ep)
 	return true;
 }
 
+static bool is_isoc(struct musb_hw_ep *hw_ep, bool in)
+{
+	if (in && hw_ep->in_qh) {
+		if (hw_ep->in_qh->type == USB_ENDPOINT_XFER_ISOC)
+			return true;
+	} else if (hw_ep->out_qh) {
+		if (hw_ep->out_qh->type == USB_ENDPOINT_XFER_ISOC)
+			return true;
+	}
+	return false;
+}
+
 static void cppi41_dma_callback(void *private_data);
 
 static void cppi41_trans_done(struct cppi41_dma_channel *cppi41_channel)
@@ -165,6 +178,32 @@ static void cppi41_trans_done(struct cppi41_dma_channel *cppi41_channel)
 	}
 }
 
+static void cppi_trans_done_work(struct work_struct *work)
+{
+	unsigned long flags;
+	struct cppi41_dma_channel *cppi41_channel =
+		container_of(work, struct cppi41_dma_channel, dma_completion);
+	struct cppi41_dma_controller *controller = cppi41_channel->controller;
+	struct musb *musb = controller->musb;
+	struct musb_hw_ep *hw_ep = cppi41_channel->hw_ep;
+	bool empty;
+
+	if (!cppi41_channel->is_tx && is_isoc(hw_ep, 1)) {
+		spin_lock_irqsave(&musb->lock, flags);
+		cppi41_trans_done(cppi41_channel);
+		spin_unlock_irqrestore(&musb->lock, flags);
+	} else {
+		empty = musb_is_tx_fifo_empty(hw_ep);
+		if (empty) {
+			spin_lock_irqsave(&musb->lock, flags);
+			cppi41_trans_done(cppi41_channel);
+			spin_unlock_irqrestore(&musb->lock, flags);
+		} else {
+			schedule_work(&cppi41_channel->dma_completion);
+		}
+	}
+}
+
 static enum hrtimer_restart cppi41_recheck_tx_req(struct hrtimer *timer)
 {
 	struct cppi41_dma_controller *controller;
@@ -228,6 +267,14 @@ static void cppi41_dma_callback(void *private_data)
 			transferred < cppi41_channel->packet_sz)
 		cppi41_channel->prog_len = 0;
 
+	if (!cppi41_channel->is_tx) {
+		if (is_isoc(hw_ep, 1))
+			schedule_work(&cppi41_channel->dma_completion);
+		else
+			cppi41_trans_done(cppi41_channel);
+		goto out;
+	}
+
 	empty = musb_is_tx_fifo_empty(hw_ep);
 	if (empty) {
 		cppi41_trans_done(cppi41_channel);
@@ -264,6 +311,10 @@ static void cppi41_dma_callback(void *private_data)
 				goto out;
 			}
 		}
+		if (is_isoc(hw_ep, 0)) {
+			schedule_work(&cppi41_channel->dma_completion);
+			goto out;
+		}
 		list_add_tail(&cppi41_channel->tx_check,
 				&controller->early_tx_list);
 		if (!hrtimer_active(&controller->early_tx)) {
@@ -620,6 +671,8 @@ static int cppi41_dma_controller_start(struct cppi41_dma_controller *controller)
 		cppi41_channel->port_num = port;
 		cppi41_channel->is_tx = is_tx;
 		INIT_LIST_HEAD(&cppi41_channel->tx_check);
+		INIT_WORK(&cppi41_channel->dma_completion,
+			  cppi_trans_done_work);
 
 		musb_dma = &cppi41_channel->channel;
 		musb_dma->private_data = cppi41_channel;
-- 
1.8.1

