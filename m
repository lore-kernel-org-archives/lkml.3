Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaFKI5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:57:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33035 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbaFKI5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:57:41 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 07/36] mtd: nand: omap: Move NAND write protect code from GPMC to NAND driver
Date: Wed, 11 Jun 2014 11:56:12 +0300
Message-ID: <1402477001-31132-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The write protect (WP) pin is only used for NAND devices. So move
the code into the NAND driver.

Get rid of gpmc_configure() as it is no longer used.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-nand.c              |  4 ----
 arch/arm/mach-omap2/gpmc.c                   | 29 ----------------------------
 arch/arm/mach-omap2/gpmc.h                   |  5 -----
 drivers/mtd/nand/omap2.c                     | 23 ++++++++++++++++++++++
 include/linux/platform_data/mtd-nand-omap2.h |  1 +
 5 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index aaebd2f..9649fd9 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -138,10 +138,6 @@ int gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data,
 	if (err < 0)
 		goto out_free_cs;
 
-	err = gpmc_configure(GPMC_CONFIG_WP, 0);
-	if (err < 0)
-		goto out_free_cs;
-
 	if (!gpmc_hwecc_bch_capable(gpmc_nand_data->ecc_opt)) {
 		dev_err(dev, "Unsupported NAND ECC scheme selected\n");
 		return -EINVAL;
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 0a8b6ca..a0c2194 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -596,35 +596,6 @@ void gpmc_cs_free(int cs)
 }
 EXPORT_SYMBOL(gpmc_cs_free);
 
-/**
- * gpmc_configure - write request to configure gpmc
- * @cmd: command type
- * @wval: value to write
- * @return status of the operation
- */
-int gpmc_configure(int cmd, int wval)
-{
-	u32 regval;
-
-	switch (cmd) {
-	case GPMC_CONFIG_WP:
-		regval = gpmc_read_reg(GPMC_CONFIG);
-		if (wval)
-			regval &= ~GPMC_CONFIG_WRITEPROTECT; /* WP is ON */
-		else
-			regval |= GPMC_CONFIG_WRITEPROTECT;  /* WP is OFF */
-		gpmc_write_reg(GPMC_CONFIG, regval);
-		break;
-
-	default:
-		pr_err("%s: command not supported\n", __func__);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(gpmc_configure);
-
 void gpmc_get_mem_resource(struct resource *res)
 {
 	res->start =  phys_base;
diff --git a/arch/arm/mach-omap2/gpmc.h b/arch/arm/mach-omap2/gpmc.h
index 479ce84..6204913 100644
--- a/arch/arm/mach-omap2/gpmc.h
+++ b/arch/arm/mach-omap2/gpmc.h
@@ -22,9 +22,6 @@
 #define GPMC_CS_CONFIG6		0x14
 #define GPMC_CS_CONFIG7		0x18
 
-/* Control Commands */
-#define GPMC_CONFIG_WP		0x00000005
-
 /* ECC commands */
 #define GPMC_ECC_READ		0 /* Reset Hardware ECC for read */
 #define GPMC_ECC_WRITE		1 /* Reset Hardware ECC for write */
@@ -57,7 +54,6 @@
 
 #define GPMC_DEVICETYPE_NOR		0
 #define GPMC_DEVICETYPE_NAND		2
-#define GPMC_CONFIG_WRITEPROTECT	0x00000010
 #define WR_RD_PIN_MONITORING		0x00600000
 #define GPMC_IRQ_FIFOEVENTENABLE	0x01
 #define GPMC_IRQ_COUNT_EVENT		0x02
@@ -79,7 +75,6 @@ extern int gpmc_cs_request(int cs, unsigned long size, unsigned long *base);
 extern void gpmc_cs_free(int cs);
 extern void omap3_gpmc_save_context(void);
 extern void omap3_gpmc_restore_context(void);
-extern int gpmc_configure(int cmd, int wval);
 extern void gpmc_read_settings_dt(struct device_node *np,
 				  struct gpmc_settings *p);
 
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 120acee..bb41796 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -140,6 +140,9 @@
 #define GPMC_IRQ_FIFOEVENT	BIT(0)
 #define GPMC_IRQ_TERMCOUNT	BIT(1)
 
+/* GPMC_CONFIG register bits */
+#define GPMC_CONFIG_WRITEPROTECT	BIT(4)
+
 /* GPMC register offsets */
 #define GPMC_REVISION		0x00
 #define GPMC_SYSCONFIG		0x10
@@ -206,6 +209,22 @@ struct omap_nand_info {
 };
 
 /**
+ * omap_nand_writeprotect - Control the WP line to the NAND chip
+ */
+static void omap_nand_writeprotect(struct omap_nand_info *info, bool on)
+{
+	u32 val;
+
+	val = readl(info->reg.gpmc_config);
+	if (on)
+		val |= GPMC_CONFIG_WRITEPROTECT;
+	else
+		val &= GPMC_CONFIG_WRITEPROTECT;
+
+	writel(val, info->reg.gpmc_config);
+}
+
+/**
  * omap_prefetch_enable - configures and starts prefetch transfer
  * @cs: cs (chip select) number
  * @fifo_th: fifo threshold to be used for read/ write
@@ -1622,6 +1641,7 @@ static void gpmc_update_nand_reg(struct omap_nand_info *info)
 	int cs = info->gpmc_cs;
 	void __iomem *gpmc_base = info->gpmc_base;
 
+	reg->gpmc_config = gpmc_base + GPMC_CONFIG;
 	reg->gpmc_status = gpmc_base + GPMC_STATUS;
 	reg->gpmc_irqstatus = gpmc_base + GPMC_IRQSTATUS;
 	reg->gpmc_irqenable = gpmc_base + GPMC_IRQENABLE;
@@ -2029,6 +2049,9 @@ static int omap_nand_probe(struct platform_device *pdev)
 		goto return_error;
 	}
 
+	/* turn off write protect */
+	omap_nand_writeprotect(info, false);
+
 	/* second phase scan */
 	if (nand_scan_tail(mtd)) {
 		err = -ENXIO;
diff --git a/include/linux/platform_data/mtd-nand-omap2.h b/include/linux/platform_data/mtd-nand-omap2.h
index b71cfbdb6..62a855e 100644
--- a/include/linux/platform_data/mtd-nand-omap2.h
+++ b/include/linux/platform_data/mtd-nand-omap2.h
@@ -34,6 +34,7 @@ enum omap_ecc {
 };
 
 struct gpmc_nand_regs {
+	void __iomem	*gpmc_config;
 	void __iomem	*gpmc_status;
 	void __iomem	*gpmc_irqstatus;
 	void __iomem	*gpmc_irqenable;
-- 
1.8.3.2

