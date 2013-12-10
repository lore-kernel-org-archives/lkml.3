Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3LJXn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:43:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38995 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3LJXnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:43:21 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: [PATCH 7/7] Input: pmic8xxx-keypad - Migrate to regmap APIs
Date: Tue, 10 Dec 2013 15:43:16 -0800
Message-Id: <1386718996-3733-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the regmap APIs for this driver instead of custom pm8xxx
APIs. This breaks this driver's dependency on the pm8xxx APIs and
allows us to easily port it to other bus protocols in the future.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/keyboard/pmic8xxx-keypad.c | 81 ++++++++++++--------------------
 1 file changed, 29 insertions(+), 52 deletions(-)

diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index 4e6bfbf..c6d3d21 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -19,8 +19,8 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/regmap.h>
 
-#include <linux/mfd/pm8xxx/core.h>
 #include <linux/mfd/pm8xxx/gpio.h>
 #include <linux/input/pmic8xxx-keypad.h>
 
@@ -87,6 +87,7 @@
  * struct pmic8xxx_kp - internal keypad data structure
  * @pdata - keypad platform data pointer
  * @input - input device pointer for keypad
+ * @regmap - regmap handle
  * @key_sense_irq - key press/release irq number
  * @key_stuck_irq - key stuck notification irq number
  * @keycodes - array to hold the key codes
