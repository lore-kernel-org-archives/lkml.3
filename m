Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaDPIkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:40:47 -0400
Received: from relay-s04-hub003.domainlocalhost.com ([74.115.207.102]:11388
	"EHLO relay-S04-HUB003.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbaDPIkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:40:41 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F40C140ADS04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "David Solda" <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] input: cyapa: add sysfs interfaces supported for gen3
 trackpad device
Thread-Topic: [PATCH 5/6] input: cyapa: add sysfs interfaces supported for
 gen3 trackpad device
Thread-Index: Ac9Xtr6qnuz/5hn7T2ugu4efqp6zCABmKkyA
Date: Wed, 16 Apr 2014 08:40:39 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C140AD@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F40C140AD@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.153]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F40C140ADS04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add sysfs interfaces for gen3 trackpad devices that required in production,
including read and update firmware image, report baselines, sensors calibra=
te,
read product id, read firmware version.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index da03427..66cb5cc 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -15,6 +15,7 @@
  */

 #include <linux/async.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
@@ -29,6 +30,7 @@
 #include <linux/unaligned/access_ok.h>
 #include <linux/pm_runtime.h>

+
 /* APA trackpad firmware generation */
 #define CYAPA_GEN_UNKNOWN   0x00   /* unknown protocol. */
 #define CYAPA_GEN3   0x03   /* support MT-protocol B with tracking ID. */
@@ -50,6 +52,8 @@
 #define CYAPA_CMD_BL_ALL           0x0a
 #define CYAPA_CMD_BLK_PRODUCT_ID   0x0b
 #define CYAPA_CMD_BLK_HEAD         0x0c
+#define CYAPA_CMD_MAX_BASELINE     0x0d
+#define CYAPA_CMD_MIN_BASELINE     0x0e

 /* report data start reg offset address. */
 #define DATA_REG_START_OFFSET  0x0000
@@ -150,6 +154,10 @@
                              CAPABILITY_MIDDLE_BTN_MASK)

 #define CYAPA_OFFSET_SOFT_RESET  REG_OFFSET_COMMAND_BASE
+#define OP_RECALIBRATION_MASK    0x80
+#define OP_REPORT_BASELINE_MASK  0x40
+#define REG_OFFSET_MAX_BASELINE  0x0026
+#define REG_OFFSET_MIN_BASELINE  0x0027

 #define REG_OFFSET_POWER_MODE (REG_OFFSET_COMMAND_BASE + 1)
 #define SET_POWER_MODE_DELAY   10000  /* unit: us */
