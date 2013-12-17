Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3LQNjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:39:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42801 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3LQNi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:38:58 -0500
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
Subject: [PATCH v4 4/9] mtd: nand: davinci: simplify error handling
Date: Tue, 17 Dec 2013 15:37:00 +0200
Message-ID: <1387287420-19802-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is not needed to use a lot of names for err handling.
It complicates code support and reading.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Taras Kondratiuk <taras@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/mtd/nand/davinci_nand.c |   46 +++++++++++++++------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 9eea269..e6757b3 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -615,8 +615,7 @@ static int nand_davinci_probe(struct platform_device *pdev)
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "unable to allocate memory\n");
-		ret = -ENOMEM;
-		goto err_nomem;
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, info);
@@ -625,20 +624,16 @@ static int nand_davinci_probe(struct platform_device *pdev)
 	res2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!res1 || !res2) {
 		dev_err(&pdev->dev, "resource missing\n");
-		ret = -EINVAL;
-		goto err_nomem;
+		return -EINVAL;
 	}
 
 	vaddr = devm_ioremap_resource(&pdev->dev, res1);
-	if (IS_ERR(vaddr)) {
-		ret = PTR_ERR(vaddr);
-		goto err_ioremap;
-	}
+	if (IS_ERR(vaddr))
+		return PTR_ERR(vaddr);
+
 	base = devm_ioremap_resource(&pdev->dev, res2);
-	if (IS_ERR(base)) {
-		ret = PTR_ERR(base);
-		goto err_ioremap;
-	}
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	info->dev		= &pdev->dev;
 	info->base		= base;
@@ -705,7 +700,7 @@ static int nand_davinci_probe(struct platform_device *pdev)
 			spin_unlock_irq(&davinci_nand_lock);
 
 			if (ret == -EBUSY)
-				goto err_ecc;
+				return ret;
 
 			info->chip.ecc.calculate = nand_davinci_calculate_4bit;
 			info->chip.ecc.correct = nand_davinci_correct_4bit;
@@ -721,8 +716,7 @@ static int nand_davinci_probe(struct platform_device *pdev)
 		info->chip.ecc.strength = pdata->ecc_bits;
 		break;
 	default:
-		ret = -EINVAL;
-		goto err_ecc;
+		return -EINVAL;
 	}
 	info->chip.ecc.mode = ecc_mode;
 
@@ -730,7 +724,7 @@ static int nand_davinci_probe(struct platform_device *pdev)
 	if (IS_ERR(info->clk)) {
 		ret = PTR_ERR(info->clk);
 		dev_dbg(&pdev->dev, "unable to get AEMIF clock, err %d\n", ret);
-		goto err_clk;
+		return ret;
 	}
 
 	ret = clk_prepare_enable(info->clk);
@@ -759,7 +753,7 @@ static int nand_davinci_probe(struct platform_device *pdev)
 							info->core_chipsel);
 	if (ret < 0) {
 		dev_dbg(&pdev->dev, "NAND timing values setup fail\n");
-		goto err_timing;
+		goto err;
 	}
 
 	spin_lock_irq(&davinci_nand_lock);
@@ -775,7 +769,7 @@ static int nand_davinci_probe(struct platform_device *pdev)
 	ret = nand_scan_ident(&info->mtd, pdata->mask_chipsel ? 2 : 1, NULL);
 	if (ret < 0) {
 		dev_dbg(&pdev->dev, "no NAND chip(s) found\n");
-		goto err_scan;
+		goto err;
 	}
 
 	/* Update ECC layout if needed ... for 1-bit HW ECC, the default
@@ -789,7 +783,7 @@ static int nand_davinci_probe(struct platform_device *pdev)
 		if (!chunks || info->mtd.oobsize < 16) {
 			dev_dbg(&pdev->dev, "too small\n");
 			ret = -EINVAL;
-			goto err_scan;
+			goto err;
 		}
 
 		/* For small page chips, preserve the manufacturer's
@@ -820,7 +814,7 @@ static int nand_davinci_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "no 4-bit ECC support yet "
 				"for 4KiB-page NAND\n");
 		ret = -EIO;
-		goto err_scan;
+		goto err;
 
 syndrome_done:
 		info->chip.ecc.layout = &info->ecclayout;
@@ -828,7 +822,7 @@ syndrome_done:
 
 	ret = nand_scan_tail(&info->mtd);
 	if (ret < 0)
-		goto err_scan;
+		goto err;
 
 	if (pdata->parts)
 		ret = mtd_device_parse_register(&info->mtd, NULL, NULL,
@@ -841,7 +835,7 @@ syndrome_done:
 						NULL, 0);
 	}
 	if (ret < 0)
-		goto err_scan;
+		goto err;
 
 	val = davinci_nand_readl(info, NRCSR_OFFSET);
 	dev_info(&pdev->dev, "controller rev. %d.%d\n",
@@ -849,8 +843,7 @@ syndrome_done:
 
 	return 0;
 
-err_scan:
-err_timing:
+err:
 	clk_disable_unprepare(info->clk);
 
 err_clk_enable:
@@ -858,11 +851,6 @@ err_clk_enable:
 	if (ecc_mode == NAND_ECC_HW_SYNDROME)
 		ecc4_busy = false;
 	spin_unlock_irq(&davinci_nand_lock);
-
-err_ecc:
-err_clk:
-err_ioremap:
-err_nomem:
 	return ret;
 }
 
-- 
1.7.9.5

