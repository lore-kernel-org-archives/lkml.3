Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaIKRwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:52:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48982 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752354AbaIKRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:52:38 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2] mtd: nand: atmel_nand: retrieve NFC clock
Date: Thu, 11 Sep 2014 19:52:17 +0200
Message-Id: <1410457937-14575-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---

Changes in v2:
 - reworked the error path to really make the clock optional
 - Documented the new optional property

 .../devicetree/bindings/mtd/atmel-nand.txt         |  1 +
 drivers/mtd/nand/atmel_nand.c                      | 25 ++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/Documentation/devicetree/bindings/mtd/atmel-nand.txt b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
index c4728839d0c1..f71e2ebab15b 100644
--- a/Documentation/devicetree/bindings/mtd/atmel-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
@@ -38,6 +38,7 @@ Optional properties:
             if don't want to use it.
   - Optional properties:
     - atmel,write-by-sram: boolean to enable NFC write by sram.
+    - clocks: phandle to the peripheral clock if it exists
 
 Examples:
 nand0: nand@40000000,0 {
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 9c5f717bda54..69e0eb1ace54 100644
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
@@ -2281,6 +2285,26 @@ static int atmel_nand_nfc_probe(struct platform_device *pdev)
 
 	nfc->is_initialized = true;
 	dev_info(&pdev->dev, "NFC is probed.\n");
+
+	nfc->clk = devm_clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(nfc->clk)) {
+		ret = clk_prepare_enable(nfc->clk);
+		if (ret)
+			return ret;
+	} else {
+		dev_warn(&pdev->dev, "NFC clock is missing");
+	}
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