@@ -493,6 +501,7 @@ struct cyapa_tsg_bin_image {
 /* The main device structure */
 struct cyapa {
        enum cyapa_state state;
+       u8 status[BL_STATUS_SIZE];

        struct i2c_client *client;
        struct input_dev *input;
@@ -569,13 +578,29 @@ struct cyapa {
        bl_read_fw_func cyapa_read_fw;
        read_raw_data_func cyapa_read_raw_data;

+       size_t read_fw_image_size;
+       size_t tp_raw_data_size;
        struct cyapa_tsg_bin_image_head fw_img_head;
+
+       struct mutex debugfs_mutex;
+
+       /* per-instance debugfs root */
+       struct dentry *dentry_dev;
+
+       /* Buffer to store firmware read using debugfs */
+       u8 *read_fw_image;
+       /* Buffer to store sensors' raw data */
+       u8 *tp_raw_data;
 };

+static const u8 bl_activate[] =3D { 0x00, 0xff, 0x38, 0x00, 0x01, 0x02, 0x=
03,
+               0x04, 0x05, 0x06, 0x07 };
 static const u8 bl_deactivate[] =3D { 0x00, 0xff, 0x3b, 0x00, 0x01, 0x02, =
0x03,
                0x04, 0x05, 0x06, 0x07 };
 static const u8 bl_exit[] =3D { 0x00, 0xff, 0xa5, 0x00, 0x01, 0x02, 0x03, =
0x04,
                0x05, 0x06, 0x07 };
+/* global root node of the cyapa debugfs directory. */
+static struct dentry *cyapa_debugfs_root;

 struct cyapa_cmd_len {
        u8 cmd;
@@ -601,10 +626,14 @@ struct cyapa_cmd_len {
 #define CMD_RESET 0
 #define CMD_POWER_MODE 1
 #define CMD_DEV_STATUS 2
+#define CMD_REPORT_MAX_BASELINE 3
+#define CMD_REPORT_MIN_BASELINE 4
 #define SMBUS_BYTE_CMD(cmd) (((cmd) & 0x3f) << 1)
 #define CYAPA_SMBUS_RESET SMBUS_BYTE_CMD(CMD_RESET)
 #define CYAPA_SMBUS_POWER_MODE SMBUS_BYTE_CMD(CMD_POWER_MODE)
 #define CYAPA_SMBUS_DEV_STATUS SMBUS_BYTE_CMD(CMD_DEV_STATUS)
+#define CYAPA_SMBUS_MAX_BASELINE SMBUS_BYTE_CMD(CMD_REPORT_MAX_BASELINE)
+#define CYAPA_SMBUS_MIN_BASELINE SMBUS_BYTE_CMD(CMD_REPORT_MIN_BASELINE)

  /* for group registers read/write command */
 #define REG_GROUP_DATA 0
@@ -649,7 +678,9 @@ static const struct cyapa_cmd_len cyapa_i2c_cmds[] =3D =
{
        { BL_DATA_OFFSET, 16 },
        { BL_HEAD_OFFSET, 32 },
        { REG_OFFSET_QUERY_BASE, PRODUCT_ID_SIZE },
-       { REG_OFFSET_DATA_BASE, 32 }
+       { REG_OFFSET_DATA_BASE, 32 },
+       { REG_OFFSET_MAX_BASELINE, 1 },
+       { REG_OFFSET_MIN_BASELINE, 1 },
 };

 static const struct cyapa_cmd_len cyapa_smbus_cmds[] =3D {
@@ -666,10 +697,30 @@ static const struct cyapa_cmd_len cyapa_smbus_cmds[] =
=3D {
        { CYAPA_SMBUS_BL_ALL, 32 },
        { CYAPA_SMBUS_BLK_PRODUCT_ID, PRODUCT_ID_SIZE },
        { CYAPA_SMBUS_BLK_HEAD, 16 },
+       { CYAPA_SMBUS_MAX_BASELINE, 1 },
+       { CYAPA_SMBUS_MIN_BASELINE, 1 },
 };

 static const char unique_str[] =3D "CYTRA";

+#define CYAPA_DEBUGFS_READ_FW  "read_fw"
+#define CYAPA_DEBUGFS_RAW_DATA "raw_data"
+#define CYAPA_FW_NAME          "cyapa.bin"
+#define CYAPA_FW_BLOCK_SIZE    64
+#define CYAPA_FW_READ_SIZE     16
+#define CYAPA_FW_HDR_START     0x0780
+#define CYAPA_FW_HDR_BLOCK_COUNT  2
+#define CYAPA_FW_HDR_BLOCK_START  (CYAPA_FW_HDR_START / CYAPA_FW_BLOCK_SIZ=
E)
+#define CYAPA_FW_HDR_SIZE      (CYAPA_FW_HDR_BLOCK_COUNT * \
+                                CYAPA_FW_BLOCK_SIZE)
+#define CYAPA_FW_DATA_START    0x0800
+#define CYAPA_FW_DATA_BLOCK_COUNT  480
+#define CYAPA_FW_DATA_BLOCK_START  (CYAPA_FW_DATA_START / CYAPA_FW_BLOCK_S=
IZE)
+#define CYAPA_FW_DATA_SIZE     (CYAPA_FW_DATA_BLOCK_COUNT * \
+                                CYAPA_FW_BLOCK_SIZE)
+#define CYAPA_FW_SIZE          (CYAPA_FW_HDR_SIZE + CYAPA_FW_DATA_SIZE)
+#define CYAPA_CMD_LEN          16
+
 static int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout);
 static void cyapa_detect(struct cyapa *cyapa);
 static void cyapa_detect_async(void *data, async_cookie_t cookie);
