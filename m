Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbaISBrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:47:15 -0400
Received: from bay004-omc1s2.hotmail.com ([65.54.190.13]:56609 "EHLO
	BAY004-OMC1S2.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbaISBrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:47:12 -0400
X-TMN: [tEua/VFuV4e4tIGKa/fRdp6EY3Qlu906]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS10B4135D6C1B8D76A50F1BDB40@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 09/13] input: cyapa: add gen3 trackpad device read firmware image function support
Date: Fri, 19 Sep 2014 09:47:10 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/Tq6C0XeaiBP1TTL23JFntrYjT1Q==
Content-Language: zh-cn
X-OriginalArrivalTime: 19 Sep 2014 01:47:12.0097 (UTC) FILETIME=[A1979D10:01CFD3AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2d1596848fe879263ffeb39633ab3c7a985a704f Mon Sep 17 00:00:00 2001
From: Dudley Du <dudl@cypress.com>
Date: Thu, 18 Sep 2014 18:11:39 +0800
Subject: [PATCH 09/13] input: cyapa: add gen3 trackpad device read firmware
 image function support
To: dmitry.torokhov@gmail.com,
    rydberg@euromail.se
Cc: bleung@google.com,
    patrikf@google.com,
    linux-input@vger.kernel.org,
    linux-kernel@vger.kernel.org

Add read firmware image function supported for gen3 trackpad device,
which its function is supplied through cyapa core read_fw interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa_gen3.c | 73 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index 6a0e67a..20f93b0 100644
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
@@ -756,6 +786,47 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
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
+	cyapa->fw_image = kmalloc(CYAPA_FW_SIZE, GFP_KERNEL);
+	if (!cyapa->fw_image) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	for (addr = 0; addr < CYAPA_FW_SIZE; addr += CYAPA_FW_READ_SIZE) {
+		ret = cyapa_gen3_read_fw_bytes(cyapa, CYAPA_FW_HDR_START + addr,
+					  &cyapa->fw_image[addr]);
+		if (ret) {
+			kfree(cyapa->fw_image);
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
@@ -1202,6 +1273,8 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
 	.show_baseline = cyapa_gen3_show_baseline,
 	.calibrate_store = cyapa_gen3_do_calibrate,
 
+	.read_fw = cyapa_gen3_read_fw,
+
 	.state_parse = cyapa_gen3_state_parse,
 	.operational_check = cyapa_gen3_do_operational_check,
 
-- 
1.9.1


