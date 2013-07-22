Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab3GVSM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:12:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:41861 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab3GVSMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:12:06 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: [PATCH 15/16] dmaengine: add transfered member to dma_async_tx_descriptor
Date: Mon, 22 Jul 2013 20:10:06 +0200
Message-Id: <1374516607-2705-16-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In USB RX path it is possible that the we receive less bytes than
requested. Take the following example:
The driver for USB-to-UART submits an URB with 256 bytes in size and the
dmaengine driver in turn programs a transfer of 256 bytes. The transfer
is programmed and the dma engine waits for the data to arrive. Once data
is sent on the UART the dma engine begins to move data. If there was
only one data byte in the USB packet received then the DMA engine will
only move one byte due to USB restrictions / rules. The real size of the
transfer has to be notified to the user / caller so he set this to the
caller.
This patch adds the transfered member to the dma_async_tx_descriptor
where the caller can obtain the final size.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/dmaengine.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index cb286b1..c3a4635 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -403,6 +403,8 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  * @tx_submit: set the prepared descriptor(s) to be executed by the engine
  * @callback: routine to call after this operation is complete
  * @callback_param: general parameter to pass to the callback routine
+ * @transfered: number of bytes that were really transfered in case the channel
+ *	transfered less than requested.
  * ---async_tx api specific fields---
  * @next: at completion submit this descriptor
  * @parent: pointer to the next level up in the dependency chain
@@ -416,6 +418,7 @@ struct dma_async_tx_descriptor {
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
+	unsigned int transfered;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
-- 
1.8.3.2

