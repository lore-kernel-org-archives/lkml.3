Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160Ab3DIIhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:37:05 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:39170 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932892Ab3DIIhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:37:01 -0400
From: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Subject: [PATCH 2/3] input: keyboard: support stmpe1801 18 bits enhanced port expander
Date: Tue, 9 Apr 2013 10:35:20 +0200
Message-ID: <1365496521-16880-2-git-send-email-jean-nicolas.graux@stericsson.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1365496521-16880-1-git-send-email-jean-nicolas.graux@stericsson.com>
References: <1365496521-16880-1-git-send-email-jean-nicolas.graux@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides support for 1801 variant of stmpe gpio port expanders.
This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
special key or dedicated key function.

Note that special/dedicated key function is not supported yet.

Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
---
 drivers/input/keyboard/stmpe-keypad.c |  267 ++++++++++++++++++++++++++-------
 1 file changed, 211 insertions(+), 56 deletions(-)

diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
index 5cbec56..fb973c8 100644
--- a/drivers/input/keyboard/stmpe-keypad.c
+++ b/drivers/input/keyboard/stmpe-keypad.c
@@ -14,40 +14,107 @@
 #include <linux/input/matrix_keypad.h>
 #include <linux/mfd/stmpe.h>
 
-/* These are at the same addresses in all STMPE variants */
-#define STMPE_KPC_COL			0x60
-#define STMPE_KPC_ROW_MSB		0x61
-#define STMPE_KPC_ROW_LSB		0x62
-#define STMPE_KPC_CTRL_MSB		0x63
-#define STMPE_KPC_CTRL_LSB		0x64
-#define STMPE_KPC_COMBI_KEY_0		0x65
-#define STMPE_KPC_COMBI_KEY_1		0x66
-#define STMPE_KPC_COMBI_KEY_2		0x67
-#define STMPE_KPC_DATA_BYTE0		0x68
-#define STMPE_KPC_DATA_BYTE1		0x69
-#define STMPE_KPC_DATA_BYTE2		0x6a
-#define STMPE_KPC_DATA_BYTE3		0x6b
-#define STMPE_KPC_DATA_BYTE4		0x6c
+/* These are at the same addresses in most of STMPE variants */
+#define STMPE_REG_KPC_COL		0x60
+#define STMPE_REG_KPC_ROW_MSB		0x61
+#define STMPE_REG_KPC_ROW_LSB		0x62
+#define STMPE_REG_KPC_CTRL_MSB		0x63
+#define STMPE_REG_KPC_CTRL_LSB		0x64
+#define STMPE_REG_KPC_COMBI_KEY_0	0x65
+#define STMPE_REG_KPC_COMBI_KEY_1	0x66
+#define STMPE_REG_KPC_COMBI_KEY_2	0x67
+#define STMPE_REG_KPC_DATA_BYTE0	0x68
+#define STMPE_REG_KPC_DATA_BYTE1	0x69
+#define STMPE_REG_KPC_DATA_BYTE2	0x6a
+#define STMPE_REG_KPC_DATA_BYTE3	0x6b
+#define STMPE_REG_KPC_DATA_BYTE4	0x6c
 
 #define STMPE_KPC_CTRL_LSB_SCAN		(0x1 << 0)
 #define STMPE_KPC_CTRL_LSB_DEBOUNCE	(0x7f << 1)
 #define STMPE_KPC_CTRL_MSB_SCAN_COUNT	(0xf << 4)
 
+/* STMPE1801 */
+#define STMPE1801_REG_KPC_ROW		0x30
+#define STMPE1801_REG_KPC_COL_LOW	0x31
+#define STMPE1801_REG_KPC_COL_HIGH	0x32
+#define STMPE1801_REG_KPC_CTRL_LOW	0x33
+#define STMPE1801_REG_KPC_CTRL_MID	0x34
+#define STMPE1801_REG_KPC_CTRL_HIGH	0x35
+#define STMPE1801_REG_KPC_CMD		0x36
+#define STMPE1801_REG_KPC_COMBI_KEY_0	0x37
+#define STMPE1801_REG_KPC_COMBI_KEY_1	0x38
+#define STMPE1801_REG_KPC_COMBI_KEY_2	0x39
+#define STMPE1801_REG_KPC_DATA_BYTE0	0x3a
+#define STMPE1801_REG_KPC_DATA_BYTE1	0x3b
+#define STMPE1801_REG_KPC_DATA_BYTE2	0x3c
+#define STMPE1801_REG_KPC_DATA_BYTE3	0x3d
+#define STMPE1801_REG_KPC_DATA_BYTE4	0x3e
+
+#define STMPE1801_MSK_KPC_SCAN_COUNT	(0xf << 4)
+#define STMPE1801_MSK_KPC_DEBOUNCE	(0x3f << 2)
+#define STMPE1801_MSK_KPC_CMD_SCAN	(0x1 << 0)
+
 #define STMPE_KPC_ROW_MSB_ROWS		0xff
 
 #define STMPE_KPC_DATA_UP		(0x1 << 7)
