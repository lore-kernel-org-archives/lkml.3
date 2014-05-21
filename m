Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaEULV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:21:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36788 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbaEULVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:21:55 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <pekon@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <robertcnelson@gmail.com>, <jg1.han@samsung.com>,
        <dwmw2@infradead.org>, <javier@dowhile0.org>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 04/16] ARM: OMAP2+: gpmc: use platform data to configure CS space and poplulate device
Date: Wed, 21 May 2014 14:20:52 +0300
Message-ID: <1400671264-10702-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400671264-10702-1-git-send-email-rogerq@ti.com>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpmc_probe_legacy() that will be called for non DT boots. This function
will use platform data to setup each chip select and populate the child
platform device for each of the chip selects.

Re-arrange init order so that gpmc device is created after
the gpmc platform data is initialized by board files.
i.e. move omap_gpmc_init() to subsys_initcall.

Load gpmc platform driver later in the boot process.
i.e. move gpmc_init() to module_initcall.

NOTE: this will break legacy boot since they call gpmc_cs_*()
functions before gpmc_mem_init() is called. They will eventually
be fixed.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c | 137 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 118 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 6b4a322..04bae67 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -160,7 +160,6 @@ static DEFINE_SPINLOCK(gpmc_mem_lock);
 static unsigned int gpmc_cs_map = ((1 << GPMC_CS_NUM) - 1);
 static unsigned int gpmc_cs_num = GPMC_CS_NUM;
 static unsigned int gpmc_nr_waitpins;
-static struct device *gpmc_dev;
 static int gpmc_irq;
 static resource_size_t phys_base, mem_size;
 static unsigned gpmc_capability;
@@ -1630,11 +1629,102 @@ static int gpmc_probe_dt(struct platform_device *pdev)
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
@@ -1663,8 +1753,6 @@ static int gpmc_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	gpmc_dev = &pdev->dev;
-
 	l = gpmc_read_reg(GPMC_REVISION);
 
 	/*
@@ -1683,31 +1771,40 @@ static int gpmc_probe(struct platform_device *pdev)
 		gpmc_capability = GPMC_HAS_WR_ACCESS | GPMC_HAS_WR_DATA_MUX_BUS;
 	if (GPMC_REVISION_MAJOR(l) > 0x5)
 		gpmc_capability |= GPMC_HAS_MUX_AAD;
-	dev_info(gpmc_dev, "GPMC revision %d.%d\n", GPMC_REVISION_MAJOR(l),
+	dev_info(dev, "GPMC revision %d.%d\n", GPMC_REVISION_MAJOR(l),
 		 GPMC_REVISION_MINOR(l));
 
 	gpmc_mem_init();
 
 	if (gpmc_setup_irq() < 0)
-		dev_warn(gpmc_dev, "gpmc_setup_irq failed\n");
+		dev_warn(dev, "gpmc_setup_irq failed\n");
 
 	/* Now the GPMC is initialised, unreserve the chip-selects */
 	gpmc_cs_map = 0;
 
-	if (!pdev->dev.of_node) {
-		gpmc_cs_num	 = GPMC_CS_NUM;
-		gpmc_nr_waitpins = GPMC_NR_WAITPINS;
-	}
+	if (!dev->of_node) {
+		/* Legacy probing based on platform data */
+		if (!dev->platform_data) {
+			dev_err(dev, "missing platform data\n");
+			rc = -EINVAL;
+			goto error;
+		}
+		gpmc_probe_legacy(pdev);
 
-	rc = gpmc_probe_dt(pdev);
-	if (rc < 0) {
-		pm_runtime_put_sync(&pdev->dev);
-		clk_put(gpmc_l3_clk);
-		dev_err(gpmc_dev, "failed to probe DT parameters\n");
-		return rc;
+	} else {
+		rc = gpmc_probe_dt(pdev);
+		if (rc < 0) {
+			dev_err(dev, "failed to probe DT parameters\n");
+			goto error;
+		}
 	}
 
 	return 0;
+
+error:
+	pm_runtime_put_sync(dev);
+	clk_put(gpmc_l3_clk);
+	return rc;
 }
 
 static int gpmc_remove(struct platform_device *pdev)
@@ -1716,7 +1813,6 @@ static int gpmc_remove(struct platform_device *pdev)
 	gpmc_mem_exit();
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	gpmc_dev = NULL;
 	return 0;
 }
 
@@ -1760,7 +1856,7 @@ static __exit void gpmc_exit(void)
 
 }
 
-omap_postcore_initcall(gpmc_init);
+module_init(gpmc_init);
 module_exit(gpmc_exit);
 
 static int __init omap_gpmc_init(void)
@@ -1782,12 +1878,15 @@ static int __init omap_gpmc_init(void)
 		return -ENODEV;
 	}
 
-	pdev = omap_device_build(DEVICE_NAME, -1, oh, NULL, 0);
+	pdev = omap_device_build(DEVICE_NAME, -1, oh, (void *)&gpmc_pdata,
+				 sizeof(gpmc_pdata));
 	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
 
 	return PTR_RET(pdev);
 }
-omap_postcore_initcall(omap_gpmc_init);
+
+/* must run after machine_init code. i.e. arch_init */
+omap_subsys_initcall(omap_gpmc_init);
 
 /**
  * gpmc_generic_init - Initialize platform data for a Chip Select
-- 
1.8.3.2

