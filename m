Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbbAFGo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 01:44:59 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:56860 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbAFGo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 01:44:57 -0500
Date: Tue, 6 Jan 2015 06:44:56 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Vinod Koul <vinod.koul@intel.com>
cc: Paul Walmsley <pwalmsley@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dmaengine: tegra: add slave capabilities reporting
Message-ID: <alpine.DEB.2.02.1501060640220.28771@utopia.booyaka.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After commit ecc19d17868be9c9f8f00ed928791533c420f3e0 ("dmaengine: Add
a warning for drivers not using the generic slave caps retrieval"),
the Tegra APB DMA driver causes this warning during boot:

WARNING: CPU: 0 PID: 1 at drivers/dma/dmaengine.c:830 dma_async_device_register+0x294/0x538()
this driver doesn't support generic slave capabilities reporting

Fix by setting the appropriate reporting structure fields that are
passed to dma_async_device_register().

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Alexandre Courbot <gnurou@gmail.com>
---
Applies on next-20150105.  Boot-tested on Tegra132 Norrin FFD
(with a few unrelated patches not yet in mainline to get the board to 
boot)

 drivers/dma/tegra20-apb-dma.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 5695fb8..eaf585e 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1425,6 +1425,21 @@ static int tegra_dma_probe(struct platform_device *pdev)
 					tegra_dma_free_chan_resources;
 	tdma->dma_dev.device_prep_slave_sg = tegra_dma_prep_slave_sg;
 	tdma->dma_dev.device_prep_dma_cyclic = tegra_dma_prep_dma_cyclic;
+	tdma->dma_dev.src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
+		BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
+		BIT(DMA_SLAVE_BUSWIDTH_4_BYTES) |
+		BIT(DMA_SLAVE_BUSWIDTH_8_BYTES);
+	tdma->dma_dev.dst_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
+		BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
+		BIT(DMA_SLAVE_BUSWIDTH_4_BYTES) |
+		BIT(DMA_SLAVE_BUSWIDTH_8_BYTES);
+	tdma->dma_dev.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	/*
+	 * XXX The hardware appears to support
+	 * DMA_RESIDUE_GRANULARITY_BURST-level reporting, but it's
+	 * only used by this driver during tegra_dma_terminate_all()
+	 */
+	tdma->dma_dev.residue_granularity = DMA_RESIDUE_GRANULARITY_SEGMENT;
 	tdma->dma_dev.device_config = tegra_dma_slave_config;
 	tdma->dma_dev.device_terminate_all = tegra_dma_terminate_all;
 	tdma->dma_dev.device_tx_status = tegra_dma_tx_status;
-- 
2.0.0.GIT

