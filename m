Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265Ab3BTR0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:26:45 -0500
Received: from mail-ye0-f201.google.com ([209.85.213.201]:49417 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947Ab3BTRZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:25:55 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, Roland Stigge <stigge@antcom.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH v5 6/6] Input: Add ChromeOS EC keyboard driver
Date: Wed, 20 Feb 2013 09:24:39 -0800
Message-Id: <1361381079-26747-7-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361381079-26747-1-git-send-email-sjg@chromium.org>
References: <1361381079-26747-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the key-matrix layer to interpret key scan information from the EC
and inject input based on the FDT-supplied key map. This driver registers
itself with the ChromeOS EC driver to perform communications.

The matrix-keypad FDT binding is used with a small addition to control
ghosting.

Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
Changes in v5:
- Fix {} style nit in cros_ec_keyb_has_ghosting
- Correct key lookup logic which was broken in previous version
- Switch cros_ec_keyb driver to use devm

Changes in v4:
- Add 'depends on MFD_CROS_EC' to Kconfig
- Remove use of wake_notifier
- Remove manual code to locate device tree node
- Add resume handler to clear keyboard scan buffer if required

Changes in v3:
- Remove 'select MFD_CROS_EC' from Kconfig as it isn't necessary
- Remove old_state by using input layer's idev->key
- Move inner loop of cros_ec_keyb_has_ghosting() into its own function and simplify
- Add check for not finding the device tree node
- Remove comment about leaking matrix_keypad_build_keymap()
- Use platform_get_drvdata() where possible
- Remove call to input_free_device() after input_unregister_device()

Changes in v2:
- Remove use of __devinit/__devexit
- Use function to read matrix-keypad parameters from DT
- Remove key autorepeat parameters from DT binding and driver
- Use unsigned int for rows/cols

 .../devicetree/bindings/input/cros-ec-keyb.txt     |  72 +++++
 drivers/input/keyboard/Kconfig                     |  12 +
 drivers/input/keyboard/Makefile                    |   1 +
 drivers/input/keyboard/cros_ec_keyb.c              | 334 +++++++++++++++++++++
 4 files changed, 419 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/cros-ec-keyb.txt
 create mode 100644 drivers/input/keyboard/cros_ec_keyb.c

diff --git a/Documentation/devicetree/bindings/input/cros-ec-keyb.txt b/Documentation/devicetree/bindings/input/cros-ec-keyb.txt
new file mode 100644
index 0000000..0f6355c
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/cros-ec-keyb.txt
@@ -0,0 +1,72 @@
+ChromeOS EC Keyboard
+
+Google's ChromeOS EC Keyboard is a simple matrix keyboard implemented on
+a separate EC (Embedded Controller) device. It provides a message for reading
+key scans from the EC. These are then converted into keycodes for processing
+by the kernel.
+
+This binding is based on matrix-keymap.txt and extends/modifies it as follows:
+
+Required properties:
+- compatible: "google,cros-ec-keyb"
+
+Optional properties:
+- google,needs-ghost-filter: True to enable a ghost filter for the matrix
+keyboard. This is recommended if the EC does not have its own logic or
+hardware for this.
+
+
+Example:
+
+cros-ec-keyb {
+	compatible = "google,cros-ec-keyb";
+	keypad,num-rows = <8>;
+	keypad,num-columns = <13>;
+	google,needs-ghost-filter;
+	/*
+	 * Keymap entries take the form of 0xRRCCKKKK where
+	 * RR=Row CC=Column KKKK=Key Code
+	 * The values below are for a US keyboard layout and
+	 * are taken from the Linux driver. Note that the
+	 * 102ND key is not used for US keyboards.
+	 */
+	linux,keymap = <
+		/* CAPSLCK F1         B          F10     */
+		0x0001003a 0x0002003b 0x00030030 0x00040044
+		/* N       =          R_ALT      ESC     */
+		0x00060031 0x0008000d 0x000a0064 0x01010001
+		/* F4      G          F7         H       */
+		0x0102003e 0x01030022 0x01040041 0x01060023
+		/* '       F9         BKSPACE    L_CTRL  */
+		0x01080028 0x01090043 0x010b000e 0x0200001d
+		/* TAB     F3         T          F6      */
+		0x0201000f 0x0202003d 0x02030014 0x02040040
+		/* ]       Y          102ND      [       */
+		0x0205001b 0x02060015 0x02070056 0x0208001a
+		/* F8      GRAVE      F2         5       */
+		0x02090042 0x03010029 0x0302003c 0x03030006
+		/* F5      6          -          \       */
+		0x0304003f 0x03060007 0x0308000c 0x030b002b
+		/* R_CTRL  A          D          F       */
+		0x04000061 0x0401001e 0x04020020 0x04030021
+		/* S       K          J          ;       */
+		0x0404001f 0x04050025 0x04060024 0x04080027
+		/* L       ENTER      Z          C       */
+		0x04090026 0x040b001c 0x0501002c 0x0502002e
+		/* V       X          ,          M       */
+		0x0503002f 0x0504002d 0x05050033 0x05060032
+		/* L_SHIFT /          .          SPACE   */
+		0x0507002a 0x05080035 0x05090034 0x050B0039
+		/* 1       3          4          2       */
+		0x06010002 0x06020004 0x06030005 0x06040003
+		/* 8       7          0          9       */
+		0x06050009 0x06060008 0x0608000b 0x0609000a
+		/* L_ALT   DOWN       RIGHT      Q       */
+		0x060a0038 0x060b006c 0x060c006a 0x07010010
+		/* E       R          W          I       */
+		0x07020012 0x07030013 0x07040011 0x07050017
+		/* U       R_SHIFT    P          O       */
+		0x07060016 0x07070036 0x07080019 0x07090018
+		/* UP      LEFT    */
+		0x070b0067 0x070c0069>;
+};
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 5a240c6..a087d3f 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -618,4 +618,16 @@ config KEYBOARD_W90P910
 	  To compile this driver as a module, choose M here: the
 	  module will be called w90p910_keypad.
 
