Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3EaKMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:12:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56834 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab3EaKMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:12:14 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <grant.likely@linaro.org>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <vaibhav.bedia@ti.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        <spi-devel-general@lists.sourceforge.net>
Subject: [PATCH 05/11] spi: omap2-mcspi: enhance pinctrl support
Date: Fri, 31 May 2013 15:43:05 +0530
Message-ID: <1369995191-20855-6-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend the spi omap controller to optionally take a pin control
handle and set the state of the pins to:

- "default" on boot, resume and before performing an spi transfer
- "idle" after initial default, after resume default, and after each
spi xfer
- "sleep" on suspend()

By optionally putting the pins into sleep state in the suspend callback
we can accomplish two things.
- One is to minimize current leakage from pins and thus save power,
- second, we can prevent the IP from driving pins output in an
uncontrolled manner, which may happen if the power domain drops the
domain regulator.

If any of the above pin states are missing in dt, a warning message
about the missing state is displayed.
If certain pin-states are not available, to remove this warning message
pass respective state name with null phandler.

(Changes based on i2c-nomadik.c & spi-pl022.c)

Note:
A .suspend callback is added which simply puts the pins to sleep state.
They are moved to default & idle state by the .resume callback.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: spi-devel-general@lists.sourceforge.net
---
:100644 100644 86d2158... 146dd16... M	drivers/spi/spi-omap2-mcspi.c
 drivers/spi/spi-omap2-mcspi.c |   89 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 86d2158..146dd16 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -130,6 +130,12 @@ struct omap2_mcspi {
 	struct device		*dev;
 	struct omap2_mcspi_regs ctx;
 	unsigned int		pin_dir:1;
+
+	/* Three pin states - default, idle & sleep */
+	struct pinctrl			*pinctrl;
+	struct pinctrl_state		*pins_default;
+	struct pinctrl_state		*pins_idle;
+	struct pinctrl_state		*pins_sleep;
 };
 
 struct omap2_mcspi_cs {
@@ -267,6 +273,12 @@ static int omap2_prepare_transfer(struct spi_master *master)
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(master);
 
 	pm_runtime_get_sync(mcspi->dev);
+
+	/* Optionaly enable pins to be muxed in and configured */
+	if (!IS_ERR(mcspi->pins_default))
+		if (pinctrl_select_state(mcspi->pinctrl, mcspi->pins_default))
+			dev_err(mcspi->dev, "could not set default pins\n");
+
 	return 0;
 }
 
