Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaKCIhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:37:15 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32975 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaKCIhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:37:11 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 16/18] input: cyapa: add gen5 trackpad device read firmware image function support
Date: Mon,  3 Nov 2014 16:33:08 +0800
Message-Id: <1415003590-30485-17-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003590-30485-1-git-send-email-dudl@cypress.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read firmware image function supported for gen5 trackpad device,
it can be used through debugfs read_fw interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa_gen5.c | 154 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index 7e7de12..35334dc 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -1213,6 +1213,153 @@ static int cyapa_gen5_write_fw_block(struct cyapa *cyapa,
 	return 0;
 }
 
+static int cyapa_gen5_read_fw_bytes(struct cyapa *cyapa, u16 row_num, u8 *data)
+{
+	int ret;
+	u8 cmd[16];
+	size_t cmd_len;
+	u8 resp_data[CYAPA_TSG_FW_ROW_SIZE / 2 + GEN5_MIN_BL_RESP_LENGTH];
+	int resp_len;
+	u16 offset;
+	u16 cmd_crc;
+	struct cyapa_tsg_bin_image_data_record *fw_img_record;
+
+	fw_img_record = (struct cyapa_tsg_bin_image_data_record *)data;
+
+	cmd[0] = 0x04;  /* Register address */
+	cmd[1] = 0x00;
+	cmd[2] = 0x0e;
+	cmd[3] = 0x00;
+	cmd[4] = 0x40;  /* Report id 40h */
+	cmd[5] = 0x00;
+	cmd[6] = GEN5_SOP_KEY;
+	cmd[7] = 0x3d;  /* Read application image command code */
+	cmd[8] = 0x03;
+	cmd[9] = 0x00;
+	offset = row_num * CYAPA_TSG_FW_ROW_SIZE -
+			CYAPA_TSG_START_OF_APPLICATION;
+	put_unaligned_le16(offset, &cmd[10]);
+	cmd[12] = CYAPA_TSG_IMG_READ_SIZE;
+	cmd_crc = crc_itu_t(0xffff, &cmd[6], 7);
+	put_unaligned_le16(cmd_crc, &cmd[13]);  /* CRC[15:0] */
+	cmd[15] = GEN5_EOP_KEY;  /* EOP = 17h */
+	cmd_len = 16;
+
+	resp_len = CYAPA_TSG_IMG_READ_SIZE + GEN5_MIN_BL_RESP_LENGTH;
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, cmd_len,
+			resp_data, &resp_len,
+			50, cyapa_gen5_sort_tsg_pip_bl_resp_data, true);
+	if (resp_len != (CYAPA_TSG_IMG_READ_SIZE + GEN5_MIN_BL_RESP_LENGTH) ||
+			ret || resp_data[2] != GEN5_BL_RESP_REPORT_ID ||
+			!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+		return (ret < 0) ? ret : -EAGAIN;
+
+	/* Copy first 64 bytes in the row. */
+	memcpy(&fw_img_record->record_data[0], &resp_data[8],
+			CYAPA_TSG_IMG_READ_SIZE);
+
+	if (row_num == CYAPA_TSG_IMG_APP_INTEGRITY_ROW_NUM) {
+		/* Last row's rest 64 bytes are bootloader metadata,
+		 * it's not allowed to be read out, will respond with error. */
+		memset(&fw_img_record->record_data[CYAPA_TSG_IMG_READ_SIZE],
+			0, CYAPA_TSG_IMG_READ_SIZE);
+		goto skip_last_row;
+	}
+
+	/* Read next 64 bytes in the row. */
+	offset = offset + CYAPA_TSG_IMG_READ_SIZE;
+	put_unaligned_le16(offset, &cmd[10]);
+	cmd_crc = crc_itu_t(0xffff, &cmd[6], 7);
+	put_unaligned_le16(cmd_crc, &cmd[13]);  /* CRC[15:0] */
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, cmd_len,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_bl_resp_data, true);
+	if (resp_len != (CYAPA_TSG_IMG_READ_SIZE + GEN5_MIN_BL_RESP_LENGTH) ||
+			ret || resp_data[2] != GEN5_BL_RESP_REPORT_ID ||
+			!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+		return (ret < 0) ? ret : -EAGAIN;
+
+	/* Copy last 64 bytes in the row. */
+	memcpy(&fw_img_record->record_data[CYAPA_TSG_IMG_READ_SIZE],
+		&resp_data[8], CYAPA_TSG_IMG_READ_SIZE);
+
+skip_last_row:
+	fw_img_record->flash_array_id = 0;
+	put_unaligned_be16(row_num, &fw_img_record->row_number);
+	put_unaligned_be16(CYAPA_TSG_FW_ROW_SIZE, &fw_img_record->record_len);
+
+	return 0;
+}
+
+static int cyapa_gen5_read_fw(struct cyapa *cyapa)
+{
+	int ret;
+	int fw_img_head_size;
+	int fw_img_record_size;
+	int fw_img_size;
+	int row_index;
+	int array_index;
+	u32 img_start;
+	u16 img_len;
+	u16 img_start_row;
+	u16 img_end_row;
+	struct cyapa_tsg_bin_image_data_record app_integrity;
+	u8 *record_data;
+
+	ret = cyapa_gen5_bl_enter(cyapa);
+	if (ret)
+		return ret;
+
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	fw_img_head_size = sizeof(struct cyapa_tsg_bin_image_head);
+	fw_img_record_size = sizeof(struct cyapa_tsg_bin_image_data_record);
+
+	/* Read app integrity block data. */
+	row_index = CYAPA_TSG_IMG_APP_INTEGRITY_ROW_NUM;
+	ret = cyapa_gen5_read_fw_bytes(cyapa, row_index, (u8 *)&app_integrity);
+	if (ret)
+		return ret;
+	img_start = get_unaligned_le32(&app_integrity.record_data[16]);
+	img_len = get_unaligned_le16(&app_integrity.record_data[20]);
+	if ((img_start + img_len) % CYAPA_TSG_FW_ROW_SIZE)
+		return -EINVAL;
+	img_start_row = img_start / CYAPA_TSG_FW_ROW_SIZE;
+	img_end_row = (img_start + img_len) / CYAPA_TSG_FW_ROW_SIZE - 1;
+
+	/* Allocate memory for image. */
+	fw_img_size = fw_img_head_size +
+			(img_end_row -  img_start_row + 2) * fw_img_record_size;
+	cyapa->fw_image = cyapa->fw_image ? cyapa->fw_image :
+		devm_kzalloc(&cyapa->client->dev, fw_img_size, GFP_KERNEL);
+	if (!cyapa->fw_image)
+			return -ENOMEM;
+
+	/* Set image head data. */
+	memcpy(cyapa->fw_image, &cyapa->fw_img_head, fw_img_head_size);
+
+	/* Read image blocks. */
+	for (row_index = img_start_row, array_index = 0;
+			row_index <= img_end_row;
+			row_index++, array_index++) {
+		record_data = &cyapa->fw_image[fw_img_head_size +
+				array_index * fw_img_record_size];
+		ret = cyapa_gen5_read_fw_bytes(cyapa, row_index, record_data);
+		if (ret)
+			return ret;
+	}
+
+	/* Append last app integrity block data. */
+	record_data = &cyapa->fw_image[fw_img_head_size +
+				array_index * fw_img_record_size];
+	memcpy(record_data, &app_integrity, fw_img_record_size);
+
+	cyapa->fw_image_size = fw_img_size;
+	return 0;
+}
+
 static int cyapa_gen5_do_fw_update(struct cyapa *cyapa,
 		const struct firmware *fw)
 {
@@ -2276,6 +2423,11 @@ static int cyapa_gen5_get_query_data(struct cyapa *cyapa)
 	if (ret || resp_len < sizeof(resp_data))
 		return ret;
 
+	cyapa->fw_img_head.head_size =
+		sizeof(struct cyapa_tsg_bin_image_head) - 1;
+	memcpy(&cyapa->fw_img_head.ttda_driver_major_version,
+		&resp_data[5], cyapa->fw_img_head.head_size);
+
 	product_family = get_unaligned_le16(&resp_data[7]);
 	if ((product_family & GEN5_PRODUCT_FAMILY_MASK) !=
 		GEN5_PRODUCT_FAMILY_TRACKPAD)
@@ -2609,6 +2761,8 @@ const struct cyapa_dev_ops cyapa_gen5_ops = {
 	.show_baseline = cyapa_gen5_show_baseline,
 	.calibrate_store = cyapa_gen5_do_calibrate,
 
+	.read_fw = cyapa_gen5_read_fw,
+
 	.initialize = cyapa_gen5_initialize,
 
 	.state_parse = cyapa_gen5_state_parse,
-- 
1.9.1

