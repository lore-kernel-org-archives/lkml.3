Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaIJEjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:39:23 -0400
Received: from bay004-omc1s5.hotmail.com ([65.54.190.16]:53656 "EHLO
	BAY004-OMC1S5.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaIJEjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:39:21 -0400
X-TMN: [Nyzo04hq0LO7k3oyGNO8OGyVpbUxJ1ix]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS11AB43557CE99589F932DBBDCF0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 01/13] input: cyapa: re-architecture driver to support
Date: Wed, 10 Sep 2014 12:34:14 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/MsHn0mENqfWaqTfagzibHAkBt5A==
Content-Language: zh-cn
X-OriginalArrivalTime: 10 Sep 2014 04:34:16.0706 (UTC) FILETIME=[7B01CE20:01CFCCB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support two different communication protocol based trackpad
device in one cyapa, the new cyapa driver is re-designed with
one cyapa driver core and two devices' functions component.
The cyapa driver core is contained in this patch, it supplies the basic
function with input and kernel system and also defined the interfaces
that the devices' functions component needs to apply and support.
Also, in order to speed up the system boot time, the device states
detecting and probing process is put into the async thread.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/Makefile |    4 +-
 drivers/input/mouse/cyapa.c  | 1120 +++++++++++++++---------------------------
 drivers/input/mouse/cyapa.h  |  275 +++++++++++
 3 files changed, 682 insertions(+), 717 deletions(-)
 create mode 100644 drivers/input/mouse/cyapa.h

diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index c25efdb..8608eb7 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_MOUSE_AMIGA)		+= amimouse.o
 obj-$(CONFIG_MOUSE_APPLETOUCH)		+= appletouch.o
 obj-$(CONFIG_MOUSE_ATARI)		+= atarimouse.o
 obj-$(CONFIG_MOUSE_BCM5974)		+= bcm5974.o
-obj-$(CONFIG_MOUSE_CYAPA)		+= cyapa.o
+obj-$(CONFIG_MOUSE_CYAPA)		+= cyapatp.o
 obj-$(CONFIG_MOUSE_GPIO)		+= gpio_mouse.o
 obj-$(CONFIG_MOUSE_INPORT)		+= inport.o
 obj-$(CONFIG_MOUSE_LOGIBM)		+= logibm.o
@@ -34,3 +34,5 @@ psmouse-$(CONFIG_MOUSE_PS2_SENTELIC)	+= sentelic.o
 psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
 psmouse-$(CONFIG_MOUSE_PS2_CYPRESS)	+= cypress_ps2.o
+
+cyapatp-y := cyapa.o
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index b409c3d..3edd23e 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -6,7 +6,7 @@
  *   Daniel Kurtz <djkurtz@chromium.org>
  *   Benson Leung <bleung@chromium.org>
  *
- * Copyright (C) 2011-2012 Cypress Semiconductor, Inc.
+ * Copyright (C) 2011-2014 Cypress Semiconductor, Inc.
  * Copyright (C) 2011-2012 Google, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -14,461 +14,301 @@
  * more details.
  */
 
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
 #include <linux/input/mt.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
+#include "cyapa.h"
 
-/* APA trackpad firmware generation */
-#define CYAPA_GEN3   0x03   /* support MT-protocol B with tracking ID. */
 
-#define CYAPA_NAME   "Cypress APA Trackpad (cyapa)"
+#define CYAPA_ADAPTER_FUNC_NONE   0
+#define CYAPA_ADAPTER_FUNC_I2C    1
+#define CYAPA_ADAPTER_FUNC_SMBUS  2
+#define CYAPA_ADAPTER_FUNC_BOTH   3
 
-/* commands for read/write registers of Cypress trackpad */
-#define CYAPA_CMD_SOFT_RESET       0x00
-#define CYAPA_CMD_POWER_MODE       0x01
-#define CYAPA_CMD_DEV_STATUS       0x02
-#define CYAPA_CMD_GROUP_DATA       0x03
-#define CYAPA_CMD_GROUP_CMD        0x04
-#define CYAPA_CMD_GROUP_QUERY      0x05
-#define CYAPA_CMD_BL_STATUS        0x06
-#define CYAPA_CMD_BL_HEAD          0x07
-#define CYAPA_CMD_BL_CMD           0x08
-#define CYAPA_CMD_BL_DATA          0x09
-#define CYAPA_CMD_BL_ALL           0x0a
-#define CYAPA_CMD_BLK_PRODUCT_ID   0x0b
-#define CYAPA_CMD_BLK_HEAD         0x0c
+#define CYAPA_DEBUGFS_READ_FW	"read_fw"
+#define CYAPA_DEBUGFS_RAW_DATA	"raw_data"
+#define CYAPA_FW_NAME		"cyapa.bin"
 
-/* report data start reg offset address. */
-#define DATA_REG_START_OFFSET  0x0000
+const char unique_str[] = "CYTRA";
 
-#define BL_HEAD_OFFSET 0x00
-#define BL_DATA_OFFSET 0x10
 
-/*
- * Operational Device Status Register
- *
- * bit 7: Valid interrupt source
- * bit 6 - 4: Reserved
- * bit 3 - 2: Power status
- * bit 1 - 0: Device status
- */
-#define REG_OP_STATUS     0x00
-#define OP_STATUS_SRC     0x80
-#define OP_STATUS_POWER   0x0c
-#define OP_STATUS_DEV     0x03
-#define OP_STATUS_MASK (OP_STATUS_SRC | OP_STATUS_POWER | OP_STATUS_DEV)
 
-/*
- * Operational Finger Count/Button Flags Register
- *
- * bit 7 - 4: Number of touched finger
- * bit 3: Valid data
- * bit 2: Middle Physical Button
- * bit 1: Right Physical Button
- * bit 0: Left physical Button
- */
-#define REG_OP_DATA1       0x01
-#define OP_DATA_VALID      0x08
-#define OP_DATA_MIDDLE_BTN 0x04
-#define OP_DATA_RIGHT_BTN  0x02
-#define OP_DATA_LEFT_BTN   0x01
-#define OP_DATA_BTN_MASK (OP_DATA_MIDDLE_BTN | OP_DATA_RIGHT_BTN | \
-			  OP_DATA_LEFT_BTN)
+ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
+					u8 *values)
+{
+	return i2c_smbus_read_i2c_block_data(cyapa->client, reg, len, values);
+}
 
-/*
- * Bootloader Status Register
- *
- * bit 7: Busy
- * bit 6 - 5: Reserved
- * bit 4: Bootloader running
- * bit 3 - 1: Reserved
- * bit 0: Checksum valid
- */
-#define REG_BL_STATUS        0x01
-#define BL_STATUS_BUSY       0x80
-#define BL_STATUS_RUNNING    0x10
-#define BL_STATUS_DATA_VALID 0x08
-#define BL_STATUS_CSUM_VALID 0x01
+ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
+					 size_t len, const u8 *values)
+{
+	return i2c_smbus_write_i2c_block_data(cyapa->client, reg, len, values);
+}
 
-/*
- * Bootloader Error Register
+/* Returns 0 on success, else negative errno on failure. */
+ssize_t cyapa_i2c_read(struct cyapa *cyapa, u8 reg, size_t len,
+					u8 *values)
+{
+	int ret;
+	struct i2c_client *client = cyapa->client;
+	struct i2c_msg msgs[] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = 1,
+			.buf = &reg,
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = values,
+		},
+	};
+
+	ret = i2c_transfer(client->adapter, msgs, 2);
+
+	if (ret != ARRAY_SIZE(msgs))
+		return ret < 0 ? ret : -EIO;
+
+	return 0;
+}
+
+/**
+ * cyapa_i2c_write - Execute i2c block data write operation
+ * @cyapa: Handle to this driver
+ * @ret: Offset of the data to written in the register map
+ * @len: number of bytes to write
+ * @values: Data to be written
  *
- * bit 7: Invalid
- * bit 6: Invalid security key
- * bit 5: Bootloading
- * bit 4: Command checksum
- * bit 3: Flash protection error
- * bit 2: Flash checksum error
- * bit 1 - 0: Reserved
+ * Return negative errno code on error; return zero when success.
  */