@@ -890,6 +941,78 @@ static int cyapa_gen3_state_parse(struct cyapa *cyapa,=
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
@@ -950,6 +1073,412 @@ static int cyapa_gen3_bl_exit(struct cyapa *cyapa)
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
+/*
+ * A firmware block read command reads 16 bytes of data from flash startin=
g
+ * from a given address.  The 12-byte block read command has the format:
+ *   <0xff> <CMD> <Key> <Addr>
+ *
+ *  <0xff>  - every command starts with 0xff
+ *  <CMD>   - the read command value is 0x3c
+ *  <Key>   - read commands include an 8-byte key: { 00 01 02 03 04 05 06 =
07 }
+ *  <Addr>  - Memory address (16-bit, big-endian)
+ *
+ * The command is followed by an i2c block read to read the 16 bytes of da=
ta.
+ */
+static int cyapa_gen3_read_fw_bytes(struct cyapa *cyapa, u16 addr, u8 *dat=
a)
+{
+       int ret;
+       u8 cmd[] =3D { 0xff, 0x3c, 0, 1, 2, 3, 4, 5, 6, 7, addr >> 8, addr =
};
+
+       ret =3D cyapa_gen3_write_buffer(cyapa, cmd, sizeof(cmd));
+       if (ret)
+               return ret;
+
+       /* read data buffer starting from offset 16 */
+       ret =3D cyapa_i2c_reg_read_block(cyapa, 16, CYAPA_FW_READ_SIZE, dat=
a);
+       if (ret !=3D CYAPA_FW_READ_SIZE)
+               return (ret < 0) ? ret : -EIO;
+
+       return 0;
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
+/*
+ * Read the entire firmware image into ->read_fw_image.
+ * If the ->read_fw_image has already been allocated, then this function
+ * doesn't do anything and just returns 0.
+ * If an error occurs while reading the image, ->read_fw_image is freed, a=
nd
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
+       if (cyapa->read_fw_image)
+               return 0;
+
+       ret =3D cyapa_gen3_bl_enter(cyapa);
+       if (ret)
+               goto err_detect;
+
+       cyapa->read_fw_image =3D kmalloc(CYAPA_FW_SIZE, GFP_KERNEL);
+       if (!cyapa->read_fw_image) {
+               ret =3D -ENOMEM;
+               goto err_detect;
+       }
+
+       for (addr =3D 0; addr < CYAPA_FW_SIZE; addr +=3D CYAPA_FW_READ_SIZE=
) {
+               ret =3D cyapa_gen3_read_fw_bytes(cyapa, CYAPA_FW_HDR_START =
+ addr,
+                                         &cyapa->read_fw_image[addr]);
+               if (ret) {
+                       kfree(cyapa->read_fw_image);
+                       cyapa->read_fw_image =3D NULL;
+                       break;
+               }
+       }
+
+err_detect:
+       if (cyapa->read_fw_image)
+               cyapa->read_fw_image_size =3D CYAPA_FW_SIZE;
+       cyapa_detect_async(cyapa, 0);
+       return ret;
+}
+
+static ssize_t cyapa_gen3_do_calibrate(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       int tries =3D 20;  /* max recalibration timeout 2s. */
+       int ret;
+
+       cyapa_disable_irq(cyapa);
+
+       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+       if (ret < 0) {
+               dev_err(dev, "Error reading dev status. err =3D %d\n", ret)=
;
+               goto out;
+       }
+       if ((ret & CYAPA_DEV_NORMAL) !=3D CYAPA_DEV_NORMAL) {
+               dev_warn(dev, "Trackpad device is busy. device state =3D 0x=
%x\n",
+                        ret);
+               ret =3D -EAGAIN;
+               goto out;
+       }
+
+       ret =3D cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
+                              OP_RECALIBRATION_MASK);
+       if (ret < 0) {
+               dev_err(dev, "Failed to send calibrate command. ret =3D %d\=
n",
+                       ret);
+               goto out;
+       }
+
+       do {
+               /*
+                * For this recalibration, the max time will not exceed 2s.
+                * The average time is approximately 500 - 700 ms, and we
+                * will check the status every 100 - 200ms.
+                */
+               usleep_range(100000, 200000);
+
+               ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+               if (ret < 0) {
+                       dev_err(dev, "Error reading dev status. err =3D %d\=
n",
+                               ret);
+                       goto out;
+               }
+               if ((ret & CYAPA_DEV_NORMAL) =3D=3D CYAPA_DEV_NORMAL)
+                       break;
+       } while (--tries);
+
+       if (tries =3D=3D 0) {
+               dev_err(dev, "Failed to calibrate. Timeout.\n");
+               ret =3D -ETIMEDOUT;
+               goto out;
+       }
+       dev_dbg(dev, "Calibration successful.\n");
+
+out:
+       cyapa_enable_irq(cyapa);
+       return ret < 0 ? ret : count;
+}
+
+static ssize_t cyapa_gen3_show_baseline(struct device *dev,
+                                  struct device_attribute *attr, char *buf=
)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       int max_baseline, min_baseline;
+       int tries =3D 3;
+       int ret;
+
+       cyapa_disable_irq(cyapa);
+
+       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+       if (ret < 0) {
+               dev_err(dev, "Error reading dev status. err =3D %d\n", ret)=
;
+               goto out;
+       }
+       if ((ret & CYAPA_DEV_NORMAL) !=3D CYAPA_DEV_NORMAL) {
+               dev_warn(dev, "Trackpad device is busy. device state =3D 0x=
%x\n",
+                        ret);
+               ret =3D -EAGAIN;
+               goto out;
+       }
+
+       ret =3D cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
+                              OP_REPORT_BASELINE_MASK);
+       if (ret < 0) {
+               dev_err(dev, "Failed to send report baseline command. %d\n"=
,
+                       ret);
+               goto out;
+       }
+
+       do {
+               usleep_range(10000, 20000);
+
+               ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+               if (ret < 0) {
+                       dev_err(dev, "Error reading dev status. err =3D %d\=
n",
+                               ret);
+                       goto out;
+               }
+               if ((ret & CYAPA_DEV_NORMAL) =3D=3D CYAPA_DEV_NORMAL)
+                       break;
+       } while (--tries);
+
+       if (tries =3D=3D 0) {
+               dev_err(dev, "Device timed out going to Normal state.\n");
+               ret =3D -ETIMEDOUT;
+               goto out;
+       }
+
+       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_MAX_BASELINE);
+       if (ret < 0) {
+               dev_err(dev, "Failed to read max baseline. err =3D %d\n", r=
et);
+               goto out;
+       }
+       max_baseline =3D ret;
+
+       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_MIN_BASELINE);
+       if (ret < 0) {
+               dev_err(dev, "Failed to read min baseline. err =3D %d\n", r=
et);
+               goto out;
+       }
+       min_baseline =3D ret;
+
+       dev_dbg(dev, "Baseline report successful. Max: %d Min: %d\n",
+               max_baseline, min_baseline);
+       ret =3D scnprintf(buf, PAGE_SIZE, "%d %d\n", max_baseline, min_base=
line);
+
+out:
+       cyapa_enable_irq(cyapa);
+       return ret;
+}
+
 /*
  * cyapa_sleep_time_to_pwr_cmd and cyapa_pwr_cmd_to_sleep_time
  *
@@ -2541,18 +3070,18 @@ static int cyapa_check_is_operational(struct cyapa =
*cyapa)

                break;
        case CYAPA_GEN3:
-               cyapa->cyapa_check_fw =3D NULL;
-               cyapa->cyapa_bl_enter =3D NULL;
-               cyapa->cyapa_bl_activate =3D NULL;
+               cyapa->cyapa_check_fw =3D cyapa_gen3_check_fw;
+               cyapa->cyapa_bl_enter =3D cyapa_gen3_bl_enter;
+               cyapa->cyapa_bl_activate =3D cyapa_gen3_bl_activate;
                cyapa->cyapa_bl_initiate =3D NULL;
-               cyapa->cyapa_update_fw =3D NULL;
+               cyapa->cyapa_update_fw =3D cyapa_gen3_do_fw_update;
                cyapa->cyapa_bl_verify_app_integrity =3D NULL;
                cyapa->cyapa_bl_deactivate =3D cyapa_gen3_bl_deactivate;
-               cyapa->cyapa_show_baseline =3D NULL;
-               cyapa->cyapa_calibrate_store =3D NULL;
+               cyapa->cyapa_show_baseline =3D cyapa_gen3_show_baseline;
+               cyapa->cyapa_calibrate_store =3D cyapa_gen3_do_calibrate;
                cyapa->cyapa_irq_handler =3D cyapa_gen3_irq_handler;
                cyapa->cyapa_set_power_mode =3D cyapa_gen3_set_power_mode;
-               cyapa->cyapa_read_fw =3D NULL;
+               cyapa->cyapa_read_fw =3D cyapa_gen3_read_fw;
                cyapa->cyapa_read_raw_data =3D NULL;

                ret =3D cyapa_gen3_do_operational_check(cyapa);
@@ -2713,6 +3242,10 @@ static int cyapa_get_state(struct cyapa *cyapa)
         * detect trackpad protocol based on characristic registers and bit=
s.
         */
        do {
+               cyapa->status[REG_OP_STATUS] =3D status[REG_OP_STATUS];
+               cyapa->status[REG_BL_STATUS] =3D status[REG_BL_STATUS];
+               cyapa->status[REG_BL_ERROR] =3D status[REG_BL_ERROR];
+
                if (cyapa->gen =3D=3D CYAPA_GEN_UNKNOWN ||
                                cyapa->gen =3D=3D CYAPA_GEN3) {
                        cyapa->gen_detecting =3D CYAPA_GEN3;
@@ -2964,6 +3497,286 @@ static void cyapa_detect(struct cyapa *cyapa)
                cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
 }

+static int cyapa_firmware(struct cyapa *cyapa, const char *fw_name)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       int ret;
+       const struct firmware *fw;
+
+       ret =3D request_firmware(&fw, fw_name, dev);
+       if (ret) {
+               dev_err(dev, "Could not load firmware from %s, %d\n",
+                       fw_name, ret);
+               return ret;
+       }
+
+       if (cyapa->cyapa_check_fw) {
+               ret =3D cyapa->cyapa_check_fw(cyapa, fw);
+               if (ret) {
+                       dev_err(dev, "Invalid CYAPA firmware image: %s\n",
+                                       fw_name);
+                       goto done;
+               }
+       } else {
+               dev_err(dev, "Unknown status, operation forbidden, gen=3D%d=
\n",
+                       cyapa->gen);
+               ret =3D -EPERM;
+               goto done;
+       }
+
+       /*
+        * Resume the potentially suspended device because doing FW
+        * update on a device not in the FULL mode has a chance to
+        * fail.
+        */
+       pm_runtime_get_sync(dev);
+
+       if (cyapa->cyapa_bl_enter) {
+               ret =3D cyapa->cyapa_bl_enter(cyapa);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->cyapa_bl_activate) {
+               ret =3D cyapa->cyapa_bl_activate(cyapa);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->cyapa_bl_initiate) {
+               ret =3D cyapa->cyapa_bl_initiate(cyapa, fw);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->cyapa_update_fw) {
+               ret =3D cyapa->cyapa_update_fw(cyapa, fw);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->cyapa_bl_verify_app_integrity) {
+               ret =3D cyapa->cyapa_bl_verify_app_integrity(cyapa);
+               if (ret)
+                       goto err_detect;
+       }
+
+err_detect:
+       pm_runtime_put_noidle(dev);
+       cyapa_detect_async(cyapa, 0);
+
+done:
+       release_firmware(fw);
+       return ret;
+}
+
+/*
+ **************************************************************
+ * debugfs interface
+ **************************************************************
+*/
+static int cyapa_debugfs_open(struct inode *inode, struct file *file)
+{
+       struct cyapa *cyapa =3D inode->i_private;
+       int ret;
+
+       if (!cyapa)
+               return -ENODEV;
+
+       ret =3D mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+
+       if (!kobject_get(&cyapa->client->dev.kobj)) {
+               ret =3D -ENODEV;
+               goto out;
+       }
+
+       file->private_data =3D cyapa;
+
+       /*
+        * If firmware hasn't been read yet, read it all in one pass.
+        * Subsequent opens will reuse the data in this same buffer.
+        */
+       if (!cyapa->cyapa_read_fw) {
+               ret =3D -EPERM;
+               goto out;
+       }
+       ret =3D cyapa->cyapa_read_fw(cyapa);
+
+out:
+       mutex_unlock(&cyapa->debugfs_mutex);
+       return ret;
+}
+
+static int cyapa_debugfs_release(struct inode *inode, struct file *file)
+{
+       struct cyapa *cyapa =3D file->private_data;
+       int ret;
+
+       if (!cyapa)
+               return 0;
+
+       ret =3D mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+       file->private_data =3D NULL;
+       kobject_put(&cyapa->client->dev.kobj);
+       mutex_unlock(&cyapa->debugfs_mutex);
+
+       return 0;
+}
+
+/* Return some bytes from the buffered firmware image, starting from *ppos=
 */
