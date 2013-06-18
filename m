Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3FRD7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:59:33 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:43544 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab3FRD7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:59:31 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <dmitry.torokhov@gmail.com>, <arnd@arndb.de>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <drwyrm@gmail.com>, <stefan@openezx.org>,
        <laforge@openezx.org>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <sleep_walker@suse.cz>, <slapin@ossfans.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V3 5/5] input: pxa27x-keypad: add device tree support
Date: Mon, 17 Jun 2013 23:56:18 -0400
Message-ID: <1371527778-5236-6-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
References: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 .../devicetree/bindings/input/pxa27x-keypad.txt    |   60 +++++
 drivers/input/keyboard/pxa27x_keypad.c             |  232 +++++++++++++++++++-
 2 files changed, 288 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/pxa27x-keypad.txt

diff --git a/Documentation/devicetree/bindings/input/pxa27x-keypad.txt b/Documentation/devicetree/bindings/input/pxa27x-keypad.txt
new file mode 100644
index 0000000..f8674f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/pxa27x-keypad.txt
@@ -0,0 +1,60 @@
+* Marvell PXA Keypad controller
+
+Required Properties
+- compatible : should be "marvell,pxa27x-keypad"
+- reg : Address and length of the register set for the device
+- interrupts : The interrupt for the keypad controller
+- marvell,debounce-interval : How long time the key will be
+  recognized when it is pressed. It is a u32 value, and bit[31:16]
+  is debounce interval for direct key and bit[15:0] is debounce
+  interval for matrix key. The value is in binary number of 2ms
+
+Optional Properties For Matrix Keyes
+Please refer to matrix-keymap.txt
+
+Optional Properties for Direct Keyes
+- marvell,direct-key-count : How many direct keyes are used.
+- marvell,direct-key-mask : The mask indicates which keyes
+  are used. If bit[X] of the mask is set, the direct key X
+  is used.
+- marvell,direct-key-low-active : Direct key status register
+  tells the level of pins that connects to the direct keyes.
+  When this property is set, it means that when the pin level
+  is low, the key is pressed(active).
+- marvell,direct-key-map : It is a u16 array. Each item indicates
+  the linux key-code for the direct key.
+
+Optional Properties For Rotary
+- marvell,rotary0 : It is a u32 value. Bit[31:16] is the
+  linux key-code for rotary up. Bit[15:0] is the linux key-code
+  for rotary down. It is for rotary 0.
+- marvell,rotary1 : Same as marvell,rotary0. It is for rotary 1.
+- marvell,rotary-rel-key : When rotary is used for relative axes
+  in the device, the value indicates the key-code for relative
+  axes measurement in the device. It is a u32 value. Bit[31:16]
+  is for rotary 1, and Bit[15:0] is for rotary 0.
+
+Examples:
+	keypad: keypad@d4012000 {
+		keypad,num-rows = <3>;
+		keypad,num-columns = <5>;
+		linux,keymap = <0x0000000e	/* KEY_BACKSPACE */
+				0x0001006b	/* KEY_END */
+				0x00020061	/* KEY_RIGHTCTRL */
+				0x0003000b	/* KEY_0 */
+				0x00040002	/* KEY_1 */
+				0x0100008b	/* KEY_MENU */
+				0x01010066	/* KEY_HOME */
+				0x010200e7	/* KEY_SEND */
+				0x01030009	/* KEY_8 */
+				0x0104000a	/* KEY_9 */
+				0x02000160	/* KEY_OK */
+				0x02010003	/* KEY_2 */
+				0x02020004	/* KEY_3 */
+				0x02030005	/* KEY_4 */
+				0x02040006>;	/* KEY_5 */
+		marvell,rotary0 = <0x006c0067>;	/* KEY_UP & KEY_DOWN */
+		marvell,direct-key-count = <1>;
+		marvell,direct-key-map = <0x001c>;
+		marvell,debounce-interval = <0x001e001e>;
+	};
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 947d657..16cf9a5 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -118,6 +118,217 @@ struct pxa27x_keypad {
 	unsigned int direct_key_mask;
 };
 
