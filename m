Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3GJGH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:07:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19242 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3GJGHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:07:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 09 Jul 2013 23:07:09 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <rob@landley.net>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 4/4] extcon: palmas: Option to disable ID/VBUS detection based on platform
Date: Wed, 10 Jul 2013 11:45:59 +0530
Message-ID: <1373436959-32444-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com>
References: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com>
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

 .../devicetree/bindings/extcon/extcon-palmas.txt   |    2 +
 drivers/extcon/extcon-palmas.c                     |   65 +++++++++++++-------
 include/linux/mfd/palmas.h                         |    4 +
 3 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
index f110e75..8e593ec 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
+++ b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
@@ -6,6 +6,8 @@ Required Properties:
 
 Optional Properties:
  - ti,wakeup : To enable the wakeup comparator in probe
+ - ti,disable-id-detection: Do not perform ID detection.
+ - ti,disable-vbus-detection: Do not pwerform VBUS detection.
 
 palmas-usb {
        compatible = "ti,twl6035-usb", "ti,palmas-usb";
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index dc7ebf3..4747d11 100644
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
@@ -144,6 +147,10 @@ static int palmas_usb_probe(struct platform_device *pdev)
 			return -ENOMEM;
 
 		pdata->wakeup = of_property_read_bool(node, "ti,wakeup");
+		pdata->disable_id_detection = of_property_read_bool(node,
+						"ti,disable-id-detection");
+		pdata->disable_vbus_detection = of_property_read_bool(node,
+						"ti,disable-vbus-detection");
 	} else if (!pdata) {
 		return -EINVAL;
 	}
@@ -154,6 +161,8 @@ static int palmas_usb_probe(struct platform_device *pdev)
 
 	palmas->usb = palmas_usb;
 	palmas_usb->palmas = palmas;
+	palmas_usb->enable_vbus_detection = !pdata->disable_vbus_detection;
+	palmas_usb->enable_id_detection =  !pdata->disable_id_detection;
 
 	palmas_usb->dev	 = &pdev->dev;
 
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
index 03c22ca..d9ef94c 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -204,6 +204,8 @@ struct palmas_pmic_platform_data {
 struct palmas_usb_platform_data {
 	/* Do we enable the wakeup comparator on probe */
 	int wakeup;
+	bool disable_vbus_detection;
+	bool disable_id_detection;
 };
 
 struct palmas_resource_platform_data {
@@ -377,6 +379,8 @@ struct palmas_usb {
 	int vbus_irq;
 
 	enum palmas_usb_state linkstat;
+	bool enable_vbus_detection;
+	bool enable_id_detection;
 };
 
 #define comparator_to_palmas(x) container_of((x), struct palmas_usb, comparator)
-- 
1.7.1.1

