Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab3HMJw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:52:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60102 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab3HMJw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:52:56 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>
CC: <kishon@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH 1/2] usb: musb: convert to devm_* to allocate resources
Date: Tue, 13 Aug 2013 15:22:47 +0530
Message-ID: <1376387568-21253-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Used devm_kzalloc and devm_clk_get instead of
kzalloc and clk_get.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
only *compile* tested.

 drivers/usb/musb/am35x.c     |   40 ++++++++++++++--------------------------
 drivers/usb/musb/blackfin.c  |    8 ++------
 drivers/usb/musb/da8xx.c     |   28 ++++++++++------------------
 drivers/usb/musb/davinci.c   |   28 ++++++++++------------------
 drivers/usb/musb/musb_dsps.c |    4 +---
 drivers/usb/musb/tusb6010.c  |   16 ++++++----------
 drivers/usb/musb/ux500.c     |   28 ++++++++++------------------
 7 files changed, 53 insertions(+), 99 deletions(-)

diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index 5c310c6..50ba013 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -465,7 +465,7 @@ static int am35x_probe(struct platform_device *pdev)
 
 	int				ret = -ENOMEM;
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
 		goto err0;
@@ -474,33 +474,33 @@ static int am35x_probe(struct platform_device *pdev)
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
 	if (!musb) {
 		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
+		goto err0;
 	}
 
-	phy_clk = clk_get(&pdev->dev, "fck");
+	phy_clk = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(phy_clk)) {
 		dev_err(&pdev->dev, "failed to get PHY clock\n");
 		ret = PTR_ERR(phy_clk);
-		goto err3;
+		goto err1;
 	}
 
-	clk = clk_get(&pdev->dev, "ick");
+	clk = devm_clk_get(&pdev->dev, "ick");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		ret = PTR_ERR(clk);
-		goto err4;
+		goto err1;
 	}
 
 	ret = clk_enable(phy_clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable PHY clock\n");
-		goto err5;
+		goto err1;
 	}
 
 	ret = clk_enable(clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
-		goto err6;
+		goto err2;
 	}
 
 	musb->dev.parent		= &pdev->dev;
@@ -520,40 +520,31 @@ static int am35x_probe(struct platform_device *pdev)
 			pdev->num_resources);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err7;
+		goto err3;
 	}
 
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err7;
+		goto err3;
 	}
 
 	ret = platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
-		goto err7;
+		goto err3;
 	}
 
 	return 0;
 
-err7:
+err3:
 	clk_disable(clk);
 
-err6:
+err2:
 	clk_disable(phy_clk);
 
-err5:
-	clk_put(clk);
-
-err4:
-	clk_put(phy_clk);
-
-err3:
-	platform_device_put(musb);
-
 err1:
-	kfree(glue);
+	platform_device_put(musb);
 
 err0:
 	return ret;
@@ -566,9 +557,6 @@ static int am35x_remove(struct platform_device *pdev)
 	platform_device_unregister(glue->musb);
 	clk_disable(glue->clk);
 	clk_disable(glue->phy_clk);
-	clk_put(glue->clk);
-	clk_put(glue->phy_clk);
-	kfree(glue);
 
 	return 0;
 }
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 72e2056..70f4c5d 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -457,7 +457,7 @@ static int bfin_probe(struct platform_device *pdev)
 
 	int				ret = -ENOMEM;
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
 		goto err0;
@@ -466,7 +466,7 @@ static int bfin_probe(struct platform_device *pdev)
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
 	if (!musb) {
 		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
+		goto err0;
 	}
 
 	musb->dev.parent		= &pdev->dev;
@@ -517,9 +517,6 @@ static int bfin_probe(struct platform_device *pdev)
 err3:
 	platform_device_put(musb);
 
-err1:
-	kfree(glue);
-
 err0:
 	return ret;
 }
@@ -529,7 +526,6 @@ static int bfin_remove(struct platform_device *pdev)
 	struct bfin_glue		*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
-	kfree(glue);
 
 	return 0;
 }
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index d9ddf41..89b2c65 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -485,7 +485,7 @@ static int da8xx_probe(struct platform_device *pdev)
 
 	int				ret = -ENOMEM;
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
 		goto err0;
@@ -494,20 +494,20 @@ static int da8xx_probe(struct platform_device *pdev)
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
 	if (!musb) {
 		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
+		goto err0;
 	}
 
-	clk = clk_get(&pdev->dev, "usb20");
+	clk = devm_clk_get(&pdev->dev, "usb20");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		ret = PTR_ERR(clk);
-		goto err3;
+		goto err1;
 	}
 
 	ret = clk_enable(clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
-		goto err4;
+		goto err1;
 	}
 
 	musb->dev.parent		= &pdev->dev;
@@ -539,34 +539,28 @@ static int da8xx_probe(struct platform_device *pdev)
 			ARRAY_SIZE(musb_resources));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err5;
+		goto err2;
 	}
 
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err5;
+		goto err2;
 	}
 
 	ret = platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
-		goto err5;
+		goto err2;
 	}
 
 	return 0;
 
-err5:
+err2:
 	clk_disable(clk);
 
-err4:
-	clk_put(clk);
-
-err3:
-	platform_device_put(musb);
-
 err1:
-	kfree(glue);
+	platform_device_put(musb);
 
 err0:
 	return ret;
