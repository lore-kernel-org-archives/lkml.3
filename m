Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3BNHqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:46:52 -0500
Received: from mail-ye0-f202.google.com ([209.85.213.202]:45539 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3BNHqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:46:51 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Simon Glass <sjg@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        linux-input@vger.kernel.org
Subject: [PATCH v3 5/6] Input: matrix-keymap: Add function to read the new DT binding
Date: Wed, 13 Feb 2013 22:50:14 -0800
Message-Id: <1360824615-10962-6-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have a binding which adds two parameters to the matrix keypad DT
node. This is separate from the GPIO-driven matrix keypad binding, and
unfortunately incompatible, since that uses row-gpios/col-gpios for the
row and column counts.

So the easiest option here is to provide a function for non-GPIO drivers
to use to decode the binding.

Note: We could in fact create an entirely separate structure to hold
these two fields, but it does not seem worth it, yet. If we have more
parameters then we can add this, and then refactor each driver to hold
such a structure.

Signed-off-by: Simon Glass <sjg@chromium.org>
Tested-by: Sourav Poddar <sourav.poddar@ti.com> (v2)
---
Changes in v3:
- Add stub for matrix_keypad_parse_of_params() when no CONFIG_OF
- Put back full DT range checking in tca8418 driver

Changes in v2:
- Add new patch to decode matrix-keypad DT binding

 drivers/input/keyboard/lpc32xx-keys.c   | 11 ++++++-----
 drivers/input/keyboard/omap4-keypad.c   | 16 +++++-----------
 drivers/input/keyboard/tca8418_keypad.c |  7 +++++--
 drivers/input/matrix-keymap.c           | 19 +++++++++++++++++++
 include/linux/input/matrix_keypad.h     | 19 +++++++++++++++++++
 5 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/drivers/input/keyboard/lpc32xx-keys.c b/drivers/input/keyboard/lpc32xx-keys.c
index 1b8add6..4218143 100644
--- a/drivers/input/keyboard/lpc32xx-keys.c
+++ b/drivers/input/keyboard/lpc32xx-keys.c
@@ -144,12 +144,13 @@ static int lpc32xx_parse_dt(struct device *dev,
 {
 	struct device_node *np = dev->of_node;
 	u32 rows = 0, columns = 0;
+	int err;
 
-	of_property_read_u32(np, "keypad,num-rows", &rows);
-	of_property_read_u32(np, "keypad,num-columns", &columns);
-	if (!rows || rows != columns) {
-		dev_err(dev,
-			"rows and columns must be specified and be equal!\n");
+	err = matrix_keypad_parse_of_params(dev, &rows, &columns);
+	if (err)
+		return err;
+	if (rows != columns) {
+		dev_err(dev, "rows and columns must be equal!\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index e25b022..1b28909 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -215,18 +215,12 @@ static int omap4_keypad_parse_dt(struct device *dev,
 				 struct omap4_keypad *keypad_data)
 {
 	struct device_node *np = dev->of_node;
+	int err;
 
-	if (!np) {
-		dev_err(dev, "missing DT data");
-		return -EINVAL;
-	}
-
-	of_property_read_u32(np, "keypad,num-rows", &keypad_data->rows);
-	of_property_read_u32(np, "keypad,num-columns", &keypad_data->cols);
-	if (!keypad_data->rows || !keypad_data->cols) {
-		dev_err(dev, "number of keypad rows/columns not specified\n");
-		return -EINVAL;
-	}
+	err = matrix_keypad_parse_of_params(dev, &keypad_data->rows,
+					    &keypad_data->cols);
+	if (err)
+		return err;
 
 	if (of_get_property(np, "linux,input-no-autorepeat", NULL))
 		keypad_data->no_autorepeat = true;
diff --git a/drivers/input/keyboard/tca8418_keypad.c b/drivers/input/keyboard/tca8418_keypad.c
index a34cc67..55c1530 100644
--- a/drivers/input/keyboard/tca8418_keypad.c
+++ b/drivers/input/keyboard/tca8418_keypad.c
@@ -288,8 +288,11 @@ static int tca8418_keypad_probe(struct i2c_client *client,
 		irq_is_gpio = pdata->irq_is_gpio;
 	} else {
 		struct device_node *np = dev->of_node;
-		of_property_read_u32(np, "keypad,num-rows", &rows);
-		of_property_read_u32(np, "keypad,num-columns", &cols);
+		int err;
+
+		err = matrix_keypad_parse_of_params(dev, &rows, &cols);
+		if (err)
+			return err;
 		rep = of_property_read_bool(np, "keypad,autorepeat");
 	}
 
diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c
index 3ae496e..619b382 100644
--- a/drivers/input/matrix-keymap.c
+++ b/drivers/input/matrix-keymap.c
@@ -50,6 +50,25 @@ static bool matrix_keypad_map_key(struct input_dev *input_dev,
 }
 
 #ifdef CONFIG_OF
+int matrix_keypad_parse_of_params(struct device *dev,
+				  unsigned int *rows, unsigned int *cols)
+{
+	struct device_node *np = dev->of_node;
+
+	if (!np) {
+		dev_err(dev, "missing DT data");
+		return -EINVAL;
+	}
+	of_property_read_u32(np, "keypad,num-rows", rows);
+	of_property_read_u32(np, "keypad,num-columns", cols);
+	if (!*rows || !*cols) {
+		dev_err(dev, "number of keypad rows/columns not specified\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int matrix_keypad_parse_of_keymap(const char *propname,
 					 unsigned int rows, unsigned int cols,
 					 struct input_dev *input_dev)
diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
index 5f3aa6b..27e06ac 100644
--- a/include/linux/input/matrix_keypad.h
+++ b/include/linux/input/matrix_keypad.h
@@ -81,4 +81,23 @@ int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
 			       unsigned short *keymap,
 			       struct input_dev *input_dev);
 
+#ifdef CONFIG_OF
+/**
+ * matrix_keypad_parse_of_params() - Read parameters from matrix-keypad node
+ *
+ * @dev: Device containing of_node
+ * @rows: Returns number of matrix rows
+ * @cols: Returns number of matrix columns
+ * @return 0 if OK, <0 on error
+ */
+int matrix_keypad_parse_of_params(struct device *dev,
+				  unsigned int *rows, unsigned int *cols);
+#else
+static inline int matrix_keypad_parse_of_params(struct device *dev,
+				  unsigned int *rows, unsigned int *cols)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_OF */
+
 #endif /* _MATRIX_KEYPAD_H */
-- 
1.8.1