-#define REG_BL_ERROR         0x02
-#define BL_ERROR_INVALID     0x80
-#define BL_ERROR_INVALID_KEY 0x40
-#define BL_ERROR_BOOTLOADING 0x20
-#define BL_ERROR_CMD_CSUM    0x10
-#define BL_ERROR_FLASH_PROT  0x08
-#define BL_ERROR_FLASH_CSUM  0x04
-
-#define BL_STATUS_SIZE  3  /* length of bootloader status registers */
-#define BLK_HEAD_BYTES 32
-
-#define PRODUCT_ID_SIZE  16
-#define QUERY_DATA_SIZE  27
-#define REG_PROTOCOL_GEN_QUERY_OFFSET  20
-
-#define REG_OFFSET_DATA_BASE     0x0000
-#define REG_OFFSET_COMMAND_BASE  0x0028
-#define REG_OFFSET_QUERY_BASE    0x002a
-
-#define CAPABILITY_LEFT_BTN_MASK	(0x01 << 3)
-#define CAPABILITY_RIGHT_BTN_MASK	(0x01 << 4)
-#define CAPABILITY_MIDDLE_BTN_MASK	(0x01 << 5)
-#define CAPABILITY_BTN_MASK  (CAPABILITY_LEFT_BTN_MASK | \
-			      CAPABILITY_RIGHT_BTN_MASK | \
-			      CAPABILITY_MIDDLE_BTN_MASK)
-
-#define CYAPA_OFFSET_SOFT_RESET  REG_OFFSET_COMMAND_BASE
-
-#define REG_OFFSET_POWER_MODE (REG_OFFSET_COMMAND_BASE + 1)
-
-#define PWR_MODE_MASK   0xfc
-#define PWR_MODE_FULL_ACTIVE (0x3f << 2)
-#define PWR_MODE_IDLE        (0x05 << 2) /* default sleep time is 50 ms. */
-#define PWR_MODE_OFF         (0x00 << 2)
-
-#define PWR_STATUS_MASK      0x0c
-#define PWR_STATUS_ACTIVE    (0x03 << 2)
-#define PWR_STATUS_IDLE      (0x02 << 2)
-#define PWR_STATUS_OFF       (0x00 << 2)
+ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
+					 size_t len, const void *values)
+{
+	int ret;
+	struct i2c_client *client = cyapa->client;
+	char data[32], *buf;
 
-/*
- * CYAPA trackpad device states.
- * Used in register 0x00, bit1-0, DeviceStatus field.
- * Other values indicate device is in an abnormal state and must be reset.
- */
-#define CYAPA_DEV_NORMAL  0x03
-#define CYAPA_DEV_BUSY    0x01
-
-enum cyapa_state {
-	CYAPA_STATE_OP,
-	CYAPA_STATE_BL_IDLE,
-	CYAPA_STATE_BL_ACTIVE,
-	CYAPA_STATE_BL_BUSY,
-	CYAPA_STATE_NO_DEVICE,
-};
+	if (len > 31)
+		buf = kzalloc(len + 1, GFP_KERNEL);
+	else
+		buf = data;
 
+	buf[0] = reg;
+	memcpy(&buf[1], values, len);
+	ret = i2c_master_send(client, buf, len + 1);
 
-struct cyapa_touch {
-	/*
-	 * high bits or x/y position value
-	 * bit 7 - 4: high 4 bits of x position value
-	 * bit 3 - 0: high 4 bits of y position value
-	 */
-	u8 xy_hi;
-	u8 x_lo;  /* low 8 bits of x position value. */
-	u8 y_lo;  /* low 8 bits of y position value. */
-	u8 pressure;
-	/* id range is 1 - 15.  It is incremented with every new touch. */
-	u8 id;
-} __packed;
-
-/* The touch.id is used as the MT slot id, thus max MT slot is 15 */
-#define CYAPA_MAX_MT_SLOTS  15
-
-struct cyapa_reg_data {
-	/*
-	 * bit 0 - 1: device status
-	 * bit 3 - 2: power mode
-	 * bit 6 - 4: reserved
-	 * bit 7: interrupt valid bit
-	 */
-	u8 device_status;
+	if (buf != data)
+		kfree(buf);
+	return (ret == (len + 1)) ? 0 : ((ret < 0) ? ret : -EIO);
+}
+
+void cyapa_default_irq_handler(struct cyapa *cyapa)
+{
 	/*
-	 * bit 7 - 4: number of fingers currently touching pad
-	 * bit 3: valid data check bit
-	 * bit 2: middle mechanism button state if exists
-	 * bit 1: right mechanism button state if exists
-	 * bit 0: left mechanism button state if exists
+	 * Do redetecting when device states is still unknown and
+	 * interrupt envent is received from device.
 	 */
-	u8 finger_btn;
-	/* CYAPA reports up to 5 touches per packet. */
-	struct cyapa_touch touches[5];
-} __packed;
+	async_schedule(cyapa_detect_async, cyapa);
+}
+
+const struct cyapa_dev_ops cyapa_default_ops = {
+	.irq_handler = cyapa_default_irq_handler
+};
+
+
+static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
+{
+	u8 ret = CYAPA_ADAPTER_FUNC_NONE;
 
-/* The main device structure */
-struct cyapa {
-	enum cyapa_state state;
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		ret |= CYAPA_ADAPTER_FUNC_I2C;
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA |
+				     I2C_FUNC_SMBUS_BLOCK_DATA |
+				     I2C_FUNC_SMBUS_I2C_BLOCK))
+		ret |= CYAPA_ADAPTER_FUNC_SMBUS;
+	return ret;
+}
 
-	struct i2c_client *client;
+static int cyapa_create_input_dev(struct cyapa *cyapa)
+{
+	struct device *dev = &cyapa->client->dev;
+	int ret;
 	struct input_dev *input;
-	char phys[32];	/* device physical location */
-	int irq;
-	bool irq_wake;  /* irq wake is enabled */
-	bool smbus;
-
-	/* read from query data region. */
-	char product_id[16];
-	u8 btn_capability;
-	u8 gen;
-	int max_abs_x;
-	int max_abs_y;
-	int physical_size_x;
-	int physical_size_y;
-};
 
-static const u8 bl_deactivate[] = { 0x00, 0xff, 0x3b, 0x00, 0x01, 0x02, 0x03,
-		0x04, 0x05, 0x06, 0x07 };
-static const u8 bl_exit[] = { 0x00, 0xff, 0xa5, 0x00, 0x01, 0x02, 0x03, 0x04,
-		0x05, 0x06, 0x07 };
+	if (!cyapa->physical_size_x || !cyapa->physical_size_y)
+		return -EINVAL;
 
-struct cyapa_cmd_len {
-	u8 cmd;
-	u8 len;
-};
+	input = cyapa->input = input_allocate_device();
+	if (!input) {
+		dev_err(dev, "allocate memory for input device failed\n");
+		return -ENOMEM;
+	}
 
-#define CYAPA_ADAPTER_FUNC_NONE   0
-#define CYAPA_ADAPTER_FUNC_I2C    1
-#define CYAPA_ADAPTER_FUNC_SMBUS  2
-#define CYAPA_ADAPTER_FUNC_BOTH   3
+	input->name = CYAPA_NAME;
+	input->phys = cyapa->phys;
+	input->id.bustype = BUS_I2C;
+	input->id.version = 1;
+	input->id.product = 0;  /* Means any product in eventcomm. */
+	input->dev.parent = &cyapa->client->dev;
 
