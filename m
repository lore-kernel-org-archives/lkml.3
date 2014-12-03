Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaLCJby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:31:54 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36759 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaLCJbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:31:48 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 03/19] input: cyapa: re-design driver to support multi-trackpad in one driver
Date: Wed,  3 Dec 2014 17:30:09 +0800
Message-Id: <1417599025-21681-4-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support multiple different chipsets and communication protocols
trackpad devices in one cyapa driver, the new cyapa driver is re-designed
with one cyapa driver core and multiple device specific functions component.
The cyapa driver core is contained in this patch, it supplies basic functions
that working with kernel and input subsystem, and also supplies the interfaces
that the specific devices' component can connect and work together with as
one driver.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/Makefile     |    3 +-
 drivers/input/mouse/cyapa.c      | 1063 +++++++++++++++-----------------------
 drivers/input/mouse/cyapa.h      |  316 +++++++++++
 drivers/input/mouse/cyapa_gen3.c |  792 ++++++++++++++++++++++++++++
 4 files changed, 1513 insertions(+), 661 deletions(-)
 create mode 100644 drivers/input/mouse/cyapa.h
 create mode 100644 drivers/input/mouse/cyapa_gen3.c

diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index dda507f..4bf6c83 100644
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
@@ -23,6 +23,7 @@ obj-$(CONFIG_MOUSE_SYNAPTICS_I2C)	+= synaptics_i2c.o
 obj-$(CONFIG_MOUSE_SYNAPTICS_USB)	+= synaptics_usb.o
 obj-$(CONFIG_MOUSE_VSXXXAA)		+= vsxxxaa.o
 
+cyapatp-objs := cyapa.o cyapa_gen3.o
 psmouse-objs := psmouse-base.o synaptics.o focaltech.o
 
 psmouse-$(CONFIG_MOUSE_PS2_ALPS)	+= alps.o
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index d8f1dfe..9287979 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -20,409 +20,107 @@
 #include <linux/input/mt.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
+#include "cyapa.h"
 
-/* APA trackpad firmware generation */
-#define CYAPA_GEN3   0x03   /* support MT-protocol B with tracking ID. */
-
-#define CYAPA_NAME   "Cypress APA Trackpad (cyapa)"
-
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
-
-/* report data start reg offset address. */
-#define DATA_REG_START_OFFSET  0x0000
-
-#define BL_HEAD_OFFSET 0x00
-#define BL_DATA_OFFSET 0x10
-
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
-
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
-
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
-
-/*
- * Bootloader Error Register
- *
- * bit 7: Invalid
- * bit 6: Invalid security key
- * bit 5: Bootloading
- * bit 4: Command checksum
- * bit 3: Flash protection error
- * bit 2: Flash checksum error
- * bit 1 - 0: Reserved
- */
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
-
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
-
-
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
-	/*
-	 * bit 7 - 4: number of fingers currently touching pad
-	 * bit 3: valid data check bit
-	 * bit 2: middle mechanism button state if exists
-	 * bit 1: right mechanism button state if exists
-	 * bit 0: left mechanism button state if exists
-	 */
-	u8 finger_btn;
-	/* CYAPA reports up to 5 touches per packet. */
-	struct cyapa_touch touches[5];
-} __packed;
-
-/* The main device structure */
-struct cyapa {
-	enum cyapa_state state;
-
-	struct i2c_client *client;
-	struct input_dev *input;
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
-
-static const u8 bl_deactivate[] = { 0x00, 0xff, 0x3b, 0x00, 0x01, 0x02, 0x03,
-		0x04, 0x05, 0x06, 0x07 };
-static const u8 bl_exit[] = { 0x00, 0xff, 0xa5, 0x00, 0x01, 0x02, 0x03, 0x04,
-		0x05, 0x06, 0x07 };
-
-struct cyapa_cmd_len {
-	u8 cmd;
-	u8 len;
-};
 
 #define CYAPA_ADAPTER_FUNC_NONE   0
 #define CYAPA_ADAPTER_FUNC_I2C    1
 #define CYAPA_ADAPTER_FUNC_SMBUS  2
 #define CYAPA_ADAPTER_FUNC_BOTH   3
 
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
+const char unique_str[] = "CYTRA";
 
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
+static int cyapa_reinitialize(struct cyapa *cyapa);
 
-static ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
+/* Returns 0 on success, else negative errno on failure. */
+ssize_t cyapa_i2c_read(struct cyapa *cyapa, u8 reg, size_t len,
 					u8 *values)
 {
-	return i2c_smbus_read_i2c_block_data(cyapa->client, reg, len, values);
-}
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
 
-static ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
-					 size_t len, const u8 *values)
-{
-	return i2c_smbus_write_i2c_block_data(cyapa->client, reg, len, values);
+	return 0;
 }
 
-/*
- * cyapa_smbus_read_block - perform smbus block read command
- * @cyapa  - private data structure of the driver
- * @cmd    - the properly encoded smbus command
- * @len    - expected length of smbus command result
- * @values - buffer to store smbus command result
- *
- * Returns negative errno, else the number of bytes written.
+/**
+ * cyapa_i2c_write - Execute i2c block data write operation
+ * @cyapa: Handle to this driver
+ * @ret: Offset of the data to written in the register map
+ * @len: number of bytes to write
+ * @values: Data to be written
  *
- * Note:
- * In trackpad device, the memory block allocated for I2C register map
- * is 256 bytes, so the max read block for I2C bus is 256 bytes.
+ * Return negative errno code on error; return zero when success.
  */
-static ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
-				      u8 *values)
+ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
+					 size_t len, const void *values)
 {
-	ssize_t ret;
-	u8 index;
-	u8 smbus_cmd;
-	u8 *buf;
+	int ret;
 	struct i2c_client *client = cyapa->client;
+	char data[32], *buf;
 
-	if (!(SMBUS_BYTE_BLOCK_CMD_MASK & cmd))
-		return -EINVAL;
-
-	if (SMBUS_GROUP_BLOCK_CMD_MASK & cmd) {
-		/* read specific block registers command. */
-		smbus_cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
-		ret = i2c_smbus_read_block_data(client, smbus_cmd, values);
-		goto out;
-	}
-
-	ret = 0;
-	for (index = 0; index * I2C_SMBUS_BLOCK_MAX < len; index++) {
-		smbus_cmd = SMBUS_ENCODE_IDX(cmd, index);
-		smbus_cmd = SMBUS_ENCODE_RW(smbus_cmd, SMBUS_READ);
-		buf = values + I2C_SMBUS_BLOCK_MAX * index;
-		ret = i2c_smbus_read_block_data(client, smbus_cmd, buf);
-		if (ret < 0)
-			goto out;
-	}
-
-out:
-	return ret > 0 ? len : ret;
-}
-
-static s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx)
-{
-	u8 cmd;
-
-	if (cyapa->smbus) {
-		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
-		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
+	if (len > 31) {
+		buf = kzalloc(len + 1, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
 	} else {
-		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+		buf = data;
 	}
-	return i2c_smbus_read_byte_data(cyapa->client, cmd);
-}
 
-static s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value)
-{
-	u8 cmd;
+	buf[0] = reg;
+	memcpy(&buf[1], values, len);
+	ret = i2c_master_send(client, buf, len + 1);
 
-	if (cyapa->smbus) {
-		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
-		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_WRITE);
-	} else {
-		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
-	}
-	return i2c_smbus_write_byte_data(cyapa->client, cmd, value);
+	if (buf != data)
+		kfree(buf);
+	return (ret == (len + 1)) ? 0 : ((ret < 0) ? ret : -EIO);
 }
 
