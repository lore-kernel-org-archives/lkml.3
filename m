Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbaEGNDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:03:48 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:34414 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932799AbaEGNDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:03:45 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: robh+dt@kernel.org
Cc: devicetree@vger.kernel.org,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [RFC/PATCH 1/3] drivers: input: keyboard: adp5589: add DT support
Date: Wed,  7 May 2014 10:00:42 -0300
Message-Id: <1399467644-27222-2-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1399467644-27222-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1399467644-27222-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT support for the Analog ADP5589 matrix keypad decoding functions.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
---
 drivers/input/keyboard/adp5589-keys.c | 207 +++++++++++++++++++++++++++++++++-
 1 file changed, 206 insertions(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/adp5589-keys.c b/drivers/input/keyboard/adp5589-keys.c
index 6329549..2b232c0 100644
--- a/drivers/input/keyboard/adp5589-keys.c
+++ b/drivers/input/keyboard/adp5589-keys.c
@@ -18,7 +18,10 @@
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/err.h>
 
+#include <linux/input/matrix_keypad.h>
 #include <linux/input/adp5589.h>
 
 /* ADP5589/ADP5585 Common Registers */
@@ -246,6 +249,14 @@ struct adp5589_kpad {
 #endif
 };
 
+static struct of_device_id adp5589_of_match[] = {
+	{
+		.compatible = "adi,adp5589",
+		.data = (void *)ADP5589
+	},
+	{ },
+};
+
 /*
  *  ADP5589 / ADP5585 derivative / variant handling
  */
@@ -858,6 +869,188 @@ static void adp5589_report_switch_state(struct adp5589_kpad *kpad)
 	input_sync(kpad->input);
 }
 