-/*
- * macros for SMBus communication
- */
-#define SMBUS_READ   0x01
-#define SMBUS_WRITE 0x00
-#define SMBUS_ENCODE_IDX(cmd, idx) ((cmd) | (((idx) & 0x03) << 1))
-#define SMBUS_ENCODE_RW(cmd, rw) ((cmd) | ((rw) & 0x01))
-#define SMBUS_BYTE_BLOCK_CMD_MASK 0x80
-#define SMBUS_GROUP_BLOCK_CMD_MASK 0x40
-
- /* for byte read/write command */
-#define CMD_RESET 0
-#define CMD_POWER_MODE 1
-#define CMD_DEV_STATUS 2
-#define SMBUS_BYTE_CMD(cmd) (((cmd) & 0x3f) << 1)
-#define CYAPA_SMBUS_RESET SMBUS_BYTE_CMD(CMD_RESET)
-#define CYAPA_SMBUS_POWER_MODE SMBUS_BYTE_CMD(CMD_POWER_MODE)
-#define CYAPA_SMBUS_DEV_STATUS SMBUS_BYTE_CMD(CMD_DEV_STATUS)
-
- /* for group registers read/write command */
-#define REG_GROUP_DATA 0
-#define REG_GROUP_CMD 2
-#define REG_GROUP_QUERY 3
-#define SMBUS_GROUP_CMD(grp) (0x80 | (((grp) & 0x07) << 3))
-#define CYAPA_SMBUS_GROUP_DATA SMBUS_GROUP_CMD(REG_GROUP_DATA)
-#define CYAPA_SMBUS_GROUP_CMD SMBUS_GROUP_CMD(REG_GROUP_CMD)
-#define CYAPA_SMBUS_GROUP_QUERY SMBUS_GROUP_CMD(REG_GROUP_QUERY)
-
- /* for register block read/write command */
-#define CMD_BL_STATUS 0
-#define CMD_BL_HEAD 1
-#define CMD_BL_CMD 2
-#define CMD_BL_DATA 3
-#define CMD_BL_ALL 4
-#define CMD_BLK_PRODUCT_ID 5
-#define CMD_BLK_HEAD 6
-#define SMBUS_BLOCK_CMD(cmd) (0xc0 | (((cmd) & 0x1f) << 1))
-
-/* register block read/write command in bootloader mode */
-#define CYAPA_SMBUS_BL_STATUS SMBUS_BLOCK_CMD(CMD_BL_STATUS)
-#define CYAPA_SMBUS_BL_HEAD SMBUS_BLOCK_CMD(CMD_BL_HEAD)
-#define CYAPA_SMBUS_BL_CMD SMBUS_BLOCK_CMD(CMD_BL_CMD)
-#define CYAPA_SMBUS_BL_DATA SMBUS_BLOCK_CMD(CMD_BL_DATA)
-#define CYAPA_SMBUS_BL_ALL SMBUS_BLOCK_CMD(CMD_BL_ALL)
-
-/* register block read/write command in operational mode */
-#define CYAPA_SMBUS_BLK_PRODUCT_ID SMBUS_BLOCK_CMD(CMD_BLK_PRODUCT_ID)
-#define CYAPA_SMBUS_BLK_HEAD SMBUS_BLOCK_CMD(CMD_BLK_HEAD)
-
-static const struct cyapa_cmd_len cyapa_i2c_cmds[] = {
-	{ CYAPA_OFFSET_SOFT_RESET, 1 },
-	{ REG_OFFSET_COMMAND_BASE + 1, 1 },
-	{ REG_OFFSET_DATA_BASE, 1 },
-	{ REG_OFFSET_DATA_BASE, sizeof(struct cyapa_reg_data) },
-	{ REG_OFFSET_COMMAND_BASE, 0 },
-	{ REG_OFFSET_QUERY_BASE, QUERY_DATA_SIZE },
-	{ BL_HEAD_OFFSET, 3 },
-	{ BL_HEAD_OFFSET, 16 },
-	{ BL_HEAD_OFFSET, 16 },
-	{ BL_DATA_OFFSET, 16 },
-	{ BL_HEAD_OFFSET, 32 },
-	{ REG_OFFSET_QUERY_BASE, PRODUCT_ID_SIZE },
-	{ REG_OFFSET_DATA_BASE, 32 }
-};
+	input_set_drvdata(input, cyapa);
 
-static const struct cyapa_cmd_len cyapa_smbus_cmds[] = {
-	{ CYAPA_SMBUS_RESET, 1 },
-	{ CYAPA_SMBUS_POWER_MODE, 1 },
-	{ CYAPA_SMBUS_DEV_STATUS, 1 },
-	{ CYAPA_SMBUS_GROUP_DATA, sizeof(struct cyapa_reg_data) },
-	{ CYAPA_SMBUS_GROUP_CMD, 2 },
-	{ CYAPA_SMBUS_GROUP_QUERY, QUERY_DATA_SIZE },
-	{ CYAPA_SMBUS_BL_STATUS, 3 },
-	{ CYAPA_SMBUS_BL_HEAD, 16 },
-	{ CYAPA_SMBUS_BL_CMD, 16 },
-	{ CYAPA_SMBUS_BL_DATA, 16 },
-	{ CYAPA_SMBUS_BL_ALL, 32 },
-	{ CYAPA_SMBUS_BLK_PRODUCT_ID, PRODUCT_ID_SIZE },
-	{ CYAPA_SMBUS_BLK_HEAD, 16 },
-};
+	__set_bit(EV_ABS, input->evbit);
 
-static ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
-					u8 *values)
-{
-	return i2c_smbus_read_i2c_block_data(cyapa->client, reg, len, values);
-}
+	/* Finger position */
+	input_set_abs_params(input, ABS_MT_POSITION_X, 0, cyapa->max_abs_x, 0,
+			     0);
+	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, cyapa->max_abs_y, 0,
+			     0);
+	input_set_abs_params(input, ABS_MT_PRESSURE, 0, cyapa->max_z, 0, 0);
+	if (cyapa->gen > CYAPA_GEN3) {
+		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
+		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 0, 0);
+		/*
+		 * Orientation is the angle between the vertical axis and
+		 * the major axis of the contact ellipse.
+		 * The range is -127 to 127.
+		 * the positive direction is clockwise form the vertical axis.
+		 * If the ellipse of contact degenerates into a circle,
+		 * orientation is reported as 0.
+		 *
+		 * Also, for Gen5 trackpad the accurate of this orientation
+		 * value is value + (-30 ~ 30).
+		 */
+		input_set_abs_params(input, ABS_MT_ORIENTATION,
+				-127, 127, 0, 0);
+	}
+	if (cyapa->gen >= CYAPA_GEN5) {
+		input_set_abs_params(input, ABS_MT_WIDTH_MAJOR, 0, 255, 0, 0);
+		input_set_abs_params(input, ABS_MT_WIDTH_MINOR, 0, 255, 0, 0);
+	}
 
-static ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
-					 size_t len, const u8 *values)
-{
-	return i2c_smbus_write_i2c_block_data(cyapa->client, reg, len, values);
+	input_abs_set_res(input, ABS_MT_POSITION_X,
+			  cyapa->max_abs_x / cyapa->physical_size_x);
+	input_abs_set_res(input, ABS_MT_POSITION_Y,
+			  cyapa->max_abs_y / cyapa->physical_size_y);
+
+	if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK)
+		__set_bit(BTN_LEFT, input->keybit);
+	if (cyapa->btn_capability & CAPABILITY_MIDDLE_BTN_MASK)
+		__set_bit(BTN_MIDDLE, input->keybit);
+	if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK)
+		__set_bit(BTN_RIGHT, input->keybit);
+
+	if (cyapa->btn_capability == CAPABILITY_LEFT_BTN_MASK)
+		__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
+
+	/* Handle pointer emulation and unused slots in core */
+	ret = input_mt_init_slots(input, CYAPA_MAX_MT_SLOTS,
+				  INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
+	if (ret) {
+		dev_err(dev, "allocate memory for MT slots failed, %d\n", ret);
+		goto err_free_device;
+	}
+
+	/* Register the device in input subsystem */
+	ret = input_register_device(input);
+	if (ret) {
+		dev_err(dev, "input device register failed, %d\n", ret);
+		goto err_free_device;
+	}
+	return 0;
+
+err_free_device:
+	input_free_device(input);
+	cyapa->input = NULL;
+	return ret;
 }
 
 /*
- * cyapa_smbus_read_block - perform smbus block read command
- * @cyapa  - private data structure of the driver
- * @cmd    - the properly encoded smbus command
- * @len    - expected length of smbus command result
- * @values - buffer to store smbus command result
+ * Check if device is operational.
  *
- * Returns negative errno, else the number of bytes written.
+ * An operational device is responding, has exited bootloader, and has
+ * firmware supported by this driver.
  *
- * Note:
- * In trackpad device, the memory block allocated for I2C register map
- * is 256 bytes, so the max read block for I2C bus is 256 bytes.
+ * Returns:
+ *   -EBUSY  no device or in bootloader
+ *   -EIO    failure while reading from device
+ *   -EAGAIN device is still in bootloader
+ *           if ->state = CYAPA_STATE_BL_IDLE, device has invalid firmware
+ *   -EINVAL device is in operational mode, but not supported by this driver
+ *   0       device is supported
  */