+static int pxa27x_keypad_matrix_key_parse_dt(struct pxa27x_keypad *keypad)
+{
+	int ret;
+	u32 rows, cols;
+	struct input_dev *input_dev = keypad->input_dev;
+	struct device *dev = input_dev->dev.parent;
+	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
+
+	ret = matrix_keypad_parse_of_params(dev, &rows, &cols);
+	if (ret)
+		return ret;
+
+	if (rows > MAX_MATRIX_KEY_ROWS || cols > MAX_MATRIX_KEY_COLS) {
+		dev_err(dev, "rows or cols exceeds maximum value\n");
+		return -EINVAL;
+	}
+
+	pdata->matrix_key_rows = rows;
+	pdata->matrix_key_cols = cols;
+
+	ret = matrix_keypad_build_keymap(NULL, NULL,
+					 pdata->matrix_key_rows,
+					 pdata->matrix_key_cols,
+					 keypad->keycodes, input_dev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int pxa27x_keypad_direct_key_parse_dt(struct pxa27x_keypad *keypad)
+{
+	const __be16 *prop;
+	unsigned short code;
+	int i, ret;
+	unsigned int proplen, size;
+	struct input_dev *input_dev = keypad->input_dev;
+	struct device *dev = input_dev->dev.parent;
+	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
+	struct device_node *np = dev->of_node;
+
+	ret = of_property_read_u32(np, "marvell,direct-key-count",
+				   &pdata->direct_key_num);
+	if (ret) {
+		/*
+		 * If do not have marvel,direct-key-count defined,
+		 * it means direct key is not supported.
+		 */
+		if (ret == -EINVAL)
+			return 0;
+		return ret;
+	}
+	ret = of_property_read_u32(np, "marvell,direct-key-mask",
+				   &pdata->direct_key_mask);
+	if (ret && ret != -EINVAL)
+		return ret;
+	/*
+	 * If marvell,direct-key-mask is not defined, driver will use
+	 * default value. Default value is set when configure the keypad.
+	 */
+	else if (ret == -EINVAL)
+		pdata->direct_key_mask = 0;
+
+	pdata->direct_key_low_active = of_property_read_bool(np,
+					"marvell,direct-key-low-active");
+
+	prop = of_get_property(np, "marvell,direct-key-map", &proplen);
+	if (!prop)
+		return -EINVAL;
+
+	if (proplen % sizeof(u16))
+		return -EINVAL;
+
+	size = proplen / sizeof(u16);
+
+	/* Only MAX_DIRECT_KEY_NUM is accepted.*/
+	if (size > MAX_DIRECT_KEY_NUM)
+		return -EINVAL;
+
+	for (i = 0; i < size; i++) {
+		code = be16_to_cpup(prop + i);
+		keypad->keycodes[MAX_MATRIX_KEY_NUM + i] = code;
+		__set_bit(code, input_dev->keybit);
+	}
+
+	return 0;
+}
+
+static int pxa27x_keypad_rotary_parse_dt(struct pxa27x_keypad *keypad)
+{
+	const __be32 *prop;
+	int i, relkey_ret;
+	unsigned int code, proplen;
+	const char *rotaryname[2] = {
+			"marvell,rotary0", "marvell,rotary1"};
+	const char relkeyname[] = {"marvell,rotary-rel-key"};
+	struct input_dev *input_dev = keypad->input_dev;
+	struct device *dev = input_dev->dev.parent;
+	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
+	struct device_node *np = dev->of_node;
+
+	relkey_ret = of_property_read_u32(np, relkeyname, &code);
+	/* if can read correct rotary key-code, we do not need this. */
+	if (relkey_ret == 0) {
+		unsigned short relcode;
+
+		/* rotary0 taks lower half, rotary1 taks upper half. */
+		relcode = code & 0xffff;
+		pdata->rotary0_rel_code = (code & 0xffff);
+		__set_bit(relcode, input_dev->relbit);
+
+		relcode = code >> 16;
+		pdata->rotary1_rel_code = relcode;
+		__set_bit(relcode, input_dev->relbit);
+	}
+
+	for (i = 0; i < 2; i++) {
+		prop = of_get_property(np, rotaryname[i], &proplen);
+		/*
+		 * If the prop is not set, it means keypad does not need
+		 * initialize the rotaryX.
+		 */
+		if (!prop)
+			continue;
+
+		code = be32_to_cpup(prop);
+		/*
+		 * Not all up/down key code are valid.
+		 * Now we depends on direct-rel-code.
+		 */
+		if ((!(code & 0xffff) || !(code >> 16)) && relkey_ret) {
+			return relkey_ret;
+		} else {
+			unsigned int n = MAX_MATRIX_KEY_NUM + (i << 1);
+			unsigned short keycode;
+
+			keycode = code & 0xffff;
+			keypad->keycodes[n] = keycode;
+			__set_bit(keycode, input_dev->keybit);
+
+			keycode = code >> 16;
+			keypad->keycodes[n + 1] = keycode;
+			__set_bit(keycode, input_dev->keybit);
+
+			if (i == 0)
+				pdata->rotary0_rel_code = -1;
+			else
+				pdata->rotary1_rel_code = -1;
+		}
+		if (i == 0)
+			pdata->enable_rotary0 = 1;
+		else
+			pdata->enable_rotary1 = 1;
+	}
+
+	keypad->rotary_rel_code[0] = pdata->rotary0_rel_code;
+	keypad->rotary_rel_code[1] = pdata->rotary1_rel_code;
+
+	return 0;
+}
+
+static int pxa27x_keypad_build_keycode_from_dt(struct pxa27x_keypad *keypad)
+{
+	int ret;
+	struct input_dev *input_dev = keypad->input_dev;
+	struct device *dev = input_dev->dev.parent;
+	struct device_node *np = dev->of_node;
+
+	if (!keypad->pdata) {
+		keypad->pdata = devm_kzalloc(dev, sizeof(*keypad->pdata),
+					     GFP_KERNEL);
+		if (!keypad->pdata) {
+			dev_err(dev, "failed to allocate memory for pdata\n");
+			return -ENOMEM;
+		}
+	}
+
+	ret = pxa27x_keypad_matrix_key_parse_dt(keypad);
+	if (ret) {
+		dev_err(dev, "failed to parse matrix key\n");
+		return ret;
+	}
+
+	ret = pxa27x_keypad_direct_key_parse_dt(keypad);
+	if (ret) {
+		dev_err(dev, "failed to parse direct key\n");
+		return ret;
+	}
+
+	ret = pxa27x_keypad_rotary_parse_dt(keypad);
+	if (ret) {
+		dev_err(dev, "failed to parse rotary key\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(np, "marvell,debounce-interval",
+				   &keypad->pdata->debounce_interval);
+	if (ret) {
+		dev_err(dev, "failed to parse debpunce-interval\n");
+		return ret;
+	}
+
+	/*
+	 * The keycodes may not only includes matrix key but also the direct
+	 * key or rotary key.
+	 */
+	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
+
+	return 0;
+}
+
 static int pxa27x_keypad_build_keycode(struct pxa27x_keypad *keypad)
 {
 	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
@@ -491,15 +702,15 @@ static const struct dev_pm_ops pxa27x_keypad_pm_ops = {
 static int pxa27x_keypad_probe(struct platform_device *pdev)
 {
 	struct pxa27x_keypad_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	struct pxa27x_keypad *keypad;
 	struct input_dev *input_dev;
 	struct resource *res;
 	int irq, error;
 
-	if (pdata == NULL) {
-		dev_err(&pdev->dev, "no platform data defined\n");
+	/* Driver need build keycode from device tree or pdata */
+	if (!np && !pdata)
 		return -EINVAL;
-	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -561,12 +772,18 @@ static int pxa27x_keypad_probe(struct platform_device *pdev)
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
 
-	error  = pxa27x_keypad_build_keycode(keypad);
+	if (np)
+		error = pxa27x_keypad_build_keycode_from_dt(keypad);
+	else
+		error  = pxa27x_keypad_build_keycode(keypad);
 	if (error) {
 		dev_err(&pdev->dev, "failed to build keycode\n");
 		goto failed_put_clk;
 	}
 
+	/* If device tree is supported, pdata will be allocated. */
+	pdata = keypad->pdata;
+
 	if ((pdata->enable_rotary0 && keypad->rotary_rel_code[0] != -1) ||
 	    (pdata->enable_rotary1 && keypad->rotary_rel_code[1] != -1)) {
 		input_dev->evbit[0] |= BIT_MASK(EV_REL);
@@ -627,11 +844,18 @@ static int pxa27x_keypad_remove(struct platform_device *pdev)
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:pxa27x-keypad");
 
+static const struct of_device_id pxa27x_keypad_dt_match[] = {
+	{ .compatible = "marvell,pxa27x-keypad" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pxa27x_keypad_dt_match);
+
 static struct platform_driver pxa27x_keypad_driver = {
 	.probe		= pxa27x_keypad_probe,
 	.remove		= pxa27x_keypad_remove,
 	.driver		= {
 		.name	= "pxa27x-keypad",
+		.of_match_table = of_match_ptr(pxa27x_keypad_dt_match),
 		.owner	= THIS_MODULE,
 #ifdef CONFIG_PM
 		.pm	= &pxa27x_keypad_pm_ops,
-- 
1.7.4.1