@@ -98,6 +99,7 @@
 struct pmic8xxx_kp {
 	const struct pm8xxx_keypad_platform_data *pdata;
 	struct input_dev *input;
+	struct regmap *regmap;
 	int key_sense_irq;
 	int key_stuck_irq;
 
@@ -110,33 +112,6 @@ struct pmic8xxx_kp {
 	u8 ctrl_reg;
 };
 
-static int pmic8xxx_kp_write_u8(struct pmic8xxx_kp *kp,
-				 u8 data, u16 reg)
-{
-	int rc;
-
-	rc = pm8xxx_writeb(kp->dev->parent, reg, data);
-	return rc;
-}
-
-static int pmic8xxx_kp_read(struct pmic8xxx_kp *kp,
-				 u8 *data, u16 reg, unsigned num_bytes)
-{
-	int rc;
-
-	rc = pm8xxx_read_buf(kp->dev->parent, reg, data, num_bytes);
-	return rc;
-}
-
-static int pmic8xxx_kp_read_u8(struct pmic8xxx_kp *kp,
-				 u8 *data, u16 reg)
-{
-	int rc;
-
-	rc = pmic8xxx_kp_read(kp, data, reg, 1);
-	return rc;
-}
-
 static u8 pmic8xxx_col_state(struct pmic8xxx_kp *kp, u8 col)
 {
 	/* all keys pressed on that particular row? */
@@ -161,9 +136,9 @@ static u8 pmic8xxx_col_state(struct pmic8xxx_kp *kp, u8 col)
 static int pmic8xxx_chk_sync_read(struct pmic8xxx_kp *kp)
 {
 	int rc;
-	u8 scan_val;
+	unsigned int scan_val;
 
-	rc = pmic8xxx_kp_read_u8(kp, &scan_val, KEYP_SCAN);
+	rc = regmap_read(kp->regmap, KEYP_SCAN, &scan_val);
 	if (rc < 0) {
 		dev_err(kp->dev, "Error reading KEYP_SCAN reg, rc=%d\n", rc);
 		return rc;
@@ -171,7 +146,7 @@ static int pmic8xxx_chk_sync_read(struct pmic8xxx_kp *kp)
 
 	scan_val |= 0x1;
 
-	rc = pmic8xxx_kp_write_u8(kp, scan_val, KEYP_SCAN);
+	rc = regmap_write(kp->regmap, KEYP_SCAN, scan_val);
 	if (rc < 0) {
 		dev_err(kp->dev, "Error writing KEYP_SCAN reg, rc=%d\n", rc);
 		return rc;
@@ -187,26 +162,24 @@ static int pmic8xxx_kp_read_data(struct pmic8xxx_kp *kp, u16 *state,
 					u16 data_reg, int read_rows)
 {
 	int rc, row;
-	u8 new_data[PM8XXX_MAX_ROWS];
+	unsigned int val;
 
-	rc = pmic8xxx_kp_read(kp, new_data, data_reg, read_rows);
-	if (rc)
-		return rc;
-
-	for (row = 0; row < kp->pdata->num_rows; row++) {
-		dev_dbg(kp->dev, "new_data[%d] = %d\n", row,
-					new_data[row]);
-		state[row] = pmic8xxx_col_state(kp, new_data[row]);
+	for (row = 0; row < read_rows; row++) {
+		rc = regmap_read(kp->regmap, data_reg, &val);
+		if (rc)
+			return rc;
+		dev_dbg(kp->dev, "%d = %d\n", row, val);
+		state[row] = pmic8xxx_col_state(kp, val);
 	}
 
-	return rc;
+	return 0;
 }
 
 static int pmic8xxx_kp_read_matrix(struct pmic8xxx_kp *kp, u16 *new_state,
 					 u16 *old_state)
 {
 	int rc, read_rows;
-	u8 scan_val;
+	unsigned int scan_val;
 
 	if (kp->pdata->num_rows < PM8XXX_MIN_ROWS)
 		read_rows = PM8XXX_MIN_ROWS;
@@ -236,14 +209,14 @@ static int pmic8xxx_kp_read_matrix(struct pmic8xxx_kp *kp, u16 *new_state,
 	/* 4 * 32KHz clocks */
 	udelay((4 * DIV_ROUND_UP(USEC_PER_SEC, KEYP_CLOCK_FREQ)) + 1);
 
-	rc = pmic8xxx_kp_read_u8(kp, &scan_val, KEYP_SCAN);
+	rc = regmap_read(kp->regmap, KEYP_SCAN, &scan_val);
 	if (rc < 0) {
 		dev_err(kp->dev, "Error reading KEYP_SCAN reg, rc=%d\n", rc);
 		return rc;
 	}
 
 	scan_val &= 0xFE;
-	rc = pmic8xxx_kp_write_u8(kp, scan_val, KEYP_SCAN);
+	rc = regmap_write(kp->regmap, KEYP_SCAN, scan_val);
 	if (rc < 0)
 		dev_err(kp->dev, "Error writing KEYP_SCAN reg, rc=%d\n", rc);
 
@@ -379,10 +352,10 @@ static irqreturn_t pmic8xxx_kp_stuck_irq(int irq, void *data)
 static irqreturn_t pmic8xxx_kp_irq(int irq, void *data)
 {
 	struct pmic8xxx_kp *kp = data;
-	u8 ctrl_val, events;
+	unsigned int ctrl_val, events;
 	int rc;
 
-	rc = pmic8xxx_kp_read(kp, &ctrl_val, KEYP_CTRL, 1);
+	rc = regmap_read(kp->regmap, KEYP_CTRL, &ctrl_val);
 	if (rc < 0) {
 		dev_err(kp->dev, "failed to read keyp_ctrl register\n");
 		return IRQ_HANDLED;
@@ -421,7 +394,7 @@ static int pmic8xxx_kpd_init(struct pmic8xxx_kp *kp)
 
 	ctrl_val |= (bits << KEYP_CTRL_SCAN_ROWS_SHIFT);
 
-	rc = pmic8xxx_kp_write_u8(kp, ctrl_val, KEYP_CTRL);
+	rc = regmap_write(kp->regmap, KEYP_CTRL, ctrl_val);
 	if (rc < 0) {
 		dev_err(kp->dev, "Error writing KEYP_CTRL reg, rc=%d\n", rc);
 		return rc;
@@ -439,7 +412,7 @@ static int pmic8xxx_kpd_init(struct pmic8xxx_kp *kp)
 
 	scan_val |= (cycles << KEYP_SCAN_ROW_HOLD_SHIFT);
 
-	rc = pmic8xxx_kp_write_u8(kp, scan_val, KEYP_SCAN);
+	rc = regmap_write(kp->regmap, KEYP_SCAN, scan_val);
 	if (rc)
 		dev_err(kp->dev, "Error writing KEYP_SCAN reg, rc=%d\n", rc);
 
@@ -474,7 +447,7 @@ static int pmic8xxx_kp_enable(struct pmic8xxx_kp *kp)
 
 	kp->ctrl_reg |= KEYP_CTRL_KEYP_EN;
 
-	rc = pmic8xxx_kp_write_u8(kp, kp->ctrl_reg, KEYP_CTRL);
+	rc = regmap_write(kp->regmap, KEYP_CTRL, kp->ctrl_reg);
 	if (rc < 0)
 		dev_err(kp->dev, "Error writing KEYP_CTRL reg, rc=%d\n", rc);
 
@@ -487,7 +460,7 @@ static int pmic8xxx_kp_disable(struct pmic8xxx_kp *kp)
 
 	kp->ctrl_reg &= ~KEYP_CTRL_KEYP_EN;
 
-	rc = pmic8xxx_kp_write_u8(kp, kp->ctrl_reg, KEYP_CTRL);
+	rc = regmap_write(kp->regmap, KEYP_CTRL, kp->ctrl_reg);
 	if (rc < 0)
 		return rc;
 
@@ -525,7 +498,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 	const struct matrix_keymap_data *keymap_data;
 	struct pmic8xxx_kp *kp;
 	int rc;
-	u8 ctrl_val;
+	unsigned int ctrl_val;
 
 	struct pm_gpio kypd_drv = {
 		.direction	= PM_GPIO_DIR_OUT,
@@ -590,6 +563,10 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 	if (!kp)
 		return -ENOMEM;
 
+	kp->regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	if (!kp->regmap)
+		return -ENODEV;
+
 	platform_set_drvdata(pdev, kp);
 
 	kp->pdata	= pdata;
@@ -678,7 +655,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 		return rc;
 	}
 
-	rc = pmic8xxx_kp_read_u8(kp, &ctrl_val, KEYP_CTRL);
+	rc = regmap_read(kp->regmap, KEYP_CTRL, &ctrl_val);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "failed to read KEYP_CTRL register\n");
 		return rc;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