-static ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
-				      u8 *values)
+static int cyapa_check_is_operational(struct cyapa *cyapa)
 {
-	ssize_t ret;
-	u8 index;
-	u8 smbus_cmd;
-	u8 *buf;
-	struct i2c_client *client = cyapa->client;
+	int ret;
 
-	if (!(SMBUS_BYTE_BLOCK_CMD_MASK & cmd))
-		return -EINVAL;
+	ret = cyapa_poll_state(cyapa, 4000);
+	if (ret)
+		return ret;
 
-	if (SMBUS_GROUP_BLOCK_CMD_MASK & cmd) {
-		/* read specific block registers command. */
-		smbus_cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
-		ret = i2c_smbus_read_block_data(client, smbus_cmd, values);
-		goto out;
+	switch (cyapa->gen) {
+	default:
+		cyapa->ops = &cyapa_default_ops;
+		cyapa->gen = CYAPA_GEN_UNKNOWN;
+		break;
 	}
 
-	ret = 0;
-	for (index = 0; index * I2C_SMBUS_BLOCK_MAX < len; index++) {
-		smbus_cmd = SMBUS_ENCODE_IDX(cmd, index);
-		smbus_cmd = SMBUS_ENCODE_RW(smbus_cmd, SMBUS_READ);
-		buf = values + I2C_SMBUS_BLOCK_MAX * index;
-		ret = i2c_smbus_read_block_data(client, smbus_cmd, buf);
-		if (ret < 0)
-			goto out;
-	}
+	if (cyapa->ops->operational_check)
+		ret = cyapa->ops->operational_check(cyapa);
+	else
+		ret = -EBUSY;
 
-out:
-	return ret > 0 ? len : ret;
+	return ret;
 }
 
-static s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx)
-{
-	u8 cmd;
 
-	if (cyapa->smbus) {
-		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
-		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
-	} else {
-		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
-	}
-	return i2c_smbus_read_byte_data(cyapa->client, cmd);
-}
-
-static s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value)
+static irqreturn_t cyapa_irq(int irq, void *dev_id)
 {
-	u8 cmd;
+	struct cyapa *cyapa = dev_id;
+	struct input_dev *input = cyapa->input;
+	bool cont;
+
+	/* Interrupt event maybe cuased by host command to trackpad device. */
+	cont = true;
+	if (cyapa->ops->irq_cmd_handler)
+		cont = cyapa->ops->irq_cmd_handler(cyapa);
+
+	/* Interrupt event maybe from trackpad device input reporting. */
+	if (cont && cyapa->ops->irq_handler) {
+		if (!mutex_trylock(&cyapa->state_sync_lock)) {
+			if (cyapa->ops->sort_empty_output_data)
+				cyapa->ops->sort_empty_output_data(cyapa,
+					NULL, NULL, NULL);
+			goto out;
+		}
 
-	if (cyapa->smbus) {
-		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
-		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_WRITE);
-	} else {
-		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
-	}
-	return i2c_smbus_write_byte_data(cyapa->client, cmd, value);
-}
+		if (!input) {
+			if (cyapa->ops->sort_empty_output_data)
+				cyapa->ops->sort_empty_output_data(cyapa,
+					NULL, NULL, NULL);
+		} else
+			cyapa->ops->irq_handler(cyapa);
 
-static ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values)
-{
-	u8 cmd;
-	size_t len;
-
-	if (cyapa->smbus) {
-		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
-		len = cyapa_smbus_cmds[cmd_idx].len;
-		return cyapa_smbus_read_block(cyapa, cmd, len, values);
-	} else {
-		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
-		len = cyapa_i2c_cmds[cmd_idx].len;
-		return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
+		mutex_unlock(&cyapa->state_sync_lock);
 	}
+out:
+	return IRQ_HANDLED;
 }
 
 /*
  * Query device for its current operating state.
- *
  */
 static int cyapa_get_state(struct cyapa *cyapa)
 {
-	int ret;
-	u8 status[BL_STATUS_SIZE];
-
 	cyapa->state = CYAPA_STATE_NO_DEVICE;
 
-	/*
-	 * Get trackpad status by reading 3 registers starting from 0.
-	 * If the device is in the bootloader, this will be BL_HEAD.
-	 * If the device is in operation mode, this will be the DATA regs.
-	 *
-	 */
-	ret = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET, BL_STATUS_SIZE,
-				       status);
-
-	/*
-	 * On smbus systems in OP mode, the i2c_reg_read will fail with
-	 * -ETIMEDOUT.  In this case, try again using the smbus equivalent
-	 * command.  This should return a BL_HEAD indicating CYAPA_STATE_OP.
-	 */
-	if (cyapa->smbus && (ret == -ETIMEDOUT || ret == -ENXIO))
-		ret = cyapa_read_block(cyapa, CYAPA_CMD_BL_STATUS, status);
-
-	if (ret != BL_STATUS_SIZE)
-		goto error;
-
-	if ((status[REG_OP_STATUS] & OP_STATUS_SRC) == OP_STATUS_SRC) {
-		switch (status[REG_OP_STATUS] & OP_STATUS_DEV) {
-		case CYAPA_DEV_NORMAL:
-		case CYAPA_DEV_BUSY:
-			cyapa->state = CYAPA_STATE_OP;
-			break;
-		default:
-			ret = -EAGAIN;
-			goto error;
-		}
-	} else {
-		if (status[REG_BL_STATUS] & BL_STATUS_BUSY)
-			cyapa->state = CYAPA_STATE_BL_BUSY;
-		else if (status[REG_BL_ERROR] & BL_ERROR_BOOTLOADING)
-			cyapa->state = CYAPA_STATE_BL_ACTIVE;
-		else
-			cyapa->state = CYAPA_STATE_BL_IDLE;
-	}
-
-	return 0;
-error:
-	return (ret < 0) ? ret : -EAGAIN;
+	return -ENODEV;
 }
 
 /*
@@ -485,7 +325,7 @@ error:
  *   -ETIMEDOUT if device never responds (too many -EAGAIN)
  *   < 0    other errors
  */
-static int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
+int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
 {
 	int ret;
 	int tries = timeout / 100;
@@ -495,332 +335,127 @@ static int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
 		msleep(100);
 		ret = cyapa_get_state(cyapa);
 	}
-	return (ret == -EAGAIN || ret == -ETIMEDOUT) ? -ETIMEDOUT : ret;
-}
-
-static int cyapa_bl_deactivate(struct cyapa *cyapa)
-{
-	int ret;
 
-	ret = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_deactivate),
-					bl_deactivate);
-	if (ret < 0)
-		return ret;
-
-	/* wait for bootloader to switch to idle state; should take < 100ms */
-	msleep(100);
-	ret = cyapa_poll_state(cyapa, 500);
-	if (ret < 0)
-		return ret;
-	if (cyapa->state != CYAPA_STATE_BL_IDLE)
-		return -EAGAIN;
-	return 0;
+	return (ret == -EAGAIN || ret == -ETIMEDOUT) ? -ETIMEDOUT : ret;
 }
 
-/*
- * Exit bootloader
- *
- * Send bl_exit command, then wait 50 - 100 ms to let device transition to
- * operational mode.  If this is the first time the device's firmware is
- * running, it can take up to 2 seconds to calibrate its sensors.  So, poll
- * the device's new state for up to 2 seconds.
- *
- * Returns:
- *   -EIO    failure while reading from device
- *   -EAGAIN device is stuck in bootloader, b/c it has invalid firmware
- *   0       device is supported and in operational mode
- */
-static int cyapa_bl_exit(struct cyapa *cyapa)
+static void cyapa_detect(struct cyapa *cyapa)
 {
+	struct device *dev = &cyapa->client->dev;
+	char *envp[2] = {"ERROR=1", NULL};
 	int ret;
 
-	ret = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_exit), bl_exit);
-	if (ret < 0)
-		return ret;
+	ret = cyapa_check_is_operational(cyapa);
+	if (ret == -ETIMEDOUT)
+		dev_err(dev, "no device detected, %d\n", ret);
+	else if (ret)
+		dev_err(dev, "device detected, but not operational, %d\n", ret);
 
