Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab3CYNOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:14:51 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1071 "EHLO
	smtp-out-223.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab3CYNOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:14:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32236
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: Jon Hunter <jon-hunter@ti.com>, Padmavathi Venna <padma.v@samsung.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] dma: pl330: Use the generic of_dma_xlate_by_chan_id
Date: Mon, 25 Mar 2013 14:16:52 +0100
Message-Id: <1364217412-31905-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1364217412-31905-1-git-send-email-lars@metafoo.de>
References: <1364217412-31905-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic of_dma_xlate_by_chan_id xlate callback instead of a custom
implementation.

There is one minor difference between the generic of_dma_xlate_by_chan_id
function and the pl330 specific one. of_dma_xlate_by_chan_id only sets the
DMA_SLAVE capability for the channel capability mask, while the pl330 driver
additionally sets the DMA_CYCLIC capability. But since all pl330 channels which
have the DMA_SLAVE capability set also have DMA_CYCLIC capability set both
functions will have the same result.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/pl330.c | 41 +----------------------------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 345e2a1..ea48de7 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -608,11 +608,6 @@ struct dma_pl330_desc {
 	struct dma_pl330_chan *pchan;
 };
 
-struct dma_pl330_filter_args {
-	struct dma_pl330_dmac *pdmac;
-	unsigned int chan_id;
-};
-
 static inline void _callback(struct pl330_req *r, enum pl330_op_err err)
 {
 	if (r && r->xfer_cb)
@@ -2358,16 +2353,6 @@ static void dma_pl330_rqcb(void *token, enum pl330_op_err err)
 	tasklet_schedule(&pch->task);
 }
 
-static bool pl330_dt_filter(struct dma_chan *chan, void *param)
-{
-	struct dma_pl330_filter_args *fargs = param;
-
-	if (chan->device != &fargs->pdmac->ddma)
-		return false;
-
-	return (chan->chan_id == fargs->chan_id);
-}
-
 bool pl330_filter(struct dma_chan *chan, void *param)
 {
 	u8 *peri_id;
@@ -2380,30 +2365,6 @@ bool pl330_filter(struct dma_chan *chan, void *param)
 }
 EXPORT_SYMBOL(pl330_filter);
 
-static struct dma_chan *of_dma_pl330_xlate(struct of_phandle_args *dma_spec,
-						struct of_dma *ofdma)
-{
-	int count = dma_spec->args_count;
-	struct dma_pl330_dmac *pdmac = ofdma->of_dma_data;
-	struct dma_pl330_filter_args fargs;
-	dma_cap_mask_t cap;
-
-	if (!pdmac)
-		return NULL;
-
-	if (count != 1)
-		return NULL;
-
-	fargs.pdmac = pdmac;
-	fargs.chan_id = dma_spec->args[0];
-
-	dma_cap_zero(cap);
-	dma_cap_set(DMA_SLAVE, cap);
-	dma_cap_set(DMA_CYCLIC, cap);
-
-	return dma_request_channel(cap, pl330_dt_filter, &fargs);
-}
-
 static int pl330_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct dma_pl330_chan *pch = to_pchan(chan);
@@ -2996,7 +2957,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		pi->pcfg.num_peri, pi->pcfg.num_events);
 
 	ret = of_dma_controller_register(adev->dev.of_node,
-					 of_dma_pl330_xlate, pdmac);
+					 of_dma_xlate_by_chan_id, pd);
 	if (ret) {
 		dev_err(&adev->dev,
 		"unable to register DMA to the generic DT DMA helpers\n");
-- 
1.8.0

