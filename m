Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3LSWm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:42:56 -0500
Received: from mail-oa0-f74.google.com ([209.85.219.74]:49436 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3LSWmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:42:54 -0500
From: Doug Anderson <dianders@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Simon Glass <sjg@chromium.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mkbp: Fix problems with backslash
Date: Thu, 19 Dec 2013 14:36:16 -0800
Message-Id: <1387492578-22068-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mkbp code (post 3.4) has an issue where it can't deal with two
keys on the keyboard having the same keycode.  When this happens it
will get confused about whether the key is down or up and will cause
some screwy behavior.

We need to have two keys on the keyboard with the same keycode for UK
keyboards.  Specifically:
* On the US keyboard the backslash key (above enter) is r3 c11 and is
  supposed to be reported as BACKSLASH.
* On the UK keyboard the # key (left of enter) is r4 c10 and is
  supposed to be reported as BACKSLASH.
* On the UK keyboard the \ key (left of Z) is r2 c7 and is supposed to
  be reported as KEY_102ND.

The above may be crazy, but that's how it's supposed to work so we
need to handle two KEY_BACKSLASH keycodes.  Luckily this is easy to
handle.

Signed-off-by: Doug Anderson <dianders@chromium.org>
(cherry picked from commit 3c56a5a6c1c69306371a4d5f37762044c87e4216)
---
 drivers/input/keyboard/cros_ec_keyb.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
index 7e8b0a5..65f6e52 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -38,6 +38,7 @@
  * @row_shift: log2 or number of rows, rounded up
  * @keymap_data: Matrix keymap data used to convert to keyscan values
  * @ghost_filter: true to enable the matrix key-ghosting filter
+ * @old_kb_state: bitmap of keys pressed last scan
  * @dev: Device pointer
  * @idev: Input device
  * @ec: Top level ChromeOS device to use to talk to EC
@@ -49,6 +50,7 @@ struct cros_ec_keyb {
 	int row_shift;
 	const struct matrix_keymap_data *keymap_data;
 	bool ghost_filter;
+	uint8_t *old_kb_state;
 
 	struct device *dev;
 	struct input_dev *idev;
@@ -135,6 +137,7 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
 	struct input_dev *idev = ckdev->idev;
 	int col, row;
 	int new_state;
+	int old_state;
 	int num_cols;
 
 	num_cols = len;
@@ -157,7 +160,8 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
 
 			code = keycodes[pos];
 			new_state = kb_state[col] & (1 << row);
-			if (!!new_state != test_bit(code, idev->key)) {
+			old_state = ckdev->old_kb_state[col] & (1 << row);
+			if (new_state != old_state) {
 				dev_dbg(ckdev->dev,
 					"changed: [r%d c%d]: byte %02x\n",
 					row, col, new_state);
@@ -165,6 +169,7 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
 				input_report_key(idev, code, new_state);
 			}
 		}
+		ckdev->old_kb_state[col] = kb_state[col];
 	}
 	input_sync(ckdev->idev);
 }
@@ -226,6 +231,9 @@ static int cros_ec_keyb_probe(struct platform_device *pdev)
 					    &ckdev->cols);
 	if (err)
 		return err;
+	ckdev->old_kb_state = devm_kzalloc(&pdev->dev, ckdev->cols, GFP_KERNEL);
+	if (!ckdev->old_kb_state)
+		return -ENOMEM;
 
 	idev = devm_input_allocate_device(&pdev->dev);
 	if (!idev)
-- 
1.8.5.1

