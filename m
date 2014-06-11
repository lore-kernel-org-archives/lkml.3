Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaFKJEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:04:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59827 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748AbaFKI6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:53 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 28/36] ARM: OMAP2+: nand: Update gpmc_nand_init() to use generic_gpmc_init()
Date: Wed, 11 Jun 2014 11:56:33 +0300
Message-ID: <1402477001-31132-29-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function should only be called by board init code for
legacy boot.

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
 arch/arm/mach-omap2/gpmc-nand.c | 51 ++++++++---------------------------------
 arch/arm/mach-omap2/gpmc.c      | 17 +++++++++-----
 2 files changed, 21 insertions(+), 47 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index f7491d0..42371e3 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -25,9 +25,12 @@
 #define	NAND_IO_SIZE	4
 
 static struct resource gpmc_nand_resource[] = {
+/* GPMC driver will fixup all the resources, see gpmc_probe_legacy () */
 	{
 		/* GPMC I/O space */
 		.flags		= IORESOURCE_MEM,
+		.start		= 0,
+		.end		= NAND_IO_SIZE - 1,
 	},
 	{
 		/* GPMC register space */
@@ -95,61 +98,27 @@ int gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data,
 {
 	int err	= 0;
 	struct gpmc_settings s;
-	struct device *dev = &gpmc_nand_device.dev;
-	struct resource res;
 
 	memset(&s, 0, sizeof(struct gpmc_settings));
 
 	gpmc_nand_device.dev.platform_data = gpmc_nand_data;
 
-	err = gpmc_cs_request(gpmc_nand_data->cs, NAND_IO_SIZE,
-				(unsigned long *)&gpmc_nand_resource[0].start);
-	if (err < 0) {
-		dev_err(dev, "Cannot request GPMC CS %d, error %d\n",
-			gpmc_nand_data->cs, err);
-		return err;
-	}
-
-	gpmc_nand_resource[0].end = gpmc_nand_resource[0].start +
-							NAND_IO_SIZE - 1;
-
-	gpmc_get_mem_resource(&res);
-	gpmc_nand_resource[1].start = res.start;
-	gpmc_nand_resource[1].end = res.end;
-
-	gpmc_nand_resource[2].start = gpmc_get_irq();
-
-	if (gpmc_t) {
-		err = gpmc_cs_set_timings(gpmc_nand_data->cs, gpmc_t);
-		if (err < 0) {
-			dev_err(dev, "Unable to set gpmc timings: %d\n", err);
-			return err;
-		}
-	}
-
 	gpmc_set_legacy(gpmc_nand_data, &s);
 
 	s.device_nand = true;
 
-	err = gpmc_cs_program_settings(gpmc_nand_data->cs, &s);
-	if (err < 0)
-		goto out_free_cs;
-
 	if (!gpmc_hwecc_bch_capable(gpmc_nand_data->ecc_opt)) {
-		dev_err(dev, "Unsupported NAND ECC scheme selected\n");
+		pr_err("%s: Unsupported NAND ECC scheme selected\n", __func__);
 		return -EINVAL;
 	}
 
-	err = platform_device_register(&gpmc_nand_device);
-	if (err < 0) {
-		dev_err(dev, "Unable to register NAND device\n");
-		goto out_free_cs;
+	err = gpmc_generic_init(gpmc_nand_data->cs, true,
+				&s, NULL, gpmc_t,
+				&gpmc_nand_device, sizeof(*gpmc_nand_data));
+	if (err) {
+		pr_err("%s: gpmc_generic_init() failed %d\n", __func__, err);
+		return err;
 	}
 
 	return 0;
-
-out_free_cs:
-	gpmc_cs_free(gpmc_nand_data->cs);
-
-	return err;
 }
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 34545ca..7a667ca 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1401,9 +1401,6 @@ static void gpmc_probe_legacy(struct platform_device *pdev)
 	gpmc_cs_num = GPMC_CS_NUM;
 	gpmc_nr_waitpins = GPMC_NR_WAITPINS;
 
-	if (!gpmc_pdata)
-		return;
-
 	for (i = 0; i < GPMC_CS_NUM; i++) {
 		cs = &gpmc_pdata->cs[i];
 		if (!cs->valid)
@@ -1609,6 +1606,12 @@ static int gpmc_probe(struct platform_device *pdev)
 		}
 	} else {
 		/* Legacy probing based on platform data */
+		if (!dev->platform_data) {
+			dev_err(dev, "No platform data\n");
+			rc = -EINVAL;
+			goto error;
+		}
+
 		gpmc_probe_legacy(pdev);
 	}
 
@@ -1669,7 +1672,7 @@ static __exit void gpmc_exit(void)
 
 }
 
-omap_postcore_initcall(gpmc_init);
+module_init(gpmc_init);
 module_exit(gpmc_exit);
 
 static int __init omap_gpmc_init(void)
@@ -1691,12 +1694,14 @@ static int __init omap_gpmc_init(void)
 		return -ENODEV;
 	}
 
-	pdev = omap_device_build(DEVICE_NAME, -1, oh, NULL, 0);
+	pdev = omap_device_build(DEVICE_NAME, -1, oh, (void *)&gpmc_pdata,
+				 sizeof(gpmc_pdata));
 	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
 
 	return PTR_RET(pdev);
 }
-omap_postcore_initcall(omap_gpmc_init);
+/* must run after machine_init code. i.e. arch_init */
+omap_subsys_initcall(omap_gpmc_init);
 
 /**
  * gpmc_generic_init - Initialize platform data for a Chip Select
-- 
1.8.3.2

