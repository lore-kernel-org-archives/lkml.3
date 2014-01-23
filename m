Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaAWMnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:43:47 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43289 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaAWMnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:43:43 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: devicetree@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3 RESEND] input: tc3589x-keypad: support probing from device tree
Date: Thu, 23 Jan 2014 13:43:36 +0100
Message-Id: <1390481016-23938-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement device tree probing for the tc3589x keypad driver.
This is modeled on the STMPE keypad driver and tested on the
Ux500 TVK1281618 UIB.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Use two local u32 variables to avoid weirdness in u8 casting
  of the resulting values to the pointers.
ChangeLog v1->v2:
- Fix rows/columns binding to read two u32's insead of two
  u8 /bits/ as noted by Mark Rutland.
---
 drivers/input/keyboard/tc3589x-keypad.c | 66 ++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
index 208de7cbb7fa..7f36e7addb86 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -297,6 +297,65 @@ static void tc3589x_keypad_close(struct input_dev *input)
 	tc3589x_keypad_disable(keypad);
 }
 
+#ifdef CONFIG_OF
+static const struct tc3589x_keypad_platform_data *
+tc3589x_keypad_of_probe(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct tc3589x_keypad_platform_data *plat;
+	u32 cols, rows;
+	u32 debounce_ms;
+	int proplen;
+
+	if (!np)
+		return ERR_PTR(-ENODEV);
+
+	plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
+	if (!plat)
+		return ERR_PTR(-ENOMEM);
+
+	of_property_read_u32(np, "keypad,num-columns", &cols);
+	of_property_read_u32(np, "keypad,num-rows", &rows);
+	plat->kcol = (u8) cols;
+	plat->krow = (u8) rows;
+	if (!plat->krow || !plat->kcol ||
+	     plat->krow > TC_KPD_ROWS || plat->kcol > TC_KPD_COLUMNS) {
+		dev_err(dev,
+			"keypad columns/rows not properly specified (%ux%u)\n",
+			plat->kcol, plat->krow);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!of_get_property(np, "linux,keymap", &proplen)) {
+		dev_err(dev, "property linux,keymap not found\n");
+		return ERR_PTR(-ENOENT);
+	}
+
+	plat->no_autorepeat = of_property_read_bool(np, "linux,no-autorepeat");
+	plat->enable_wakeup = of_property_read_bool(np, "linux,wakeup");
+
+	/* The custom delay format is ms/16 */
+	of_property_read_u32(np, "debounce-delay-ms", &debounce_ms);
+	if (debounce_ms)
+		plat->debounce_period = debounce_ms * 16;
+	else
+		plat->debounce_period = TC_KPD_DEBOUNCE_PERIOD;
+
+	plat->settle_time = TC_KPD_SETTLE_TIME;
+	/* FIXME: should be property of the IRQ resource? */
+	plat->irqtype = IRQF_TRIGGER_FALLING;
+
+	return plat;
+}
+#else
+static inline const struct tc3589x_keypad_platform_data *
+tc3589x_keypad_of_probe(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif
+
+
 static int tc3589x_keypad_probe(struct platform_device *pdev)
 {
 	struct tc3589x *tc3589x = dev_get_drvdata(pdev->dev.parent);
@@ -307,8 +366,11 @@ static int tc3589x_keypad_probe(struct platform_device *pdev)
 
 	plat = tc3589x->pdata->keypad;
 	if (!plat) {
-		dev_err(&pdev->dev, "invalid keypad platform data\n");
-		return -EINVAL;
+		plat = tc3589x_keypad_of_probe(&pdev->dev);
+		if (IS_ERR(plat)) {
+			dev_err(&pdev->dev, "invalid keypad platform data\n");
+			return PTR_ERR(plat);
+		}
 	}
 
 	irq = platform_get_irq(pdev, 0);
-- 
1.8.4.2

