Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab3BAVBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:01:18 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:59847 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab3BAVAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:00:49 -0500
From: Matt Porter <mporter@ti.com>
To: Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 2/3] mmc: omap_hsmmc: Skip platform_get_resource_byname() for dt case
Date: Fri,  1 Feb 2013 16:01:18 -0500
Message-Id: <1359752479-29427-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359752479-29427-1-git-send-email-mporter@ti.com>
References: <1359752479-29427-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

MMC driver probe will abort for DT case because of failed
platform_get_resource_byname() lookup. Fix it by skipping resource
byname lookup for device tree build.

Issue is hidden because hwmod popullates the IO resources which
helps to succeed platform_get_resource_byname() and probe.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e79b12d..8ae1225 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1896,21 +1896,23 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 	omap_hsmmc_conf_bus_power(host);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
-	if (!res) {
-		dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
-		ret = -ENXIO;
-		goto err_irq;
-	}
-	tx_req = res->start;
+	if (!pdev->dev.of_node) {
+		res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
+		if (!res) {
+			dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
+			ret = -ENXIO;
+			goto err_irq;
+		}
+		tx_req = res->start;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
-	if (!res) {
-		dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
-		ret = -ENXIO;
-		goto err_irq;
+		res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
+		if (!res) {
+			dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
+			ret = -ENXIO;
+			goto err_irq;
+		}
+		rx_req = res->start;
 	}
-	rx_req = res->start;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-- 
1.7.9.5

