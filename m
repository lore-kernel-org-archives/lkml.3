Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaJGJvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:51:25 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54135 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbaJGJut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:50:49 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/4] Input: pmic8xxx-keypad - use regmap_field for register access
Date: Tue,  7 Oct 2014 12:50:46 +0300
Message-Id: <1412675448-11990-3-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract access to bit and register definitions to simplify adding
support for similar controller, which be found on SPMI based pm8941.

Group hardware capabilities to controller specific structure, and
pass it to driver, based on compatible string.

Pre-compute minimum number of rows and columns to avoid runtime checks.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/input/keyboard/pmic8xxx-keypad.c | 260 ++++++++++++++++++-------------
 1 file changed, 154 insertions(+), 106 deletions(-)

diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index dd1fc95..b82d161 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -21,6 +21,7 @@
 #include <linux/mutex.h>
 #include <linux/regmap.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/input/matrix_keypad.h>
 
 #define PM8XXX_MAX_ROWS		18
@@ -28,9 +29,6 @@
 #define PM8XXX_ROW_SHIFT	3
 #define PM8XXX_MATRIX_MAX_SIZE	(PM8XXX_MAX_ROWS * PM8XXX_MAX_COLS)
 
-#define PM8XXX_MIN_ROWS		5
-#define PM8XXX_MIN_COLS		5
-
 #define MAX_SCAN_DELAY		128
 #define MIN_SCAN_DELAY		1
 
@@ -41,34 +39,34 @@
 #define MAX_DEBOUNCE_TIME	20
 #define MIN_DEBOUNCE_TIME	5
 
