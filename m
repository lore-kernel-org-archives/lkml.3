Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3HVMwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:52:10 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:51075 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab3HVMwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:52:08 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <jszhang@marvell.com>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] pinctrl: mvebu: add missing iounmap
Date: Thu, 22 Aug 2013 20:46:51 +0800
Message-ID: <1377175611-4241-5-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
References: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing iounmap to prove error path and remove path

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index bb7ddb1..d1ac6b7 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -601,7 +601,8 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 			GFP_KERNEL);
 	if (!pctl) {
 		dev_err(&pdev->dev, "unable to alloc driver\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto bail_out;
 	}
 
 	pctl->desc.name = dev_name(&pdev->dev);
@@ -631,7 +632,8 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 		if (ctrl->mpp_get || ctrl->mpp_set) {
 			if (!ctrl->name || !ctrl->mpp_get || !ctrl->mpp_set) {
 				dev_err(&pdev->dev, "wrong soc control info\n");
-				return -EINVAL;
+				ret = -EINVAL;
+				goto bail_out;
 			}
 			pctl->num_groups += 1;
 			continue;
@@ -641,7 +643,8 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 		names = devm_kzalloc(&pdev->dev, ctrl->npins * 8, GFP_KERNEL);
 		if (!names) {
 			dev_err(&pdev->dev, "failed to alloc mpp names\n");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto bail_out;
 		}
 		for (k = 0; k < ctrl->npins; k++)
 			sprintf(names + 8*k, "mpp%d", ctrl->pid+k);
@@ -653,7 +656,8 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 			     sizeof(struct pinctrl_pin_desc), GFP_KERNEL);
 	if (!pdesc) {
 		dev_err(&pdev->dev, "failed to alloc pinctrl pins\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto bail_out;
 	}
 
 	for (n = 0; n < pctl->desc.npins; n++)
@@ -664,7 +668,8 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 			     sizeof(struct mvebu_pinctrl_group), GFP_KERNEL);
 	if (!pctl->groups) {
 		dev_err(&pdev->dev, "failed to alloc pinctrl groups\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto bail_out;
 	}
 
 	/* assign mpp controls to groups */
@@ -735,13 +740,14 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 	ret = mvebu_pinctrl_build_functions(pdev, pctl);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to build functions\n");
-		return ret;
+		goto bail_out;
 	}
 
 	pctl->pctldev = pinctrl_register(&pctl->desc, &pdev->dev, pctl);
 	if (!pctl->pctldev) {
 		dev_err(&pdev->dev, "unable to register pinctrl driver\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto bail_out;
 	}
 
 	dev_info(&pdev->dev, "registered pinctrl driver\n");
@@ -751,11 +757,15 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 		pinctrl_add_gpio_range(pctl->pctldev, &soc->gpioranges[n]);
 
 	return 0;
+bail_out:
+	iounmap(base);
+	return ret;
 }
 
 int mvebu_pinctrl_remove(struct platform_device *pdev)
 {
 	struct mvebu_pinctrl *pctl = platform_get_drvdata(pdev);
+	iounmap(pctl->base);
 	pinctrl_unregister(pctl->pctldev);
 	return 0;
 }
-- 
1.8.4.rc3

