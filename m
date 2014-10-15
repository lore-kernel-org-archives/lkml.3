Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaJOHVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:21:40 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58737 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaJOHVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:21:35 -0400
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com, patrikf@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] input: cyapa: add gen3 trackpad device read firmware image function support
Date: Wed, 15 Oct 2014 15:19:23 +0800
Message-Id: <1413357567-26177-10-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413357567-26177-1-git-send-email-dudl@cypress.com>
References: <1413357567-26177-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read firmware image function supported for gen3 trackpad device,
which its function is supplied through cyapa core read_fw interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa_gen3.c | 74 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index c92da08..1f862d3 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -710,6 +710,36 @@ static int cyapa_gen3_write_fw_block(struct cyapa *cyapa,
 	return ret;
 }
 
+/*
+ * A firmware block read command reads 16 bytes of data from flash starting
+ * from a given address.  The 12-byte block read command has the format:
+ *   <0xff> <CMD> <Key> <Addr>
+ *
+ *  <0xff>  - every command starts with 0xff
+ *  <CMD>   - the read command value is 0x3c
+ *  <Key>   - read commands include an 8-byte key: { 00 01 02 03 04 05 06 07 }
+ *  <Addr>  - Memory address (16-bit, big-endian)
+ *
+ * The command is followed by an i2c block read to read the 16 bytes of data.
+ */
+static int cyapa_gen3_read_fw_bytes(struct cyapa *cyapa, u16 addr, u8 *data)
+{
+	int ret;
+	u8 cmd[] = { 0xff, 0x3c, 0x00, 0x01, 0x02, 0x03, 0x04,
+		0x05, 0x06, 0x07, addr >> 8, addr };
+
+	ret = cyapa_gen3_write_buffer(cyapa, cmd, sizeof(cmd));
+	if (ret)
+		return ret;
+
+	/* Read data buffer starting from offset 16 */
+	ret = cyapa_i2c_reg_read_block(cyapa, 16, CYAPA_FW_READ_SIZE, data);
+	if (ret != CYAPA_FW_READ_SIZE)
+		return (ret < 0) ? ret : -EIO;
+
+	return 0;
+}
+
 static int cyapa_gen3_write_blocks(struct cyapa *cyapa,
 		size_t start_block, size_t block_count,
 		const u8 *image_data)
@@ -756,6 +786,48 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
 	return 0;
 }
 
+/*
+ * Read the entire firmware image into ->fw_image.
+ * If the ->fw_image has already been allocated, then this function
+ * doesn't do anything and just returns 0.
+ * If an error occurs while reading the image, ->fw_image is freed, and
+ * the error is returned.
+ *
+ * The firmware is a fixed size (CYAPA_FW_SIZE), and is read out in
+ * fixed length (CYAPA_FW_READ_SIZE) chunks.
+ */
+static int cyapa_gen3_read_fw(struct cyapa *cyapa)
+{
+	int ret;
+	int addr;
+
+	ret = cyapa_gen3_bl_enter(cyapa);
+	if (ret)
+		goto err;
+
+	cyapa->fw_image = devm_kzalloc(&cyapa->client->dev,
+					CYAPA_FW_SIZE, GFP_KERNEL);
+	if (!cyapa->fw_image) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	for (addr = 0; addr < CYAPA_FW_SIZE; addr += CYAPA_FW_READ_SIZE) {
+		ret = cyapa_gen3_read_fw_bytes(cyapa, CYAPA_FW_HDR_START + addr,
+					  &cyapa->fw_image[addr]);
+		if (ret) {
+			devm_kfree(&cyapa->client->dev, cyapa->fw_image);
+			cyapa->fw_image = NULL;
+			break;
+		}
+	}
+
+err:
+	if (cyapa->fw_image)
+		cyapa->fw_image_size = CYAPA_FW_SIZE;
+	return ret;
+}
+
 static ssize_t cyapa_gen3_do_calibrate(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
@@ -1206,6 +1278,8 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
 	.show_baseline = cyapa_gen3_show_baseline,
 	.calibrate_store = cyapa_gen3_do_calibrate,
 
+	.read_fw = cyapa_gen3_read_fw,
+
 	.state_parse = cyapa_gen3_state_parse,
 	.operational_check = cyapa_gen3_do_operational_check,
 
-- 
1.9.1

