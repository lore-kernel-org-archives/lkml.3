Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945941Ab3AXV3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:29:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:40485 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160999Ab3AXVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [ 46/46] dma: tegra: implement flags parameters for cyclic transfer
Date: Thu, 24 Jan 2013 13:13:24 -0800
Message-Id: <20130124211151.374591048@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Dewangan <ldewangan@nvidia.com>

commit b9bb37f5486ba05d2b557dbf1aeb754fef618985 upstream.

The flag parameter is added in the cyclic transfer request.
Use the flag option of:
- DMA_PREP_INTERRUPT for enabling interrupt.
- DMA_CTRL_ACK for deciding whether ack is requred or not for
  descriptor.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/tegra20-apb-dma.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -266,6 +266,7 @@ static struct tegra_dma_desc *tegra_dma_
 		if (async_tx_test_ack(&dma_desc->txd)) {
 			list_del(&dma_desc->node);
 			spin_unlock_irqrestore(&tdc->lock, flags);
+			dma_desc->txd.flags = 0;
 			return dma_desc;
 		}
 	}
@@ -1050,7 +1051,9 @@ struct dma_async_tx_descriptor *tegra_dm
 					TEGRA_APBDMA_AHBSEQ_WRAP_SHIFT;
 	ahb_seq |= TEGRA_APBDMA_AHBSEQ_BUS_WIDTH_32;
 
-	csr |= TEGRA_APBDMA_CSR_FLOW | TEGRA_APBDMA_CSR_IE_EOC;
+	csr |= TEGRA_APBDMA_CSR_FLOW;
+	if (flags & DMA_PREP_INTERRUPT)
+		csr |= TEGRA_APBDMA_CSR_IE_EOC;
 	csr |= tdc->dma_sconfig.slave_id << TEGRA_APBDMA_CSR_REQ_SEL_SHIFT;
 
 	apb_seq |= TEGRA_APBDMA_APBSEQ_WRAP_WORD_1;
@@ -1095,7 +1098,8 @@ struct dma_async_tx_descriptor *tegra_dm
 		mem += len;
 	}
 	sg_req->last_sg = true;
-	dma_desc->txd.flags = 0;
+	if (flags & DMA_CTRL_ACK)
+		dma_desc->txd.flags = DMA_CTRL_ACK;
 
 	/*
 	 * Make sure that mode should not be conflicting with currently


