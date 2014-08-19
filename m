Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaHSR3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:29:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:28243 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbaHSR3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:29:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="587012965"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 06/12] dmaengine: dw: move clock operations to platform.c
Date: Tue, 19 Aug 2014 20:29:17 +0300
Message-Id: <1408469363-15901-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On BayTrail platform DMA is not functional in the PCI mode, whereby it always
failed and exit at the point when it tries to get a clock. It causes the PCI
mode probe to exit with the error message:
	dw_dmac_pci: probe of 0000:00:1e.0 failed with error -2

This patch moves clock operations to where it belongs to. Thus, the clock is
provided only in ACPI / non-PCI cases.

Reported-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/core.c     | 16 ----------------
 drivers/dma/dw/internal.h |  2 ++
 drivers/dma/dw/platform.c | 25 ++++++++++++++++++++++---
 drivers/dma/dw/regs.h     |  1 -
 4 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 10e43ea..9546b1f 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/bitops.h>
-#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
@@ -1488,13 +1487,6 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
 	dw->regs = chip->regs;
 	chip->dw = dw;
 
-	dw->clk = devm_clk_get(chip->dev, "hclk");
-	if (IS_ERR(dw->clk))
-		return PTR_ERR(dw->clk);
-	err = clk_prepare_enable(dw->clk);
-	if (err)
-		return err;
-
 	dw_params = dma_read_byaddr(chip->regs, DW_PARAMS);
 	autocfg = dw_params >> DW_PARAMS_EN & 0x1;
 
@@ -1665,7 +1657,6 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
 err_dma_register:
 	free_irq(chip->irq, dw);
 err_pdata:
-	clk_disable_unprepare(dw->clk);
 	return err;
 }
 EXPORT_SYMBOL_GPL(dw_dma_probe);
@@ -1687,8 +1678,6 @@ int dw_dma_remove(struct dw_dma_chip *chip)
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 	}
 
-	clk_disable_unprepare(dw->clk);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dw_dma_remove);
@@ -1698,7 +1687,6 @@ void dw_dma_shutdown(struct dw_dma_chip *chip)
 	struct dw_dma *dw = chip->dw;
 
 	dw_dma_off(dw);
-	clk_disable_unprepare(dw->clk);
 }
 EXPORT_SYMBOL_GPL(dw_dma_shutdown);
 
@@ -1709,8 +1697,6 @@ int dw_dma_suspend(struct dw_dma_chip *chip)
 	struct dw_dma *dw = chip->dw;
 
 	dw_dma_off(dw);
-	clk_disable_unprepare(dw->clk);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dw_dma_suspend);
@@ -1719,9 +1705,7 @@ int dw_dma_resume(struct dw_dma_chip *chip)
 {
 	struct dw_dma *dw = chip->dw;
 
-	clk_prepare_enable(dw->clk);
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dw_dma_resume);
diff --git a/drivers/dma/dw/internal.h b/drivers/dma/dw/internal.h
index 2c8d02f..82258a1 100644
--- a/drivers/dma/dw/internal.h
+++ b/drivers/dma/dw/internal.h
@@ -21,12 +21,14 @@
  * @dev:		struct device of the DMA controller
  * @irq:		irq line
  * @regs:		memory mapped I/O space
+ * @clk:		hclk clock
  * @dw:			struct dw_dma that is filed by dw_dma_probe()
  */
 struct dw_dma_chip {
 	struct device	*dev;
 	int		irq;
 	void __iomem	*regs;
+	struct clk	*clk;
 	struct dw_dma	*dw;
 };
 
diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
index 860c9ac..d50077e 100644
--- a/drivers/dma/dw/platform.c
+++ b/drivers/dma/dw/platform.c
@@ -178,10 +178,17 @@ static int dw_probe(struct platform_device *pdev)
 
 	chip->dev = dev;
 
-	err = dw_dma_probe(chip, pdata);
+	chip->clk = devm_clk_get(chip->dev, "hclk");
+	if (IS_ERR(chip->clk))
+		return PTR_ERR(chip->clk);
+	err = clk_prepare_enable(chip->clk);
 	if (err)
 		return err;
 
+	err = dw_dma_probe(chip, pdata);
+	if (err)
+		goto err_dw_dma_probe;
+
 	platform_set_drvdata(pdev, chip);
 
 	if (pdev->dev.of_node) {
@@ -196,6 +203,10 @@ static int dw_probe(struct platform_device *pdev)
 		dw_dma_acpi_controller_register(chip->dw);
 
 	return 0;
+
+err_dw_dma_probe:
+	clk_disable_unprepare(chip->clk);
+	return err;
 }
 
 static int dw_remove(struct platform_device *pdev)
@@ -205,7 +216,10 @@ static int dw_remove(struct platform_device *pdev)
 	if (pdev->dev.of_node)
 		of_dma_controller_free(pdev->dev.of_node);
 
-	return dw_dma_remove(chip);
+	dw_dma_remove(chip);
+	clk_disable_unprepare(chip->clk);
+
+	return 0;
 }
 
 static void dw_shutdown(struct platform_device *pdev)
@@ -213,6 +227,7 @@ static void dw_shutdown(struct platform_device *pdev)
 	struct dw_dma_chip *chip = platform_get_drvdata(pdev);
 
 	dw_dma_shutdown(chip);
+	clk_disable_unprepare(chip->clk);
 }
 
 #ifdef CONFIG_OF
@@ -238,7 +253,10 @@ static int dw_suspend_late(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_dma_chip *chip = platform_get_drvdata(pdev);
 
-	return dw_dma_suspend(chip);
+	dw_dma_suspend(chip);
+	clk_disable_unprepare(chip->clk);
+
+	return 0;
 }
 
 static int dw_resume_early(struct device *dev)
@@ -246,6 +264,7 @@ static int dw_resume_early(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_dma_chip *chip = platform_get_drvdata(pdev);
 
+	clk_prepare_enable(chip->clk);
 	return dw_dma_resume(chip);
 }
 
diff --git a/drivers/dma/dw/regs.h b/drivers/dma/dw/regs.h
index 0e82d99..00d27a9 100644
--- a/drivers/dma/dw/regs.h
+++ b/drivers/dma/dw/regs.h
@@ -251,7 +251,6 @@ struct dw_dma {
 	void __iomem		*regs;
 	struct dma_pool		*desc_pool;
 	struct tasklet_struct	tasklet;
-	struct clk		*clk;
 
 	/* channels */
 	struct dw_dma_chan	*chan;
-- 
2.1.0