@@ -274,6 +286,12 @@ static int omap2_unprepare_transfer(struct spi_master *master)
 {
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(master);
 
+	/* Optionally let pins go into idle state */
+	if (!IS_ERR(mcspi->pins_idle))
+		if (pinctrl_select_state(mcspi->pinctrl, mcspi->pins_idle))
+			dev_err(mcspi->dev,
+				"could not set pins to idle state\n");
+
 	pm_runtime_mark_last_busy(mcspi->dev);
 	pm_runtime_put_autosuspend(mcspi->dev);
 	return 0;
@@ -1186,7 +1204,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	static int		bus_num = 1;
 	struct device_node	*node = pdev->dev.of_node;
 	const struct of_device_id *match;
-	struct pinctrl *pinctrl;
 
 	master = spi_alloc_master(&pdev->dev, sizeof *mcspi);
 	if (master == NULL) {
@@ -1284,10 +1301,46 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	if (status < 0)
 		goto dma_chnl_free;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev,
-				"pins are not configured from the driver\n");
+	mcspi->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (!IS_ERR(mcspi->pinctrl)) {
+		mcspi->pins_default = pinctrl_lookup_state(mcspi->pinctrl,
+							 PINCTRL_STATE_DEFAULT);
+		if (IS_ERR(mcspi->pins_default))
+			dev_dbg(&pdev->dev, "could not get default pinstate\n");
+		else
+			if (pinctrl_select_state(mcspi->pinctrl,
+						 mcspi->pins_default))
+				dev_err(&pdev->dev,
+					"could not set default pinstate\n");
+
+		mcspi->pins_idle = pinctrl_lookup_state(mcspi->pinctrl,
+						      PINCTRL_STATE_IDLE);
+		if (IS_ERR(mcspi->pins_idle))
+			dev_dbg(&pdev->dev, "could not get idle pinstate\n");
+		else
+			/* If possible, let's idle until the first transfer */
+			if (pinctrl_select_state(mcspi->pinctrl,
+						 mcspi->pins_idle))
+				dev_err(&pdev->dev,
+					"could not set idle pinstate\n");
+
+		mcspi->pins_sleep = pinctrl_lookup_state(mcspi->pinctrl,
+						       PINCTRL_STATE_SLEEP);
+		if (IS_ERR(mcspi->pins_sleep))
+			dev_dbg(&pdev->dev, "could not get sleep pinstate\n");
+	} else {
+		/*
+		* Since we continue even when pinctrl node is not found,
+		* Invalidate pins as not available. This is to make sure that
+		* IS_ERR(pins_xxx) results in failure when used.
+		*/
+		mcspi->pins_default = ERR_PTR(-ENODATA);
+		mcspi->pins_idle = ERR_PTR(-ENODATA);
+		mcspi->pins_sleep = ERR_PTR(-ENODATA);
+
+		dev_dbg(&pdev->dev, "did not get pins for i2c error: %li\n",
+			PTR_ERR(mcspi->pinctrl));
+	}
 
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
@@ -1335,6 +1388,18 @@ static int omap2_mcspi_remove(struct platform_device *pdev)
 MODULE_ALIAS("platform:omap2_mcspi");
 
 #ifdef	CONFIG_SUSPEND
+static int omap2_mcspi_suspend(struct device *dev)
+{
+	struct spi_master	*master = dev_get_drvdata(dev);
+	struct omap2_mcspi	*mcspi = spi_master_get_devdata(master);
+
+	if (!IS_ERR(mcspi->pins_sleep))
+		if (pinctrl_select_state(mcspi->pinctrl, mcspi->pins_sleep))
+			dev_err(dev, "could not set pins to sleep state\n");
+
+	return 0;
+}
+
 /*
  * When SPI wake up from off-mode, CS is in activate state. If it was in
  * unactive state when driver was suspend, then force it to unactive state at
@@ -1348,6 +1413,17 @@ static int omap2_mcspi_resume(struct device *dev)
 	struct omap2_mcspi_cs	*cs;
 
 	pm_runtime_get_sync(mcspi->dev);
+
+	/* First go to the default state */
+	if (!IS_ERR(mcspi->pins_default))
+		if (pinctrl_select_state(mcspi->pinctrl, mcspi->pins_default))
+			dev_err(dev, "could not set pins to default state\n");
+
+	/* Then let's idle the pins until the next transfer happens */
+	if (!IS_ERR(mcspi->pins_idle))
+		if (pinctrl_select_state(mcspi->pinctrl, mcspi->pins_idle))
+			dev_err(dev, "could not set pins to idle state\n");
+
 	list_for_each_entry(cs, &ctx->cs, node) {
 		if ((cs->chconf0 & OMAP2_MCSPI_CHCONF_FORCE) == 0) {
 			/*
@@ -1364,12 +1440,15 @@ static int omap2_mcspi_resume(struct device *dev)
 	pm_runtime_put_autosuspend(mcspi->dev);
 	return 0;
 }
+
 #else
+#define	omap2_mcspi_suspend	NULL
 #define	omap2_mcspi_resume	NULL
 #endif
 
 static const struct dev_pm_ops omap2_mcspi_pm_ops = {
 	.resume = omap2_mcspi_resume,
+	.suspend = omap2_mcspi_suspend,
 	.runtime_resume	= omap_mcspi_runtime_resume,
 };
 
-- 
1.7.9.5

