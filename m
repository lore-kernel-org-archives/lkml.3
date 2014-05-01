Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbaEAKIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:08:21 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50549 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbaEAJ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/47] mtd: nand: stm_nand_bch: add Power Management
Date: Thu,  1 May 2014 10:56:19 +0100
Message-Id: <1398938214-17847-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate the standard PM call-backs for; suspend, resume and restore.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 0c6aad2..8a63c4a 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -568,12 +568,51 @@ static int stm_nand_bch_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int stm_nand_bch_suspend(struct device *dev)
+{
+	struct nandi_controller *nandi = dev_get_drvdata(dev);
+
+	nandi_clk_disable(nandi);
+
+	return 0;
+}
+static int stm_nand_bch_resume(struct device *dev)
+{
+	struct nandi_controller *nandi = dev_get_drvdata(dev);
+
+	nandi_clk_enable(nandi);
+
+	return 0;
+}
+
+static int stm_nand_bch_restore(struct device *dev)
+{
+	struct nandi_controller *nandi = dev_get_drvdata(dev);
+	struct stm_plat_nand_bch_data *pdata = dev->platform_data;
+	struct stm_nand_bank_data *bank = pdata->bank;
+
+	nandi_init_controller(nandi, bank->csn);
+
+	return 0;
+}
+
+static const struct dev_pm_ops stm_nand_bch_pm_ops = {
+	.suspend = stm_nand_bch_suspend,
+	.resume = stm_nand_bch_resume,
+	.restore = stm_nand_bch_restore,
+};
+#else
+static const struct dev_pm_ops stm_nand_bch_pm_ops;
+#endif
+
 static struct platform_driver stm_nand_bch_driver = {
 	.probe	= stm_nand_bch_probe ,
 	.remove	= stm_nand_bch_remove,
 	.driver	= {
 		.name	= "stm-nand-bch",
 		.owner	= THIS_MODULE,
+		.pm	= &stm_nand_bch_pm_ops,
 	},
 };
 module_platform_driver(stm_nand_bch_driver);
-- 
1.8.3.2

