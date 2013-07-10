Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3GJJVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:21:02 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7034 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3GJJVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:21:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 10 Jul 2013 02:21:32 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <rob@landley.net>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3] extcon: palmas: Option to disable ID/VBUS detection based on platform
Date: Wed, 10 Jul 2013 14:59:06 +0530
Message-ID: <1373448546-7531-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on system design, platform needs to detect the VBUS or ID or
both. Provide option to select this through platform data to
disable part of cable detection through palmas-usb.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Acked-by: Graeme Gregory <gg@slimlogic.co.uk>
---
No changes from V1.

Change from V2:
- Remove the changes on platform strcuture.
- Move the palma_usb allocation before DT parsing.
- remove the mem allocation of pdata as it is not used.

Note:
- This was the 4th patch of the series. ALready 3 pacthes are applied and
  hence sending this 4th patch only. This has the fix suggested by Chanwoo.

 .../devicetree/bindings/extcon/extcon-palmas.txt   |    2 +
 drivers/extcon/extcon-palmas.c                     |   87 ++++++++++++--------
 include/linux/mfd/palmas.h                         |    3 +
 3 files changed, 58 insertions(+), 34 deletions(-)

diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
index f110e75..7dab6a8 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
+++ b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
@@ -6,6 +6,8 @@ Required Properties:
 
 Optional Properties:
  - ti,wakeup : To enable the wakeup comparator in probe
+ - ti,enable-id-detection: Perform ID detection.
+ - ti,enable-vbus-detection: Perform VBUS detection.
 
 palmas-usb {
        compatible = "ti,twl6035-usb", "ti,palmas-usb";
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 5440f7c..5c218d2 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -122,11 +122,14 @@ static void palmas_enable_irq(struct palmas_usb *palmas_usb)
 		PALMAS_USB_ID_INT_EN_HI_SET_ID_GND |
 		PALMAS_USB_ID_INT_EN_HI_SET_ID_FLOAT);
 
-	palmas_vbus_irq_handler(palmas_usb->vbus_irq, palmas_usb);
+	if (palmas_usb->enable_vbus_detection)
+		palmas_vbus_irq_handler(palmas_usb->vbus_irq, palmas_usb);
 
 	/* cold plug for host mode needs this delay */
-	msleep(30);
-	palmas_id_irq_handler(palmas_usb->id_irq, palmas_usb);
+	if (palmas_usb->enable_id_detection) {
+		msleep(30);
+		palmas_id_irq_handler(palmas_usb->id_irq, palmas_usb);
+	}
 }
 
 static int palmas_usb_probe(struct platform_device *pdev)
@@ -137,20 +140,26 @@ static int palmas_usb_probe(struct platform_device *pdev)
 	struct palmas_usb *palmas_usb;
 	int status;
 
-	if (node && !pdata) {
-		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-
-		if (!pdata)
-			return -ENOMEM;
+	palmas_usb = devm_kzalloc(&pdev->dev, sizeof(*palmas_usb), GFP_KERNEL);
+	if (!palmas_usb)
+		return -ENOMEM;
 
-		pdata->wakeup = of_property_read_bool(node, "ti,wakeup");
+	if (node && !pdata) {
+		palmas_usb->wakeup = of_property_read_bool(node, "ti,wakeup");
+		palmas_usb->enable_id_detection = of_property_read_bool(node,
+						"ti,enable-id-detection");
+		palmas_usb->enable_vbus_detection = of_property_read_bool(node,
+						"ti,enable-vbus-detection");
+	} else if (pdata) {
+		palmas_usb->wakeup = pdata->wakeup;
+		palmas_usb->enable_id_detection = true;
+		palmas_usb->enable_vbus_detection = true;
 	} else if (!pdata) {
-		return -EINVAL;
+		palmas_usb->wakeup = true;
+		palmas_usb->enable_id_detection = true;
+		palmas_usb->enable_vbus_detection = true;
 	}
 
-	palmas_usb = devm_kzalloc(&pdev->dev, sizeof(*palmas_usb), GFP_KERNEL);
-	if (!palmas_usb)
-		return -ENOMEM;
 
 	palmas->usb = palmas_usb;
 	palmas_usb->palmas = palmas;
@@ -166,7 +175,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
 	palmas_usb->vbus_irq = regmap_irq_get_virq(palmas->irq_data,
 						PALMAS_VBUS_IRQ);
 
-	palmas_usb_wakeup(palmas, pdata->wakeup);
+	palmas_usb_wakeup(palmas, palmas_usb->wakeup);
 
 	platform_set_drvdata(pdev, palmas_usb);
 
@@ -180,26 +189,32 @@ static int palmas_usb_probe(struct platform_device *pdev)
 		return status;
 	}
 