-	/*
-	 * Wait for bootloader to exit, and operation mode to start.
-	 * Normally, this takes at least 50 ms.
-	 */
-	usleep_range(50000, 100000);
-	/*
-	 * In addition, when a device boots for the first time after being
-	 * updated to new firmware, it must first calibrate its sensors, which
-	 * can take up to an additional 2 seconds.
-	 */
-	ret = cyapa_poll_state(cyapa, 2000);
-	if (ret < 0)
-		return ret;
-	if (cyapa->state != CYAPA_STATE_OP)
-		return -EAGAIN;
+	if (ret) {
+		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+		return;
+	}
 
-	return 0;
+	if (!cyapa->input) {
+		ret = cyapa_create_input_dev(cyapa);
+		if (ret)
+			dev_err(dev, "create input_dev instance failed, %d\n",
+				ret);
+
+		/*
+		 * On some systems, a system crash / warm boot does not reset
+		 * the device's current power mode to FULL_ACTIVE.
+		 * If such an event happens during suspend, after the device
+		 * has been put in a low power mode, the device will still be
+		 * in low power mode on a subsequent boot, since there was
+		 * never a matching resume().
+		 * Handle this by always forcing full power here, when a
+		 * device is first detected to be in operational mode.
+		 */
+		if (cyapa->ops->set_power_mode) {
+			ret = cyapa->ops->set_power_mode(cyapa,
+					PWR_MODE_FULL_ACTIVE, 0);
+			if (ret)
+				dev_warn(dev, "set active power failed, %d\n",
+						ret);
+		}
+	}
 }
 
 /*
- * Set device power mode
- *
+ * Sysfs Interface.
  */
-static int cyapa_set_power_mode(struct cyapa *cyapa, u8 power_mode)
-{
-	struct device *dev = &cyapa->client->dev;
-	int ret;
-	u8 power;
-
-	if (cyapa->state != CYAPA_STATE_OP)
-		return 0;
-
-	ret = cyapa_read_byte(cyapa, CYAPA_CMD_POWER_MODE);
-	if (ret < 0)
-		return ret;
 
-	power = ret & ~PWR_MODE_MASK;
-	power |= power_mode & PWR_MODE_MASK;
-	ret = cyapa_write_byte(cyapa, CYAPA_CMD_POWER_MODE, power);
-	if (ret < 0)
-		dev_err(dev, "failed to set power_mode 0x%02x err = %d\n",
-			power_mode, ret);
-	return ret;
-}
-
-static int cyapa_get_query_data(struct cyapa *cyapa)
+static u16 clamp_pwr_cmd_sleep_time(u16 sleep_time)
 {
-	u8 query_data[QUERY_DATA_SIZE];
-	int ret;
-
-	if (cyapa->state != CYAPA_STATE_OP)
-		return -EBUSY;
-
-	ret = cyapa_read_block(cyapa, CYAPA_CMD_GROUP_QUERY, query_data);
-	if (ret < 0)
-		return ret;
-	if (ret != QUERY_DATA_SIZE)
-		return -EIO;
-
-	memcpy(&cyapa->product_id[0], &query_data[0], 5);
-	cyapa->product_id[5] = '-';
-	memcpy(&cyapa->product_id[6], &query_data[5], 6);
-	cyapa->product_id[12] = '-';
-	memcpy(&cyapa->product_id[13], &query_data[11], 2);
-	cyapa->product_id[15] = '\0';
-
-	cyapa->btn_capability = query_data[19] & CAPABILITY_BTN_MASK;
-
-	cyapa->gen = query_data[20] & 0x0f;
-
-	cyapa->max_abs_x = ((query_data[21] & 0xf0) << 4) | query_data[22];
-	cyapa->max_abs_y = ((query_data[21] & 0x0f) << 8) | query_data[23];
-
-	cyapa->physical_size_x =
-		((query_data[24] & 0xf0) << 4) | query_data[25];
-	cyapa->physical_size_y =
-		((query_data[24] & 0x0f) << 8) | query_data[26];
+	if (sleep_time < 20)
+		sleep_time = 20;     /* minimal sleep time. */
+	else if (sleep_time > 1000)
+		sleep_time = 1000;   /* maximal sleep time. */
 
-	return 0;
+	return sleep_time;
 }
 
 /*
- * Check if device is operational.
+ * cyapa_sleep_time_to_pwr_cmd and cyapa_pwr_cmd_to_sleep_time
  *
- * An operational device is responding, has exited bootloader, and has
- * firmware supported by this driver.
+ * These are helper functions that convert to and from integer idle
+ * times and register settings to write to the PowerMode register.
+ * The trackpad supports between 20ms to 1000ms scan intervals.
+ * The time will be increased in increments of 10ms from 20ms to 100ms.
+ * From 100ms to 1000ms, time will be increased in increments of 20ms.
  *
- * Returns:
- *   -EBUSY  no device or in bootloader
- *   -EIO    failure while reading from device
- *   -EAGAIN device is still in bootloader
- *           if ->state = CYAPA_STATE_BL_IDLE, device has invalid firmware
- *   -EINVAL device is in operational mode, but not supported by this driver
- *   0       device is supported
+ * When Idle_Time < 100, the format to convert Idle_Time to Idle_Command is:
+ *   Idle_Command = Idle Time / 10;
+ * When Idle_Time >= 100, the format to convert Idle_Time to Idle_Command is:
+ *   Idle_Command = Idle Time / 20 + 5;
  */
-static int cyapa_check_is_operational(struct cyapa *cyapa)
+u8 cyapa_sleep_time_to_pwr_cmd(u16 sleep_time)
 {
-	struct device *dev = &cyapa->client->dev;
-	static const char unique_str[] = "CYTRA";
-	int ret;
-
-	ret = cyapa_poll_state(cyapa, 2000);
-	if (ret < 0)
-		return ret;
-	switch (cyapa->state) {
-	case CYAPA_STATE_BL_ACTIVE:
-		ret = cyapa_bl_deactivate(cyapa);
-		if (ret)
-			return ret;
-
-	/* Fallthrough state */
-	case CYAPA_STATE_BL_IDLE:
-		ret = cyapa_bl_exit(cyapa);
-		if (ret)
-			return ret;
-
-	/* Fallthrough state */
-	case CYAPA_STATE_OP:
-		ret = cyapa_get_query_data(cyapa);
-		if (ret < 0)
-			return ret;
-
-		/* only support firmware protocol gen3 */
-		if (cyapa->gen != CYAPA_GEN3) {
-			dev_err(dev, "unsupported protocol version (%d)",
-				cyapa->gen);
-			return -EINVAL;
-		}
-
-		/* only support product ID starting with CYTRA */
-		if (memcmp(cyapa->product_id, unique_str,
-			   sizeof(unique_str) - 1) != 0) {
-			dev_err(dev, "unsupported product ID (%s)\n",
-				cyapa->product_id);
-			return -EINVAL;
-		}
-		return 0;
+	sleep_time = clamp_pwr_cmd_sleep_time(sleep_time);
 
-	default:
-		return -EIO;
-	}
-	return 0;
+	if (sleep_time < 100)
+		return ((sleep_time / 10) << 2) & PWR_MODE_MASK;
+	return ((sleep_time / 20 + 5) << 2) & PWR_MODE_MASK;
 }
 
-static irqreturn_t cyapa_irq(int irq, void *dev_id)
+u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode)
 {
-	struct cyapa *cyapa = dev_id;
-	struct device *dev = &cyapa->client->dev;
-	struct input_dev *input = cyapa->input;
-	struct cyapa_reg_data data;
-	int i;
-	int ret;
-	int num_fingers;
+	u8 encoded_time = pwr_mode >> 2;
 
-	if (device_may_wakeup(dev))
-		pm_wakeup_event(dev, 0);
-
-	ret = cyapa_read_block(cyapa, CYAPA_CMD_GROUP_DATA, (u8 *)&data);
-	if (ret != sizeof(data))
-		goto out;
+	return (encoded_time < 10) ? encoded_time * 10
+				   : (encoded_time - 5) * 20;
+}
 
