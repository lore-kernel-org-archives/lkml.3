Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3LQNjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:39:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42850 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3LQNjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:39:52 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v4 7/9] mtd: nand: davinci: adjust DT properties to MTD generic
Date: Tue, 17 Dec 2013 15:37:56 +0200
Message-ID: <1387287476-19907-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The properties davinci-ecc-mode, davinci-nand-use-bbt, davinci-nand-buswidth
are MTD generic. Correct names for them are: nand-ecc-mode, nand-on-flash-bbt,
nand-bus-width accordingly. So rename them in dts and documentation.

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Taras Kondratiuk <taras@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 .../devicetree/bindings/mtd/davinci-nand.txt       |   25 ++++++++++++++++----
 drivers/mtd/nand/davinci_nand.c                    |   14 +++++++----
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
index d2a3fc0..befaa5b 100644
--- a/Documentation/devicetree/bindings/mtd/davinci-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
@@ -37,7 +37,7 @@ Recommended properties :
 - ti,davinci-mask-chipsel:	mask for chipselect address. Needed to mask
 				addresses for given chipselect.
 
-- ti,davinci-ecc-mode:		operation mode of the NAND ecc mode. ECC mode
+- nand-ecc-mode:		operation mode of the NAND ecc mode. ECC mode
 				valid values for davinci driver:
 				- "none"
 				- "soft"
@@ -45,10 +45,25 @@ Recommended properties :
 
 - ti,davinci-ecc-bits:		used ECC bits, currently supported 1 or 4.
 
-- ti,davinci-nand-buswidth:	buswidth 8 or 16.
+- nand-bus-width:		buswidth 8 or 16. If not present 8.
+
+- nand-on-flash-bbt:		use flash based bad block table support. OOB
+				identifier is saved in OOB area. If not present
+				false.
+
+Deprecated properties:
+
+- ti,davinci-ecc-mode:		operation mode of the NAND ecc mode. ECC mode
+				valid values for davinci driver:
+				- "none"
+				- "soft"
+				- "hw"
+
+- ti,davinci-nand-buswidth:	buswidth 8 or 16. If not present 8.
 
 - ti,davinci-nand-use-bbt:	use flash based bad block table support. OOB
-				identifier is saved in OOB area.
+				identifier is saved in OOB area. If not present
+				false.
 
 Nand device bindings may contain additional sub-nodes describing partitions of
 the address space. See partition.txt for more detail. The NAND Flash timing
@@ -66,9 +81,9 @@ nand_cs3@62000000 {
 	ti,davinci-mask-ale = <0>;
 	ti,davinci-mask-cle = <0>;
 	ti,davinci-mask-chipsel = <0>;
-	ti,davinci-ecc-mode = "hw";
+	nand-ecc-mode = "hw";
 	ti,davinci-ecc-bits = <4>;
-	ti,davinci-nand-use-bbt;
+	nand-on-flash-bbt;
 
 	partition@180000 {
 		label = "ubifs";
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index e6757b3..8a61a40 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/of_device.h>
 #include <linux/of.h>
+#include <linux/of_mtd.h>
 
 #include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/mtd-davinci-aemif.h>
@@ -534,7 +535,6 @@ static struct davinci_nand_pdata
 		struct davinci_nand_pdata *pdata;
 		const char *mode;
 		u32 prop;
-		int len;
 
 		pdata =  devm_kzalloc(&pdev->dev,
 				sizeof(struct davinci_nand_pdata),
@@ -558,6 +558,8 @@ static struct davinci_nand_pdata
 			"ti,davinci-mask-chipsel", &prop))
 			pdata->mask_chipsel = prop;
 		if (!of_property_read_string(pdev->dev.of_node,
+			"nand-ecc-mode", &mode) ||
+		    !of_property_read_string(pdev->dev.of_node,
 			"ti,davinci-ecc-mode", &mode)) {
 			if (!strncmp("none", mode, 4))
 				pdata->ecc_mode = NAND_ECC_NONE;
@@ -569,12 +571,16 @@ static struct davinci_nand_pdata
 		if (!of_property_read_u32(pdev->dev.of_node,
 			"ti,davinci-ecc-bits", &prop))
 			pdata->ecc_bits = prop;
-		if (!of_property_read_u32(pdev->dev.of_node,
+
+		prop = of_get_nand_bus_width(pdev->dev.of_node);
+		if (0 < prop || !of_property_read_u32(pdev->dev.of_node,
 			"ti,davinci-nand-buswidth", &prop))
 			if (prop == 16)
 				pdata->options |= NAND_BUSWIDTH_16;
-		if (of_find_property(pdev->dev.of_node,
-			"ti,davinci-nand-use-bbt", &len))
+		if (of_property_read_bool(pdev->dev.of_node,
+			"nand-on-flash-bbt") ||
+		    of_property_read_bool(pdev->dev.of_node,
+			"ti,davinci-nand-use-bbt"))
 			pdata->bbt_options = NAND_BBT_USE_FLASH;
 	}
 
-- 
1.7.9.5

