Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaIJElz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:41:55 -0400
Received: from bay004-omc1s20.hotmail.com ([65.54.190.31]:52396 "EHLO
	BAY004-OMC1S20.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbaIJEjz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:39:55 -0400
X-TMN: [V2tKi2piUq74U1xsUnEBxcLimjbtU0eZ]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS11B4C46C71A578D0605BDDBDCF0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 06/13] input: cyapa: add gen3 trackpad device basic functions support
Date: Wed, 10 Sep 2014 12:34:45 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/MsIxWBQ/g7SI8QK2zQWF+8G86mw==
Content-Language: zh-cn
X-OriginalArrivalTime: 10 Sep 2014 04:34:47.0051 (UTC) FILETIME=[8D1815B0:01CFCCB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the cyapa core, add the gen3 trackpad device's basic functions
supported, so gen3 trackpad device can work with kernel input system.
The basic function is absolutely same as previous cyapa driver only
support gen3 trackpad device.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/Makefile     |   2 +-
 drivers/input/mouse/cyapa.c      |  96 ++++-
 drivers/input/mouse/cyapa.h      |   1 +
 drivers/input/mouse/cyapa_gen3.c | 783 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 880 insertions(+), 2 deletions(-)
 create mode 100644 drivers/input/mouse/cyapa_gen3.c

diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 8608eb7..63b42e0 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -35,4 +35,4 @@ psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
 psmouse-$(CONFIG_MOUSE_PS2_CYPRESS)	+= cypress_ps2.o
 
-cyapatp-y := cyapa.o
+cyapatp-y := cyapa.o cyapa_gen3.o
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index b3b19b3..7ac2fdf 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -116,6 +116,15 @@ ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
 
 void cyapa_default_irq_handler(struct cyapa *cyapa)
 {
+	bool cont;
+
+	/* Interrupt triggerred by command response in detecting. */
+	cont = true;
+	if (cyapa_gen3_ops.irq_cmd_handler)
+		cont = cyapa_gen3_ops.irq_cmd_handler(cyapa);
+	if (!cont)
+		return;
+
 	/*
 	 * Do redetecting when device states is still unknown and
 	 * interrupt envent is received from device.
@@ -255,6 +264,9 @@ static int cyapa_check_is_operational(struct cyapa *cyapa)
 		return ret;
 
 	switch (cyapa->gen) {
+	case CYAPA_GEN3:
+		cyapa->ops = &cyapa_gen3_ops;
+		break;
 	default:
 		cyapa->ops = &cyapa_default_ops;
 		cyapa->gen = CYAPA_GEN_UNKNOWN;
@@ -317,9 +329,85 @@ out:
  */
 static int cyapa_get_state(struct cyapa *cyapa)
 {
+	int ret;
+	u8 status[BL_STATUS_SIZE];
+	u8 cmd[32];
+	/* The i2c address of gen4 and gen5 trackpad device must be even. */
+	bool even_addr = ((cyapa->client->addr & 0x0001) == 0);
+	bool smbus = false;
+	int retries = 2;
+
 	cyapa->state = CYAPA_STATE_NO_DEVICE;
 
-	return -ENODEV;
+	/*
+	 * Get trackpad status by reading 3 registers starting from 0.
+	 * If the device is in the bootloader, this will be BL_HEAD.
+	 * If the device is in operation mode, this will be the DATA regs.
+	 *
+	 */
+	ret = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET, BL_STATUS_SIZE,
+				       status);
+
+	/*
+	 * On smbus systems in OP mode, the i2c_reg_read will fail with
+	 * -ETIMEDOUT.  In this case, try again using the smbus equivalent
+	 * command.  This should return a BL_HEAD indicating CYAPA_STATE_OP.
+	 */
+	if (cyapa->smbus && (ret == -ETIMEDOUT || ret == -ENXIO)) {
+		if (!even_addr)
+			ret = cyapa_read_block(cyapa,
+					CYAPA_CMD_BL_STATUS, status);
+		smbus = true;
+	}
+	if (ret != BL_STATUS_SIZE)
+		goto error;
+
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
+			ret = cyapa_gen3_ops.state_parse(cyapa,
+					status, BL_STATUS_SIZE);
+			if (ret == 0)
+				goto out_detected;
+		}
+
+		/*
+		 * Cannot detect communication protocol based on current
+		 * charateristic registers and bits.
+		 * So write error command to do further detection.
+		 * this method only valid on I2C bus.
+		 * for smbus interface, it won't have overwrite issue.
+		 */
+		if (!smbus) {
+			cmd[0] = 0x00;
+			cmd[1] = 0x00;
+			ret = cyapa_i2c_write(cyapa, 0, 2, cmd);
+			if (ret)
+				goto error;
+
+			msleep(50);
+
+			ret = cyapa_i2c_read(cyapa, BL_HEAD_OFFSET,
+					BL_STATUS_SIZE, status);
+			if (ret < 0)
+				goto error;
+		}
+	} while (--retries > 0 && !smbus);
+
+	goto error;
+
+out_detected:
+	return 0;
+
+error:
+	return (ret < 0) ? ret : -EAGAIN;
 }
 
 /*
@@ -1008,11 +1096,17 @@ static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
 
 static int cyapa_tp_modules_init(struct cyapa *cyapa)
 {
+	if (cyapa_gen3_ops.initialize)
+		return cyapa_gen3_ops.initialize(cyapa);
+
 	return 0;
 }
 
 static int cyapa_tp_modules_uninit(struct cyapa *cyapa)
 {
+	if (cyapa_gen3_ops.uninitialize)
+		return cyapa_gen3_ops.uninitialize(cyapa);
+
 	return 0;
 }
 
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index b61a71b..0b8d023 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -298,5 +298,6 @@ u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode);
 
 
 extern const char unique_str[];
+extern const struct cyapa_dev_ops cyapa_gen3_ops;
 
 #endif
diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
new file mode 100644
index 0000000..0f1537c
--- /dev/null
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -0,0 +1,783 @@
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
+#define SET_POWER_MODE_DELAY   10000  /* unit: us */
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
+static bool data_reporting_started;
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
+	/*
+	 * Must be in detecting and should not do data reporting.
+	 * It will be reenabled when all detecting done and lauched into
+	 * applicaiton mode successfully.
+	 */
+	data_reporting_started = false;
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
+	int ret;
+
+	ret = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_deactivate),
+					bl_deactivate);
+	if (ret < 0)
+		return ret;
+
+	/* Wait for bootloader to switch to idle state; should take < 100ms */
+	msleep(100);
+	ret = cyapa_poll_state(cyapa, 500);
+	if (ret < 0)
+		return ret;
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
+	int ret;
+
+	ret = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_exit), bl_exit);
+	if (ret < 0)
+		return ret;
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
+	ret = cyapa_poll_state(cyapa, 4000);
+	if (ret < 0)
+		return ret;
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
+	int ret;
+
+	switch (cyapa->state) {
+	case CYAPA_STATE_BL_ACTIVE:
+		ret = cyapa_gen3_bl_deactivate(cyapa);
+		if (ret) {
+			dev_err(dev, "failed to bl_deactivate. %d\n", ret);
+			return ret;
+		}
+
+	/* Fallthrough state */
+	case CYAPA_STATE_BL_IDLE:
+		/* Try to get firmware version in bootloader mode. */
+		cyapa_gen3_bl_query_data(cyapa);
+
+		ret = cyapa_gen3_bl_exit(cyapa);
+		if (ret) {
+			dev_err(dev, "failed to bl_exit. %d\n", ret);
+			return ret;
+		}
+
+	/* Fallthrough state */
+	case CYAPA_STATE_OP:
+		/*
+		 * Reading query data before going back to the full mode
+		 * may cause problems, so we set the power mode first here.
+		 */
+		ret = cyapa_gen3_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE, 0);
+		if (ret)
+			dev_err(dev, "%s: set full power mode failed, (%d)\n",
+				__func__, ret);
+		ret = cyapa_gen3_get_query_data(cyapa);
+		if (ret < 0)
+			return ret;
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
+		data_reporting_started = true;
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
+	if (data_reporting_started)
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
+static void cyapa_gen3_irq_handler(struct cyapa *cyapa)
+{
+	struct input_dev *input = cyapa->input;
+	struct cyapa_reg_data data;
+	int i;
+	int ret;
+	int num_fingers;
+
+	if (!input)
+		return;
+
+	ret = cyapa_read_block(cyapa, CYAPA_CMD_GROUP_DATA, (u8 *)&data);
+	if (ret != sizeof(data)) {
+		async_schedule(cyapa_detect_async, cyapa);
+		return;
+	}
+
+	if ((data.device_status & OP_STATUS_SRC) != OP_STATUS_SRC ||
+	    (data.device_status & OP_STATUS_DEV) != CYAPA_DEV_NORMAL ||
+	    (data.finger_btn & OP_DATA_VALID) != OP_DATA_VALID) {
+		async_schedule(cyapa_detect_async, cyapa);
+		return;
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


