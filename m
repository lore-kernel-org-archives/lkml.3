Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaILNQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:16:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61372 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbaILNQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:16:56 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ac-5412f245ac9a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] extcon: max77693: Use resource managed interrupt line
Date: Fri, 12 Sep 2014 15:16:37 +0200
Message-id: <1410527797-14027-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t/xa7qun4RCDK7NlbPYOGM9q8X1L89Z
	LV6/MLQ42/SG3eLyrjlsFmuP3GW3uN24gs2B3aNvyypGj8+b5AKYorhsUlJzMstSi/TtErgy
	tp67wFawQLRi8p9prA2MfwW6GDk5JARMJD7ef8sIYYtJXLi3nq2LkYtDSGApo8Szzx+gnD4m
	iZOzprOBVLEJGEtsXr4EzBYRKJR4suEqWBGzwFFGiem9b5lAEsICbhKn931jB7FZBFQlVn4+
	zwpi8wq4S3xYNp8FYp2cxMljk1knMHIvYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRES
	CF92MC4+ZnWIUYCDUYmHl+OcYIgQa2JZcWXuIUYJDmYlEd4br4RChHhTEiurUovy44tKc1KL
	DzEycXBKNTCKVVbpZ5cyvNrcu2v7L5OQgwd+8Pcrl3hY/LPbnMZsu4ezcMWXizUF2VOVe5+n
	JWqnvrAsmezWk99zcUXVsfOXfujOvbZph0x2pNSE3edaEoKmP5l1xFdtfe6MRMZ2f9EWr7d5
	RY8PWXif5b2v9er0ZREbt5ST4W+ux/pMb015UvNHfmtydaYSS3FGoqEWc1FxIgDmQdCv4gEA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource managed interrupt line devm_request_threaded_irq() to
simplify a little cleanup paths:
 - no goto to cleanup label,
 - simpler remove function.

Overall the driver size is decreased by 11 line of code.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 77460f2c1ca1..0574154a94a9 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1155,13 +1155,11 @@ static int max77693_muic_probe(struct platform_device *pdev)
 
 		virq = regmap_irq_get_virq(max77693->irq_data_muic,
 					muic_irq->irq);
-		if (!virq) {
-			ret = -EINVAL;
-			goto err_irq;
-		}
+		if (!virq)
+			return -EINVAL;
 		muic_irq->virq = virq;
 
-		ret = request_threaded_irq(virq, NULL,
+		ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
 				max77693_muic_irq_handler,
 				IRQF_NO_SUSPEND,
 				muic_irq->name, info);
@@ -1170,7 +1168,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 				"failed: irq request (IRQ: %d,"
 				" error :%d)\n",
 				muic_irq->irq, ret);
-			goto err_irq;
+			return ret;
 		}
 	}
 
@@ -1179,15 +1177,14 @@ static int max77693_muic_probe(struct platform_device *pdev)
 					      max77693_extcon_cable);
 	if (IS_ERR(info->edev)) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
-		ret = -ENOMEM;
-		goto err_irq;
+		return -ENOMEM;
 	}
 	info->edev->name = DEV_NAME;
 
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-		goto err_irq;
+		return ret;
 	}
 
 	/* Initialize MUIC register by using platform data or default data */
@@ -1265,7 +1262,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 			MAX77693_MUIC_REG_ID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
-		goto err_irq;
+		return ret;
 	}
 	dev_info(info->dev, "device ID : 0x%x\n", id);
 
@@ -1285,20 +1282,12 @@ static int max77693_muic_probe(struct platform_device *pdev)
 			delay_jiffies);
 
 	return ret;
-
-err_irq:
-	while (--i >= 0)
-		free_irq(muic_irqs[i].virq, info);
-	return ret;
 }
 
 static int max77693_muic_remove(struct platform_device *pdev)
 {
 	struct max77693_muic_info *info = platform_get_drvdata(pdev);
-	int i;
 
-	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
-		free_irq(muic_irqs[i].virq, info);
 	cancel_work_sync(&info->irq_work);
 	input_unregister_device(info->dock);
 
-- 
1.9.1