-static ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values)
+static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
 {
-	u8 cmd;
-	size_t len;
-
-	if (cyapa->smbus) {
-		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
-		len = cyapa_smbus_cmds[cmd_idx].len;
-		return cyapa_smbus_read_block(cyapa, cmd, len, values);
-	}
+	u8 ret = CYAPA_ADAPTER_FUNC_NONE;
 
-	cmd = cyapa_i2c_cmds[cmd_idx].cmd;
-	len = cyapa_i2c_cmds[cmd_idx].len;
-	return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		ret |= CYAPA_ADAPTER_FUNC_I2C;
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA |
+				     I2C_FUNC_SMBUS_BLOCK_DATA |
+				     I2C_FUNC_SMBUS_I2C_BLOCK))
+		ret |= CYAPA_ADAPTER_FUNC_SMBUS;
+	return ret;
 }
 
 /*
  * Query device for its current operating state.
- *
  */
 static int cyapa_get_state(struct cyapa *cyapa)
 {
 	u8 status[BL_STATUS_SIZE];
+	u8 cmd[32];
+	/* The i2c address of gen4 and gen5 trackpad device must be even. */
+	bool even_addr = ((cyapa->client->addr & 0x0001) == 0);
+	bool smbus = false;
+	int retries = 2;
 	int error;
 
 	cyapa->state = CYAPA_STATE_NO_DEVICE;
@@ -441,32 +139,57 @@ static int cyapa_get_state(struct cyapa *cyapa)
 	 * -ETIMEDOUT.  In this case, try again using the smbus equivalent
 	 * command.  This should return a BL_HEAD indicating CYAPA_STATE_OP.
 	 */
-	if (cyapa->smbus && (error == -ETIMEDOUT || error == -ENXIO))
-		error = cyapa_read_block(cyapa, CYAPA_CMD_BL_STATUS, status);
+	if (cyapa->smbus && (error == -ETIMEDOUT || error == -ENXIO)) {
+		if (!even_addr)
+			error = cyapa_read_block(cyapa,
+					CYAPA_CMD_BL_STATUS, status);
+		smbus = true;
+	}
 
 	if (error != BL_STATUS_SIZE)
 		goto error;
 
-	if ((status[REG_OP_STATUS] & OP_STATUS_SRC) == OP_STATUS_SRC) {
-		switch (status[REG_OP_STATUS] & OP_STATUS_DEV) {
-		case CYAPA_DEV_NORMAL:
-		case CYAPA_DEV_BUSY:
-			cyapa->state = CYAPA_STATE_OP;
-			break;
-		default:
-			error = -EAGAIN;
-			goto error;
+	/*
+	 * Detect trackpad protocol based on characristic registers and bits.
+	 */
+	do {
+		cyapa->status[REG_OP_STATUS] = status[REG_OP_STATUS];
+		cyapa->status[REG_BL_STATUS] = status[REG_BL_STATUS];
+		cyapa->status[REG_BL_ERROR] = status[REG_BL_ERROR];
+
+		if (cyapa->gen == CYAPA_GEN_UNKNOWN ||
+				cyapa->gen == CYAPA_GEN3) {
+			error = cyapa_gen3_ops.state_parse(cyapa,
+					status, BL_STATUS_SIZE);
+			if (!error)
+				goto out_detected;
 		}
-	} else {
-		if (status[REG_BL_STATUS] & BL_STATUS_BUSY)
-			cyapa->state = CYAPA_STATE_BL_BUSY;
-		else if (status[REG_BL_ERROR] & BL_ERROR_BOOTLOADING)
-			cyapa->state = CYAPA_STATE_BL_ACTIVE;
-		else
-			cyapa->state = CYAPA_STATE_BL_IDLE;
-	}
 
+		/*
+		 * Write 0x00 0x00 to trackpad device to force update its
+		 * status, then redo the detection again.
+		 */
+		if (!smbus) {
+			cmd[0] = 0x00;
+			cmd[1] = 0x00;
+			error = cyapa_i2c_write(cyapa, 0, 2, cmd);
+			if (error)
+				goto error;
+
+			msleep(50);
+
+			error = cyapa_i2c_read(cyapa, BL_HEAD_OFFSET,
+					BL_STATUS_SIZE, status);
+			if (error)
+				goto error;
+		}
+	} while (--retries > 0 && !smbus);
+
+	goto error;
+
+out_detected:
 	return 0;
+
 error:
 	return (error < 0) ? error : -EAGAIN;
 }
@@ -485,138 +208,18 @@ error:
  *   -ETIMEDOUT if device never responds (too many -EAGAIN)
  *   < 0    other errors
  */
-static int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
+int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
 {
 	int error;
 	int tries = timeout / 100;
 
 	error = cyapa_get_state(cyapa);
-	while ((error || cyapa->state >= CYAPA_STATE_BL_BUSY) && tries--) {
+	while ((error || cyapa->state <= CYAPA_STATE_BL_BUSY) && tries--) {
 		msleep(100);
 		error = cyapa_get_state(cyapa);
 	}
-	return (error == -EAGAIN || error == -ETIMEDOUT) ? -ETIMEDOUT : error;
-}
-
-static int cyapa_bl_deactivate(struct cyapa *cyapa)
-{
-	int error;
-
-	error = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_deactivate),
-					bl_deactivate);
-	if (error)
-		return error;
-
-	/* wait for bootloader to switch to idle state; should take < 100ms */
-	msleep(100);
-	error = cyapa_poll_state(cyapa, 500);
-	if (error)
-		return error;
-	if (cyapa->state != CYAPA_STATE_BL_IDLE)
-		return -EAGAIN;
-	return 0;
-}
-
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
-{
-	int error;
 
-	error = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_exit), bl_exit);
-	if (error)
-		return error;
-
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
-	error = cyapa_poll_state(cyapa, 2000);
-	if (error < 0)
-		return error;
-	if (cyapa->state != CYAPA_STATE_OP)
-		return -EAGAIN;
-
-	return 0;
-}
-
-/*
- * Set device power mode
- *
- */
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
-
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
-{
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
-
-	return 0;
+	return (error == -EAGAIN || error == -ETIMEDOUT) ? -ETIMEDOUT : error;
 }
 
 /*
@@ -626,8 +229,10 @@ static int cyapa_get_query_data(struct cyapa *cyapa)
  * firmware supported by this driver.
  *
  * Returns:
+ *   -ENODEV no device
  *   -EBUSY  no device or in bootloader
  *   -EIO    failure while reading from device
+ *   -ETIMEDOUT timeout failure for bus idle or bus no response
  *   -EAGAIN device is still in bootloader
  *           if ->state = CYAPA_STATE_BL_IDLE, device has invalid firmware
  *   -EINVAL device is in operational mode, but not supported by this driver
@@ -635,138 +240,106 @@ static int cyapa_get_query_data(struct cyapa *cyapa)
  */
 static int cyapa_check_is_operational(struct cyapa *cyapa)
 {
-	struct device *dev = &cyapa->client->dev;
-	static const char unique_str[] = "CYTRA";
 	int error;
 
-	error = cyapa_poll_state(cyapa, 2000);
+	error = cyapa_poll_state(cyapa, 4000);
 	if (error)
 		return error;
-	switch (cyapa->state) {
-	case CYAPA_STATE_BL_ACTIVE:
-		error = cyapa_bl_deactivate(cyapa);
-		if (error)
-			return error;
-
-	/* Fallthrough state */
-	case CYAPA_STATE_BL_IDLE:
-		error = cyapa_bl_exit(cyapa);
-		if (error)
-			return error;
 
-	/* Fallthrough state */
-	case CYAPA_STATE_OP:
-		error = cyapa_get_query_data(cyapa);
-		if (error)
-			return error;
+	switch (cyapa->gen) {
+	case CYAPA_GEN3:
+		cyapa->ops = &cyapa_gen3_ops;
+		break;
+	default:
+		return -ENODEV;
+	}
 
-		/* only support firmware protocol gen3 */
-		if (cyapa->gen != CYAPA_GEN3) {
-			dev_err(dev, "unsupported protocol version (%d)",
-				cyapa->gen);
-			return -EINVAL;
-		}
+	if (cyapa->ops->operational_check)
+		error = cyapa->ops->operational_check(cyapa);
 
-		/* only support product ID starting with CYTRA */
-		if (memcmp(cyapa->product_id, unique_str,
-			   sizeof(unique_str) - 1) != 0) {
-			dev_err(dev, "unsupported product ID (%s)\n",
-				cyapa->product_id);
-			return -EINVAL;
-		}
-		return 0;
+	if (!error && CYAPA_OPERATIONAL(cyapa))
+		cyapa->operational = true;
+	else
+		cyapa->operational = false;
 
-	default:
-		return -EIO;
-	}
-	return 0;
+	return error;
 }
 