-#define STMPE_KPC_DATA_ROW		(0xf << 3)
-#define STMPE_KPC_DATA_COL		(0x7 << 0)
+
 #define STMPE_KPC_DATA_NOKEY_MASK	0x78
 
 #define STMPE_KEYPAD_MAX_DEBOUNCE	127
 #define STMPE_KEYPAD_MAX_SCAN_COUNT	15
 
-#define STMPE_KEYPAD_MAX_ROWS		8
-#define STMPE_KEYPAD_MAX_COLS		8
-#define STMPE_KEYPAD_ROW_SHIFT		3
-#define STMPE_KEYPAD_KEYMAP_SIZE	\
-	(STMPE_KEYPAD_MAX_ROWS * STMPE_KEYPAD_MAX_COLS)
+enum {
+	STMPE_IDX_KPC_COL_LSB,
+	STMPE_IDX_KPC_COL_MSB,
+	STMPE_IDX_KPC_ROW_LSB,
+	STMPE_IDX_KPC_ROW_MSB,
+	STMPE_IDX_KPC_CTRL_LSB,
+	STMPE_IDX_KPC_CTRL_MID,
+	STMPE_IDX_KPC_CTRL_MSB,
+	STMPE_IDX_KPC_CMD,
+	STMPE_IDX_KPC_COMBI_KEY_0,
+	STMPE_IDX_KPC_COMBI_KEY_1,
+	STMPE_IDX_KPC_COMBI_KEY_2,
+	STMPE_IDX_KPC_DATA_BYTE0,
+	STMPE_IDX_KPC_DATA_BYTE1,
+	STMPE_IDX_KPC_DATA_BYTE2,
+	STMPE_IDX_KPC_DATA_BYTE3,
+	STMPE_IDX_KPC_DATA_BYTE4,
+};
+
+static const u8 stmpe_default_regs[] = {
+	[STMPE_IDX_KPC_COL_LSB]		= STMPE_REG_KPC_COL,
+	[STMPE_IDX_KPC_ROW_LSB]		= STMPE_REG_KPC_ROW_LSB,
+	[STMPE_IDX_KPC_ROW_MSB]		= STMPE_REG_KPC_ROW_MSB,
+	[STMPE_IDX_KPC_CTRL_LSB]	= STMPE_REG_KPC_CTRL_LSB,
+	[STMPE_IDX_KPC_CTRL_MSB]	= STMPE_REG_KPC_CTRL_MSB,
+	[STMPE_IDX_KPC_COMBI_KEY_0]	= STMPE_REG_KPC_COMBI_KEY_0,
+	[STMPE_IDX_KPC_COMBI_KEY_1]	= STMPE_REG_KPC_COMBI_KEY_1,
+	[STMPE_IDX_KPC_COMBI_KEY_2]	= STMPE_REG_KPC_COMBI_KEY_2,
+	[STMPE_IDX_KPC_DATA_BYTE0]	= STMPE_REG_KPC_DATA_BYTE0,
+	[STMPE_IDX_KPC_DATA_BYTE1]	= STMPE_REG_KPC_DATA_BYTE1,
+	[STMPE_IDX_KPC_DATA_BYTE2]	= STMPE_REG_KPC_DATA_BYTE2,
+	[STMPE_IDX_KPC_DATA_BYTE3]	= STMPE_REG_KPC_DATA_BYTE3,
+	[STMPE_IDX_KPC_DATA_BYTE4]	= STMPE_REG_KPC_DATA_BYTE4,
+};
+
+static const u8 stmpe_1801_regs[] = {
+	[STMPE_IDX_KPC_COL_LSB]		= STMPE1801_REG_KPC_COL_LOW,
+	[STMPE_IDX_KPC_COL_MSB]		= STMPE1801_REG_KPC_COL_HIGH,
+	[STMPE_IDX_KPC_ROW_LSB]		= STMPE1801_REG_KPC_ROW,
+	[STMPE_IDX_KPC_CTRL_LSB]	= STMPE1801_REG_KPC_CTRL_LOW,
+	[STMPE_IDX_KPC_CTRL_MID]	= STMPE1801_REG_KPC_CTRL_MID,
+	[STMPE_IDX_KPC_CTRL_MSB]	= STMPE1801_REG_KPC_CTRL_HIGH,
+	[STMPE_IDX_KPC_CMD]		= STMPE1801_REG_KPC_CMD,
+	[STMPE_IDX_KPC_COMBI_KEY_0]	= STMPE1801_REG_KPC_COMBI_KEY_0,
+	[STMPE_IDX_KPC_COMBI_KEY_1]	= STMPE1801_REG_KPC_COMBI_KEY_1,
+	[STMPE_IDX_KPC_COMBI_KEY_2]	= STMPE1801_REG_KPC_COMBI_KEY_2,
+	[STMPE_IDX_KPC_DATA_BYTE0]	= STMPE1801_REG_KPC_DATA_BYTE0,
+	[STMPE_IDX_KPC_DATA_BYTE1]	= STMPE1801_REG_KPC_DATA_BYTE1,
+	[STMPE_IDX_KPC_DATA_BYTE2]	= STMPE1801_REG_KPC_DATA_BYTE2,
+	[STMPE_IDX_KPC_DATA_BYTE3]	= STMPE1801_REG_KPC_DATA_BYTE3,
+	[STMPE_IDX_KPC_DATA_BYTE4]	= STMPE1801_REG_KPC_DATA_BYTE4,
+};
 
 /**
  * struct stmpe_keypad_variant - model-specific attributes
@@ -57,6 +124,10 @@
  * @num_normal_data: number of normal keys' data bytes
  * @max_cols: maximum number of columns supported
  * @max_rows: maximum number of rows supported
+ * @row_mask: mask used to get row number in KPC_DATA_BYTEx registers
+ * @col_mask: mask used to get column number in KPC_DATA_BYTEx registers
+ * @row_shift: shift used to get row number in KPC_DATA_BYTEx registers
+ * @col_shift: shift used to get column number in KPC_DATA_BYTEx registers
  * @col_gpios: bitmask of gpios which can be used for columns
  * @row_gpios: bitmask of gpios which can be used for rows
  */
