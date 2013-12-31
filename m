Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3LaTff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:35:35 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45616 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3LaTfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:35:34 -0500
Date: Tue, 31 Dec 2013 11:35:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Simon Glass <sjg@chromium.org>, Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: cros_ec_keyb - avoid variable-length arrays on stack
Message-ID: <20131231193530.GA25261@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/cros_ec_keyb.c | 80 ++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 35 deletions(-)

diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
index d44c5d4..03cb960 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -39,6 +39,7 @@
  * @keymap_data: Matrix keymap data used to convert to keyscan values
  * @ghost_filter: true to enable the matrix key-ghosting filter
  * @old_kb_state: bitmap of keys pressed last scan
+ * @kb_state: bitmap of keys currently pressed
  * @dev: Device pointer
  * @idev: Input device
  * @ec: Top level ChromeOS device to use to talk to EC
@@ -50,17 +51,17 @@ struct cros_ec_keyb {
 	int row_shift;
 	const struct matrix_keymap_data *keymap_data;
 	bool ghost_filter;
-	u8 *old_kb_state;
-
 	struct device *dev;
 	struct input_dev *idev;
 	struct cros_ec_device *ec;
 	struct notifier_block notifier;
+
+	u8 *old_kb_state;
+	u8 kb_state[];
 };
 
 
