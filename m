Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaEULZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:25:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46620 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbaEULW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:22:28 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <pekon@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <robertcnelson@gmail.com>, <jg1.han@samsung.com>,
        <dwmw2@infradead.org>, <javier@dowhile0.org>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 10/16] mtd: nand: omap: Move gpmc_update_nand_reg to nand driver
Date: Wed, 21 May 2014 14:20:58 +0300
Message-ID: <1400671264-10702-11-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400671264-10702-1-git-send-email-rogerq@ti.com>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPMC and NAND drivers share the same register space but never use the
same registers. As there is no clear address seperation between the
registers for GPMC and NAND, we can't easily split it up into 2 regions
i.e. one for GPMC and other for NAND. Instead, we simply remap the entire
register space in both the drivers. The NAND driver doesn't re-request
the region as it is already requested by the GPMC driver (parent).

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-nand.c              |   7 +-
 arch/arm/mach-omap2/gpmc.c                   |  60 +++----------
 arch/arm/mach-omap2/gpmc.h                   |   3 -
 drivers/mtd/nand/omap2.c                     | 123 ++++++++++++++++++++++++---
 include/linux/platform_data/mtd-nand-omap2.h |   3 +-
 5 files changed, 131 insertions(+), 65 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 775b263..d916ec0 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -27,13 +27,18 @@
 static struct resource gpmc_nand_resource[] = {
 /* GPMC driver will fixup all the resources, see gpmc_probe_legacy () */
 	{
+		/* GPMC I/O space */
 		.flags		= IORESOURCE_MEM,
 		.start          = 0,
 		.end            = NAND_IO_SIZE - 1,
 	},
 	{
-		.flags		= IORESOURCE_IRQ,
+		/* GPMC register space */
+		.flags		= IORESOURCE_MEM,
 	},
+	{
+		.flags		= IORESOURCE_IRQ,
+	}
 };
 
 static struct platform_device gpmc_nand_device = {
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index e28864d..4207dc9 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -626,40 +626,6 @@ int gpmc_configure(int cmd, int wval)
 }
 EXPORT_SYMBOL(gpmc_configure);
 
-void gpmc_update_nand_reg(struct gpmc_nand_regs *reg, int cs)
-{
-	int i;
-
-	reg->gpmc_status = gpmc_base + GPMC_STATUS;
-	reg->gpmc_irqstatus = gpmc_base + GPMC_IRQSTATUS;
-	reg->gpmc_irqenable = gpmc_base + GPMC_IRQENABLE;
-	reg->gpmc_nand_command = gpmc_base + GPMC_CS0_OFFSET +
-				GPMC_CS_NAND_COMMAND + GPMC_CS_SIZE * cs;
-	reg->gpmc_nand_address = gpmc_base + GPMC_CS0_OFFSET +
-				GPMC_CS_NAND_ADDRESS + GPMC_CS_SIZE * cs;
-	reg->gpmc_nand_data = gpmc_base + GPMC_CS0_OFFSET +
-				GPMC_CS_NAND_DATA + GPMC_CS_SIZE * cs;
-	reg->gpmc_prefetch_config1 = gpmc_base + GPMC_PREFETCH_CONFIG1;
-	reg->gpmc_prefetch_config2 = gpmc_base + GPMC_PREFETCH_CONFIG2;
-	reg->gpmc_prefetch_control = gpmc_base + GPMC_PREFETCH_CONTROL;
-	reg->gpmc_prefetch_status = gpmc_base + GPMC_PREFETCH_STATUS;
-	reg->gpmc_ecc_config = gpmc_base + GPMC_ECC_CONFIG;
-	reg->gpmc_ecc_control = gpmc_base + GPMC_ECC_CONTROL;
-	reg->gpmc_ecc_size_config = gpmc_base + GPMC_ECC_SIZE_CONFIG;
-	reg->gpmc_ecc1_result = gpmc_base + GPMC_ECC1_RESULT;
-
-	for (i = 0; i < GPMC_BCH_NUM_REMAINDER; i++) {
-		reg->gpmc_bch_result0[i] = gpmc_base + GPMC_ECC_BCH_RESULT_0 +
-					   GPMC_BCH_SIZE * i;
-		reg->gpmc_bch_result1[i] = gpmc_base + GPMC_ECC_BCH_RESULT_1 +
-					   GPMC_BCH_SIZE * i;
-		reg->gpmc_bch_result2[i] = gpmc_base + GPMC_ECC_BCH_RESULT_2 +
-					   GPMC_BCH_SIZE * i;
-		reg->gpmc_bch_result3[i] = gpmc_base + GPMC_ECC_BCH_RESULT_3 +
-					   GPMC_BCH_SIZE * i;
-	}
-}
-
 static void gpmc_mem_exit(void)
 {
 	int cs;
@@ -1499,21 +1465,25 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 }
 #endif
 
