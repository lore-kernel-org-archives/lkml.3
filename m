Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaCYIUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:20:49 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52060 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaCYIUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:20:38 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 10/47] mtd: nand: stm_nand_bch: initialise the Hamming Controller
Date: Tue, 25 Mar 2014 08:19:27 +0000
Message-Id: <1395735604-26706-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 7333ad6..8ab8e7b 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -207,6 +207,41 @@ static struct clk *nandi_clk_setup(struct nandi_controller *nandi,
 	return clk;
 }
 
+static void nandi_init_hamming(struct nandi_controller *nandi, int emi_bank)
+{
+	dev_dbg(nandi->dev, "%s\n", __func__);
+
+	emiss_nandi_select(STM_NANDI_HAMMING);
+
+	/* Reset and disable boot-mode controller */
+	writel(BOOT_CFG_RESET, nandi->base + NANDHAM_BOOTBANK_CFG);
+	udelay(1);
+	writel(0x00000000, nandi->base + NANDHAM_BOOTBANK_CFG);
+
+	/* Reset controller */
+	writel(CFG_RESET, nandi->base + NANDHAM_FLEXMODE_CFG);
+	udelay(1);
+	writel(0x00000000, nandi->base + NANDHAM_FLEXMODE_CFG);
+
+	/* Set EMI Bank */
+	writel(0x1 << emi_bank, nandi->base + NANDHAM_FLEX_MUXCTRL);
+
+	/* Enable FLEX mode */
+	writel(CFG_ENABLE_FLEX, nandi->base + NANDHAM_FLEXMODE_CFG);
+
+	/* Configure FLEX_DATA_READ/WRITE for 1-byte access */
+	writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+	writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+
+	/* RBn interrupt on rising edge */
+	writel(NAND_EDGE_CFG_RBN_RISING, nandi->base + NANDHAM_INT_EDGE_CFG);
+
+	/* Enable interrupts */
+	nandi_enable_interrupts(nandi, NAND_INT_ENABLE);
+}
+
 static void nandi_init_bch(struct nandi_controller *nandi, int emi_bank)
 {
 	dev_dbg(nandi->dev, "%s\n", __func__);
@@ -255,6 +290,7 @@ static void nandi_init_controller(struct nandi_controller *nandi,
 				  int emi_bank)
 {
 	nandi_init_bch(nandi, emi_bank);
+	nandi_init_hamming(nandi, emi_bank);
 }
 
 static int remap_named_resource(struct platform_device *pdev,
-- 
1.8.3.2