-	status = devm_request_threaded_irq(palmas_usb->dev, palmas_usb->id_irq,
-			NULL, palmas_id_irq_handler,
-			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
-			IRQF_ONESHOT | IRQF_EARLY_RESUME,
-			"palmas_usb_id", palmas_usb);
-	if (status < 0) {
-		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
+	if (palmas_usb->enable_id_detection) {
+		status = devm_request_threaded_irq(palmas_usb->dev,
+				palmas_usb->id_irq,
+				NULL, palmas_id_irq_handler,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
+				IRQF_ONESHOT | IRQF_EARLY_RESUME,
+				"palmas_usb_id", palmas_usb);
+		if (status < 0) {
+			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 					palmas_usb->id_irq, status);
-		goto fail_extcon;
+			goto fail_extcon;
+		}
 	}
 
-	status = devm_request_threaded_irq(palmas_usb->dev,
-			palmas_usb->vbus_irq, NULL, palmas_vbus_irq_handler,
-			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
-			IRQF_ONESHOT | IRQF_EARLY_RESUME,
-			"palmas_usb_vbus", palmas_usb);
-	if (status < 0) {
-		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
+	if (palmas_usb->enable_vbus_detection) {
+		status = devm_request_threaded_irq(palmas_usb->dev,
+				palmas_usb->vbus_irq, NULL,
+				palmas_vbus_irq_handler,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
+				IRQF_ONESHOT | IRQF_EARLY_RESUME,
+				"palmas_usb_vbus", palmas_usb);
+		if (status < 0) {
+			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 					palmas_usb->vbus_irq, status);
-		goto fail_extcon;
+			goto fail_extcon;
+		}
 	}
 
 	palmas_enable_irq(palmas_usb);
@@ -227,8 +242,10 @@ static int palmas_usb_suspend(struct device *dev)
 	struct palmas_usb *palmas_usb = dev_get_drvdata(dev);
 
 	if (device_may_wakeup(dev)) {
-		enable_irq_wake(palmas_usb->vbus_irq);
-		enable_irq_wake(palmas_usb->id_irq);
+		if (palmas_usb->enable_vbus_detection)
+			enable_irq_wake(palmas_usb->vbus_irq);
+		if (palmas_usb->enable_id_detection)
+			enable_irq_wake(palmas_usb->id_irq);
 	}
 	return 0;
 }
@@ -238,8 +255,10 @@ static int palmas_usb_resume(struct device *dev)
 	struct palmas_usb *palmas_usb = dev_get_drvdata(dev);
 
 	if (device_may_wakeup(dev)) {
-		disable_irq_wake(palmas_usb->vbus_irq);
-		disable_irq_wake(palmas_usb->id_irq);
+		if (palmas_usb->enable_vbus_detection)
+			disable_irq_wake(palmas_usb->vbus_irq);
+		if (palmas_usb->enable_id_detection)
+			disable_irq_wake(palmas_usb->id_irq);
 	}
 	return 0;
 };
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 03c22ca..cfc678c 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -377,6 +377,9 @@ struct palmas_usb {
 	int vbus_irq;
 
 	enum palmas_usb_state linkstat;
+	int wakeup;
+	bool enable_vbus_detection;
+	bool enable_id_detection;
 };
 
 #define comparator_to_palmas(x) container_of((x), struct palmas_usb, comparator)
-- 
1.7.1.1

