Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3AUJbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:31:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:37125 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab3AUJbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:31:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="276287979"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 07/10] spi/pxa2xx: add support for runtime PM
Date: Mon, 21 Jan 2013 11:32:00 +0200
Message-Id: <1358760723-32752-8-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should put the device into low power states proactively whenever the
device is not in use. Thus implement support for runtime PM and use the
autosuspend feature to make sure that we can still perform well in case we see
lots of SPI traffic within short period of time.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c |   73 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 67 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index a08df23..7fa2e8e 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -30,6 +30,7 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -427,10 +428,20 @@ static irqreturn_t ssp_int(int irq, void *dev_id)
 {
 	struct driver_data *drv_data = dev_id;
 	void __iomem *reg = drv_data->ioaddr;
-	u32 sccr1_reg = read_SSCR1(reg);
+	u32 sccr1_reg;
 	u32 mask = drv_data->mask_sr;
 	u32 status;
 
+	/*
+	 * The IRQ might be shared with other peripherals so we must first
+	 * check that are we RPM suspended or not. If we are we assume that
+	 * the IRQ was not for us (we shouldn't be RPM suspended when the
+	 * interrupt is enabled).
+	 */
+	if (pm_runtime_suspended(&drv_data->pdev->dev))
+		return IRQ_NONE;
+
+	sccr1_reg = read_SSCR1(reg);
 	status = read_SSSR(reg);
 
 	/* Ignore possible writes if we don't need to write */
@@ -687,6 +698,27 @@ static int pxa2xx_spi_transfer_one_message(struct spi_master *master,
 	return 0;
 }
 
+static int pxa2xx_spi_prepare_transfer(struct spi_master *master)
+{
+	struct driver_data *drv_data = spi_master_get_devdata(master);
+
+	pm_runtime_get_sync(&drv_data->pdev->dev);
+	return 0;
+}
+
+static int pxa2xx_spi_unprepare_transfer(struct spi_master *master)
+{
+	struct driver_data *drv_data = spi_master_get_devdata(master);
+
+	/* Disable the SSP now */
+	write_SSCR0(read_SSCR0(drv_data->ioaddr) & ~SSCR0_SSE,
+		    drv_data->ioaddr);
+
+	pm_runtime_mark_last_busy(&drv_data->pdev->dev);
+	pm_runtime_put_autosuspend(&drv_data->pdev->dev);
+	return 0;
+}
+
 static int setup_cs(struct spi_device *spi, struct chip_data *chip,
 		    struct pxa2xx_spi_chip *chip_info)
 {
@@ -923,6 +955,8 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	master->cleanup = cleanup;
 	master->setup = setup;
 	master->transfer_one_message = pxa2xx_spi_transfer_one_message;
+	master->prepare_transfer_hardware = pxa2xx_spi_prepare_transfer;
+	master->unprepare_transfer_hardware = pxa2xx_spi_unprepare_transfer;
 
 	drv_data->ssp_type = ssp->type;
 	drv_data->null_dma_buf = (u32 *)PTR_ALIGN(&drv_data[1], DMA_ALIGNMENT);
@@ -988,6 +1022,11 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 		goto out_error_clock_enabled;
 	}
 
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 50);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return status;
 
 out_error_clock_enabled:
@@ -1010,6 +1049,8 @@ static int pxa2xx_spi_remove(struct platform_device *pdev)
 		return 0;
 	ssp = drv_data->ssp;
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	/* Disable the SSP at the peripheral and SOC level */
 	write_SSCR0(0, drv_data->ioaddr);
 	clk_disable_unprepare(ssp->clk);
@@ -1018,6 +1059,9 @@ static int pxa2xx_spi_remove(struct platform_device *pdev)
 	if (drv_data->master_info->enable_dma)
 		dma_release(drv_data);
 
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	/* Release IRQ */
 	free_irq(ssp->irq, drv_data);
 
@@ -1077,20 +1121,37 @@ static int pxa2xx_spi_resume(struct device *dev)
 
 	return 0;
 }
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+static int pxa2xx_spi_runtime_suspend(struct device *dev)
+{
+	struct driver_data *drv_data = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(drv_data->ssp->clk);
+	return 0;
+}
+
+static int pxa2xx_spi_runtime_resume(struct device *dev)
+{
+	struct driver_data *drv_data = dev_get_drvdata(dev);
+
+	clk_prepare_enable(drv_data->ssp->clk);
+	return 0;
+}
+#endif
 
 static const struct dev_pm_ops pxa2xx_spi_pm_ops = {
-	.suspend	= pxa2xx_spi_suspend,
-	.resume		= pxa2xx_spi_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(pxa2xx_spi_suspend, pxa2xx_spi_resume)
+	SET_RUNTIME_PM_OPS(pxa2xx_spi_runtime_suspend,
+			   pxa2xx_spi_runtime_resume, NULL)
 };
-#endif
 
 static struct platform_driver driver = {
 	.driver = {
 		.name	= "pxa2xx-spi",
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm	= &pxa2xx_spi_pm_ops,
-#endif
 	},
 	.probe = pxa2xx_spi_probe,
 	.remove = pxa2xx_spi_remove,
-- 
1.7.10.4

