Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbbAPGfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 01:35:37 -0500
Received: from smtp1.cypress.com ([157.95.67.100]:49163 "EHLO
	smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbbAPGfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 01:35:18 -0500
From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, jmmahler@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v18 09/12] input: cyapa: add gen5 trackpad device firmware update function support
Date: Fri, 16 Jan 2015 14:34:12 +0800
Message-Id: <1421390055-32760-10-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421390055-32760-1-git-send-email-dudl@cypress.com>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add firmware image update function supported for gen5 trackpad device,
it can be used through sysfs update_fw interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/Kconfig      |   1 +
 drivers/input/mouse/cyapa_gen5.c | 391 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 392 insertions(+)

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index d8b46b0..728490e 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -206,6 +206,7 @@ config MOUSE_BCM5974
 config MOUSE_CYAPA
 	tristate "Cypress APA I2C Trackpad support"
 	depends on I2C
+	select CRC_ITU_T
 	help
 	  This driver adds support for Cypress All Points Addressable (APA)
 	  I2C Trackpads, including the ones used in 2012 Samsung Chromebooks.
diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index a049ae3..442b29d 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -18,6 +18,7 @@
 #include <linux/completion.h>
 #include <linux/slab.h>
 #include <linux/unaligned/access_ok.h>
+#include <linux/crc-itu-t.h>
 #include "cyapa.h"
 
 
@@ -264,6 +265,79 @@ struct cyapa_gen5_report_data {
 	struct cyapa_gen5_touch_record touch_records[10];
 } __packed;
 
