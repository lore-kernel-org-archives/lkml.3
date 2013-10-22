Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3JVVIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:08:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:19451 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab3JVVIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:08:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,550,1378882800"; 
   d="scan'208";a="415395945"
Subject: [PATCH v2 13/13] dmaengine: remove DMA unmap flags
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: dave.jiang@intel.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
        b.zolnierkie@samsung.com, vinod.koul@intel.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Mark Brown <broonie@kernel.org>, Viresh Kumar <viresh.linux@gmail.com>,
        Tejun Heo <tj@kernel.org>, linux@arm.linux.org.uk,
        Jon Mason <jon.mason@intel.com>, David Woodhouse <dwmw2@infradead.org>
Date: Tue, 22 Oct 2013 14:08:34 -0700
Message-ID: <20131022210834.31394.26173.stgit@viggo.jf.intel.com>
In-Reply-To: <1382117733-16720-14-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-14-git-send-email-b.zolnierkie@samsung.com>
User-Agent: StGit/0.17-1-g7c57
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Remove no longer needed DMA unmap flags:
- DMA_COMPL_SKIP_SRC_UNMAP
- DMA_COMPL_SKIP_DEST_UNMAP
- DMA_COMPL_SRC_UNMAP_SINGLE
- DMA_COMPL_DEST_UNMAP_SINGLE

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jon Mason <jon.mason@intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Resend to:
	1/ add it to the new dmaengine patchwork
	2/ cc maintainers of affected drivers
	3/ fixup some mail addresses

 crypto/async_tx/async_memcpy.c           |    3 +--
 crypto/async_tx/async_pq.c               |    1 -
 crypto/async_tx/async_raid6_recov.c      |    8 ++------
 crypto/async_tx/async_xor.c              |    6 ++----
 drivers/ata/pata_arasan_cf.c             |    3 +--
 drivers/dma/dmaengine.c                  |    3 +--
 drivers/dma/dmatest.c                    |    3 +--
 drivers/dma/ioat/dma.c                   |    3 +--
 drivers/dma/ioat/dma_v3.c                |   12 +++---------
 drivers/media/platform/m2m-deinterlace.c |    3 +--
 drivers/media/platform/timblogiw.c       |    2 +-
 drivers/misc/carma/carma-fpga.c          |    3 +--
 drivers/mtd/nand/atmel_nand.c            |    3 +--
 drivers/mtd/nand/fsmc_nand.c             |    2 --
 drivers/net/ethernet/micrel/ks8842.c     |    6 ++----
 drivers/ntb/ntb_transport.c              |    3 +--
 drivers/spi/spi-dw-mid.c                 |    4 ++--
 include/linux/dmaengine.h                |   18 ++++--------------
 18 files changed, 25 insertions(+), 61 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 72750214f779..f8c0b8dbeb75 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -56,8 +56,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 		unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOIO);
 
 	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 4126b56fbc01..d05327caf69d 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -62,7 +62,6 @@ do_async_gen_syndrome(struct dma_chan *chan,
 	dma_addr_t dma_dest[2];
 	int src_off = 0;
 
-	dma_flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 	if (submit->flags & ASYNC_TX_FENCE)
 		dma_flags |= DMA_PREP_FENCE;
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index a3a72a784421..934a84981495 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -47,9 +47,7 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 		struct device *dev = dma->dev;
 		dma_addr_t pq[2];
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-						DMA_COMPL_SKIP_DEST_UNMAP |
-						DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
@@ -113,9 +111,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 		dma_addr_t dma_dest[2];
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-						DMA_COMPL_SKIP_DEST_UNMAP |
-						DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index d2cc77d501c7..3c562f5a60bb 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -41,7 +41,7 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	void *cb_param_orig = submit->cb_param;
 	enum async_tx_flags flags_orig = submit->flags;
-	enum dma_ctrl_flags dma_flags;
+	enum dma_ctrl_flags dma_flags = 0;
 	int src_cnt = unmap->to_cnt;
 	int xor_src_cnt;
 	dma_addr_t dma_dest = unmap->addr[unmap->to_cnt];
@@ -55,7 +55,6 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		/* if we are submitting additional xors, leave the chain open
 		 * and clear the callback parameters
 		 */
-		dma_flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 		if (src_cnt > xor_src_cnt) {
 			submit->flags &= ~ASYNC_TX_ACK;
 			submit->flags |= ASYNC_TX_FENCE;
@@ -284,8 +283,7 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 
 	if (unmap && src_cnt <= device->max_xor &&
 	    is_dma_xor_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 853f610af28f..e88690ebfd82 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -396,8 +396,7 @@ dma_xfer(struct arasan_cf_dev *acdev, dma_addr_t src, dma_addr_t dest, u32 len)
 	struct dma_async_tx_descriptor *tx;
 	struct dma_chan *chan = acdev->dma_chan;
 	dma_cookie_t cookie;
-	unsigned long flags = DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	unsigned long flags = DMA_PREP_INTERRUPT;
 	int ret = 0;
 
 	tx = chan->device->device_prep_dma_memcpy(chan, dest, src, len, flags);
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index f878c808466e..b69ac3892b86 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1065,8 +1065,7 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 	unmap->addr[1] = dma_map_page(dev->dev, dest_pg, dest_off, len,
 				      DMA_FROM_DEVICE);
 	unmap->len = len;
-	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK;
 	tx = dev->device_prep_dma_memcpy(chan, unmap->addr[1], unmap->addr[0],
 					 len, flags);
 
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index f4a2a25fae31..5791091c13ca 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -599,8 +599,7 @@ static int dmatest_func(void *data)
 	/*
 	 * src and dst buffers are freed by ourselves below
 	 */
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
-		DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	while (!kthread_should_stop()
 	       && !(params->iterations && total_tests >= params->iterations)) {
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index c123e32dbbb0..6fcf741ad91b 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -818,8 +818,7 @@ int ioat_dma_self_test(struct ioatdma_device *device)
 
 	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev, dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
-	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
-		DMA_PREP_INTERRUPT;
+	flags = DMA_PREP_INTERRUPT;
 	tx = device->common.device_prep_dma_memcpy(dma_chan, dma_dest, dma_src,
 						   IOAT_TEST_SIZE, flags);
 	if (!tx) {
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 43386c171bba..a4798f0cc225 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1279,9 +1279,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
 				      IOAT_NUM_SRC_TEST, PAGE_SIZE,
-				      DMA_PREP_INTERRUPT |
-				      DMA_COMPL_SKIP_SRC_UNMAP |
-				      DMA_COMPL_SKIP_DEST_UNMAP);
+				      DMA_PREP_INTERRUPT);
 
 	if (!tx) {
 		dev_err(dev, "Self-test xor prep failed\n");
@@ -1342,9 +1340,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT |
-					  DMA_COMPL_SKIP_SRC_UNMAP |
-					  DMA_COMPL_SKIP_DEST_UNMAP);
+					  &xor_val_result, DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test zero prep failed\n");
 		err = -ENODEV;
@@ -1389,9 +1385,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT |
-					  DMA_COMPL_SKIP_SRC_UNMAP |
-					  DMA_COMPL_SKIP_DEST_UNMAP);
+					  &xor_val_result, DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test 2nd zero prep failed\n");
 		err = -ENODEV;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 540516ca872c..879ea6fdd1be 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -341,8 +341,7 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 	ctx->xt->dir = DMA_MEM_TO_MEM;
 	ctx->xt->src_sgl = false;
 	ctx->xt->dst_sgl = true;
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
-		DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	tx = dmadev->device_prep_interleaved_dma(chan, ctx->xt, flags);
 	if (tx == NULL) {
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index b557caf5b1a4..59a95e3ab0e3 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -565,7 +565,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 	desc = dmaengine_prep_slave_sg(fh->chan,
 		buf->sg, sg_elems, DMA_DEV_TO_MEM,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		DMA_PREP_INTERRUPT);
 	if (!desc) {
 		spin_lock_irq(&fh->queue_lock);
 		list_del_init(&vb->queue);
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 7b56563f8b74..5335104e7c84 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -631,8 +631,7 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	struct dma_async_tx_descriptor *tx;
 	dma_cookie_t cookie;
 	dma_addr_t dst, src;
-	unsigned long dma_flags = DMA_COMPL_SKIP_DEST_UNMAP |
-				  DMA_COMPL_SKIP_SRC_UNMAP;
+	unsigned long dma_flags = 0;
 
 	dst_sg = buf->vb.sglist;
 	dst_nents = buf->vb.sglen;
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 060feeaf6b3e..2a837cb425d7 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -375,8 +375,7 @@ static int atmel_nand_dma_op(struct mtd_info *mtd, void *buf, int len,
 
 	dma_dev = host->dma_chan->device;
 
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	phys_addr = dma_map_single(dma_dev->dev, p, len, dir);
 	if (dma_mapping_error(dma_dev->dev, phys_addr)) {
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 3dc1a7564d87..8b2752263db9 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -573,8 +573,6 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
 
-	flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
-
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;
 		dma_dst = host->data_pa;
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index 0951f7aca1ef..822616e3c375 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -459,8 +459,7 @@ static int ks8842_tx_frame_dma(struct sk_buff *skb, struct net_device *netdev)
 		sg_dma_len(&ctl->sg) += 4 - sg_dma_len(&ctl->sg) % 4;
 
 	ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
-		&ctl->sg, 1, DMA_MEM_TO_DEV,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		&ctl->sg, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
 	if (!ctl->adesc)
 		return NETDEV_TX_BUSY;
 
@@ -571,8 +570,7 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
 		sg_dma_len(sg) = DMA_BUFFER_SIZE;
 
 		ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
-			sg, 1, DMA_DEV_TO_MEM,
-			DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+			sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
 
 		if (!ctl->adesc)
 			goto out;
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index fc6bbf1e16d9..bc7a55cdf679 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1072,8 +1072,7 @@ static void ntb_async_rx(struct ntb_queue_entry *entry, void *offset,
 
 	unmap->from_cnt = 1;
 
-	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
-		DMA_PREP_INTERRUPT;
+	flags = DMA_PREP_INTERRUPT;
 	txd = device->device_prep_dma_memcpy(chan, unmap->addr[1],
 					     unmap->addr[0], len, flags);
 	if (!txd)
diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index b9f0192758d6..6d207afec8cb 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -150,7 +150,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->tx_sgl,
 				1,
 				DMA_MEM_TO_DEV,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT);
 	txdesc->callback = dw_spi_dma_done;
 	txdesc->callback_param = dws;
 
@@ -173,7 +173,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->rx_sgl,
 				1,
 				DMA_DEV_TO_MEM,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT);
 	rxdesc->callback = dw_spi_dma_done;
 	rxdesc->callback_param = dws;
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3782cdb782a8..491072cb5ba0 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -171,12 +171,6 @@ struct dma_interleaved_template {
  * @DMA_CTRL_ACK - if clear, the descriptor cannot be reused until the client
  *  acknowledges receipt, i.e. has has a chance to establish any dependency
  *  chains
- * @DMA_COMPL_SKIP_SRC_UNMAP - set to disable dma-unmapping the source buffer(s)
- * @DMA_COMPL_SKIP_DEST_UNMAP - set to disable dma-unmapping the destination(s)
- * @DMA_COMPL_SRC_UNMAP_SINGLE - set to do the source dma-unmapping as single
- * 	(if not set, do the source dma-unmapping as page)
- * @DMA_COMPL_DEST_UNMAP_SINGLE - set to do the destination dma-unmapping as single
- * 	(if not set, do the destination dma-unmapping as page)
  * @DMA_PREP_PQ_DISABLE_P - prevent generation of P while generating Q
  * @DMA_PREP_PQ_DISABLE_Q - prevent generation of Q while generating P
  * @DMA_PREP_CONTINUE - indicate to a driver that it is reusing buffers as
@@ -188,14 +182,10 @@ struct dma_interleaved_template {
 enum dma_ctrl_flags {
 	DMA_PREP_INTERRUPT = (1 << 0),
 	DMA_CTRL_ACK = (1 << 1),
-	DMA_COMPL_SKIP_SRC_UNMAP = (1 << 2),
-	DMA_COMPL_SKIP_DEST_UNMAP = (1 << 3),
-	DMA_COMPL_SRC_UNMAP_SINGLE = (1 << 4),
-	DMA_COMPL_DEST_UNMAP_SINGLE = (1 << 5),
-	DMA_PREP_PQ_DISABLE_P = (1 << 6),
-	DMA_PREP_PQ_DISABLE_Q = (1 << 7),
-	DMA_PREP_CONTINUE = (1 << 8),
-	DMA_PREP_FENCE = (1 << 9),
+	DMA_PREP_PQ_DISABLE_P = (1 << 2),
+	DMA_PREP_PQ_DISABLE_Q = (1 << 3),
+	DMA_PREP_CONTINUE = (1 << 4),
+	DMA_PREP_FENCE = (1 << 5),
 };
 
 /**