@@ -578,8 +572,6 @@ static int da8xx_remove(struct platform_device *pdev)
 
 	platform_device_unregister(glue->musb);
 	clk_disable(glue->clk);
-	clk_put(glue->clk);
-	kfree(glue);
 
 	return 0;
 }
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index ed0834e..9bb121d 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -517,7 +517,7 @@ static int davinci_probe(struct platform_device *pdev)
 
 	int				ret = -ENOMEM;
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
 		goto err0;
@@ -526,20 +526,20 @@ static int davinci_probe(struct platform_device *pdev)
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
 	if (!musb) {
 		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
+		goto err0;
 	}
 
-	clk = clk_get(&pdev->dev, "usb");
+	clk = devm_clk_get(&pdev->dev, "usb");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		ret = PTR_ERR(clk);
-		goto err3;
+		goto err1;
 	}
 
 	ret = clk_enable(clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
-		goto err4;
+		goto err1;
 	}
 
 	musb->dev.parent		= &pdev->dev;
@@ -571,34 +571,28 @@ static int davinci_probe(struct platform_device *pdev)
 			ARRAY_SIZE(musb_resources));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err5;
+		goto err2;
 	}
 
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err5;
+		goto err2;
 	}
 
 	ret = platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
-		goto err5;
+		goto err2;
 	}
 
 	return 0;
 
-err5:
+err2:
 	clk_disable(clk);
 
-err4:
-	clk_put(clk);
-
-err3:
-	platform_device_put(musb);
-
 err1:
-	kfree(glue);
+	platform_device_put(musb);
 
 err0:
 	return ret;
@@ -610,8 +604,6 @@ static int davinci_remove(struct platform_device *pdev)
 
 	platform_device_unregister(glue->musb);
 	clk_disable(glue->clk);
-	clk_put(glue->clk);
-	kfree(glue);
 
 	return 0;
 }
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 4ffbaac..acd984c 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -524,7 +524,7 @@ static int dsps_probe(struct platform_device *pdev)
 	wrp = match->data;
 
 	/* allocate glue */
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "unable to allocate glue memory\n");
 		return -ENOMEM;
@@ -552,7 +552,6 @@ err3:
 	pm_runtime_put(&pdev->dev);
 err2:
 	pm_runtime_disable(&pdev->dev);
-	kfree(glue);
 	return ret;
 }
 
@@ -565,7 +564,6 @@ static int dsps_remove(struct platform_device *pdev)
 	/* disable usbss clocks */
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	kfree(glue);
 	return 0;
 }
 
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index c642f09..6d93fe8 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1163,7 +1163,7 @@ static int tusb_probe(struct platform_device *pdev)
 
 	int				ret = -ENOMEM;
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
 		goto err0;
@@ -1172,7 +1172,7 @@ static int tusb_probe(struct platform_device *pdev)
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
 	if (!musb) {
 		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
+		goto err0;
 	}
 
 	musb->dev.parent		= &pdev->dev;
@@ -1208,28 +1208,25 @@ static int tusb_probe(struct platform_device *pdev)
 			ARRAY_SIZE(musb_resources));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err3;
+		goto err1;
 	}
 
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err3;
+		goto err1;
 	}
 
 	ret = platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
-		goto err3;
+		goto err1;
 	}
 
 	return 0;
 
-err3:
-	platform_device_put(musb);
-
 err1:
-	kfree(glue);
+	platform_device_put(musb);
 
 err0:
 	return ret;
@@ -1240,7 +1237,6 @@ static int tusb_remove(struct platform_device *pdev)
 	struct tusb6010_glue		*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
-	kfree(glue);
 
 	return 0;
 }
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 59256b1..14a1d62 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -247,7 +247,7 @@ static int ux500_probe(struct platform_device *pdev)
 		}
 	}
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
 		goto err0;
@@ -256,20 +256,20 @@ static int ux500_probe(struct platform_device *pdev)
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
 	if (!musb) {
 		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
+		goto err0;
 	}
 
-	clk = clk_get(&pdev->dev, "usb");
+	clk = devm_clk_get(&pdev->dev, "usb");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		ret = PTR_ERR(clk);
-		goto err3;
+		goto err1;
 	}
 
 	ret = clk_prepare_enable(clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
-		goto err4;
+		goto err1;
 	}
 
 	musb->dev.parent		= &pdev->dev;
@@ -303,34 +303,28 @@ static int ux500_probe(struct platform_device *pdev)
 			ARRAY_SIZE(musb_resources));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err5;
+		goto err2;
 	}
 
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err5;
+		goto err2;
 	}
 
 	ret = platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
-		goto err5;
+		goto err2;
 	}
 
 	return 0;
 
-err5:
+err2:
 	clk_disable_unprepare(clk);
 
-err4:
-	clk_put(clk);
-
-err3:
-	platform_device_put(musb);
-
 err1:
-	kfree(glue);
+	platform_device_put(musb);
 
 err0:
 	return ret;
@@ -342,8 +336,6 @@ static int ux500_remove(struct platform_device *pdev)
 
 	platform_device_unregister(glue->musb);
 	clk_disable_unprepare(glue->clk);
-	clk_put(glue->clk);
-	kfree(glue);
 
 	return 0;
 }
-- 
1.7.10.4

