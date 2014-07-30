Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaG3If4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:35:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53536 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535AbaG3IfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:35:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/3] dmaengine: sun6i: Fix memory leaks
Date: Wed, 30 Jul 2014 10:30:23 +0200
Message-Id: <1406709023-7650-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406709023-7650-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1406709023-7650-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sun6i_dma_prep_memcpy and sun6i_dma_prep_slave_sg functions were both
leaking the descriptor they allocated if an  error was happening after a
successful dma_pool_alloc call.

It also fixes a memleak that was happening in the scatter gather list
traversal, that was allocating as much descriptor as there was scatter gather
items, but only freeing the current descriptor if an error was to arise.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/sun6i-dma.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 63a1db38894e..1f92a56fd2b6 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -562,8 +562,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_memcpy(
 	v_lli = dma_pool_alloc(sdev->pool, GFP_NOWAIT, &p_lli);
 	if (!v_lli) {
 		dev_err(sdev->slave.dev, "Failed to alloc lli memory\n");
-		kfree(txd);
-		return NULL;
+		goto err_txd_free;
 	}
 
 	ret = sun6i_dma_cfg_lli(v_lli, src, dest, len, sconfig);
@@ -583,6 +582,8 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_memcpy(
 
 err_dma_free:
 	dma_pool_free(sdev->pool, v_lli, p_lli);
+err_txd_free:
+	kfree(txd);
 	return NULL;
 }
 
@@ -614,17 +615,15 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_slave_sg(
 
 	for_each_sg(sgl, sg, sg_len, i) {
 		v_lli = dma_pool_alloc(sdev->pool, GFP_NOWAIT, &p_lli);
-		if (!v_lli) {
-			kfree(txd);
-			return NULL;
-		}
+		if (!v_lli)
+			goto err_lli_free;
 
 		if (dir == DMA_MEM_TO_DEV) {
 			ret = sun6i_dma_cfg_lli(v_lli, sg_dma_address(sg),
 						sconfig->dst_addr, sg_dma_len(sg),
 						sconfig);
 			if (ret)
-				goto err_dma_free;
+				goto err_cur_lli_free;
 
 			v_lli->cfg |= DMA_CHAN_CFG_DST_IO_MODE |
 				DMA_CHAN_CFG_SRC_LINEAR_MODE |
@@ -642,7 +641,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_slave_sg(
 						sg_dma_address(sg), sg_dma_len(sg),
 						sconfig);
 			if (ret)
-				goto err_dma_free;
+				goto err_cur_lli_free;
 
 			v_lli->cfg |= DMA_CHAN_CFG_DST_LINEAR_MODE |
 				DMA_CHAN_CFG_SRC_IO_MODE |
@@ -665,8 +664,12 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_slave_sg(
 
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
-err_dma_free:
+err_cur_lli_free:
 	dma_pool_free(sdev->pool, v_lli, p_lli);
+err_lli_free:
+	for (prev = txd->v_lli; prev; prev = prev->v_lli_next)
+		dma_pool_free(sdev->pool, prev, virt_to_phys(prev));
+	kfree(txd);
 	return NULL;
 }
 
-- 
2.0.2