+config KEYBOARD_CROS_EC
+	tristate "ChromeOS EC keyboard"
+	select INPUT_MATRIXKMAP
+	depends on MFD_CROS_EC
+	help
+	  Say Y here to enable the matrix keyboard used by ChromeOS devices
+	  and implemented on the ChromeOS EC. You must enable one bus option
+	  (MFD_CROS_EC_I2C or MFD_CROS_EC_SPI) to use this.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cros_ec_keyb.
+
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 44e7600..61b739c 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_KEYBOARD_AMIGA)		+= amikbd.o
 obj-$(CONFIG_KEYBOARD_ATARI)		+= atakbd.o
 obj-$(CONFIG_KEYBOARD_ATKBD)		+= atkbd.o
 obj-$(CONFIG_KEYBOARD_BFIN)		+= bf54x-keys.o
+obj-$(CONFIG_KEYBOARD_CROS_EC)		+= cros_ec_keyb.o
 obj-$(CONFIG_KEYBOARD_DAVINCI)		+= davinci_keyscan.o
 obj-$(CONFIG_KEYBOARD_EP93XX)		+= ep93xx_keypad.o
 obj-$(CONFIG_KEYBOARD_GPIO)		+= gpio_keys.o
diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
new file mode 100644
index 0000000..54dd133
--- /dev/null
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -0,0 +1,334 @@
+/*
+ * ChromeOS EC keyboard driver
+ *
+ * Copyright (C) 2012 Google, Inc
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This driver uses the Chrome OS EC byte-level message-based protocol for
+ * communicating the keyboard state (which keys are pressed) from a keyboard EC
+ * to the AP over some bus (such as i2c, lpc, spi).  The EC does debouncing,
+ * but everything else (including deghosting) is done here.  The main
+ * motivation for this is to keep the EC firmware as simple as possible, since
+ * it cannot be easily upgraded and EC flash/IRAM space is relatively
+ * expensive.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/kernel.h>
+#include <linux/notifier.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/input/matrix_keypad.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+
+/*
+ * @rows: Number of rows in the keypad
+ * @cols: Number of columns in the keypad
+ * @row_shift: log2 or number of rows, rounded up
+ * @keymap_data: Matrix keymap data used to convert to keyscan values
+ * @ghost_filter: true to enable the matrix key-ghosting filter
+ * @dev: Device pointer
+ * @idev: Input device
+ * @ec: Top level ChromeOS device to use to talk to EC
+ * @event_notifier: interrupt event notifier for transport devices
+ */
+struct cros_ec_keyb {
+	unsigned int rows;
+	unsigned int cols;
+	int row_shift;
+	const struct matrix_keymap_data *keymap_data;
+	bool ghost_filter;
+
+	struct device *dev;
+	struct input_dev *idev;
+	struct cros_ec_device *ec;
+	struct notifier_block notifier;
+};
+
+
+static bool cros_ec_keyb_row_has_ghosting(struct cros_ec_keyb *ckdev,
+					  uint8_t *buf, int row)
+{
+	int pressed_in_row = 0;
+	int row_has_teeth = 0;
+	int col, mask;
+
+	mask = 1 << row;
+	for (col = 0; col < ckdev->cols; col++) {
+		if (buf[col] & mask) {
+			pressed_in_row++;
+			row_has_teeth |= buf[col] & ~mask;
+			if (pressed_in_row > 1 && row_has_teeth) {
+				/* ghosting */
+				dev_dbg(ckdev->dev,
+					"ghost found at: r%d c%d, pressed %d, teeth 0x%x\n",
+					row, col, pressed_in_row,
+					row_has_teeth);
+				return true;
+			}
+		}
+	}
+
+	return false;
+}
+
+/*
+ * Returns true when there is at least one combination of pressed keys that
+ * results in ghosting.
+ */
+static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev, uint8_t *buf)
+{
+	int row;
+
+	/*
+	 * Ghosting happens if for any pressed key X there are other keys
+	 * pressed both in the same row and column of X as, for instance,
+	 * in the following diagram:
+	 *
+	 * . . Y . g .
+	 * . . . . . .
+	 * . . . . . .
+	 * . . X . Z .
+	 *
+	 * In this case only X, Y, and Z are pressed, but g appears to be
+	 * pressed too (see Wikipedia).
+	 *
+	 * We can detect ghosting in a single pass (*) over the keyboard state
+	 * by maintaining two arrays.  pressed_in_row counts how many pressed
+	 * keys we have found in a row.  row_has_teeth is true if any of the
+	 * pressed keys for this row has other pressed keys in its column.  If
+	 * at any point of the scan we find that a row has multiple pressed
+	 * keys, and at least one of them is at the intersection with a column
+	 * with multiple pressed keys, we're sure there is ghosting.
+	 * Conversely, if there is ghosting, we will detect such situation for
+	 * at least one key during the pass.
+	 *
+	 * (*) This looks linear in the number of keys, but it's not.  We can
+	 * cheat because the number of rows is small.
+	 */
+	for (row = 0; row < ckdev->rows; row++)
+		if (cros_ec_keyb_row_has_ghosting(ckdev, buf, row))
+			return true;
+
+	return false;
+}
+
+/*
+ * Compares the new keyboard state to the old one and produces key
+ * press/release events accordingly.  The keyboard state is 13 bytes (one byte
+ * per column)
+ */
+static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
+			 uint8_t *kb_state, int len)
+{
+	struct input_dev *idev = ckdev->idev;
+	int col, row;
+	int new_state;
+	int num_cols;
+
+	num_cols = len;
+
+	if (ckdev->ghost_filter && cros_ec_keyb_has_ghosting(ckdev, kb_state)) {
+		/*
+		 * Simple-minded solution: ignore this state. The obvious
+		 * improvement is to only ignore changes to keys involved in
+		 * the ghosting, but process the other changes.
+		 */
+		dev_dbg(ckdev->dev, "ghosting found\n");
+		return;
+	}
+
+	for (col = 0; col < ckdev->cols; col++) {
+		for (row = 0; row < ckdev->rows; row++) {
+			int pos = MATRIX_SCAN_CODE(row, col, ckdev->row_shift);
+			const unsigned short *keycodes = idev->keycode;
+			int code;
+
+			code = keycodes[pos];
+			new_state = kb_state[col] & (1 << row);
+			if (!!new_state != test_bit(code, idev->key)) {
+				dev_dbg(ckdev->dev,
+					"changed: [r%d c%d]: byte %02x\n",
+					row, col, new_state);
+
+			input_report_key(idev, code, new_state);
+			}
+		}
+	}
+	input_sync(ckdev->idev);
+}
+
+static int cros_ec_keyb_open(struct input_dev *dev)
+{
+	struct cros_ec_keyb *ckdev = input_get_drvdata(dev);
+
+	return blocking_notifier_chain_register(&ckdev->ec->event_notifier,
+						&ckdev->notifier);
+}
+
+static void cros_ec_keyb_close(struct input_dev *dev)
+{
+	struct cros_ec_keyb *ckdev = input_get_drvdata(dev);
+
+	blocking_notifier_chain_unregister(&ckdev->ec->event_notifier,
+					   &ckdev->notifier);
+}
+
+static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
+{
+	return ckdev->ec->command_recv(ckdev->ec, EC_CMD_MKBP_STATE,
+					  kb_state, ckdev->cols);
+}
+
+static int cros_ec_keyb_work(struct notifier_block *nb,
+		     unsigned long state, void *_notify)
+{
+	int ret;
+	struct cros_ec_keyb *ckdev = container_of(nb, struct cros_ec_keyb,
+						    notifier);
+	uint8_t kb_state[ckdev->cols];
+
+	ret = cros_ec_keyb_get_state(ckdev, kb_state);
+	if (ret >= 0)
+		cros_ec_keyb_process(ckdev, kb_state, ret);
+
+	return NOTIFY_DONE;
+}
+
+/* Clear any keys in the buffer */
+static void cros_ec_keyb_clear_keyboard(struct cros_ec_keyb *ckdev)
+{
+	uint8_t old_state[ckdev->cols];
+	uint8_t new_state[ckdev->cols];
+	unsigned long duration;
+	int i, ret;
+
+	/*
+	 * Keep reading until we see that the scan state does not change.
+	 * That indicates that we are done.
+	 *
+	 * Assume that the EC keyscan buffer is at most 32 deep.
+	 */
+	duration = jiffies;
+	ret = cros_ec_keyb_get_state(ckdev, new_state);
+	for (i = 1; !ret && i < 32; i++) {
+		memcpy(old_state, new_state, sizeof(old_state));
+		ret = cros_ec_keyb_get_state(ckdev, new_state);
+		if (0 == memcmp(old_state, new_state, sizeof(old_state)))
+			break;
+	}
+	duration = jiffies - duration;
+	dev_info(ckdev->dev, "Discarded %d keyscan(s) in %dus\n", i,
+		jiffies_to_usecs(duration));
+}
+
+static int cros_ec_keyb_probe(struct platform_device *pdev)
+{
+	struct cros_ec_device *ec = dev_get_drvdata(pdev->dev.parent);
+	struct device *dev = ec->dev;
+	struct cros_ec_keyb *ckdev = NULL;
+	struct input_dev *idev = NULL;
+	struct device_node *np;
+	int err;
+
+	np = pdev->dev.of_node;
+	if (!np)
+		return -ENODEV;
+
+	ckdev = devm_kzalloc(&pdev->dev, sizeof(*ckdev), GFP_KERNEL);
+	if (!ckdev)
+		return -ENOMEM;
+	err = matrix_keypad_parse_of_params(&pdev->dev, &ckdev->rows,
+					    &ckdev->cols);
+	if (err)
+		return err;
+
+	idev = devm_input_allocate_device(&pdev->dev);
+	if (!idev)
+		return -ENOMEM;
+
+	ckdev->ec = ec;
+	ckdev->notifier.notifier_call = cros_ec_keyb_work;
+	ckdev->dev = dev;
+	dev_set_drvdata(&pdev->dev, ckdev);
+
+	idev->name = ec->ec_name;
+	idev->phys = ec->phys_name;
+	__set_bit(EV_REP, idev->evbit);
+
+	idev->id.bustype = BUS_VIRTUAL;
+	idev->id.version = 1;
+	idev->id.product = 0;
+	idev->dev.parent = &pdev->dev;
+	idev->open = cros_ec_keyb_open;
+	idev->close = cros_ec_keyb_close;
+
+	ckdev->ghost_filter = of_property_read_bool(np,
+					"google,needs-ghost-filter");
+
+	err = matrix_keypad_build_keymap(NULL, NULL, ckdev->rows, ckdev->cols,
+					 NULL, idev);
+	if (err) {
+		dev_err(dev, "cannot build key matrix\n");
+		return err;
+	}
+
+	ckdev->row_shift = get_count_order(ckdev->cols);
+
+	input_set_capability(idev, EV_MSC, MSC_SCAN);
+	input_set_drvdata(idev, ckdev);
+	ckdev->idev = idev;
+	err = input_register_device(ckdev->idev);
+	if (err) {
+		dev_err(dev, "cannot register input device\n");
+		return err;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int cros_ec_keyb_resume(struct device *dev)
+{
+	struct cros_ec_keyb *ckdev = dev_get_drvdata(dev);
+
+	/*
+	 * When the EC is not a wake source, then it could not have caused the
+	 * resume, so we clear the EC's key scan buffer. If the EC was a
+	 * wake source (e.g. the lid is open and the user might press a key to
+	 * wake) then the key scan buffer should be preserved.
+	 */
+	if (ckdev->ec->was_wake_device)
+		cros_ec_keyb_clear_keyboard(ckdev);
+
+	return 0;
+}
+
+#endif
+
+static SIMPLE_DEV_PM_OPS(cros_ec_keyb_pm_ops, NULL, cros_ec_keyb_resume);
+
+static struct platform_driver cros_ec_keyb_driver = {
+	.probe = cros_ec_keyb_probe,
+	.driver = {
+		.name = "cros-ec-keyb",
+		.pm	= &cros_ec_keyb_pm_ops,
+	},
+};
+
+module_platform_driver(cros_ec_keyb_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ChromeOS EC keyboard driver");
+MODULE_ALIAS("platform:cros-ec-keyb");
-- 
1.8.1.3