-static int gpmc_nand_setup(struct platform_device *pdev,
+/* Configure nand device resources */
+static int gpmc_nand_setup(struct platform_device *parent_pdev,
+			   struct platform_device *pdev,
 			   struct gpmc_settings *settings)
 {
 	struct resource *res;
 	int rc;
-	struct omap_nand_platform_data *gpmc_nand_data;
+	struct resource *res_mem;
 
-	gpmc_nand_data = pdev->dev.platform_data;
-	if (!gpmc_nand_data)
+	/* GPMC register space */
+	res_mem = platform_get_resource(parent_pdev, IORESOURCE_MEM, 0);
+	if (!res_mem)
 		return -EINVAL;
 
 	res = pdev->resource;
+	res[1] = *res_mem;
 
-	/* setup IRQ resources */
-	res[1].start = gpmc_irq;
+	/* IRQ resource */
+	res[2].start = gpmc_irq;
 
 	settings->device_nand = true;
 	/*
@@ -1524,9 +1494,6 @@ static int gpmc_nand_setup(struct platform_device *pdev,
 	if (rc < 0)
 		return rc;
 
-	/* update register addresses in NAND platform data */
-	gpmc_update_nand_reg(&gpmc_nand_data->reg, gpmc_nand_data->cs);
-
 	return 0;
 }
 
@@ -1539,10 +1506,11 @@ static int gpmc_nand_check_csdata(struct gpmc_omap_cs_data *cs)
 
 	res = cs->pdev->resource;
 
-	if (cs->pdev->num_resources < 2)
+	if (cs->pdev->num_resources < 3)
 		return -EINVAL;
 
-	if (resource_type(&res[1]) != IORESOURCE_IRQ)
+	if (resource_type(&res[1]) != IORESOURCE_MEM ||
+	    resource_type(&res[2]) != IORESOURCE_IRQ)
 		return -EINVAL;
 
 	if (!cs->settings)
@@ -1608,7 +1576,7 @@ skip_mem:
 				continue;
 			}
 
