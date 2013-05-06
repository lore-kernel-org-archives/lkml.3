Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3EFDEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:04:16 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:56978 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778Ab3EFDEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:04:14 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>, <haojian.zhuang@gmail.com>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 1/5] input: pxa27x-keypad: use matrix_keymap for matrix keyes
Date: Sun, 5 May 2013 23:04:04 -0400
Message-ID: <1367809448-9437-2-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1367809448-9437-1-git-send-email-chao.xie@marvell.com>
References: <1367809448-9437-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pxa27x-keypad includes matrix keyes. Make use of matrix_keymap
for the matrix keyes.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/input/keyboard/Kconfig              |    1 +
 drivers/input/keyboard/pxa27x_keypad.c      |   36 +++++++++++++++++---------
 include/linux/platform_data/keypad-pxa27x.h |    1 +
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index ac05006..fff3751 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -441,6 +441,7 @@ config KEYBOARD_OPENCORES
 config KEYBOARD_PXA27x
 	tristate "PXA27x/PXA3xx keypad support"
 	depends on PXA27x || PXA3xx || ARCH_MMP
+	select INPUT_MATRIXKMAP
 	help
 	  Enable support for PXA27x/PXA3xx keypad controller.
 
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 5330d8f..c9f212a 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -118,25 +118,29 @@ struct pxa27x_keypad {
 	unsigned int direct_key_mask;
 };
 
-static void pxa27x_keypad_build_keycode(struct pxa27x_keypad *keypad)
+static int pxa27x_keypad_build_keycode(struct pxa27x_keypad *keypad)
 {
 	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
 	struct input_dev *input_dev = keypad->input_dev;
 	unsigned short keycode;
-	int i;
+	int ret, i;
+	const struct matrix_keymap_data *keymap_data =
+				pdata ? pdata->matrix_keymap_data : NULL;
 
-	for (i = 0; i < pdata->matrix_key_map_size; i++) {
-		unsigned int key = pdata->matrix_key_map[i];
-		unsigned int row = KEY_ROW(key);
-		unsigned int col = KEY_COL(key);
-		unsigned int scancode = MATRIX_SCAN_CODE(row, col,
-							 MATRIX_ROW_SHIFT);
+	ret = matrix_keypad_build_keymap(keymap_data, NULL,
+					 pdata->matrix_key_rows,
+					 pdata->matrix_key_cols,
+					 keypad->keycodes, input_dev);
+	if (ret)
+		return ret;
 
-		keycode = KEY_VAL(key);
-		keypad->keycodes[scancode] = keycode;
-		__set_bit(keycode, input_dev->keybit);
-	}
+	/*
+	 * The keycodes may not only includes matrix key but also the direct
+	 * key or rotary key.
+	 */
+	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
 
+	/* For direct key. */
 	for (i = 0; i < pdata->direct_key_num; i++) {
 		keycode = pdata->direct_key_map[i];
 		keypad->keycodes[MAX_MATRIX_KEY_NUM + i] = keycode;
@@ -178,6 +182,8 @@ static void pxa27x_keypad_build_keycode(struct pxa27x_keypad *keypad)
 	}
 
 	__clear_bit(KEY_RESERVED, input_dev->keybit);
+
+	return 0;
 }
 
 static void pxa27x_keypad_scan_matrix(struct pxa27x_keypad *keypad)
@@ -555,7 +561,11 @@ static int pxa27x_keypad_probe(struct platform_device *pdev)
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
 
-	pxa27x_keypad_build_keycode(keypad);
+	error  = pxa27x_keypad_build_keycode(keypad);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keycode\n");
+		goto failed_put_clk;
+	}
 
 	if ((pdata->enable_rotary0 && keypad->rotary_rel_code[0] != -1) ||
 	    (pdata->enable_rotary1 && keypad->rotary_rel_code[1] != -1)) {
diff --git a/include/linux/platform_data/keypad-pxa27x.h b/include/linux/platform_data/keypad-pxa27x.h
index 5ce8d5e6..0db423b 100644
--- a/include/linux/platform_data/keypad-pxa27x.h
+++ b/include/linux/platform_data/keypad-pxa27x.h
@@ -36,6 +36,7 @@
 struct pxa27x_keypad_platform_data {
 
 	/* code map for the matrix keys */
+	const struct matrix_keymap_data *matrix_keymap_data;
 	unsigned int	matrix_key_rows;
 	unsigned int	matrix_key_cols;
 	unsigned int	*matrix_key_map;
-- 
1.7.4.1

