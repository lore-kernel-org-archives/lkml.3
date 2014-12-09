Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaLIJNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:13:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49114 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbaLIJN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:13:26 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 06/12] input: cyapa: add gen3 trackpad device firmware update function support
Date: Tue,  9 Dec 2014 17:11:38 +0800
Message-Id: <1418116304-11392-7-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add firmware image update function supported for gen3 trackpad device,
it can be used through sysfs update_fw interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa_gen3.c | 284 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 284 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index a50986c..1110668 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -416,6 +416,72 @@ static int cyapa_gen3_state_parse(struct cyapa *cyapa, u8 *reg_data, int len)
 	return -EAGAIN;
 }
 
+/*
+ * Enter bootloader by soft resetting the device.
+ *
+ * If device is already in the bootloader, the function just returns.
+ * Otherwise, reset the device; after reset, device enters bootloader idle
+ * state immediately.
+ *
+ * Also, if device was unregister device from input core.  Device will
+ * re-register after it is detected following resumption of operational mode.
+ *
+ * Returns:
+ *   0 on success
+ *   -EAGAIN  device was reset, but is not now in bootloader idle state
+ *   < 0 if the device never responds within the timeout
+ */
+static int cyapa_gen3_bl_enter(struct cyapa *cyapa)
+{
+	int error;
+
+	error = cyapa_poll_state(cyapa, 500);
+	if (error)
+		return error;
+	if (cyapa->state == CYAPA_STATE_BL_IDLE) {
+		/* Already in BL_IDLE. Skipping reset. */
+		return 0;
+	}
+
+	if (cyapa->state != CYAPA_STATE_OP)
+		return -EAGAIN;
+
+	cyapa->state = CYAPA_STATE_NO_DEVICE;
+	error = cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET, 0x01);
+	if (error)
+		return -EIO;
+
+	usleep_range(25000, 50000);
+	error = cyapa_poll_state(cyapa, 500);
+	if (error)
+		return error;
+	if ((cyapa->state != CYAPA_STATE_BL_IDLE) ||
+		(cyapa->status[REG_BL_STATUS] & BL_STATUS_WATCHDOG))
+		return -EAGAIN;
+
+	return 0;
+}
+
+static int cyapa_gen3_bl_activate(struct cyapa *cyapa)
+{
+	int error;
+
+	error = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_activate),
+					bl_activate);
+	if (error)
+		return error;
+
+	/* Wait for bootloader to activate; takes between 2 and 12 seconds */
+	msleep(2000);
+	error = cyapa_poll_state(cyapa, 11000);
+	if (error)
+		return error;
+	if (cyapa->state != CYAPA_STATE_BL_ACTIVE)
+		return -EAGAIN;
+
+	return 0;
+}
+
 static int cyapa_gen3_bl_deactivate(struct cyapa *cyapa)
 {
 	int error;
@@ -476,6 +542,218 @@ static int cyapa_gen3_bl_exit(struct cyapa *cyapa)
 	return 0;
 }
 
