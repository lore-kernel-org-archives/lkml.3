Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab3DXDYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:24:18 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33389 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757400Ab3DXDYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:24:16 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>, <haojian.zhuang@gmail.com>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 1/6] input: pxa27x-keypad: copy members of platform data to device private data
Date: Tue, 23 Apr 2013 23:20:28 -0400
Message-ID: <1366773633-7727-2-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366773633-7727-1-git-send-email-chao.xie@marvell.com>
References: <1366773633-7727-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original driver will directly use platform data when driver is
running.
In fact, the platform data may be freed after system is bootup,
or pointer for platform data is NULL if it has device tree support.
Define the useful members of platform data in device private data.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/input/keyboard/pxa27x_keypad.c |   97 ++++++++++++++++++++-----------
 1 files changed, 62 insertions(+), 35 deletions(-)

diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 5330d8f..023243a 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -100,8 +100,6 @@
 #define MAX_KEYPAD_KEYS		(MAX_MATRIX_KEY_NUM + MAX_DIRECT_KEY_NUM)
 
 struct pxa27x_keypad {
-	struct pxa27x_keypad_platform_data *pdata;
-
 	struct clk *clk;
 	struct input_dev *input_dev;
 	void __iomem *mmio_base;
@@ -116,15 +114,33 @@ struct pxa27x_keypad {
 	uint32_t direct_key_state;
 
 	unsigned int direct_key_mask;
+
+	/* from platform data */
+	unsigned int matrix_key_rows;
+	unsigned int matrix_key_cols;
+
+	int direct_key_low_active;
+	unsigned int direct_key_num;
+	unsigned int default_direct_key_mask;
+
+	int enable_rotary0;
+	int enable_rotary1;
+
+	unsigned int debounce_interval;
+
+	void (*clear_wakeup_event)(void);
 };
 
-static void pxa27x_keypad_build_keycode(struct pxa27x_keypad *keypad)
+static int pxa27x_keypad_build_keycode(struct device *dev,
+			struct pxa27x_keypad *keypad,
+			struct pxa27x_keypad_platform_data *pdata,
+			struct input_dev *input_dev)
 {
-	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
-	struct input_dev *input_dev = keypad->input_dev;
 	unsigned short keycode;
 	int i;
 
+	keypad->matrix_key_rows = pdata->matrix_key_rows;
+	keypad->matrix_key_cols = pdata->matrix_key_cols;
 	for (i = 0; i < pdata->matrix_key_map_size; i++) {
 		unsigned int key = pdata->matrix_key_map[i];
 		unsigned int row = KEY_ROW(key);
@@ -137,12 +153,16 @@ static void pxa27x_keypad_build_keycode(struct pxa27x_keypad *keypad)
 		__set_bit(keycode, input_dev->keybit);
 	}
 
+	keypad->direct_key_low_active = pdata->direct_key_low_active;
+	keypad->direct_key_num = pdata->direct_key_num;
+	keypad->default_direct_key_mask = pdata->direct_key_mask;
 	for (i = 0; i < pdata->direct_key_num; i++) {
 		keycode = pdata->direct_key_map[i];
 		keypad->keycodes[MAX_MATRIX_KEY_NUM + i] = keycode;
 		__set_bit(keycode, input_dev->keybit);
 	}
 
+	keypad->enable_rotary0 = pdata->enable_rotary0;
 	if (pdata->enable_rotary0) {
 		if (pdata->rotary0_up_key && pdata->rotary0_down_key) {
 			keycode = pdata->rotary0_up_key;
@@ -160,6 +180,7 @@ static void pxa27x_keypad_build_keycode(struct pxa27x_keypad *keypad)
 		}
 	}
 
+	keypad->enable_rotary1 = pdata->enable_rotary1;
 	if (pdata->enable_rotary1) {
 		if (pdata->rotary1_up_key && pdata->rotary1_down_key) {
 			keycode = pdata->rotary1_up_key;
@@ -178,11 +199,14 @@ static void pxa27x_keypad_build_keycode(struct pxa27x_keypad *keypad)
 	}
 
 	__clear_bit(KEY_RESERVED, input_dev->keybit);
+
+	keypad->debounce_interval = pdata->debounce_interval;
+
+	return 0;
 }
 
 static void pxa27x_keypad_scan_matrix(struct pxa27x_keypad *keypad)
 {
-	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
 	struct input_dev *input_dev = keypad->input_dev;
 	int row, col, num_keys_pressed = 0;
 	uint32_t new_state[MAX_MATRIX_KEY_COLS];
@@ -200,8 +224,8 @@ static void pxa27x_keypad_scan_matrix(struct pxa27x_keypad *keypad)
 		row = KPAS_RP(kpas);
 
 		/* if invalid row/col, treat as no key pressed */
-		if (col >= pdata->matrix_key_cols ||
-		    row >= pdata->matrix_key_rows)
+		if (col >= keypad->matrix_key_cols ||
+		    row >= keypad->matrix_key_rows)
 			goto scan;
 
 		new_state[col] = (1 << row);
@@ -224,7 +248,7 @@ static void pxa27x_keypad_scan_matrix(struct pxa27x_keypad *keypad)
 		new_state[7] = (kpasmkp3 >> 16) & KPASMKP_MKC_MASK;
 	}
 scan:
-	for (col = 0; col < pdata->matrix_key_cols; col++) {
+	for (col = 0; col < keypad->matrix_key_cols; col++) {
 		uint32_t bits_changed;
 		int code;
 
@@ -232,7 +256,7 @@ scan:
 		if (bits_changed == 0)
 			continue;
 
-		for (row = 0; row < pdata->matrix_key_rows; row++) {
+		for (row = 0; row < keypad->matrix_key_rows; row++) {
 			if ((bits_changed & (1 << row)) == 0)
 				continue;
 
@@ -284,23 +308,21 @@ static void report_rotary_event(struct pxa27x_keypad *keypad, int r, int delta)
 
 static void pxa27x_keypad_scan_rotary(struct pxa27x_keypad *keypad)
 {
-	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
 	uint32_t kprec;
 
 	/* read and reset to default count value */
 	kprec = keypad_readl(KPREC);
 	keypad_writel(KPREC, DEFAULT_KPREC);
 
-	if (pdata->enable_rotary0)
+	if (keypad->enable_rotary0)
 		report_rotary_event(keypad, 0, rotary_delta(kprec));
 
-	if (pdata->enable_rotary1)
+	if (keypad->enable_rotary1)
 		report_rotary_event(keypad, 1, rotary_delta(kprec >> 16));
 }
 
 static void pxa27x_keypad_scan_direct(struct pxa27x_keypad *keypad)
 {
-	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
 	struct input_dev *input_dev = keypad->input_dev;
 	unsigned int new_state;
 	uint32_t kpdk, bits_changed;
@@ -308,14 +330,14 @@ static void pxa27x_keypad_scan_direct(struct pxa27x_keypad *keypad)
 
 	kpdk = keypad_readl(KPDK);
 
-	if (pdata->enable_rotary0 || pdata->enable_rotary1)
+	if (keypad->enable_rotary0 || keypad->enable_rotary1)
 		pxa27x_keypad_scan_rotary(keypad);
 
 	/*
 	 * The KPDR_DK only output the key pin level, so it relates to board,
 	 * and low level may be active.
 	 */
-	if (pdata->direct_key_low_active)
+	if (keypad->direct_key_low_active)
 		new_state = ~KPDK_DK(kpdk) & keypad->direct_key_mask;
 	else
 		new_state = KPDK_DK(kpdk) & keypad->direct_key_mask;
@@ -325,7 +347,7 @@ static void pxa27x_keypad_scan_direct(struct pxa27x_keypad *keypad)
 	if (bits_changed == 0)
 		return;
 
-	for (i = 0; i < pdata->direct_key_num; i++) {
+	for (i = 0; i < keypad->direct_key_num; i++) {
 		if (bits_changed & (1 << i)) {
 			int code = MAX_MATRIX_KEY_NUM + i;
 
@@ -340,10 +362,9 @@ static void pxa27x_keypad_scan_direct(struct pxa27x_keypad *keypad)
 
 static void clear_wakeup_event(struct pxa27x_keypad *keypad)
 {
-	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
 
-	if (pdata->clear_wakeup_event)
-		(pdata->clear_wakeup_event)();
+	if (keypad->clear_wakeup_event)
+		(keypad->clear_wakeup_event)();
 }
 
 static irqreturn_t pxa27x_keypad_irq_handler(int irq, void *dev_id)
@@ -364,7 +385,6 @@ static irqreturn_t pxa27x_keypad_irq_handler(int irq, void *dev_id)
 
 static void pxa27x_keypad_config(struct pxa27x_keypad *keypad)
 {
-	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
 	unsigned int mask = 0, direct_key_num = 0;
 	unsigned long kpc = 0;
 
@@ -372,34 +392,34 @@ static void pxa27x_keypad_config(struct pxa27x_keypad *keypad)
 	keypad_readl(KPC);
 
 	/* enable matrix keys with automatic scan */
-	if (pdata->matrix_key_rows && pdata->matrix_key_cols) {
+	if (keypad->matrix_key_rows && keypad->matrix_key_cols) {
 		kpc |= KPC_ASACT | KPC_MIE | KPC_ME | KPC_MS_ALL;
-		kpc |= KPC_MKRN(pdata->matrix_key_rows) |
-		       KPC_MKCN(pdata->matrix_key_cols);
+		kpc |= KPC_MKRN(keypad->matrix_key_rows) |
+		       KPC_MKCN(keypad->matrix_key_cols);
 	}
 
 	/* enable rotary key, debounce interval same as direct keys */
-	if (pdata->enable_rotary0) {
+	if (keypad->enable_rotary0) {
 		mask |= 0x03;
 		direct_key_num = 2;
 		kpc |= KPC_REE0;
 	}
 
-	if (pdata->enable_rotary1) {
+	if (keypad->enable_rotary1) {
 		mask |= 0x0c;
 		direct_key_num = 4;
 		kpc |= KPC_REE1;
 	}
 
-	if (pdata->direct_key_num > direct_key_num)
-		direct_key_num = pdata->direct_key_num;
+	if (keypad->direct_key_num > direct_key_num)
+		direct_key_num = keypad->direct_key_num;
 
 	/*
 	 * Direct keys usage may not start from KP_DKIN0, check the platfrom
 	 * mask data to config the specific.
 	 */
-	if (pdata->direct_key_mask)
-		keypad->direct_key_mask = pdata->direct_key_mask;
+	if (keypad->default_direct_key_mask)
+		keypad->direct_key_mask = keypad->default_direct_key_mask;
 	else
 		keypad->direct_key_mask = ((1 << direct_key_num) - 1) & ~mask;
 
@@ -409,7 +429,7 @@ static void pxa27x_keypad_config(struct pxa27x_keypad *keypad)
 
 	keypad_writel(KPC, kpc | KPC_RE_ZERO_DEB);
 	keypad_writel(KPREC, DEFAULT_KPREC);
-	keypad_writel(KPKDI, pdata->debounce_interval);
+	keypad_writel(KPKDI, keypad->debounce_interval);
 }
 
 static int pxa27x_keypad_open(struct input_dev *dev)
@@ -515,7 +535,6 @@ static int pxa27x_keypad_probe(struct platform_device *pdev)
 		goto failed_free;
 	}
 
-	keypad->pdata = pdata;
 	keypad->input_dev = input_dev;
 	keypad->irq = irq;
 
@@ -555,10 +574,18 @@ static int pxa27x_keypad_probe(struct platform_device *pdev)
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
 
-	pxa27x_keypad_build_keycode(keypad);
+	if (pdata->clear_wakeup_event)
+		keypad->clear_wakeup_event = pdata->clear_wakeup_event;
+
+	error = pxa27x_keypad_build_keycode(&pdev->dev, keypad, pdata,
+					    input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keycode\n");
+		goto failed_put_clk;
+	}
 
-	if ((pdata->enable_rotary0 && keypad->rotary_rel_code[0] != -1) ||
-	    (pdata->enable_rotary1 && keypad->rotary_rel_code[1] != -1)) {
+	if ((keypad->enable_rotary0 && keypad->rotary_rel_code[0] != -1) ||
+	    (keypad->enable_rotary1 && keypad->rotary_rel_code[1] != -1)) {
 		input_dev->evbit[0] |= BIT_MASK(EV_REL);
 	}
 
-- 
1.7.4.1

