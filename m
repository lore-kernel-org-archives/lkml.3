Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaFFH3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:29:08 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:30894
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaFFH3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:06 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C8D3S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 7/14] input: cyapa: add gen3 trackpad device firmware
 update function supported
Thread-Topic: [PATCH v2 7/14] input: cyapa: add gen3 trackpad device
 firmware update function supported
Thread-Index: Ac+BWOsRHtIOB2CmQvq8VdSIN31tSg==
Date: Fri, 6 Jun 2014 07:29:03 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C8D3@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C8D3@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8D3S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add firmware image update function supported for gen3 trackpad device,
which its function is supplied through cyapa core update_fw interface.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_g=
en3.c
index 5345a9e..a3e1e72 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -392,6 +392,78 @@ static int cyapa_gen3_state_parse(struct cyapa *cyapa,=
 u8 *reg_data, int len)
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
+ * re-register after it is detected following resumption of operational mo=
de.
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
+               cyapa->input =3D NULL;
+       }
+
+       ret =3D cyapa_poll_state(cyapa, 500);
+       if (ret < 0)
+               return ret;
+       if (cyapa->state =3D=3D CYAPA_STATE_BL_IDLE) {
+               /* Already in BL_IDLE. Skipping exit. */
+               return 0;
+       }
+
+       if (cyapa->state !=3D CYAPA_STATE_OP)
+               return -EAGAIN;
+
+       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+       ret =3D cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET, 0x01);
+       if (ret < 0)
+               return -EIO;
+
+       usleep_range(25000, 50000);
+       ret =3D cyapa_poll_state(cyapa, 500);
+       if (ret < 0)
+               return ret;
+       if ((cyapa->state !=3D CYAPA_STATE_BL_IDLE) ||
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
+       ret =3D cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_activate),
+                                       bl_activate);
+       if (ret < 0)
+               return ret;
+
+       /* Wait for bootloader to activate; takes between 2 and 12 seconds =
*/
+       msleep(2000);
+       ret =3D cyapa_poll_state(cyapa, 11000);
+       if (ret < 0)
+               return ret;
+       if (cyapa->state !=3D CYAPA_STATE_BL_ACTIVE)
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
+       u16 csum =3D 0;
+
+       for (i =3D 0; i < count; i++)
+               csum +=3D buf[i];
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
+ * The last two bytes of the header hold the firmware image checksum, comp=
uted
+ * by summing the 30720 bytes of the image modulo 0xffff.
+ *
+ * Both checksums are stored little-endian.
+ */
+static int cyapa_gen3_check_fw(struct cyapa *cyapa, const struct firmware =
*fw)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       u16 csum;
+       u16 csum_expected;
+
+       /* Firmware must match exact 30848 bytes =3D 482 64-byte blocks. */
+       if (fw->size !=3D CYAPA_FW_SIZE) {
+               dev_err(dev, "invalid firmware size =3D %zu, expected %u.\n=
",
+                       fw->size, CYAPA_FW_SIZE);
+               return -EINVAL;
+       }
+
+       /* Verify header block */
+       csum_expected =3D (fw->data[0] << 8) | fw->data[1];
+       csum =3D cyapa_gen3_csum(&fw->data[2], CYAPA_FW_HDR_SIZE - 2);
+       if (csum !=3D csum_expected) {
+               dev_err(dev, "%s %04x, expected: %04x\n",
+                       "invalid firmware header checksum =3D ",
+                       csum, csum_expected);
+               return -EINVAL;
+       }
+
+       /* Verify firmware image */
+       csum_expected =3D (fw->data[CYAPA_FW_HDR_SIZE - 2] << 8) |
+                        fw->data[CYAPA_FW_HDR_SIZE - 1];
+       csum =3D cyapa_gen3_csum(&fw->data[CYAPA_FW_HDR_SIZE],
+                       CYAPA_FW_DATA_SIZE);
+       if (csum !=3D csum_expected) {
+               dev_err(dev, "%s %04x, expected: %04x\n",
+                       "invalid firmware header checksum =3D ",
+                       csum, csum_expected);
+               return -EINVAL;
+       }
+       return 0;
+}
+
+/*
+ * Write a |len| byte long buffer |buf| to the device, by chopping it up i=
nto a
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
+       for (i =3D 0; i < len; i +=3D CYAPA_CMD_LEN) {
+               const u8 *payload =3D &buf[i];
+               cmd_len =3D (len - i >=3D CYAPA_CMD_LEN) ? CYAPA_CMD_LEN : =
len - i;
+               cmd[0] =3D i;
+               memcpy(&cmd[1], payload, cmd_len);
+
+               ret =3D cyapa_i2c_reg_write_block(cyapa, 0, cmd_len + 1, cm=
d);
+               if (ret < 0)
+                       return ret;
+       }
+       return 0;
+}
+
+/*
+ * A firmware block write command writes 64 bytes of data to a single flas=
h
+ * page in the device.  The 78-byte block write command has the format:
+ *   <0xff> <CMD> <Key> <Start> <Data> <Data-Checksum> <CMD Checksum>
+ *
+ *  <0xff>  - every command starts with 0xff
+ *  <CMD>   - the write command value is 0x39
+ *  <Key>   - write commands include an 8-byte key: { 00 01 02 03 04 05 06=
 07 }
+ *  <Block> - Memory Block number (address / 64) (16-bit, big-endian)
+ *  <Data>  - 64 bytes of firmware image data
+ *  <Data Checksum> - sum of 64 <Data> bytes, modulo 0xff
+ *  <CMD Checksum> - sum of 77 bytes, from 0xff to <Data Checksum>
+ *
+ * Each write command is split into 5 i2c write transactions of up to 16 b=
ytes.
+ * Each transaction starts with an i2c register offset: (00, 10, 20, 30, 4=
0).
+ */
+static int cyapa_gen3_write_fw_block(struct cyapa *cyapa,
+               u16 block, const u8 *data)
+{
+       int ret;
+       u8 cmd[78];
+       u8 status[BL_STATUS_SIZE];
+       /* Programming for one block can take about 100ms. */
+       int tries =3D 11;
+       u8 bl_status, bl_error;
+
+       /* set write command and security key bytes. */
+       cmd[0] =3D 0xff;
+       cmd[1] =3D 0x39;
+       cmd[2] =3D 0x00;
+       cmd[3] =3D 0x01;
+       cmd[4] =3D 0x02;
+       cmd[5] =3D 0x03;
+       cmd[6] =3D 0x04;
+       cmd[7] =3D 0x05;
+       cmd[8] =3D 0x06;
+       cmd[9] =3D 0x07;
+       cmd[10] =3D block >> 8;
+       cmd[11] =3D block;
+       memcpy(&cmd[12], data, CYAPA_FW_BLOCK_SIZE);
+       cmd[76] =3D cyapa_gen3_csum(data, CYAPA_FW_BLOCK_SIZE);
+       cmd[77] =3D cyapa_gen3_csum(cmd, sizeof(cmd) - 1);
+
+       ret =3D cyapa_gen3_write_buffer(cyapa, cmd, sizeof(cmd));
+       if (ret)
+               return ret;
+
+       /* wait for write to finish */
+       do {
+               usleep_range(10000, 20000);
+
+               /* check block write command result status. */
+               ret =3D cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET,
+                                              BL_STATUS_SIZE, status);
+               if (ret !=3D BL_STATUS_SIZE)
+                       return (ret < 0) ? ret : -EIO;
+       } while ((status[1] & BL_STATUS_BUSY) && --tries);
+
+       /* ignore WATCHDOG bit and reserved bits. */
+       bl_status =3D status[1] & ~BL_STATUS_REV_MASK;
+       bl_error =3D status[2] & ~BL_ERROR_RESERVED;
+
+       if (status[1] & BL_STATUS_BUSY)
+               ret =3D -ETIMEDOUT;
+       else if (bl_status !=3D BL_STATUS_RUNNING ||
+               bl_error !=3D BL_ERROR_BOOTLOADING)
+               ret =3D -EIO;
+       else
+               ret =3D 0;
+
+       return ret;
+}
+
+static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
+               const struct firmware *fw)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       int ret;
+       int i;
+
+       /* First write data, starting at byte 128  of fw->data */
+       for (i =3D 0; i < CYAPA_FW_DATA_BLOCK_COUNT; i++) {
+               size_t block =3D CYAPA_FW_DATA_BLOCK_START + i;
+               size_t addr =3D (i + CYAPA_FW_HDR_BLOCK_COUNT) *
+                               CYAPA_FW_BLOCK_SIZE;
+               const u8 *data =3D &fw->data[addr];
+               ret =3D cyapa_gen3_write_fw_block(cyapa, block, data);
+               if (ret) {
+                       dev_err(dev, "FW update aborted, %d\n", ret);
+                       return ret;
+               }
+       }
+
+       /* Then write checksum */
+       for (i =3D 0; i < CYAPA_FW_HDR_BLOCK_COUNT; i++) {
+               size_t block =3D CYAPA_FW_HDR_BLOCK_START + i;
+               size_t addr =3D i * CYAPA_FW_BLOCK_SIZE;
+               const u8 *data =3D &fw->data[addr];
+               ret =3D cyapa_gen3_write_fw_block(cyapa, block, data);
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
@@ -707,13 +979,13 @@ static void cyapa_gen3_irq_handler(struct cyapa *cyap=
a)


 const struct cyapa_dev_ops cyapa_gen3_ops =3D {
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
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8D3S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
HwABXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwD4PwEAAAAU
AAAARAB1AGQAbABlAHkAIABEAHUAAAAfACNAAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMA
cwAuAGMAbwBtAAAAAAAfACJAAQAAAAoAAABTAE0AVABQAAAAAAACAfk/AQAAAFgAAAAAAAAAgSsf
pL6jEBmdbgDdAQ9UAgAAAIBEAHUAZABsAGUAeQAgAEQAdQAAAFMATQBUAFAAAABkAHUAZABsAEAA
YwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAHwAJXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBz
AHMALgBjAG8AbQAAAAAAHwAxQAEAAAACAAAAAAAAAAsAQDoBAAAAHwAwQAEAAAACAAAAAAAAAB8A
GgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwQIAAALAEA6AQAAAAMA/T+oAwAAAgEL
MAEAAAAQAAAATM+RgDe4+kWUdGjfyiCClwMAFwABAAAAQAA5AIBJq/1Ygc8BQAAIMKHJKP5Ygc8B
CwApAAAAAAALACMAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABs
AGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAaAAAAegBoAC0AQwBOACwAIABlAG4ALQBVAFMAAAAAAAsA
AIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAAC0AAAAWwBQAEEAVABDAEgAIAB2
ADIAIAA3AC8AMQA0AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6ACAAYQBkAGQAIABnAGUA
bgAzACAAdAByAGEAYwBrAHAAYQBkACAAZABlAHYAaQBjAGUAIABmAGkAcgBtAHcAYQByAGUAIAB1
AHAAZABhAHQAZQAgAGYAdQBuAGMAdABpAG8AbgAgAHMAdQBwAHAAbwByAHQAZQBkAAAAHwA9AAEA
AAACAAAAAAAAAAMANgAAAAAAAgFxAAEAAAAWAAAAAc+BWOsRHtIOB2CmQvq8VdSIN31tSgAAHwBw
AAEAAAC0AAAAWwBQAEEAVABDAEgAIAB2ADIAIAA3AC8AMQA0AF0AIABpAG4AcAB1AHQAOgAgAGMA
eQBhAHAAYQA6ACAAYQBkAGQAIABnAGUAbgAzACAAdAByAGEAYwBrAHAAYQBkACAAZABlAHYAaQBj
AGUAIABmAGkAcgBtAHcAYQByAGUAIAB1AHAAZABhAHQAZQAgAGYAdQBuAGMAdABpAG8AbgAgAHMA
dQBwAHAAbwByAHQAZQBkAAAAHwA1EAEAAACEAAAAPAA3ADcAQgBDADcAMgA1AEMAOQAwADYAMgA3
ADYANABGADgANwA0AEQANwA5AEYANQAxAEUAMQBGADEAQQA4AEYANAA0ADAANgBDADgARAAzAEAA
UwAwADQALQBNAEIAWAAwADEALQAwADEALgBzADAANAAuAGwAbwBjAGEAbAA+AAAAAwDeP59OAAAL
AACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAGF
AAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEAAAAAAAADAIAQ/////wUAAIADIAYAAAAA
AMAAAAAAAABGAAAAAAKBAAAAAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAByBAAAAAAAA
QAAHMPFIoPtYgc8BCwACAAEAAAADACYAAAAAAAIBEDABAAAARgAAAAAAAACxH6E5MCBRRp20pXDe
0J/UBwB3vHJckGJ2T4dNefUeHxqPAAAAmTwbAAC6pz7uy9f3QKN27zX8YVmJABiD/MNMAAAAAB8A
+j8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAAwAJWQEAAAADAACACCAGAAAAAADAAAAAAAAA
RgAAAAAQhQAAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBzAGEA
dABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAC6AAAASQBJAD0AMAAx
AEMARgA4ADEANQA4AEUAQgAxADEAMQBFAEQAMgAwAEUAMAA3ADYAMABBADYANAAyAEYAQQBCAEMA
NQA1AEQANAA4ADgAMwA3ADcARAA2AEQANABBADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMAaQBv
AG4AIAAxADQALgAzACAAKABCAHUAaQBsAGQAIAAxADcANAAuADAAKQAsACAAUwB0AGEAZwBlAD0A
SAA0AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAATgQAAAQAAAAMAAIADIAYAAAAAAMAAAAAA
AABGAAAAACOBAAD///9/AwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEIEAAAAAAAADAACAAyAGAAAA
AADAAAAAAAAARgAAAAARgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACSBAAAAAAAACwAA
gAMgBgAAAAAAwAAAAAAAAEYAAAAALIEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAApgQAA
AAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACqBAAAAAAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYA
AAAAJ4EAAAEAAAACAAAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABKBAAABAAAAHwAAgAMg
BgAAAAAAwAAAAAAAAEYAAAAAIYEAAAEAAAACAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAA
AAOBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJoEAAAAAAAALAACACCAGAAAAAADAAAAA
AAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAACwAAgAggBgAA
AAAAwAAAAAAAAEYAAAAAgoUAAAAAAAADAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAA
AAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAA
AMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAA
HgAAAFsAMQAwAC4AMwAwAC4AMQAyAC4AMQA0ADYAXQAAAAAAA60=

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8D3S04MBX0101s04lo_--