+/* Used in gen3 bootloader commands. */
+static u16 cyapa_gen3_csum(const u8 *buf, size_t count)
+{
+	int i;
+	u16 csum = 0;
+
+	for (i = 0; i < count; i++)
+		csum += buf[i];
+
+	return csum;
+}
+
+/*
+ * Verify the integrity of a CYAPA firmware image file.
+ *
+ * The firmware image file is 30848 bytes, composed of 482 64-byte blocks.
+ *
+ * The first 2 blocks are the firmware header.
+ * The next 480 blocks are the firmware image.
+ *
+ * The first two bytes of the header hold the header checksum, computed by
+ * summing the other 126 bytes of the header.
+ * The last two bytes of the header hold the firmware image checksum, computed
+ * by summing the 30720 bytes of the image modulo 0xffff.
+ *
+ * Both checksums are stored little-endian.
+ */
+static int cyapa_gen3_check_fw(struct cyapa *cyapa, const struct firmware *fw)
+{
+	struct device *dev = &cyapa->client->dev;
+	u16 csum;
+	u16 csum_expected;
+
+	/* Firmware must match exact 30848 bytes = 482 64-byte blocks. */
+	if (fw->size != CYAPA_FW_SIZE) {
+		dev_err(dev, "invalid firmware size = %zu, expected %u.\n",
+			fw->size, CYAPA_FW_SIZE);
+		return -EINVAL;
+	}
+
+	/* Verify header block */
+	csum_expected = (fw->data[0] << 8) | fw->data[1];
+	csum = cyapa_gen3_csum(&fw->data[2], CYAPA_FW_HDR_SIZE - 2);
+	if (csum != csum_expected) {
+		dev_err(dev, "%s %04x, expected: %04x\n",
+			"invalid firmware header checksum = ",
+			csum, csum_expected);
+		return -EINVAL;
+	}
+
+	/* Verify firmware image */
+	csum_expected = (fw->data[CYAPA_FW_HDR_SIZE - 2] << 8) |
+			 fw->data[CYAPA_FW_HDR_SIZE - 1];
+	csum = cyapa_gen3_csum(&fw->data[CYAPA_FW_HDR_SIZE],
+			CYAPA_FW_DATA_SIZE);
+	if (csum != csum_expected) {
+		dev_err(dev, "%s %04x, expected: %04x\n",
+			"invalid firmware header checksum = ",
+			csum, csum_expected);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * Write a |len| byte long buffer |buf| to the device, by chopping it up into a
+ * sequence of smaller |CYAPA_CMD_LEN|-length write commands.
+ *
+ * The data bytes for a write command are prepended with the 1-byte offset
+ * of the data relative to the start of |buf|.
+ */
+static int cyapa_gen3_write_buffer(struct cyapa *cyapa,
+		const u8 *buf, size_t len)
+{
+	int error;
+	size_t i;
+	unsigned char cmd[CYAPA_CMD_LEN + 1];
+	size_t cmd_len;
+
+	for (i = 0; i < len; i += CYAPA_CMD_LEN) {
+		const u8 *payload = &buf[i];
+
+		cmd_len = (len - i >= CYAPA_CMD_LEN) ? CYAPA_CMD_LEN : len - i;
+		cmd[0] = i;
+		memcpy(&cmd[1], payload, cmd_len);
+
+		error = cyapa_i2c_reg_write_block(cyapa, 0, cmd_len + 1, cmd);
+		if (error)
+			return error;
+	}
+	return 0;
+}
+
+/*
+ * A firmware block write command writes 64 bytes of data to a single flash
+ * page in the device.  The 78-byte block write command has the format:
+ *   <0xff> <CMD> <Key> <Start> <Data> <Data-Checksum> <CMD Checksum>
+ *
+ *  <0xff>  - every command starts with 0xff
+ *  <CMD>   - the write command value is 0x39
+ *  <Key>   - write commands include an 8-byte key: { 00 01 02 03 04 05 06 07 }
+ *  <Block> - Memory Block number (address / 64) (16-bit, big-endian)
+ *  <Data>  - 64 bytes of firmware image data
+ *  <Data Checksum> - sum of 64 <Data> bytes, modulo 0xff
+ *  <CMD Checksum> - sum of 77 bytes, from 0xff to <Data Checksum>
+ *
+ * Each write command is split into 5 i2c write transactions of up to 16 bytes.
+ * Each transaction starts with an i2c register offset: (00, 10, 20, 30, 40).
+ */
+static int cyapa_gen3_write_fw_block(struct cyapa *cyapa,
+		u16 block, const u8 *data)
+{
+	int ret;
+	u8 cmd[78];
+	u8 status[BL_STATUS_SIZE];
+	/* Programming for one block can take about 100ms. */
+	int tries = 11;
+	u8 bl_status, bl_error;
+
+	/* Set write command and security key bytes. */
+	cmd[0] = 0xff;
+	cmd[1] = 0x39;
+	cmd[2] = 0x00;
+	cmd[3] = 0x01;
+	cmd[4] = 0x02;
+	cmd[5] = 0x03;
+	cmd[6] = 0x04;
+	cmd[7] = 0x05;
+	cmd[8] = 0x06;
+	cmd[9] = 0x07;
+	cmd[10] = block >> 8;
+	cmd[11] = block;
+	memcpy(&cmd[12], data, CYAPA_FW_BLOCK_SIZE);
+	cmd[76] = cyapa_gen3_csum(data, CYAPA_FW_BLOCK_SIZE);
+	cmd[77] = cyapa_gen3_csum(cmd, sizeof(cmd) - 1);
+
+	ret = cyapa_gen3_write_buffer(cyapa, cmd, sizeof(cmd));
+	if (ret)
+		return ret;
+
+	/* Wait for write to finish */
+	do {
+		usleep_range(10000, 20000);
+
+		/* Check block write command result status. */
+		ret = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET,
+					       BL_STATUS_SIZE, status);
+		if (ret != BL_STATUS_SIZE)
+			return (ret < 0) ? ret : -EIO;
+	} while ((status[REG_BL_STATUS] & BL_STATUS_BUSY) && --tries);
+
+	/* Ignore WATCHDOG bit and reserved bits. */
+	bl_status = status[REG_BL_STATUS] & ~BL_STATUS_REV_MASK;
+	bl_error = status[REG_BL_ERROR] & ~BL_ERROR_RESERVED;
+
+	if (bl_status & BL_STATUS_BUSY)
+		ret = -ETIMEDOUT;
+	else if (bl_status != BL_STATUS_RUNNING ||
+		bl_error != BL_ERROR_BOOTLOADING)
+		ret = -EIO;
+	else
+		ret = 0;
+
+	return ret;
+}
+
+static int cyapa_gen3_write_blocks(struct cyapa *cyapa,
+		size_t start_block, size_t block_count,
+		const u8 *image_data)
+{
+	int error;
+	int i;
+
+	for (i = 0; i < block_count; i++) {
+		size_t block = start_block + i;
+		size_t addr = i * CYAPA_FW_BLOCK_SIZE;
+		const u8 *data = &image_data[addr];
+
+		error = cyapa_gen3_write_fw_block(cyapa, block, data);
+		if (error)
+			return error;
+	}
+	return 0;
+}
+
+static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
+		const struct firmware *fw)
+{
+	struct device *dev = &cyapa->client->dev;
+	int error;
+
+	/* First write data, starting at byte 128  of fw->data */
+	error = cyapa_gen3_write_blocks(cyapa,
+		CYAPA_FW_DATA_BLOCK_START, CYAPA_FW_DATA_BLOCK_COUNT,
+		&fw->data[CYAPA_FW_HDR_BLOCK_COUNT * CYAPA_FW_BLOCK_SIZE]);
+	if (error) {
+		dev_err(dev, "FW update aborted, write image: %d\n", error);
+		return error;
+	}
+
+	/* Then write checksum */
+	error = cyapa_gen3_write_blocks(cyapa,
+		CYAPA_FW_HDR_BLOCK_START, CYAPA_FW_HDR_BLOCK_COUNT,
+		&fw->data[0]);
+	if (error) {
+		dev_err(dev, "FW update aborted, write checksum: %d\n", error);
+		return error;
+	}
+
+	return 0;
+}
+
 /*
  * cyapa_get_wait_time_for_pwr_cmd
  *
@@ -783,6 +1061,12 @@ static int cyapa_gen3_irq_handler(struct cyapa *cyapa)
 }
 
 const struct cyapa_dev_ops cyapa_gen3_ops = {
+	.check_fw = cyapa_gen3_check_fw,
+	.bl_enter = cyapa_gen3_bl_enter,
+	.bl_activate = cyapa_gen3_bl_activate,
+	.update_fw = cyapa_gen3_do_fw_update,
+	.bl_deactivate = cyapa_gen3_bl_deactivate,
+
 	.state_parse = cyapa_gen3_state_parse,
 	.operational_check = cyapa_gen3_do_operational_check,
 
-- 
1.9.1

