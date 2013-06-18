Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3FRD5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:57:34 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:55621 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277Ab3FRD5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:57:33 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <dmitry.torokhov@gmail.com>, <arnd@arndb.de>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <drwyrm@gmail.com>, <stefan@openezx.org>,
        <laforge@openezx.org>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <sleep_walker@suse.cz>, <slapin@ossfans.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V3 1/5] input: pxa27x-keypad: use matrix_keymap for matrix keyes
Date: Mon, 17 Jun 2013 23:56:14 -0400
Message-ID: <1371527778-5236-2-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
References: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
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
index 37c3666..706e11b 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -451,6 +451,7 @@ config KEYBOARD_OPENCORES
 config KEYBOARD_PXA27x
 	tristate "PXA27x/PXA3xx keypad support"
 	depends on PXA27x || PXA3xx || ARCH_MMP
+	select INPUT_MATRIXKMAP
 	help
 	  Enable support for PXA27x/PXA3xx keypad controller.
 
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index b674e7a..947d657 100644
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

