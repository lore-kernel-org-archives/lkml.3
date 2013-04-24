Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3DXD3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:29:31 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:53206 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757569Ab3DXD32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:29:28 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>, <haojian.zhuang@gmail.com>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 2/6] input: pxa27x-keypad: use matrix_keymap for matrix keyes
Date: Tue, 23 Apr 2013 23:20:29 -0400
Message-ID: <1366773633-7727-3-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366773633-7727-1-git-send-email-chao.xie@marvell.com>
References: <1366773633-7727-1-git-send-email-chao.xie@marvell.com>
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
 drivers/input/keyboard/pxa27x_keypad.c      |   29 +++++++++++++++-----------
 include/linux/platform_data/keypad-pxa27x.h |    1 +
 3 files changed, 19 insertions(+), 12 deletions(-)

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
index 023243a..975b448 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -137,22 +137,27 @@ static int pxa27x_keypad_build_keycode(struct device *dev,
 			struct input_dev *input_dev)
 {
 	unsigned short keycode;
-	int i;
+	int ret, i;
+	const struct matrix_keymap_data *keymap_data =
+				pdata ? pdata->matrix_keymap_data : NULL;
 
 	keypad->matrix_key_rows = pdata->matrix_key_rows;
 	keypad->matrix_key_cols = pdata->matrix_key_cols;
-	for (i = 0; i < pdata->matrix_key_map_size; i++) {
-		unsigned int key = pdata->matrix_key_map[i];
-		unsigned int row = KEY_ROW(key);
-		unsigned int col = KEY_COL(key);
-		unsigned int scancode = MATRIX_SCAN_CODE(row, col,
-							 MATRIX_ROW_SHIFT);
-
-		keycode = KEY_VAL(key);
-		keypad->keycodes[scancode] = keycode;
-		__set_bit(keycode, input_dev->keybit);
-	}
 
+	ret = matrix_keypad_build_keymap(keymap_data, NULL,
+					 keypad->matrix_key_rows,
+					 keypad->matrix_key_cols,
+					 keypad->keycodes, input_dev);
+	if (ret)
+		return ret;
+
+	/*
+	 * The keycodes may not only includes matrix key but also the direct
+	 * key or rotary key.
+	 */
+	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
+
+	/* For direct key. */
 	keypad->direct_key_low_active = pdata->direct_key_low_active;
 	keypad->direct_key_num = pdata->direct_key_num;
 	keypad->default_direct_key_mask = pdata->direct_key_mask;
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