@@ -66,8 +137,13 @@ struct stmpe_keypad_variant {
 	int		num_normal_data;
 	int		max_cols;
 	int		max_rows;
+	unsigned int	row_mask;
+	unsigned int	col_mask;
+	unsigned char	row_shift;
+	unsigned char	col_shift;
 	unsigned int	col_gpios;
 	unsigned int	row_gpios;
+	const u8	*regs;
 };
 
 static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
@@ -77,8 +153,27 @@ static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
 		.num_normal_data	= 3,
 		.max_cols		= 8,
 		.max_rows		= 8,
+		.row_mask		= (0xf << 3),
+		.row_shift		= 3,
+		.col_mask		= (0x7 << 0),
+		.col_shift		= 0,
 		.col_gpios		= 0x000ff,	/* GPIO 0 - 7 */
 		.row_gpios		= 0x0ff00,	/* GPIO 8 - 15 */
+		.regs			= stmpe_default_regs,
+	},
+	[STMPE1801] = {
+		.auto_increment		= true,
+		.num_data		= 5,
+		.num_normal_data	= 3,
+		.max_cols		= 10,
+		.max_rows		= 8,
+		.row_mask		= (0x7 << 0),
+		.row_shift		= 0,
+		.col_mask		= (0xf << 3),
+		.col_shift		= 3,
+		.col_gpios		= 0x3ff00,	/* GPIO 8 - 17 */
+		.row_gpios		= 0x000ff,	/* GPIO 0 - 7 */
+		.regs			= stmpe_1801_regs,
 	},
 	[STMPE2401] = {
 		.auto_increment		= false,
@@ -86,8 +181,13 @@ static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
 		.num_normal_data	= 2,
 		.max_cols		= 8,
 		.max_rows		= 12,
+		.row_mask		= (0xf << 3),
+		.row_shift		= 3,
+		.col_mask		= (0x7 << 0),
+		.col_shift		= 0,
 		.col_gpios		= 0x0000ff,	/* GPIO 0 - 7*/
 		.row_gpios		= 0x1fef00,	/* GPIO 8-14, 16-20 */
+		.regs			= stmpe_default_regs,
 	},
 	[STMPE2403] = {
 		.auto_increment		= true,
@@ -95,8 +195,13 @@ static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
 		.num_normal_data	= 3,
 		.max_cols		= 8,
 		.max_rows		= 12,
+		.row_mask		= (0xf << 3),
+		.row_shift		= 3,
+		.col_mask		= (0x7 << 0),
+		.col_shift		= 0,
 		.col_gpios		= 0x0000ff,	/* GPIO 0 - 7*/
 		.row_gpios		= 0x1fef00,	/* GPIO 8-14, 16-20 */
+		.regs			= stmpe_default_regs,
 	},
 };
 