+static ssize_t cyapa_debugfs_read_fw(struct file *file, char __user *buffe=
r,
+                                    size_t count, loff_t *ppos)
+{
+       struct cyapa *cyapa =3D file->private_data;
+
+       if (!cyapa->read_fw_image)
+               return -EINVAL;
+
+       if (*ppos >=3D cyapa->read_fw_image_size)
+               return 0;
+
+       if (count + *ppos > cyapa->read_fw_image_size)
+               count =3D cyapa->read_fw_image_size - *ppos;
+
+       if (copy_to_user(buffer, &cyapa->read_fw_image[*ppos], count))
+               return -EFAULT;
+
+       *ppos +=3D count;
+       return count;
+}
+
+static const struct file_operations cyapa_read_fw_fops =3D {
+       .open =3D cyapa_debugfs_open,
+       .release =3D cyapa_debugfs_release,
+       .read =3D cyapa_debugfs_read_fw
+};
+
+static int cyapa_debugfs_raw_data_open(struct inode *inode, struct file *f=
ile)
+{
+       struct cyapa *cyapa =3D inode->i_private;
+       int ret;
+
+       if (!cyapa)
+               return -ENODEV;
+
+       ret =3D mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+
+       if (!kobject_get(&cyapa->client->dev.kobj)) {
+               ret =3D -ENODEV;
+               goto out;
+       }
+
+       file->private_data =3D cyapa;
+
+       if (!cyapa->tp_raw_data) {
+               if (cyapa->state !=3D CYAPA_STATE_GEN5_APP ||
+                       !cyapa->electrodes_x || !cyapa->electrodes_y) {
+                       ret =3D  -EINVAL;
+                       goto out;
+               }
+
+               cyapa->tp_raw_data_size =3D sizeof(s32) * (cyapa->electrode=
s_x *
+                       cyapa->electrodes_y + cyapa->electrodes_x +
+                       cyapa->electrodes_y) + GEN5_RAW_DATA_HEAD_SIZE;
+               /* This buffer will be hold after used until the driver is
+                * unloaded, the purpose of it is to improve the performace
+                * to avoid frequently allocate and release the buffer. */
+               cyapa->tp_raw_data =3D
+                       kmalloc(cyapa->tp_raw_data_size, GFP_KERNEL);
+               if (!cyapa->tp_raw_data) {
+                       ret =3D  -ENOMEM;
+                       goto out;
+               }
+               memset(cyapa->tp_raw_data, 0, cyapa->tp_raw_data_size);
+       }
+
+       if (!cyapa->cyapa_read_raw_data) {
+               ret =3D -EPERM;
+               goto out;
+       }
+       ret =3D cyapa->cyapa_read_raw_data(cyapa);
+
+out:
+       mutex_unlock(&cyapa->debugfs_mutex);
+       return ret;
+}
+
+static int cyapa_debugfs_raw_data_release(struct inode *inode,
+                               struct file *file)
+{
+       struct cyapa *cyapa =3D file->private_data;
+       int ret;
+
+       if (!cyapa)
+               return 0;
+
+       ret =3D mutex_lock_interruptible(&cyapa->debugfs_mutex);
+       if (ret)
+               return ret;
+       file->private_data =3D NULL;
+       kobject_put(&cyapa->client->dev.kobj);
+       mutex_unlock(&cyapa->debugfs_mutex);
+
+       return 0;
+}
+
+/* Always return the sensors' latest raw data from trackpad device. */
+static ssize_t cyapa_debugfs_read_raw_data(struct file *file,
+                                    char __user *buffer,
+                                    size_t count, loff_t *ppos)
+{
+       struct cyapa *cyapa =3D file->private_data;
+
+       if (!cyapa->tp_raw_data)
+               return -EINVAL;
+
+       if (*ppos >=3D cyapa->tp_raw_data_size)
+               return 0;
+
+       if (count + *ppos > cyapa->tp_raw_data_size)
+               count =3D cyapa->tp_raw_data_size - *ppos;
+
+       if (copy_to_user(buffer, &cyapa->tp_raw_data[*ppos], count))
+               return -EFAULT;
+
+       *ppos +=3D count;
+       return count;
+}
+
+static const struct file_operations cyapa_read_raw_data_fops =3D {
+       .open =3D cyapa_debugfs_raw_data_open,
+       .release =3D cyapa_debugfs_raw_data_release,
+       .read =3D cyapa_debugfs_read_raw_data
+};
+
+static int cyapa_debugfs_init(struct cyapa *cyapa)
+{
+       struct device *dev =3D &cyapa->client->dev;
+
+       if (!cyapa_debugfs_root)
+               return -ENODEV;
+
+       cyapa->dentry_dev =3D debugfs_create_dir(kobject_name(&dev->kobj),
+                                              cyapa_debugfs_root);
+
+       if (!cyapa->dentry_dev)
+               return -ENODEV;
+
+       mutex_init(&cyapa->debugfs_mutex);
+
+       debugfs_create_file(CYAPA_DEBUGFS_READ_FW, S_IRUSR, cyapa->dentry_d=
ev,
+                           cyapa, &cyapa_read_fw_fops);
+
+       debugfs_create_file(CYAPA_DEBUGFS_RAW_DATA, S_IRUSR, cyapa->dentry_=
dev,
+                           cyapa, &cyapa_read_raw_data_fops);
+       return 0;
+}

 /*
  * Sysfs Interface.
@@ -3110,6 +3923,93 @@ static void cyapa_start_runtime(struct cyapa *cyapa)
 static void cyapa_start_runtime(struct cyapa *cyapa) {}
 #endif /* CONFIG_PM_RUNTIME */

