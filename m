Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3EJIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:16:56 -0400
Received: from sauhun.de ([89.238.76.85]:60436 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab3EJIQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:52 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: [RFC 16/42] drivers/mtd/nand: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:01 +0200
Message-Id: <1368173847-5661-17-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/mtd/nand/lpc32xx_mlc.c |    5 -----
 drivers/mtd/nand/lpc32xx_slc.c |    7 +------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/mtd/nand/lpc32xx_mlc.c b/drivers/mtd/nand/lpc32xx_mlc.c
index 0ca22ae..3a5762c 100644
--- a/drivers/mtd/nand/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/lpc32xx_mlc.c
@@ -672,11 +672,6 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	}
 
 	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (rc == NULL) {
-		dev_err(&pdev->dev, "No memory resource found for device!\r\n");
-		return -ENXIO;
-	}
-
 	host->io_base = devm_ioremap_resource(&pdev->dev, rc);
 	if (IS_ERR(host->io_base))
 		return PTR_ERR(host->io_base);
diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index be94ed5..f342f7b 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -764,12 +764,6 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	struct mtd_part_parser_data ppdata = {};
 	int res;
 
-	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (rc == NULL) {
-		dev_err(&pdev->dev, "No memory resource found for device\n");
-		return -EBUSY;
-	}
-
 	/* Allocate memory for the device structure (and zero it) */
 	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
 	if (!host) {
@@ -778,6 +772,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	}
 	host->io_base_dma = rc->start;
 
+	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->io_base = devm_ioremap_resource(&pdev->dev, rc);
 	if (IS_ERR(host->io_base))
 		return PTR_ERR(host->io_base);
-- 
1.7.10.4

