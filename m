Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189Ab3BJUQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 15:16:12 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64209 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761064Ab3BJUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 15:16:10 -0500
From: Benson Leung <bleung@chromium.org>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org
Cc: bleung@chromium.org, olofj@chromium.org, djkurtz@chromium.org,
        dudl@cypress.com
Subject: [PATCH v2 1/1] Input: mouse: cyapa - Add support for cyapa smbus protocol
Date: Sun, 10 Feb 2013 12:15:40 -0800
Message-Id: <1360527340-25936-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359673513-22328-1-git-send-email-bleung@chromium.org>
References: <1359673513-22328-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Cypress APA Smbus Trackpad type,
which uses a modified register map that fits within the
limitations of the smbus protocol.

Devices that use this protocol include:
CYTRA-116001-00 - Samsung Series 5 550 Chromebook trackpad
CYTRA-103002-00 - Acer C7 Chromebook trackpad
CYTRA-101003-00 - HP Pavilion 14 Chromebook trackpad

Signed-off-by: Dudley Du <dudl@cypress.com>
Signed-off-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
---
v2 : Minor style cleanup. Removed unused struct device *dev declarations.
---
 drivers/input/mouse/cyapa.c | 180 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 175 insertions(+), 5 deletions(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 1a14688..0ba66aa 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -208,6 +208,7 @@ struct cyapa {
 	char phys[32];	/* device physical location */
 	int irq;
 	bool irq_wake;  /* irq wake is enabled */
+	bool smbus;
 
 	/* read from query data region. */
 	char product_id[16];
@@ -229,6 +230,60 @@ struct cyapa_cmd_len {
 	u8 len;
 };
 
+#define CYAPA_ADAPTER_FUNC_NONE   0
+#define CYAPA_ADAPTER_FUNC_I2C    1
+#define CYAPA_ADAPTER_FUNC_SMBUS  2
+#define CYAPA_ADAPTER_FUNC_BOTH   3
+
+/*
+ * macros for SMBus communication
+ */
+#define SMBUS_READ   0x01
+#define SMBUS_WRITE 0x00
+#define SMBUS_ENCODE_IDX(cmd, idx) ((cmd) | (((idx) & 0x03) << 1))
+#define SMBUS_ENCODE_RW(cmd, rw) ((cmd) | ((rw) & 0x01))
+#define SMBUS_BYTE_BLOCK_CMD_MASK 0x80
+#define SMBUS_GROUP_BLOCK_CMD_MASK 0x40
+
+ /* for byte read/write command */
+#define CMD_RESET 0
+#define CMD_POWER_MODE 1
+#define CMD_DEV_STATUS 2
+#define SMBUS_BYTE_CMD(cmd) (((cmd) & 0x3f) << 1)
+#define CYAPA_SMBUS_RESET SMBUS_BYTE_CMD(CMD_RESET)
+#define CYAPA_SMBUS_POWER_MODE SMBUS_BYTE_CMD(CMD_POWER_MODE)
+#define CYAPA_SMBUS_DEV_STATUS SMBUS_BYTE_CMD(CMD_DEV_STATUS)
+
+ /* for group registers read/write command */
+#define REG_GROUP_DATA 0
+#define REG_GROUP_CMD 2
+#define REG_GROUP_QUERY 3
+#define SMBUS_GROUP_CMD(grp) (0x80 | (((grp) & 0x07) << 3))
+#define CYAPA_SMBUS_GROUP_DATA SMBUS_GROUP_CMD(REG_GROUP_DATA)
+#define CYAPA_SMBUS_GROUP_CMD SMBUS_GROUP_CMD(REG_GROUP_CMD)
+#define CYAPA_SMBUS_GROUP_QUERY SMBUS_GROUP_CMD(REG_GROUP_QUERY)
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
+#define CYAPA_SMBUS_BL_STATUS SMBUS_BLOCK_CMD(CMD_BL_STATUS)
+#define CYAPA_SMBUS_BL_HEAD SMBUS_BLOCK_CMD(CMD_BL_HEAD)
+#define CYAPA_SMBUS_BL_CMD SMBUS_BLOCK_CMD(CMD_BL_CMD)
+#define CYAPA_SMBUS_BL_DATA SMBUS_BLOCK_CMD(CMD_BL_DATA)
+#define CYAPA_SMBUS_BL_ALL SMBUS_BLOCK_CMD(CMD_BL_ALL)
+
+/* register block read/write command in operational mode */
+#define CYAPA_SMBUS_BLK_PRODUCT_ID SMBUS_BLOCK_CMD(CMD_BLK_PRODUCT_ID)
+#define CYAPA_SMBUS_BLK_HEAD SMBUS_BLOCK_CMD(CMD_BLK_HEAD)
+
 static const struct cyapa_cmd_len cyapa_i2c_cmds[] = {
 	{ CYAPA_OFFSET_SOFT_RESET, 1 },
 	{ REG_OFFSET_COMMAND_BASE + 1, 1 },
@@ -245,6 +300,22 @@ static const struct cyapa_cmd_len cyapa_i2c_cmds[] = {
 	{ REG_OFFSET_DATA_BASE, 32 }
 };
 
+static const struct cyapa_cmd_len cyapa_smbus_cmds[] = {
+	{ CYAPA_SMBUS_RESET, 1 },
+	{ CYAPA_SMBUS_POWER_MODE, 1 },
+	{ CYAPA_SMBUS_DEV_STATUS, 1 },
+	{ CYAPA_SMBUS_GROUP_DATA, sizeof(struct cyapa_reg_data) },
+	{ CYAPA_SMBUS_GROUP_CMD, 2 },
+	{ CYAPA_SMBUS_GROUP_QUERY, QUERY_DATA_SIZE },
+	{ CYAPA_SMBUS_BL_STATUS, 3 },
+	{ CYAPA_SMBUS_BL_HEAD, 16 },
+	{ CYAPA_SMBUS_BL_CMD, 16 },
+	{ CYAPA_SMBUS_BL_DATA, 16 },
+	{ CYAPA_SMBUS_BL_ALL, 32 },
+	{ CYAPA_SMBUS_BLK_PRODUCT_ID, PRODUCT_ID_SIZE },
+	{ CYAPA_SMBUS_BLK_HEAD, 16 },
+};
+
 static ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
 					u8 *values)
 {
@@ -257,26 +328,93 @@ static ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
 	return i2c_smbus_write_i2c_block_data(cyapa->client, reg, len, values);
 }
 
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
+static ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
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
+
+	return (ret > 0) ? len : ret;
+}
+
 static s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx)
 {
-	u8 cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+	u8 cmd;
 
+	if (cyapa->smbus) {
+		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
+		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
+	} else {
+		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+	}
 	return i2c_smbus_read_byte_data(cyapa->client, cmd);
 }
 
 static s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value)
 {
-	u8 cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+	u8 cmd;
 
+	if (cyapa->smbus) {
+		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
+		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_WRITE);
+	} else {
+		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+	}
 	return i2c_smbus_write_byte_data(cyapa->client, cmd, value);
 }
 
 static ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values)
 {
-	u8 cmd = cyapa_i2c_cmds[cmd_idx].cmd;
-	size_t len = cyapa_i2c_cmds[cmd_idx].len;
+	u8 cmd;
+	size_t len;
 
-	return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
+	if (cyapa->smbus) {
+		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
+		len = cyapa_smbus_cmds[cmd_idx].len;
+		return cyapa_smbus_read_block(cyapa, cmd, len, values);
+	} else {
+		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+		len = cyapa_i2c_cmds[cmd_idx].len;
+		return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
+	}
 }
 
 /*
@@ -298,6 +436,15 @@ static int cyapa_get_state(struct cyapa *cyapa)
 	 */
 	ret = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET, BL_STATUS_SIZE,
 				       status);
