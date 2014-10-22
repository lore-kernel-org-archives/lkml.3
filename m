Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaJVQBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:01:02 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54089 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754796AbaJVPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:47 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 26/59] dmaengine: k3: Split device_control
Date: Wed, 22 Oct 2014 17:43:40 +0200
Message-Id: <1413992653-21963-27-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Hisilicon K3 DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/k3dma.c | 197 ++++++++++++++++++++++++++++------------------------
 1 file changed, 107 insertions(+), 90 deletions(-)

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index a1f911aaf220..fb4dd2cffd80 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -441,7 +441,7 @@ static struct dma_async_tx_descriptor *k3_dma_prep_memcpy(
 	num = 0;
 
 	if (!c->ccfg) {
-		/* default is memtomem, without calling device_control */
+		/* default is memtomem, without calling device_config */
 		c->ccfg = CX_CFG_SRCINCR | CX_CFG_DSTINCR | CX_CFG_EN;
 		c->ccfg |= (0xf << 20) | (0xf << 24);	/* burst = 16 */
 		c->ccfg |= (0x3 << 12) | (0x3 << 16);	/* width = 64 bit */
@@ -523,112 +523,126 @@ static struct dma_async_tx_descriptor *k3_dma_prep_slave_sg(
 	return vchan_tx_prep(&c->vc, &ds->vd, flags);
 }
 
-static int k3_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-	unsigned long arg)
+static int k3_dma_config(struct dma_chan *chan,
+			 struct dma_slave_config *cfg)
+{
+	struct k3_dma_chan *c = to_k3_chan(chan);
+	u32 maxburst = 0, val = 0;
+	enum dma_slave_buswidth width = DMA_SLAVE_BUSWIDTH_UNDEFINED;
+
+	if (cfg == NULL)
+		return -EINVAL;
+	c->dir = cfg->direction;
+	if (c->dir == DMA_DEV_TO_MEM) {
+		c->ccfg = CX_CFG_DSTINCR;
+		c->dev_addr = cfg->src_addr;
+		maxburst = cfg->src_maxburst;
+		width = cfg->src_addr_width;
+	} else if (c->dir == DMA_MEM_TO_DEV) {
+		c->ccfg = CX_CFG_SRCINCR;
+		c->dev_addr = cfg->dst_addr;
+		maxburst = cfg->dst_maxburst;
+		width = cfg->dst_addr_width;
+	}
+	switch (width) {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+	case DMA_SLAVE_BUSWIDTH_8_BYTES:
+		val =  __ffs(width);
+		break;
+	default:
+		val = 3;
+		break;
+	}
+	c->ccfg |= (val << 12) | (val << 16);
+
+	if ((maxburst == 0) || (maxburst > 16))
+		val = 16;
+	else
+		val = maxburst - 1;
+	c->ccfg |= (val << 20) | (val << 24);
+	c->ccfg |= CX_CFG_MEM2PER | CX_CFG_EN;
+
+	/* specific request line */
+	c->ccfg |= c->vc.chan.chan_id << 4;
+
+	return 0;
+}
+
+static int k3_dma_terminate_all(struct dma_chan *chan)
 {
 	struct k3_dma_chan *c = to_k3_chan(chan);
 	struct k3_dma_dev *d = to_k3_dma(chan->device);
-	struct dma_slave_config *cfg = (void *)arg;
 	struct k3_dma_phy *p = c->phy;
 	unsigned long flags;
-	u32 maxburst = 0, val = 0;
-	enum dma_slave_buswidth width = DMA_SLAVE_BUSWIDTH_UNDEFINED;
 	LIST_HEAD(head);
 
-	switch (cmd) {
-	case DMA_SLAVE_CONFIG:
-		if (cfg == NULL)
-			return -EINVAL;
-		c->dir = cfg->direction;
-		if (c->dir == DMA_DEV_TO_MEM) {
-			c->ccfg = CX_CFG_DSTINCR;
-			c->dev_addr = cfg->src_addr;
-			maxburst = cfg->src_maxburst;
-			width = cfg->src_addr_width;
-		} else if (c->dir == DMA_MEM_TO_DEV) {
-			c->ccfg = CX_CFG_SRCINCR;
-			c->dev_addr = cfg->dst_addr;
-			maxburst = cfg->dst_maxburst;
-			width = cfg->dst_addr_width;
-		}
-		switch (width) {
-		case DMA_SLAVE_BUSWIDTH_1_BYTE:
-		case DMA_SLAVE_BUSWIDTH_2_BYTES:
-		case DMA_SLAVE_BUSWIDTH_4_BYTES:
-		case DMA_SLAVE_BUSWIDTH_8_BYTES:
-			val =  __ffs(width);
-			break;
-		default:
-			val = 3;
-			break;
-		}
-		c->ccfg |= (val << 12) | (val << 16);
+	dev_dbg(d->slave.dev, "vchan %p: terminate all\n", &c->vc);
 
-		if ((maxburst == 0) || (maxburst > 16))
-			val = 16;
-		else
-			val = maxburst - 1;
-		c->ccfg |= (val << 20) | (val << 24);
-		c->ccfg |= CX_CFG_MEM2PER | CX_CFG_EN;
+	/* Prevent this channel being scheduled */
+	spin_lock(&d->lock);
+	list_del_init(&c->node);
+	spin_unlock(&d->lock);
 
-		/* specific request line */
-		c->ccfg |= c->vc.chan.chan_id << 4;
-		break;
+	/* Clear the tx descriptor lists */
+	spin_lock_irqsave(&c->vc.lock, flags);
+	vchan_get_all_descriptors(&c->vc, &head);
+	if (p) {
+		/* vchan is assigned to a pchan - stop the channel */
+		k3_dma_terminate_chan(p, d);
+		c->phy = NULL;
+		p->vchan = NULL;
+		p->ds_run = p->ds_done = NULL;
+	}
+	spin_unlock_irqrestore(&c->vc.lock, flags);
+	vchan_dma_desc_free_list(&c->vc, &head);
 
-	case DMA_TERMINATE_ALL:
-		dev_dbg(d->slave.dev, "vchan %p: terminate all\n", &c->vc);
+	return 0;
+}
 
-		/* Prevent this channel being scheduled */
-		spin_lock(&d->lock);
-		list_del_init(&c->node);
-		spin_unlock(&d->lock);
+static int k3_dma_pause(struct dma_chan *chan)
+{
+	struct k3_dma_chan *c = to_k3_chan(chan);
+	struct k3_dma_dev *d = to_k3_dma(chan->device);
+	struct k3_dma_phy *p = c->phy;
 
-		/* Clear the tx descriptor lists */
-		spin_lock_irqsave(&c->vc.lock, flags);
-		vchan_get_all_descriptors(&c->vc, &head);
+	dev_dbg(d->slave.dev, "vchan %p: pause\n", &c->vc);
+	if (c->status == DMA_IN_PROGRESS) {
+		c->status = DMA_PAUSED;
 		if (p) {
-			/* vchan is assigned to a pchan - stop the channel */
-			k3_dma_terminate_chan(p, d);
-			c->phy = NULL;
-			p->vchan = NULL;
-			p->ds_run = p->ds_done = NULL;
+			k3_dma_pause_dma(p, false);
+		} else {
+			spin_lock(&d->lock);
+			list_del_init(&c->node);
+			spin_unlock(&d->lock);
 		}
-		spin_unlock_irqrestore(&c->vc.lock, flags);
-		vchan_dma_desc_free_list(&c->vc, &head);
-		break;
+	}
 
-	case DMA_PAUSE:
-		dev_dbg(d->slave.dev, "vchan %p: pause\n", &c->vc);
-		if (c->status == DMA_IN_PROGRESS) {
-			c->status = DMA_PAUSED;
-			if (p) {
-				k3_dma_pause_dma(p, false);
-			} else {
-				spin_lock(&d->lock);
-				list_del_init(&c->node);
-				spin_unlock(&d->lock);
-			}
-		}
-		break;
+	return 0;
+}
 
-	case DMA_RESUME:
-		dev_dbg(d->slave.dev, "vchan %p: resume\n", &c->vc);
-		spin_lock_irqsave(&c->vc.lock, flags);
-		if (c->status == DMA_PAUSED) {
-			c->status = DMA_IN_PROGRESS;
-			if (p) {
-				k3_dma_pause_dma(p, true);
-			} else if (!list_empty(&c->vc.desc_issued)) {
-				spin_lock(&d->lock);
-				list_add_tail(&c->node, &d->chan_pending);
-				spin_unlock(&d->lock);
-			}
+static int k3_dma_resume(struct dma_chan *chan)
+{
+	struct k3_dma_chan *c = to_k3_chan(chan);
+	struct k3_dma_dev *d = to_k3_dma(chan->device);
+	struct k3_dma_phy *p = c->phy;
+	unsigned long flags;
+
+	dev_dbg(d->slave.dev, "vchan %p: resume\n", &c->vc);
+	spin_lock_irqsave(&c->vc.lock, flags);
+	if (c->status == DMA_PAUSED) {
+		c->status = DMA_IN_PROGRESS;
+		if (p) {
+			k3_dma_pause_dma(p, true);
+		} else if (!list_empty(&c->vc.desc_issued)) {
+			spin_lock(&d->lock);
+			list_add_tail(&c->node, &d->chan_pending);
+			spin_unlock(&d->lock);
 		}
-		spin_unlock_irqrestore(&c->vc.lock, flags);
-		break;
-	default:
-		return -ENXIO;
 	}
+	spin_unlock_irqrestore(&c->vc.lock, flags);
+
 	return 0;
 }
 
@@ -720,7 +734,10 @@ static int k3_dma_probe(struct platform_device *op)
 	d->slave.device_prep_dma_memcpy = k3_dma_prep_memcpy;
 	d->slave.device_prep_slave_sg = k3_dma_prep_slave_sg;
 	d->slave.device_issue_pending = k3_dma_issue_pending;
-	d->slave.device_control = k3_dma_control;
+	d->slave.device_config = k3_dma_config;
+	d->slave.device_pause = k3_dma_pause;
+	d->slave.device_resume = k3_dma_resume;
+	d->slave.device_terminate_all = k3_dma_terminate_all;
 	d->slave.copy_align = DMA_ALIGN;
 	d->slave.chancnt = d->dma_requests;
 
-- 
2.1.1