-static irqreturn_t cyapa_irq(int irq, void *dev_id)
+
+/*
+ * Returns 0 on device detected, negative errno on no device detected.
+ * And when the device is detected and opertaional, it will be reset to
+ * full power active mode automatically.
+ */
+int cyapa_detect(struct cyapa *cyapa)
 {
-	struct cyapa *cyapa = dev_id;
 	struct device *dev = &cyapa->client->dev;
-	struct input_dev *input = cyapa->input;
-	struct cyapa_reg_data data;
-	int i;
-	int ret;
-	int num_fingers;
-
-	if (device_may_wakeup(dev))
-		pm_wakeup_event(dev, 0);
-
-	ret = cyapa_read_block(cyapa, CYAPA_CMD_GROUP_DATA, (u8 *)&data);
-	if (ret != sizeof(data))
-		goto out;
+	int error;
 
-	if ((data.device_status & OP_STATUS_SRC) != OP_STATUS_SRC ||
-	    (data.device_status & OP_STATUS_DEV) != CYAPA_DEV_NORMAL ||
-	    (data.finger_btn & OP_DATA_VALID) != OP_DATA_VALID) {
-		goto out;
-	}
+	error = cyapa_check_is_operational(cyapa);
+	if (error) {
+		if (error != -ETIMEDOUT && error != -ENODEV &&
+			CYAPA_BOOTLOADER(cyapa)) {
+			dev_warn(dev, "device detected but not operational\n");
+			return 0;
+		}
 
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
+		dev_err(dev, "no device detected, (%d)\n", error);
+		return error;
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
-
-out:
-	return IRQ_HANDLED;
-}
-
-static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
-{
-	u8 ret = CYAPA_ADAPTER_FUNC_NONE;
-
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-		ret |= CYAPA_ADAPTER_FUNC_I2C;
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA |
-				     I2C_FUNC_SMBUS_BLOCK_DATA |
-				     I2C_FUNC_SMBUS_I2C_BLOCK))
-		ret |= CYAPA_ADAPTER_FUNC_SMBUS;
-	return ret;
+	return 0;
 }
 
 static int cyapa_open(struct input_dev *input)
 {
 	struct cyapa *cyapa = input_get_drvdata(input);
 	struct i2c_client *client = cyapa->client;
+	int error;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+
+	if (cyapa->operational && cyapa->ops->set_power_mode) {
+		/*
+		 * though failed to set active power mode,
+		 * but still may be able to work in lower scan rate
+		 * when in operational mode.
+		 */
+		error = cyapa->ops->set_power_mode(cyapa,
+				PWR_MODE_FULL_ACTIVE, 0);
+		if (error) {
+			dev_warn(&client->dev,
+				"set active power failed: %d\n", error);
+			goto out;
+		}
+	} else {
+		error = cyapa_reinitialize(cyapa);
+		if (error || !cyapa->operational) {
+			error = error ? error : -EAGAIN;
+			goto out;
+		}
+	}
 
 	enable_irq(client->irq);
-	return 0;
+out:
+	mutex_unlock(&cyapa->state_sync_lock);
+	return error;
 }
 
 static void cyapa_close(struct input_dev *input)
 {
 	struct cyapa *cyapa = input_get_drvdata(input);
+	struct i2c_client *client = cyapa->client;
 
-	disable_irq(cyapa->client->irq);
+	mutex_lock(&cyapa->state_sync_lock);
+
+	disable_irq(client->irq);
+	if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode)
+		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
+
+	mutex_unlock(&cyapa->state_sync_lock);
 }
 
 static int cyapa_create_input_dev(struct cyapa *cyapa)
@@ -803,7 +376,28 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 			     0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, cyapa->max_abs_y, 0,
 			     0);
-	input_set_abs_params(input, ABS_MT_PRESSURE, 0, 255, 0, 0);
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
 
 	input_abs_set_res(input, ABS_MT_POSITION_X,
 			  cyapa->max_abs_x / cyapa->physical_size_x);
@@ -839,12 +433,149 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	return 0;
 }
 
