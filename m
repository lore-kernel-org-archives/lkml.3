Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3AOU2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:28:43 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:55607 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3AOU2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:28:32 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v5 09/14] mmc: omap_hsmmc: set max_segs based on dma engine limitations
Date: Tue, 15 Jan 2013 15:32:49 -0500
Message-Id: <1358281974-8411-10-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358281974-8411-1-git-send-email-mporter@ti.com>
References: <1358281974-8411-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EDMA DMAC has a hardware limitation that prevents supporting
scatter gather lists with any number of segments. The DMA Engine
API reports the maximum number of segments a channel can support
via the optional dma_get_channel_caps() API. If the nr_segs
capability is present, the value is used to configure mmc->max_segs
appropriately.

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap_hsmmc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e79b12d..f74bd69 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1769,6 +1769,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	dma_cap_mask_t mask;
 	unsigned tx_req, rx_req;
+	struct dmaengine_chan_caps *dma_chan_caps;
 	struct pinctrl *pinctrl;
 
 	match = of_match_device(of_match_ptr(omap_mmc_of_match), &pdev->dev);
@@ -1935,6 +1936,11 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
+	/* Some DMA Engines only handle a limited number of SG segments */
+	dma_chan_caps = dma_get_channel_caps(host->rx_chan, DMA_DEV_TO_MEM);
+	if (dma_chan_caps && dma_chan_caps->seg_nr)
+		mmc->max_segs = dma_chan_caps->seg_nr;
+
 	/* Request IRQ for MMC operations */
 	ret = request_irq(host->irq, omap_hsmmc_irq, 0,
 			mmc_hostname(mmc), host);
-- 
1.7.9.5

