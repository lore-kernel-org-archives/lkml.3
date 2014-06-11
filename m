Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaFKJCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:02:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56384 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbaFKI7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:59:05 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 30/36] ARM: OMAP2+: gpmc-smsc911x: Use gpmc_generic_init()
Date: Wed, 11 Jun 2014 11:56:35 +0300
Message-ID: <1402477001-31132-31-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't access any GPMC registers here. Use gpmc_generic_init()
to pass GPMC Chip Select settings, platform device and platform data
to the GPMC driver.

Some boards use multiple smsc911x devices, so we dynamically
allocate pdev and pdata.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-smsc911x.c | 76 ++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-smsc911x.c b/arch/arm/mach-omap2/gpmc-smsc911x.c
index 2757504..9492db0 100644
--- a/arch/arm/mach-omap2/gpmc-smsc911x.c
+++ b/arch/arm/mach-omap2/gpmc-smsc911x.c
@@ -19,19 +19,11 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/smsc911x.h>
+#include <linux/slab.h>
 
 #include "gpmc.h"
 #include "gpmc-smsc911x.h"
 
-static struct resource gpmc_smsc911x_resources[] = {
-	[0] = {
-		.flags		= IORESOURCE_MEM,
-	},
-	[1] = {
-		.flags		= IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
-	},
-};
-
 static struct smsc911x_platform_config gpmc_smsc911x_config = {
 	.phy_interface	= PHY_INTERFACE_MODE_MII,
 	.irq_polarity	= SMSC911X_IRQ_POLARITY_ACTIVE_LOW,
@@ -45,24 +37,43 @@ static struct smsc911x_platform_config gpmc_smsc911x_config = {
  */
 void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *gpmc_cfg)
 {
-	struct platform_device *pdev;
-	unsigned long cs_mem_base;
 	int ret;
+	struct platform_device *pdev;
+	struct resource *res;
+
+	/*
+	 * This function can be called multiple times per board so the platform
+	 * device and resources have to be allocated separately for each
+	 * device.
+	 */
+	pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
+	if (!pdev)
+		goto fail;
+
+	/* needs 2 resources */
+	res = kzalloc(2 * sizeof(*res), GFP_KERNEL);
+	if (!res)
+		goto free1;
 
-	if (gpmc_cs_request(gpmc_cfg->cs, SZ_16M, &cs_mem_base) < 0) {
-		pr_err("Failed to request GPMC mem region\n");
-		return;
-	}
+	pdev->name = "smsc911x";
+	pdev->id = gpmc_cfg->id;
+	pdev->dev.platform_data = &gpmc_smsc911x_config,
+	pdev->num_resources = 2;
+	pdev->resource = res;
+
+	/* res[0]  Will be relocated by GPMC driver, see gpmc_probe_legacy() */
+	res[0].flags = IORESOURCE_MEM;
+	res[0].start = 0;
+	res[0].end = 0xff;
 
-	gpmc_smsc911x_resources[0].start = cs_mem_base + 0x0;
-	gpmc_smsc911x_resources[0].end = cs_mem_base + 0xff;
 
 	if (gpio_request_one(gpmc_cfg->gpio_irq, GPIOF_IN, "smsc911x irq")) {
 		pr_err("Failed to request IRQ GPIO%d\n", gpmc_cfg->gpio_irq);
-		goto free1;
+		goto free2;
 	}
 
-	gpmc_smsc911x_resources[1].start = gpio_to_irq(gpmc_cfg->gpio_irq);
+	res[1].start = gpio_to_irq(gpmc_cfg->gpio_irq);
+	res[1].flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL;
 
 	if (gpio_is_valid(gpmc_cfg->gpio_reset)) {
 		ret = gpio_request_one(gpmc_cfg->gpio_reset,
@@ -70,7 +81,7 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *gpmc_cfg)
 		if (ret) {
 			pr_err("Failed to request reset GPIO%d\n",
 			       gpmc_cfg->gpio_reset);
-			goto free2;
+			goto free3;
 		}
 
 		gpio_set_value(gpmc_cfg->gpio_reset, 0);
@@ -80,21 +91,26 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *gpmc_cfg)
 
 	gpmc_smsc911x_config.flags = gpmc_cfg->flags ? : SMSC911X_USE_16BIT;
 
-	pdev = platform_device_register_resndata(NULL, "smsc911x", gpmc_cfg->id,
-		 gpmc_smsc911x_resources, ARRAY_SIZE(gpmc_smsc911x_resources),
-		 &gpmc_smsc911x_config, sizeof(gpmc_smsc911x_config));
-	if (IS_ERR(pdev)) {
-		pr_err("Unable to register platform device\n");
-		gpio_free(gpmc_cfg->gpio_reset);
-		goto free2;
+	ret = gpmc_generic_init(gpmc_cfg->cs, false,
+				NULL, NULL, NULL,
+				pdev,
+				sizeof(gpmc_smsc911x_config));
+	if (ret) {
+		pr_err("%s: gpmc_generic_init() failed %d\n", __func__, ret);
+		goto free4;
 	}
 
 	return;
 
-free2:
+free4:
+	if (gpio_is_valid(gpmc_cfg->gpio_reset))
+		gpio_free(gpmc_cfg->gpio_reset);
+free3:
 	gpio_free(gpmc_cfg->gpio_irq);
+free2:
+	kfree(res);
 free1:
-	gpmc_cs_free(gpmc_cfg->cs);
-
+	kfree(pdev);
+fail:
 	pr_err("Could not initialize smsc911x device\n");
 }
-- 
1.8.3.2

