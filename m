Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaF3GoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:44:24 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:33199
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbaF3GoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:44:21 -0400
From: Dudley Du <dudl@cypress.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "patrikf@google.com" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 7/14] input: cyapa: add gen3 trackpad device firmware
 update function supported
Thread-Topic: [PATCH v2 7/14] input: cyapa: add gen3 trackpad device
 firmware update function supported
Thread-Index: Ac+ULrYod+4tUSARSryZijF+C9qKJA==
Date: Mon, 30 Jun 2014 06:44:19 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902CA0@S04-MBX01-01.s04.local>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5U6iXuZ009590

Add firmware image update function supported for gen3 trackpad device,
which its function is supplied through cyapa core update_fw interface.
TEST=test on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index 5345a9e..a3e1e72 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -392,6 +392,78 @@ static int cyapa_gen3_state_parse(struct cyapa *cyapa, u8 *reg_data, int len)
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
+       int ret;
+
+       if (cyapa->input) {
+               cyapa_disable_irq(cyapa);
+               input_unregister_device(cyapa->input);
+               cyapa->input = NULL;
+       }
+
+       ret = cyapa_poll_state(cyapa, 500);
+       if (ret < 0)
+               return ret;
+       if (cyapa->state == CYAPA_STATE_BL_IDLE) {
+               /* Already in BL_IDLE. Skipping exit. */
+               return 0;
+       }
+
+       if (cyapa->state != CYAPA_STATE_OP)
+               return -EAGAIN;
+
+       cyapa->state = CYAPA_STATE_NO_DEVICE;
+       ret = cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET, 0x01);
+       if (ret < 0)
+               return -EIO;
+
+       usleep_range(25000, 50000);
+       ret = cyapa_poll_state(cyapa, 500);
+       if (ret < 0)
+               return ret;
+       if ((cyapa->state != CYAPA_STATE_BL_IDLE) ||
+               (cyapa->status[REG_BL_STATUS] & BL_STATUS_WATCHDOG))
+               return -EAGAIN;
+
+       return 0;
+}
+
+static int cyapa_gen3_bl_activate(struct cyapa *cyapa)
+{
+       int ret;
+
+       ret = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_activate),
+                                       bl_activate);
+       if (ret < 0)
+               return ret;
+
+       /* Wait for bootloader to activate; takes between 2 and 12 seconds */
+       msleep(2000);
+       ret = cyapa_poll_state(cyapa, 11000);
+       if (ret < 0)
+               return ret;
+       if (cyapa->state != CYAPA_STATE_BL_ACTIVE)
+               return -EAGAIN;
+
+       return 0;
+}
+
 static int cyapa_gen3_bl_deactivate(struct cyapa *cyapa)
 {
        int ret;
@@ -452,6 +524,206 @@ static int cyapa_gen3_bl_exit(struct cyapa *cyapa)
        return 0;
 }

