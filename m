Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3AUKKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:10:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab3AUKKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:40 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 24/33] rtc: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:17 +0100
Message-Id: <1358762966-20791-25-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:SlhnGFDlSfiYivur0cvkkZWqRyheeF7nFUE5JxfUyHP
 ykABnftzp0iwlyzhzEh+FMDF2hkdtHQDnvE1zXNjgFqJLeTdX6
 AHOWkfikBPVg9ctWDZa3947QRvIbLEf3+2Z6gmRKJVQL6892N5
 3xcxwPqkunXgKQflIn5HA4+w2U3/jAyKxiVWsdgU0sk8L/wihN
 +L5XLHpMRf9rH1HFBG4h/T/szBRvjXrxcZZxpqkaIIdQJIWJzY
 3EWS/qkIjyintz6vy6Z7Pq6ZHwE/8U6HMTTFWJzyn8nAWan582
 u/yK8ODd4qlSqSWQdE+TM2koeb6k16XhcO4yYj3OPRvzHCB/ie
 DKDlA5hL+8qHgRPjqX2O9RXiPHFR+aqlUmMytcns4ZDuRlq9eD
 VOEhEiHqVZrrt1V49ae0FGTaIbtMUbrvFepPBUfvzqoD3lLLdH
 4Ztus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/rtc-s3c.c   | 8 +++-----
 drivers/rtc/rtc-snvs.c  | 6 +++---
 drivers/rtc/rtc-spear.c | 8 +++-----
 drivers/rtc/rtc-tegra.c | 8 +++-----
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 4046514..0c397ac 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -486,11 +486,9 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	s3c_rtc_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (s3c_rtc_base == NULL) {
-		dev_err(&pdev->dev, "failed to ioremap memory region\n");
-		return -EINVAL;
-	}
+	s3c_rtc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(s3c_rtc_base))
+		return PTR_ERR(s3c_rtc_base);
 
 	rtc_clk = devm_clk_get(&pdev->dev, "rtc");
 	if (IS_ERR(rtc_clk)) {
diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index d5ec785..40662e9 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -252,9 +252,9 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	data->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
-	if (!data->ioaddr)
-		return -EADDRNOTAVAIL;
+	data->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(data->ioaddr))
+		return PTR_ERR(data->ioaddr);
 
 	data->irq = platform_get_irq(pdev, 0);
 	if (data->irq < 0)
diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index c2121b5..a18c319 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -385,11 +385,9 @@ static int spear_rtc_probe(struct platform_device *pdev)
 		return status;
 	}
 
-	config->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
-	if (!config->ioaddr) {
-		dev_err(&pdev->dev, "request-ioremap fail\n");
-		return -ENOMEM;
-	}
+	config->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(config->ioaddr))
+		return PTR_ERR(config->ioaddr);
 
 	config->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(config->clk))
diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index c84ea66..7c03375 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -327,11 +327,9 @@ static int tegra_rtc_probe(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
-	info->rtc_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!info->rtc_base) {
-		dev_err(&pdev->dev, "Unable to request mem region and grab IOs for device.\n");
-		return -EBUSY;
-	}
+	info->rtc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(info->rtc_base))
+		return PTR_ERR(info->rtc_base);
 
 	info->tegra_rtc_irq = platform_get_irq(pdev, 0);
 	if (info->tegra_rtc_irq <= 0)
-- 
1.8.1.1