@@ -108,8 +213,8 @@ struct stmpe_keypad {
 
 	unsigned int rows;
 	unsigned int cols;
-
-	unsigned short keymap[STMPE_KEYPAD_KEYMAP_SIZE];
+	unsigned char scan_code_row_shift;
+	unsigned short *keymap;
 };
 
 static int stmpe_keypad_read_data(struct stmpe_keypad *keypad, u8 *data)
@@ -120,11 +225,13 @@ static int stmpe_keypad_read_data(struct stmpe_keypad *keypad, u8 *data)
 	int i;
 
 	if (variant->auto_increment)
-		return stmpe_block_read(stmpe, STMPE_KPC_DATA_BYTE0,
-					variant->num_data, data);
+		return stmpe_block_read(stmpe,
+				variant->regs[STMPE_IDX_KPC_DATA_BYTE0],
+				variant->num_data, data);
 
 	for (i = 0; i < variant->num_data; i++) {
-		ret = stmpe_reg_read(stmpe, STMPE_KPC_DATA_BYTE0 + i);
+		ret = stmpe_reg_read(stmpe,
+				variant->regs[STMPE_IDX_KPC_DATA_BYTE0] + i);
 		if (ret < 0)
 			return ret;
 
@@ -149,9 +256,10 @@ static irqreturn_t stmpe_keypad_irq(int irq, void *dev)
 
 	for (i = 0; i < variant->num_normal_data; i++) {
 		u8 data = fifo[i];
-		int row = (data & STMPE_KPC_DATA_ROW) >> 3;
-		int col = data & STMPE_KPC_DATA_COL;
-		int code = MATRIX_SCAN_CODE(row, col, STMPE_KEYPAD_ROW_SHIFT);
+		int row = (data & variant->row_mask) >> variant->row_shift;
+		int col = (data & variant->col_mask) >> variant->col_shift;
+		int code = MATRIX_SCAN_CODE(row, col,
+				keypad->scan_code_row_shift);
 		bool up = data & STMPE_KPC_DATA_UP;
 
 		if ((data & STMPE_KPC_DATA_NOKEY_MASK)
@@ -228,43 +336,79 @@ static int stmpe_keypad_chip_init(struct stmpe_keypad *keypad)
 	if (ret < 0)
 		return ret;
 
-	ret = stmpe_reg_write(stmpe, STMPE_KPC_COL, keypad->cols);
+	ret = stmpe_reg_write(stmpe, variant->regs[STMPE_IDX_KPC_COL_LSB],
+			keypad->cols);
 	if (ret < 0)
 		return ret;
 
-	ret = stmpe_reg_write(stmpe, STMPE_KPC_ROW_LSB, keypad->rows);
+	if (stmpe->partnum == STMPE1801 && variant->max_cols > 8) {
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_COL_MSB],
+				0x3,
+				keypad->cols >> 8);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = stmpe_reg_write(stmpe, variant->regs[STMPE_IDX_KPC_ROW_LSB],
+			keypad->rows);
 	if (ret < 0)
 		return ret;
 
 	if (variant->max_rows > 8) {
-		ret = stmpe_set_bits(stmpe, STMPE_KPC_ROW_MSB,
-				     STMPE_KPC_ROW_MSB_ROWS,
-				     keypad->rows >> 8);
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_ROW_MSB],
+				STMPE_KPC_ROW_MSB_ROWS,
+				keypad->rows >> 8);
 		if (ret < 0)
 			return ret;
 	}
 
