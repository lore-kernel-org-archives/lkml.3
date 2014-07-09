Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbaGIMjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:39:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60478 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbaGIMjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:39:03 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 10/10] OMAP: GPMC: NAND: Don't pass NAND/ECC/BCH register adresses to NAND driver
Date: Wed, 9 Jul 2014 15:37:30 +0300
Message-ID: <1404909450-11970-11-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NAND driver now relies completely on the GPMC APIs to access
the NAND control lines and ECC/BCH engine. We no longer need
gpmc_update_nand_reg() and struct gpmc_nand_regs, so get rid of them.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-nand.c              |  2 --
 arch/arm/mach-omap2/gpmc.c                   | 38 ----------------------------
 arch/arm/mach-omap2/gpmc.h                   |  1 -
 drivers/mtd/nand/omap2.c                     |  2 --
 include/linux/platform_data/mtd-nand-omap2.h |  5 +++-
 5 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 17cd393..565bd15 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -138,8 +138,6 @@ int gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data,
 	if (err < 0)
 		goto out_free_cs;
 
-	gpmc_update_nand_reg(&gpmc_nand_data->reg, gpmc_nand_data->cs);
-
 	if (!gpmc_hwecc_bch_capable(gpmc_nand_data->ecc_opt)) {
 		dev_err(dev, "Unsupported NAND ECC scheme selected\n");
 		return -EINVAL;
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 9222244..fbd651e 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -724,44 +724,6 @@ int gpmc_configure(int cmd, int wval)
 }
 EXPORT_SYMBOL(gpmc_configure);
 
-void gpmc_update_nand_reg(struct gpmc_nand_regs *reg, int cs)
-{
-	int i;
-
-	reg->gpmc_status = gpmc_base + GPMC_STATUS;
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
-		reg->gpmc_bch_result4[i] = gpmc_base + GPMC_ECC_BCH_RESULT_4 +
-					   i * GPMC_BCH_SIZE;
-		reg->gpmc_bch_result5[i] = gpmc_base + GPMC_ECC_BCH_RESULT_5 +
-					   i * GPMC_BCH_SIZE;
-		reg->gpmc_bch_result6[i] = gpmc_base + GPMC_ECC_BCH_RESULT_6 +
-					   i * GPMC_BCH_SIZE;
-	}
-}
-
 int gpmc_get_client_irq(unsigned irq_config)
 {
 	int i;
diff --git a/arch/arm/mach-omap2/gpmc.h b/arch/arm/mach-omap2/gpmc.h
index 707f6d5..a91fab7 100644
--- a/arch/arm/mach-omap2/gpmc.h
+++ b/arch/arm/mach-omap2/gpmc.h
@@ -211,7 +211,6 @@ extern int gpmc_calc_timings(struct gpmc_timings *gpmc_t,
 			     struct gpmc_settings *gpmc_s,
 			     struct gpmc_device_timings *dev_t);
 
-extern void gpmc_update_nand_reg(struct gpmc_nand_regs *reg, int cs);
 extern int gpmc_get_client_irq(unsigned irq_config);
 
 extern unsigned int gpmc_ticks_to_ns(unsigned int ticks);
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 6b0f953..e894e65 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -163,7 +163,6 @@ struct omap_nand_info {
 	} iomode;
 	u_char				*buf;
 	int					buf_len;
-	struct gpmc_nand_regs		reg;
 	/* fields specific for BCHx_HW ECC scheme */
 	struct device			*elm_dev;
 	struct device_node		*of_node;
@@ -1547,7 +1546,6 @@ static int omap_nand_probe(struct platform_device *pdev)
 
 	info->pdev		= pdev;
 	info->gpmc_cs		= pdata->cs;
-	info->reg		= pdata->reg;
 	info->of_node		= pdata->of_node;
 	info->ecc_opt		= pdata->ecc_opt;
 	mtd			= &info->mtd;
diff --git a/include/linux/platform_data/mtd-nand-omap2.h b/include/linux/platform_data/mtd-nand-omap2.h
index 660c029..44198be 100644
--- a/include/linux/platform_data/mtd-nand-omap2.h
+++ b/include/linux/platform_data/mtd-nand-omap2.h
@@ -35,6 +35,7 @@ enum omap_ecc {
 	OMAP_ECC_BCH16_CODE_HW,
 };
 
+/* Deprecated - Don't use */
 struct gpmc_nand_regs {
 	void __iomem	*gpmc_status;
 	void __iomem	*gpmc_nand_command;
@@ -65,10 +66,12 @@ struct omap_nand_platform_data {
 	enum nand_io		xfer_type;
 	int			devsize;
 	enum omap_ecc           ecc_opt;
-	struct gpmc_nand_regs	reg;
 
 	/* for passing the partitions */
 	struct device_node	*of_node;
 	struct device_node	*elm_of_node;
+
+
+	struct gpmc_nand_regs	reg;	/* Deprecated. Don't use */
 };
 #endif
-- 
1.8.3.2

