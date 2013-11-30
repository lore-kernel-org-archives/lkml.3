Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3K3Qxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 11:53:50 -0500
Received: from ring0.de ([91.143.88.219]:36217 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab3K3Qxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 11:53:43 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCHv4 1/2] Input: twl4030-keypad - add device tree support
Date: Sat, 30 Nov 2013 17:53:35 +0100
Message-Id: <1385830416-12900-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385830416-12900-1-git-send-email-sre@debian.org>
References: <1383948866-32672-1-git-send-email-sre@debian.org>
 <1385830416-12900-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for twl4030 keypad driver.

Tested on Nokia N900.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/input/keyboard/twl4030_keypad.c | 65 ++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/input/keyboard/twl4030_keypad.c b/drivers/input/keyboard/twl4030_keypad.c
index d2d178c..5d0cffb 100644
--- a/drivers/input/keyboard/twl4030_keypad.c
+++ b/drivers/input/keyboard/twl4030_keypad.c
@@ -33,6 +33,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c/twl.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 /*
  * The TWL4030 family chips include a keypad controller that supports
@@ -60,6 +61,7 @@
 struct twl4030_keypad {
 	unsigned short	keymap[TWL4030_KEYMAP_SIZE];
 	u16		kp_state[TWL4030_MAX_ROWS];
+	bool		autorepeat;
 	unsigned	n_rows;
 	unsigned	n_cols;
 	unsigned	irq;
@@ -331,20 +333,12 @@ static int twl4030_kp_program(struct twl4030_keypad *kp)
 static int twl4030_kp_probe(struct platform_device *pdev)
 {
 	struct twl4030_keypad_data *pdata = pdev->dev.platform_data;
-	const struct matrix_keymap_data *keymap_data;
+	const struct matrix_keymap_data *keymap_data = NULL;
 	struct twl4030_keypad *kp;
 	struct input_dev *input;
 	u8 reg;
 	int error;
 
-	if (!pdata || !pdata->rows || !pdata->cols || !pdata->keymap_data ||
-	    pdata->rows > TWL4030_MAX_ROWS || pdata->cols > TWL4030_MAX_COLS) {
-		dev_err(&pdev->dev, "Invalid platform_data\n");
-		return -EINVAL;
-	}
-
-	keymap_data = pdata->keymap_data;
-
 	kp = kzalloc(sizeof(*kp), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!kp || !input) {
@@ -352,13 +346,9 @@ static int twl4030_kp_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	/* Get the debug Device */
-	kp->dbg_dev = &pdev->dev;
-	kp->input = input;
-
-	kp->n_rows = pdata->rows;
-	kp->n_cols = pdata->cols;
-	kp->irq = platform_get_irq(pdev, 0);
+	/* get the debug device */
+	kp->dbg_dev		= &pdev->dev;
+	kp->input		= input;
 
 	/* setup input device */
 	input->name		= "TWL4030 Keypad";
@@ -370,6 +360,38 @@ static int twl4030_kp_probe(struct platform_device *pdev)
 	input->id.product	= 0x0001;
 	input->id.version	= 0x0003;
 
+	if (pdata) {
+		if (!pdata->rows || !pdata->cols || !pdata->keymap_data) {
+			dev_err(&pdev->dev, "Missing platform_data\n");
+			error = -EINVAL;
+			goto err1;
+		}
+
+		kp->n_rows = pdata->rows;
+		kp->n_cols = pdata->cols;
+		kp->autorepeat = pdata->rep;
+		keymap_data = pdata->keymap_data;
+	} else {
+		error = matrix_keypad_parse_of_params(&pdev->dev, &kp->n_rows,
+						      &kp->n_cols);
+		kp->autorepeat = true;
+		if (error)
+			goto err1;
+	}
+
+	if (kp->n_rows > TWL4030_MAX_ROWS || kp->n_cols > TWL4030_MAX_COLS) {
+		dev_err(&pdev->dev, "Invalid rows/cols amount specified in platform/devicetree data\n");
+		error = -EINVAL;
+		goto err1;
+	}
+
+	kp->irq = platform_get_irq(pdev, 0);
+	if (!kp->irq) {
+		dev_err(&pdev->dev, "no keyboard irq assigned\n");
+		error = -EINVAL;
+		goto err1;
+	}
+
 	error = matrix_keypad_build_keymap(keymap_data, NULL,
 					   TWL4030_MAX_ROWS,
 					   1 << TWL4030_ROW_SHIFT,
@@ -381,7 +403,7 @@ static int twl4030_kp_probe(struct platform_device *pdev)
 
 	input_set_capability(input, EV_MSC, MSC_SCAN);
 	/* Enable auto repeat feature of Linux input subsystem */
-	if (pdata->rep)
+	if (kp->autorepeat)
 		__set_bit(EV_REP, input->evbit);
 
 	error = input_register_device(input);
@@ -443,6 +465,14 @@ static int twl4030_kp_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id twl4030_keypad_dt_match_table[] = {
+	{ .compatible = "ti,twl4030-keypad" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, twl4030_keypad_dt_match_table);
+#endif
+
 /*
  * NOTE: twl4030 are multi-function devices connected via I2C.
  * So this device is a child of an I2C parent, thus it needs to
@@ -455,6 +485,7 @@ static struct platform_driver twl4030_kp_driver = {
 	.driver		= {
 		.name	= "twl4030_keypad",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(twl4030_keypad_dt_match_table),
 	},
 };
 module_platform_driver(twl4030_kp_driver);
-- 
1.8.4.3

