Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaKGNFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:05:08 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56109 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaKGNFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:05:04 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: rtc-linux@googlegroups.com
Cc: shawn.guo@linaro.org, linux@arm.linux.org.uk, kernel@pengutronix.de,
        stefan@agner.ch, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [[PATCHv2] 3/3] drivers/rtc/rtc-snvs: Add clock support
Date: Fri,  7 Nov 2014 18:34:28 +0530
Message-Id: <30e496ce2d6521e608df3b68b73b3e05caa1daef.1415364391.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1415364391.git.maitysanchayan@gmail.com>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1415364391.git.maitysanchayan@gmail.com>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds clock enable and disable support for
the SNVS peripheral, which is required for using the
RTC within the SNVS block.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 drivers/rtc/rtc-snvs.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index fa384fe..d4a6512 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -17,6 +17,7 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
+#include <linux/clk.h>
 
 /* These register offsets are relative to LP (Low Power) range */
 #define SNVS_LPCR		0x04
@@ -39,6 +40,7 @@ struct snvs_rtc_data {
 	void __iomem *ioaddr;
 	int irq;
 	spinlock_t lock;
+	struct clk *clk;
 };
 
 static u32 rtc_read_lp_counter(void __iomem *ioaddr)
@@ -260,6 +262,18 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 	if (data->irq < 0)
 		return data->irq;
 
+	data->clk = devm_clk_get(&pdev->dev, "snvs-rtc");
+	if (IS_ERR(data->clk)) {
+		data->clk = NULL;
+	} else {
+		ret = clk_prepare_enable(data->clk);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Could not prepare or enable the snvs clock\n");
+			return ret;
+		}
+	}
+
 	platform_set_drvdata(pdev, data);
 
 	spin_lock_init(&data->lock);
@@ -280,7 +294,7 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request irq %d: %d\n",
 			data->irq, ret);
-		return ret;
+		goto error_rtc_device_register;
 	}
 
 	data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
@@ -288,10 +302,16 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 	if (IS_ERR(data->rtc)) {
 		ret = PTR_ERR(data->rtc);
 		dev_err(&pdev->dev, "failed to register rtc: %d\n", ret);
-		return ret;
+		goto error_rtc_device_register;
 	}
 
 	return 0;
+
+error_rtc_device_register:
+	if (data->clk)
+		clk_disable_unprepare(data->clk);
+
+	return ret;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -302,16 +322,26 @@ static int snvs_rtc_suspend(struct device *dev)
 	if (device_may_wakeup(dev))
 		enable_irq_wake(data->irq);
 
+	if (data->clk)
+		clk_disable_unprepare(data->clk);
+
 	return 0;
 }
 
 static int snvs_rtc_resume(struct device *dev)
 {
 	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+	int ret;
 
 	if (device_may_wakeup(dev))
 		disable_irq_wake(data->irq);
 
+	if (data->clk) {
+		ret = clk_prepare_enable(data->clk);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 #endif
-- 
1.7.9.5

