Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaBZTNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:13:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53858 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaBZTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:06 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 6/9] Input: pmic8xxx-keypad - Migrate to DT
Date: Wed, 26 Feb 2014 11:05:59 -0800
Message-Id: <1393441562-685-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
References: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is only supported on DT enabled platforms. Convert the
driver to DT so that it can probe properly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/keyboard/pmic8xxx-keypad.c | 148 ++++++++++++++++++-------------
 include/linux/input/pmic8xxx-keypad.h    |  52 -----------
 2 files changed, 85 insertions(+), 115 deletions(-)
 delete mode 100644 include/linux/input/pmic8xxx-keypad.h

diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index c6d3d216ffa7..d2e43073d76e 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -20,9 +20,10 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/regmap.h>
+#include <linux/of.h>
+#include <linux/input/matrix_keypad.h>
 
 #include <linux/mfd/pm8xxx/gpio.h>
-#include <linux/input/pmic8xxx-keypad.h>
 
 #define PM8XXX_MAX_ROWS		18
 #define PM8XXX_MAX_COLS		8
@@ -85,7 +86,8 @@
 
 /**
  * struct pmic8xxx_kp - internal keypad data structure
- * @pdata - keypad platform data pointer
+ * @num_cols - number of columns of keypad
+ * @num_rows - number of row of keypad
  * @input - input device pointer for keypad
  * @regmap - regmap handle
  * @key_sense_irq - key press/release irq number
@@ -97,7 +99,8 @@
  * @ctrl_reg - control register value
  */
 struct pmic8xxx_kp {
-	const struct pm8xxx_keypad_platform_data *pdata;
+	unsigned int num_rows;
+	unsigned int num_cols;
 	struct input_dev *input;
 	struct regmap *regmap;
 	int key_sense_irq;
@@ -116,9 +119,9 @@ static u8 pmic8xxx_col_state(struct pmic8xxx_kp *kp, u8 col)
 {
 	/* all keys pressed on that particular row? */
 	if (col == 0x00)
-		return 1 << kp->pdata->num_cols;
+		return 1 << kp->num_cols;
 	else
-		return col & ((1 << kp->pdata->num_cols) - 1);
+		return col & ((1 << kp->num_cols) - 1);
 }
 
 /*
@@ -181,10 +184,10 @@ static int pmic8xxx_kp_read_matrix(struct pmic8xxx_kp *kp, u16 *new_state,
 	int rc, read_rows;
 	unsigned int scan_val;
 
-	if (kp->pdata->num_rows < PM8XXX_MIN_ROWS)
+	if (kp->num_rows < PM8XXX_MIN_ROWS)
 		read_rows = PM8XXX_MIN_ROWS;
 	else
-		read_rows = kp->pdata->num_rows;
+		read_rows = kp->num_rows;
 
 	pmic8xxx_chk_sync_read(kp);
 
@@ -228,13 +231,13 @@ static void __pmic8xxx_kp_scan_matrix(struct pmic8xxx_kp *kp, u16 *new_state,
 {
 	int row, col, code;
 
-	for (row = 0; row < kp->pdata->num_rows; row++) {
+	for (row = 0; row < kp->num_rows; row++) {
 		int bits_changed = new_state[row] ^ old_state[row];
 
 		if (!bits_changed)
 			continue;
 
-		for (col = 0; col < kp->pdata->num_cols; col++) {
+		for (col = 0; col < kp->num_cols; col++) {
 			if (!(bits_changed & (1 << col)))
 				continue;
 
@@ -260,9 +263,9 @@ static bool pmic8xxx_detect_ghost_keys(struct pmic8xxx_kp *kp, u16 *new_state)
 	u16 check, row_state;
 
 	check = 0;
-	for (row = 0; row < kp->pdata->num_rows; row++) {
+	for (row = 0; row < kp->num_rows; row++) {
 		row_state = (~new_state[row]) &
-				 ((1 << kp->pdata->num_cols) - 1);
+				 ((1 << kp->num_cols) - 1);
 
 		if (hweight16(row_state) > 1) {
 			if (found_first == -1)
@@ -370,8 +373,13 @@ static irqreturn_t pmic8xxx_kp_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int pmic8xxx_kpd_init(struct pmic8xxx_kp *kp)
+static int pmic8xxx_kpd_init(struct pmic8xxx_kp *kp,
+			     struct platform_device *pdev)
 {
+	const struct device_node *of_node = pdev->dev.of_node;
+	unsigned int scan_delay_ms;
+	unsigned int row_hold_ns;
+	unsigned int debounce_ms;
 	int bits, rc, cycles;
 	u8 scan_val = 0, ctrl_val = 0;
 	static const u8 row_bits[] = {
@@ -379,18 +387,18 @@ static int pmic8xxx_kpd_init(struct pmic8xxx_kp *kp)
 	};
 
 	/* Find column bits */
-	if (kp->pdata->num_cols < KEYP_CTRL_SCAN_COLS_MIN)
+	if (kp->num_cols < KEYP_CTRL_SCAN_COLS_MIN)
 		bits = 0;
 	else
-		bits = kp->pdata->num_cols - KEYP_CTRL_SCAN_COLS_MIN;
+		bits = kp->num_cols - KEYP_CTRL_SCAN_COLS_MIN;
 	ctrl_val = (bits & KEYP_CTRL_SCAN_COLS_BITS) <<
 		KEYP_CTRL_SCAN_COLS_SHIFT;
 
 	/* Find row bits */
-	if (kp->pdata->num_rows < KEYP_CTRL_SCAN_ROWS_MIN)
+	if (kp->num_rows < KEYP_CTRL_SCAN_ROWS_MIN)
 		bits = 0;
 	else
-		bits = row_bits[kp->pdata->num_rows - KEYP_CTRL_SCAN_ROWS_MIN];
+		bits = row_bits[kp->num_rows - KEYP_CTRL_SCAN_ROWS_MIN];
 
 	ctrl_val |= (bits << KEYP_CTRL_SCAN_ROWS_SHIFT);
 
@@ -400,15 +408,44 @@ static int pmic8xxx_kpd_init(struct pmic8xxx_kp *kp)
 		return rc;
 	}
 
