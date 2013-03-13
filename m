Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab3CMRQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:16:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12913 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab3CMRQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:16:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Mar 2013 10:16:35 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dmitry.torokhov@gmail.com>
CC: <swarren@wwwdotorg.org>, <linux-input@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] input: keyboard: tegra: support for defining row/columns based on SoC
Date: Wed, 13 Mar 2013 22:44:33 +0530
Message-ID: <1363194873-13723-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra20 and Tegra30 supports the 16x8 keyboard matrix and T114
support the 11x8 Key matrix.

Add support for defining the maximum row/columns based on SoC through
proper compatibity.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
Changes from V1:
- cleanup changes as suggested by Stephen
- rename variable "max_row_colums" to num_rows_and_columns.
- Better write error message.
- Remove non-require () in expression.

 drivers/input/keyboard/tegra-kbc.c |   81 +++++++++++++++++++++++++++--------
 1 files changed, 62 insertions(+), 19 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 0e138eb..72b06ad 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -27,17 +27,18 @@
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/clk/tegra.h>
 
-#define KBC_MAX_GPIO	24
 #define KBC_MAX_KPENT	8
 
-#define KBC_MAX_ROW	16
-#define KBC_MAX_COL	8
-#define KBC_MAX_KEY	(KBC_MAX_ROW * KBC_MAX_COL)
+/* Maximum row/column supported by Tegra KBC yet  is 16x8 */
+#define KBC_MAX_GPIO	24
+/* Maximum keys supported by Tegra KBC yet is 16 x 8*/
+#define KBC_MAX_KEY	(16 * 8)
 
 #define KBC_MAX_DEBOUNCE_CNT	0x3ffu
 
@@ -80,6 +81,12 @@ enum tegra_pin_type {
 	PIN_CFG_ROW,
 };
 
