Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbbAVGv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:51:27 -0500
Received: from smtp1.cypress.com ([157.95.67.100]:52679 "EHLO
	smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbAVGvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:51:00 -0500
From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, jmmahler@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com, dan.carpenter@oracle.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect type in assiggment
Date: Thu, 22 Jan 2015 14:50:05 +0800
Message-Id: <1421909406-1240-1-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the sparse warning issue of the incorrect type in assignment which
found by the kbuild test robot.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa_gen5.c | 80 ++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index ced2a2c..69d9059 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -319,7 +319,7 @@ struct gen5_bl_initiate_cmd_data {
 
 struct gen5_bl_metadata_row_params {
 	__le16 size;
-	__le16 maximun_size;
+	__le16 maximum_size;
 	__le32 app_start;
 	__le16 app_len;
 	__le16 app_crc;
@@ -1192,67 +1192,69 @@ static int cyapa_gen5_bl_enter(struct cyapa *cyapa)
 static int cyapa_gen5_check_fw(struct cyapa *cyapa, const struct firmware *fw)
 {
 	struct device *dev = &cyapa->client->dev;
-	struct gen5_bl_metadata_row_params metadata;
-	struct cyapa_tsg_bin_image *image;
-	int flash_records_count;
-	u16 app_crc = 0;
-	u16 app_integrity_crc = 0;
-	u16 row_num;
-	u8 *data;
+	const struct cyapa_tsg_bin_image *image = (const void *)fw->data;
+	const struct cyapa_tsg_bin_image_data_record *app_integrity;
+	const struct gen5_bl_metadata_row_params *metadata;
+	size_t flash_records_count;
+	u32 fw_app_start, fw_upgrade_start;
+	u16 fw_app_len, fw_upgrade_len;
+	u16 app_crc;
+	u16 app_integrity_crc;
 	int record_index;
 	int i;
 
-	image = (struct cyapa_tsg_bin_image *)fw->data;
 	flash_records_count = (fw->size -
 			sizeof(struct cyapa_tsg_bin_image_head)) /
 			sizeof(struct cyapa_tsg_bin_image_data_record);
 
-	/* APP_INTEGRITY row is always the last row block,
-	 * and the row id must be 0x01ff */
-	row_num = get_unaligned_be16(
-			&image->records[flash_records_count - 1].row_number);
-	if (image->records[flash_records_count - 1].flash_array_id != 0x00 &&
-			row_num != 0x01ff) {
+	/*
+	 * APP_INTEGRITY row is always the last row block,
+	 * and the row id must be 0x01ff.
+	 */
+	app_integrity = &image->records[flash_records_count - 1];
+
+	if (app_integrity->flash_array_id != 0x00 ||
+	    get_unaligned_be16(&app_integrity->row_number) != 0x01ff) {
 		dev_err(dev, "%s: invalid app_integrity data.\n", __func__);
 		return -EINVAL;
 	}
-	data = image->records[flash_records_count - 1].record_data;
-
-	metadata.app_start = get_unaligned_le32(&data[4]);
-	metadata.app_len = get_unaligned_le16(&data[8]);
-	metadata.app_crc = get_unaligned_le16(&data[10]);
-	metadata.upgrade_start = get_unaligned_le32(&data[16]);
-	metadata.upgrade_len  = get_unaligned_le16(&data[20]);
-	metadata.metadata_crc = get_unaligned_le16(&data[60]);
-
-	if ((metadata.app_start + metadata.app_len +
-		metadata.upgrade_start + metadata.upgrade_len) %
-			CYAPA_TSG_FW_ROW_SIZE) {
-		dev_err(dev, "%s: invalid image alignment.\n", __func__);
-		return -EINVAL;
-	}
+
+	metadata = (const void *)app_integrity->record_data;
 
 	/* Verify app_integrity crc */
-	app_integrity_crc = crc_itu_t(0xffff, data,
-			CYAPA_TSG_APP_INTEGRITY_SIZE);
-	if (app_integrity_crc != metadata.metadata_crc) {
+	app_integrity_crc = crc_itu_t(0xffff, app_integrity->record_data,
+				      CYAPA_TSG_APP_INTEGRITY_SIZE);
+	if (app_integrity_crc != get_unaligned_le16(&metadata->metadata_crc)) {
 		dev_err(dev, "%s: invalid app_integrity crc.\n", __func__);
 		return -EINVAL;
 	}
 
+	fw_app_start = get_unaligned_le32(&metadata->app_start);
+	fw_app_len = get_unaligned_le16(&metadata->app_len);
+	fw_upgrade_start = get_unaligned_le32(&metadata->upgrade_start);
+	fw_upgrade_len = get_unaligned_le16(&metadata->upgrade_len);
+
+	if (fw_app_start % CYAPA_TSG_FW_ROW_SIZE ||
+	    fw_app_len % CYAPA_TSG_FW_ROW_SIZE ||
+	    fw_upgrade_start % CYAPA_TSG_FW_ROW_SIZE ||
+	    fw_upgrade_len % CYAPA_TSG_FW_ROW_SIZE) {
+		dev_err(dev, "%s: invalid image alignment.\n", __func__);
+		return -EINVAL;
+	}
+
 	/*
 	 * Verify application image CRC
 	 */
-	record_index = metadata.app_start / CYAPA_TSG_FW_ROW_SIZE -
+	record_index = fw_app_start / CYAPA_TSG_FW_ROW_SIZE -
 				CYAPA_TSG_IMG_START_ROW_NUM;
-	data = (u8 *)&image->records[record_index].record_data;
-	app_crc = crc_itu_t(0xffff, data, CYAPA_TSG_FW_ROW_SIZE);
-	for (i = 1; i < (metadata.app_len / CYAPA_TSG_FW_ROW_SIZE); i++) {
-		data = (u8 *)&image->records[++record_index].record_data;
+	app_crc = 0xffffU;
+	for (i = 0; i < fw_app_len / CYAPA_TSG_FW_ROW_SIZE; i++) {
+		const u8 *data = image->records[record_index + i].record_data;
+
 		app_crc = crc_itu_t(app_crc, data, CYAPA_TSG_FW_ROW_SIZE);
 	}
 
-	if (app_crc != metadata.app_crc) {
+	if (app_crc != get_unaligned_le16(&metadata->app_crc)) {
 		dev_err(dev, "%s: invalid firmware app crc check.\n", __func__);
 		return -EINVAL;
 	}
-- 
1.9.1