-	bits = (kp->pdata->debounce_ms / 5) - 1;
+	if (of_property_read_u32(of_node, "scan-delay", &scan_delay_ms))
+		scan_delay_ms = MIN_SCAN_DELAY;
+
+	if (scan_delay_ms > MAX_SCAN_DELAY || scan_delay_ms < MIN_SCAN_DELAY ||
+		!is_power_of_2(scan_delay_ms)) {
+		dev_err(&pdev->dev, "invalid keypad scan time supplied\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32(of_node, "row-hold", &row_hold_ns))
+		row_hold_ns = MIN_ROW_HOLD_DELAY;
+
+	if (row_hold_ns > MAX_ROW_HOLD_DELAY ||
+		row_hold_ns < MIN_ROW_HOLD_DELAY ||
+		((row_hold_ns % MIN_ROW_HOLD_DELAY) != 0)) {
+		dev_err(&pdev->dev, "invalid keypad row hold time supplied\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32(of_node, "debounce", &debounce_ms))
+		debounce_ms = MIN_DEBOUNCE_TIME;
+
+	if (((debounce_ms % 5) != 0) ||
+		debounce_ms > MAX_DEBOUNCE_TIME ||
+		debounce_ms < MIN_DEBOUNCE_TIME) {
+		dev_err(&pdev->dev, "invalid debounce time supplied\n");
+		return -EINVAL;
+	}
+
+	bits = (debounce_ms / 5) - 1;
 
 	scan_val |= (bits << KEYP_SCAN_DBOUNCE_SHIFT);
 
-	bits = fls(kp->pdata->scan_delay_ms) - 1;
+	bits = fls(scan_delay_ms) - 1;
 	scan_val |= (bits << KEYP_SCAN_PAUSE_SHIFT);
 
 	/* Row hold time is a multiple of 32KHz cycles. */
-	cycles = (kp->pdata->row_hold_ns * KEYP_CLOCK_FREQ) / NSEC_PER_SEC;
+	cycles = (row_hold_ns * KEYP_CLOCK_FREQ) / NSEC_PER_SEC;
 
 	scan_val |= (cycles << KEYP_SCAN_ROW_HOLD_SHIFT);
 
@@ -481,6 +518,13 @@ static void pmic8xxx_kp_close(struct input_dev *dev)
 	pmic8xxx_kp_disable(kp);
 }
 
+static const struct of_device_id pm8xxx_match_table[] = {
+	{ .compatible = "qcom,pm8058-keypad" },
+	{ .compatible = "qcom,pm8921-keypad" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, pm8xxx_match_table);
+
 /*
  * keypad controller should be initialized in the following sequence
  * only, otherwise it might get into FSM stuck state.
@@ -493,9 +537,9 @@ static void pmic8xxx_kp_close(struct input_dev *dev)
  */
 static int pmic8xxx_kp_probe(struct platform_device *pdev)
 {
-	const struct pm8xxx_keypad_platform_data *pdata =
-					dev_get_platdata(&pdev->dev);
-	const struct matrix_keymap_data *keymap_data;
+	unsigned int rows, cols;
+	bool repeat;
+	bool wakeup;
 	struct pmic8xxx_kp *kp;
 	int rc;
 	unsigned int ctrl_val;
@@ -520,44 +564,20 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 		.inv_int_pol	= 1,
 	};
 
+	rc = matrix_keypad_parse_of_params(&pdev->dev, &rows, &cols);
+	if (rc)
+		return rc;
 
-	if (!pdata || !pdata->num_cols || !pdata->num_rows ||
-		pdata->num_cols > PM8XXX_MAX_COLS ||
-		pdata->num_rows > PM8XXX_MAX_ROWS ||
-		pdata->num_cols < PM8XXX_MIN_COLS) {
+	if (cols > PM8XXX_MAX_COLS || rows > PM8XXX_MAX_ROWS ||
+		cols < PM8XXX_MIN_COLS) {
 		dev_err(&pdev->dev, "invalid platform data\n");
 		return -EINVAL;
 	}
 
-	if (!pdata->scan_delay_ms ||
-		pdata->scan_delay_ms > MAX_SCAN_DELAY ||
-		pdata->scan_delay_ms < MIN_SCAN_DELAY ||
-		!is_power_of_2(pdata->scan_delay_ms)) {
-		dev_err(&pdev->dev, "invalid keypad scan time supplied\n");
-		return -EINVAL;
-	}
-
-	if (!pdata->row_hold_ns ||
-		pdata->row_hold_ns > MAX_ROW_HOLD_DELAY ||
-		pdata->row_hold_ns < MIN_ROW_HOLD_DELAY ||
-		((pdata->row_hold_ns % MIN_ROW_HOLD_DELAY) != 0)) {
-		dev_err(&pdev->dev, "invalid keypad row hold time supplied\n");
-		return -EINVAL;
-	}
-
-	if (!pdata->debounce_ms ||
-		((pdata->debounce_ms % 5) != 0) ||
-		pdata->debounce_ms > MAX_DEBOUNCE_TIME ||
-		pdata->debounce_ms < MIN_DEBOUNCE_TIME) {
-		dev_err(&pdev->dev, "invalid debounce time supplied\n");
-		return -EINVAL;
-	}
-
-	keymap_data = pdata->keymap_data;
-	if (!keymap_data) {
-		dev_err(&pdev->dev, "no keymap data supplied\n");
-		return -EINVAL;
-	}
+	repeat = !of_property_read_bool(pdev->dev.of_node,
+					"linux,input-no-autorepeat");
+	wakeup = !of_property_read_bool(pdev->dev.of_node,
+					"linux,keypad-wakeup");
 
 	kp = devm_kzalloc(&pdev->dev, sizeof(*kp), GFP_KERNEL);
 	if (!kp)
@@ -569,7 +589,8 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, kp);
 
-	kp->pdata	= pdata;
+	kp->num_rows	= rows;
+	kp->num_cols	= cols;
 	kp->dev		= &pdev->dev;
 
 	kp->input = devm_input_allocate_device(&pdev->dev);
@@ -590,8 +611,8 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 		return kp->key_stuck_irq;
 	}
 
-	kp->input->name = pdata->input_name ? : "PMIC8XXX keypad";
-	kp->input->phys = pdata->input_phys_device ? : "pmic8xxx_keypad/input0";
+	kp->input->name = "PMIC8XXX keypad";
+	kp->input->phys = "pmic8xxx_keypad/input0";
 
 	kp->input->id.bustype	= BUS_I2C;
 	kp->input->id.version	= 0x0001;
@@ -601,7 +622,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 	kp->input->open		= pmic8xxx_kp_open;
 	kp->input->close	= pmic8xxx_kp_close;
 
-	rc = matrix_keypad_build_keymap(keymap_data, NULL,
+	rc = matrix_keypad_build_keymap(NULL, NULL,
 					PM8XXX_MAX_ROWS, PM8XXX_MAX_COLS,
 					kp->keycodes, kp->input);
 	if (rc) {
@@ -609,7 +630,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 		return rc;
 	}
 
-	if (pdata->rep)
+	if (repeat)
 		__set_bit(EV_REP, kp->input->evbit);
 	input_set_capability(kp->input, EV_MSC, MSC_SCAN);
 
@@ -619,7 +640,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 	memset(kp->keystate, 0xff, sizeof(kp->keystate));
 	memset(kp->stuckstate, 0xff, sizeof(kp->stuckstate));
 
-	rc = pmic8xxx_kpd_init(kp);
+	rc = pmic8xxx_kpd_init(kp, pdev);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "unable to initialize keypad controller\n");
 		return rc;
@@ -669,7 +690,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 		return rc;
 	}
 
-	device_init_wakeup(&pdev->dev, pdata->wakeup);
+	device_init_wakeup(&pdev->dev, wakeup);
 
 	return 0;
 }
@@ -722,9 +743,10 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_kp_pm_ops,
 static struct platform_driver pmic8xxx_kp_driver = {
 	.probe		= pmic8xxx_kp_probe,
 	.driver		= {
-		.name = PM8XXX_KEYPAD_DEV_NAME,
+		.name = "pm8xxx-keypad",
 		.owner = THIS_MODULE,
 		.pm = &pm8xxx_kp_pm_ops,
+		.of_match_table = pm8xxx_match_table,
 	},
 };
 module_platform_driver(pmic8xxx_kp_driver);
diff --git a/include/linux/input/pmic8xxx-keypad.h b/include/linux/input/pmic8xxx-keypad.h
deleted file mode 100644
index 5f1e2f9ad959..000000000000
--- a/include/linux/input/pmic8xxx-keypad.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __PMIC8XXX_KEYPAD_H__
-#define __PMIC8XXX_KEYPAD_H__
-
-#include <linux/input/matrix_keypad.h>
-
-#define PM8XXX_KEYPAD_DEV_NAME     "pm8xxx-keypad"
-
-/**
- * struct pm8xxx_keypad_platform_data - platform data for keypad
- * @keymap_data - matrix keymap data
- * @input_name - input device name
- * @input_phys_device - input device name
- * @num_cols - number of columns of keypad
- * @num_rows - number of row of keypad
- * @debounce_ms - debounce period in milliseconds
- * @scan_delay_ms - scan delay in milliseconds
- * @row_hold_ns - row hold period in nanoseconds
- * @wakeup - configure keypad as wakeup
- * @rep - enable or disable key repeat bit
- */
-struct pm8xxx_keypad_platform_data {
-	const struct matrix_keymap_data *keymap_data;
-
-	const char *input_name;
-	const char *input_phys_device;
-
-	unsigned int num_cols;
-	unsigned int num_rows;
-	unsigned int rows_gpio_start;
-	unsigned int cols_gpio_start;
-
-	unsigned int debounce_ms;
-	unsigned int scan_delay_ms;
-	unsigned int row_hold_ns;
-
-	bool wakeup;
-	bool rep;
-};
-
-#endif /*__PMIC8XXX_KEYPAD_H__ */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

