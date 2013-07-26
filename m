Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab3GZQb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:31:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38459 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757958Ab3GZQaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:30:06 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 1/3] Input: omap-keypad: Enable wakeup capability for keypad.
Date: Fri, 26 Jul 2013 19:29:59 +0300
Message-ID: <1374856201-11507-2-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374856201-11507-1-git-send-email-illia.smyrnov@ti.com>
References: <1374856201-11507-1-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable/disable IRQ wake in suspend/resume handlers
to make the keypad wakeup capable.

Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
 drivers/input/keyboard/omap4-keypad.c |   38 +++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index 0244262..5f0a2c7 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -74,6 +74,7 @@ struct omap4_keypad {
 	struct input_dev *input;
 
 	void __iomem *base;
+	bool irq_wake_enabled;
 	unsigned int irq;
 
 	unsigned int rows;
@@ -380,6 +381,7 @@ static int omap4_keypad_probe(struct platform_device *pdev)
 		goto err_free_input;
 	}
 
+	device_init_wakeup(&pdev->dev, true);
 	pm_runtime_put_sync(&pdev->dev);
 
 	error = input_register_device(keypad_data->input);
@@ -393,6 +395,7 @@ static int omap4_keypad_probe(struct platform_device *pdev)
 
 err_pm_disable:
 	pm_runtime_disable(&pdev->dev);
+	device_init_wakeup(&pdev->dev, false);
 	free_irq(keypad_data->irq, keypad_data);
 err_free_keymap:
 	kfree(keypad_data->keymap);
@@ -418,6 +421,8 @@ static int omap4_keypad_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	device_init_wakeup(&pdev->dev, false);
+
 	input_unregister_device(keypad_data->input);
 
 	iounmap(keypad_data->base);
@@ -439,12 +444,45 @@ static const struct of_device_id omap_keypad_dt_match[] = {
 MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
 #endif
 
+#ifdef CONFIG_PM_SLEEP
+static int omap4_keypad_suspend(struct device *dev)
+{
+	int error;
+
+	if (device_may_wakeup(&pdev->dev)) {
+		error = enable_irq_wake(keypad_data->irq);
+		if (!error)
+			keypad_data->irq_wake_enabled = true;
+	}
+
+	return 0;
+}
+
+static int omap4_keypad_resume(struct device *dev)
+{
+	if (device_may_wakeup(&pdev->dev) && keypad_data->irq_wake_enabled) {
+		disable_irq_wake(keypad_data->irq);
+		keypad_data->irq_wake_enabled = false;
+	}
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(omap4_keypad_pm_ops, omap4_keypad_suspend,
+				omap4_keypad_resume);
+
+#define OMAP4_KEYPAD_PM_OPS (&omap4_keypad_pm_ops)
+#else
+#define OMAP4_KEYPAD_PM_OPS NULL
+#endif
+
 static struct platform_driver omap4_keypad_driver = {
 	.probe		= omap4_keypad_probe,
 	.remove		= omap4_keypad_remove,
 	.driver		= {
 		.name	= "omap4-keypad",
 		.owner	= THIS_MODULE,
+		.pm	= OMAP4_KEYPAD_PM_OPS,
 		.of_match_table = of_match_ptr(omap_keypad_dt_match),
 	},
 };
-- 
1.7.9.5

