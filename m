Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3GIM5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:57:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8131 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab3GIM5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:57:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 09 Jul 2013 05:56:18 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <rob@landley.net>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] extcon: palams: add support for suspend/resume
Date: Tue, 9 Jul 2013 18:34:23 +0530
Message-ID: <1373375064-12012-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1373375064-12012-1-git-send-email-ldewangan@nvidia.com>
References: <1373375064-12012-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend/resume callbacks and support for wakeup from
suspend on USB HOST or USB Device cable insertion or removal.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/extcon/extcon-palmas.c |   38 +++++++++++++++++++++++++++++++++++---
 1 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 587034b..b2d64d4 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -182,7 +182,8 @@ static int palmas_usb_probe(struct platform_device *pdev)
 
 	status = devm_request_threaded_irq(palmas_usb->dev, palmas_usb->id_irq,
 			NULL, palmas_id_irq_handler,
-			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
+			IRQF_ONESHOT | IRQF_EARLY_RESUME,
 			"palmas_usb_id", palmas_usb);
 	if (status < 0) {
 		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
@@ -192,7 +193,8 @@ static int palmas_usb_probe(struct platform_device *pdev)
 
 	status = devm_request_threaded_irq(palmas_usb->dev,
 			palmas_usb->vbus_irq, NULL, palmas_vbus_irq_handler,
-			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
+			IRQF_ONESHOT | IRQF_EARLY_RESUME,
 			"palmas_usb_vbus", palmas_usb);
 	if (status < 0) {
 		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
@@ -201,7 +203,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
 	}
 
 	palmas_enable_irq(palmas_usb);
-
+	device_set_wakeup_capable(&pdev->dev, true);
 	return 0;
 
 fail_extcon:
@@ -219,6 +221,35 @@ static int palmas_usb_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int palmas_usb_suspend(struct device *dev)
+{
+	struct palmas_usb *palmas_usb = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev)) {
+		enable_irq_wake(palmas_usb->vbus_irq);
+		enable_irq_wake(palmas_usb->id_irq);
+	}
+	return 0;
+}
+
+static int palmas_usb_resume(struct device *dev)
+{
+	struct palmas_usb *palmas_usb = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev)) {
+		disable_irq_wake(palmas_usb->vbus_irq);
+		disable_irq_wake(palmas_usb->id_irq);
+	}
+	return 0;
+};
+#endif
+
+static const struct dev_pm_ops palmas_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(palmas_usb_suspend,
+				palmas_usb_resume)
+};
+
 static struct of_device_id of_palmas_match_tbl[] = {
 	{ .compatible = "ti,palmas-usb", },
 	{ .compatible = "ti,twl6035-usb", },
@@ -232,6 +263,7 @@ static struct platform_driver palmas_usb_driver = {
 		.name = "palmas-usb",
 		.of_match_table = of_palmas_match_tbl,
 		.owner = THIS_MODULE,
+		.pm = &palmas_pm_ops,
 	},
 };
 
-- 
1.7.1.1