-static bool cros_ec_keyb_row_has_ghosting(struct cros_ec_keyb *ckdev,
-					  u8 *buf, int row)
+static bool cros_ec_keyb_row_has_ghosting(struct cros_ec_keyb *ckdev, int row)
 {
 	int pressed_in_row = 0;
 	int row_has_teeth = 0;
@@ -68,9 +69,9 @@ static bool cros_ec_keyb_row_has_ghosting(struct cros_ec_keyb *ckdev,
 
 	mask = 1 << row;
 	for (col = 0; col < ckdev->cols; col++) {
-		if (buf[col] & mask) {
+		if (ckdev->kb_state[col] & mask) {
 			pressed_in_row++;
-			row_has_teeth |= buf[col] & ~mask;
+			row_has_teeth |= ckdev->kb_state[col] & ~mask;
 			if (pressed_in_row > 1 && row_has_teeth) {
 				/* ghosting */
 				dev_dbg(ckdev->dev,
@@ -89,7 +90,7 @@ static bool cros_ec_keyb_row_has_ghosting(struct cros_ec_keyb *ckdev,
  * Returns true when there is at least one combination of pressed keys that
  * results in ghosting.
  */
-static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev, u8 *buf)
+static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev)
 {
 	int row;
 
@@ -120,7 +121,7 @@ static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev, u8 *buf)
 	 * cheat because the number of rows is small.
 	 */
 	for (row = 0; row < ckdev->rows; row++)
-		if (cros_ec_keyb_row_has_ghosting(ckdev, buf, row))
+		if (cros_ec_keyb_row_has_ghosting(ckdev, row))
 			return true;
 
 	return false;
@@ -131,8 +132,7 @@ static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev, u8 *buf)
  * press/release events accordingly.  The keyboard state is 13 bytes (one byte
  * per column)
  */
-static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
-				 u8 *kb_state, int len)
+static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev, int len)
 {
 	struct input_dev *idev = ckdev->idev;
 	int col, row;
@@ -142,7 +142,7 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
 
 	num_cols = len;
 
-	if (ckdev->ghost_filter && cros_ec_keyb_has_ghosting(ckdev, kb_state)) {
+	if (ckdev->ghost_filter && cros_ec_keyb_has_ghosting(ckdev)) {
 		/*
 		 * Simple-minded solution: ignore this state. The obvious
 		 * improvement is to only ignore changes to keys involved in
@@ -157,7 +157,7 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
 			int pos = MATRIX_SCAN_CODE(row, col, ckdev->row_shift);
 			const unsigned short *keycodes = idev->keycode;
 
-			new_state = kb_state[col] & (1 << row);
+			new_state = ckdev->kb_state[col] & (1 << row);
 			old_state = ckdev->old_kb_state[col] & (1 << row);
 			if (new_state != old_state) {
 				dev_dbg(ckdev->dev,
@@ -168,9 +168,12 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
 						 new_state);
 			}
 		}
-		ckdev->old_kb_state[col] = kb_state[col];
 	}
+
 	input_sync(ckdev->idev);
+
+	memcpy(ckdev->old_kb_state, ckdev->kb_state,
+	       ckdev->cols * sizeof(*ckdev->kb_state));
 }
 
 static int cros_ec_keyb_open(struct input_dev *dev)
@@ -189,10 +192,10 @@ static void cros_ec_keyb_close(struct input_dev *dev)
 					   &ckdev->notifier);
 }
 
-static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, u8 *kb_state)
+static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev)
 {
 	return ckdev->ec->command_recv(ckdev->ec, EC_CMD_MKBP_STATE,
-					  kb_state, ckdev->cols);
+				       ckdev->kb_state, ckdev->cols);
 }
 
 static int cros_ec_keyb_work(struct notifier_block *nb,
@@ -201,11 +204,10 @@ static int cros_ec_keyb_work(struct notifier_block *nb,
 	int ret;
 	struct cros_ec_keyb *ckdev = container_of(nb, struct cros_ec_keyb,
 						    notifier);
-	u8 kb_state[ckdev->cols];
 
-	ret = cros_ec_keyb_get_state(ckdev, kb_state);
+	ret = cros_ec_keyb_get_state(ckdev);
 	if (ret >= 0)
-		cros_ec_keyb_process(ckdev, kb_state, ret);
+		cros_ec_keyb_process(ckdev, ret);
 
 	return NOTIFY_DONE;
 }
@@ -217,32 +219,40 @@ static int cros_ec_keyb_probe(struct platform_device *pdev)
 	struct cros_ec_keyb *ckdev;
 	struct input_dev *idev;
 	struct device_node *np;
+	unsigned int rows, cols;
+	size_t size;
 	int err;
 
 	np = pdev->dev.of_node;
 	if (!np)
 		return -ENODEV;
 
-	ckdev = devm_kzalloc(&pdev->dev, sizeof(*ckdev), GFP_KERNEL);
-	if (!ckdev)
-		return -ENOMEM;
-	err = matrix_keypad_parse_of_params(&pdev->dev, &ckdev->rows,
-					    &ckdev->cols);
+	err = matrix_keypad_parse_of_params(&pdev->dev, &rows, &cols);
 	if (err)
 		return err;
-	ckdev->old_kb_state = devm_kzalloc(&pdev->dev, ckdev->cols, GFP_KERNEL);
-	if (!ckdev->old_kb_state)
-		return -ENOMEM;
 
-	idev = devm_input_allocate_device(&pdev->dev);
-	if (!idev)
+	/*
+	 * Double memory for keyboard state so we have space for storing
+	 * current and previous state.
+	 */
+	size = sizeof(*ckdev) + 2 * cols * sizeof(*ckdev->kb_state);
+	ckdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!ckdev)
 		return -ENOMEM;
 
+	ckdev->rows = rows;
+	ckdev->cols = cols;
+	ckdev->old_kb_state = &ckdev->kb_state[cols];
+
 	ckdev->ec = ec;
-	ckdev->notifier.notifier_call = cros_ec_keyb_work;
 	ckdev->dev = dev;
+	ckdev->notifier.notifier_call = cros_ec_keyb_work;
 	dev_set_drvdata(&pdev->dev, ckdev);
 
+	idev = devm_input_allocate_device(&pdev->dev);
+	if (!idev)
+		return -ENOMEM;
+
 	idev->name = ec->ec_name;
 	idev->phys = ec->phys_name;
 	__set_bit(EV_REP, idev->evbit);
@@ -282,8 +292,6 @@ static int cros_ec_keyb_probe(struct platform_device *pdev)
 /* Clear any keys in the buffer */
 static void cros_ec_keyb_clear_keyboard(struct cros_ec_keyb *ckdev)
 {
-	u8 old_state[ckdev->cols];
-	u8 new_state[ckdev->cols];
 	unsigned long duration;
 	int i, ret;
 
@@ -294,11 +302,13 @@ static void cros_ec_keyb_clear_keyboard(struct cros_ec_keyb *ckdev)
 	 * Assume that the EC keyscan buffer is at most 32 deep.
 	 */
 	duration = jiffies;
-	ret = cros_ec_keyb_get_state(ckdev, new_state);
+	ret = cros_ec_keyb_get_state(ckdev);
 	for (i = 1; !ret && i < 32; i++) {
-		memcpy(old_state, new_state, sizeof(old_state));
-		ret = cros_ec_keyb_get_state(ckdev, new_state);
-		if (0 == memcmp(old_state, new_state, sizeof(old_state)))
+		memcpy(ckdev->old_kb_state, ckdev->kb_state,
+		       ckdev->cols * sizeof(*ckdev->kb_state));
+		ret = cros_ec_keyb_get_state(ckdev);
+		if (!memcmp(ckdev->old_kb_state, ckdev->kb_state,
+			    ckdev->cols * sizeof(*ckdev->kb_state)))
 			break;
 	}
 	duration = jiffies - duration;
-- 
1.8.3.1


-- 
Dmitry