-	if ((data.device_status & OP_STATUS_SRC) != OP_STATUS_SRC ||
-	    (data.device_status & OP_STATUS_DEV) != CYAPA_DEV_NORMAL ||
-	    (data.finger_btn & OP_DATA_VALID) != OP_DATA_VALID) {
-		goto out;
-	}
+void cyapa_detect_async(void *data, async_cookie_t cookie)
+{
+	struct cyapa *cyapa = (struct cyapa *)data;
 
-	num_fingers = (data.finger_btn >> 4) & 0x0f;
-	for (i = 0; i < num_fingers; i++) {
-		const struct cyapa_touch *touch = &data.touches[i];
-		/* Note: touch->id range is 1 to 15; slots are 0 to 14. */
-		int slot = touch->id - 1;
-
-		input_mt_slot(input, slot);
-		input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
-		input_report_abs(input, ABS_MT_POSITION_X,
-				 ((touch->xy_hi & 0xf0) << 4) | touch->x_lo);
-		input_report_abs(input, ABS_MT_POSITION_Y,
-				 ((touch->xy_hi & 0x0f) << 8) | touch->y_lo);
-		input_report_abs(input, ABS_MT_PRESSURE, touch->pressure);
+	mutex_lock(&cyapa->state_sync_lock);
+	if (cyapa->removed) {
+		mutex_unlock(&cyapa->state_sync_lock);
+		return;
 	}
 
-	input_mt_sync_frame(input);
-
-	if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK)
-		input_report_key(input, BTN_LEFT,
-				 data.finger_btn & OP_DATA_LEFT_BTN);
-
-	if (cyapa->btn_capability & CAPABILITY_MIDDLE_BTN_MASK)
-		input_report_key(input, BTN_MIDDLE,
-				 data.finger_btn & OP_DATA_MIDDLE_BTN);
-
-	if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK)
-		input_report_key(input, BTN_RIGHT,
-				 data.finger_btn & OP_DATA_RIGHT_BTN);
-
-	input_sync(input);
+	/* Keep synchronized with sys interface process threads. */
+	cyapa_detect(cyapa);
 
-out:
-	return IRQ_HANDLED;
+	mutex_unlock(&cyapa->state_sync_lock);
 }
 
-static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
+static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
 {
-	u8 ret = CYAPA_ADAPTER_FUNC_NONE;
-
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-		ret |= CYAPA_ADAPTER_FUNC_I2C;
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA |
-				     I2C_FUNC_SMBUS_BLOCK_DATA |
-				     I2C_FUNC_SMBUS_I2C_BLOCK))
-		ret |= CYAPA_ADAPTER_FUNC_SMBUS;
-	return ret;
+	cyapa_detect_async(data, cookie);
 }
 
-static int cyapa_create_input_dev(struct cyapa *cyapa)
+static int cyapa_tp_modules_init(struct cyapa *cyapa)
 {
-	struct device *dev = &cyapa->client->dev;
-	int ret;
-	struct input_dev *input;
-
-	if (!cyapa->physical_size_x || !cyapa->physical_size_y)
-		return -EINVAL;
-
-	input = cyapa->input = input_allocate_device();
-	if (!input) {
-		dev_err(dev, "allocate memory for input device failed\n");
-		return -ENOMEM;
-	}
-
-	input->name = CYAPA_NAME;
-	input->phys = cyapa->phys;
-	input->id.bustype = BUS_I2C;
-	input->id.version = 1;
-	input->id.product = 0;  /* means any product in eventcomm. */
-	input->dev.parent = &cyapa->client->dev;
-
-	input_set_drvdata(input, cyapa);
-
-	__set_bit(EV_ABS, input->evbit);
-
-	/* finger position */
-	input_set_abs_params(input, ABS_MT_POSITION_X, 0, cyapa->max_abs_x, 0,
-			     0);
-	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, cyapa->max_abs_y, 0,
-			     0);
-	input_set_abs_params(input, ABS_MT_PRESSURE, 0, 255, 0, 0);
-
-	input_abs_set_res(input, ABS_MT_POSITION_X,
-			  cyapa->max_abs_x / cyapa->physical_size_x);
-	input_abs_set_res(input, ABS_MT_POSITION_Y,
-			  cyapa->max_abs_y / cyapa->physical_size_y);
-
-	if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK)
-		__set_bit(BTN_LEFT, input->keybit);
-	if (cyapa->btn_capability & CAPABILITY_MIDDLE_BTN_MASK)
-		__set_bit(BTN_MIDDLE, input->keybit);
-	if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK)
-		__set_bit(BTN_RIGHT, input->keybit);
-
-	if (cyapa->btn_capability == CAPABILITY_LEFT_BTN_MASK)
-		__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
-
-	/* handle pointer emulation and unused slots in core */
-	ret = input_mt_init_slots(input, CYAPA_MAX_MT_SLOTS,
-				  INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
-	if (ret) {
-		dev_err(dev, "allocate memory for MT slots failed, %d\n", ret);
-		goto err_free_device;
-	}
-
-	/* Register the device in input subsystem */
-	ret = input_register_device(input);
-	if (ret) {
-		dev_err(dev, "input device register failed, %d\n", ret);
-		goto err_free_device;
-	}
 	return 0;
+}
 