+static ssize_t cyapa_show_fm_ver(struct device *dev,
+                                struct device_attribute *attr, char *buf)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       return scnprintf(buf, PAGE_SIZE, "%d.%d\n", cyapa->fw_maj_ver,
+                        cyapa->fw_min_ver);
+}
+
+static ssize_t cyapa_show_product_id(struct device *dev,
+                                    struct device_attribute *attr, char *b=
uf)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       return scnprintf(buf, PAGE_SIZE, "%s\n", cyapa->product_id);
+}
+
+static ssize_t cyapa_update_fw_store(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       const char *fw_name;
+       int ret;
+
+       /* Do not allow paths that step out of /lib/firmware  */
+       if (strstr(buf, "../") !=3D NULL)
+               return -EINVAL;
+
+       fw_name =3D !strncmp(buf, "1", count) ||
+                 !strncmp(buf, "1\n", count) ? CYAPA_FW_NAME : buf;
+
+       ret =3D cyapa_firmware(cyapa, fw_name);
+       if (ret)
+               dev_err(dev, "firmware update failed, %d\n", ret);
+       else
+               dev_dbg(dev, "firmware update succeeded\n");
+
+       return ret ? ret : count;
+}
+
+static ssize_t cyapa_calibrate_store(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       int ret;
+
+       if (!cyapa->cyapa_calibrate_store) {
+               dev_err(dev, "Calibrate operation not permitted.\n");
+               return -EPERM;
+       }
+
+       ret =3D cyapa->cyapa_calibrate_store(dev, attr, buf, count);
+       return ret < 0 ? ret : count;
+}
+
+static ssize_t cyapa_show_baseline(struct device *dev,
+                                  struct device_attribute *attr, char *buf=
)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+
+       if (!cyapa->cyapa_show_baseline) {
+               dev_err(dev, "Calibrate operation not permitted.\n");
+               return -EPERM;
+       }
+
+       return cyapa->cyapa_show_baseline(dev, attr, buf);
+}
+
+static DEVICE_ATTR(firmware_version, S_IRUGO, cyapa_show_fm_ver, NULL);
+static DEVICE_ATTR(product_id, S_IRUGO, cyapa_show_product_id, NULL);
+static DEVICE_ATTR(update_fw, S_IWUSR, NULL, cyapa_update_fw_store);
+static DEVICE_ATTR(baseline, S_IRUGO, cyapa_show_baseline, NULL);
+static DEVICE_ATTR(calibrate, S_IWUSR, NULL, cyapa_calibrate_store);
+
+static struct attribute *cyapa_sysfs_entries[] =3D {
+       &dev_attr_firmware_version.attr,
+       &dev_attr_product_id.attr,
+       &dev_attr_update_fw.attr,
+       &dev_attr_baseline.attr,
+       &dev_attr_calibrate.attr,
+       NULL,
+};
+
+static const struct attribute_group cyapa_sysfs_group =3D {
+       .attrs =3D cyapa_sysfs_entries,
+};
+

 /*
  * We rely on EV_SW and SW_LID bits to identify a LID device, and hook
@@ -3311,6 +4211,16 @@ static int cyapa_probe(struct i2c_client *client,
        }
        cyapa_disable_irq(cyapa);

+       if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
+               dev_warn(dev, "error creating sysfs entries.\n");
+
+       /* Create a global debugfs root for all cyapa devices */
+       cyapa_debugfs_root =3D debugfs_create_dir("cyapa", NULL);
+       if (cyapa_debugfs_root =3D=3D ERR_PTR(-ENODEV))
+               cyapa_debugfs_root =3D NULL;
+       if (cyapa_debugfs_init(cyapa))
+               dev_warn(dev, "error creating debugfs entries.\n");
+
 #ifdef CONFIG_PM_SLEEP
        if (device_can_wakeup(dev) &&
            sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group)=
)
@@ -3333,6 +4243,7 @@ static int cyapa_remove(struct i2c_client *client)
        struct cyapa *cyapa =3D i2c_get_clientdata(client);

        pm_runtime_disable(&client->dev);