+/* Used in gen3 bootloader commands. */
+static u16 cyapa_gen3_csum(const u8 *buf, size_t count)
+{
+       int i;
+       u16 csum = 0;
+
+       for (i = 0; i < count; i++)
+               csum += buf[i];
+
+       return csum;
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
+       struct device *dev = &cyapa->client->dev;
+       u16 csum;
+       u16 csum_expected;
+
+       /* Firmware must match exact 30848 bytes = 482 64-byte blocks. */
+       if (fw->size != CYAPA_FW_SIZE) {
+               dev_err(dev, "invalid firmware size = %zu, expected %u.\n",
+                       fw->size, CYAPA_FW_SIZE);
+               return -EINVAL;
+       }
+
+       /* Verify header block */
+       csum_expected = (fw->data[0] << 8) | fw->data[1];
+       csum = cyapa_gen3_csum(&fw->data[2], CYAPA_FW_HDR_SIZE - 2);
+       if (csum != csum_expected) {
+               dev_err(dev, "%s %04x, expected: %04x\n",
+                       "invalid firmware header checksum = ",
+                       csum, csum_expected);
+               return -EINVAL;
+       }
+
+       /* Verify firmware image */
+       csum_expected = (fw->data[CYAPA_FW_HDR_SIZE - 2] << 8) |
+                        fw->data[CYAPA_FW_HDR_SIZE - 1];
+       csum = cyapa_gen3_csum(&fw->data[CYAPA_FW_HDR_SIZE],
+                       CYAPA_FW_DATA_SIZE);
+       if (csum != csum_expected) {
+               dev_err(dev, "%s %04x, expected: %04x\n",
+                       "invalid firmware header checksum = ",
+                       csum, csum_expected);
+               return -EINVAL;
+       }
+       return 0;
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
+               const u8 *buf, size_t len)
+{
+       int ret;
+       size_t i;
+       unsigned char cmd[CYAPA_CMD_LEN + 1];
+       size_t cmd_len;
+
+       for (i = 0; i < len; i += CYAPA_CMD_LEN) {
+               const u8 *payload = &buf[i];
+               cmd_len = (len - i >= CYAPA_CMD_LEN) ? CYAPA_CMD_LEN : len - i;
+               cmd[0] = i;
+               memcpy(&cmd[1], payload, cmd_len);
+
+               ret = cyapa_i2c_reg_write_block(cyapa, 0, cmd_len + 1, cmd);
+               if (ret < 0)
+                       return ret;
+       }
+       return 0;
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
+               u16 block, const u8 *data)
+{
+       int ret;
+       u8 cmd[78];
+       u8 status[BL_STATUS_SIZE];
+       /* Programming for one block can take about 100ms. */
+       int tries = 11;
+       u8 bl_status, bl_error;
+
+       /* set write command and security key bytes. */
+       cmd[0] = 0xff;
+       cmd[1] = 0x39;
+       cmd[2] = 0x00;
+       cmd[3] = 0x01;
+       cmd[4] = 0x02;
+       cmd[5] = 0x03;
+       cmd[6] = 0x04;
+       cmd[7] = 0x05;
+       cmd[8] = 0x06;
+       cmd[9] = 0x07;
+       cmd[10] = block >> 8;
+       cmd[11] = block;
+       memcpy(&cmd[12], data, CYAPA_FW_BLOCK_SIZE);
+       cmd[76] = cyapa_gen3_csum(data, CYAPA_FW_BLOCK_SIZE);
+       cmd[77] = cyapa_gen3_csum(cmd, sizeof(cmd) - 1);
+
+       ret = cyapa_gen3_write_buffer(cyapa, cmd, sizeof(cmd));
+       if (ret)
+               return ret;
+
+       /* wait for write to finish */
+       do {
+               usleep_range(10000, 20000);
+
+               /* check block write command result status. */
+               ret = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET,
+                                              BL_STATUS_SIZE, status);
+               if (ret != BL_STATUS_SIZE)
+                       return (ret < 0) ? ret : -EIO;
+       } while ((status[1] & BL_STATUS_BUSY) && --tries);
+
+       /* ignore WATCHDOG bit and reserved bits. */
+       bl_status = status[1] & ~BL_STATUS_REV_MASK;
+       bl_error = status[2] & ~BL_ERROR_RESERVED;
+
+       if (status[1] & BL_STATUS_BUSY)
+               ret = -ETIMEDOUT;
+       else if (bl_status != BL_STATUS_RUNNING ||
+               bl_error != BL_ERROR_BOOTLOADING)
+               ret = -EIO;
+       else
+               ret = 0;
+
+       return ret;
+}
+
+static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
+               const struct firmware *fw)
+{
+       struct device *dev = &cyapa->client->dev;
+       int ret;
+       int i;
+
+       /* First write data, starting at byte 128  of fw->data */
+       for (i = 0; i < CYAPA_FW_DATA_BLOCK_COUNT; i++) {
+               size_t block = CYAPA_FW_DATA_BLOCK_START + i;
+               size_t addr = (i + CYAPA_FW_HDR_BLOCK_COUNT) *
+                               CYAPA_FW_BLOCK_SIZE;
+               const u8 *data = &fw->data[addr];
+               ret = cyapa_gen3_write_fw_block(cyapa, block, data);
+               if (ret) {
+                       dev_err(dev, "FW update aborted, %d\n", ret);
+                       return ret;
+               }
+       }
+
+       /* Then write checksum */
+       for (i = 0; i < CYAPA_FW_HDR_BLOCK_COUNT; i++) {
+               size_t block = CYAPA_FW_HDR_BLOCK_START + i;
+               size_t addr = i * CYAPA_FW_BLOCK_SIZE;
+               const u8 *data = &fw->data[addr];
+               ret = cyapa_gen3_write_fw_block(cyapa, block, data);
+               if (ret) {
+                       dev_err(dev, "FW update aborted, %d\n", ret);
+                       return ret;
+               }
+       }
+
+       return 0;
+}
+
 /*
  * cyapa_get_wait_time_for_pwr_cmd
  *
@@ -707,13 +979,13 @@ static void cyapa_gen3_irq_handler(struct cyapa *cyapa)


 const struct cyapa_dev_ops cyapa_gen3_ops = {
+       cyapa_gen3_check_fw,
+       cyapa_gen3_bl_enter,
+       cyapa_gen3_bl_activate,
        NULL,
+       cyapa_gen3_do_fw_update,
        NULL,
-       NULL,
-       NULL,
-       NULL,
-       NULL,
-       NULL,
+       cyapa_gen3_bl_deactivate,

        NULL,
        NULL,
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
