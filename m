Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaLIJOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:14:12 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37489 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaLIJOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:14:06 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 09/12] input: cyapa: add gen5 trackpad device firmware update function support
Date: Tue,  9 Dec 2014 17:11:41 +0800
Message-Id: <1418116304-11392-10-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add firmware image update function supported for gen5 trackpad device,
it can be used through sysfs update_fw interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/Kconfig      |   2 +-
 drivers/input/mouse/cyapa_gen5.c | 290 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 291 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index d8b46b0..63e8b40 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -205,7 +205,7 @@ config MOUSE_BCM5974
 
 config MOUSE_CYAPA
 	tristate "Cypress APA I2C Trackpad support"
-	depends on I2C
+	depends on I2C && CRC_ITU_T
 	help
 	  This driver adds support for Cypress All Points Addressable (APA)
 	  I2C Trackpads, including the ones used in 2012 Samsung Chromebooks.
diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index 8509046..47a0543 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -18,6 +18,7 @@
 #include <linux/completion.h>
 #include <linux/slab.h>
 #include <linux/unaligned/access_ok.h>
+#include <linux/crc-itu-t.h>
 #include "cyapa.h"
 
 
@@ -911,6 +912,86 @@ static int cyapa_gen5_state_parse(struct cyapa *cyapa, u8 *reg_data, int len)
 	return -EAGAIN;
 }
 
+static int cyapa_gen5_bl_initiate(struct cyapa *cyapa,
+		const struct firmware *fw)
+{
+	u16 length = 0;
+	u16 data_len = 0;
+	u16 meta_data_crc = 0;
+	u16 cmd_crc = 0;
+	u8 bl_gen5_activate[18 + CYAPA_TSG_FLASH_MAP_BLOCK_SIZE + 3];
+	int bl_gen5_activate_size = 0;
+	u8 resp_data[11];
+	int resp_len;
+	struct cyapa_tsg_bin_image *image;
+	int records_num;
+	u8 *data;
+	int error;
+
+	/* Try to dump all bufferred report data before send any command. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	bl_gen5_activate_size = sizeof(bl_gen5_activate);
+	memset(bl_gen5_activate, 0, bl_gen5_activate_size);
+
+	/* Output Report Register Address[15:0] = 0004h */
+	bl_gen5_activate[0] = 0x04;
+	bl_gen5_activate[1] = 0x00;
+
+	/* Total command length[15:0] */
+	length = bl_gen5_activate_size - 2;
+	put_unaligned_le16(length, &bl_gen5_activate[2]);
+	bl_gen5_activate[4] = 0x40;  /* Report ID = 40h */
+	bl_gen5_activate[5] = 0x00;  /* RSVD = 00h */
+
+	bl_gen5_activate[6] = GEN5_SOP_KEY;  /* SOP = 01h */
+	bl_gen5_activate[7] = 0x48;  /* Command Code = 48h */
+
+	/* 8 Key bytes and block size */
+	data_len = CYAPA_TSG_BL_KEY_SIZE + CYAPA_TSG_FLASH_MAP_BLOCK_SIZE;
+	/* Data Length[15:0] */
+	put_unaligned_le16(data_len, &bl_gen5_activate[8]);
+	bl_gen5_activate[10] = 0xa5;  /* Key Byte 0 */
+	bl_gen5_activate[11] = 0x01;
+	bl_gen5_activate[12] = 0x02;  /*     .      */
+	bl_gen5_activate[13] = 0x03;  /*     .      */
+	bl_gen5_activate[14] = 0xff;  /*     .      */
+	bl_gen5_activate[15] = 0xfe;
+	bl_gen5_activate[16] = 0xfd;
+	bl_gen5_activate[17] = 0x5a;  /* Key Byte 7 */
+
+	/* Copy 60 bytes Meta Data Row Parameters */
+	image = (struct cyapa_tsg_bin_image *)fw->data;
+	records_num = (fw->size - sizeof(struct cyapa_tsg_bin_image_head)) /
+				sizeof(struct cyapa_tsg_bin_image_data_record);
+	/* APP_INTEGRITY row is always the last row block */
+	data = image->records[records_num - 1].record_data;
+	memcpy(&bl_gen5_activate[18], data, CYAPA_TSG_FLASH_MAP_METADATA_SIZE);
+
+	meta_data_crc = crc_itu_t(0xffff, &bl_gen5_activate[18],
+				CYAPA_TSG_FLASH_MAP_METADATA_SIZE);
+	/* Meta Data CRC[15:0] */
+	put_unaligned_le16(meta_data_crc,
+		&bl_gen5_activate[18 + CYAPA_TSG_FLASH_MAP_METADATA_SIZE]);
+
+	cmd_crc = crc_itu_t(0xffff, &bl_gen5_activate[6], 4 + data_len);
+	put_unaligned_le16(cmd_crc,
+		&bl_gen5_activate[bl_gen5_activate_size - 3]);  /* CRC[15:0] */
+	bl_gen5_activate[bl_gen5_activate_size - 1] = GEN5_EOP_KEY;
+
+	resp_len = sizeof(resp_data);
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			bl_gen5_activate, sizeof(bl_gen5_activate),
+			resp_data, &resp_len, 12000,
+			cyapa_gen5_sort_tsg_pip_bl_resp_data, true);
+	if (error || resp_len != GEN5_BL_INITIATE_RESP_LEN ||
+			resp_data[2] != GEN5_BL_RESP_REPORT_ID ||
+			!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+		return error ? error : -EAGAIN;
+
+	return 0;
+}
+
 bool cyapa_gen5_sort_bl_exit_data(struct cyapa *cyapa, u8 *buf, int len)
 {
 	if (buf == NULL || len < GEN5_RESP_LENGTH_SIZE)
@@ -960,6 +1041,210 @@ static int cyapa_gen5_bl_exit(struct cyapa *cyapa)
 	return -ENODEV;
 }
 
