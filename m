Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaDSCvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 22:51:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46344 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaDSCvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 22:51:33 -0400
From: Joel Fernandes <joelf@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH] dmaengine: edma: Add DMA memcpy support
Date: Fri, 18 Apr 2014 21:50:33 -0500
Message-ID: <1397875833-31345-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add DMA memcpy support to EDMA driver. Successful tests performed using
dmatest kernel module. Copy alignment is set to DMA_SLAVE_BUSWIDTH_4_BYTES and
users must ensure length is aligned so that copy is performed fully.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 25a75e2..072f642 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -378,6 +378,11 @@ static int edma_config_pset(struct dma_chan *chan, struct edmacc_param *pset,
 		src_cidx = 0;
 		dst_bidx = acnt;
 		dst_cidx = cidx;
+	} else if (direction == DMA_MEM_TO_MEM)  {
+		src_bidx = acnt;
+		src_cidx = cidx;
+		dst_bidx = acnt;
+		dst_cidx = cidx;
 	} else {
 		dev_err(dev, "%s: direction not implemented yet\n", __func__);
 		return -EINVAL;
@@ -498,6 +503,44 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
 }
 
+struct dma_async_tx_descriptor *edma_prep_dma_memcpy(
+	struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
+	size_t len, unsigned long tx_flags)
+{
+	int ret;
+	struct edma_desc *edesc;
+	struct device *dev = chan->device->dev;
+	struct edma_chan *echan = to_edma_chan(chan);
+
+	if (unlikely(!echan || !len))
+		return NULL;
+
+	edesc = kzalloc(sizeof(*edesc) + sizeof(edesc->pset[0]), GFP_ATOMIC);
+	if (!edesc) {
+		dev_dbg(dev, "Failed to allocate a descriptor\n");
+		return NULL;
+	}
+
+	edesc->pset_nr = 1;
+
+	ret = edma_config_pset(chan, &edesc->pset[0], src, dest, 1,
+			       DMA_SLAVE_BUSWIDTH_4_BYTES, len, DMA_MEM_TO_MEM);
+	if (ret < 0)
+		return NULL;
+
+	edesc->absync = ret;
+
+	/*
+	 * Enable intermediate transfer chaining to re-trigger channel
+	 * on completion of every TR, and enable transfer-completion
+	 * interrupt on completion of the whole transfer.
+	 */
+	edesc->pset[0].opt |= ITCCHEN;
+	edesc->pset[0].opt |= TCINTEN;
+
+	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
+}
+
 static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 	struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 	size_t period_len, enum dma_transfer_direction direction,
@@ -875,6 +918,7 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 {
 	dma->device_prep_slave_sg = edma_prep_slave_sg;
 	dma->device_prep_dma_cyclic = edma_prep_dma_cyclic;
+	dma->device_prep_dma_memcpy = edma_prep_dma_memcpy;
 	dma->device_alloc_chan_resources = edma_alloc_chan_resources;
 	dma->device_free_chan_resources = edma_free_chan_resources;
 	dma->device_issue_pending = edma_issue_pending;
@@ -883,6 +927,12 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 	dma->device_slave_caps = edma_dma_device_slave_caps;
 	dma->dev = dev;
 
+	/*
+	 * code using dma memcpy must make sure alignment of
+	 * length is at dma->copy_align boundary.
+	 */
+	dma->copy_align = DMA_SLAVE_BUSWIDTH_4_BYTES;
+
 	INIT_LIST_HEAD(&dma->channels);
 }
 
@@ -911,6 +961,7 @@ static int edma_probe(struct platform_device *pdev)
 	dma_cap_zero(ecc->dma_slave.cap_mask);
 	dma_cap_set(DMA_SLAVE, ecc->dma_slave.cap_mask);
 	dma_cap_set(DMA_CYCLIC, ecc->dma_slave.cap_mask);
+	dma_cap_set(DMA_MEMCPY, ecc->dma_slave.cap_mask);
 
 	edma_dma_init(ecc, &ecc->dma_slave, &pdev->dev);
 
-- 
1.7.9.5

