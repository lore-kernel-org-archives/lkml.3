Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab3CGEQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:16:34 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:40374 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab3CGEQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:16:12 -0500
From: Matt Porter <mporter@ti.com>
To: Balaji T K <balajitk@ti.com>, Chris Ball <cjb@laptop.org>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [PATCH 1/2] mmc: omap_hsmmc: set max_segs based on dma engine limits
Date: Wed,  6 Mar 2013 23:16:38 -0500
Message-Id: <1362629799-22485-2-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362629799-22485-1-git-send-email-mporter@ti.com>
References: <1362629799-22485-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EDMA DMAC has a hardware limitation that prevents supporting
scatter gather lists with any number of segments. The DMA Engine
API reports the maximum number of segments a channel can support
via the optional dma_get_slave_sg_limits() API. If the max_nr_segs
limit is present, the value is used to configure mmc->max_segs
appropriately.

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap_hsmmc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e79b12d..f74d2ef 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1769,6 +1769,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	dma_cap_mask_t mask;
 	unsigned tx_req, rx_req;
+	struct dma_slave_sg_limits *dma_sg_limits;
 	struct pinctrl *pinctrl;
 
 	match = of_match_device(of_match_ptr(omap_mmc_of_match), &pdev->dev);
@@ -1935,6 +1936,13 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
+	/* Some DMA Engines only handle a limited number of SG segments */
+	dma_sg_limits = dma_get_slave_sg_limits(host->rx_chan,
+						DMA_SLAVE_BUSWIDTH_4_BYTES,
+						mmc->max_blk_size / 4);
+	if (dma_sg_limits && dma_sg_limits->max_seg_nr)
+		mmc->max_segs = dma_sg_limits->max_seg_nr;
+
 	/* Request IRQ for MMC operations */
 	ret = request_irq(host->irq, omap_hsmmc_irq, 0,
 			mmc_hostname(mmc), host);
-- 
1.7.9.5

