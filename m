Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3JRRgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:36:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61625 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab3JRRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:36:09 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-da-52617188576f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dave.jiang@intel.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        Dan Williams <djbw@fb.com>
Subject: [PATCH v2 03/13] dmaengine: prepare for generic 'unmap' data
Date: Fri, 18 Oct 2013 19:35:23 +0200
Message-id: <1382117733-16720-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd2OwsQgg93H5C02zljPajF96gVG
	ixM3G9ksNvc/YLM42/SG3eLyrjlsFrcv81qsn/GaxeJl334WB06PluYeNo+Jze/YPRbvecnk
	0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBnTJh5gKZjnUbH1zXO2BsYPNl2MnBwSAiYSi8+v
	Y4WwxSQu3FvP1sXIxSEksIhR4mPjbUYIp4tJYue/XhaQKjYBK4mJ7asYQWwRARmJDf+3M4MU
	MQucZ5RYfWAlUIKDQ1jAVaJzcxVIDYuAqsSNW3vYQWxeAQ+JG8tOskNsk5d4er+PDcTmFPCU
	mLZvOZgtBFRz7sxLtgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfaM+kdjKsa
	LA4xCnAwKvHwdtgkBgmxJpYVV+YeYpTgYFYS4S1zBgrxpiRWVqUW5ccXleakFh9ilOZgURLn
	PdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgLPnaaeYsHrWP9YlxNvelKp51ezRCJt7iZiiaX2x0
	t0jjtPryr3tk5CUtbrX/S6hULcgxe68mn3f/wpmQTmV3xruHvwmK8B69pH7Xw5CDeZG6aEzi
	MZ5fwfMW+8bGTpg/PUjXunLjvgvTpbu58lYaBjzQdJJdJJK56vLbojUcOeEHJ53UfNKnxFKc
	kWioxVxUnAgAVjJYPTACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <djbw@fb.com>

Add a hook for a common dma unmap implementation to enable removal of
the per driver custom unmap code.  (A reworked version of Bartlomiej
Zolnierkiewicz's patches to remove the custom callbacks and the size
increase of dma_async_tx_descriptor for drivers that don't care about
raid).

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <djbw@fb.com>
[bzolnier: prepare pl330 driver for adding missing unmap while at it]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/amba-pl08x.c  |  1 +
 drivers/dma/at_hdmac.c    |  1 +
 drivers/dma/dw/core.c     |  1 +
 drivers/dma/ep93xx_dma.c  |  1 +
 drivers/dma/fsldma.c      |  1 +
 drivers/dma/ioat/dma.c    |  1 +
 drivers/dma/ioat/dma_v2.c |  1 +
 drivers/dma/ioat/dma_v3.c |  1 +
 drivers/dma/iop-adma.c    |  1 +
 drivers/dma/mv_xor.c      |  1 +
 drivers/dma/pl330.c       |  2 ++
 drivers/dma/ppc4xx/adma.c |  1 +
 drivers/dma/timb_dma.c    |  1 +
 drivers/dma/txx9dmac.c    |  1 +
 include/linux/dmaengine.h | 26 ++++++++++++++++++++++++++
 15 files changed, 41 insertions(+)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index e2c06e6..bbc01c1 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1197,6 +1197,7 @@ static void pl08x_desc_free(struct virt_dma_desc *vd)
 	struct pl08x_txd *txd = to_pl08x_txd(&vd->tx);
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(vd->tx.chan);
 
+	dma_descriptor_unmap(txd);
 	if (!plchan->slave)
 		pl08x_unmap_buffers(txd);
 
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index c787f38..cc7098d 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -345,6 +345,7 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	list_move(&desc->desc_node, &atchan->free_list);
 
 	/* unmap dma addresses (not on slave channels) */
