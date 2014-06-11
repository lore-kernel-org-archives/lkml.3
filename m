Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbaFKJHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:07:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56342 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbaFKI6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:35 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 23/36] ARM: OMAP2+: gpmc: use platform data to configure CS space and poplulate device
Date: Wed, 11 Jun 2014 11:56:28 +0300
Message-ID: <1402477001-31132-24-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpmc_probe_legacy() that will be called for non DT boots. This function
will use platform data to setup each chip select and populate the child
platform device for each of the chip selects.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c | 129 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 111 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index d3a64ed..c26ba3f 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1302,11 +1302,6 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 {
 	int ret;
 	struct device_node *child;
-	const struct of_device_id *of_id =
-		of_match_device(gpmc_dt_ids, &pdev->dev);
-
-	if (!of_id)
-		return 0;
 
 	ret = of_property_read_u32(pdev->dev.of_node, "gpmc,num-cs",
 				   &gpmc_cs_num);
@@ -1355,11 +1350,106 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 }
 #endif
 
+static void gpmc_probe_legacy(struct platform_device *pdev)
+{
+	int i, rc;
+	struct device *dev = &pdev->dev;
+	struct gpmc_omap_platform_data *gpmc_pdata;
+
+	gpmc_pdata = dev->platform_data;
+	gpmc_cs_num = GPMC_CS_NUM;
+	gpmc_nr_waitpins = GPMC_NR_WAITPINS;
+
+	if (!gpmc_pdata)
+		return;
+
+	for (i = 0; i < GPMC_CS_NUM; i++) {
+		struct resource *mem_res;
+		unsigned long cs_base;
+		resource_size_t size;
+		struct gpmc_timings gpmc_timings;
+		struct gpmc_omap_cs_data *cs;
+
+		cs = &gpmc_pdata->cs[i];
+		if (!cs->valid)
+			continue;
+
+		/*
+		 * Request a CS space. Use size from
+		 * platform device's MEM resource
+		 */
+		if (!cs->pdev)
+			goto skip_mem;
+
+		mem_res = cs->pdev->resource;
+		if (cs->pdev->num_resources < 1 ||
+		    resource_type(mem_res) != IORESOURCE_MEM) {
+			dev_err(dev, "Invalid IOMEM resource for CS %d\n", i);
+			continue;
+		}
+
+		size = mem_res->end - mem_res->start + 1;
+		if (gpmc_cs_request(i, size, &cs_base)) {
+			dev_err(dev, "Couldn't request resource for CS %d\n",
+				i);
+			continue;
+		}
+
+		mem_res->start = cs_base;
+		mem_res->end = cs_base + size - 1;
+
+		/* FIXME: When do we need to call gpmc_cs_remap()? */
+skip_mem:
+
+		if (cs->settings) {
+			if (gpmc_cs_program_settings(i, cs->settings)) {
+				dev_err(dev,
+					"Couldn't program settings for CS %d\n",
+					i);
+				continue;
+			}
+		}
+
+		/* give device_timings priority over gpmc_timings */
+		if (cs->device_timings) {
+			gpmc_calc_timings(&gpmc_timings, cs->settings,
+					  cs->device_timings);
+
+			if (gpmc_cs_set_timings(i, &gpmc_timings)) {
+				dev_err(dev,
+					"Couldn't program timings for CS %d\n",
+					i);
+				continue;
+			}
+		} else if (cs->gpmc_timings) {
+			if (gpmc_cs_set_timings(i, cs->gpmc_timings)) {
+				dev_err(dev,
+					"Couldn't program timings for CS %d\n",
+					i);
+				continue;
+			}
+		}
+
+		if (!cs->pdev)
+			continue;
+
+		cs->pdev->dev.parent = dev;
+		rc = platform_device_register(cs->pdev);
+		if (rc < 0) {
+			dev_err(dev,
+				"Failed to register device %s on CS %d\n",
+				cs->pdev->name, i);
+			continue;
+		}
+	}
+}
+
 static int gpmc_probe(struct platform_device *pdev)
 {
 	int rc;
 	u32 l;
 	struct resource *res;
+	struct device *dev = &pdev->dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL)
@@ -1390,7 +1480,7 @@ static int gpmc_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	gpmc_dev = &pdev->dev;
+	gpmc_dev = dev;
 
 	l = gpmc_read_reg(GPMC_REVISION);
 
@@ -1410,7 +1500,7 @@ static int gpmc_probe(struct platform_device *pdev)
 		gpmc_capability = GPMC_HAS_WR_ACCESS | GPMC_HAS_WR_DATA_MUX_BUS;
 	if (GPMC_REVISION_MAJOR(l) > 0x5)
 		gpmc_capability |= GPMC_HAS_MUX_AAD;
-	dev_info(gpmc_dev, "GPMC revision %d.%d\n", GPMC_REVISION_MAJOR(l),
+	dev_info(dev, "GPMC revision %d.%d\n", GPMC_REVISION_MAJOR(l),
 		 GPMC_REVISION_MINOR(l));
 
 	gpmc_mem_init();
@@ -1418,20 +1508,23 @@ static int gpmc_probe(struct platform_device *pdev)
 	/* Now the GPMC is initialised, unreserve the chip-selects */
 	gpmc_cs_map = 0;
 
-	if (!pdev->dev.of_node) {
-		gpmc_cs_num	 = GPMC_CS_NUM;
-		gpmc_nr_waitpins = GPMC_NR_WAITPINS;
-	}
-
-	rc = gpmc_probe_dt(pdev);
-	if (rc < 0) {
-		pm_runtime_put_sync(&pdev->dev);
-		clk_put(gpmc_l3_clk);
-		dev_err(gpmc_dev, "failed to probe DT parameters\n");
-		return rc;
+	if (dev->of_node) {
+		rc = gpmc_probe_dt(pdev);
+		if (rc) {
+			dev_err(dev, "gpmc_probe_dt() failed\n");
+			goto error;
+		}
+	} else {
+		/* Legacy probing based on platform data */
+		gpmc_probe_legacy(pdev);
 	}
 
 	return 0;
+
+error:
+	pm_runtime_put_sync(dev);
+	clk_put(gpmc_l3_clk);
+	return rc;
 }
 
 static int gpmc_remove(struct platform_device *pdev)
-- 
1.8.3.2