-			rc = gpmc_nand_setup(cs->pdev, cs->settings);
+			rc = gpmc_nand_setup(pdev, cs->pdev, cs->settings);
 			if (rc) {
 				dev_err(dev, "Error setting up NAND on CS %d\n",
 					i);
diff --git a/arch/arm/mach-omap2/gpmc.h b/arch/arm/mach-omap2/gpmc.h
index 906eefe..05974f0 100644
--- a/arch/arm/mach-omap2/gpmc.h
+++ b/arch/arm/mach-omap2/gpmc.h
@@ -21,9 +21,6 @@
 #define GPMC_CS_CONFIG5		0x10
 #define GPMC_CS_CONFIG6		0x14
 #define GPMC_CS_CONFIG7		0x18
-#define GPMC_CS_NAND_COMMAND	0x1c
-#define GPMC_CS_NAND_ADDRESS	0x20
-#define GPMC_CS_NAND_DATA	0x24
 
 /* Control Commands */
 #define GPMC_CONFIG_WP		0x00000005
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index ad9d28f..7d12d92 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -140,6 +140,36 @@
 #define GPMC_IRQ_FIFOEVENT	BIT(0)
 #define GPMC_IRQ_TERMCOUNT	BIT(1)
 
+/* GPMC register offsets */
+#define GPMC_REVISION		0x00
+#define GPMC_SYSCONFIG		0x10
+#define GPMC_SYSSTATUS		0x14
+#define GPMC_IRQSTATUS		0x18
+#define GPMC_IRQENABLE		0x1c
+#define GPMC_TIMEOUT_CONTROL	0x40
+#define GPMC_ERR_ADDRESS	0x44
+#define GPMC_ERR_TYPE		0x48
+#define GPMC_CONFIG		0x50
+#define GPMC_STATUS		0x54
+#define GPMC_CS_NAND_COMMAND	0x7c
+#define GPMC_CS_NAND_ADDRESS	0x80
+#define GPMC_CS_NAND_DATA	0x84
+#define GPMC_PREFETCH_CONFIG1	0x1e0
+#define GPMC_PREFETCH_CONFIG2	0x1e4
+#define GPMC_PREFETCH_CONTROL	0x1ec
+#define GPMC_PREFETCH_STATUS	0x1f0
+#define GPMC_ECC_CONFIG		0x1f4
+#define GPMC_ECC_CONTROL	0x1f8
+#define GPMC_ECC_SIZE_CONFIG	0x1fc
+#define GPMC_ECC1_RESULT        0x200
+#define GPMC_ECC_BCH_RESULT_0   0x240   /* not available on OMAP2 */
+#define	GPMC_ECC_BCH_RESULT_1	0x244	/* not available on OMAP2 */
+#define	GPMC_ECC_BCH_RESULT_2	0x248	/* not available on OMAP2 */
+#define	GPMC_ECC_BCH_RESULT_3	0x24c	/* not available on OMAP2 */
+
+#define GPMC_CS_SIZE		0x30
+#define	GPMC_BCH_SIZE		0x10
+
 #ifdef CONFIG_MTD_NAND_OMAP_BCH
 static u_char bch8_vector[] = {0xf3, 0xdb, 0x14, 0x16, 0x8b, 0xd2, 0xbe, 0xcc,
 	0xac, 0x6b, 0xff, 0x99, 0x7b};
@@ -158,6 +188,7 @@ struct omap_nand_info {
 
 	int				gpmc_cs;
 	unsigned long			phys_base;
+	void __iomem			*gpmc_base;
 	enum omap_ecc			ecc_opt;
 	struct completion		comp;
 	struct dma_chan			*dma;
@@ -1584,20 +1615,58 @@ static int is_elm_present(struct omap_nand_info *info,
 }
 #endif /* CONFIG_MTD_NAND_ECC_BCH */
 
+static void gpmc_update_nand_reg(struct omap_nand_info *info)
+{
+	int i;
+	struct gpmc_nand_regs *reg = &info->reg;
+	int cs = info->gpmc_cs;
+	void __iomem *gpmc_base = info->gpmc_base;
+
+	reg->gpmc_status = gpmc_base + GPMC_STATUS;
+	reg->gpmc_irqstatus = gpmc_base + GPMC_IRQSTATUS;
+	reg->gpmc_irqenable = gpmc_base + GPMC_IRQENABLE;
+	reg->gpmc_nand_command = gpmc_base + GPMC_CS_NAND_COMMAND +
+				 GPMC_CS_SIZE * cs;
+	reg->gpmc_nand_address = gpmc_base + GPMC_CS_NAND_ADDRESS +
+				 GPMC_CS_SIZE * cs;
+	reg->gpmc_nand_data = gpmc_base + GPMC_CS_NAND_DATA +
+				 GPMC_CS_SIZE * cs;
+	reg->gpmc_prefetch_config1 = gpmc_base + GPMC_PREFETCH_CONFIG1;
+	reg->gpmc_prefetch_config2 = gpmc_base + GPMC_PREFETCH_CONFIG2;
+	reg->gpmc_prefetch_control = gpmc_base + GPMC_PREFETCH_CONTROL;
+	reg->gpmc_prefetch_status = gpmc_base + GPMC_PREFETCH_STATUS;
+	reg->gpmc_ecc_config = gpmc_base + GPMC_ECC_CONFIG;
+	reg->gpmc_ecc_control = gpmc_base + GPMC_ECC_CONTROL;
+	reg->gpmc_ecc_size_config = gpmc_base + GPMC_ECC_SIZE_CONFIG;
+	reg->gpmc_ecc1_result = gpmc_base + GPMC_ECC1_RESULT;
+
+	for (i = 0; i < GPMC_BCH_NUM_REMAINDER; i++) {
+		reg->gpmc_bch_result0[i] = gpmc_base + GPMC_ECC_BCH_RESULT_0 +
+					   GPMC_BCH_SIZE * i;
+		reg->gpmc_bch_result1[i] = gpmc_base + GPMC_ECC_BCH_RESULT_1 +
+					   GPMC_BCH_SIZE * i;
+		reg->gpmc_bch_result2[i] = gpmc_base + GPMC_ECC_BCH_RESULT_2 +
+					   GPMC_BCH_SIZE * i;
+		reg->gpmc_bch_result3[i] = gpmc_base + GPMC_ECC_BCH_RESULT_3 +
+					   GPMC_BCH_SIZE * i;
+	}
+}
+
 static int omap_nand_probe(struct platform_device *pdev)
 {
-	struct omap_nand_info		*info;
-	struct omap_nand_platform_data	*pdata;
-	struct mtd_info			*mtd;
-	struct nand_chip		*nand_chip;
-	struct nand_ecclayout		*ecclayout;
-	int				err;
-	int				i;
-	dma_cap_mask_t			mask;
-	unsigned			sig;
-	unsigned			oob_index;
-	struct resource			*res;
-	struct mtd_part_parser_data	ppdata = {};
+	struct omap_nand_info *info;
+	struct omap_nand_platform_data *pdata;
+	struct mtd_info	*mtd;
+	struct nand_chip *nand_chip;
+	struct nand_ecclayout *ecclayout;
+	int err;
+	int i;
+	dma_cap_mask_t mask;
+	unsigned sig;
+	unsigned oob_index;
+	struct resource	*res;
+	struct mtd_part_parser_data ppdata = {};
+	struct device *dev = &pdev->dev;
 
 	pdata = dev_get_platdata(&pdev->dev);
 	if (pdata == NULL) {
@@ -1617,7 +1686,6 @@ static int omap_nand_probe(struct platform_device *pdev)
 
 	info->pdev		= pdev;
 	info->gpmc_cs		= pdata->cs;
-	info->reg		= pdata->reg;
 	info->of_node		= pdata->of_node;
 	info->ecc_opt		= pdata->ecc_opt;
 	mtd			= &info->mtd;
@@ -1628,8 +1696,14 @@ static int omap_nand_probe(struct platform_device *pdev)
 	nand_chip->ecc.priv	= NULL;
 	nand_chip->options	|= NAND_SKIP_BBTSCAN;
 
+	/* GPMC external I/O space */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	nand_chip->IO_ADDR_R = devm_ioremap_resource(&pdev->dev, res);
+	if (!res) {
+		dev_err(dev, "Can't get memory resource 0\n");
+		return -EINVAL;
+	}
+
+	nand_chip->IO_ADDR_R = devm_ioremap_resource(dev, res);
 	if (IS_ERR(nand_chip->IO_ADDR_R))
 		return PTR_ERR(nand_chip->IO_ADDR_R);
 
@@ -1640,6 +1714,27 @@ static int omap_nand_probe(struct platform_device *pdev)
 	nand_chip->IO_ADDR_W = nand_chip->IO_ADDR_R;
 	nand_chip->cmd_ctrl  = omap_hwcontrol;
 
+	/* GPMC internal registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res) {
+		dev_err(dev, "Can't get memory resource 1\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * This resource is already requested by the GPMC driver
+	 * so we can't request it again. Instead, we just ioremap it.
+	 * This driver doesn't access the same registers as the GPMC
+	 * driver so it is safe.
+	 */
+	info->gpmc_base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!info->gpmc_base) {
+		dev_err(dev, "Can't ioremap resource 1\n");
+		return -EADDRNOTAVAIL;
+	}
+
+	gpmc_update_nand_reg(info);
+
 	/*
 	 * If RDY/BSY line is connected to OMAP then use the omap ready
 	 * function and the generic nand_wait function which reads the status
diff --git a/include/linux/platform_data/mtd-nand-omap2.h b/include/linux/platform_data/mtd-nand-omap2.h
index 97c9852..b71cfbd 100644
--- a/include/linux/platform_data/mtd-nand-omap2.h
+++ b/include/linux/platform_data/mtd-nand-omap2.h
@@ -62,10 +62,11 @@ struct omap_nand_platform_data {
 	enum nand_io		xfer_type;
 	int			devsize;
 	enum omap_ecc           ecc_opt;
-	struct gpmc_nand_regs	reg;
 
 	/* for passing the partitions */
 	struct device_node	*of_node;
 	struct device_node	*elm_of_node;
+
+	struct gpmc_nand_regs	reg;		/* deprecated */
 };
 #endif
-- 
1.8.3.2

