Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaCYIyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:54:50 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52333 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaCYIUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:20:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 07/47] mtd: nand: stm_nand_bch: initialise the BCH Controller
Date: Tue, 25 Mar 2014 08:19:24 +0000
Message-Id: <1395735604-26706-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 56 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/stm_nand.h    | 20 +++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 76a0d02..1a93f8d 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
@@ -102,6 +103,56 @@ static void nandi_disable_interrupts(struct nandi_controller *nandi,
 	writel(val, nandi->base + NANDBCH_INT_EN);
 }
 
+static void nandi_init_bch(struct nandi_controller *nandi, int emi_bank)
+{
+	dev_dbg(nandi->dev, "%s\n", __func__);
+
+	/* Initialise BCH Controller */
+	emiss_nandi_select(STM_NANDI_BCH);
+
+	/* Reset and disable boot-mode controller */
+	writel(BOOT_CFG_RESET, nandi->base + NANDBCH_BOOTBANK_CFG);
+	udelay(1);
+	writel(0x00000000, nandi->base + NANDBCH_BOOTBANK_CFG);
+
+	/* Reset AFM controller */
+	writel(CFG_RESET, nandi->base + NANDBCH_CONTROLLER_CFG);
+	udelay(1);
+	writel(0x00000000, nandi->base + NANDBCH_CONTROLLER_CFG);
+
+	/* Set EMI Bank */
+	writel(0x1 << emi_bank, nandi->base + NANDBCH_FLEX_MUXCTRL);
+
+	/* Reset ECC stats */
+	writel(0x7f0, nandi->base + NANDBCH_CONTROLLER_CFG);
+	udelay(1);
+
+	/* Enable AFM */
+	writel(CFG_ENABLE_AFM, nandi->base + NANDBCH_CONTROLLER_CFG);
+
+	/* Configure Read DMA Plugs (values supplied by Validation) */
+	writel(0x00000005, nandi->dma + EMISS_NAND_RD_DMA_PAGE_SIZE);
+	writel(0x00000005, nandi->dma + EMISS_NAND_RD_DMA_MAX_OPCODE_SIZE);
+	writel(0x00000002, nandi->dma + EMISS_NAND_RD_DMA_MIN_OPCODE_SIZE);
+	writel(0x00000001, nandi->dma + EMISS_NAND_RD_DMA_MAX_CHUNK_SIZE);
+	writel(0x00000000, nandi->dma + EMISS_NAND_RD_DMA_MAX_MESSAGE_SIZE);
+
+	/* Configure Write DMA Plugs (values supplied by Validation) */
+	writel(0x00000005, nandi->dma + EMISS_NAND_WR_DMA_PAGE_SIZE);
+	writel(0x00000005, nandi->dma + EMISS_NAND_WR_DMA_MAX_OPCODE_SIZE);
+	writel(0x00000002, nandi->dma + EMISS_NAND_WR_DMA_MIN_OPCODE_SIZE);
+	writel(0x00000001, nandi->dma + EMISS_NAND_WR_DMA_MAX_CHUNK_SIZE);
+	writel(0x00000000, nandi->dma + EMISS_NAND_WR_DMA_MAX_MESSAGE_SIZE);
+
+	nandi_enable_interrupts(nandi, NAND_INT_ENABLE);
+}
+
+static void nandi_init_controller(struct nandi_controller *nandi,
+				  int emi_bank)
+{
+	nandi_init_bch(nandi, emi_bank);
+}
+
 static int remap_named_resource(struct platform_device *pdev,
 				char *name,
 				void __iomem **io_ptr)
@@ -174,6 +225,7 @@ nandi_init_resources(struct platform_device *pdev)
 static int stm_nand_bch_probe(struct platform_device *pdev)
 {
 	struct stm_plat_nand_bch_data *pdata = pdev->dev.platform_data;
+	struct stm_nand_bank_data *bank;
 	struct nandi_controller *nandi;
 
 	if (!pdata) {
@@ -190,6 +242,10 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	init_completion(&nandi->seq_completed);
 	init_completion(&nandi->rbn_completed);
 
+	bank = pdata->bank;
+	if (bank)
+		nandi_init_controller(nandi, bank->csn);
+
 	return 0;
 }
 
diff --git a/include/linux/mtd/stm_nand.h b/include/linux/mtd/stm_nand.h
index da2006c..99a69ca 100644
--- a/include/linux/mtd/stm_nand.h
+++ b/include/linux/mtd/stm_nand.h
@@ -17,6 +17,26 @@
 
 #include <linux/io.h>
 
+/*
+ * Board-level specification relating to a 'bank' of NAND Flash
+ */
+struct stm_nand_bank_data {
+	int			csn;
+	int			nr_partitions;
+	struct mtd_partition	*partitions;
+	unsigned int		options;
+	unsigned int		bbt_options;
+
+	struct nand_timing_spec *timing_spec;
+
+	/*
+	 * No. of IP clk cycles by which to 'relax' the timing configuration.
+	 * Required on some boards to to accommodate board-level limitations.
+	 * Used in conjunction with 'nand_timing_spec' and ONFI configuration.
+	 */
+	int			timing_relax;
+};
+
 struct stm_plat_nand_bch_data {
 	struct stm_nand_bank_data *bank;
 	enum stm_nand_bch_ecc_config bch_ecc_cfg;
-- 
1.8.3.2