+
+	/*
+	 * On smbus systems in OP mode, the i2c_reg_read will fail with
+	 * -ETIMEDOUT.  In this case, try again using the smbus equivalent
+	 * command.  This should return a BL_HEAD indicating CYAPA_STATE_OP.
+	 */
+	if (cyapa->smbus && (ret == -ETIMEDOUT || ret == -ENXIO))
+		ret = cyapa_read_block(cyapa, CYAPA_CMD_BL_STATUS, status);
+
 	if (ret != BL_STATUS_SIZE)
 		goto error;
 
@@ -594,6 +741,19 @@ out:
 	return IRQ_HANDLED;
 }
 
+static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
+{
+	u8 ret = CYAPA_ADAPTER_FUNC_NONE;
+
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		ret |= CYAPA_ADAPTER_FUNC_I2C;
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA |
+				     I2C_FUNC_SMBUS_BLOCK_DATA |
+				     I2C_FUNC_SMBUS_I2C_BLOCK))
+		ret |= CYAPA_ADAPTER_FUNC_SMBUS;
+	return ret;
+}
+
 static int cyapa_create_input_dev(struct cyapa *cyapa)
 {
 	struct device *dev = &cyapa->client->dev;
@@ -668,9 +828,16 @@ static int cyapa_probe(struct i2c_client *client,
 		       const struct i2c_device_id *dev_id)
 {
 	int ret;
+	u8 adapter_func;
 	struct cyapa *cyapa;
 	struct device *dev = &client->dev;
 
+	adapter_func = cyapa_check_adapter_functionality(client);
+	if (adapter_func == CYAPA_ADAPTER_FUNC_NONE) {
+		dev_err(dev, "not a supported I2C/SMBus adapter\n");
+		return -EIO;
+	}
+
 	cyapa = kzalloc(sizeof(struct cyapa), GFP_KERNEL);
 	if (!cyapa) {
 		dev_err(dev, "allocate memory for cyapa failed\n");
@@ -683,6 +850,9 @@ static int cyapa_probe(struct i2c_client *client,
 	sprintf(cyapa->phys, "i2c-%d-%04x/input0", client->adapter->nr,
 		client->addr);
 
+	/* i2c isn't supported, set smbus */
+	if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
+		cyapa->smbus = true;
 	cyapa->state = CYAPA_STATE_NO_DEVICE;
 	ret = cyapa_check_is_operational(cyapa);
 	if (ret) {
-- 
1.8.1