-#define KEYP_CTRL			0x148
-
-#define KEYP_CTRL_EVNTS_MASK		0x3
-
-#define KEYP_CTRL_SCAN_COLS_SHIFT	5
-#define KEYP_CTRL_SCAN_COLS_MIN		5
-#define KEYP_CTRL_SCAN_COLS_BITS	0x3
-
-#define KEYP_CTRL_SCAN_ROWS_SHIFT	2
-#define KEYP_CTRL_SCAN_ROWS_MIN		5
-#define KEYP_CTRL_SCAN_ROWS_BITS	0x7
-
-#define KEYP_CTRL_KEYP_EN		BIT(7)
-
-#define KEYP_SCAN			0x149
-
-#define KEYP_SCAN_DBOUNCE_SHIFT		1
-#define KEYP_SCAN_PAUSE_SHIFT		3
-#define KEYP_SCAN_ROW_HOLD_SHIFT	6
-
-/* bits of these registers represent
- * '0' for key press
- * '1' for key release
- */
-#define KEYP_RECENT_DATA		0x14B
-#define KEYP_OLD_DATA			0x14C
-
-#define KEYP_CLOCK_FREQ			32768
+#define KEYP_CLOCK_FREQ		32768
+
+/* Keypad capabilities and registers description */
+struct pmic8xxx_kp_info {
+	unsigned int max_rows;
+	unsigned int min_rows;
+	unsigned int max_cols;
+	unsigned int min_cols;
+
+	unsigned int rows_select[PM8XXX_MAX_ROWS];
+	/*
+	 * bits of these registers represent
+	 * '0' for key press
+	 * '1' for key release
+	 */
+	unsigned int recent_data;
+	unsigned int old_data;
+	unsigned int read_stride;
+
+	struct reg_field events;
+	struct reg_field scan_rows;
+	struct reg_field scan_cols;
+	struct reg_field enable;
+	struct reg_field read_state;
+	struct reg_field dbonce;
+	struct reg_field pause;
+	struct reg_field row_hold;
+};
 
 /**
  * struct pmic8xxx_kp - internal keypad data structure
@@ -98,7 +96,44 @@ struct pmic8xxx_kp {
 	u16 keystate[PM8XXX_MAX_ROWS];
 	u16 stuckstate[PM8XXX_MAX_ROWS];
 
-	u8 ctrl_reg;
+	struct regmap_field *events;
+	struct regmap_field *scan_rows;
+	struct regmap_field *scan_cols;
+	struct regmap_field *enable;
+	struct regmap_field *read_state;
+	struct regmap_field *dbonce;
+	struct regmap_field *pause;
+	struct regmap_field *row_hold;
+
+	unsigned int recent_data;
+	unsigned int old_data;
+	unsigned int read_stride;
+};
+
+static const struct pmic8xxx_kp_info ssbi_kp = {
+	.max_rows	= 18,
+	.min_rows	= 5,
+	.max_cols	= 8,
+	.min_cols	= 5,
+
+	.rows_select = {
+		0, 1, 2, 3, 4, 4, 5,
+		5, 6, 6, 6, 7, 7, 7,
+	},
+
+	.recent_data	= 0x14b,
+	.old_data	= 0x14c,
+	.read_stride	= 0,
+
+	.events		= REG_FIELD(0x148, 0, 1),
+	.scan_rows	= REG_FIELD(0x148, 2, 4),
+	.scan_cols	= REG_FIELD(0x148, 5, 6),
+	.enable		= REG_FIELD(0x148, 7, 7),
+
+	.read_state	= REG_FIELD(0x149, 0, 0),
+	.dbonce		= REG_FIELD(0x149, 1, 2),
+	.pause		= REG_FIELD(0x149, 3, 5),
+	.row_hold	= REG_FIELD(0x149, 6, 7),
 };
 
 static u8 pmic8xxx_col_state(struct pmic8xxx_kp *kp, u8 col)
@@ -125,17 +160,8 @@ static u8 pmic8xxx_col_state(struct pmic8xxx_kp *kp, u8 col)
 static int pmic8xxx_chk_sync_read(struct pmic8xxx_kp *kp)
 {
 	int rc;
-	unsigned int scan_val;
-
-	rc = regmap_read(kp->regmap, KEYP_SCAN, &scan_val);
-	if (rc < 0) {
-		dev_err(kp->dev, "Error reading KEYP_SCAN reg, rc=%d\n", rc);
-		return rc;
-	}
-
-	scan_val |= 0x1;
 
-	rc = regmap_write(kp->regmap, KEYP_SCAN, scan_val);
+	rc = regmap_field_write(kp->read_state, 1);
 	if (rc < 0) {
 		dev_err(kp->dev, "Error writing KEYP_SCAN reg, rc=%d\n", rc);
 		return rc;
@@ -151,10 +177,11 @@ static int pmic8xxx_kp_read_data(struct pmic8xxx_kp *kp, u16 *state,
 					u16 data_reg, int read_rows)
 {
 	int rc, row;
-	unsigned int val;
+	unsigned int val, offset;
 
 	for (row = 0; row < read_rows; row++) {
-		rc = regmap_read(kp->regmap, data_reg, &val);
+		offset = data_reg + row * kp->read_stride;
+		rc = regmap_read(kp->regmap, offset, &val);
 		if (rc)
 			return rc;
 		dev_dbg(kp->dev, "%d = %d\n", row, val);
@@ -168,17 +195,13 @@ static int pmic8xxx_kp_read_matrix(struct pmic8xxx_kp *kp, u16 *new_state,
 					 u16 *old_state)
 {
 	int rc, read_rows;
-	unsigned int scan_val;
 
-	if (kp->num_rows < PM8XXX_MIN_ROWS)
-		read_rows = PM8XXX_MIN_ROWS;
-	else
-		read_rows = kp->num_rows;
+	read_rows = kp->num_rows;
 
 	pmic8xxx_chk_sync_read(kp);
 
 	if (old_state) {
-		rc = pmic8xxx_kp_read_data(kp, old_state, KEYP_OLD_DATA,
+		rc = pmic8xxx_kp_read_data(kp, old_state, kp->old_data,
 						read_rows);
 		if (rc < 0) {
 			dev_err(kp->dev,
@@ -187,7 +210,7 @@ static int pmic8xxx_kp_read_matrix(struct pmic8xxx_kp *kp, u16 *new_state,
 		}
 	}
 
-	rc = pmic8xxx_kp_read_data(kp, new_state, KEYP_RECENT_DATA,
+	rc = pmic8xxx_kp_read_data(kp, new_state, kp->recent_data,
 					 read_rows);
 	if (rc < 0) {
 		dev_err(kp->dev,
@@ -198,14 +221,7 @@ static int pmic8xxx_kp_read_matrix(struct pmic8xxx_kp *kp, u16 *new_state,
 	/* 4 * 32KHz clocks */
 	udelay((4 * DIV_ROUND_UP(USEC_PER_SEC, KEYP_CLOCK_FREQ)) + 1);
 