+	dma_descriptor_unmap(txd);
 	if (!atchan->chan_common.private) {
 		struct device *parent = chan2parent(&atchan->chan_common);
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 89eb89f..e3fe1b1 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -311,6 +311,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 	list_splice_init(&desc->tx_list, &dwc->free_list);
 	list_move(&desc->desc_node, &dwc->free_list);
 
+	dma_descriptor_unmap(txd);
 	if (!is_slave_direction(dwc->direction)) {
 		struct device *parent = chan2parent(&dwc->chan);
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 591cd8c..dcd6bf5 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -791,6 +791,7 @@ static void ep93xx_dma_tasklet(unsigned long data)
 		 * For the memcpy channels the API requires us to unmap the
 		 * buffers unless requested otherwise.
 		 */
+		dma_descriptor_unmap(&desc->txd);
 		if (!edmac->chan.private)
 			ep93xx_dma_unmap_buffers(desc);
 
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 61517dd..3752b2a9 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -870,6 +870,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 	/* Run any dependencies */
 	dma_run_dependencies(txd);
 
+	dma_descriptor_unmap(txd);
 	/* Unmap the dst buffer, if requested */
 	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 		if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 5ff6fc1..26f8cfd 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -602,6 +602,7 @@ static void __cleanup(struct ioat_dma_chan *ioat, dma_addr_t phys_complete)
 		dump_desc_dbg(ioat, desc);
 		if (tx->cookie) {
 			dma_cookie_complete(tx);
+			dma_descriptor_unmap(tx);
 			ioat_dma_unmap(chan, tx->flags, desc->len, desc->hw);
 			ioat->active -= desc->hw->tx_cnt;
 			if (tx->callback) {
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index b925e1b..fc7b50a 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -148,6 +148,7 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 		tx = &desc->txd;
 		dump_desc_dbg(ioat, desc);
 		if (tx->cookie) {
+			dma_descriptor_unmap(tx);
 			ioat_dma_unmap(chan, tx->flags, desc->len, desc->hw);
 			dma_cookie_complete(tx);
 			if (tx->callback) {
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index d8ececa..57a2901 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -577,6 +577,7 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 		tx = &desc->txd;
 		if (tx->cookie) {
 			dma_cookie_complete(tx);
+			dma_descriptor_unmap(tx);
 			ioat3_dma_unmap(ioat, desc, idx + i);
 			if (tx->callback) {
 				tx->callback(tx->callback_param);
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index dd8b44a..8f6e426 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -152,6 +152,7 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 		if (tx->callback)
 			tx->callback(tx->callback_param);
 
+		dma_descriptor_unmap(tx);
 		/* unmap dma addresses
 		 * (unmap_single vs unmap_page?)
 		 */
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 536dcb8..ed1ab1d 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -278,6 +278,7 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
 			desc->async_tx.callback(
 				desc->async_tx.callback_param);
 
+		dma_descriptor_unmap(&desc->async_tx);
 		/* unmap dma addresses
 		 * (unmap_single vs unmap_page?)
 		 */
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index a456829..ce2d842 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2268,6 +2268,8 @@ static void pl330_tasklet(unsigned long data)
 			list_move_tail(&desc->node, &pch->dmac->desc_pool);
 		}
 
+		dma_descriptor_unmap(&desc->txd);
+
 		if (callback) {
 			spin_unlock_irqrestore(&pch->lock, flags);
 			callback(callback_param);
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 370ff82..442492d 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -1765,6 +1765,7 @@ static dma_cookie_t ppc440spe_adma_run_tx_complete_actions(
 			desc->async_tx.callback(
 				desc->async_tx.callback_param);
 
+		dma_descriptor_unmap(&desc->async_tx);
 		/* unmap dma addresses
 		 * (unmap_single vs unmap_page?)
 		 *
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 28af214..1d0c988 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -293,6 +293,7 @@ static void __td_finish(struct timb_dma_chan *td_chan)
 
 	list_move(&td_desc->desc_node, &td_chan->free_list);
 
+	dma_descriptor_unmap(txd);
 	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP))
 		__td_unmap_descs(td_desc,
 			txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE);
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 71e8e77..22a0b6c 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -419,6 +419,7 @@ txx9dmac_descriptor_complete(struct txx9dmac_chan *dc,
 	list_splice_init(&desc->tx_list, &dc->free_list);
 	list_move(&desc->desc_node, &dc->free_list);
 
+	dma_descriptor_unmap(txd);
 	if (!ds) {
 		dma_addr_t dmaaddr;
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0bc7275..9070050 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -413,6 +413,17 @@ void dma_chan_cleanup(struct kref *kref);
 typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
 
 typedef void (*dma_async_tx_callback)(void *dma_async_param);
+
+struct dmaengine_unmap_data {
+	u8 to_cnt;
+	u8 from_cnt;
+	u8 bidi_cnt;
+	struct device *dev;
+	struct kref kref;
+	size_t len;
+	dma_addr_t addr[0];
+};
+
 /**
  * struct dma_async_tx_descriptor - async transaction descriptor
  * ---dma generic offload fields---
@@ -438,6 +449,7 @@ struct dma_async_tx_descriptor {
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
+	struct dmaengine_unmap_data *unmap;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
@@ -445,6 +457,20 @@ struct dma_async_tx_descriptor {
 #endif
 };
 
+static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
+				 struct dmaengine_unmap_data *unmap)
+{
+	kref_get(&unmap->kref);
+	tx->unmap = unmap;
+}
+
+static inline void dma_descriptor_unmap(struct dma_async_tx_descriptor *tx)
+{
+	if (tx->unmap) {
+		tx->unmap = NULL;
+	}
+}
+
 #ifndef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 static inline void txd_lock(struct dma_async_tx_descriptor *txd)
 {
-- 
1.8.2.3

