Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaF3Gol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:44:41 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:33234
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311AbaF3Goi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:44:38 -0400
From: Dudley Du <dudl@cypress.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "patrikf@google.com" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 9/14] input: cyapa: add gen3 trackpad device read
 firmware image function supported
Thread-Topic: [PATCH v2 9/14] input: cyapa: add gen3 trackpad device read
 firmware image function supported
Thread-Index: Ac+ULsHNljiGOMr2SyG6XE5ZqaZcYw==
Date: Mon, 30 Jun 2014 06:44:37 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902CB2@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.30.12.155]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5U6iljc009598

Add read firmware image function supported for gen3 trackpad device,
which its function is supplied through cyapa core read_fw interface.
TEST=test on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index 9ffdbc1..e903e62 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -689,6 +689,35 @@ static int cyapa_gen3_write_fw_block(struct cyapa *cyapa,
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
+       int ret;
+       u8 cmd[] = { 0xff, 0x3c, 0, 1, 2, 3, 4, 5, 6, 7, addr >> 8, addr };
+
+       ret = cyapa_gen3_write_buffer(cyapa, cmd, sizeof(cmd));
+       if (ret)
+               return ret;
+
+       /* read data buffer starting from offset 16 */
+       ret = cyapa_i2c_reg_read_block(cyapa, 16, CYAPA_FW_READ_SIZE, data);
+       if (ret != CYAPA_FW_READ_SIZE)
+               return (ret < 0) ? ret : -EIO;
+
+       return 0;
+}
+
 static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
                const struct firmware *fw)
 {
@@ -724,6 +753,47 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
        return 0;
 }

+/*
+ * Read the entire firmware image into ->read_fw_image.
+ * If the ->read_fw_image has already been allocated, then this function
+ * doesn't do anything and just returns 0.
+ * If an error occurs while reading the image, ->read_fw_image is freed, and
+ * the error is returned.
+ *
+ * The firmware is a fixed size (CYAPA_FW_SIZE), and is read out in
+ * fixed length (CYAPA_FW_READ_SIZE) chunks.
+ */
+static int cyapa_gen3_read_fw(struct cyapa *cyapa)
+{
+       int ret;
+       int addr;
+
+       ret = cyapa_gen3_bl_enter(cyapa);
+       if (ret)
+               goto err;
+
+       cyapa->read_fw_image = kmalloc(CYAPA_FW_SIZE, GFP_KERNEL);
+       if (!cyapa->read_fw_image) {
+               ret = -ENOMEM;
+               goto err;
+       }
+
+       for (addr = 0; addr < CYAPA_FW_SIZE; addr += CYAPA_FW_READ_SIZE) {
+               ret = cyapa_gen3_read_fw_bytes(cyapa, CYAPA_FW_HDR_START + addr,
+                                         &cyapa->read_fw_image[addr]);
+               if (ret) {
+                       kfree(cyapa->read_fw_image);
+                       cyapa->read_fw_image = NULL;
+                       break;
+               }
+       }
+
+err:
+       if (cyapa->read_fw_image)
+               cyapa->read_fw_image_size = CYAPA_FW_SIZE;
+       return ret;
+}
+
 static ssize_t cyapa_gen3_do_calibrate(struct device *dev,
                                     struct device_attribute *attr,
                                     const char *buf, size_t count)
@@ -1122,7 +1192,7 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
        cyapa_gen3_show_baseline,
        cyapa_gen3_do_calibrate,

-       NULL,
+       cyapa_gen3_read_fw,
        NULL,

        NULL,
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
