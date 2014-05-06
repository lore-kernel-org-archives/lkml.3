Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaEFVW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:22:26 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12478 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaEFVWT (ORCPT
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
Subject: [PATCH v1 3/3] dma: tegra: avoid int overflow for transferred count
Date: Tue, 6 May 2014 14:22:23 -0700
Message-ID: <1399411343-12222-4-git-send-email-cfreeman@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bytes_transferred will overflow during long audio playbacks.  Since
the driver only ever consults this value modulo bytes_requested, store the
value modulo bytes_requested.

Signed-off-by: Christopher Freeman <cfreeman@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 094e97d..e1b80a4 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -583,7 +583,9 @@ static void handle_once_dma_done(struct tegra_dma_channel *tdc,
 	tdc->busy = false;
 	sgreq = list_first_entry(&tdc->pending_sg_req, typeof(*sgreq), node);
 	dma_desc = sgreq->dma_desc;
-	dma_desc->bytes_transferred += sgreq->req_len;
+	dma_desc->bytes_transferred = (dma_desc->bytes_transferred +
+					sgreq->req_len) %
+					dma_desc->bytes_requested;
 
 	list_del(&sgreq->node);
 	if (sgreq->last_sg) {
@@ -613,7 +615,9 @@ static void handle_cont_sngl_cycle_dma_done(struct tegra_dma_channel *tdc,
 
 	sgreq = list_first_entry(&tdc->pending_sg_req, typeof(*sgreq), node);
 	dma_desc = sgreq->dma_desc;
-	dma_desc->bytes_transferred += sgreq->req_len;
+	dma_desc->bytes_transferred = (dma_desc->bytes_transferred +
+					sgreq->req_len) %
+					dma_desc->bytes_requested;
 
 	/* Callback need to be call */
 	if (!dma_desc->cb_count)
@@ -762,8 +766,10 @@ static void tegra_dma_terminate_all(struct dma_chan *dc)
 	if (!list_empty(&tdc->pending_sg_req) && was_busy) {
 		sgreq = list_first_entry(&tdc->pending_sg_req,
 					typeof(*sgreq), node);
-		sgreq->dma_desc->bytes_transferred +=
-				get_current_xferred_count(tdc, sgreq, wcount);
+		sgreq->dma_desc->bytes_transferred =
+				(sgreq->dma_desc->bytes_transferred +
+				 get_current_xferred_count(tdc, sgreq, wcount)) %
+				 sgreq->dma_desc->bytes_requested;
 	}
 	tegra_dma_resume(tdc);
 
@@ -838,8 +844,7 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 	list_for_each_entry(dma_desc, &tdc->free_dma_desc, node) {
 		if (dma_desc->txd.cookie == cookie) {
 			residual =  dma_desc->bytes_requested -
-					(dma_desc->bytes_transferred %
-						dma_desc->bytes_requested);
+					dma_desc->bytes_transferred;
 			dma_set_residue(txstate, residual);
 			ret = dma_desc->dma_status;
 			spin_unlock_irqrestore(&tdc->lock, flags);
@@ -859,8 +864,7 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 						typeof(*first_entry), node);
 
 			residual =  dma_desc->bytes_requested -
-					(dma_desc->bytes_transferred %
-						dma_desc->bytes_requested);
+					dma_desc->bytes_transferred;
 
 			/* hw byte count only applies to current transaction */
 			if (first_entry &&
-- 
1.7.9.5

