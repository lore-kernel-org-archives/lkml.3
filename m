Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936103Ab3DKOkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:40:18 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57703 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3DKOkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:40:16 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, stable <stable@vger.kernel.org>
Subject: [PATCH] rtc: rtc-at91rm9200: fix missing iounmap
Date: Thu, 11 Apr 2013 16:38:36 +0200
Message-Id: <1365691116-8882-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing iounmap to probe error path and remove.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/rtc/rtc-at91rm9200.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 434ebc3..eebd8ac 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -297,7 +297,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 				"at91_rtc", pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ %d already in use.\n", irq);
-		return ret;
+		goto err_unmap;
 	}
 
 	/* cpu init code should really have flagged this device as
@@ -309,13 +309,20 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&at91_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		free_irq(irq, pdev);
-		return PTR_ERR(rtc);
+		ret = PTR_ERR(rtc);
+		goto err_free_irq;
 	}
 	platform_set_drvdata(pdev, rtc);
 
 	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
+
+err_free_irq:
+	free_irq(irq, pdev);
+err_unmap:
+	iounmap(at91_rtc_regs);
+
+	return ret;
 }
 
 /*
@@ -332,6 +339,7 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	free_irq(irq, pdev);
 
 	rtc_device_unregister(rtc);
+	iounmap(at91_rtc_regs);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.8.1.5

