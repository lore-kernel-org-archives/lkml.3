Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaILJkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:40:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53331 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753500AbaILJkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:40:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>, Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4] mtd: nand: atmel_nand: retrieve NFC clock
Date: Fri, 12 Sep 2014 11:40:09 +0200
Message-Id: <1410514809-25650-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---

Changes in v4:
 - fix typo in the documentation

 .../devicetree/bindings/mtd/atmel-nand.txt         |  2 ++
 drivers/mtd/nand/atmel_nand.c                      | 25 ++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/Documentation/devicetree/bindings/mtd/atmel-nand.txt b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
index c4728839d0c1..6edc3b616e98 100644
--- a/Documentation/devicetree/bindings/mtd/atmel-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
@@ -36,6 +36,7 @@ Optional properties:
     - reg : should specify the address and size used for NFC command registers,
             NFC registers and NFC Sram. NFC Sram address and size can be absent
             if don't want to use it.
+    - clocks: phandle to the peripheral clock
   - Optional properties:
     - atmel,write-by-sram: boolean to enable NFC write by sram.
 
@@ -98,6 +99,7 @@ nand0: nand@40000000 {
 		compatible = "atmel,sama5d3-nfc";
 		#address-cells = <1>;
 		#size-cells = <1>;
+		clocks = <&hsmc_clk>
 		reg = <
 			0x70000000 0x10000000	/* NFC Command Registers */
 			0xffffc000 0x00000070	/* NFC HSMC regs */
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 9c5f717bda54..d1e502f8dbd0 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -27,6 +27,7 @@
  *
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -96,6 +97,8 @@ struct atmel_nfc {
 	bool			use_nfc_sram;
 	bool			write_by_sram;
 
+	struct clk		*clk;
+
 	bool			is_initialized;
 	struct completion	comp_ready;
 	struct completion	comp_cmd_done;
@@ -2248,6 +2251,7 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
 {
 	struct atmel_nfc *nfc = &nand_nfc;
 	struct resource *nfc_cmd_regs, *nfc_hsmc_regs, *nfc_sram;
+	int ret;
 
 	nfc_cmd_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	nfc->base_cmd_regs = devm_ioremap_resource(&pdev->dev, nfc_cmd_regs);
@@ -2279,8 +2283,28 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
 	nfc_writel(nfc->hsmc_regs, IDR, 0xffffffff);
 	nfc_readl(nfc->hsmc_regs, SR);	/* clear the NFC_SR */
 
+	nfc->clk = devm_clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(nfc->clk)) {
+		ret = clk_prepare_enable(nfc->clk);
+		if (ret)
+			return ret;
+	} else {
+		dev_warn(&pdev->dev, "NFC clock missing, update your Device Tree");
+	}
+
 	nfc->is_initialized = true;
 	dev_info(&pdev->dev, "NFC is probed.\n");
+
+	return 0;
+}
+
+static int atmel_nand_nfc_remove(struct platform_device *pdev)
+{
+	struct atmel_nfc *nfc = &nand_nfc;
+
+	if (!IS_ERR(nfc->clk))
+		clk_disable_unprepare(nfc->clk);
+
 	return 0;
 }
 
@@ -2297,6 +2321,7 @@ static struct platform_driver atmel_nand_nfc_driver = {
 		.of_match_table = of_match_ptr(atmel_nand_nfc_match),
 	},
 	.probe = atmel_nand_nfc_probe,
+	.remove = atmel_nand_nfc_remove,
 };
 
 static struct platform_driver atmel_nand_driver = {
-- 
1.9.1

