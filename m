Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaEVL02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:26:28 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56306 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaEVLYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:24:22 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/10] mtd: st_spi_fsm: Obtain and use EMI clock if provided
Date: Thu, 22 May 2014 12:24:00 +0100
Message-Id: <1400757848-18075-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400757848-18075-1-git-send-email-lee.jones@linaro.org>
References: <1400757848-18075-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST's Common Clk Framework is now available. This patch ensures the FSM
makes use of it by obtaining and enabling the EMI clock if provided. If
system fails to provide the EMI clock FSM uses its original default
rate.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 45 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index aca4d72..fe54533 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/clk.h>
 
 #include "serial_flash_cmds.h"
 
@@ -262,6 +263,7 @@ struct stfsm {
 	struct mtd_info		mtd;
 	struct mutex		lock;
 	struct flash_info       *info;
+	struct clk              *clk;
 
 	uint32_t                configuration;
 	uint32_t                fifo_dir_delay;
@@ -1907,8 +1909,13 @@ static void stfsm_set_freq(struct stfsm *fsm, uint32_t spi_freq)
 	uint32_t emi_freq;
 	uint32_t clk_div;
 
-	/* TODO: Make this dynamic */
-	emi_freq = STFSM_DEFAULT_EMI_FREQ;
+	if (!fsm->clk) {
+		dev_warn(fsm->dev,
+			 "No EMI clock available. Using default 100MHz.\n");
+
+		emi_freq = STFSM_DEFAULT_EMI_FREQ;
+	} else
+		emi_freq = clk_get_rate(fsm->clk);
 
 	/*
 	 * Calculate clk_div - values between 2 and 128
@@ -2058,6 +2065,15 @@ static int stfsm_probe(struct platform_device *pdev)
 		return PTR_ERR(fsm->base);
 	}
 
+	fsm->clk = devm_clk_get(&pdev->dev, "emi_clk");
+	if (IS_ERR(fsm->clk)) {
+		dev_warn(fsm->dev, "Couldn't find EMI clock.\n");
+		fsm->clk = NULL;
+	} else if (clk_prepare_enable(fsm->clk)) {
+		dev_warn(fsm->dev, "Failed to enable EMI clock.\n");
+		fsm->clk = NULL;
+	}
+
 	mutex_init(&fsm->lock);
 
 	ret = stfsm_init(fsm);
@@ -2122,6 +2138,30 @@ static int stfsm_remove(struct platform_device *pdev)
 	return mtd_device_unregister(&fsm->mtd);
 }
 
+#ifdef CONFIG_PM
+static int stfsmfsm_suspend(struct device *dev)
+{
+	struct stfsm *fsm = dev_get_drvdata(dev);
+
+	if (fsm->clk)
+		clk_disable_unprepare(fsm->clk);
+
+	return 0;
+}
+
+static int stfsmfsm_resume(struct device *dev)
+{
+	struct stfsm *fsm = dev_get_drvdata(dev);
+
+	if (fsm->clk)
+		clk_prepare_enable(fsm->clk);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(stfsm_pm_ops, stfsmfsm_suspend, stfsmfsm_resume);
+
 static struct of_device_id stfsm_match[] = {
 	{ .compatible = "st,spi-fsm", },
 	{},
@@ -2135,6 +2175,7 @@ static struct platform_driver stfsm_driver = {
 		.name	= "st-spi-fsm",
 		.owner	= THIS_MODULE,
 		.of_match_table = stfsm_match,
+		.pm     = &stfsm_pm_ops,
 	},
 };
 module_platform_driver(stfsm_driver);
-- 
1.8.3.2

