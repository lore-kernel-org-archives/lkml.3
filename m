Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3AaKqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:46:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36008 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab3AaKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:45:46 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-mmc@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <hs@denx.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjb@laptop.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@ti.com>,
        <ido@wizery.com>, <gregkh@linuxfoundation.org>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] mmc: davinci_mmc: add DT support
Date: Thu, 31 Jan 2013 16:03:06 +0530
Message-ID: <1359628387-14437-3-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359628387-14437-1-git-send-email-prakash.pm@ti.com>
References: <1359628387-14437-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds device tree support for davinci_mmc. Also add
binding documentation.
Tested with non-dma PIO mode and without GPIO
card_detect/write_protect option because of
dependencies on EDMA and GPIO modules DT support.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: devicetree-discuss@lists.ozlabs.org
Cc: cjb@laptop.org
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: mporter@ti.com
---
 .../devicetree/bindings/mmc/davinci_mmc.txt        |   23 +++++++
 drivers/mmc/host/davinci_mmc.c                     |   69 +++++++++++++++++++-
 2 files changed, 91 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/davinci_mmc.txt

diff --git a/Documentation/devicetree/bindings/mmc/davinci_mmc.txt b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
new file mode 100644
index 0000000..144bee6
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
@@ -0,0 +1,23 @@
+* TI Highspeed MMC host controller for DaVinci
+
+The Highspeed MMC Host Controller on TI DaVinci family
+provides an interface for MMC, SD and SDIO types of memory cards.
+
+This file documents differences between the core properties described
+by mmc.txt and the properties used by the davinci_mmc driver.
+
+Required properties:
+- compatible:
+ Should be "ti,davinci_mmc", for davinci controllers
+
+Optional properties:
+- bus-width: Number of data lines, can be <1>, <4>, or <8>, default <1>
+- max-frequency: maximum operating clock frequency.
+- caps: Check for Host capabilities in <linux/mmc/host.h>
+- version: version of controller.
+Example:
+	mmc1: mmc@0x4809c000 {
+		compatible = "ti,omap4-hsmmc";
+		reg = <0x4809c000 0x400>;
+		bus-width = <4>;
+	};
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 382b79d..ce6730d 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -34,6 +34,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/edma.h>
 #include <linux/mmc/mmc.h>
+#include <linux/of.h>
 
 #include <linux/platform_data/mmc-davinci.h>
 
@@ -1156,16 +1157,75 @@ static void __init init_mmcsd_host(struct mmc_davinci_host *host)
 
 	mmc_davinci_reset_ctrl(host, 0);
 }
+#ifdef CONFIG_OF
+static struct davinci_mmc_config
+	*mmc_of_get_pdata(struct platform_device *pdev)
+{
+	struct device_node *np;
+	struct davinci_mmc_config *pdata = NULL;
+	u32 data;
+	int ret;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata) {
+			dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
+			goto nodata;
+		}
+	}
+
+	np = pdev->dev.of_node;
+	if (!np)
+		goto nodata;
+
+	ret = of_property_read_u32(np, "bus-width", &data);
+	if (ret)
+		dev_info(&pdev->dev, "wires not specified, defaulting to 4 bit mode\n");
+	pdata->wires = data;
+
+	ret = of_property_read_u32(np, "max-frequency", &data);
+	if (ret)
+		dev_info(&pdev->dev, "max-frequency not specified, defaulting to 25MHz\n");
+	pdata->max_freq = data;
+
+	ret = of_property_read_u32(np, "caps", &data);
+	if (ret)
+		dev_info(&pdev->dev, "card capability not specified\n");
+	pdata->caps = data;
+
+	ret = of_property_read_u32(np, "version", &data);
+	if (ret)
+		dev_err(&pdev->dev, "version not specified\n");
+	pdata->version = data;
+
+nodata:
+	return pdata;
+}
+
+#else
+static struct davinci_mmc_config
+	*mmc_of_get_pdata(struct platform_device *pdev)
+{
+	return pdev->dev.platform_data;
+}
+#endif
 
 static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 {
-	struct davinci_mmc_config *pdata = pdev->dev.platform_data;
+	struct davinci_mmc_config *pdata = NULL;
 	struct mmc_davinci_host *host = NULL;
 	struct mmc_host *mmc = NULL;
 	struct resource *r, *mem = NULL;
 	int ret = 0, irq = 0;
 	size_t mem_size;
 
+	pdata = mmc_of_get_pdata(pdev);
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "Can not get platform data\n");
+		return -ENOENT;
+	}
+
 	/* REVISIT:  when we're fully converted, fail if pdata is NULL */
 
 	ret = -ENODEV;
@@ -1403,11 +1463,18 @@ static const struct dev_pm_ops davinci_mmcsd_pm = {
 #define davinci_mmcsd_pm_ops NULL
 #endif
 
+static const struct of_device_id davinci_mmc_of_match[] = {
+	{.compatible = "ti,davinci_mmc", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, davinci_mmc_of_match);
+
 static struct platform_driver davinci_mmcsd_driver = {
 	.driver		= {
 		.name	= "davinci_mmc",
 		.owner	= THIS_MODULE,
 		.pm	= davinci_mmcsd_pm_ops,
+		.of_match_table = of_match_ptr(davinci_mmc_of_match),
 	},
 	.remove		= __exit_p(davinci_mmcsd_remove),
 };
-- 
1.7.4.1