-	rc = regmap_read(kp->regmap, KEYP_SCAN, &scan_val);
-	if (rc < 0) {
-		dev_err(kp->dev, "Error reading KEYP_SCAN reg, rc=%d\n", rc);
-		return rc;
-	}
-
-	scan_val &= 0xFE;
-	rc = regmap_write(kp->regmap, KEYP_SCAN, scan_val);
+	rc = regmap_field_write(kp->read_state, 0);
 	if (rc < 0)
 		dev_err(kp->dev, "Error writing KEYP_SCAN reg, rc=%d\n", rc);
 
@@ -341,17 +357,15 @@ static irqreturn_t pmic8xxx_kp_stuck_irq(int irq, void *data)
 static irqreturn_t pmic8xxx_kp_irq(int irq, void *data)
 {
 	struct pmic8xxx_kp *kp = data;
-	unsigned int ctrl_val, events;
+	unsigned int events;
 	int rc;
 
-	rc = regmap_read(kp->regmap, KEYP_CTRL, &ctrl_val);
+	rc = regmap_field_read(kp->events, &events);
 	if (rc < 0) {
 		dev_err(kp->dev, "failed to read keyp_ctrl register\n");
 		return IRQ_HANDLED;
 	}
 
-	events = ctrl_val & KEYP_CTRL_EVNTS_MASK;
-
 	rc = pmic8xxx_kp_scan_matrix(kp, events);
 	if (rc < 0)
 		dev_err(kp->dev, "failed to scan matrix\n");
@@ -360,35 +374,28 @@ static irqreturn_t pmic8xxx_kp_irq(int irq, void *data)
 }
 
 static int pmic8xxx_kpd_init(struct pmic8xxx_kp *kp,
-			     struct platform_device *pdev)
+			     struct platform_device *pdev,
+			     const struct pmic8xxx_kp_info *info)
 {
 	const struct device_node *of_node = pdev->dev.of_node;
 	unsigned int scan_delay_ms;
 	unsigned int row_hold_ns;
 	unsigned int debounce_ms;
 	int bits, rc, cycles;
-	u8 scan_val = 0, ctrl_val = 0;
-	static const u8 row_bits[] = {
-		0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7,
-	};
 
 	/* Find column bits */
-	if (kp->num_cols < KEYP_CTRL_SCAN_COLS_MIN)
-		bits = 0;
-	else
-		bits = kp->num_cols - KEYP_CTRL_SCAN_COLS_MIN;
-	ctrl_val = (bits & KEYP_CTRL_SCAN_COLS_BITS) <<
-		KEYP_CTRL_SCAN_COLS_SHIFT;
+	bits = kp->num_cols - info->min_cols;
 
-	/* Find row bits */
-	if (kp->num_rows < KEYP_CTRL_SCAN_ROWS_MIN)
-		bits = 0;
-	else
-		bits = row_bits[kp->num_rows - KEYP_CTRL_SCAN_ROWS_MIN];
+	rc = regmap_field_write(kp->scan_cols, bits);
+	if (rc < 0) {
+		dev_err(kp->dev, "Error writing KEYP_CTRL reg, rc=%d\n", rc);
+		return rc;
+	}
 
-	ctrl_val |= (bits << KEYP_CTRL_SCAN_ROWS_SHIFT);
+	/* Find row bits */
+	bits = info->rows_select[kp->num_rows - info->min_rows];
 
-	rc = regmap_write(kp->regmap, KEYP_CTRL, ctrl_val);
+	rc = regmap_field_write(kp->scan_rows, bits);
 	if (rc < 0) {
 		dev_err(kp->dev, "Error writing KEYP_CTRL reg, rc=%d\n", rc);
 		return rc;
@@ -425,17 +432,20 @@ static int pmic8xxx_kpd_init(struct pmic8xxx_kp *kp,
 
 	bits = (debounce_ms / 5) - 1;
 
-	scan_val |= (bits << KEYP_SCAN_DBOUNCE_SHIFT);
+	rc = regmap_field_write(kp->dbonce, bits);
+	if (rc)
+		dev_err(kp->dev, "Error writing KEYP_SCAN reg, rc=%d\n", rc);
 
 	bits = fls(scan_delay_ms) - 1;
-	scan_val |= (bits << KEYP_SCAN_PAUSE_SHIFT);
+
+	rc = regmap_field_write(kp->pause, bits);
+	if (rc)
+		dev_err(kp->dev, "Error writing KEYP_SCAN reg, rc=%d\n", rc);
 
 	/* Row hold time is a multiple of 32KHz cycles. */
 	cycles = (row_hold_ns * KEYP_CLOCK_FREQ) / NSEC_PER_SEC;
 
-	scan_val |= (cycles << KEYP_SCAN_ROW_HOLD_SHIFT);
-
-	rc = regmap_write(kp->regmap, KEYP_SCAN, scan_val);
+	rc = regmap_field_write(kp->row_hold, cycles);
 	if (rc)
 		dev_err(kp->dev, "Error writing KEYP_SCAN reg, rc=%d\n", rc);
 
@@ -447,9 +457,7 @@ static int pmic8xxx_kp_enable(struct pmic8xxx_kp *kp)
 {
 	int rc;
 
-	kp->ctrl_reg |= KEYP_CTRL_KEYP_EN;
-
-	rc = regmap_write(kp->regmap, KEYP_CTRL, kp->ctrl_reg);
+	rc = regmap_field_write(kp->enable, 1);
 	if (rc < 0)
 		dev_err(kp->dev, "Error writing KEYP_CTRL reg, rc=%d\n", rc);
 
@@ -460,9 +468,7 @@ static int pmic8xxx_kp_disable(struct pmic8xxx_kp *kp)
 {
 	int rc;
 
-	kp->ctrl_reg &= ~KEYP_CTRL_KEYP_EN;
-
-	rc = regmap_write(kp->regmap, KEYP_CTRL, kp->ctrl_reg);
+	rc = regmap_field_write(kp->enable, 0);
 	if (rc < 0)
 		return rc;
 
@@ -483,6 +489,8 @@ static void pmic8xxx_kp_close(struct input_dev *dev)
 	pmic8xxx_kp_disable(kp);
 }
 
+static const struct of_device_id pm8xxx_match_table[];
+
 /*
  * keypad controller should be initialized in the following sequence
  * only, otherwise it might get into FSM stuck state.
@@ -495,19 +503,22 @@ static void pmic8xxx_kp_close(struct input_dev *dev)
  */
 static int pmic8xxx_kp_probe(struct platform_device *pdev)
 {
+	const struct pmic8xxx_kp_info *info;
+	const struct of_device_id *id;
 	unsigned int rows, cols;
 	bool repeat;
 	bool wakeup;
 	struct pmic8xxx_kp *kp;
 	int rc;
-	unsigned int ctrl_val;
+
+	id = of_match_device(pm8xxx_match_table, &pdev->dev);
+	info = (const struct pmic8xxx_kp_info *)id->data;
 
 	rc = matrix_keypad_parse_of_params(&pdev->dev, &rows, &cols);
 	if (rc)
 		return rc;
 
-	if (cols > PM8XXX_MAX_COLS || rows > PM8XXX_MAX_ROWS ||
-	    cols < PM8XXX_MIN_COLS) {
+	if (cols > info->max_cols || rows > info->max_rows) {
 		dev_err(&pdev->dev, "invalid platform data\n");
 		return -EINVAL;
 	}
@@ -527,10 +538,55 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, kp);
 
+	if (rows < info->min_rows)
+		rows = info->min_rows;
+
+	if (cols < info->min_cols)
+		cols = info->min_cols;
+
 	kp->num_rows	= rows;
 	kp->num_cols	= cols;
 	kp->dev		= &pdev->dev;
 
+	kp->events = devm_regmap_field_alloc(kp->dev, kp->regmap,
+					     info->events);
+	if (IS_ERR(kp->events))
+		return PTR_ERR(kp->events);
+
+	kp->scan_rows = devm_regmap_field_alloc(kp->dev, kp->regmap,
+						info->scan_rows);
+	if (IS_ERR(kp->scan_rows))
+		return PTR_ERR(kp->scan_rows);
+
+	kp->scan_cols = devm_regmap_field_alloc(kp->dev, kp->regmap,
+						info->scan_cols);
+	if (IS_ERR(kp->scan_cols))
+		return PTR_ERR(kp->scan_cols);
+
+	kp->enable = devm_regmap_field_alloc(kp->dev, kp->regmap,
+					     info->enable);
+	if (IS_ERR(kp->enable))
+		return PTR_ERR(kp->enable);
+
+	kp->read_state = devm_regmap_field_alloc(kp->dev, kp->regmap,
+						 info->read_state);
+	if (IS_ERR(kp->read_state))
+		return PTR_ERR(kp->read_state);
+
+	kp->dbonce = devm_regmap_field_alloc(kp->dev, kp->regmap,
+					     info->dbonce);
+	if (IS_ERR(kp->dbonce))
+		return PTR_ERR(kp->dbonce);
+
+	kp->pause = devm_regmap_field_alloc(kp->dev, kp->regmap, info->pause);
+	if (IS_ERR(kp->pause))
+		return PTR_ERR(kp->pause);
+
+	kp->row_hold = devm_regmap_field_alloc(kp->dev, kp->regmap,
+					       info->row_hold);
+	if (IS_ERR(kp->row_hold))
+		return PTR_ERR(kp->row_hold);
+
 	kp->input = devm_input_allocate_device(&pdev->dev);
 	if (!kp->input) {
 		dev_err(&pdev->dev, "unable to allocate input device\n");
@@ -578,7 +634,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 	memset(kp->keystate, 0xff, sizeof(kp->keystate));
 	memset(kp->stuckstate, 0xff, sizeof(kp->stuckstate));
 
-	rc = pmic8xxx_kpd_init(kp, pdev);
+	rc = pmic8xxx_kpd_init(kp, pdev, info);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "unable to initialize keypad controller\n");
 		return rc;
@@ -600,14 +656,6 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 		return rc;
 	}
 
-	rc = regmap_read(kp->regmap, KEYP_CTRL, &ctrl_val);
-	if (rc < 0) {
-		dev_err(&pdev->dev, "failed to read KEYP_CTRL register\n");
-		return rc;
-	}
-
-	kp->ctrl_reg = ctrl_val;
-
 	rc = input_register_device(kp->input);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "unable to register keypad input device\n");
@@ -665,8 +713,8 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_kp_pm_ops,
 			 pmic8xxx_kp_suspend, pmic8xxx_kp_resume);
 
 static const struct of_device_id pm8xxx_match_table[] = {
-	{ .compatible = "qcom,pm8058-keypad" },
-	{ .compatible = "qcom,pm8921-keypad" },
+	{ .compatible = "qcom,pm8058-keypad", .data = (void *)&ssbi_kp },
+	{ .compatible = "qcom,pm8921-keypad", .data = (void *)&ssbi_kp },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, pm8xxx_match_table);
-- 
1.9.1