-	ret = stmpe_set_bits(stmpe, STMPE_KPC_CTRL_MSB,
-			     STMPE_KPC_CTRL_MSB_SCAN_COUNT,
-			     plat->scan_count << 4);
-	if (ret < 0)
-		return ret;
+	if (stmpe->partnum == STMPE1801) {
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CTRL_LSB],
+				STMPE1801_MSK_KPC_SCAN_COUNT,
+				plat->scan_count << 4);
+		if (ret < 0)
+			return ret;
+
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CTRL_MID],
+				STMPE1801_MSK_KPC_DEBOUNCE,
+				(plat->debounce_ms << 1));
+		if (ret < 0)
+			return ret;
+
+		return  stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CMD],
+				STMPE1801_MSK_KPC_CMD_SCAN,
+				STMPE1801_MSK_KPC_CMD_SCAN);
+	} else {
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CTRL_MSB],
+				STMPE_KPC_CTRL_MSB_SCAN_COUNT,
+				plat->scan_count << 4);
+		if (ret < 0)
+			return ret;
+
+		return stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CTRL_LSB],
+				STMPE_KPC_CTRL_LSB_SCAN |
+				STMPE_KPC_CTRL_LSB_DEBOUNCE,
+				STMPE_KPC_CTRL_LSB_SCAN |
+				(plat->debounce_ms << 1));
+	}
 
-	return stmpe_set_bits(stmpe, STMPE_KPC_CTRL_LSB,
-			      STMPE_KPC_CTRL_LSB_SCAN |
-			      STMPE_KPC_CTRL_LSB_DEBOUNCE,
-			      STMPE_KPC_CTRL_LSB_SCAN |
-			      (plat->debounce_ms << 1));
 }
 
 static void stmpe_keypad_fill_used_pins(struct stmpe_keypad *keypad)
 {
 	int row, col;
 
-	for (row = 0; row < STMPE_KEYPAD_MAX_ROWS; row++) {
-		for (col = 0; col < STMPE_KEYPAD_MAX_COLS; col++) {
+	for (row = 0; row < keypad->variant->max_rows; row++) {
+		for (col = 0; col < keypad->variant->max_cols; col++) {
 			int code = MATRIX_SCAN_CODE(row, col,
-						STMPE_KEYPAD_ROW_SHIFT);
+						keypad->scan_code_row_shift);
 			if (keypad->keymap[code] != KEY_RESERVED) {
 				keypad->rows |= 1 << row;
 				keypad->cols |= 1 << col;
@@ -335,23 +479,34 @@ static int stmpe_keypad_probe(struct platform_device *pdev)
 	input->id.bustype = BUS_I2C;
 	input->dev.parent = &pdev->dev;
 
-	error = matrix_keypad_build_keymap(plat->keymap_data, NULL,
-					   STMPE_KEYPAD_MAX_ROWS,
-					   STMPE_KEYPAD_MAX_COLS,
-					   keypad->keymap, input);
-	if (error)
-		return error;
-
 	input_set_capability(input, EV_MSC, MSC_SCAN);
 	if (!plat->no_autorepeat)
 		__set_bit(EV_REP, input->evbit);
 
-	stmpe_keypad_fill_used_pins(keypad);
-
 	keypad->stmpe = stmpe;
 	keypad->plat = plat;
 	keypad->input = input;
 	keypad->variant = &stmpe_keypad_variants[stmpe->partnum];
+	keypad->keymap = devm_kzalloc(&pdev->dev,
+		sizeof(keypad->keymap) * keypad->variant->max_rows *
+			keypad->variant->max_cols, GFP_KERNEL);
+	if (!keypad->keymap)
+		return -ENOMEM;
+
+	error = matrix_keypad_build_keymap(plat->keymap_data, NULL,
+					   keypad->variant->max_rows,
+					   keypad->variant->max_cols,
+					   keypad->keymap, input);
+	if (error)
+		return error;
+
+	/*
+	 * compute keypad->scan_code_row_shift by figuring out
+	 * how many bits are needed to encode keypad->variant->max_cols
+	 */
+	keypad->scan_code_row_shift =
+			get_count_order(keypad->variant->max_cols);
+	stmpe_keypad_fill_used_pins(keypad);
 
 	error = stmpe_keypad_chip_init(keypad);
 	if (error < 0)
-- 
1.7.10

