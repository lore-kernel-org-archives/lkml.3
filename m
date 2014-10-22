Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaJVPpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:45:38 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54065 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754620AbaJVPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:33 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 25/59] dmaengine: ipu-idmac: Split device_control
Date: Wed, 22 Oct 2014 17:43:39 +0200
Message-Id: <1413992653-21963-26-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the IPU IDMAC driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/ipu/ipu_idmac.c | 96 ++++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 45 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index bbf62927bd72..b36f5a47578a 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1398,76 +1398,81 @@ static void idmac_issue_pending(struct dma_chan *chan)
 	 */
 }
 
-static int __idmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			   unsigned long arg)
+static int idmac_pause(struct dma_chan *chan)
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
 	struct idmac *idmac = to_idmac(chan->device);
 	struct ipu *ipu = to_ipu(idmac);
 	struct list_head *list, *tmp;
 	unsigned long flags;
-	int i;
 
-	switch (cmd) {
-	case DMA_PAUSE:
-		spin_lock_irqsave(&ipu->lock, flags);
-		ipu_ic_disable_task(ipu, chan->chan_id);
+	mutex_lock(&ichan->chan_mutex);
 
-		/* Return all descriptors into "prepared" state */
-		list_for_each_safe(list, tmp, &ichan->queue)
-			list_del_init(list);
+	spin_lock_irqsave(&ipu->lock, flags);
+	ipu_ic_disable_task(ipu, chan->chan_id);
 
-		ichan->sg[0] = NULL;
-		ichan->sg[1] = NULL;
+	/* Return all descriptors into "prepared" state */
+	list_for_each_safe(list, tmp, &ichan->queue)
+		list_del_init(list);
 
-		spin_unlock_irqrestore(&ipu->lock, flags);
+	ichan->sg[0] = NULL;
+	ichan->sg[1] = NULL;
 
-		ichan->status = IPU_CHANNEL_INITIALIZED;
-		break;
-	case DMA_TERMINATE_ALL:
-		ipu_disable_channel(idmac, ichan,
-				    ichan->status >= IPU_CHANNEL_ENABLED);
+	spin_unlock_irqrestore(&ipu->lock, flags);
 
-		tasklet_disable(&ipu->tasklet);
+	ichan->status = IPU_CHANNEL_INITIALIZED;
 
-		/* ichan->queue is modified in ISR, have to spinlock */
-		spin_lock_irqsave(&ichan->lock, flags);
-		list_splice_init(&ichan->queue, &ichan->free_list);
+	mutex_unlock(&ichan->chan_mutex);
 
-		if (ichan->desc)
-			for (i = 0; i < ichan->n_tx_desc; i++) {
-				struct idmac_tx_desc *desc = ichan->desc + i;
-				if (list_empty(&desc->list))
-					/* Descriptor was prepared, but not submitted */
-					list_add(&desc->list, &ichan->free_list);
+	return 0;
+}
 
-				async_tx_clear_ack(&desc->txd);
-			}
+static int __idmac_terminate_all(struct dma_chan *chan)
+{
+	struct idmac_channel *ichan = to_idmac_chan(chan);
+	struct idmac *idmac = to_idmac(chan->device);
+	struct ipu *ipu = to_ipu(idmac);
+	unsigned long flags;
+	int i;
 
-		ichan->sg[0] = NULL;
-		ichan->sg[1] = NULL;
-		spin_unlock_irqrestore(&ichan->lock, flags);
+	ipu_disable_channel(idmac, ichan,
+			    ichan->status >= IPU_CHANNEL_ENABLED);
 
-		tasklet_enable(&ipu->tasklet);
+	tasklet_disable(&ipu->tasklet);
 
-		ichan->status = IPU_CHANNEL_INITIALIZED;
-		break;
-	default:
-		return -ENOSYS;
-	}
+	/* ichan->queue is modified in ISR, have to spinlock */
+	spin_lock_irqsave(&ichan->lock, flags);
+	list_splice_init(&ichan->queue, &ichan->free_list);
+
+	if (ichan->desc)
+		for (i = 0; i < ichan->n_tx_desc; i++) {
+			struct idmac_tx_desc *desc = ichan->desc + i;
+			if (list_empty(&desc->list))
+				/* Descriptor was prepared, but not submitted */
+				list_add(&desc->list, &ichan->free_list);
+
+			async_tx_clear_ack(&desc->txd);
+		}
+
+	ichan->sg[0] = NULL;
+	ichan->sg[1] = NULL;
+	spin_unlock_irqrestore(&ichan->lock, flags);
+
+	tasklet_enable(&ipu->tasklet);
+
+	ichan->status = IPU_CHANNEL_INITIALIZED;
 
 	return 0;
 }
 
-static int idmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			 unsigned long arg)
+static int idmac_terminate_all(struct dma_chan *chan)
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
 	int ret;
 
 	mutex_lock(&ichan->chan_mutex);
 
-	ret = __idmac_control(chan, cmd, arg);
+	ret = __idmac_terminate_all(chan);
 
 	mutex_unlock(&ichan->chan_mutex);
 
@@ -1568,7 +1573,7 @@ static void idmac_free_chan_resources(struct dma_chan *chan)
 
 	mutex_lock(&ichan->chan_mutex);
 
-	__idmac_control(chan, DMA_TERMINATE_ALL, 0);
+	__idmac_terminate_all(chan);
 
 	if (ichan->status > IPU_CHANNEL_FREE) {
 #ifdef DEBUG
@@ -1622,7 +1627,8 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 
 	/* Compulsory for DMA_SLAVE fields */
 	dma->device_prep_slave_sg		= idmac_prep_slave_sg;
-	dma->device_control			= idmac_control;
+	dma->device_pause			= idmac_pause;
+	dma->device_terminate_all		= idmac_terminate_all;
 
 	INIT_LIST_HEAD(&dma->channels);
 	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
@@ -1655,7 +1661,7 @@ static void ipu_idmac_exit(struct ipu *ipu)
 	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
 		struct idmac_channel *ichan = ipu->channel + i;
 
-		idmac_control(&ichan->dma_chan, DMA_TERMINATE_ALL, 0);
+		idmac_terminate_all(&ichan->dma_chan);
 	}
 
 	dma_async_device_unregister(&idmac->dma);
-- 
2.1.1

