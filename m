Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaLOMDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:03:01 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:55353 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaLOL7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:59:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v3 02/13] mtd: st_spi_fsm: Obtain and use EMI clock
Date: Mon, 15 Dec 2014 11:59:09 +0000
Message-Id: <1418644760-18773-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
References: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST's Common Clk Framework is now available. This patch ensures the FSM
makes use of it by obtaining and enabling the EMI clock. If system fails
to provide the EMI clock, we bomb out.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 6e4d3bfe..fac0fe9 100644
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
@@ -1906,8 +1908,7 @@ static void stfsm_set_freq(struct stfsm *fsm, uint32_t spi_freq)
 	uint32_t emi_freq;
 	uint32_t clk_div;
 
-	/* TODO: Make this dynamic */
-	emi_freq = STFSM_DEFAULT_EMI_FREQ;
+	emi_freq = clk_get_rate(fsm->clk);
 
 	/*
 	 * Calculate clk_div - values between 2 and 128
@@ -2057,6 +2058,18 @@ static int stfsm_probe(struct platform_device *pdev)
 		return PTR_ERR(fsm->base);
 	}
 
+	fsm->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(fsm->clk)) {
+		dev_err(fsm->dev, "Couldn't find EMI clock.\n");
+		return PTR_ERR(fsm->clk);
+	}
+
+	ret = clk_prepare_enable(fsm->clk);
+	if (ret) {
+		dev_err(fsm->dev, "Failed to enable EMI clock.\n");
+		return ret;
+	}
+
 	mutex_init(&fsm->lock);
 
 	ret = stfsm_init(fsm);
@@ -2121,6 +2134,28 @@ static int stfsm_remove(struct platform_device *pdev)
 	return mtd_device_unregister(&fsm->mtd);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int stfsmfsm_suspend(struct device *dev)
+{
+	struct stfsm *fsm = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(fsm->clk);
+
+	return 0;
+}
+
+static int stfsmfsm_resume(struct device *dev)
+{
+	struct stfsm *fsm = dev_get_drvdata(dev);
+
+	clk_prepare_enable(fsm->clk);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(stfsm_pm_ops, stfsmfsm_suspend, stfsmfsm_resume);
+
 static const struct of_device_id stfsm_match[] = {
 	{ .compatible = "st,spi-fsm", },
 	{},
@@ -2134,6 +2169,7 @@ static struct platform_driver stfsm_driver = {
 		.name	= "st-spi-fsm",
 		.owner	= THIS_MODULE,
 		.of_match_table = stfsm_match,
+		.pm     = &stfsm_pm_ops,
 	},
 };
 module_platform_driver(stfsm_driver);
-- 
1.9.1

