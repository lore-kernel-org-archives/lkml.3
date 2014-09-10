Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaIJEmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:42:15 -0400
Received: from bay004-omc1s20.hotmail.com ([65.54.190.31]:52396 "EHLO
	BAY004-OMC1S20.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbaIJEjy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:39:54 -0400
X-TMN: [kcRwa6w0Re0ti/QdrLFfWEnKR/JegAfi]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS11ED7F5E647857D89A092CBDCF0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 13/13] input: cyapa: add gen5 trackpad device read firmware image and raw data functions support
Date: Wed, 10 Sep 2014 12:35:15 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/MsJ4g1gyllom0SjGe6F1U3vZF6Q==
Content-Language: zh-cn
X-OriginalArrivalTime: 10 Sep 2014 04:35:16.0831 (UTC) FILETIME=[9ED826F0:01CFCCB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read firmware image function supported for gen5 trackpad device,
which its function is supplied through cyapa core read_fw interface.
Through this interface, upper layer application can read out, check
and backup the firmware image in trackpad device before updated
with new one when new firmware image may have problems.
Also add interfaces to report all sensor's raw data values to upper
layer, so it can help to find out the performance issue when users
reports problem, and also it's useful and required interface for
some customers that require sensors' raw data.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa_gen5.c | 267 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 266 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index 452cb5d..e7f410d 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -1221,6 +1221,158 @@ static int cyapa_gen5_write_fw_block(struct cyapa *cyapa,
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
+			50, cyapa_gen5_sort_tsg_pip_bl_resp_data);
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
+			500, cyapa_gen5_sort_tsg_pip_bl_resp_data);
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
+		goto err;
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
+		goto err;
+	img_start = get_unaligned_le32(&app_integrity.record_data[16]);
+	img_len = get_unaligned_le16(&app_integrity.record_data[20]);
+	if ((img_start + img_len) % CYAPA_TSG_FW_ROW_SIZE)
+		goto err;
+	img_start_row = img_start / CYAPA_TSG_FW_ROW_SIZE;
+	img_end_row = (img_start + img_len) / CYAPA_TSG_FW_ROW_SIZE - 1;
+
+	/* Allocate memory for image. */
+	cyapa->fw_image_size = fw_img_head_size +
+		(img_end_row -  img_start_row + 2) * fw_img_record_size;
+	cyapa->fw_image = kmalloc(cyapa->fw_image_size, GFP_KERNEL);
+	if (!cyapa->fw_image) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Set image head data. */
+	memcpy(cyapa->fw_image, &gen5_fw_img_head, fw_img_head_size);
+
+	/* Read image blocks. */
+	for (row_index = img_start_row, array_index = 0;
+			row_index <= img_end_row;
+			row_index++, array_index++) {
+		record_data = &cyapa->fw_image[fw_img_head_size +
+				array_index * fw_img_record_size];
+		ret = cyapa_gen5_read_fw_bytes(cyapa, row_index, record_data);
+		if (ret)
+			goto err;
+	}
+
+	/* Append last app integrity block data. */
+	record_data = &cyapa->fw_image[fw_img_head_size +
+				array_index * fw_img_record_size];
+	memcpy(record_data, &app_integrity, fw_img_record_size);
+
+err:
+	if (ret) {
+		kfree(cyapa->fw_image);
+		cyapa->fw_image = NULL;
+		cyapa->fw_image_size = 0;
+	}
+	return ret;
+}
+
 static int cyapa_gen5_do_fw_update(struct cyapa *cyapa,
 		const struct firmware *fw)
 {
@@ -1493,7 +1645,7 @@ static int cyapa_gen5_set_power_mode(struct cyapa *cyapa,
 		ret = cyapa_gen5_change_power_state(cyapa,
 				GEN5_POWER_STATE_BTN_ONLY);
 		if (ret) {
-			dev_err(dev, "fail change to active, (%d)\n", ret);
+			dev_err(dev, "fail to button only mode, (%d)\n", ret);
 			return ret;
 		}
 
@@ -2207,6 +2359,116 @@ resume_scanning:
 	return ret + err;
 }
 
+static int cyapa_gen5_read_raw_data(struct cyapa *cyapa)
+{
+	int ret, err;
+	int raw_cap_mutual_max, raw_cap_mutual_min, raw_cap_mutual_ave;
+	int raw_cap_self_max, raw_cap_self_min, raw_cap_self_ave;
+	int offset;
+	int data_size, max, min, ave;
+	ktime_t time_mono;
+
+	offset = 0;
+	if (!cyapa->tp_raw_data) {
+		if (cyapa->state != CYAPA_STATE_GEN5_APP ||
+			!cyapa->electrodes_x || !cyapa->electrodes_y)
+			return  -EINVAL;
+
+		cyapa->tp_raw_data_size = sizeof(s32) * (cyapa->electrodes_x *
+			cyapa->electrodes_y + cyapa->electrodes_x +
+			cyapa->electrodes_y) + GEN5_RAW_DATA_HEAD_SIZE;
+		/*
+		 * This buffer will be hold after used until the driver is
+		 * unloaded, the purpose of it is to improve the performace
+		 * to avoid frequently allocate and release the buffer.
+		 */
+		cyapa->tp_raw_data =
+			kmalloc(cyapa->tp_raw_data_size, GFP_KERNEL);
+		if (!cyapa->tp_raw_data)
+			return -ENOMEM;
+		memset(cyapa->tp_raw_data, 0, cyapa->tp_raw_data_size);
+	}
+
+
+	/*
+	 * 1. Suspend Scanning.
+	 *
+	 * After suspend scanning, the raw data will not be updated,
+	 * so the time of the raw data is before scanning suspended.
+	 */
+	time_mono = ktime_get();
+	ret = cyapa_gen5_suspend_scanning(cyapa);
+	if (ret)
+		return ret;
+
+	/* 2. Get the correct electrodes_rx number. */
+	if (cyapa->electrodes_rx == 0) {
+		/*
+		 * Through the read global idac interface to get the Rx number.
+		 * this value is useful to the raw data map.
+		 */
+		data_size = 0;
+		err = cyapa_gen5_read_idac_data(cyapa,
+				GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+				GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+				&data_size, &max, &min, &ave);
+		if (err || cyapa->electrodes_rx == 0)
+			goto resume_scanning;
+	}
+
+	/* 3. Execuate panel scan. It must be executed before read data. */
+	err = cyapa_gen5_execute_panel_scan(cyapa);
+	if (err)
+		goto resume_scanning;
+
+	/* 4. Retrive panel scan, mutual cap raw data. */
+	offset = GEN5_RAW_DATA_HEAD_SIZE;
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_MUTUAL_DIFFCOUNT,
+				cyapa->electrodes_x * cyapa->electrodes_y,
+				&raw_cap_mutual_max, &raw_cap_mutual_min,
+				&raw_cap_mutual_ave,
+				cyapa->tp_raw_data + offset);
+	if (err)
+		goto resume_scanning;
+
+	offset += sizeof(s32) * cyapa->electrodes_x * cyapa->electrodes_y;
+
+	/* 5. Retrive panel scan, self cap raw data. */
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_SELF_DIFFCOUNT,
+				cyapa->electrodes_x + cyapa->electrodes_y,
+				&raw_cap_self_max, &raw_cap_self_min,
+				&raw_cap_self_ave,
+				cyapa->tp_raw_data + offset);
+	if (err)
+		goto resume_scanning;
+
+	offset += sizeof(s32) * (cyapa->electrodes_x + cyapa->electrodes_y);
+
+resume_scanning:
+	/* 6. Resume Scanning*/
+	ret = cyapa_gen5_resume_scanning(cyapa);
+	if (ret || err)
+		return ret ? ret : err;
+
+	*((struct timeval *)&cyapa->tp_raw_data[0]) =
+						ktime_to_timeval(time_mono);
+	cyapa->tp_raw_data[16] = (u8)cyapa->electrodes_x;
+	cyapa->tp_raw_data[17] = (u8)cyapa->electrodes_y;
+	cyapa->tp_raw_data[18] = (u8)cyapa->x_origin;
+	cyapa->tp_raw_data[19] = (u8)cyapa->y_origin;
+	cyapa->tp_raw_data[20] = (u8)sizeof(s32);
+	cyapa->tp_raw_data[21] = (u8)sizeof(s32);
+	cyapa->tp_raw_data[22] = (u8)cyapa->electrodes_rx;
+	cyapa->tp_raw_data[23] = 0;  /* Reserved. */
+
+	cyapa->tp_raw_data_size = offset;
+	return 0;
+}
+
 static bool cyapa_gen5_sort_system_info_data(struct cyapa *cyapa,
 		u8 *buf, int len)
 {
@@ -2611,6 +2873,9 @@ const struct cyapa_dev_ops cyapa_gen5_ops = {
 	.show_baseline = cyapa_gen5_show_baseline,
 	.calibrate_store = cyapa_gen5_do_calibrate,
 
+	.read_fw = cyapa_gen5_read_fw,
+	.read_raw_data = cyapa_gen5_read_raw_data,
+
 	.initialize = cyapa_gen5_initialize,
 	.uninitialize = cyapa_gen5_uninitialize,
 
-- 
1.9.1


