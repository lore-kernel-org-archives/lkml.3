Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3JVMsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:48:05 -0400
Received: from ring0.de ([91.143.88.219]:35987 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab3JVMrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:47:36 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, linux-input@vger.kernel.org
Cc: =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv2 1/3] Input: twl4030-keypad - add device tree support
Date: Tue, 22 Oct 2013 14:47:20 +0200
Message-Id: <1382446042-27099-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382446042-27099-1-git-send-email-sre@debian.org>
References: <1382446042-27099-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for twl4030 keypad driver and update the
Documentation with twl4030 keypad device tree binding information.

Tested on Nokia N900.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/input/twl4030-keypad.txt   | 31 ++++++++
 drivers/input/keyboard/twl4030_keypad.c            | 91 ++++++++++++++++++----
 2 files changed, 105 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-keypad.txt

diff --git a/Documentation/devicetree/bindings/input/twl4030-keypad.txt b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
new file mode 100644
index 0000000..2b4bd7a
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
@@ -0,0 +1,31 @@
+* TWL4030's Keypad Controller device tree bindings
+
+TWL4030's Keypad controller is used to interface a SoC with a matrix-type
+keypad device. The keypad controller supports multiple row and column lines.
+A key can be placed at each intersection of a unique row and a unique column.
+The keypad controller can sense a key-press and key-release and report the
+event using a interrupt to the cpu.
+
+This binding is based on the matrix-keymap binding with the following
+changes:
+
+ * keypad,num-rows and keypad,num-columns are required.
+
+Required SoC Specific Properties:
+- compatible: should be one of the following
+   - "ti,twl4030-keypad": For controllers compatible with twl4030 keypad
+      controller.
+- interrupt: should be one of the following
+   - <1>: For controllers compatible with twl4030 keypad controller.
+
+Optional Properties specific to linux:
+- linux,keypad-no-autorepeat: do no enable autorepeat feature.
+
+Example:
+	twl_keypad: keypad {
+		compatible = "ti,twl4030-keypad";
+		interrupts = <1>;
+		keypad,num-rows = <8>;
+		keypad,num-columns = <8>;
+		linux,keypad-no-autorepeat;
+	};
diff --git a/drivers/input/keyboard/twl4030_keypad.c b/drivers/input/keyboard/twl4030_keypad.c
index d2d178c..034c312 100644
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
+	bool		no_autorepeat;
 	unsigned	n_rows;
 	unsigned	n_cols;
 	unsigned	irq;
@@ -324,6 +326,31 @@ static int twl4030_kp_program(struct twl4030_keypad *kp)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_OF)
+static int twl4030_keypad_parse_dt(struct device *dev,
+				 struct twl4030_keypad *keypad_data)
+{
+	struct device_node *np = dev->of_node;
+	int err;
+
+	err = matrix_keypad_parse_of_params(dev, &keypad_data->n_rows,
+					    &keypad_data->n_cols);
+	if (err)
+		return err;
+
+	if (of_get_property(np, "linux,input-no-autorepeat", NULL))
+		keypad_data->no_autorepeat = true;
+
+	return 0;
+}
+#else
+static inline int twl4030_keypad_parse_dt(struct device *dev,
+					struct twl4030_keypad *keypad_data)
+{
+	return -ENOSYS;
+}
+#endif
+
 /*
  * Registers keypad device with input subsystem
  * and configures TWL4030 keypad registers
@@ -331,20 +358,12 @@ static int twl4030_kp_program(struct twl4030_keypad *kp)
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
@@ -352,13 +371,9 @@ static int twl4030_kp_probe(struct platform_device *pdev)
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
@@ -370,6 +385,36 @@ static int twl4030_kp_probe(struct platform_device *pdev)
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
+		kp->no_autorepeat = !pdata->rep;
+		keymap_data = pdata->keymap_data;
+	} else {
+		error = twl4030_keypad_parse_dt(&pdev->dev, kp);
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
@@ -381,7 +426,7 @@ static int twl4030_kp_probe(struct platform_device *pdev)
 
 	input_set_capability(input, EV_MSC, MSC_SCAN);
 	/* Enable auto repeat feature of Linux input subsystem */
-	if (pdata->rep)
+	if (!kp->no_autorepeat)
 		__set_bit(EV_REP, input->evbit);
 
 	error = input_register_device(input);
@@ -443,6 +488,17 @@ static int twl4030_kp_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id twl4030_keypad_dt_match_table[] = {
+	{ .compatible = "ti,twl4030-keypad" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, twl4030_keypad_dt_match_table);
+#define twl4030_keypad_dt_match of_match_ptr(twl4030_keypad_dt_match_table)
+#else
+#define twl4030_keypad_dt_match NULL
+#endif
+
 /*
  * NOTE: twl4030 are multi-function devices connected via I2C.
  * So this device is a child of an I2C parent, thus it needs to
@@ -455,6 +511,7 @@ static struct platform_driver twl4030_kp_driver = {
 	.driver		= {
 		.name	= "twl4030_keypad",
 		.owner	= THIS_MODULE,
+		.of_match_table = twl4030_keypad_dt_match,
 	},
 };
 module_platform_driver(twl4030_kp_driver);
-- 
1.8.4.rc3