+/*
+ * cyapa_sleep_time_to_pwr_cmd and cyapa_pwr_cmd_to_sleep_time
+ *
+ * These are helper functions that convert to and from integer idle
+ * times and register settings to write to the PowerMode register.
+ * The trackpad supports between 20ms to 1000ms scan intervals.
+ * The time will be increased in increments of 10ms from 20ms to 100ms.
+ * From 100ms to 1000ms, time will be increased in increments of 20ms.
+ *
+ * When Idle_Time < 100, the format to convert Idle_Time to Idle_Command is:
+ *   Idle_Command = Idle Time / 10;
+ * When Idle_Time >= 100, the format to convert Idle_Time to Idle_Command is:
+ *   Idle_Command = Idle Time / 20 + 5;
+ */
+u8 cyapa_sleep_time_to_pwr_cmd(u16 sleep_time)
+{
+	u16 encoded_time;
+
+	sleep_time = clamp_val(sleep_time, 20, 1000);
+	encoded_time = sleep_time < 100 ? sleep_time / 10 : sleep_time / 20 + 5;
+	return (encoded_time << 2) & PWR_MODE_MASK;
+}
+
+u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode)
+{
+	u8 encoded_time = pwr_mode >> 2;
+
+	return (encoded_time < 10) ? encoded_time * 10
+				   : (encoded_time - 5) * 20;
+}
+
+/* 0 on driver initialize and detected successfully, negative on failure. */
+static int cyapa_initialize(struct cyapa *cyapa)
+{
+	int error = 0;
+
+	cyapa->state = CYAPA_STATE_NO_DEVICE;
+	cyapa->gen = CYAPA_GEN_UNKNOWN;
+	mutex_init(&cyapa->state_sync_lock);
+
+	/*
+	 * Set to hard code default, they will be updated with trackpad set
+	 * default values after probe and initialized.
+	 */
+	cyapa->suspend_power_mode = PWR_MODE_SLEEP;
+	cyapa->suspend_sleep_time =
+		cyapa_pwr_cmd_to_sleep_time(cyapa->suspend_power_mode);
+
+	if (cyapa_gen3_ops.initialize)
+		error = cyapa_gen3_ops.initialize(cyapa);
+	if (error)
+		return error;
+
+	error = cyapa_detect(cyapa);
+	if (error)
+		return error;
+
+	/* Power down the device until we need it. */
+	if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode)
+		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
+
+	return 0;
+}
+
+static int cyapa_reinitialize(struct cyapa *cyapa)
+{
+	struct device *dev = &cyapa->client->dev;
+	struct input_dev *input = cyapa->input;
+	int error;
+
+	/* Avoid command failures when TP was in OFF state. */
+	if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode)
+		cyapa->ops->set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE, 0);
+
+	error = cyapa_detect(cyapa);
+	if (error)
+		goto out;
+
+	if (!input && cyapa->operational) {
+		error = cyapa_create_input_dev(cyapa);
+		if (error) {
+			dev_err(dev, "create input_dev instance failed: %d\n",
+					error);
+			goto out;
+		}
+	}
+
+out:
+	if (!input || !input->users) {
+		/* Reset to power OFF state to save power when no user open. */
+		if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode)
+			cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
+	}
+
+	return error;
+}
+
+static irqreturn_t cyapa_irq(int irq, void *dev_id)
+{
+	struct cyapa *cyapa = dev_id;
+	struct device *dev = &cyapa->client->dev;
+	bool cont;
+
+	if (device_may_wakeup(dev))
+		pm_wakeup_event(dev, 0);
+
+	/* Interrupt event maybe cuased by host command to trackpad device. */
+	cont = true;
+	if (cyapa->ops->irq_cmd_handler)
+		cont = cyapa->ops->irq_cmd_handler(cyapa);
+
+	/* Interrupt event maybe from trackpad device input reporting. */
+	if (cont && cyapa->ops->irq_handler) {
+		/* Still in probling or in firware image udpating or reading. */
+		if (!cyapa->input && cyapa->ops->sort_empty_output_data) {
+			cyapa->ops->sort_empty_output_data(cyapa,
+				NULL, NULL, NULL);
+			goto out;
+		}
+
+		if (!cyapa->operational || cyapa->ops->irq_handler(cyapa)) {
+			if (!mutex_trylock(&cyapa->state_sync_lock) &&
+					cyapa->ops->sort_empty_output_data) {
+				cyapa->ops->sort_empty_output_data(cyapa,
+					NULL, NULL, NULL);
+				goto out;
+			}
+			cyapa_reinitialize(cyapa);
+			mutex_unlock(&cyapa->state_sync_lock);
+		}
+	}
+
+out:
+	return IRQ_HANDLED;
+}
+
 static int cyapa_probe(struct i2c_client *client,
 		       const struct i2c_device_id *dev_id)
 {
 	u8 adapter_func;
 	struct cyapa *cyapa;
 	struct device *dev = &client->dev;
+	union i2c_smbus_data dummy;
 	int error;
 
 	adapter_func = cyapa_check_adapter_functionality(client);
@@ -853,35 +584,32 @@ static int cyapa_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
+	/* Make sure there is something at this address */
+	if (i2c_smbus_xfer(client->adapter, client->addr, 0,
+			I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &dummy) < 0)
+		return -ENODEV;
+
 	cyapa = devm_kzalloc(dev, sizeof(struct cyapa), GFP_KERNEL);
 	if (!cyapa)
 		return -ENOMEM;
 
-	cyapa->gen = CYAPA_GEN3;
+	/* i2c isn't supported, use smbus */
+	if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
+		cyapa->smbus = true;
+
 	cyapa->client = client;
 	i2c_set_clientdata(client, cyapa);
 	sprintf(cyapa->phys, "i2c-%d-%04x/input0", client->adapter->nr,
 		client->addr);
 
-	/* i2c isn't supported, use smbus */
-	if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
-		cyapa->smbus = true;
-	cyapa->state = CYAPA_STATE_NO_DEVICE;
-	error = cyapa_check_is_operational(cyapa);
+	error = cyapa_initialize(cyapa);
 	if (error) {
-		dev_err(dev, "device not operational, %d\n", error);
+		dev_err(dev, "failed to detect and initialize tp device.\n");
 		return error;
 	}
 
-	error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
-	if (error) {
-		dev_err(dev, "set active power failed, %d\n", error);
-		return error;
-	}
-
-	cyapa->irq = client->irq;
 	error = devm_request_threaded_irq(dev,
-					cyapa->irq,
+					client->irq,
 					NULL,
 					cyapa_irq,
 					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
@@ -895,67 +623,83 @@ static int cyapa_probe(struct i2c_client *client,
 	/* Disable IRQ until the device is opened. */
 	disable_irq(client->irq);
 
-	error = cyapa_create_input_dev(cyapa);
-	if (error) {
-		dev_err(dev, "create input_dev instance failed, %d\n", error);
-		return error;
+	/*
+	 * Register the device in the input subsystem when it's operational.
+	 * Otherwise, keep in this driver, so it can be be recovered or updated
+	 * through the sysfs mode and update_fw interfaces by user or apps.
+	 */
+	if (cyapa->operational) {
+		error = cyapa_create_input_dev(cyapa);
+		if (error) {
+			dev_err(dev, "create input_dev instance failed: %d\n",
+					error);
+			return error;
+		}
 	}
 
 	return 0;
 }
 
-static int cyapa_remove(struct i2c_client *client)
+static int __maybe_unused cyapa_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct cyapa *cyapa = i2c_get_clientdata(client);
-
-	disable_irq(cyapa->irq);
-	cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM_SLEEP
-static int cyapa_suspend(struct device *dev)
-{
-	int error;
 	u8 power_mode;
-	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int error;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
 
-	disable_irq(cyapa->irq);
+	disable_irq(cyapa->client->irq);
 
 	/*
 	 * Set trackpad device to idle mode if wakeup is allowed,
 	 * otherwise turn off.
 	 */
-	power_mode = device_may_wakeup(dev) ? PWR_MODE_IDLE
+	power_mode = device_may_wakeup(dev) ? cyapa->suspend_power_mode
 					    : PWR_MODE_OFF;
-	error = cyapa_set_power_mode(cyapa, power_mode);
-	if (error)
-		dev_err(dev, "set power mode failed, %d\n", error);
+	if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode) {
+		error = cyapa->ops->set_power_mode(cyapa, power_mode,
+				cyapa->suspend_sleep_time);
+		if (error)
+			dev_err(dev, "suspend set power mode failed: %d\n",
+					error);
+	}
 
 	if (device_may_wakeup(dev))
-		cyapa->irq_wake = (enable_irq_wake(cyapa->irq) == 0);
+		cyapa->irq_wake = (enable_irq_wake(cyapa->client->irq) == 0);
+
+	mutex_unlock(&cyapa->state_sync_lock);
 	return 0;
 }
 
-static int cyapa_resume(struct device *dev)
+static int __maybe_unused cyapa_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+	struct cyapa *cyapa = i2c_get_clientdata(client);
 	int error;
-	struct cyapa *cyapa = dev_get_drvdata(dev);
 
-	if (device_may_wakeup(dev) && cyapa->irq_wake)
-		disable_irq_wake(cyapa->irq);
+	mutex_lock(&cyapa->state_sync_lock);
+
+	if (cyapa->irq_wake) {
+		disable_irq_wake(cyapa->client->irq);
+		cyapa->irq_wake = false;
+	}
 
-	error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
+	error = cyapa_reinitialize(cyapa);
 	if (error)
-		dev_warn(dev, "resume active power failed, %d\n", error);
+		dev_err(dev, "failed to reinitialize TP device: %d\n", error);
 
-	enable_irq(cyapa->irq);
+	enable_irq(cyapa->client->irq);
+
+	mutex_unlock(&cyapa->state_sync_lock);
 	return 0;
 }
-#endif /* CONFIG_PM_SLEEP */
 
-static SIMPLE_DEV_PM_OPS(cyapa_pm_ops, cyapa_suspend, cyapa_resume);
+static const struct dev_pm_ops cyapa_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(cyapa_suspend, cyapa_resume)
+};
 
 static const struct i2c_device_id cyapa_id_table[] = {
 	{ "cyapa", 0 },
@@ -971,7 +715,6 @@ static struct i2c_driver cyapa_driver = {
 	},
 
 	.probe = cyapa_probe,
-	.remove = cyapa_remove,
 	.id_table = cyapa_id_table,
 };
 
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
new file mode 100644
index 0000000..d79eeb1
--- /dev/null
+++ b/drivers/input/mouse/cyapa.h
@@ -0,0 +1,316 @@
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
+#define UNINIT_SLEEP_TIME 0xFFFF
+#define UNINIT_PWR_MODE   0xFF
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
+	int (*check_fw)(struct cyapa *, const struct firmware *);
+	int (*bl_enter)(struct cyapa *);
+	int (*bl_activate)(struct cyapa *);
+	int (*bl_initiate)(struct cyapa *, const struct firmware *);
+	int (*update_fw)(struct cyapa *, const struct firmware *);
+	int (*bl_verify_app_integrity)(struct cyapa *);
+	int (*bl_deactivate)(struct cyapa *);
+
+	ssize_t (*show_baseline)(struct device *,
+			struct device_attribute *, char *);
+	ssize_t (*calibrate_store)(struct device *,
+			struct device_attribute *, const char *, size_t);
+
+	int (*initialize)(struct cyapa *cyapa);
+
+	int (*state_parse)(struct cyapa *cyapa, u8 *reg_status, int len);
+	int (*operational_check)(struct cyapa *cyapa);
+
+	int (*irq_handler)(struct cyapa *);
+	bool (*irq_cmd_handler)(struct cyapa *);
+	int (*sort_empty_output_data)(struct cyapa *,
+			u8 *, int *, cb_sort);
+
+	int (*set_power_mode)(struct cyapa *, u8, u16);
+};
+
+struct cyapa_gen5_cmd_states {
+	struct mutex cmd_lock;
+	struct completion cmd_ready;
+	atomic_t cmd_issued;
+	u8 in_progress_cmd;
+	bool is_irq_mode;
+
+	cb_sort resp_sort_func;
+	u8 *resp_data;
+	int *resp_len;
+
+	u8 irq_cmd_buf[CYAPA_REG_MAP_SIZE];
+	u8 empty_buf[CYAPA_REG_MAP_SIZE];
+};
+
+union cyapa_cmd_states {
+	struct cyapa_gen5_cmd_states gen5;
+};
+
+enum cyapa_state {
+	CYAPA_STATE_NO_DEVICE,
+	CYAPA_STATE_BL_BUSY,
+	CYAPA_STATE_BL_IDLE,
+	CYAPA_STATE_BL_ACTIVE,
+	CYAPA_STATE_OP,
+	CYAPA_STATE_GEN5_BL,
+	CYAPA_STATE_GEN5_APP,
+};
+#define CYAPA_OPERATIONAL(cyapa)					\
+	(((cyapa)->gen == CYAPA_GEN5 &&					\
+		(cyapa)->state == CYAPA_STATE_GEN5_APP) ||		\
+	((cyapa->gen) == CYAPA_GEN3 && (cyapa)->state == CYAPA_STATE_OP))
+#define CYAPA_BOOTLOADER(cyapa)						\
+	((((cyapa)->gen == CYAPA_GEN5 &&				\
+		(cyapa)->state == CYAPA_STATE_GEN5_BL)) ||		\
+	(((cyapa)->gen == CYAPA_GEN3 &&					\
+		(cyapa)->state >= CYAPA_STATE_BL_BUSY &&		\
+		(cyapa)->state <= CYAPA_STATE_BL_ACTIVE)))
+
+struct cyapa_tsg_bin_image_head {
+	u8 head_size;  /* Unit: bytes, including itself. */
+	u8 ttda_driver_major_version;  /* Reserved as 0. */
+	u8 ttda_driver_minor_version;  /* Reserved as 0. */
+	u8 fw_major_version;
+	u8 fw_minor_version;
+	u8 fw_revision_control_number[8];
+} __packed;
+
+/* The main device structure */
+struct cyapa {
+	enum cyapa_state state;
+	u8 status[BL_STATUS_SIZE];
+	bool operational; /* true: ready for data reporting; false: not. */
+
+	struct i2c_client *client;
+	struct input_dev *input;
+	char phys[32];	/* Device physical location */
+	bool irq_wake;  /* Irq wake is enabled */
+	bool smbus;
+
+	/* power mode settings */
+	u8 suspend_power_mode;
+	u16 suspend_sleep_time;
+	u8 dev_pwr_mode;
+	u16 dev_sleep_time;
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
+	int max_z;
+
+	/*
+	 * Used to synchronize the access or update the device state.
+	 * And since update firmware and read firmware image process will take
+	 * quite long time, maybe more than 10 seconds, so use mutex_lock
+	 * to sync and wait other interface and detecting are done or ready.
+	 */
+	struct mutex state_sync_lock;
+
+	const struct cyapa_dev_ops *ops;
+
+	union cyapa_cmd_states cmd_states;
+};
+
+
+ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
+				u8 *values);
+ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
+				u8 *values);
+
+ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values);
+
+int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout);
+
+u8 cyapa_sleep_time_to_pwr_cmd(u16 sleep_time);
+u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode);
+
+
+extern const char unique_str[];
+extern const struct cyapa_dev_ops cyapa_gen3_ops;
+
+#endif
diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
new file mode 100644
index 0000000..6bf82a6
--- /dev/null
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -0,0 +1,792 @@
+/*
+ * Cypress APA trackpad with I2C interface
+ *
+ * Author: Dudley Du <dudl@cypress.com>
+ * Further cleanup and restructuring by:
+ *   Daniel Kurtz <djkurtz@chromium.org>
+ *   Benson Leung <bleung@chromium.org>
+ *
+ * Copyright (C) 2011-2014 Cypress Semiconductor, Inc.
+ * Copyright (C) 2011-2012 Google, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/input/mt.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "cyapa.h"
+
+
+#define GEN3_MAX_FINGERS 5
+#define GEN3_FINGER_NUM(x) (((x) >> 4) & 0x07)
+
+#define BLK_HEAD_BYTES 32
+
+/* Macro for register map group offset. */
+#define PRODUCT_ID_SIZE  16
+#define QUERY_DATA_SIZE  27
+#define REG_PROTOCOL_GEN_QUERY_OFFSET  20
+
+#define REG_OFFSET_DATA_BASE     0x0000
+#define REG_OFFSET_COMMAND_BASE  0x0028
+#define REG_OFFSET_QUERY_BASE    0x002a
+
+#define CYAPA_OFFSET_SOFT_RESET  REG_OFFSET_COMMAND_BASE
+#define OP_RECALIBRATION_MASK    0x80
+#define OP_REPORT_BASELINE_MASK  0x40
+#define REG_OFFSET_MAX_BASELINE  0x0026
+#define REG_OFFSET_MIN_BASELINE  0x0027
+
+#define REG_OFFSET_POWER_MODE (REG_OFFSET_COMMAND_BASE + 1)
+#define SET_POWER_MODE_DELAY   10000  /* Unit: us */
+#define SET_POWER_MODE_TRIES   5
+
+/*
+ * CYAPA trackpad device states.
+ * Used in register 0x00, bit1-0, DeviceStatus field.
+ * Other values indicate device is in an abnormal state and must be reset.
+ */
+#define CYAPA_DEV_NORMAL  0x03
+#define CYAPA_DEV_BUSY    0x01
+
+#define CYAPA_FW_BLOCK_SIZE	64
+#define CYAPA_FW_READ_SIZE	16
+#define CYAPA_FW_HDR_START	0x0780
+#define CYAPA_FW_HDR_BLOCK_COUNT  2
+#define CYAPA_FW_HDR_BLOCK_START  (CYAPA_FW_HDR_START / CYAPA_FW_BLOCK_SIZE)
+#define CYAPA_FW_HDR_SIZE	  (CYAPA_FW_HDR_BLOCK_COUNT * \
+					CYAPA_FW_BLOCK_SIZE)
+#define CYAPA_FW_DATA_START	0x0800
+#define CYAPA_FW_DATA_BLOCK_COUNT  480
+#define CYAPA_FW_DATA_BLOCK_START  (CYAPA_FW_DATA_START / CYAPA_FW_BLOCK_SIZE)
+#define CYAPA_FW_DATA_SIZE	(CYAPA_FW_DATA_BLOCK_COUNT * \
+				 CYAPA_FW_BLOCK_SIZE)
+#define CYAPA_FW_SIZE		(CYAPA_FW_HDR_SIZE + CYAPA_FW_DATA_SIZE)
+#define CYAPA_CMD_LEN		16
+
+#define GEN3_BL_IDLE_FW_MAJ_VER_OFFSET 0x0b
+#define GEN3_BL_IDLE_FW_MIN_VER_OFFSET (GEN3_BL_IDLE_FW_MAJ_VER_OFFSET + 1)
+
+
+struct cyapa_touch {
+	/*
+	 * high bits or x/y position value
+	 * bit 7 - 4: high 4 bits of x position value
+	 * bit 3 - 0: high 4 bits of y position value
+	 */
+	u8 xy_hi;
+	u8 x_lo;  /* low 8 bits of x position value. */
+	u8 y_lo;  /* low 8 bits of y position value. */
+	u8 pressure;
+	/* id range is 1 - 15.  It is incremented with every new touch. */
+	u8 id;
+} __packed;
+
+struct cyapa_reg_data {
+	/*
+	 * bit 0 - 1: device status
+	 * bit 3 - 2: power mode
+	 * bit 6 - 4: reserved
+	 * bit 7: interrupt valid bit
+	 */
+	u8 device_status;
+	/*
+	 * bit 7 - 4: number of fingers currently touching pad
+	 * bit 3: valid data check bit
+	 * bit 2: middle mechanism button state if exists
+	 * bit 1: right mechanism button state if exists
+	 * bit 0: left mechanism button state if exists
+	 */
+	u8 finger_btn;
+	/* CYAPA reports up to 5 touches per packet. */
+	struct cyapa_touch touches[5];
+} __packed;
+
+static const u8 bl_activate[] = { 0x00, 0xff, 0x38, 0x00, 0x01, 0x02, 0x03,
+		0x04, 0x05, 0x06, 0x07 };
+static const u8 bl_deactivate[] = { 0x00, 0xff, 0x3b, 0x00, 0x01, 0x02, 0x03,
+		0x04, 0x05, 0x06, 0x07 };
+static const u8 bl_exit[] = { 0x00, 0xff, 0xa5, 0x00, 0x01, 0x02, 0x03, 0x04,
+		0x05, 0x06, 0x07 };
+
+
+ /* for byte read/write command */
+#define CMD_RESET      0
+#define CMD_POWER_MODE 1
+#define CMD_DEV_STATUS 2
+#define CMD_REPORT_MAX_BASELINE 3
+#define CMD_REPORT_MIN_BASELINE 4
+#define SMBUS_BYTE_CMD(cmd) (((cmd) & 0x3f) << 1)
+#define CYAPA_SMBUS_RESET         SMBUS_BYTE_CMD(CMD_RESET)
+#define CYAPA_SMBUS_POWER_MODE    SMBUS_BYTE_CMD(CMD_POWER_MODE)
+#define CYAPA_SMBUS_DEV_STATUS    SMBUS_BYTE_CMD(CMD_DEV_STATUS)
+#define CYAPA_SMBUS_MAX_BASELINE  SMBUS_BYTE_CMD(CMD_REPORT_MAX_BASELINE)
+#define CYAPA_SMBUS_MIN_BASELINE  SMBUS_BYTE_CMD(CMD_REPORT_MIN_BASELINE)
+
+ /* for group registers read/write command */
+#define REG_GROUP_DATA 0
+#define REG_GROUP_CMD 2
+#define REG_GROUP_QUERY 3
+#define SMBUS_GROUP_CMD(grp) (0x80 | (((grp) & 0x07) << 3))
+#define CYAPA_SMBUS_GROUP_DATA	 SMBUS_GROUP_CMD(REG_GROUP_DATA)
+#define CYAPA_SMBUS_GROUP_CMD	 SMBUS_GROUP_CMD(REG_GROUP_CMD)
+#define CYAPA_SMBUS_GROUP_QUERY	 SMBUS_GROUP_CMD(REG_GROUP_QUERY)
+
+ /* for register block read/write command */
+#define CMD_BL_STATUS 0
+#define CMD_BL_HEAD 1
+#define CMD_BL_CMD 2
+#define CMD_BL_DATA 3
+#define CMD_BL_ALL 4
+#define CMD_BLK_PRODUCT_ID 5
+#define CMD_BLK_HEAD 6
+#define SMBUS_BLOCK_CMD(cmd) (0xc0 | (((cmd) & 0x1f) << 1))
+
+/* register block read/write command in bootloader mode */
+#define CYAPA_SMBUS_BL_STATUS  SMBUS_BLOCK_CMD(CMD_BL_STATUS)
+#define CYAPA_SMBUS_BL_HEAD    SMBUS_BLOCK_CMD(CMD_BL_HEAD)
+#define CYAPA_SMBUS_BL_CMD     SMBUS_BLOCK_CMD(CMD_BL_CMD)
+#define CYAPA_SMBUS_BL_DATA    SMBUS_BLOCK_CMD(CMD_BL_DATA)
+#define CYAPA_SMBUS_BL_ALL     SMBUS_BLOCK_CMD(CMD_BL_ALL)
+
+/* register block read/write command in operational mode */
+#define CYAPA_SMBUS_BLK_PRODUCT_ID SMBUS_BLOCK_CMD(CMD_BLK_PRODUCT_ID)
+#define CYAPA_SMBUS_BLK_HEAD SMBUS_BLOCK_CMD(CMD_BLK_HEAD)
+
+ /* for byte read/write command */
+#define CMD_RESET 0
+#define CMD_POWER_MODE 1
+#define CMD_DEV_STATUS 2
+#define CMD_REPORT_MAX_BASELINE 3
+#define CMD_REPORT_MIN_BASELINE 4
+#define SMBUS_BYTE_CMD(cmd) (((cmd) & 0x3f) << 1)
+#define CYAPA_SMBUS_RESET         SMBUS_BYTE_CMD(CMD_RESET)
+#define CYAPA_SMBUS_POWER_MODE    SMBUS_BYTE_CMD(CMD_POWER_MODE)
+#define CYAPA_SMBUS_DEV_STATUS    SMBUS_BYTE_CMD(CMD_DEV_STATUS)
+#define CYAPA_SMBUS_MAX_BASELINE  SMBUS_BYTE_CMD(CMD_REPORT_MAX_BASELINE)
+#define CYAPA_SMBUS_MIN_BASELINE  SMBUS_BYTE_CMD(CMD_REPORT_MIN_BASELINE)
+
+ /* for group registers read/write command */
+#define REG_GROUP_DATA  0
+#define REG_GROUP_CMD   2
+#define REG_GROUP_QUERY 3
+#define SMBUS_GROUP_CMD(grp) (0x80 | (((grp) & 0x07) << 3))
+#define CYAPA_SMBUS_GROUP_DATA  SMBUS_GROUP_CMD(REG_GROUP_DATA)
+#define CYAPA_SMBUS_GROUP_CMD   SMBUS_GROUP_CMD(REG_GROUP_CMD)
+#define CYAPA_SMBUS_GROUP_QUERY SMBUS_GROUP_CMD(REG_GROUP_QUERY)
+
+ /* for register block read/write command */
+#define CMD_BL_STATUS		0
+#define CMD_BL_HEAD		1
+#define CMD_BL_CMD		2
+#define CMD_BL_DATA		3
+#define CMD_BL_ALL		4
+#define CMD_BLK_PRODUCT_ID	5
+#define CMD_BLK_HEAD		6
+#define SMBUS_BLOCK_CMD(cmd) (0xc0 | (((cmd) & 0x1f) << 1))
+
+/* register block read/write command in bootloader mode */
+#define CYAPA_SMBUS_BL_STATUS SMBUS_BLOCK_CMD(CMD_BL_STATUS)
+#define CYAPA_SMBUS_BL_HEAD   SMBUS_BLOCK_CMD(CMD_BL_HEAD)
+#define CYAPA_SMBUS_BL_CMD    SMBUS_BLOCK_CMD(CMD_BL_CMD)
+#define CYAPA_SMBUS_BL_DATA   SMBUS_BLOCK_CMD(CMD_BL_DATA)
+#define CYAPA_SMBUS_BL_ALL    SMBUS_BLOCK_CMD(CMD_BL_ALL)
+
+/* register block read/write command in operational mode */
+#define CYAPA_SMBUS_BLK_PRODUCT_ID SMBUS_BLOCK_CMD(CMD_BLK_PRODUCT_ID)
+#define CYAPA_SMBUS_BLK_HEAD       SMBUS_BLOCK_CMD(CMD_BLK_HEAD)
+
+struct cyapa_cmd_len {
+	u8 cmd;
+	u8 len;
+};
+
+/* maps generic CYAPA_CMD_* code to the I2C equivalent */
+static const struct cyapa_cmd_len cyapa_i2c_cmds[] = {
+	{ CYAPA_OFFSET_SOFT_RESET, 1 },		/* CYAPA_CMD_SOFT_RESET */
+	{ REG_OFFSET_COMMAND_BASE + 1, 1 },	/* CYAPA_CMD_POWER_MODE */
+	{ REG_OFFSET_DATA_BASE, 1 },		/* CYAPA_CMD_DEV_STATUS */
+	{ REG_OFFSET_DATA_BASE, sizeof(struct cyapa_reg_data) },
+						/* CYAPA_CMD_GROUP_DATA */
+	{ REG_OFFSET_COMMAND_BASE, 0 },		/* CYAPA_CMD_GROUP_CMD */
+	{ REG_OFFSET_QUERY_BASE, QUERY_DATA_SIZE }, /* CYAPA_CMD_GROUP_QUERY */
+	{ BL_HEAD_OFFSET, 3 },			/* CYAPA_CMD_BL_STATUS */
+	{ BL_HEAD_OFFSET, 16 },			/* CYAPA_CMD_BL_HEAD */
+	{ BL_HEAD_OFFSET, 16 },			/* CYAPA_CMD_BL_CMD */
+	{ BL_DATA_OFFSET, 16 },			/* CYAPA_CMD_BL_DATA */
+	{ BL_HEAD_OFFSET, 32 },			/* CYAPA_CMD_BL_ALL */
+	{ REG_OFFSET_QUERY_BASE, PRODUCT_ID_SIZE },
+						/* CYAPA_CMD_BLK_PRODUCT_ID */
+	{ REG_OFFSET_DATA_BASE, 32 },		/* CYAPA_CMD_BLK_HEAD */
+	{ REG_OFFSET_MAX_BASELINE, 1 },		/* CYAPA_CMD_MAX_BASELINE */
+	{ REG_OFFSET_MIN_BASELINE, 1 },		/* CYAPA_CMD_MIN_BASELINE */
+};
+
+static const struct cyapa_cmd_len cyapa_smbus_cmds[] = {
+	{ CYAPA_SMBUS_RESET, 1 },		/* CYAPA_CMD_SOFT_RESET */
+	{ CYAPA_SMBUS_POWER_MODE, 1 },		/* CYAPA_CMD_POWER_MODE */
+	{ CYAPA_SMBUS_DEV_STATUS, 1 },		/* CYAPA_CMD_DEV_STATUS */
+	{ CYAPA_SMBUS_GROUP_DATA, sizeof(struct cyapa_reg_data) },
+						/* CYAPA_CMD_GROUP_DATA */
+	{ CYAPA_SMBUS_GROUP_CMD, 2 },		/* CYAPA_CMD_GROUP_CMD */
+	{ CYAPA_SMBUS_GROUP_QUERY, QUERY_DATA_SIZE },
+						/* CYAPA_CMD_GROUP_QUERY */
+	{ CYAPA_SMBUS_BL_STATUS, 3 },		/* CYAPA_CMD_BL_STATUS */
+	{ CYAPA_SMBUS_BL_HEAD, 16 },		/* CYAPA_CMD_BL_HEAD */
+	{ CYAPA_SMBUS_BL_CMD, 16 },		/* CYAPA_CMD_BL_CMD */
+	{ CYAPA_SMBUS_BL_DATA, 16 },		/* CYAPA_CMD_BL_DATA */
+	{ CYAPA_SMBUS_BL_ALL, 32 },		/* CYAPA_CMD_BL_ALL */
+	{ CYAPA_SMBUS_BLK_PRODUCT_ID, PRODUCT_ID_SIZE },
+						/* CYAPA_CMD_BLK_PRODUCT_ID */
+	{ CYAPA_SMBUS_BLK_HEAD, 16 },		/* CYAPA_CMD_BLK_HEAD */
+	{ CYAPA_SMBUS_MAX_BASELINE, 1 },	/* CYAPA_CMD_MAX_BASELINE */
+	{ CYAPA_SMBUS_MIN_BASELINE, 1 },	/* CYAPA_CMD_MIN_BASELINE */
+};
+
+
+/*
+ * cyapa_smbus_read_block - perform smbus block read command
+ * @cyapa  - private data structure of the driver
+ * @cmd    - the properly encoded smbus command
+ * @len    - expected length of smbus command result
+ * @values - buffer to store smbus command result
+ *
+ * Returns negative errno, else the number of bytes written.
+ *
+ * Note:
+ * In trackpad device, the memory block allocated for I2C register map
+ * is 256 bytes, so the max read block for I2C bus is 256 bytes.
+ */
+ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
+				      u8 *values)
+{
+	ssize_t ret;
+	u8 index;
+	u8 smbus_cmd;
+	u8 *buf;
+	struct i2c_client *client = cyapa->client;
+
+	if (!(SMBUS_BYTE_BLOCK_CMD_MASK & cmd))
+		return -EINVAL;
+
+	if (SMBUS_GROUP_BLOCK_CMD_MASK & cmd) {
+		/* read specific block registers command. */
+		smbus_cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
+		ret = i2c_smbus_read_block_data(client, smbus_cmd, values);
+		goto out;
+	}
+
+	ret = 0;
+	for (index = 0; index * I2C_SMBUS_BLOCK_MAX < len; index++) {
+		smbus_cmd = SMBUS_ENCODE_IDX(cmd, index);
+		smbus_cmd = SMBUS_ENCODE_RW(smbus_cmd, SMBUS_READ);
+		buf = values + I2C_SMBUS_BLOCK_MAX * index;
+		ret = i2c_smbus_read_block_data(client, smbus_cmd, buf);
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	return ret > 0 ? len : ret;
+}
+
+s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx)
+{
+	u8 cmd;
+
+	if (cyapa->smbus) {
+		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
+		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
+	} else {
+		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+	}
+	return i2c_smbus_read_byte_data(cyapa->client, cmd);
+}
+
+s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value)
+{
+	u8 cmd;
+
+	if (cyapa->smbus) {
+		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
+		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_WRITE);
+	} else {
+		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+	}
+	return i2c_smbus_write_byte_data(cyapa->client, cmd, value);
+}
+
+ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
+					u8 *values)
+{
+	return i2c_smbus_read_i2c_block_data(cyapa->client, reg, len, values);
+}
+
+ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
+					 size_t len, const u8 *values)
+{
+	return i2c_smbus_write_i2c_block_data(cyapa->client, reg, len, values);
+}
+
+ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values)
+{
+	u8 cmd;
+	size_t len;
+
+	if (cyapa->smbus) {
+		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
+		len = cyapa_smbus_cmds[cmd_idx].len;
+		return cyapa_smbus_read_block(cyapa, cmd, len, values);
+	}
+	cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+	len = cyapa_i2c_cmds[cmd_idx].len;
+	return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
+}
+
+/*
+ * Determine the Gen3 trackpad device's current operating state.
+ *
+ */
+static int cyapa_gen3_state_parse(struct cyapa *cyapa, u8 *reg_data, int len)
+{
+	cyapa->state = CYAPA_STATE_NO_DEVICE;
+
+	/* Parse based on Gen3 characteristic registers and bits */
+	if (reg_data[REG_BL_FILE] == BL_FILE &&
+		reg_data[REG_BL_ERROR] == BL_ERROR_NO_ERR_IDLE &&
+		(reg_data[REG_BL_STATUS] ==
+			(BL_STATUS_RUNNING | BL_STATUS_CSUM_VALID) ||
+			reg_data[REG_BL_STATUS] == BL_STATUS_RUNNING)) {
+		/*
+		 * Normal state after power on or reset,
+		 * REG_BL_STATUS == 0x11, firmware image checksum is valid.
+		 * REG_BL_STATUS == 0x10, firmware image checksum is invalid.
+		 */
+		cyapa->gen = CYAPA_GEN3;
+		cyapa->state = CYAPA_STATE_BL_IDLE;
+	} else if (reg_data[REG_BL_FILE] == BL_FILE &&
+		(reg_data[REG_BL_STATUS] & BL_STATUS_RUNNING) ==
+			BL_STATUS_RUNNING) {
+		cyapa->gen = CYAPA_GEN3;
+		if (reg_data[REG_BL_STATUS] & BL_STATUS_BUSY) {
+			cyapa->state = CYAPA_STATE_BL_BUSY;
+		} else {
+			if ((reg_data[REG_BL_ERROR] & BL_ERROR_BOOTLOADING) ==
+					BL_ERROR_BOOTLOADING)
+				cyapa->state = CYAPA_STATE_BL_ACTIVE;
+			else
+				cyapa->state = CYAPA_STATE_BL_IDLE;
+		}
+	} else if ((reg_data[REG_OP_STATUS] & OP_STATUS_SRC) &&
+			(reg_data[REG_OP_DATA1] & OP_DATA_VALID)) {
+		/*
+		 * Normal state when running in operaitonal mode,
+		 * may also not in full power state or
+		 * busying in command process.
+		 */
+		if (GEN3_FINGER_NUM(reg_data[REG_OP_DATA1]) <=
+				GEN3_MAX_FINGERS) {
+			/* Finger number data is valid. */
+			cyapa->gen = CYAPA_GEN3;
+			cyapa->state = CYAPA_STATE_OP;
+		}
+	} else if (reg_data[REG_OP_STATUS] == 0x0C &&
+			reg_data[REG_OP_DATA1] == 0x08) {
+		/* Op state when first two registers overwritten with 0x00 */
+		cyapa->gen = CYAPA_GEN3;
+		cyapa->state = CYAPA_STATE_OP;
+	} else if (reg_data[REG_BL_STATUS] &
+			(BL_STATUS_RUNNING | BL_STATUS_BUSY)) {
+		cyapa->gen = CYAPA_GEN3;
+		cyapa->state = CYAPA_STATE_BL_BUSY;
+	}
+
+	if (cyapa->gen == CYAPA_GEN3 && (cyapa->state == CYAPA_STATE_OP ||
+		cyapa->state == CYAPA_STATE_BL_IDLE ||
+		cyapa->state == CYAPA_STATE_BL_ACTIVE ||
+		cyapa->state == CYAPA_STATE_BL_BUSY))
+		return 0;
+
+	return -EAGAIN;
+}
+
+static int cyapa_gen3_bl_deactivate(struct cyapa *cyapa)
+{
+	int error;
+
+	error = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_deactivate),
+					bl_deactivate);
+	if (error)
+		return error;
+
+	/* Wait for bootloader to switch to idle state; should take < 100ms */
+	msleep(100);
+	error = cyapa_poll_state(cyapa, 500);
+	if (error)
+		return error;
+	if (cyapa->state != CYAPA_STATE_BL_IDLE)
+		return -EAGAIN;
+	return 0;
+}
+
+/*
+ * Exit bootloader
+ *
+ * Send bl_exit command, then wait 50 - 100 ms to let device transition to
+ * operational mode.  If this is the first time the device's firmware is
+ * running, it can take up to 2 seconds to calibrate its sensors.  So, poll
+ * the device's new state for up to 2 seconds.
+ *
+ * Returns:
+ *   -EIO    failure while reading from device
+ *   -EAGAIN device is stuck in bootloader, b/c it has invalid firmware
+ *   0       device is supported and in operational mode
+ */
+static int cyapa_gen3_bl_exit(struct cyapa *cyapa)
+{
+	int error;
+
+	error = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_exit), bl_exit);
+	if (error)
+		return error;
+
+	/*
+	 * Wait for bootloader to exit, and operation mode to start.
+	 * Normally, this takes at least 50 ms.
+	 */
+	usleep_range(50000, 100000);
+	/*
+	 * In addition, when a device boots for the first time after being
+	 * updated to new firmware, it must first calibrate its sensors, which
+	 * can take up to an additional 2 seconds. If the device power is
+	 * running low, this may take even longer.
+	 */
+	error = cyapa_poll_state(cyapa, 4000);
+	if (error < 0)
+		return error;
+	if (cyapa->state != CYAPA_STATE_OP)
+		return -EAGAIN;
+
+	return 0;
+}
+
+/*
+ * cyapa_get_wait_time_for_pwr_cmd
+ *
+ * Compute the amount of time we need to wait after updating the touchpad
+ * power mode. The touchpad needs to consume the incoming power mode set
+ * command at the current clock rate.
+ */
+
+static u16 cyapa_get_wait_time_for_pwr_cmd(u8 pwr_mode)
+{
+	switch (pwr_mode) {
+	case PWR_MODE_FULL_ACTIVE: return 20;
+	case PWR_MODE_BTN_ONLY: return 20;
+	case PWR_MODE_OFF: return 20;
+	default: return cyapa_pwr_cmd_to_sleep_time(pwr_mode) + 50;
+	}
+}
+
+/*
+ * Set device power mode
+ *
+ * Write to the field to configure power state. Power states include :
+ *   Full : Max scans and report rate.
+ *   Idle : Report rate set by user specified time.
+ *   ButtonOnly : No scans for fingers. When the button is triggered,
+ *     a slave interrupt is asserted to notify host to wake up.
+ *   Off : Only awake for i2c commands from host. No function for button
+ *     or touch sensors.
+ *
+ * The power_mode command should conform to the following :
+ *   Full : 0x3f
+ *   Idle : Configurable from 20 to 1000ms. See note below for
+ *     cyapa_sleep_time_to_pwr_cmd and cyapa_pwr_cmd_to_sleep_time
+ *   ButtonOnly : 0x01
+ *   Off : 0x00
+ *
+ * Device power mode can only be set when device is in operational mode.
+ */
+static int cyapa_gen3_set_power_mode(struct cyapa *cyapa, u8 power_mode,
+		u16 always_unused)
+{
+	int ret;
+	u8 power;
+	int tries = SET_POWER_MODE_TRIES;
+	u16 sleep_time;
+
+	always_unused = 0;
+	if (cyapa->state != CYAPA_STATE_OP)
+		return 0;
+
+	while (true) {
+		ret = cyapa_read_byte(cyapa, CYAPA_CMD_POWER_MODE);
+		if (ret >= 0 || --tries < 1)
+			break;
+		usleep_range(SET_POWER_MODE_DELAY, 2 * SET_POWER_MODE_DELAY);
+	}
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Return early if the power mode to set is the same as the current
+	 * one.
+	 */
+	if ((ret & PWR_MODE_MASK) == power_mode)
+		return 0;
+
+	sleep_time = cyapa_get_wait_time_for_pwr_cmd(ret & PWR_MODE_MASK);
+	power = ret;
+	power &= ~PWR_MODE_MASK;
+	power |= power_mode & PWR_MODE_MASK;
+	while (true) {
+		ret = cyapa_write_byte(cyapa, CYAPA_CMD_POWER_MODE, power);
+		if (!ret || --tries < 1)
+			break;
+		usleep_range(SET_POWER_MODE_DELAY, 2 * SET_POWER_MODE_DELAY);
+	}
+
+	/*
+	 * Wait for the newly set power command to go in at the previous
+	 * clock speed (scanrate) used by the touchpad firmware. Not
+	 * doing so before issuing the next command may result in errors
+	 * depending on the command's content.
+	 */
+	msleep(sleep_time);
+	return ret;
+}
+
+static int cyapa_gen3_get_query_data(struct cyapa *cyapa)
+{
+	u8 query_data[QUERY_DATA_SIZE];
+	int ret;
+
+	if (cyapa->state != CYAPA_STATE_OP)
+		return -EBUSY;
+
+	ret = cyapa_read_block(cyapa, CYAPA_CMD_GROUP_QUERY, query_data);
+	if (ret != QUERY_DATA_SIZE)
+		return (ret < 0) ? ret : -EIO;
+
+	memcpy(&cyapa->product_id[0], &query_data[0], 5);
+	cyapa->product_id[5] = '-';
+	memcpy(&cyapa->product_id[6], &query_data[5], 6);
+	cyapa->product_id[12] = '-';
+	memcpy(&cyapa->product_id[13], &query_data[11], 2);
+	cyapa->product_id[15] = '\0';
+
+	cyapa->fw_maj_ver = query_data[15];
+	cyapa->fw_min_ver = query_data[16];
+
+	cyapa->btn_capability = query_data[19] & CAPABILITY_BTN_MASK;
+
+	cyapa->gen = query_data[20] & 0x0f;
+
+	cyapa->max_abs_x = ((query_data[21] & 0xf0) << 4) | query_data[22];
+	cyapa->max_abs_y = ((query_data[21] & 0x0f) << 8) | query_data[23];
+
+	cyapa->physical_size_x =
+		((query_data[24] & 0xf0) << 4) | query_data[25];
+	cyapa->physical_size_y =
+		((query_data[24] & 0x0f) << 8) | query_data[26];
+
+	cyapa->max_z = 255;
+
+	return 0;
+}
+
+static int cyapa_gen3_bl_query_data(struct cyapa *cyapa)
+{
+	u8 bl_data[CYAPA_CMD_LEN];
+	int ret;
+
+	ret = cyapa_i2c_reg_read_block(cyapa, 0, CYAPA_CMD_LEN, bl_data);
+	if (ret != CYAPA_CMD_LEN)
+		return (ret < 0) ? ret : -EIO;
+
+	/*
+	 * This value will be updated again when entered application mode.
+	 * If TP failed to enter application mode, this fw version values
+	 * can be used as a reference.
+	 * This firmware version valid when fw image checksum is valid.
+	 */
+	if (bl_data[REG_BL_STATUS] ==
+			(BL_STATUS_RUNNING | BL_STATUS_CSUM_VALID)) {
+		cyapa->fw_maj_ver = bl_data[GEN3_BL_IDLE_FW_MAJ_VER_OFFSET];
+		cyapa->fw_min_ver = bl_data[GEN3_BL_IDLE_FW_MIN_VER_OFFSET];
+	}
+
+	return 0;
+}
+
+/*
+ * Check if device is operational.
+ *
+ * An operational device is responding, has exited bootloader, and has
+ * firmware supported by this driver.
+ *
+ * Returns:
+ *   -EBUSY  no device or in bootloader
+ *   -EIO    failure while reading from device
+ *   -EAGAIN device is still in bootloader
+ *           if ->state = CYAPA_STATE_BL_IDLE, device has invalid firmware
+ *   -EINVAL device is in operational mode, but not supported by this driver
+ *   0       device is supported
+ */
+static int cyapa_gen3_do_operational_check(struct cyapa *cyapa)
+{
+	struct device *dev = &cyapa->client->dev;
+	int error;
+
+	switch (cyapa->state) {
+	case CYAPA_STATE_BL_ACTIVE:
+		error = cyapa_gen3_bl_deactivate(cyapa);
+		if (error) {
+			dev_err(dev, "failed to bl_deactivate: %d\n", error);
+			return error;
+		}
+
+	/* Fallthrough state */
+	case CYAPA_STATE_BL_IDLE:
+		/* Try to get firmware version in bootloader mode. */
+		cyapa_gen3_bl_query_data(cyapa);
+
+		error = cyapa_gen3_bl_exit(cyapa);
+		if (error) {
+			dev_err(dev, "failed to bl_exit: %d\n", error);
+			return error;
+		}
+
+	/* Fallthrough state */
+	case CYAPA_STATE_OP:
+		/*
+		 * Reading query data before going back to the full mode
+		 * may cause problems, so we set the power mode first here.
+		 */
+		error = cyapa_gen3_set_power_mode(cyapa,
+				PWR_MODE_FULL_ACTIVE, 0);
+		if (error)
+			dev_err(dev, "%s: set full power mode failed: %d\n",
+				__func__, error);
+		error = cyapa_gen3_get_query_data(cyapa);
+		if (error < 0)
+			return error;
+
+		/* Only support firmware protocol gen3 */
+		if (cyapa->gen != CYAPA_GEN3) {
+			dev_err(dev, "unsupported protocol version (%d)",
+				cyapa->gen);
+			return -EINVAL;
+		}
+
+		/* Only support product ID starting with CYTRA */
+		if (memcmp(cyapa->product_id, unique_str,
+				strlen(unique_str)) != 0) {
+			dev_err(dev, "unsupported product ID (%s)\n",
+				cyapa->product_id);
+			return -EINVAL;
+		}
+
+		return 0;
+
+	default:
+		return -EIO;
+	}
+	return 0;
+}
+
+/*
+ * Return false, do not continue process
+ * Return true, continue process.
+ */
+static bool cyapa_gen3_irq_cmd_handler(struct cyapa *cyapa)
+{
+	/* Not gen3 irq command response, skip for continue. */
+	if (cyapa->gen != CYAPA_GEN3)
+		return true;
+
+	if (cyapa->operational)
+		return true;
+
+	/*
+	 * Driver in detecting or other interface function processing,
+	 * so, stop cyapa_gen3_irq_handler to continue process to
+	 * avoid unwanted to error detecting and processing.
+	 *
+	 * And also, avoid the periodicly accerted interrupts to be processed
+	 * as touch inputs when gen3 failed to launch into application mode,
+	 * which will cause gen3 stays in bootloader mode.
+	 */
+	return false;
+}
+
+static int cyapa_gen3_irq_handler(struct cyapa *cyapa)
+{
+	struct input_dev *input = cyapa->input;
+	struct device *dev = &cyapa->client->dev;
+	struct cyapa_reg_data data;
+	int num_fingers;
+	int ret;
+	int i;
+
+	ret = cyapa_read_block(cyapa, CYAPA_CMD_GROUP_DATA, (u8 *)&data);
+	if (ret != sizeof(data)) {
+		dev_err(dev, "failed to read report data, (%d)\n", ret);
+		return -EINVAL;
+	}
+
+	if ((data.device_status & OP_STATUS_SRC) != OP_STATUS_SRC ||
+	    (data.device_status & OP_STATUS_DEV) != CYAPA_DEV_NORMAL ||
+	    (data.finger_btn & OP_DATA_VALID) != OP_DATA_VALID) {
+		dev_err(dev, "invalid device state bytes, %02x %02x\n",
+			data.device_status, data.finger_btn);
+		return -EINVAL;
+	}
+
+	num_fingers = (data.finger_btn >> 4) & 0x0f;
+	for (i = 0; i < num_fingers; i++) {
+		const struct cyapa_touch *touch = &data.touches[i];
+		/* Note: touch->id range is 1 to 15; slots are 0 to 14. */
+		int slot = touch->id - 1;
+
+		input_mt_slot(input, slot);
+		input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
+		input_report_abs(input, ABS_MT_POSITION_X,
+				 ((touch->xy_hi & 0xf0) << 4) | touch->x_lo);
+		input_report_abs(input, ABS_MT_POSITION_Y,
+				 ((touch->xy_hi & 0x0f) << 8) | touch->y_lo);
+		input_report_abs(input, ABS_MT_PRESSURE, touch->pressure);
+	}
+
+	input_mt_sync_frame(input);
+
+	if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK)
+		input_report_key(input, BTN_LEFT,
+				 !!(data.finger_btn & OP_DATA_LEFT_BTN));
+	if (cyapa->btn_capability & CAPABILITY_MIDDLE_BTN_MASK)
+		input_report_key(input, BTN_MIDDLE,
+				 !!(data.finger_btn & OP_DATA_MIDDLE_BTN));
+	if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK)
+		input_report_key(input, BTN_RIGHT,
+				 !!(data.finger_btn & OP_DATA_RIGHT_BTN));
+	input_sync(input);
+
+	return 0;
+}
+
+const struct cyapa_dev_ops cyapa_gen3_ops = {
+	.state_parse = cyapa_gen3_state_parse,
+	.operational_check = cyapa_gen3_do_operational_check,
+
+	.irq_handler = cyapa_gen3_irq_handler,
+	.irq_cmd_handler = cyapa_gen3_irq_cmd_handler,
+
+	.set_power_mode = cyapa_gen3_set_power_mode,
+};
-- 
1.9.1

