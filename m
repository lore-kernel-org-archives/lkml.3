Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaEULWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:22:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36791 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaEULV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:21:59 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <pekon@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <robertcnelson@gmail.com>, <jg1.han@samsung.com>,
        <dwmw2@infradead.org>, <javier@dowhile0.org>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 06/16] ARM: OMAP2+: gpmc: add NAND specific setup
Date: Wed, 21 May 2014 14:20:54 +0300
Message-ID: <1400671264-10702-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400671264-10702-1-git-send-email-rogerq@ti.com>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide NAND specific resources and platform data.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 26b26ec..f4ee6e9 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1629,6 +1629,61 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 }
 #endif
 
+static int gpmc_nand_setup(struct platform_device *pdev,
+			   struct gpmc_settings *settings)
+{
+	struct resource *res;
+	int rc;
+	struct omap_nand_platform_data *gpmc_nand_data;
+
+	gpmc_nand_data = pdev->dev.platform_data;
+	if (!gpmc_nand_data)
+		return -EINVAL;
+
+	res = pdev->resource;
+
+	/* setup IRQ resources */
+	res[1].start = gpmc_get_client_irq(GPMC_IRQ_FIFOEVENTENABLE);
+
+	res[2].start = gpmc_get_client_irq(GPMC_IRQ_COUNT_EVENT);
+
+	settings->device_nand = true;
+	/*
+	 * Not sure why WP is explicitly turned OFF. we just moved it here
+	 * as is from mach-omap2/gpmc-nand.c
+	 */
+	rc = gpmc_configure(GPMC_CONFIG_WP, 0);
+	if (rc < 0)
+		return rc;
+
+	/* update register addresses in NAND platform data */
+	gpmc_update_nand_reg(&gpmc_nand_data->reg, gpmc_nand_data->cs);
+
+	return 0;
+}
+
+static int gpmc_nand_check_csdata(struct gpmc_omap_cs_data *cs)
+{
+	struct resource *res;
+
+	if (!cs->pdev)
+		return -EINVAL;
+
+	res = cs->pdev->resource;
+
+	if (cs->pdev->num_resources < 3)
+		return -EINVAL;
+
+	if (resource_type(&res[1]) != IORESOURCE_IRQ ||
+	    resource_type(&res[2]) != IORESOURCE_IRQ)
+		return -EINVAL;
+
+	if (!cs->settings)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void gpmc_probe_legacy(struct platform_device *pdev)
 {
 	int i, rc;
@@ -1677,6 +1732,28 @@ static void gpmc_probe_legacy(struct platform_device *pdev)
 		/* FIXME: When do we need to call gpmc_cs_remap()? */
 skip_mem:
 
+		/* Customized setup based on type */
+		switch (cs->type) {
+		case GPMC_OMAP_TYPE_NAND:
+			if (gpmc_nand_check_csdata(cs)) {
+				dev_err(dev, "Invalid NAND config on CS %d\n",
+					i);
+				continue;
+			}
+
+			rc = gpmc_nand_setup(cs->pdev, cs->settings);
+			if (rc) {
+				dev_err(dev, "Error setting up NAND on CS %d\n",
+					i);
+				continue;
+			}
+			break;
+		case GPMC_OMAP_TYPE_NOR:
+		case GPMC_OMAP_TYPE_ONENAND:
+		case GPMC_OMAP_TYPE_GENERIC:
+			break;
+		}
+
 		if (cs->settings) {
 			if (gpmc_cs_program_settings(i, cs->settings)) {
 				dev_err(dev,
-- 
1.8.3.2