+struct cyapa_tsg_bin_image_head {
+	u8 head_size;  /* Unit: bytes, including itself. */
+	u8 ttda_driver_major_version;  /* Reserved as 0. */
+	u8 ttda_driver_minor_version;  /* Reserved as 0. */
+	u8 fw_major_version;
+	u8 fw_minor_version;
+	u8 fw_revision_control_number[8];
+} __packed;
+
+struct cyapa_tsg_bin_image_data_record {
+	u8 flash_array_id;
+	__be16 row_number;
+	/* The number of bytes of flash data contained in this record. */
+	__be16 record_len;
+	/* The flash program data. */
+	u8 record_data[CYAPA_TSG_FW_ROW_SIZE];
+} __packed;
+
+struct cyapa_tsg_bin_image {
+	struct cyapa_tsg_bin_image_head image_head;
+	struct cyapa_tsg_bin_image_data_record records[0];
+} __packed;
+
+struct gen5_bl_packet_start {
+	u8 sop;  /* Start of packet, must be 01h */
+	u8 cmd_code;
+	__le16 data_length;  /* Size of data parameter start from data[0] */
+} __packed;
+
+struct gen5_bl_packet_end {
+	__le16 crc;
+	u8 eop;  /* End of packet, must be 17h */
+} __packed;
+
+struct gen5_bl_cmd_head {
+	__le16 addr;   /* Output report register address, must be 0004h */
+	/* Size of packet not including output report register address */
+	__le16 length;
+	u8 report_id;  /* Bootloader output report id, must be 40h */
+	u8 rsvd;  /* Reserved, must be 0 */
+	struct gen5_bl_packet_start packet_start;
+	u8 data[0];  /* Command data variable based on commands */
+} __packed;
+
+/* Initiate bootload command data structure. */
+struct gen5_bl_initiate_cmd_data {
+	/* Key must be "A5h 01h 02h 03h FFh FEh FDh 5Ah" */
+	u8 key[CYAPA_TSG_BL_KEY_SIZE];
+	u8 metadata_raw_parameter[CYAPA_TSG_FLASH_MAP_METADATA_SIZE];
+	__le16 metadata_crc;
+} __packed;
+
+struct gen5_bl_metadata_row_params {
+	__le16 size;
+	__le16 maximun_size;
+	__le32 app_start;
+	__le16 app_len;
+	__le16 app_crc;
+	__le32 app_entry;
+	__le32 upgrade_start;
+	__le16 upgrade_len;
+	__le16 entry_row_crc;
+	u8 padding[36];  /* Padding data must be 0 */
+	__le16 metadata_crc;  /* CRC starts at offset of 60 */
+} __packed;
+
+/* Bootload program and verify row command data structure */
+struct gen5_bl_flash_row_head {
+	u8 flash_array_id;
+	__le16 flash_row_id;
+	u8 flash_data[0];
+} __packed;
+
 struct gen5_app_cmd_head {
 	__le16 addr;   /* Output report register address, must be 0004h */
 	/* Size of packet not including output report register address */
@@ -297,6 +371,10 @@ struct gen5_app_get_parameter_data {
 #define GEN5_DEV_UNINIT_SLEEP_TIME(cyapa)	\
 		(((cyapa)->dev_sleep_time) == UNINIT_SLEEP_TIME)
 
+
+static u8 cyapa_gen5_bl_cmd_key[] = { 0xa5, 0x01, 0x02, 0x03,
+	0xff, 0xfe, 0xfd, 0x5a };
+
 static int cyapa_gen5_initialize(struct cyapa *cyapa)
 {
 	struct cyapa_gen5_cmd_states *gen5_pip = &cyapa->cmd_states.gen5;
@@ -618,6 +696,22 @@ static bool cyapa_gen5_sort_tsg_pip_app_resp_data(struct cyapa *cyapa,
 	return false;
 }
 
+static bool cyapa_gen5_sort_application_launch_data(struct cyapa *cyapa,
+		u8 *buf, int len)
+{
+	if (buf == NULL || len < GEN5_RESP_LENGTH_SIZE)
+		return false;
+
+	/*
+	 * After reset or power on, trackpad device always sets to 0x00 0x00
+	 * to indicate a reset or power on event.
+	 */
+	if (buf[0] == 0 && buf[1] == 0)
+		return true;
+
+	return false;
+}
+
 static bool cyapa_gen5_sort_hid_descriptor_data(struct cyapa *cyapa,
 		u8 *buf, int len)
 {
@@ -923,6 +1017,80 @@ static int cyapa_gen5_state_parse(struct cyapa *cyapa, u8 *reg_data, int len)
 	return -EAGAIN;
 }
 
+static int cyapa_gen5_bl_initiate(struct cyapa *cyapa,
+		const struct firmware *fw)
+{
+	struct cyapa_tsg_bin_image *image;
+	struct gen5_bl_cmd_head *bl_cmd_head;
+	struct gen5_bl_packet_start *bl_packet_start;
+	struct gen5_bl_initiate_cmd_data *cmd_data;
+	struct gen5_bl_packet_end *bl_packet_end;
+	u8 cmd[CYAPA_TSG_MAX_CMD_SIZE];
+	int cmd_len;
+	u16 cmd_data_len;
+	u16 cmd_crc = 0;
+	u16 meta_data_crc = 0;
+	u8 resp_data[11];
+	int resp_len;
+	int records_num;
+	u8 *data;
+	int error;
+
+	/* Try to dump all buffered report data before any send command. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	memset(cmd, 0, CYAPA_TSG_MAX_CMD_SIZE);
+	bl_cmd_head = (struct gen5_bl_cmd_head *)cmd;
+	cmd_data_len = CYAPA_TSG_BL_KEY_SIZE + CYAPA_TSG_FLASH_MAP_BLOCK_SIZE;
+	cmd_len = sizeof(struct gen5_bl_cmd_head) + cmd_data_len +
+		  sizeof(struct gen5_bl_packet_end);
+
+	put_unaligned_le16(GEN5_OUTPUT_REPORT_ADDR, &bl_cmd_head->addr);
+	put_unaligned_le16(cmd_len - 2, &bl_cmd_head->length);
+	bl_cmd_head->report_id = GEN5_BL_CMD_REPORT_ID;
+
+	bl_packet_start = &bl_cmd_head->packet_start;
+	bl_packet_start->sop = GEN5_SOP_KEY;
+	bl_packet_start->cmd_code = GEN5_BL_CMD_INITIATE_BL;
+	/* 8 key bytes and 128 bytes block size */
+	put_unaligned_le16(cmd_data_len, &bl_packet_start->data_length);
+
+	cmd_data = (struct gen5_bl_initiate_cmd_data *)bl_cmd_head->data;
+	memcpy(cmd_data->key, cyapa_gen5_bl_cmd_key, CYAPA_TSG_BL_KEY_SIZE);
+
+	/* Copy 60 bytes Meta Data Row Parameters */
+	image = (struct cyapa_tsg_bin_image *)fw->data;
+	records_num = (fw->size - sizeof(struct cyapa_tsg_bin_image_head)) /
+				sizeof(struct cyapa_tsg_bin_image_data_record);
+	/* APP_INTEGRITY row is always the last row block */
+	data = image->records[records_num - 1].record_data;
+	memcpy(cmd_data->metadata_raw_parameter, data,
+		CYAPA_TSG_FLASH_MAP_METADATA_SIZE);
+
+	meta_data_crc = crc_itu_t(0xffff, cmd_data->metadata_raw_parameter,
+				CYAPA_TSG_FLASH_MAP_METADATA_SIZE);
+	put_unaligned_le16(meta_data_crc, &cmd_data->metadata_crc);
+
+	bl_packet_end = (struct gen5_bl_packet_end *)(bl_cmd_head->data +
+				cmd_data_len);
+	cmd_crc = crc_itu_t(0xffff, (u8 *)bl_packet_start,
+		sizeof(struct gen5_bl_packet_start) + cmd_data_len);
+	put_unaligned_le16(cmd_crc, &bl_packet_end->crc);
+	bl_packet_end->eop = GEN5_EOP_KEY;
+
+	resp_len = sizeof(resp_data);
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, cmd_len,
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
 static bool cyapa_gen5_sort_bl_exit_data(struct cyapa *cyapa, u8 *buf, int len)
 {
 	if (buf == NULL || len < GEN5_RESP_LENGTH_SIZE)
@@ -973,6 +1141,219 @@ static int cyapa_gen5_bl_exit(struct cyapa *cyapa)
 	return -ENODEV;
 }
 
+static int cyapa_gen5_bl_enter(struct cyapa *cyapa)
+{
+	u8 cmd[] = { 0x04, 0x00, 0x05, 0x00, 0x2F, 0x00, 0x01 };
+	u8 resp_data[2];
+	int resp_len;
+	int error;
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
+	/* Try to dump all buffered report data before any send command. */
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
+	cyapa->operational = false;
+	cyapa->state = CYAPA_STATE_GEN5_BL;
+	return 0;
+}
+
+static int cyapa_gen5_check_fw(struct cyapa *cyapa, const struct firmware *fw)
+{
+	struct device *dev = &cyapa->client->dev;
+	struct gen5_bl_metadata_row_params metadata;
+	struct cyapa_tsg_bin_image *image;
+	int flash_records_count;
+	u16 app_crc = 0;
+	u16 app_integrity_crc = 0;
+	u16 row_num;
+	u8 *data;
+	int record_index;
+	int i;
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
+	if (image->records[flash_records_count - 1].flash_array_id != 0x00 &&
+			row_num != 0x01ff) {
+		dev_err(dev, "%s: invalid app_integrity data.\n", __func__);
+		return -EINVAL;
+	}
+	data = image->records[flash_records_count - 1].record_data;
+
+	metadata.app_start = get_unaligned_le32(&data[4]);
+	metadata.app_len = get_unaligned_le16(&data[8]);
+	metadata.app_crc = get_unaligned_le16(&data[10]);
+	metadata.upgrade_start = get_unaligned_le32(&data[16]);
+	metadata.upgrade_len  = get_unaligned_le16(&data[20]);
+	metadata.metadata_crc = get_unaligned_le16(&data[60]);
+
+	if ((metadata.app_start + metadata.app_len +
+		metadata.upgrade_start + metadata.upgrade_len) %
+			CYAPA_TSG_FW_ROW_SIZE) {
+		dev_err(dev, "%s: invalid image alignment.\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Verify app_integrity crc */
+	app_integrity_crc = crc_itu_t(0xffff, data,
+			CYAPA_TSG_APP_INTEGRITY_SIZE);
+	if (app_integrity_crc != metadata.metadata_crc) {
+		dev_err(dev, "%s: invalid app_integrity crc.\n", __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * Verify application image CRC
+	 */
+	record_index = metadata.app_start / CYAPA_TSG_FW_ROW_SIZE -
+				CYAPA_TSG_IMG_START_ROW_NUM;
+	data = (u8 *)&image->records[record_index].record_data;
+	app_crc = crc_itu_t(0xffff, data, CYAPA_TSG_FW_ROW_SIZE);
+	for (i = 1; i < (metadata.app_len / CYAPA_TSG_FW_ROW_SIZE); i++) {
+		data = (u8 *)&image->records[++record_index].record_data;
+		app_crc = crc_itu_t(app_crc, data, CYAPA_TSG_FW_ROW_SIZE);
+	}
+
+	if (app_crc != metadata.app_crc) {
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
+	struct gen5_bl_cmd_head *bl_cmd_head;
+	struct gen5_bl_packet_start *bl_packet_start;
+	struct gen5_bl_flash_row_head *flash_row_head;
+	struct gen5_bl_packet_end *bl_packet_end;
+	u8 cmd[CYAPA_TSG_MAX_CMD_SIZE];
+	u16 cmd_len;
+	u8 flash_array_id;
+	u16 flash_row_id;
+	u16 record_len;
+	u8 *record_data;
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
+	memset(cmd, 0, CYAPA_TSG_MAX_CMD_SIZE);
+	bl_cmd_head = (struct gen5_bl_cmd_head *)cmd;
+	bl_packet_start = &bl_cmd_head->packet_start;
+	cmd_len = sizeof(struct gen5_bl_cmd_head) +
+		  sizeof(struct gen5_bl_flash_row_head) +
+		  CYAPA_TSG_FLASH_MAP_BLOCK_SIZE +
+		  sizeof(struct gen5_bl_packet_end);
+
+	put_unaligned_le16(GEN5_OUTPUT_REPORT_ADDR, &bl_cmd_head->addr);
+	/* Don't include 2 bytes register address */
+	put_unaligned_le16(cmd_len - 2, &bl_cmd_head->length);
+	bl_cmd_head->report_id = GEN5_BL_CMD_REPORT_ID;
+	bl_packet_start->sop = GEN5_SOP_KEY;
+	bl_packet_start->cmd_code = GEN5_BL_CMD_PROGRAM_VERIFY_ROW;
+
+	/* 1 (Flash Array ID) + 2 (Flash Row ID) + 128 (flash data) */
+	data_len = sizeof(struct gen5_bl_flash_row_head) + record_len;
+	put_unaligned_le16(data_len, &bl_packet_start->data_length);
+
+	flash_row_head = (struct gen5_bl_flash_row_head *)bl_cmd_head->data;
+	flash_row_head->flash_array_id = flash_array_id;
+	put_unaligned_le16(flash_row_id, &flash_row_head->flash_row_id);
+	memcpy(flash_row_head->flash_data, record_data, record_len);
+
+	bl_packet_end = (struct gen5_bl_packet_end *)(bl_cmd_head->data +
+						      data_len);
+	crc = crc_itu_t(0xffff, (u8 *)bl_packet_start,
+		sizeof(struct gen5_bl_packet_start) + data_len);
+	put_unaligned_le16(crc, &bl_packet_end->crc);
+	bl_packet_end->eop = GEN5_EOP_KEY;
+
+	resp_len = sizeof(resp_data);
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, cmd_len,
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
+	struct cyapa_tsg_bin_image_data_record *flash_record;
+	struct cyapa_tsg_bin_image *image =
+		(struct cyapa_tsg_bin_image *)fw->data;
+	int flash_records_count;
+	int i;
+	int error;
+
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	flash_records_count =
+		(fw->size - sizeof(struct cyapa_tsg_bin_image_head)) /
+			sizeof(struct cyapa_tsg_bin_image_data_record);
+	/*
+	 * The last flash row 0x01ff has been written through bl_initiate
+	 * command, so DO NOT write flash 0x01ff to trackpad device.
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
@@ -1665,7 +2046,17 @@ static int cyapa_gen5_irq_handler(struct cyapa *cyapa)
 	return 0;
 }
 
+static int cyapa_gen5_bl_activate(struct cyapa *cyapa) { return 0; }
+static int cyapa_gen5_bl_deactivate(struct cyapa *cyapa) { return 0; }
+
 const struct cyapa_dev_ops cyapa_gen5_ops = {
+	.check_fw = cyapa_gen5_check_fw,
+	.bl_enter = cyapa_gen5_bl_enter,
+	.bl_initiate = cyapa_gen5_bl_initiate,
+	.update_fw = cyapa_gen5_do_fw_update,
+	.bl_activate = cyapa_gen5_bl_activate,
+	.bl_deactivate = cyapa_gen5_bl_deactivate,
+
 	.initialize = cyapa_gen5_initialize,
 
 	.state_parse = cyapa_gen5_state_parse,
-- 
1.9.1

