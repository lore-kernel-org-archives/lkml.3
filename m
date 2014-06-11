Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaFKI6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:58:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33115 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbaFKI6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:48 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 25/36] ARM: OMAP2+: gpmc: Support multiple Chip Selects per device
Date: Wed, 11 Jun 2014 11:56:30 +0300
Message-ID: <1402477001-31132-26-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices (e.g. tusb6010) need 2 chip selects to work with
2 separate IOMEM resources. Allow such use case. The user just
needs to call gpmc_generic_init() for as many chip selects
with the same platform_device pointer. The GPMC driver will
take care of fixing up the memory resources.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c | 134 ++++++++++++++++++++++++++++++---------------
 1 file changed, 91 insertions(+), 43 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 5563360..34545ca 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1388,9 +1388,14 @@ static int gpmc_nand_setup(struct platform_device *parent_pdev,
 
 static void gpmc_probe_legacy(struct platform_device *pdev)
 {
-	int i, rc;
+	int i, rc, j;
 	struct device *dev = &pdev->dev;
 	struct gpmc_omap_platform_data *gpmc_pdata;
+	struct resource *mem_res;
+	unsigned long cs_base;
+	resource_size_t size;
+	struct gpmc_timings gpmc_timings;
+	struct gpmc_omap_cs_data *cs;
 
 	gpmc_pdata = dev->platform_data;
 	gpmc_cs_num = GPMC_CS_NUM;
@@ -1400,52 +1405,10 @@ static void gpmc_probe_legacy(struct platform_device *pdev)
 		return;
 
 	for (i = 0; i < GPMC_CS_NUM; i++) {
-		struct resource *mem_res;
-		unsigned long cs_base;
-		resource_size_t size;
-		struct gpmc_timings gpmc_timings;
-		struct gpmc_omap_cs_data *cs;
-
 		cs = &gpmc_pdata->cs[i];
 		if (!cs->valid)
 			continue;
 
-		/*
-		 * Request a CS space. Use size from
-		 * platform device's MEM resource
-		 */
-		if (!cs->pdev)
-			goto skip_mem;
-
-		mem_res = cs->pdev->resource;
-		if (cs->pdev->num_resources < 1 ||
-		    resource_type(mem_res) != IORESOURCE_MEM) {
-			dev_err(dev, "Invalid IOMEM resource for CS %d\n", i);
-			continue;
-		}
-
-		size = mem_res->end - mem_res->start + 1;
-		if (gpmc_cs_request(i, size, &cs_base)) {
-			dev_err(dev, "Couldn't request resource for CS %d\n",
-				i);
-			continue;
-		}
-
-		mem_res->start = cs_base;
-		mem_res->end = cs_base + size - 1;
-
-		/* FIXME: When do we need to call gpmc_cs_remap()? */
-skip_mem:
-
-		/* Customized NAND setup */
-		if (cs->is_nand) {
-			if (gpmc_nand_setup(pdev, cs)) {
-				dev_err(dev, "Error setting up NAND on CS %d\n",
-					i);
-				continue;
-			}
-		}
-
 		if (cs->settings) {
 			if (gpmc_cs_program_settings(i, cs->settings)) {
 				dev_err(dev,
@@ -1474,10 +1437,95 @@ skip_mem:
 				continue;
 			}
 		}
+	}
+
+	/*
+	 * All Chip Selects must be configured before platform devices are
+	 * created as some devices (e.g. tusb6010) can use multiple
+	 * Chip selects.
+	 */
+
+	/* Fixup Memory resources */
+	for (i = 0; i < GPMC_CS_NUM; i++) {
+		int required_resources;
+
+		cs = &gpmc_pdata->cs[i];
+		if (!cs->valid)
+			continue;
 
 		if (!cs->pdev)
 			continue;
 
+		/* Customized NAND setup */
+		if (cs->is_nand) {
+			if (gpmc_nand_setup(pdev, cs)) {
+				dev_err(dev, "Error setting up NAND on CS %d\n",
+					i);
+				continue;
+			}
+		}
+
+		mem_res = cs->pdev->resource;
+
+		/*
+		 * If device is present multiple times, fix the subsequent
+		 * resources
+		 */
+		required_resources = 1;
+		for (j = 0; j < i; j++) {
+			if (gpmc_pdata->cs[j].pdev == cs->pdev) {
+				mem_res++;
+				required_resources++;
+			}
+		}
+
+		if (cs->pdev->num_resources < required_resources ||
+		    resource_type(mem_res) != IORESOURCE_MEM) {
+			dev_err(dev, "Invalid IOMEM resource for CS %d\n", i);
+			continue;
+		}
+
+		/*
+		 * Request a CS space. Use size from
+		 * platform device's MEM resource
+		 */
+		size = mem_res->end - mem_res->start + 1;
+		if (gpmc_cs_request(i, size, &cs_base)) {
+			dev_err(dev, "Couldn't request resource for CS %d\n",
+				i);
+			continue;
+		}
+
+		mem_res->start = cs_base;
+		mem_res->end = cs_base + size - 1;
+	}
+
+	/* create the platform devices */
+	for (i = 0; i < GPMC_CS_NUM; i++) {
+		bool registered;
+
+		cs = &gpmc_pdata->cs[i];
+		if (!cs->valid)
+			continue;
+
+		if (!cs->pdev)
+			continue;
+
+		/*
+		 * same device can be present on multiple CS, don't
+		 * register device more than once.
+		 */
+		registered = false;
+		for (j = 0; j < i; j++) {
+			if (gpmc_pdata->cs[j].pdev == cs->pdev) {
+				registered = true;
+				break;
+			}
+		}
+
+		if (registered)
+			continue;
+
 		cs->pdev->dev.parent = dev;
 		rc = platform_device_register(cs->pdev);
 		if (rc < 0) {
-- 
1.8.3.2