+/* Tegra KBC hw support */
+struct tegra_kbc_hw_support {
+	int max_rows;
+	int max_columns;
+};
+
 struct tegra_kbc_pin_cfg {
 	enum tegra_pin_type type;
 	unsigned char num;
@@ -108,6 +115,9 @@ struct tegra_kbc {
 	u32 wakeup_key;
 	struct timer_list timer;
 	struct clk *clk;
+	const struct tegra_kbc_hw_support *hw_support;
+	int max_keys;
+	int num_rows_and_columns;
 };
 
 static void tegra_kbc_report_released_keys(struct input_dev *input,
@@ -204,11 +214,11 @@ static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
 
 	/*
 	 * If the platform uses Fn keymaps, translate keys on a Fn keypress.
-	 * Function keycodes are KBC_MAX_KEY apart from the plain keycodes.
+	 * Function keycodes are max_keys apart from the plain keycodes.
 	 */
 	if (fn_keypress) {
 		for (i = 0; i < num_down; i++) {
-			scancodes[i] += KBC_MAX_KEY;
+			scancodes[i] += kbc->max_keys;
 			keycodes[i] = kbc->keycode[scancodes[i]];
 		}
 	}
@@ -315,7 +325,7 @@ static void tegra_kbc_setup_wakekeys(struct tegra_kbc *kbc, bool filter)
 	/* Either mask all keys or none. */
 	rst_val = (filter && !kbc->wakeup) ? ~0 : 0;
 
-	for (i = 0; i < KBC_MAX_ROW; i++)
+	for (i = 0; i < kbc->hw_support->max_rows; i++)
 		writel(rst_val, kbc->mmio + KBC_ROW0_MASK_0 + i * 4);
 }
 
@@ -452,7 +462,7 @@ static bool tegra_kbc_check_pin_cfg(const struct tegra_kbc *kbc,
 
 		switch (pin_cfg->type) {
 		case PIN_CFG_ROW:
-			if (pin_cfg->num >= KBC_MAX_ROW) {
+			if (pin_cfg->num >= kbc->hw_support->max_rows) {
 				dev_err(kbc->dev,
 					"pin_cfg[%d]: invalid row number %d\n",
 					i, pin_cfg->num);
@@ -462,7 +472,7 @@ static bool tegra_kbc_check_pin_cfg(const struct tegra_kbc *kbc,
 			break;
 
 		case PIN_CFG_COL:
-			if (pin_cfg->num >= KBC_MAX_COL) {
+			if (pin_cfg->num >= kbc->hw_support->max_columns) {
 				dev_err(kbc->dev,
 					"pin_cfg[%d]: invalid column number %d\n",
 					i, pin_cfg->num);
@@ -520,6 +530,18 @@ static int tegra_kbc_parse_dt(struct tegra_kbc *kbc)
 	}
 	num_cols = proplen / sizeof(u32);
 
+	if (num_rows > kbc->hw_support->max_rows) {
+		dev_err(kbc->dev,
+			"Number of rows is more than supported by hardware\n");
+		return -EINVAL;
+	}
+
+	if (num_cols > kbc->hw_support->max_columns) {
+		dev_err(kbc->dev,
+			"Number of cols is more than supported by hardware\n");
+		return -EINVAL;
+	}
+
 	if (!of_get_property(np, "linux,keymap", &proplen)) {
 		dev_err(kbc->dev, "property linux,keymap not found\n");
 		return -ENOENT;
@@ -532,7 +554,7 @@ static int tegra_kbc_parse_dt(struct tegra_kbc *kbc)
 	}
 
 	/* Set all pins as non-configured */
-	for (i = 0; i < KBC_MAX_GPIO; i++)
+	for (i = 0; i < kbc->num_rows_and_columns; ++i)
 		kbc->pin_cfg[i].type = PIN_CFG_IGNORE;
 
 	ret = of_property_read_u32_array(np, "nvidia,kbc-row-pins",
@@ -562,6 +584,24 @@ static int tegra_kbc_parse_dt(struct tegra_kbc *kbc)
 	return 0;
 }
 
+static const struct tegra_kbc_hw_support tegra20_kbc_hw_support = {
+	.max_rows	= 16,
+	.max_columns	= 8,
+};
+
+static const struct tegra_kbc_hw_support tegra11_kbc_hw_support = {
+	.max_rows	= 11,
+	.max_columns	= 8,
+};
+
+static const struct of_device_id tegra_kbc_of_match[] = {
+	{ .compatible = "nvidia,tegra114-kbc", .data = &tegra11_kbc_hw_support},
+	{ .compatible = "nvidia,tegra30-kbc", .data = &tegra20_kbc_hw_support},
+	{ .compatible = "nvidia,tegra20-kbc", .data = &tegra20_kbc_hw_support},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_kbc_of_match);
+
 static int tegra_kbc_probe(struct platform_device *pdev)
 {
 	struct tegra_kbc *kbc;
@@ -570,7 +610,10 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	int num_rows = 0;
 	unsigned int debounce_cnt;
 	unsigned int scan_time_rows;
-	unsigned int keymap_rows = KBC_MAX_KEY;
+	unsigned int keymap_rows;
+	const struct of_device_id *match;
+
+	match = of_match_device(of_match_ptr(tegra_kbc_of_match), &pdev->dev);
 
 	kbc = devm_kzalloc(&pdev->dev, sizeof(*kbc), GFP_KERNEL);
 	if (!kbc) {
@@ -579,6 +622,12 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	}
 
 	kbc->dev = &pdev->dev;
+	kbc->hw_support = match->data;
+	kbc->max_keys = kbc->hw_support->max_rows *
+				kbc->hw_support->max_columns;
+	kbc->num_rows_and_columns = kbc->hw_support->max_rows +
+					kbc->hw_support->max_columns;
+	keymap_rows = kbc->max_keys;
 	spin_lock_init(&kbc->lock);
 
 	err = tegra_kbc_parse_dt(kbc);
@@ -641,8 +690,8 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 		keymap_rows *= 2;
 
 	err = matrix_keypad_build_keymap(kbc->keymap_data, NULL,
-					 keymap_rows, KBC_MAX_COL,
-					 kbc->keycode, kbc->idev);
+				 keymap_rows, kbc->hw_support->max_columns,
+				 kbc->keycode, kbc->idev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to setup keymap\n");
 		return err;
@@ -767,12 +816,6 @@ static int tegra_kbc_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(tegra_kbc_pm_ops, tegra_kbc_suspend, tegra_kbc_resume);
 
-static const struct of_device_id tegra_kbc_of_match[] = {
-	{ .compatible = "nvidia,tegra20-kbc", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, tegra_kbc_of_match);
-
 static struct platform_driver tegra_kbc_driver = {
 	.probe		= tegra_kbc_probe,
 	.driver	= {
-- 
1.7.1.1

