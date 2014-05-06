Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaEFVWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:22:25 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11267 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaEFVWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:22:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 06 May 2014 14:12:05 -0700
From: Christopher Freeman <cfreeman@nvidia.com>
To: <ldewangan@nvidia.com>, <swarren@nvidia.com>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christopher Freeman <cfreeman@nvidia.com>
Subject: [PATCH v1 1/3] dma: tegra: finer granularity residual for tx_status
Date: Tue, 6 May 2014 14:22:21 -0700
Message-ID: <1399411343-12222-2-git-send-email-cfreeman@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get word-level granularity from hardware for calculating
the transfer count remaining.

Signed-off-by: Christopher Freeman <cfreeman@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |   52 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 03ad64e..cc6b2fd 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -779,15 +779,54 @@ skip_dma_stop:
 	spin_unlock_irqrestore(&tdc->lock, flags);
 }
 
+static int tegra_dma_wcount_in_bytes(struct dma_chan *dc)
+{
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+	struct tegra_dma_sg_req *sgreq;
+	unsigned long wcount = 0;
+	unsigned long status = 0;
+	int bytes = 0;
+
+	if (list_empty(&tdc->pending_sg_req) || !tdc->busy)
+		return 0;
+
+	tegra_dma_pause(tdc, true);
+
+	/* in case of interrupt, handle it and don't read wcount reg */
+	status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
+	if (status & TEGRA_APBDMA_STATUS_ISE_EOC) {
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_STATUS, status);
+		dev_info(tdc2dev(tdc), "%s():handling isr\n", __func__);
+		tdc->isr_handler(tdc, false);
+		tegra_dma_resume(tdc);
+		return 0;
+	}
+
+	if (tdc->tdma->chip_data->support_separate_wcount_reg)
+		wcount = tdc_read(tdc, TEGRA_APBDMA_CHAN_WORD_TRANSFER);
+	else
+		wcount = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
+
+	sgreq = list_first_entry(&tdc->pending_sg_req,
+				typeof(*sgreq), node);
+	bytes = get_current_xferred_count(tdc, sgreq, wcount);
+
+	tegra_dma_resume(tdc);
+
+	return bytes;
+}
+
 static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 	dma_cookie_t cookie, struct dma_tx_state *txstate)
 {
 	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
 	struct tegra_dma_desc *dma_desc;
 	struct tegra_dma_sg_req *sg_req;
+	struct tegra_dma_sg_req *first_entry = NULL;
 	enum dma_status ret;
 	unsigned long flags;
 	unsigned int residual;
+	unsigned int hw_byte_count = 0;
 
 	ret = dma_cookie_status(dc, cookie, txstate);
 	if (ret == DMA_COMPLETE)
@@ -812,9 +851,22 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 	list_for_each_entry(sg_req, &tdc->pending_sg_req, node) {
 		dma_desc = sg_req->dma_desc;
 		if (dma_desc->txd.cookie == cookie) {
+			hw_byte_count = tegra_dma_wcount_in_bytes(dc);
+
+			if (!list_empty(&tdc->pending_sg_req))
+				first_entry =
+					list_first_entry(&tdc->pending_sg_req,
+						typeof(*first_entry), node);
+
 			residual =  dma_desc->bytes_requested -
 					(dma_desc->bytes_transferred %
 						dma_desc->bytes_requested);
+
+			/* hw byte count only applies to current transaction */
+			if (first_entry &&
+				first_entry->dma_desc->txd.cookie == cookie)
+				residual -= hw_byte_count;
+
 			dma_set_residue(txstate, residual);
 			ret = dma_desc->dma_status;
 			spin_unlock_irqrestore(&tdc->lock, flags);
-- 
1.7.9.5

