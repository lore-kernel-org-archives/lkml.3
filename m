Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbaFKJGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:06:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57645 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaFKI6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:38 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 24/36] ARM: OMAP2+: gpmc: add NAND specific setup
Date: Wed, 11 Jun 2014 11:56:29 +0300
Message-ID: <1402477001-31132-25-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide NAND specific resources and platform data.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index c26ba3f..5563360 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1350,6 +1350,42 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 }
 #endif
 
+static int gpmc_nand_setup(struct platform_device *parent_pdev,
+			   struct gpmc_omap_cs_data *cs)
+{
+	struct resource *res;
+	struct resource *res_gpmc;
+
+	if (!cs->pdev)
+		return -EINVAL;
+
+	res = cs->pdev->resource;
+
+	if (cs->pdev->num_resources < 3)
+		return -EINVAL;
+
+	if (resource_type(&res[1]) != IORESOURCE_MEM ||
+	    resource_type(&res[2]) != IORESOURCE_IRQ)
+		return -EINVAL;
+
+	if (!cs->settings)
+		return -EINVAL;
+
+	/* GPMC register space */
+	res_gpmc = platform_get_resource(parent_pdev, IORESOURCE_MEM, 0);
+	if (!res_gpmc)
+		return -EINVAL;
+
+	res[1] = *res_gpmc;
+
+	/* setup IRQ resources */
+	res[2].start = gpmc_irq;
+
+	cs->settings->device_nand = true;
+
+	return 0;
+}
+
 static void gpmc_probe_legacy(struct platform_device *pdev)
 {
 	int i, rc;
@@ -1401,6 +1437,15 @@ static void gpmc_probe_legacy(struct platform_device *pdev)
 		/* FIXME: When do we need to call gpmc_cs_remap()? */
 skip_mem:
 
+		/* Customized NAND setup */
+		if (cs->is_nand) {
+			if (gpmc_nand_setup(pdev, cs)) {
+				dev_err(dev, "Error setting up NAND on CS %d\n",
+					i);
+				continue;
+			}
+		}
+
 		if (cs->settings) {
 			if (gpmc_cs_program_settings(i, cs->settings)) {
 				dev_err(dev,
-- 
1.8.3.2