-err_free_device:
-	input_free_device(input);
-	cyapa->input = NULL;
-	return ret;
+static int cyapa_tp_modules_uninit(struct cyapa *cyapa)
+{
+	return 0;
 }
 
 static int cyapa_probe(struct i2c_client *client,
@@ -830,6 +465,7 @@ static int cyapa_probe(struct i2c_client *client,
 	u8 adapter_func;
 	struct cyapa *cyapa;
 	struct device *dev = &client->dev;
+	union i2c_smbus_data dummy;
 
 	adapter_func = cyapa_check_adapter_functionality(client);
 	if (adapter_func == CYAPA_ADAPTER_FUNC_NONE) {
@@ -837,39 +473,41 @@ static int cyapa_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
+	/* Make sure there is something at this address */
+	if (dev->of_node && i2c_smbus_xfer(client->adapter, client->addr, 0,
+			I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &dummy) < 0)
+		return -ENODEV;
+
 	cyapa = kzalloc(sizeof(struct cyapa), GFP_KERNEL);
-	if (!cyapa) {
-		dev_err(dev, "allocate memory for cyapa failed\n");
+	if (!cyapa)
 		return -ENOMEM;
-	}
 
-	cyapa->gen = CYAPA_GEN3;
 	cyapa->client = client;
 	i2c_set_clientdata(client, cyapa);
 	sprintf(cyapa->phys, "i2c-%d-%04x/input0", client->adapter->nr,
 		client->addr);
 
-	/* i2c isn't supported, use smbus */
-	if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
-		cyapa->smbus = true;
-	cyapa->state = CYAPA_STATE_NO_DEVICE;
-	ret = cyapa_check_is_operational(cyapa);
+	ret = cyapa_tp_modules_init(cyapa);
 	if (ret) {
-		dev_err(dev, "device not operational, %d\n", ret);
-		goto err_mem_free;
+		dev_err(dev, "initialize device modules failed.\n");
+		goto err_unregister_device;
 	}
 
-	ret = cyapa_create_input_dev(cyapa);
-	if (ret) {
-		dev_err(dev, "create input_dev instance failed, %d\n", ret);
-		goto err_mem_free;
-	}
+	cyapa->gen = CYAPA_GEN_UNKNOWN;
+	cyapa->ops = &cyapa_default_ops;
+	mutex_init(&cyapa->state_sync_lock);
 
-	ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
-	if (ret) {
-		dev_err(dev, "set active power failed, %d\n", ret);
-		goto err_unregister_device;
-	}
+	/* i2c isn't supported, use smbus */
+	if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
+		cyapa->smbus = true;
+	cyapa->state = CYAPA_STATE_NO_DEVICE;
+	/*
+	 * Set to hard code default, they will be updated with trackpad set
+	 * default values after probe and initialized.
+	 */
+	cyapa->suspend_power_mode = PWR_MODE_SLEEP;
+	cyapa->suspend_sleep_time =
+		cyapa_pwr_cmd_to_sleep_time(cyapa->suspend_power_mode);
 
 	cyapa->irq = client->irq;
 	ret = request_threaded_irq(cyapa->irq,
@@ -880,14 +518,17 @@ static int cyapa_probe(struct i2c_client *client,
 				   cyapa);
 	if (ret) {
 		dev_err(dev, "IRQ request failed: %d\n, ", ret);
-		goto err_unregister_device;
+		goto err_uninit_tp_modules;
 	}
 
+	async_schedule(cyapa_detect_and_start, cyapa);
 	return 0;
 
+err_uninit_tp_modules:
+	cyapa_tp_modules_uninit(cyapa);
 err_unregister_device:
 	input_unregister_device(cyapa->input);
-err_mem_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(cyapa);
 
 	return ret;
@@ -897,9 +538,18 @@ static int cyapa_remove(struct i2c_client *client)
 {
 	struct cyapa *cyapa = i2c_get_clientdata(client);
 
+	/* Make sure asynchronous thread run nothing when removing. */
+	mutex_lock(&cyapa->state_sync_lock);
+	cyapa->removed = true;
+	mutex_unlock(&cyapa->state_sync_lock);
+
 	free_irq(cyapa->irq, cyapa);
+
 	input_unregister_device(cyapa->input);
-	cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
+	if (cyapa->ops->set_power_mode)
+		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
+	cyapa_tp_modules_uninit(cyapa);
+	i2c_set_clientdata(client, NULL);
 	kfree(cyapa);
 
 	return 0;
@@ -912,17 +562,28 @@ static int cyapa_suspend(struct device *dev)
 	u8 power_mode;
 	struct cyapa *cyapa = dev_get_drvdata(dev);
 
+	cyapa->suspended = true;
+	/*
+	 * Disable IRQ to avoid the command response interrupt cause system
+	 * suspending process interrupted and failed.
+	 * Because the gen5 devices will always assert interrupt to host after
+	 * executed the set power mode command.
+	 */
 	disable_irq(cyapa->irq);
 
 	/*
 	 * Set trackpad device to idle mode if wakeup is allowed,
 	 * otherwise turn off.
 	 */
-	power_mode = device_may_wakeup(dev) ? PWR_MODE_IDLE
+	power_mode = device_may_wakeup(dev) ? cyapa->suspend_power_mode
 					    : PWR_MODE_OFF;
-	ret = cyapa_set_power_mode(cyapa, power_mode);
-	if (ret < 0)
-		dev_err(dev, "set power mode failed, %d\n", ret);
+	if (cyapa->ops->set_power_mode) {
+		ret = cyapa->ops->set_power_mode(cyapa, power_mode,
+				cyapa->suspend_sleep_time);
+		if (ret < 0)
+			dev_err(dev, "suspend set power mode failed, %d\n",
+					ret);
+	}
 
 	if (device_may_wakeup(dev))
 		cyapa->irq_wake = (enable_irq_wake(cyapa->irq) == 0);
@@ -936,17 +597,25 @@ static int cyapa_resume(struct device *dev)
 
 	if (device_may_wakeup(dev) && cyapa->irq_wake)
 		disable_irq_wake(cyapa->irq);
+	enable_irq(cyapa->irq);
+	cyapa->suspended = false;
 
-	ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
-	if (ret)
-		dev_warn(dev, "resume active power failed, %d\n", ret);
+	if (cyapa->ops->set_power_mode) {
+		ret = cyapa->ops->set_power_mode(cyapa,
+			PWR_MODE_FULL_ACTIVE, 0);
+		if (ret)
+			dev_warn(dev, "resume active power failed, %d\n", ret);
+	}
+
+	async_schedule(cyapa_detect_async, cyapa);
 
-	enable_irq(cyapa->irq);
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static SIMPLE_DEV_PM_OPS(cyapa_pm_ops, cyapa_suspend, cyapa_resume);
+static const struct dev_pm_ops cyapa_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(cyapa_suspend, cyapa_resume)
+};
 
 static const struct i2c_device_id cyapa_id_table[] = {
 	{ "cyapa", 0 },
@@ -966,7 +635,26 @@ static struct i2c_driver cyapa_driver = {
 	.id_table = cyapa_id_table,
 };
 
-module_i2c_driver(cyapa_driver);
+static int __init cyapa_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&cyapa_driver);
+	if (ret) {
+		pr_err("cyapa driver register FAILED.\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit cyapa_exit(void)
+{
+	i2c_del_driver(&cyapa_driver);
+}
+
+module_init(cyapa_init);
+module_exit(cyapa_exit);
 
 MODULE_DESCRIPTION("Cypress APA I2C Trackpad Driver");
 MODULE_AUTHOR("Dudley Du <dudl@cypress.com>");
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
new file mode 100644
index 0000000..636fea9
--- /dev/null
+++ b/drivers/input/mouse/cyapa.h
@@ -0,0 +1,275 @@
+/*
+ * Cypress APA trackpad with I2C interface
+ *
+ * Author: Dudley Du <dudl@cypress.com>
+ *
+ * Copyright (C) 2014 Cypress Semiconductor, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
+ */
+
+#ifndef _CYAPA_H
+#define _CYAPA_H
+
+#include <linux/async.h>
+#include <linux/firmware.h>
+
+/* APA trackpad firmware generation number. */
+#define CYAPA_GEN_UNKNOWN   0x00   /* unknown protocol. */
+#define CYAPA_GEN3   0x03   /* support MT-protocol B with tracking ID. */
+#define CYAPA_GEN5   0x05   /* support TrueTouch GEN5 trackpad device. */
+
+#define CYAPA_NAME   "Cypress APA Trackpad (cyapa)"
+
+/*
+ * Macros for SMBus communication
+ */
+#define SMBUS_READ   0x01
+#define SMBUS_WRITE 0x00
+#define SMBUS_ENCODE_IDX(cmd, idx) ((cmd) | (((idx) & 0x03) << 1))
+#define SMBUS_ENCODE_RW(cmd, rw) ((cmd) | ((rw) & 0x01))
+#define SMBUS_BYTE_BLOCK_CMD_MASK 0x80
+#define SMBUS_GROUP_BLOCK_CMD_MASK 0x40
+
+/* Commands for read/write registers of Cypress trackpad */
+#define CYAPA_CMD_SOFT_RESET       0x00
+#define CYAPA_CMD_POWER_MODE       0x01
+#define CYAPA_CMD_DEV_STATUS       0x02
+#define CYAPA_CMD_GROUP_DATA       0x03
+#define CYAPA_CMD_GROUP_CMD        0x04
+#define CYAPA_CMD_GROUP_QUERY      0x05
+#define CYAPA_CMD_BL_STATUS        0x06
+#define CYAPA_CMD_BL_HEAD          0x07
+#define CYAPA_CMD_BL_CMD           0x08
+#define CYAPA_CMD_BL_DATA          0x09
+#define CYAPA_CMD_BL_ALL           0x0a
+#define CYAPA_CMD_BLK_PRODUCT_ID   0x0b
+#define CYAPA_CMD_BLK_HEAD         0x0c
+#define CYAPA_CMD_MAX_BASELINE     0x0d
+#define CYAPA_CMD_MIN_BASELINE     0x0e
+
+#define BL_HEAD_OFFSET 0x00
+#define BL_DATA_OFFSET 0x10
+
+#define BL_STATUS_SIZE  3  /* Length of gen3 bootloader status registers */
+#define CYAPA_REG_MAP_SIZE  256
+
+/*
+ * Gen3 Operational Device Status Register
+ *
+ * bit 7: Valid interrupt source
+ * bit 6 - 4: Reserved
+ * bit 3 - 2: Power status
+ * bit 1 - 0: Device status
+ */
+#define REG_OP_STATUS     0x00
+#define OP_STATUS_SRC     0x80
+#define OP_STATUS_POWER   0x0c
+#define OP_STATUS_DEV     0x03
+#define OP_STATUS_MASK (OP_STATUS_SRC | OP_STATUS_POWER | OP_STATUS_DEV)
+
+/*
+ * Operational Finger Count/Button Flags Register
+ *
+ * bit 7 - 4: Number of touched finger
+ * bit 3: Valid data
+ * bit 2: Middle Physical Button
+ * bit 1: Right Physical Button
+ * bit 0: Left physical Button
+ */
+#define REG_OP_DATA1       0x01
+#define OP_DATA_VALID      0x08
+#define OP_DATA_MIDDLE_BTN 0x04
+#define OP_DATA_RIGHT_BTN  0x02
+#define OP_DATA_LEFT_BTN   0x01
+#define OP_DATA_BTN_MASK (OP_DATA_MIDDLE_BTN | OP_DATA_RIGHT_BTN | \
+			  OP_DATA_LEFT_BTN)
+
+/*
+ * Write-only command file register used to issue commands and
+ * parameters to the bootloader.
+ * The default value read from it is always 0x00.
+ */
+#define REG_BL_FILE	0x00
+#define BL_FILE		0x00
+
+/*
+ * Bootloader Status Register
+ *
+ * bit 7: Busy
+ * bit 6 - 5: Reserved
+ * bit 4: Bootloader running
+ * bit 3 - 2: Reserved
+ * bit 1: Watchdog Reset
+ * bit 0: Checksum valid
+ */
+#define REG_BL_STATUS        0x01
+#define BL_STATUS_REV_6_5    0x60
+#define BL_STATUS_BUSY       0x80
+#define BL_STATUS_RUNNING    0x10
+#define BL_STATUS_REV_3_2    0x0c
+#define BL_STATUS_WATCHDOG   0x02
+#define BL_STATUS_CSUM_VALID 0x01
+#define BL_STATUS_REV_MASK (BL_STATUS_WATCHDOG | BL_STATUS_REV_3_2 | \
+			    BL_STATUS_REV_6_5)
+
+/*
+ * Bootloader Error Register
+ *
+ * bit 7: Invalid
+ * bit 6: Invalid security key
+ * bit 5: Bootloading
+ * bit 4: Command checksum
+ * bit 3: Flash protection error
+ * bit 2: Flash checksum error
+ * bit 1 - 0: Reserved
+ */
+#define REG_BL_ERROR         0x02
+#define BL_ERROR_INVALID     0x80
+#define BL_ERROR_INVALID_KEY 0x40
+#define BL_ERROR_BOOTLOADING 0x20
+#define BL_ERROR_CMD_CSUM    0x10
+#define BL_ERROR_FLASH_PROT  0x08
+#define BL_ERROR_FLASH_CSUM  0x04
+#define BL_ERROR_RESERVED    0x03
+#define BL_ERROR_NO_ERR_IDLE    0x00
+#define BL_ERROR_NO_ERR_ACTIVE  (BL_ERROR_BOOTLOADING)
+
+#define CAPABILITY_BTN_SHIFT            3
+#define CAPABILITY_LEFT_BTN_MASK	(0x01 << 3)
+#define CAPABILITY_RIGHT_BTN_MASK	(0x01 << 4)
+#define CAPABILITY_MIDDLE_BTN_MASK	(0x01 << 5)
+#define CAPABILITY_BTN_MASK  (CAPABILITY_LEFT_BTN_MASK | \
+			      CAPABILITY_RIGHT_BTN_MASK | \
+			      CAPABILITY_MIDDLE_BTN_MASK)
+
+#define PWR_MODE_MASK   0xfc
+#define PWR_MODE_FULL_ACTIVE (0x3f << 2)
+#define PWR_MODE_IDLE        (0x03 << 2) /* Default rt suspend scanrate: 30ms */
+#define PWR_MODE_SLEEP       (0x05 << 2) /* Default suspend scanrate: 50ms */
+#define PWR_MODE_BTN_ONLY    (0x01 << 2)
+#define PWR_MODE_OFF         (0x00 << 2)
+
+#define PWR_STATUS_MASK      0x0c
+#define PWR_STATUS_ACTIVE    (0x03 << 2)
+#define PWR_STATUS_IDLE      (0x02 << 2)
+#define PWR_STATUS_BTN_ONLY  (0x01 << 2)
+#define PWR_STATUS_OFF       (0x00 << 2)
+
+#define AUTOSUSPEND_DELAY   2000 /* unit : ms */
+
+#define BTN_ONLY_MODE_NAME   "buttononly"
+#define OFF_MODE_NAME        "off"
+
+/* The touch.id is used as the MT slot id, thus max MT slot is 15 */
+#define CYAPA_MAX_MT_SLOTS  15
+
+struct cyapa;
+
+typedef bool (*cb_sort)(struct cyapa *, u8 *, int);
+
+struct cyapa_dev_ops {
+	int (*initialize)(struct cyapa *cyapa);
+	int (*uninitialize)(struct cyapa *cyapa);
+
+	int (*state_parse)(struct cyapa *cyapa, u8 *reg_status, int len);
+	int (*operational_check)(struct cyapa *cyapa);
+
+	void (*irq_handler)(struct cyapa *);
+	bool (*irq_cmd_handler)(struct cyapa *);
+	int (*sort_empty_output_data)(struct cyapa *,
+			u8 *, int *, cb_sort);
+
+	int (*set_power_mode)(struct cyapa *, u8, u16);
+};
+
+enum cyapa_state {
+	CYAPA_STATE_OP,
+	CYAPA_STATE_BL_IDLE,
+	CYAPA_STATE_BL_ACTIVE,
+	CYAPA_STATE_GEN5_BL,
+	CYAPA_STATE_GEN5_APP,
+	CYAPA_STATE_BL_BUSY,
+	CYAPA_STATE_NO_DEVICE,
+};
+
+/* The main device structure */
+struct cyapa {
+	enum cyapa_state state;
+	u8 status[BL_STATUS_SIZE];
+
+	struct i2c_client *client;
+	struct input_dev *input;
+	char phys[32];	/* Device physical location */
+	int irq;
+	bool irq_wake;  /* Irq wake is enabled */
+	bool smbus;
+
+	/* power mode settings */
+	u8 suspend_power_mode;
+	u16 suspend_sleep_time;
+#ifdef CONFIG_PM_RUNTIME
+	u8 runtime_suspend_power_mode;
+	u16 runtime_suspend_sleep_time;
+#endif /* CONFIG_PM_RUNTIME */
+	bool suspended;
+
+	/* Read from query data region. */
+	char product_id[16];
+	u8 fw_maj_ver;  /* Firmware major version. */
+	u8 fw_min_ver;  /* Firmware minor version. */
+	u8 btn_capability;
+	u8 gen;
+	int max_abs_x;
+	int max_abs_y;
+	int physical_size_x;
+	int physical_size_y;
+
+	/* Used in ttsp and truetouch based trackpad devices. */
+	u8 x_origin;  /* X Axis Origin: 0 = left side; 1 = rigth side. */
+	u8 y_origin;  /* Y Axis Origin: 0 = top; 1 = bottom. */
+	int electrodes_x;  /* Number of electrodes on the X Axis*/
+	int electrodes_y;  /* Number of electrodes on the Y Axis*/
+	int electrodes_rx;  /* Number of Rx electrodes */
+	int max_z;
+
+	/*
+	 * Used to synchronize the access or update the device state.
+	 * And since update firmware and read firmware image process will take
+	 * quite long time, maybe more than 10 seconds, so use mutex_lock
+	 * to sync and wait other interface and detecting are done or ready.
+	 */
+	struct mutex state_sync_lock;
+	bool removed;
+
+	const struct cyapa_dev_ops *ops;
+};
+
+
+ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
+				u8 *values);
+ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
+				size_t len, const u8 *values);
+ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
+				u8 *values);
+
+s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx);
+s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value);
+ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values);
+
+ssize_t cyapa_i2c_read(struct cyapa *cyapa, u8 reg, size_t len, u8 *values);
+ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
+				size_t len, const void *values);
+
+int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout);
+void cyapa_detect_async(void *data, async_cookie_t cookie);
+
+u8 cyapa_sleep_time_to_pwr_cmd(u16 sleep_time);
+u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode);
+
+
+extern const char unique_str[];
+
+#endif
-- 
1.9.1


