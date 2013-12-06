Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab3LFKC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:02:28 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51268 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab3LFKCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:02:24 -0500
Date: Fri, 6 Dec 2013 02:02:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Sachin Kamat <sachin.kamat@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: samsung-keypad - favor platform data if present
Message-ID: <20131206100215.GA27763@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be able to override firmware-provided parameters with in-kernel
data, if needed. To that effect favor platform data, if present, over
devicetree data.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/samsung-keypad.c | 36 +++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/input/keyboard/samsung-keypad.c b/drivers/input/keyboard/samsung-keypad.c
index 9ac8a1e..a7357ad 100644
--- a/drivers/input/keyboard/samsung-keypad.c
+++ b/drivers/input/keyboard/samsung-keypad.c
@@ -244,8 +244,8 @@ static void samsung_keypad_close(struct input_dev *input_dev)
 }
 
 #ifdef CONFIG_OF
-static struct samsung_keypad_platdata *samsung_keypad_parse_dt(
-				struct device *dev)
+static struct samsung_keypad_platdata *
+samsung_keypad_parse_dt(struct device *dev)
 {
 	struct samsung_keypad_platdata *pdata;
 	struct matrix_keymap_data *keymap_data;
@@ -253,17 +253,22 @@ static struct samsung_keypad_platdata *samsung_keypad_parse_dt(
 	struct device_node *np = dev->of_node, *key_np;
 	unsigned int key_count;
 
+	if (!np) {
+		dev_err(dev, "missing device tree data\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata) {
 		dev_err(dev, "could not allocate memory for platform data\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	of_property_read_u32(np, "samsung,keypad-num-rows", &num_rows);
 	of_property_read_u32(np, "samsung,keypad-num-columns", &num_cols);
 	if (!num_rows || !num_cols) {
 		dev_err(dev, "number of keypad rows/columns not specified\n");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 	pdata->rows = num_rows;
 	pdata->cols = num_cols;
@@ -271,7 +276,7 @@ static struct samsung_keypad_platdata *samsung_keypad_parse_dt(
 	keymap_data = devm_kzalloc(dev, sizeof(*keymap_data), GFP_KERNEL);
 	if (!keymap_data) {
 		dev_err(dev, "could not allocate memory for keymap data\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	pdata->keymap_data = keymap_data;
 
@@ -280,7 +285,7 @@ static struct samsung_keypad_platdata *samsung_keypad_parse_dt(
 	keymap = devm_kzalloc(dev, sizeof(uint32_t) * key_count, GFP_KERNEL);
 	if (!keymap) {
 		dev_err(dev, "could not allocate memory for keymap\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	keymap_data->keymap = keymap;
 
@@ -294,16 +299,19 @@ static struct samsung_keypad_platdata *samsung_keypad_parse_dt(
 
 	if (of_get_property(np, "linux,input-no-autorepeat", NULL))
 		pdata->no_autorepeat = true;
+
 	if (of_get_property(np, "linux,input-wakeup", NULL))
 		pdata->wakeup = true;
 
 	return pdata;
 }
 #else
-static
-struct samsung_keypad_platdata *samsung_keypad_parse_dt(struct device *dev)
+static struct samsung_keypad_platdata *
+samsung_keypad_parse_dt(struct device *dev)
 {
-	return NULL;
+	dev_err(dev, "no platform data defined\n");
+
+	return ERR_PTR(-EINVAL);
 }
 #endif
 
@@ -318,13 +326,11 @@ static int samsung_keypad_probe(struct platform_device *pdev)
 	unsigned int keymap_size;
 	int error;
 
-	if (pdev->dev.of_node)
-		pdata = samsung_keypad_parse_dt(&pdev->dev);
-	else
-		pdata = dev_get_platdata(&pdev->dev);
+	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
-		dev_err(&pdev->dev, "no platform data defined\n");
-		return -EINVAL;
+		pdata = samsung_keypad_parse_dt(&pdev->dev);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
 	}
 
 	keymap_data = pdata->keymap_data;
-- 
1.8.3.1


-- 
Dmitry
