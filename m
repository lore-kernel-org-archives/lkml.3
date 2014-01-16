Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaAPFsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 00:48:25 -0500
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:58217
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbaAPFsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 00:48:21 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzd799hzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21a7h1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: <hongbo.zhang@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <LeoLi@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH 4/7] DMA: Freescale: move functions to avoid forward declarations
Date: Thu, 16 Jan 2014 13:47:23 +0800
Message-ID: <1389851246-8564-5-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
References: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

These functions will be modified in the next patch in the series. By moving the
function in a patch separate from the changes, it will make review easier.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |  192 +++++++++++++++++++++++++-------------------------
 1 file changed, 96 insertions(+), 96 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index ad73538..7b6fd3c 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -463,6 +463,102 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(struct fsldma_chan *chan)
 }
 
 /**
+ * fsl_chan_xfer_ld_queue - transfer any pending transactions
+ * @chan : Freescale DMA channel
+ *
+ * HARDWARE STATE: idle
+ * LOCKING: must hold chan->desc_lock
+ */
+static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
+{
+	struct fsl_desc_sw *desc;
+
+	/*
+	 * If the list of pending descriptors is empty, then we
+	 * don't need to do any work at all
+	 */
+	if (list_empty(&chan->ld_pending)) {
+		chan_dbg(chan, "no pending LDs\n");
+		return;
+	}
+
+	/*
+	 * The DMA controller is not idle, which means that the interrupt
+	 * handler will start any queued transactions when it runs after
+	 * this transaction finishes
+	 */
+	if (!chan->idle) {
+		chan_dbg(chan, "DMA controller still busy\n");
+		return;
+	}
+
+	/*
+	 * If there are some link descriptors which have not been
+	 * transferred, we need to start the controller
+	 */
+
+	/*
+	 * Move all elements from the queue of pending transactions
+	 * onto the list of running transactions
+	 */
+	chan_dbg(chan, "idle, starting controller\n");
+	desc = list_first_entry(&chan->ld_pending, struct fsl_desc_sw, node);
+	list_splice_tail_init(&chan->ld_pending, &chan->ld_running);
+
+	/*
+	 * The 85xx DMA controller doesn't clear the channel start bit
+	 * automatically at the end of a transfer. Therefore we must clear
+	 * it in software before starting the transfer.
+	 */
+	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
+		u32 mode;
+
+		mode = get_mr(chan);
+		mode &= ~FSL_DMA_MR_CS;
+		set_mr(chan, mode);
+	}
+
+	/*
+	 * Program the descriptor's address into the DMA controller,
+	 * then start the DMA transaction
+	 */
+	set_cdar(chan, desc->async_tx.phys);
+	get_cdar(chan);
+
+	dma_start(chan);
+	chan->idle = false;
+}
+
+/**
+ * fsldma_cleanup_descriptor - cleanup and free a single link descriptor
+ * @chan: Freescale DMA channel
+ * @desc: descriptor to cleanup and free
+ *
+ * This function is used on a descriptor which has been executed by the DMA
+ * controller. It will run any callbacks, submit any dependencies, and then
+ * free the descriptor.
+ */
+static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
+				      struct fsl_desc_sw *desc)
+{
+	struct dma_async_tx_descriptor *txd = &desc->async_tx;
+
+	/* Run the link descriptor callback function */
+	if (txd->callback) {
+#ifdef FSL_DMA_LD_DEBUG
+		chan_dbg(chan, "LD %p callback\n", desc);
+#endif
+		txd->callback(txd->callback_param);
+	}
+
+	/* Run any dependencies */
+	dma_run_dependencies(txd);
+
+	dma_descriptor_unmap(txd);
+	fsl_dma_free_descriptor(chan, desc);
+}
+
+/**
  * fsl_dma_alloc_chan_resources - Allocate resources for DMA channel.
  * @chan : Freescale DMA channel
  *
@@ -807,102 +903,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 }
 
 /**
- * fsldma_cleanup_descriptor - cleanup and free a single link descriptor
- * @chan: Freescale DMA channel
- * @desc: descriptor to cleanup and free
- *
- * This function is used on a descriptor which has been executed by the DMA
- * controller. It will run any callbacks, submit any dependencies, and then
- * free the descriptor.
- */
-static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
-				      struct fsl_desc_sw *desc)
-{
-	struct dma_async_tx_descriptor *txd = &desc->async_tx;
-
-	/* Run the link descriptor callback function */
-	if (txd->callback) {
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "LD %p callback\n", desc);
-#endif
-		txd->callback(txd->callback_param);
-	}
-
-	/* Run any dependencies */
-	dma_run_dependencies(txd);
-
-	dma_descriptor_unmap(txd);
-	fsl_dma_free_descriptor(chan, desc);
-}
-
-/**
- * fsl_chan_xfer_ld_queue - transfer any pending transactions
- * @chan : Freescale DMA channel
- *
- * HARDWARE STATE: idle
- * LOCKING: must hold chan->desc_lock
- */
-static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
-{
-	struct fsl_desc_sw *desc;
-
-	/*
-	 * If the list of pending descriptors is empty, then we
-	 * don't need to do any work at all
-	 */
-	if (list_empty(&chan->ld_pending)) {
-		chan_dbg(chan, "no pending LDs\n");
-		return;
-	}
-
-	/*
-	 * The DMA controller is not idle, which means that the interrupt
-	 * handler will start any queued transactions when it runs after
-	 * this transaction finishes
-	 */
-	if (!chan->idle) {
-		chan_dbg(chan, "DMA controller still busy\n");
-		return;
-	}
-
-	/*
-	 * If there are some link descriptors which have not been
-	 * transferred, we need to start the controller
-	 */
-
-	/*
-	 * Move all elements from the queue of pending transactions
-	 * onto the list of running transactions
-	 */
-	chan_dbg(chan, "idle, starting controller\n");
-	desc = list_first_entry(&chan->ld_pending, struct fsl_desc_sw, node);
-	list_splice_tail_init(&chan->ld_pending, &chan->ld_running);
-
-	/*
-	 * The 85xx DMA controller doesn't clear the channel start bit
-	 * automatically at the end of a transfer. Therefore we must clear
-	 * it in software before starting the transfer.
-	 */
-	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
-		u32 mode;
-
-		mode = get_mr(chan);
-		mode &= ~FSL_DMA_MR_CS;
-		set_mr(chan, mode);
-	}
-
-	/*
-	 * Program the descriptor's address into the DMA controller,
-	 * then start the DMA transaction
-	 */
-	set_cdar(chan, desc->async_tx.phys);
-	get_cdar(chan);
-
-	dma_start(chan);
-	chan->idle = false;
-}
-
-/**
  * fsl_dma_memcpy_issue_pending - Issue the DMA start command
  * @chan : Freescale DMA channel
  */
-- 
1.7.9.5