+       sysfs_remove_group(&client->dev.kobj, &cyapa_sysfs_group);

 #ifdef CONFIG_PM_SLEEP
        sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
@@ -3342,7 +4253,18 @@ static int cyapa_remove(struct i2c_client *client)
        sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
 #endif

+       kfree(cyapa->read_fw_image);
+       cyapa->read_fw_image =3D NULL;
+       cyapa->read_fw_image_size =3D 0;
+       kfree(cyapa->tp_raw_data);
+       cyapa->tp_raw_data =3D NULL;
+       cyapa->tp_raw_data_size =3D 0;
        free_irq(cyapa->irq, cyapa);
+
+       debugfs_remove_recursive(cyapa->dentry_dev);
+       debugfs_remove_recursive(cyapa_debugfs_root);
+       mutex_destroy(&cyapa->debugfs_mutex);
+
        input_unregister_device(cyapa->input);
        lid_event_unregister_handler(cyapa);
        if (cyapa->cyapa_set_power_mode)
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F40C140ADS04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
cAB1AHQAOgAgAGMAeQBhAHAAYQA6ACAAYQBkAGQAIABzAHkAcwBmAHMAIABpAG4AdABlAHIAZgBh
AGMAZQBzACAAcwB1AHAAcABvAHIAdABlAGQAIABmAG8AcgAgAGcAZQBuADMAIAB0AHIAYQBjAGsA
cABhAGQAIABkAGUAdgBpAGMAZQAAAB8APQABAAAAAgAAAAAAAAADADYAAAAAAAMALgAAAAAAHwBC
EAEAAAACAAAAAAAAAAIBcQABAAAAGwAAAAHPV7a+qp7s/+YZ+09roLuHn6qeswgAZipMgAAfAHAA
AQAAAKQAAABbAFAAQQBUAEMASAAgADUALwA2AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6
ACAAYQBkAGQAIABzAHkAcwBmAHMAIABpAG4AdABlAHIAZgBhAGMAZQBzACAAcwB1AHAAcABvAHIA
dABlAGQAIABmAG8AcgAgAGcAZQBuADMAIAB0AHIAYQBjAGsAcABhAGQAIABkAGUAdgBpAGMAZQAA
AB8ANRABAAAAhAAAADwANwA3AEIAQwA3ADIANQBDADkAMAA2ADIANwA2ADQARgA4ADcANABEADcA
OQBGADUAMQBFADEARgAxAEEAOABGADQAMABDADEANAAwAEEARABAAFMAMAA0AC0ATQBCAFgAMAAx
AC0AMAAxAC4AcwAwADQALgBsAG8AYwBhAGwAPgAAAB8AORABAAAAAgAAAAAAAAADAN4/n04AAAsA
AIAIIAYAAAAAAMAAAAAAAABGAAAAAAOFAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAAYUA
AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAABgQAAAAAAAAMAgBD/////BQAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAAoEAAAAAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAHIEAAAAAAABA
AAcwp59zik9ZzwELAAIAAQAAAAMAJgAAAAAACwArAAAAAAACARAwAQAAAEYAAAAAAAAAsR+hOTAg
UUadtKVw3tCf1AcAd7xyXJBidk+HTXn1Hh8ajwAAAJk8GwAAuqc+7svX90Cjdu81/GFZiQAYg/zD
MAAAAAAfAPo/AQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAAMACVkBAAAAAwAAgAggBgAAAAAA
wAAAAAAAAEYAAAAAEIUAAAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBl
AHIAcwBhAHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAA3gAAAEkA
SQA9ADAAMQBDAEYANQA3AEIANgBCAEUAQQBBADkARQBFAEMARgBGAEUANgAxADkARgBCADQARgA2
AEIAQQAwAEIAQgA4ADcAOQBGAEEAQQA5AEUAQgAzADAAOAAwADAANgA2ADIAQQA0AEMAOAAwADsA
UwBCAEMASQBEAD0ANAA7AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMwAg
ACgAQgB1AGkAbABkACAAMQA3ADQALgAwACkALAAgAFMAdABhAGcAZQA9AEgANAAAAAAAAwAAgAMg
BgAAAAAAwAAAAAAAAEYAAAAAE4EAAAEAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAjgQAA////
fwMAAIADIAYAAAAAAMAAAAAAAABGAAAAABCBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAA
EYEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAkgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAA
AABGAAAAACyBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKYEAAAAAAAADAACAAyAGAAAA
AADAAAAAAAAARgAAAAAqgQAAAAAAAB8AAIADIAYAAAAAAMAAAAAAAABGAAAAACeBAAABAAAAAgAA
AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAASgQAAAQAAAB8AAIADIAYAAAAAAMAAAAAAAABG
AAAAACGBAAABAAAAAgAAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAADgQAAAAAAAAsAAIAD
IAYAAAAAAMAAAAAAAABGAAAAACaBAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAA
AAADAACACCAGAAAAAADAAAAAAAAARgAAAAAYhQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAA
AIKFAAAAAAAAAwANNP0/AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAgAAAAeAAtAG0AcwAtAGgA
YQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAi
AAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAtAGkAcAAAAAAAAQAAAB4AAABbADEAMAAuADMA
MAAuADEAMgAuADEANQAzAF0AAAAAAO8T

--_000_77BC725C9062764F874D79F51E1F1A8F40C140ADS04MBX0101s04lo_--
