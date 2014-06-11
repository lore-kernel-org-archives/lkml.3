Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbaFKJPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:15:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59756 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaFKI5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:57:31 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 05/36] mtd: nand: omap: Move IRQ handling from GPMC to NAND driver
Date: Wed, 11 Jun 2014 11:56:10 +0300
Message-ID: <1402477001-31132-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the Interrupt Events are used only by the NAND driver,
there is no point in managing the Interrupt registers
in the GPMC driver and complicating it with irqchip modeling.

Let's manage the interrupt registers directly in the NAND driver
and get rid of irqchip model from GPMC driver.

Get rid of IRQ commands and unused commands from gpmc_configure() in
the GPMC driver.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-nand.c              |   8 +-
 arch/arm/mach-omap2/gpmc.c                   | 168 ++-------------------------
 arch/arm/mach-omap2/gpmc.h                   |   8 +-
 drivers/mtd/nand/omap2.c                     |  76 ++++++------
 include/linux/platform_data/mtd-nand-omap2.h |   2 +
 5 files changed, 56 insertions(+), 206 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 4349e82..3e6420b 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -31,9 +31,6 @@ static struct resource gpmc_nand_resource[] = {
 	{
 		.flags		= IORESOURCE_IRQ,
 	},
-	{
-		.flags		= IORESOURCE_IRQ,
-	},
 };
 
 static struct platform_device gpmc_nand_device = {
@@ -110,10 +107,7 @@ int gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data,
 	gpmc_nand_resource[0].end = gpmc_nand_resource[0].start +
 							NAND_IO_SIZE - 1;
 
-	gpmc_nand_resource[1].start =
-				gpmc_get_client_irq(GPMC_IRQ_FIFOEVENTENABLE);
-	gpmc_nand_resource[2].start =
-				gpmc_get_client_irq(GPMC_IRQ_COUNT_EVENT);
+	gpmc_nand_resource[1].start = gpmc_get_irq();
 
 	if (gpmc_t) {
 		err = gpmc_cs_set_timings(gpmc_nand_data->cs, gpmc_t);
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 9fe8c94..2524541 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -111,15 +111,6 @@
 
 #define GPMC_NR_WAITPINS		4
 
-/* XXX: Only NAND irq has been considered,currently these are the only ones used
- */
-#define	GPMC_NR_IRQ		2
-
-struct gpmc_client_irq	{
-	unsigned		irq;
-	u32			bitmask;
-};
-
 /* Structure to save gpmc cs context */
 struct gpmc_cs_config {
 	u32 config1;
@@ -147,10 +138,6 @@ struct omap3_gpmc_regs {
 	struct gpmc_cs_config cs_context[GPMC_CS_NUM];
 };
 
-static struct gpmc_client_irq gpmc_client_irq[GPMC_NR_IRQ];
-static struct irq_chip gpmc_irq_chip;
-static int gpmc_irq_start;
-
 static struct resource	gpmc_mem_root;
 static struct resource	gpmc_cs_mem[GPMC_CS_NUM];
 static DEFINE_SPINLOCK(gpmc_mem_lock);
@@ -159,15 +146,13 @@ static unsigned int gpmc_cs_map = ((1 << GPMC_CS_NUM) - 1);
 static unsigned int gpmc_cs_num = GPMC_CS_NUM;
 static unsigned int gpmc_nr_waitpins;
 static struct device *gpmc_dev;
-static int gpmc_irq;
+static int gpmc_irq = -EINVAL;
 static resource_size_t phys_base, mem_size;
 static unsigned gpmc_capability;
 static void __iomem *gpmc_base;
 
 static struct clk *gpmc_l3_clk;
 
-static irqreturn_t gpmc_handle_irq(int irq, void *dev);
-
 static void gpmc_write_reg(int idx, u32 val)
 {
 	__raw_writel(val, gpmc_base + idx);
@@ -622,14 +607,6 @@ int gpmc_configure(int cmd, int wval)
 	u32 regval;
 
 	switch (cmd) {
-	case GPMC_ENABLE_IRQ:
-		gpmc_write_reg(GPMC_IRQENABLE, wval);
-		break;
-
-	case GPMC_SET_IRQ_STATUS:
-		gpmc_write_reg(GPMC_IRQSTATUS, wval);
-		break;
-
 	case GPMC_CONFIG_WP:
 		regval = gpmc_read_reg(GPMC_CONFIG);
 		if (wval)
@@ -653,6 +630,8 @@ void gpmc_update_nand_reg(struct gpmc_nand_regs *reg, int cs)
 	int i;
 
 	reg->gpmc_status = gpmc_base + GPMC_STATUS;
+	reg->gpmc_irqstatus = gpmc_base + GPMC_IRQSTATUS;
+	reg->gpmc_irqenable = gpmc_base + GPMC_IRQENABLE;
 	reg->gpmc_nand_command = gpmc_base + GPMC_CS0_OFFSET +
 				GPMC_CS_NAND_COMMAND + GPMC_CS_SIZE * cs;
 	reg->gpmc_nand_address = gpmc_base + GPMC_CS0_OFFSET +
@@ -680,113 +659,9 @@ void gpmc_update_nand_reg(struct gpmc_nand_regs *reg, int cs)
 	}
 }
 
-int gpmc_get_client_irq(unsigned irq_config)
-{
-	int i;
-
-	if (hweight32(irq_config) > 1)
-		return 0;
-
-	for (i = 0; i < GPMC_NR_IRQ; i++)
-		if (gpmc_client_irq[i].bitmask & irq_config)
-			return gpmc_client_irq[i].irq;
-
-	return 0;
-}
-
-static int gpmc_irq_endis(unsigned irq, bool endis)
-{
-	int i;
-	u32 regval;
-
-	for (i = 0; i < GPMC_NR_IRQ; i++)
-		if (irq == gpmc_client_irq[i].irq) {
-			regval = gpmc_read_reg(GPMC_IRQENABLE);
-			if (endis)
-				regval |= gpmc_client_irq[i].bitmask;
-			else
-				regval &= ~gpmc_client_irq[i].bitmask;
-			gpmc_write_reg(GPMC_IRQENABLE, regval);
-			break;
-		}
-
-	return 0;
-}
-
-static void gpmc_irq_disable(struct irq_data *p)
-{
-	gpmc_irq_endis(p->irq, false);
-}
-
-static void gpmc_irq_enable(struct irq_data *p)
-{
-	gpmc_irq_endis(p->irq, true);
-}
-
-static void gpmc_irq_noop(struct irq_data *data) { }
-
-static unsigned int gpmc_irq_noop_ret(struct irq_data *data) { return 0; }
-
-static int gpmc_setup_irq(void)
-{
-	int i;
-	u32 regval;
-
-	if (!gpmc_irq)
-		return -EINVAL;
-
-	gpmc_irq_start = irq_alloc_descs(-1, 0, GPMC_NR_IRQ, 0);
-	if (gpmc_irq_start < 0) {
-		pr_err("irq_alloc_descs failed\n");
-		return gpmc_irq_start;
-	}
-
-	gpmc_irq_chip.name = "gpmc";
-	gpmc_irq_chip.irq_startup = gpmc_irq_noop_ret;
-	gpmc_irq_chip.irq_enable = gpmc_irq_enable;
-	gpmc_irq_chip.irq_disable = gpmc_irq_disable;
-	gpmc_irq_chip.irq_shutdown = gpmc_irq_noop;
-	gpmc_irq_chip.irq_ack = gpmc_irq_noop;
-	gpmc_irq_chip.irq_mask = gpmc_irq_noop;
-	gpmc_irq_chip.irq_unmask = gpmc_irq_noop;
-
-	gpmc_client_irq[0].bitmask = GPMC_IRQ_FIFOEVENTENABLE;
-	gpmc_client_irq[1].bitmask = GPMC_IRQ_COUNT_EVENT;
-
-	for (i = 0; i < GPMC_NR_IRQ; i++) {
-		gpmc_client_irq[i].irq = gpmc_irq_start + i;
-		irq_set_chip_and_handler(gpmc_client_irq[i].irq,
-					&gpmc_irq_chip, handle_simple_irq);
-		set_irq_flags(gpmc_client_irq[i].irq,
-				IRQF_VALID | IRQF_NOAUTOEN);
-	}
-
-	/* Disable interrupts */
-	gpmc_write_reg(GPMC_IRQENABLE, 0);
-
-	/* clear interrupts */
-	regval = gpmc_read_reg(GPMC_IRQSTATUS);
-	gpmc_write_reg(GPMC_IRQSTATUS, regval);
-
-	return request_irq(gpmc_irq, gpmc_handle_irq, 0, "gpmc", NULL);
-}
-
-static int gpmc_free_irq(void)
+int gpmc_get_irq(void)
 {
-	int i;
-
-	if (gpmc_irq)
-		free_irq(gpmc_irq, NULL);
-
-	for (i = 0; i < GPMC_NR_IRQ; i++) {
-		irq_set_handler(gpmc_client_irq[i].irq, NULL);
-		irq_set_chip(gpmc_client_irq[i].irq, &no_irq_chip);
-		irq_modify_status(gpmc_client_irq[i].irq, 0, 0);
-	}
-
-	irq_free_descs(gpmc_irq_start, GPMC_NR_IRQ);
-
-	return 0;
+	return gpmc_irq;
 }
 
 static void gpmc_mem_exit(void)
@@ -1646,10 +1521,12 @@ static int gpmc_probe(struct platform_device *pdev)
 		return PTR_ERR(gpmc_base);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res == NULL)
-		dev_warn(&pdev->dev, "Failed to get resource: irq\n");
-	else
-		gpmc_irq = res->start;
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get resource: irq\n");
+		return -EINVAL;
+	}
+
+	gpmc_irq = res->start;
 
 	gpmc_l3_clk = clk_get(&pdev->dev, "fck");
 	if (IS_ERR(gpmc_l3_clk)) {
@@ -1686,9 +1563,6 @@ static int gpmc_probe(struct platform_device *pdev)
 
 	gpmc_mem_init();
 
-	if (gpmc_setup_irq() < 0)
-		dev_warn(gpmc_dev, "gpmc_setup_irq failed\n");
-
 	/* Now the GPMC is initialised, unreserve the chip-selects */
 	gpmc_cs_map = 0;
 
@@ -1710,7 +1584,6 @@ static int gpmc_probe(struct platform_device *pdev)
 
 static int gpmc_remove(struct platform_device *pdev)
 {
-	gpmc_free_irq();
 	gpmc_mem_exit();
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -1787,25 +1660,6 @@ static int __init omap_gpmc_init(void)
 }
 omap_postcore_initcall(omap_gpmc_init);
 
-static irqreturn_t gpmc_handle_irq(int irq, void *dev)
-{
-	int i;
-	u32 regval;
-
-	regval = gpmc_read_reg(GPMC_IRQSTATUS);
-
-	if (!regval)
-		return IRQ_NONE;
-
-	for (i = 0; i < GPMC_NR_IRQ; i++)
-		if (regval & gpmc_client_irq[i].bitmask)
-			generic_handle_irq(gpmc_client_irq[i].irq);
-
-	gpmc_write_reg(GPMC_IRQSTATUS, regval);
-
-	return IRQ_HANDLED;
-}
-
 static struct omap3_gpmc_regs gpmc_context;
 
 void omap3_gpmc_save_context(void)
diff --git a/arch/arm/mach-omap2/gpmc.h b/arch/arm/mach-omap2/gpmc.h
index 13554e7..a558ebd 100644
--- a/arch/arm/mach-omap2/gpmc.h
+++ b/arch/arm/mach-omap2/gpmc.h
@@ -26,14 +26,8 @@
 #define GPMC_CS_NAND_DATA	0x24
 
 /* Control Commands */
-#define GPMC_CONFIG_RDY_BSY	0x00000001
-#define GPMC_CONFIG_DEV_SIZE	0x00000002
-#define GPMC_CONFIG_DEV_TYPE	0x00000003
-#define GPMC_SET_IRQ_STATUS	0x00000004
 #define GPMC_CONFIG_WP		0x00000005
 
-#define GPMC_ENABLE_IRQ		0x0000000d
-
 /* ECC commands */
 #define GPMC_ECC_READ		0 /* Reset Hardware ECC for read */
 #define GPMC_ECC_WRITE		1 /* Reset Hardware ECC for write */
@@ -76,7 +70,7 @@ extern int gpmc_calc_timings(struct gpmc_timings *gpmc_t,
 			     struct gpmc_device_timings *dev_t);
 
 extern void gpmc_update_nand_reg(struct gpmc_nand_regs *reg, int cs);
-extern int gpmc_get_client_irq(unsigned irq_config);
+int gpmc_get_irq(void);
 
 extern unsigned int gpmc_ticks_to_ns(unsigned int ticks);
 
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 1ff49b8..8de1660 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -136,6 +136,10 @@
 
 #define BADBLOCK_MARKER_LENGTH		2
 
+/* GPMC IRQ REGISTER bits */
+#define GPMC_IRQ_FIFOEVENT	BIT(0)
+#define GPMC_IRQ_TERMCOUNT	BIT(1)
+
 #ifdef CONFIG_MTD_NAND_OMAP_BCH
 static u_char bch8_vector[] = {0xf3, 0xdb, 0x14, 0x16, 0x8b, 0xd2, 0xbe, 0xcc,
 	0xac, 0x6b, 0xff, 0x99, 0x7b};
@@ -157,8 +161,7 @@ struct omap_nand_info {
 	enum omap_ecc			ecc_opt;
 	struct completion		comp;
 	struct dma_chan			*dma;
-	int				gpmc_irq_fifo;
-	int				gpmc_irq_count;
+	int				gpmc_irq;
 	enum {
 		OMAP_NAND_IO_READ = 0,	/* read */
 		OMAP_NAND_IO_WRITE,	/* write */
@@ -572,12 +575,16 @@ static irqreturn_t omap_nand_irq(int this_irq, void *dev)
 {
 	struct omap_nand_info *info = (struct omap_nand_info *) dev;
 	u32 bytes;
+	u32 irqstatus;
+	u32 irqenable;
+
+	irqstatus = readl(info->reg.gpmc_irqstatus);
 
 	bytes = readl(info->reg.gpmc_prefetch_status);
 	bytes = PREFETCH_STATUS_FIFO_CNT(bytes);
 	bytes = bytes  & 0xFFFC; /* io in multiple of 4 bytes */
 	if (info->iomode == OMAP_NAND_IO_WRITE) { /* checks for write io */
-		if (this_irq == info->gpmc_irq_count)
+		if (irqstatus & GPMC_IRQ_TERMCOUNT)
 			goto done;
 
 		if (info->buf_len && (info->buf_len < bytes))
@@ -594,17 +601,27 @@ static irqreturn_t omap_nand_irq(int this_irq, void *dev)
 						(u32 *)info->buf, bytes >> 2);
 		info->buf = info->buf + bytes;
 
-		if (this_irq == info->gpmc_irq_count)
+		if (irqstatus & GPMC_IRQ_TERMCOUNT)
 			goto done;
 	}
 
+	/* Clear FIFOEVENT STATUS */
+	irqstatus &= ~GPMC_IRQ_FIFOEVENT;
+	writel(irqstatus, info->reg.gpmc_irqstatus);
+
 	return IRQ_HANDLED;
 
 done:
 	complete(&info->comp);
 
-	disable_irq_nosync(info->gpmc_irq_fifo);
-	disable_irq_nosync(info->gpmc_irq_count);
+	/* Clear FIFOEVENT and TERMCOUNT STATUS */
+	irqstatus &= ~(GPMC_IRQ_TERMCOUNT | GPMC_IRQ_FIFOEVENT);
+	writel(irqstatus, info->reg.gpmc_irqstatus);
+
+	/* Disable Interrupt generation */
+	irqenable = readl(info->reg.gpmc_irqenable);
+	irqenable &= ~(GPMC_IRQ_TERMCOUNT | GPMC_IRQ_FIFOEVENT);
+	writel(irqenable, info->reg.gpmc_irqenable);
 
 	return IRQ_HANDLED;
 }
@@ -620,6 +637,7 @@ static void omap_read_buf_irq_pref(struct mtd_info *mtd, u_char *buf, int len)
 	struct omap_nand_info *info = container_of(mtd,
 						struct omap_nand_info, mtd);
 	int ret = 0;
+	u32 irqenable;
 
 	if (len <= mtd->oobsize) {
 		omap_read_buf_pref(mtd, buf, len);
@@ -639,8 +657,10 @@ static void omap_read_buf_irq_pref(struct mtd_info *mtd, u_char *buf, int len)
 
 	info->buf_len = len;
 
-	enable_irq(info->gpmc_irq_count);
-	enable_irq(info->gpmc_irq_fifo);
+	/* Enable Interrupt generation */
+	irqenable = readl(info->reg.gpmc_irqenable);
+	irqenable |= (GPMC_IRQ_FIFOEVENT | GPMC_IRQ_TERMCOUNT);
+	writel(irqenable, info->reg.gpmc_irqenable);
 
 	/* waiting for read to complete */
 	wait_for_completion(&info->comp);
@@ -670,6 +690,7 @@ static void omap_write_buf_irq_pref(struct mtd_info *mtd,
 	int ret = 0;
 	unsigned long tim, limit;
 	u32 val;
+	u32 irqenable;
 
 	if (len <= mtd->oobsize) {
 		omap_write_buf_pref(mtd, buf, len);
@@ -689,8 +710,10 @@ static void omap_write_buf_irq_pref(struct mtd_info *mtd,
 
 	info->buf_len = len;
 
-	enable_irq(info->gpmc_irq_count);
-	enable_irq(info->gpmc_irq_fifo);
+	/* Enable Interrupt generation */
+	irqenable = readl(info->reg.gpmc_irqenable);
+	irqenable |= (GPMC_IRQ_FIFOEVENT | GPMC_IRQ_TERMCOUNT);
+	writel(irqenable, info->reg.gpmc_irqenable);
 
 	/* waiting for write to complete */
 	wait_for_completion(&info->comp);
@@ -1689,35 +1712,18 @@ static int omap_nand_probe(struct platform_device *pdev)
 		break;
 
 	case NAND_OMAP_PREFETCH_IRQ:
-		info->gpmc_irq_fifo = platform_get_irq(pdev, 0);
-		if (info->gpmc_irq_fifo <= 0) {
-			dev_err(&pdev->dev, "error getting fifo irq\n");
-			err = -ENODEV;
-			goto return_error;
-		}
-		err = devm_request_irq(&pdev->dev, info->gpmc_irq_fifo,
-					omap_nand_irq, IRQF_SHARED,
-					"gpmc-nand-fifo", info);
-		if (err) {
-			dev_err(&pdev->dev, "requesting irq(%d) error:%d",
-						info->gpmc_irq_fifo, err);
-			info->gpmc_irq_fifo = 0;
-			goto return_error;
-		}
-
-		info->gpmc_irq_count = platform_get_irq(pdev, 1);
-		if (info->gpmc_irq_count <= 0) {
-			dev_err(&pdev->dev, "error getting count irq\n");
-			err = -ENODEV;
+		info->gpmc_irq = platform_get_irq(pdev, 0);
+		if (info->gpmc_irq < 0) {
+			dev_err(&pdev->dev, "error getting GPMC irq\n");
+			err = info->gpmc_irq;
 			goto return_error;
 		}
-		err = devm_request_irq(&pdev->dev, info->gpmc_irq_count,
-					omap_nand_irq, IRQF_SHARED,
-					"gpmc-nand-count", info);
+		err = devm_request_irq(&pdev->dev, info->gpmc_irq,
+				       omap_nand_irq, IRQF_SHARED,
+				       DRIVER_NAME, info);
 		if (err) {
 			dev_err(&pdev->dev, "requesting irq(%d) error:%d",
-						info->gpmc_irq_count, err);
-			info->gpmc_irq_count = 0;
+				info->gpmc_irq, err);
 			goto return_error;
 		}
 
diff --git a/include/linux/platform_data/mtd-nand-omap2.h b/include/linux/platform_data/mtd-nand-omap2.h
index 3e9dd66..97c9852 100644
--- a/include/linux/platform_data/mtd-nand-omap2.h
+++ b/include/linux/platform_data/mtd-nand-omap2.h
@@ -35,6 +35,8 @@ enum omap_ecc {
 
 struct gpmc_nand_regs {
 	void __iomem	*gpmc_status;
+	void __iomem	*gpmc_irqstatus;
+	void __iomem	*gpmc_irqenable;
 	void __iomem	*gpmc_nand_command;
 	void __iomem	*gpmc_nand_address;
 	void __iomem	*gpmc_nand_data;
-- 
1.8.3.2