+static int cyapa_gen5_bl_enter(struct cyapa *cyapa)
+{
+	int error;
+	u8 cmd[] = { 0x04, 0x00, 0x05, 0x00, 0x2F, 0x00, 0x01 };
+	u8 resp_data[2];
+	int resp_len;
+
+	error = cyapa_poll_state(cyapa, 500);
+	if (error < 0)
+		return error;
+	if (cyapa->gen != CYAPA_GEN5)
+		return -EINVAL;
+
+	/* Already in Gen5 BL. Skipping exit. */
+	if (cyapa->state == CYAPA_STATE_GEN5_BL)
+		return 0;
+
+	if (cyapa->state != CYAPA_STATE_GEN5_APP)
+		return -EAGAIN;
+
+	/* Try to dump all bufferred report data before send any command. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	/*
+	 * Send bootloader enter command to trackpad device,
+	 * after enter bootloader, the response data is two bytes of 0x00 0x00.
+	 */
+	resp_len = sizeof(resp_data);
+	memset(resp_data, 0, resp_len);
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, sizeof(cmd),
+			resp_data, &resp_len,
+			5000, cyapa_gen5_sort_application_launch_data,
+			true);
+	if (error || resp_data[0] != 0x00 || resp_data[1] != 0x00)
+		return error < 0 ? error : -EAGAIN;
+
+	cyapa->state = CYAPA_STATE_GEN5_BL;
+	return 0;
+}
+
+static int cyapa_gen5_check_fw(struct cyapa *cyapa, const struct firmware *fw)
+{
+	int i;
+	struct cyapa_tsg_bin_image *image;
+	int flash_records_count;
+	u16 expected_app_crc;
+	u16 expected_app_integrity_crc;
+	u16 app_crc = 0;
+	u16 app_integrity_crc = 0;
+	u16 row_num;
+	u8 *data;
+	u32 app_start;
+	u16 app_len;
+	u32 img_start;
+	u16 img_len;
+	int record_index;
+	struct device *dev = &cyapa->client->dev;
+
+	image = (struct cyapa_tsg_bin_image *)fw->data;
+	flash_records_count = (fw->size -
+			sizeof(struct cyapa_tsg_bin_image_head)) /
+			sizeof(struct cyapa_tsg_bin_image_data_record);
+
+	/* APP_INTEGRITY row is always the last row block,
+	 * and the row id must be 0x01ff */
+	row_num = get_unaligned_be16(
+			&image->records[flash_records_count - 1].row_number);
+	if (&image->records[flash_records_count - 1].flash_array_id != 0x00 &&
+			row_num != 0x01ff) {
+		dev_err(dev, "%s: invalid app_integrity data.\n", __func__);
+		return -EINVAL;
+	}
+	data = image->records[flash_records_count - 1].record_data;
+	app_start = get_unaligned_le32(&data[4]);
+	app_len = get_unaligned_le16(&data[8]);
+	expected_app_crc = get_unaligned_le16(&data[10]);
+	img_start = get_unaligned_le32(&data[16]);
+	img_len = get_unaligned_le16(&data[20]);
+	expected_app_integrity_crc = get_unaligned_le16(&data[60]);
+
+	if ((app_start + app_len + img_start + img_len) %
+			CYAPA_TSG_FW_ROW_SIZE) {
+		dev_err(dev, "%s: invalid image alignment.\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Verify app_integrity crc */
+	app_integrity_crc = crc_itu_t(0xffff, data,
+			CYAPA_TSG_APP_INTEGRITY_SIZE);
+	if (app_integrity_crc != expected_app_integrity_crc) {
+		dev_err(dev, "%s: invalid app_integrity crc.\n", __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * Verify application image CRC
+	 */
+	record_index = app_start / CYAPA_TSG_FW_ROW_SIZE -
+				CYAPA_TSG_IMG_START_ROW_NUM;
+	data = (u8 *)&image->records[record_index].record_data;
+	app_crc = crc_itu_t(0xffff, data, CYAPA_TSG_FW_ROW_SIZE);
+	for (i = 1; i < (app_len / CYAPA_TSG_FW_ROW_SIZE); i++) {
+		data = (u8 *)&image->records[++record_index].record_data;
+		app_crc = crc_itu_t(app_crc, data, CYAPA_TSG_FW_ROW_SIZE);
+	}
+
+	if (app_crc != expected_app_crc) {
+		dev_err(dev, "%s: invalid firmware app crc check.\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int cyapa_gen5_write_fw_block(struct cyapa *cyapa,
+		struct cyapa_tsg_bin_image_data_record *flash_record)
+{
+	u8 flash_array_id;
+	u16 flash_row_id;
+	u16 record_len;
+	u8 *record_data;
+	u8 cmd[144];  /* 13 + 128+ 3 */
+	u16 cmd_len;
+	u16 data_len;
+	u16 crc;
+	u8 resp_data[11];
+	int resp_len;
+	int error;
+
+	flash_array_id = flash_record->flash_array_id;
+	flash_row_id = get_unaligned_be16(&flash_record->row_number);
+	record_len = get_unaligned_be16(&flash_record->record_len);
+	record_data = flash_record->record_data;
+
+	cmd_len = sizeof(cmd) - 2; /* Not include 2 bytes regisetr address. */
+	memset(cmd, 0, cmd_len + 2);
+	cmd[0] = 0x04;  /* Register address */
+	cmd[1] = 0x00;
+
+	put_unaligned_le16(cmd_len, &cmd[2]);
+	cmd[4] = 0x40;  /* Report id 40h */
+	cmd[5] = 0x00;
+
+	cmd[6] = GEN5_SOP_KEY;  /* SOP = 01h */
+	cmd[7] = 0x39;  /* Command code = 39h */
+	/* 1 (Flash Array ID) + 2 (Flash Row ID) + 128 (flash data) */
+	data_len = 3 + record_len;
+	put_unaligned_le16(data_len, &cmd[8]);
+	cmd[10] = flash_array_id;  /* Flash Array ID = 00h */
+	put_unaligned_le16(flash_row_id, &cmd[11]);
+
+	memcpy(&cmd[13], record_data, record_len);
+	crc = crc_itu_t(0xffff, &cmd[6], 4 + data_len);
+	put_unaligned_le16(crc, &cmd[2 + cmd_len - 3]);
+	cmd[2 + cmd_len - 1] = GEN5_EOP_KEY;
+
+	resp_len = sizeof(resp_data);
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, sizeof(cmd),
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_bl_resp_data, true);
+	if (error || resp_len != GEN5_BL_BLOCK_WRITE_RESP_LEN ||
+			resp_data[2] != GEN5_BL_RESP_REPORT_ID ||
+			!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+		return error < 0 ? error : -EAGAIN;
+
+	return 0;
+}
+
+static int cyapa_gen5_do_fw_update(struct cyapa *cyapa,
+		const struct firmware *fw)
+{
+	struct device *dev = &cyapa->client->dev;
+	struct cyapa_tsg_bin_image *image =
+		(struct cyapa_tsg_bin_image *)fw->data;
+	struct cyapa_tsg_bin_image_data_record *flash_record;
+	int flash_records_count;
+	int i;
+	int error;
+
+	/* Try to dump all bufferred data if exists before send commands. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	flash_records_count =
+		(fw->size - sizeof(struct cyapa_tsg_bin_image_head)) /
+			sizeof(struct cyapa_tsg_bin_image_data_record);
+	/*
+	 * The last flash row 0x01ff has been written through bl_initiate
+	 *  command, so DO NOT write flash 0x01ff to trackpad device.
+	 */
+	for (i = 0; i < (flash_records_count - 1); i++) {
+		flash_record = &image->records[i];
+		error = cyapa_gen5_write_fw_block(cyapa, flash_record);
+		if (error) {
+			dev_err(dev, "%s: Gen5 FW update aborted: %d\n",
+				__func__, error);
+			return error;
+		}
+	}
+
+	return 0;
+}
+
 static int cyapa_gen5_change_power_state(struct cyapa *cyapa, u8 power_state)
 {
 	u8 cmd[8] = { 0x04, 0x00, 0x06, 0x00, 0x2f, 0x00, 0x08, 0x01 };
@@ -1648,6 +1933,11 @@ static int cyapa_gen5_irq_handler(struct cyapa *cyapa)
 }
 
 const struct cyapa_dev_ops cyapa_gen5_ops = {
+	.check_fw = cyapa_gen5_check_fw,
+	.bl_enter = cyapa_gen5_bl_enter,
+	.bl_initiate = cyapa_gen5_bl_initiate,
+	.update_fw = cyapa_gen5_do_fw_update,
+
 	.initialize = cyapa_gen5_initialize,
 
 	.state_parse = cyapa_gen5_state_parse,
-- 
1.9.1