+#ifdef CONFIG_OF
+static int adp5589_key(int row, int col)
+{
+	return col + row * 11;
+}
+
+static int adp5589_dt_read_keymap(struct device *dev,
+				  struct adp5589_kpad_platform_data *pdata,
+				  const struct device_node *node)
+{
+	int i;
+	const u32 *dt_keymap;
+	unsigned short *keymap;
+	int keymap_len;
+
+	dt_keymap = of_get_property(node, "linux,keymap", &keymap_len);
+	if (!dt_keymap) {
+		dev_err(dev, "missing dt keymap\n");
+		return -ENODEV;
+	}
+
+	if (keymap_len % sizeof(u32)) {
+		dev_err(dev, "malformed keymap (len=%i)\n", keymap_len);
+		return -EINVAL;
+	}
+
+	keymap_len /= sizeof(u32);
+
+	keymap = devm_kzalloc(dev, ADP5589_KEYMAPSIZE * sizeof(u32),
+			      GFP_KERNEL);
+	if (!keymap)
+		return -ENOMEM;
+
+	for (i = 0; i < keymap_len; i++) {
+		u32 val;
+		u16 key;
+		u8 row, col;
+
+		val = be32_to_cpup(&dt_keymap[i]);
+
+		row = KEY_ROW(val);
+		col = KEY_COL(val);
+		key = KEY_VAL(val);
+
+		if (row > ADP5589_MAX_ROW_NUM) {
+			dev_err(dev, "invalid row number (%i)\n", row);
+			return -EINVAL;
+		}
+
+		if (col > ADP5589_MAX_COL_NUM) {
+			dev_err(dev, "invalid column number (%i)\n", col);
+			return -EINVAL;
+		}
+
+		pdata->keypad_en_mask |= ADP_ROW(row);
+		pdata->keypad_en_mask |= ADP_COL(col);
+
+		keymap[adp5589_key(row, col)] = key;
+	}
+
+	pdata->keymap = keymap;
+	pdata->keymapsize = ADP5589_KEYMAPSIZE;
+
+	return 0;
+}
+
+static int adp5589_dt_read_pulls(struct device *dev,
+				 struct adp5589_kpad_platform_data *pdata,
+				 const struct device_node *node)
+{
+	unsigned i;
+
+	pdata->pull_dis_mask = 0;
+	pdata->pullup_en_300k = 0;
+	pdata->pullup_en_100k = 0;
+	pdata->pulldown_en_300k = 0;
+
+	of_property_read_u32(node, "adp5589,pulldown-300k",
+			&pdata->pulldown_en_300k);
+
+	of_property_read_u32(node, "adp5589,pullup-300k",
+			&pdata->pullup_en_300k);
+
+	of_property_read_u32(node, "adp5589,pullup-100k",
+			&pdata->pullup_en_100k);
+
+	of_property_read_u32(node, "adp5589,pull-disable",
+			&pdata->pull_dis_mask);
+
+	/* Check for misconfiguration */
+	for (i = 1; i != 0; i <<= 1) {
+		int s = 0;
+
+		if (pdata->pulldown_en_300k & i)
+			s++;
+		if (pdata->pullup_en_300k & i)
+			s++;
+		if (pdata->pullup_en_100k & i)
+			s++;
+		if (pdata->pull_dis_mask & i)
+			s++;
+
+		if (s > 1) {
+			dev_err(dev, "misconfigured pull resistors\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int adp5589_ms_to_cycle_time(unsigned t)
+{
+	if (t >= 40)
+		return ADP5589_SCAN_CYCLE_40ms;
+	else if (t >= 30)
+		return ADP5589_SCAN_CYCLE_30ms;
+	else if (t >= 20)
+		return ADP5589_SCAN_CYCLE_20ms;
+	else
+		return ADP5589_SCAN_CYCLE_10ms;
+}
+
+static int adp5589_dt_fill(struct device *dev,
+			   struct adp5589_kpad_platform_data *pdata,
+			   const struct device_node *node)
+{
+	int error;
+	u32 t;
+
+	error = adp5589_dt_read_keymap(dev, pdata, node);
+	if (error)
+		return error;
+
+	error = adp5589_dt_read_pulls(dev, pdata, node);
+	if (error)
+		return error;
+
+	if (!of_property_read_u32(node, "adp5589,scan-cycle-time-ms", &t))
+		pdata->scan_cycle_time = adp5589_ms_to_cycle_time(t);
+
+	pdata->repeat = !of_property_read_bool(node, "linux,no-autorepeat");
+
+	return 0;
+}
+
+static struct adp5589_kpad_platform_data *
+adp5589_get_dt_data(struct device *dev, int *dev_type)
+{
+	struct device_node *node;
+	const struct of_device_id *match;
+	struct adp5589_kpad_platform_data *pdata;
+	int error;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	node = dev->of_node;
+	if (!node) {
+		dev_err(dev, "dt node does not exist\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	error = adp5589_dt_fill(dev, pdata, node);
+	if (error)
+		return ERR_PTR(error);
+
+	*dev_type = (uintptr_t)match->data;
+	dev->platform_data = pdata;
+
+	return pdata;
+}
+#else
+static struct adp5589_kpad_platform_data *
+adp5589_get_dt_data(struct device *dev, int *dev_type)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif
+
 static int adp5589_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -868,6 +1061,7 @@ static int adp5589_probe(struct i2c_client *client,
 	unsigned int revid;
 	int ret, i;
 	int error;
+	int dev_type = 0;
 
 	if (!i2c_check_functionality(client->adapter,
 				     I2C_FUNC_SMBUS_BYTE_DATA)) {
@@ -876,6 +1070,16 @@ static int adp5589_probe(struct i2c_client *client,
 	}
 
 	if (!pdata) {
+		/* Try with device tree */
+		pdata = adp5589_get_dt_data(&client->dev, &dev_type);
+
+		if (IS_ERR(pdata))
+			pdata = NULL;
+	} else {
+		dev_type = id->driver_data;
+	}
+
+	if (!pdata) {
 		dev_err(&client->dev, "no platform data?\n");
 		return -EINVAL;
 	}
@@ -884,7 +1088,7 @@ static int adp5589_probe(struct i2c_client *client,
 	if (!kpad)
 		return -ENOMEM;
 
-	switch (id->driver_data) {
+	switch (dev_type) {
 	case ADP5585_02:
 		kpad->adp5585_support_row5 = true;
 	case ADP5585_01:
@@ -1101,6 +1305,7 @@ static struct i2c_driver adp5589_driver = {
 		.name = KBUILD_MODNAME,
 		.owner = THIS_MODULE,
 		.pm = &adp5589_dev_pm_ops,
+		.of_match_table = adp5589_of_match,
 	},
 	.probe = adp5589_probe,
 	.remove = adp5589_remove,
-- 
2.0.0.rc0

