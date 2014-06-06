Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaFFH24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:28:56 -0400
Received: from relay-s04-hub006.domainlocalhost.com ([74.115.207.217]:38370
	"EHLO relay-S04-HUB006.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaFFH2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:28:53 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406B897S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 1/14] input: cyapa: re-architecture driver to support
 multi-trackpads in one driver
Thread-Topic: [PATCH v2 1/14] input: cyapa: re-architecture driver to
 support multi-trackpads in one driver
Thread-Index: Ac+BWOPDpsXwZFzKTQikGLKtbJwV3Q==
Date: Fri, 6 Jun 2014 07:28:32 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406B897@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406B897@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406B897S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

In order to support two different communication protocol based trackpad
device in one cyapa, the new cyapa driver is re-designed with
one cyapa driver core and two devices' functions component.
The cyapa driver core is contained in this patch, it supplies the basic
function with input and kernel system and also defined the interfaces
that the devices' functions component needs to apply and support.
Also, in order to speed up the system boot time, the device states
detecting and probing process is put into the async thread.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index c25efdb..d8948df 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_MOUSE_AMIGA)               +=3D amimouse.o
 obj-$(CONFIG_MOUSE_APPLETOUCH)         +=3D appletouch.o
 obj-$(CONFIG_MOUSE_ATARI)              +=3D atarimouse.o
 obj-$(CONFIG_MOUSE_BCM5974)            +=3D bcm5974.o
-obj-$(CONFIG_MOUSE_CYAPA)              +=3D cyapa.o
+obj-$(CONFIG_MOUSE_CYAPA)              +=3D cyapatp.o
 obj-$(CONFIG_MOUSE_GPIO)               +=3D gpio_mouse.o
 obj-$(CONFIG_MOUSE_INPORT)             +=3D inport.o
 obj-$(CONFIG_MOUSE_LOGIBM)             +=3D logibm.o
@@ -34,3 +34,6 @@ psmouse-$(CONFIG_MOUSE_PS2_SENTELIC)  +=3D sentelic.o
 psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT) +=3D trackpoint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)   +=3D touchkit_ps2.o
 psmouse-$(CONFIG_MOUSE_PS2_CYPRESS)    +=3D cypress_ps2.o
+
+cyapatp-y :=3D cyapa.o
+
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index b409c3d..d5adee8 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -14,731 +14,193 @@
  * more details.
  */

+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
 #include <linux/input/mt.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
+#include "cyapa.h"

-/* APA trackpad firmware generation */
-#define CYAPA_GEN3   0x03   /* support MT-protocol B with tracking ID. */
-
-#define CYAPA_NAME   "Cypress APA Trackpad (cyapa)"
-
-/* commands for read/write registers of Cypress trackpad */
-#define CYAPA_CMD_SOFT_RESET       0x00
-#define CYAPA_CMD_POWER_MODE       0x01
-#define CYAPA_CMD_DEV_STATUS       0x02
-#define CYAPA_CMD_GROUP_DATA       0x03
-#define CYAPA_CMD_GROUP_CMD        0x04
-#define CYAPA_CMD_GROUP_QUERY      0x05
-#define CYAPA_CMD_BL_STATUS        0x06
-#define CYAPA_CMD_BL_HEAD          0x07
-#define CYAPA_CMD_BL_CMD           0x08
-#define CYAPA_CMD_BL_DATA          0x09
-#define CYAPA_CMD_BL_ALL           0x0a
-#define CYAPA_CMD_BLK_PRODUCT_ID   0x0b
-#define CYAPA_CMD_BLK_HEAD         0x0c
-
-/* report data start reg offset address. */
-#define DATA_REG_START_OFFSET  0x0000
-
-#define BL_HEAD_OFFSET 0x00
-#define BL_DATA_OFFSET 0x10
-
-/*
- * Operational Device Status Register
- *
- * bit 7: Valid interrupt source
- * bit 6 - 4: Reserved
- * bit 3 - 2: Power status
- * bit 1 - 0: Device status
- */
-#define REG_OP_STATUS     0x00
-#define OP_STATUS_SRC     0x80
-#define OP_STATUS_POWER   0x0c
-#define OP_STATUS_DEV     0x03
-#define OP_STATUS_MASK (OP_STATUS_SRC | OP_STATUS_POWER | OP_STATUS_DEV)
-
-/*
- * Operational Finger Count/Button Flags Register
- *
- * bit 7 - 4: Number of touched finger
- * bit 3: Valid data
- * bit 2: Middle Physical Button
- * bit 1: Right Physical Button
- * bit 0: Left physical Button
- */
-#define REG_OP_DATA1       0x01
-#define OP_DATA_VALID      0x08
-#define OP_DATA_MIDDLE_BTN 0x04
-#define OP_DATA_RIGHT_BTN  0x02
-#define OP_DATA_LEFT_BTN   0x01
-#define OP_DATA_BTN_MASK (OP_DATA_MIDDLE_BTN | OP_DATA_RIGHT_BTN | \
-                         OP_DATA_LEFT_BTN)
-
-/*
- * Bootloader Status Register
- *
- * bit 7: Busy
- * bit 6 - 5: Reserved
- * bit 4: Bootloader running
- * bit 3 - 1: Reserved
- * bit 0: Checksum valid
- */
-#define REG_BL_STATUS        0x01
-#define BL_STATUS_BUSY       0x80
-#define BL_STATUS_RUNNING    0x10
-#define BL_STATUS_DATA_VALID 0x08
-#define BL_STATUS_CSUM_VALID 0x01
-
-/*
- * Bootloader Error Register
- *
- * bit 7: Invalid
- * bit 6: Invalid security key
- * bit 5: Bootloading
- * bit 4: Command checksum
- * bit 3: Flash protection error
- * bit 2: Flash checksum error
- * bit 1 - 0: Reserved
- */
-#define REG_BL_ERROR         0x02
-#define BL_ERROR_INVALID     0x80
-#define BL_ERROR_INVALID_KEY 0x40
-#define BL_ERROR_BOOTLOADING 0x20
-#define BL_ERROR_CMD_CSUM    0x10
-#define BL_ERROR_FLASH_PROT  0x08
-#define BL_ERROR_FLASH_CSUM  0x04
-
-#define BL_STATUS_SIZE  3  /* length of bootloader status registers */
-#define BLK_HEAD_BYTES 32
-
-#define PRODUCT_ID_SIZE  16
-#define QUERY_DATA_SIZE  27
-#define REG_PROTOCOL_GEN_QUERY_OFFSET  20
-
-#define REG_OFFSET_DATA_BASE     0x0000
-#define REG_OFFSET_COMMAND_BASE  0x0028
-#define REG_OFFSET_QUERY_BASE    0x002a
-
-#define CAPABILITY_LEFT_BTN_MASK       (0x01 << 3)
-#define CAPABILITY_RIGHT_BTN_MASK      (0x01 << 4)
-#define CAPABILITY_MIDDLE_BTN_MASK     (0x01 << 5)
-#define CAPABILITY_BTN_MASK  (CAPABILITY_LEFT_BTN_MASK | \
-                             CAPABILITY_RIGHT_BTN_MASK | \
-                             CAPABILITY_MIDDLE_BTN_MASK)
-
-#define CYAPA_OFFSET_SOFT_RESET  REG_OFFSET_COMMAND_BASE
-
-#define REG_OFFSET_POWER_MODE (REG_OFFSET_COMMAND_BASE + 1)
-
-#define PWR_MODE_MASK   0xfc
-#define PWR_MODE_FULL_ACTIVE (0x3f << 2)
-#define PWR_MODE_IDLE        (0x05 << 2) /* default sleep time is 50 ms. *=
/
-#define PWR_MODE_OFF         (0x00 << 2)
-
-#define PWR_STATUS_MASK      0x0c
-#define PWR_STATUS_ACTIVE    (0x03 << 2)
-#define PWR_STATUS_IDLE      (0x02 << 2)
-#define PWR_STATUS_OFF       (0x00 << 2)
-
-/*
- * CYAPA trackpad device states.
- * Used in register 0x00, bit1-0, DeviceStatus field.
- * Other values indicate device is in an abnormal state and must be reset.
- */
-#define CYAPA_DEV_NORMAL  0x03
-#define CYAPA_DEV_BUSY    0x01
-
-enum cyapa_state {
-       CYAPA_STATE_OP,
-       CYAPA_STATE_BL_IDLE,
-       CYAPA_STATE_BL_ACTIVE,
-       CYAPA_STATE_BL_BUSY,
-       CYAPA_STATE_NO_DEVICE,
-};
-
-
-struct cyapa_touch {
-       /*
-        * high bits or x/y position value
-        * bit 7 - 4: high 4 bits of x position value
-        * bit 3 - 0: high 4 bits of y position value
-        */
-       u8 xy_hi;
-       u8 x_lo;  /* low 8 bits of x position value. */
-       u8 y_lo;  /* low 8 bits of y position value. */
-       u8 pressure;
-       /* id range is 1 - 15.  It is incremented with every new touch. */
-       u8 id;
-} __packed;
-
-/* The touch.id is used as the MT slot id, thus max MT slot is 15 */
-#define CYAPA_MAX_MT_SLOTS  15
-
-struct cyapa_reg_data {
-       /*
-        * bit 0 - 1: device status
-        * bit 3 - 2: power mode
-        * bit 6 - 4: reserved
-        * bit 7: interrupt valid bit
-        */
-       u8 device_status;
-       /*
-        * bit 7 - 4: number of fingers currently touching pad
-        * bit 3: valid data check bit
-        * bit 2: middle mechanism button state if exists
-        * bit 1: right mechanism button state if exists
-        * bit 0: left mechanism button state if exists
-        */
-       u8 finger_btn;
-       /* CYAPA reports up to 5 touches per packet. */
-       struct cyapa_touch touches[5];
-} __packed;
-
-/* The main device structure */
-struct cyapa {
-       enum cyapa_state state;
-
-       struct i2c_client *client;
-       struct input_dev *input;
-       char phys[32];  /* device physical location */
-       int irq;
-       bool irq_wake;  /* irq wake is enabled */
-       bool smbus;
-
-       /* read from query data region. */
-       char product_id[16];
-       u8 btn_capability;
-       u8 gen;
-       int max_abs_x;
-       int max_abs_y;
-       int physical_size_x;
-       int physical_size_y;
-};
-
-static const u8 bl_deactivate[] =3D { 0x00, 0xff, 0x3b, 0x00, 0x01, 0x02, =
0x03,
-               0x04, 0x05, 0x06, 0x07 };
-static const u8 bl_exit[] =3D { 0x00, 0xff, 0xa5, 0x00, 0x01, 0x02, 0x03, =
0x04,
-               0x05, 0x06, 0x07 };
-
-struct cyapa_cmd_len {
-       u8 cmd;
-       u8 len;
-};

 #define CYAPA_ADAPTER_FUNC_NONE   0
 #define CYAPA_ADAPTER_FUNC_I2C    1
 #define CYAPA_ADAPTER_FUNC_SMBUS  2
 #define CYAPA_ADAPTER_FUNC_BOTH   3

-/*
- * macros for SMBus communication
- */
-#define SMBUS_READ   0x01
-#define SMBUS_WRITE 0x00
-#define SMBUS_ENCODE_IDX(cmd, idx) ((cmd) | (((idx) & 0x03) << 1))
-#define SMBUS_ENCODE_RW(cmd, rw) ((cmd) | ((rw) & 0x01))
-#define SMBUS_BYTE_BLOCK_CMD_MASK 0x80
-#define SMBUS_GROUP_BLOCK_CMD_MASK 0x40
-
- /* for byte read/write command */
-#define CMD_RESET 0
-#define CMD_POWER_MODE 1
-#define CMD_DEV_STATUS 2
-#define SMBUS_BYTE_CMD(cmd) (((cmd) & 0x3f) << 1)
-#define CYAPA_SMBUS_RESET SMBUS_BYTE_CMD(CMD_RESET)
-#define CYAPA_SMBUS_POWER_MODE SMBUS_BYTE_CMD(CMD_POWER_MODE)
-#define CYAPA_SMBUS_DEV_STATUS SMBUS_BYTE_CMD(CMD_DEV_STATUS)
-
- /* for group registers read/write command */
-#define REG_GROUP_DATA 0
-#define REG_GROUP_CMD 2
-#define REG_GROUP_QUERY 3
-#define SMBUS_GROUP_CMD(grp) (0x80 | (((grp) & 0x07) << 3))
-#define CYAPA_SMBUS_GROUP_DATA SMBUS_GROUP_CMD(REG_GROUP_DATA)
-#define CYAPA_SMBUS_GROUP_CMD SMBUS_GROUP_CMD(REG_GROUP_CMD)
-#define CYAPA_SMBUS_GROUP_QUERY SMBUS_GROUP_CMD(REG_GROUP_QUERY)
-
- /* for register block read/write command */
-#define CMD_BL_STATUS 0
-#define CMD_BL_HEAD 1
-#define CMD_BL_CMD 2
-#define CMD_BL_DATA 3
-#define CMD_BL_ALL 4
-#define CMD_BLK_PRODUCT_ID 5
-#define CMD_BLK_HEAD 6
-#define SMBUS_BLOCK_CMD(cmd) (0xc0 | (((cmd) & 0x1f) << 1))
-
-/* register block read/write command in bootloader mode */
-#define CYAPA_SMBUS_BL_STATUS SMBUS_BLOCK_CMD(CMD_BL_STATUS)
-#define CYAPA_SMBUS_BL_HEAD SMBUS_BLOCK_CMD(CMD_BL_HEAD)
-#define CYAPA_SMBUS_BL_CMD SMBUS_BLOCK_CMD(CMD_BL_CMD)
-#define CYAPA_SMBUS_BL_DATA SMBUS_BLOCK_CMD(CMD_BL_DATA)
-#define CYAPA_SMBUS_BL_ALL SMBUS_BLOCK_CMD(CMD_BL_ALL)
-
-/* register block read/write command in operational mode */
-#define CYAPA_SMBUS_BLK_PRODUCT_ID SMBUS_BLOCK_CMD(CMD_BLK_PRODUCT_ID)
-#define CYAPA_SMBUS_BLK_HEAD SMBUS_BLOCK_CMD(CMD_BLK_HEAD)
-
-static const struct cyapa_cmd_len cyapa_i2c_cmds[] =3D {
-       { CYAPA_OFFSET_SOFT_RESET, 1 },
-       { REG_OFFSET_COMMAND_BASE + 1, 1 },
-       { REG_OFFSET_DATA_BASE, 1 },
-       { REG_OFFSET_DATA_BASE, sizeof(struct cyapa_reg_data) },
-       { REG_OFFSET_COMMAND_BASE, 0 },
-       { REG_OFFSET_QUERY_BASE, QUERY_DATA_SIZE },
-       { BL_HEAD_OFFSET, 3 },
-       { BL_HEAD_OFFSET, 16 },
-       { BL_HEAD_OFFSET, 16 },
-       { BL_DATA_OFFSET, 16 },
-       { BL_HEAD_OFFSET, 32 },
-       { REG_OFFSET_QUERY_BASE, PRODUCT_ID_SIZE },
-       { REG_OFFSET_DATA_BASE, 32 }
-};
+#define CYAPA_DEBUGFS_READ_FW  "read_fw"
+#define CYAPA_DEBUGFS_RAW_DATA "raw_data"
+#define CYAPA_FW_NAME          "cyapa.bin"

-static const struct cyapa_cmd_len cyapa_smbus_cmds[] =3D {
-       { CYAPA_SMBUS_RESET, 1 },
-       { CYAPA_SMBUS_POWER_MODE, 1 },
-       { CYAPA_SMBUS_DEV_STATUS, 1 },
-       { CYAPA_SMBUS_GROUP_DATA, sizeof(struct cyapa_reg_data) },
-       { CYAPA_SMBUS_GROUP_CMD, 2 },
-       { CYAPA_SMBUS_GROUP_QUERY, QUERY_DATA_SIZE },
-       { CYAPA_SMBUS_BL_STATUS, 3 },
-       { CYAPA_SMBUS_BL_HEAD, 16 },
-       { CYAPA_SMBUS_BL_CMD, 16 },
-       { CYAPA_SMBUS_BL_DATA, 16 },
-       { CYAPA_SMBUS_BL_ALL, 32 },
-       { CYAPA_SMBUS_BLK_PRODUCT_ID, PRODUCT_ID_SIZE },
-       { CYAPA_SMBUS_BLK_HEAD, 16 },
-};
+const char unique_str[] =3D "CYTRA";

-static ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_=
t len,
-                                       u8 *values)
-{
-       return i2c_smbus_read_i2c_block_data(cyapa->client, reg, len, value=
s);
-}

-static ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
-                                        size_t len, const u8 *values)
+void cyapa_enable_irq(struct cyapa *cyapa)
 {
-       return i2c_smbus_write_i2c_block_data(cyapa->client, reg, len, valu=
es);
+       mutex_lock(&cyapa->irq_state_lock);
+       if (!cyapa->irq_enabled)
+               enable_irq(cyapa->irq);
+       cyapa->irq_enabled =3D true;
+       cyapa->prev_irq_enabled =3D true;
+       mutex_unlock(&cyapa->irq_state_lock);
 }

-/*
- * cyapa_smbus_read_block - perform smbus block read command
- * @cyapa  - private data structure of the driver
- * @cmd    - the properly encoded smbus command
- * @len    - expected length of smbus command result
- * @values - buffer to store smbus command result
- *
- * Returns negative errno, else the number of bytes written.
- *
- * Note:
- * In trackpad device, the memory block allocated for I2C register map
- * is 256 bytes, so the max read block for I2C bus is 256 bytes.
- */
-static ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t =
len,
-                                     u8 *values)
+void cyapa_disable_irq(struct cyapa *cyapa)
 {
-       ssize_t ret;
-       u8 index;
-       u8 smbus_cmd;
-       u8 *buf;
-       struct i2c_client *client =3D cyapa->client;
-
-       if (!(SMBUS_BYTE_BLOCK_CMD_MASK & cmd))
-               return -EINVAL;
-
-       if (SMBUS_GROUP_BLOCK_CMD_MASK & cmd) {
-               /* read specific block registers command. */
-               smbus_cmd =3D SMBUS_ENCODE_RW(cmd, SMBUS_READ);
-               ret =3D i2c_smbus_read_block_data(client, smbus_cmd, values=
);
-               goto out;
-       }
-
-       ret =3D 0;
-       for (index =3D 0; index * I2C_SMBUS_BLOCK_MAX < len; index++) {
-               smbus_cmd =3D SMBUS_ENCODE_IDX(cmd, index);
-               smbus_cmd =3D SMBUS_ENCODE_RW(smbus_cmd, SMBUS_READ);
-               buf =3D values + I2C_SMBUS_BLOCK_MAX * index;
-               ret =3D i2c_smbus_read_block_data(client, smbus_cmd, buf);
-               if (ret < 0)
-                       goto out;
-       }
-
-out:
-       return ret > 0 ? len : ret;
+       mutex_lock(&cyapa->irq_state_lock);
+       if (cyapa->irq_enabled)
+               disable_irq(cyapa->irq);
+       cyapa->irq_enabled =3D false;
+       cyapa->prev_irq_enabled =3D false;
+       mutex_unlock(&cyapa->irq_state_lock);
 }

-static s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx)
+void cyapa_enable_irq_save(struct cyapa *cyapa)
 {
-       u8 cmd;
-
-       if (cyapa->smbus) {
-               cmd =3D cyapa_smbus_cmds[cmd_idx].cmd;
-               cmd =3D SMBUS_ENCODE_RW(cmd, SMBUS_READ);
-       } else {
-               cmd =3D cyapa_i2c_cmds[cmd_idx].cmd;
+       mutex_lock(&cyapa->irq_state_lock);
+       if (!cyapa->irq_enabled) {
+               enable_irq(cyapa->irq);
+               cyapa->irq_enabled =3D true;
        }
-       return i2c_smbus_read_byte_data(cyapa->client, cmd);
+       mutex_unlock(&cyapa->irq_state_lock);
 }

-static s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value)
+void cyapa_disable_irq_save(struct cyapa *cyapa)
 {
-       u8 cmd;
-
-       if (cyapa->smbus) {
-               cmd =3D cyapa_smbus_cmds[cmd_idx].cmd;
-               cmd =3D SMBUS_ENCODE_RW(cmd, SMBUS_WRITE);
-       } else {
-               cmd =3D cyapa_i2c_cmds[cmd_idx].cmd;
+       mutex_lock(&cyapa->irq_state_lock);
+       if (cyapa->irq_enabled) {
+               disable_irq(cyapa->irq);
+               cyapa->irq_enabled =3D false;
        }
-       return i2c_smbus_write_byte_data(cyapa->client, cmd, value);
+       mutex_unlock(&cyapa->irq_state_lock);
 }

-static ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *value=
s)
+void cyapa_irq_restore(struct cyapa *cyapa)
 {
-       u8 cmd;
-       size_t len;
-
-       if (cyapa->smbus) {
-               cmd =3D cyapa_smbus_cmds[cmd_idx].cmd;
-               len =3D cyapa_smbus_cmds[cmd_idx].len;
-               return cyapa_smbus_read_block(cyapa, cmd, len, values);
-       } else {
-               cmd =3D cyapa_i2c_cmds[cmd_idx].cmd;
-               len =3D cyapa_i2c_cmds[cmd_idx].len;
-               return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
+       mutex_lock(&cyapa->irq_state_lock);
+       if (cyapa->irq_enabled !=3D cyapa->prev_irq_enabled) {
+               if (cyapa->prev_irq_enabled) {
+                       enable_irq(cyapa->irq);
+                       cyapa->irq_enabled =3D true;
+               } else {
+                       disable_irq(cyapa->irq);
+                       cyapa->irq_enabled =3D false;
+               }
        }
+       mutex_unlock(&cyapa->irq_state_lock);
 }

-/*
- * Query device for its current operating state.
- *
- */
-static int cyapa_get_state(struct cyapa *cyapa)
+bool cyapa_is_irq_enabled(struct cyapa *cyapa)
 {
-       int ret;
-       u8 status[BL_STATUS_SIZE];
-
-       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
-
-       /*
-        * Get trackpad status by reading 3 registers starting from 0.
-        * If the device is in the bootloader, this will be BL_HEAD.
-        * If the device is in operation mode, this will be the DATA regs.
-        *
-        */
-       ret =3D cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET, BL_STATUS_S=
IZE,
-                                      status);
+       bool enabled;

-       /*
-        * On smbus systems in OP mode, the i2c_reg_read will fail with
-        * -ETIMEDOUT.  In this case, try again using the smbus equivalent
-        * command.  This should return a BL_HEAD indicating CYAPA_STATE_OP=
.
-        */
-       if (cyapa->smbus && (ret =3D=3D -ETIMEDOUT || ret =3D=3D -ENXIO))
-               ret =3D cyapa_read_block(cyapa, CYAPA_CMD_BL_STATUS, status=
);
-
-       if (ret !=3D BL_STATUS_SIZE)
-               goto error;
-
-       if ((status[REG_OP_STATUS] & OP_STATUS_SRC) =3D=3D OP_STATUS_SRC) {
-               switch (status[REG_OP_STATUS] & OP_STATUS_DEV) {
-               case CYAPA_DEV_NORMAL:
-               case CYAPA_DEV_BUSY:
-                       cyapa->state =3D CYAPA_STATE_OP;
-                       break;
-               default:
-                       ret =3D -EAGAIN;
-                       goto error;
-               }
-       } else {
-               if (status[REG_BL_STATUS] & BL_STATUS_BUSY)
-                       cyapa->state =3D CYAPA_STATE_BL_BUSY;
-               else if (status[REG_BL_ERROR] & BL_ERROR_BOOTLOADING)
-                       cyapa->state =3D CYAPA_STATE_BL_ACTIVE;
-               else
-                       cyapa->state =3D CYAPA_STATE_BL_IDLE;
-       }
-
-       return 0;
-error:
-       return (ret < 0) ? ret : -EAGAIN;
+       mutex_lock(&cyapa->irq_state_lock);
+       enabled =3D cyapa->irq_enabled;
+       mutex_unlock(&cyapa->irq_state_lock);
+       return enabled;
 }

-/*
- * Poll device for its status in a loop, waiting up to timeout for a respo=
nse.
- *
- * When the device switches state, it usually takes ~300 ms.
- * However, when running a new firmware image, the device must calibrate i=
ts
- * sensors, which can take as long as 2 seconds.
- *
- * Note: The timeout has granularity of the polling rate, which is 100 ms.
- *
- * Returns:
- *   0 when the device eventually responds with a valid non-busy state.
- *   -ETIMEDOUT if device never responds (too many -EAGAIN)
- *   < 0    other errors
- */
-static int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
+bool cyapa_state_sync_enter(struct cyapa *cyapa)
 {
-       int ret;
-       int tries =3D timeout / 100;
-
-       ret =3D cyapa_get_state(cyapa);
-       while ((ret || cyapa->state >=3D CYAPA_STATE_BL_BUSY) && tries--) {
-               msleep(100);
-               ret =3D cyapa_get_state(cyapa);
+       mutex_lock(&cyapa->state_sync_lock);
+       if (cyapa->in_syncing) {
+               mutex_unlock(&cyapa->state_sync_lock);
+               return false;
        }
-       return (ret =3D=3D -EAGAIN || ret =3D=3D -ETIMEDOUT) ? -ETIMEDOUT :=
 ret;
+       cyapa->in_syncing =3D true;
+       mutex_unlock(&cyapa->state_sync_lock);
+       return true;
 }

-static int cyapa_bl_deactivate(struct cyapa *cyapa)
+void cyapa_state_sync_exit(struct cyapa *cyapa)
 {
-       int ret;
-
-       ret =3D cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_deactivate),
-                                       bl_deactivate);
-       if (ret < 0)
-               return ret;
-
-       /* wait for bootloader to switch to idle state; should take < 100ms=
 */
-       msleep(100);
-       ret =3D cyapa_poll_state(cyapa, 500);
-       if (ret < 0)
-               return ret;
-       if (cyapa->state !=3D CYAPA_STATE_BL_IDLE)
-               return -EAGAIN;
-       return 0;
+       mutex_lock(&cyapa->state_sync_lock);
+       cyapa->in_syncing =3D false;
+       mutex_unlock(&cyapa->state_sync_lock);
 }

-/*
- * Exit bootloader
- *
- * Send bl_exit command, then wait 50 - 100 ms to let device transition to
- * operational mode.  If this is the first time the device's firmware is
- * running, it can take up to 2 seconds to calibrate its sensors.  So, pol=
l
- * the device's new state for up to 2 seconds.
- *
- * Returns:
- *   -EIO    failure while reading from device
- *   -EAGAIN device is stuck in bootloader, b/c it has invalid firmware
- *   0       device is supported and in operational mode
- */
-static int cyapa_bl_exit(struct cyapa *cyapa)
+/* Returns the number of read bytes or a negative errno code. */
+ssize_t cyapa_i2c_read(struct cyapa *cyapa, u8 reg, size_t len,
+                                       u8 *values)
 {
        int ret;
-
-       ret =3D cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_exit), bl_exi=
t);
-       if (ret < 0)
-               return ret;
-
-       /*
-        * Wait for bootloader to exit, and operation mode to start.
-        * Normally, this takes at least 50 ms.
-        */
-       usleep_range(50000, 100000);
-       /*
-        * In addition, when a device boots for the first time after being
-        * updated to new firmware, it must first calibrate its sensors, wh=
ich
-        * can take up to an additional 2 seconds.
-        */
-       ret =3D cyapa_poll_state(cyapa, 2000);
-       if (ret < 0)
-               return ret;
-       if (cyapa->state !=3D CYAPA_STATE_OP)
-               return -EAGAIN;
-
-       return 0;
+       struct i2c_client *client =3D cyapa->client;
+       struct i2c_msg msgs[] =3D {
+               {
+                       .addr =3D client->addr,
+                       .flags =3D 0,
+                       .len =3D 1,
+                       .buf =3D &reg,
+               },
+               {
+                       .addr =3D client->addr,
+                       .flags =3D I2C_M_RD,
+                       .len =3D len,
+                       .buf =3D values,
+               },
+       };
+
+       ret =3D i2c_transfer(client->adapter, msgs, 2);
+
+       return (ret =3D=3D 2) ? len : ((ret < 0) ? ret : -EIO);
 }

-/*
- * Set device power mode
+/**
+ * cyapa_i2c_write - execute i2c block data write operation
+ * @cyapa: Handle to this driver
+ * @ret: Offset of the data to written in the register map
+ * @len: the data length of bytes to written.
+ * @values: Data to be written
  *
+ * This executes returns a negative errno code else zero on success.
  */
-static int cyapa_set_power_mode(struct cyapa *cyapa, u8 power_mode)
+ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
+                                        size_t len, const u8 *values)
 {
-       struct device *dev =3D &cyapa->client->dev;
        int ret;
-       u8 power;
+       struct i2c_client *client =3D cyapa->client;
+       char data[32], *buf;

-       if (cyapa->state !=3D CYAPA_STATE_OP)
-               return 0;
+       if (len > 31)
+               buf =3D kzalloc(len + 1, GFP_KERNEL);
+       else
+               buf =3D &data[0];

-       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_POWER_MODE);
-       if (ret < 0)
-               return ret;
+       buf[0] =3D reg;
+       memcpy(&buf[1], values, len);
+       ret =3D i2c_master_send(client, buf, len + 1);

-       power =3D ret & ~PWR_MODE_MASK;
-       power |=3D power_mode & PWR_MODE_MASK;
-       ret =3D cyapa_write_byte(cyapa, CYAPA_CMD_POWER_MODE, power);
-       if (ret < 0)
-               dev_err(dev, "failed to set power_mode 0x%02x err =3D %d\n"=
,
-                       power_mode, ret);
-       return ret;
+       if (buf !=3D &data[0])
+               kfree(buf);
+       return (ret =3D=3D (len + 1)) ? 0 : ((ret < 0) ? ret : -EIO);
 }

-static int cyapa_get_query_data(struct cyapa *cyapa)
+void cyapa_default_irq_handler(struct cyapa *cyapa)
 {
-       u8 query_data[QUERY_DATA_SIZE];
-       int ret;
-
-       if (cyapa->state !=3D CYAPA_STATE_OP)
-               return -EBUSY;
-
-       ret =3D cyapa_read_block(cyapa, CYAPA_CMD_GROUP_QUERY, query_data);
-       if (ret < 0)
-               return ret;
-       if (ret !=3D QUERY_DATA_SIZE)
-               return -EIO;
-
-       memcpy(&cyapa->product_id[0], &query_data[0], 5);
-       cyapa->product_id[5] =3D '-';
-       memcpy(&cyapa->product_id[6], &query_data[5], 6);
-       cyapa->product_id[12] =3D '-';
-       memcpy(&cyapa->product_id[13], &query_data[11], 2);
-       cyapa->product_id[15] =3D '\0';
-
-       cyapa->btn_capability =3D query_data[19] & CAPABILITY_BTN_MASK;
-
-       cyapa->gen =3D query_data[20] & 0x0f;
-
-       cyapa->max_abs_x =3D ((query_data[21] & 0xf0) << 4) | query_data[22=
];
-       cyapa->max_abs_y =3D ((query_data[21] & 0x0f) << 8) | query_data[23=
];
-
-       cyapa->physical_size_x =3D
-               ((query_data[24] & 0xf0) << 4) | query_data[25];
-       cyapa->physical_size_y =3D
-               ((query_data[24] & 0x0f) << 8) | query_data[26];
-
-       return 0;
+       /* do redetecting when device states is still unknown and
+        * interrupt envent is received from device. */
+       async_schedule(cyapa_detect_async, cyapa);
 }

-/*
- * Check if device is operational.
- *
- * An operational device is responding, has exited bootloader, and has
- * firmware supported by this driver.
- *
- * Returns:
- *   -EBUSY  no device or in bootloader
- *   -EIO    failure while reading from device
- *   -EAGAIN device is still in bootloader
- *           if ->state =3D CYAPA_STATE_BL_IDLE, device has invalid firmwa=
re
- *   -EINVAL device is in operational mode, but not supported by this driv=
er
- *   0       device is supported
- */
-static int cyapa_check_is_operational(struct cyapa *cyapa)
-{
-       struct device *dev =3D &cyapa->client->dev;
-       static const char unique_str[] =3D "CYTRA";
-       int ret;
-
-       ret =3D cyapa_poll_state(cyapa, 2000);
-       if (ret < 0)
-               return ret;
-       switch (cyapa->state) {
-       case CYAPA_STATE_BL_ACTIVE:
-               ret =3D cyapa_bl_deactivate(cyapa);
-               if (ret)
-                       return ret;
-
-       /* Fallthrough state */
-       case CYAPA_STATE_BL_IDLE:
-               ret =3D cyapa_bl_exit(cyapa);
-               if (ret)
-                       return ret;
+const struct cyapa_dev_ops cyapa_default_ops =3D {
+       NULL,
+       NULL,

-       /* Fallthrough state */
-       case CYAPA_STATE_OP:
-               ret =3D cyapa_get_query_data(cyapa);
-               if (ret < 0)
-                       return ret;
+       NULL,
+       NULL,

-               /* only support firmware protocol gen3 */
-               if (cyapa->gen !=3D CYAPA_GEN3) {
-                       dev_err(dev, "unsupported protocol version (%d)",
-                               cyapa->gen);
-                       return -EINVAL;
-               }
+       cyapa_default_irq_handler,
+       NULL,
+       NULL,

-               /* only support product ID starting with CYTRA */
-               if (memcmp(cyapa->product_id, unique_str,
-                          sizeof(unique_str) - 1) !=3D 0) {
-                       dev_err(dev, "unsupported product ID (%s)\n",
-                               cyapa->product_id);
-                       return -EINVAL;
-               }
-               return 0;
-
-       default:
-               return -EIO;
-       }
-       return 0;
-}
-
-static irqreturn_t cyapa_irq(int irq, void *dev_id)
-{
-       struct cyapa *cyapa =3D dev_id;
-       struct device *dev =3D &cyapa->client->dev;
-       struct input_dev *input =3D cyapa->input;
-       struct cyapa_reg_data data;
-       int i;
-       int ret;
-       int num_fingers;
-
-       if (device_may_wakeup(dev))
-               pm_wakeup_event(dev, 0);
-
-       ret =3D cyapa_read_block(cyapa, CYAPA_CMD_GROUP_DATA, (u8 *)&data);
-       if (ret !=3D sizeof(data))
-               goto out;
-
-       if ((data.device_status & OP_STATUS_SRC) !=3D OP_STATUS_SRC ||
-           (data.device_status & OP_STATUS_DEV) !=3D CYAPA_DEV_NORMAL ||
-           (data.finger_btn & OP_DATA_VALID) !=3D OP_DATA_VALID) {
-               goto out;
-       }
-
-       num_fingers =3D (data.finger_btn >> 4) & 0x0f;
-       for (i =3D 0; i < num_fingers; i++) {
-               const struct cyapa_touch *touch =3D &data.touches[i];
-               /* Note: touch->id range is 1 to 15; slots are 0 to 14. */
-               int slot =3D touch->id - 1;
-
-               input_mt_slot(input, slot);
-               input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
-               input_report_abs(input, ABS_MT_POSITION_X,
-                                ((touch->xy_hi & 0xf0) << 4) | touch->x_lo=
);
-               input_report_abs(input, ABS_MT_POSITION_Y,
-                                ((touch->xy_hi & 0x0f) << 8) | touch->y_lo=
);
-               input_report_abs(input, ABS_MT_PRESSURE, touch->pressure);
-       }
-
-       input_mt_sync_frame(input);
-
-       if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK)
-               input_report_key(input, BTN_LEFT,
-                                data.finger_btn & OP_DATA_LEFT_BTN);
-
-       if (cyapa->btn_capability & CAPABILITY_MIDDLE_BTN_MASK)
-               input_report_key(input, BTN_MIDDLE,
-                                data.finger_btn & OP_DATA_MIDDLE_BTN);
-
-       if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK)
-               input_report_key(input, BTN_RIGHT,
-                                data.finger_btn & OP_DATA_RIGHT_BTN);
-
-       input_sync(input);
+       NULL,
+};

-out:
-       return IRQ_HANDLED;
-}

 static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
 {
@@ -784,7 +246,27 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
                             0);
        input_set_abs_params(input, ABS_MT_POSITION_Y, 0, cyapa->max_abs_y,=
 0,
                             0);
-       input_set_abs_params(input, ABS_MT_PRESSURE, 0, 255, 0, 0);
+       input_set_abs_params(input, ABS_MT_PRESSURE, 0, cyapa->max_z, 0, 0)=
;
+       if (cyapa->gen > CYAPA_GEN3) {
+               input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, =
0);
+               input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 0, =
0);
+               /* orientation is the angle between the vertial axis and
+                * the major axis of the contact ellipse.
+                * The range is -127 to 127.
+                * the positive direction is clockwise form the vertical ax=
is.
+                * If the ellipse of contact degenerates into a circle,
+                * orientation is reported as 0.
+                *
+                * Also, for Gen5 trackpad the accurate of this orientation
+                * value is value + (-30 ~ 30).
+                */
+               input_set_abs_params(input, ABS_MT_ORIENTATION,
+                               -127, 127, 0, 0);
+       }
+       if (cyapa->gen >=3D CYAPA_GEN5) {
+               input_set_abs_params(input, ABS_MT_WIDTH_MAJOR, 0, 255, 0, =
0);
+               input_set_abs_params(input, ABS_MT_WIDTH_MINOR, 0, 255, 0, =
0);
+       }

        input_abs_set_res(input, ABS_MT_POSITION_X,
                          cyapa->max_abs_x / cyapa->physical_size_x);
@@ -823,6 +305,214 @@ err_free_device:
        return ret;
 }

+/*
+ * Check if device is operational.
+ *
+ * An operational device is responding, has exited bootloader, and has
+ * firmware supported by this driver.
+ *
+ * Returns:
+ *   -EBUSY  no device or in bootloader
+ *   -EIO    failure while reading from device
+ *   -EAGAIN device is still in bootloader
+ *           if ->state =3D CYAPA_STATE_BL_IDLE, device has invalid firmwa=
re
+ *   -EINVAL device is in operational mode, but not supported by this driv=
er
+ *   0       device is supported
+ */
+static int cyapa_check_is_operational(struct cyapa *cyapa)
+{
+       int ret;
+
+       ret =3D cyapa_poll_state(cyapa, 4000);
+       if (ret)
+               return ret;
+
+       switch (cyapa->gen) {
+       default:
+               cyapa->ops =3D &cyapa_default_ops;
+               cyapa->gen =3D CYAPA_GEN_UNKNOWN;
+               break;
+       }
+
+       if (cyapa->ops->cyapa_operational_check)
+               ret =3D cyapa->ops->cyapa_operational_check(cyapa);
+       else
+               ret =3D -EBUSY;
+
+       return ret;
+}
+
+
+static irqreturn_t cyapa_irq(int irq, void *dev_id)
+{
+       struct cyapa *cyapa =3D dev_id;
+       struct input_dev *input =3D cyapa->input;
+       bool cont;
+
+       /* interrupt event maybe cuased by host command to trackpad device.=
 */
+       cont =3D true;
+       if (cyapa->ops->cyapa_irq_cmd_handler)
+               cont =3D cyapa->ops->cyapa_irq_cmd_handler(cyapa);
+
+       /* interrupt event maybe from trackpad device input reporting. */
+       if (cont && cyapa->ops->cyapa_irq_handler) {
+               if (!cyapa_state_sync_enter(cyapa)) {
+                       if (cyapa->ops->cyapa_sort_empty_output_data)
+                               cyapa->ops->cyapa_sort_empty_output_data(cy=
apa,
+                                       NULL, NULL, NULL);
+                       goto out;
+               }
+
+               if (!input && cyapa->ops->cyapa_sort_empty_output_data) {
+                       cyapa->ops->cyapa_sort_empty_output_data(cyapa,
+                               NULL, NULL, NULL);
+                       goto out;
+               }
+
+               cyapa->ops->cyapa_irq_handler(cyapa);
+
+               cyapa_state_sync_exit(cyapa);
+       }
+out:
+       return IRQ_HANDLED;
+}
+
+/*
+ * Query device for its current operating state.
+ *
+ */
+static int cyapa_get_state(struct cyapa *cyapa)
+{
+       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+
+       return -ENODEV;
+}
+
+/*
+ * Poll device for its status in a loop, waiting up to timeout for a respo=
nse.
+ *
+ * When the device switches state, it usually takes ~300 ms.
+ * However, when running a new firmware image, the device must calibrate i=
ts
+ * sensors, which can take as long as 2 seconds.
+ *
+ * Note: The timeout has granularity of the polling rate, which is 100 ms.
+ *
+ * Returns:
+ *   0 when the device eventually responds with a valid non-busy state.
+ *   -ETIMEDOUT if device never responds (too many -EAGAIN)
+ *   < 0    other errors
+ */
+int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
+{
+       int ret;
+       int tries =3D timeout / 100;
+
+       ret =3D cyapa_get_state(cyapa);
+       while ((ret || cyapa->state >=3D CYAPA_STATE_BL_BUSY) && tries--) {
+               msleep(100);
+               ret =3D cyapa_get_state(cyapa);
+       }
+
+       return (ret =3D=3D -EAGAIN || ret =3D=3D -ETIMEDOUT) ? -ETIMEDOUT :=
 ret;
+}
+
+static void cyapa_detect(struct cyapa *cyapa)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       char *envp[2] =3D {"ERROR=3D1", NULL};
+       int ret;
+
+       ret =3D cyapa_check_is_operational(cyapa);
+       if (ret =3D=3D -ETIMEDOUT)
+               dev_err(dev, "no device detected, %d\n", ret);
+       else if (ret)
+               dev_err(dev, "device detected, but not operational, %d\n", =
ret);
+
+       if (ret) {
+               kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+               return;
+       }
+
+       if (!cyapa->input) {
+               ret =3D cyapa_create_input_dev(cyapa);
+               if (ret)
+                       dev_err(dev, "create input_dev instance failed, %d\=
n",
+                               ret);
+
+               cyapa_enable_irq(cyapa);
+
+               /*
+                * On some systems, a system crash / warm boot does not res=
et
+                * the device's current power mode to FULL_ACTIVE.
+                * If such an event happens during suspend, after the devic=
e
+                * has been put in a low power mode, the device will still =
be
+                * in low power mode on a subsequent boot, since there was
+                * never a matching resume().
+                * Handle this by always forcing full power here, when a
+                * device is first detected to be in operational mode.
+                */
+               if (cyapa->ops->cyapa_set_power_mode) {
+                       ret =3D cyapa->ops->cyapa_set_power_mode(cyapa,
+                                       PWR_MODE_FULL_ACTIVE, 0);
+                       if (ret)
+                               dev_warn(dev, "set active power failed, %d\=
n",
+                                               ret);
+               }
+       }
+}
+
+/*
+ * cyapa_sleep_time_to_pwr_cmd and cyapa_pwr_cmd_to_sleep_time
+ *
+ * These are helper functions that convert to and from integer idle
+ * times and register settings to write to the PowerMode register.
+ * The trackpad supports between 20ms to 1000ms scan intervals.
+ * The time will be increased in increments of 10ms from 20ms to 100ms.
+ * From 100ms to 1000ms, time will be increased in increments of 20ms.
+ *
+ * When Idle_Time < 100, the format to convert Idle_Time to Idle_Command i=
s:
+ *   Idle_Command =3D Idle Time / 10;
+ * When Idle_Time >=3D 100, the format to convert Idle_Time to Idle_Comman=
d is:
+ *   Idle_Command =3D Idle Time / 20 + 5;
+ */
+u8 cyapa_sleep_time_to_pwr_cmd(u16 sleep_time)
+{
+       if (sleep_time < 20)
+               sleep_time =3D 20;     /* minimal sleep time. */
+       else if (sleep_time > 1000)
+               sleep_time =3D 1000;   /* maximal sleep time. */
+
+       if (sleep_time < 100)
+               return ((sleep_time / 10) << 2) & PWR_MODE_MASK;
+       else
+               return ((sleep_time / 20 + 5) << 2) & PWR_MODE_MASK;
+}
+
+u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode)
+{
+       u8 encoded_time =3D pwr_mode >> 2;
+       return (encoded_time < 10) ? encoded_time * 10
+                                  : (encoded_time - 5) * 20;
+}
+
+void cyapa_detect_async(void *data, async_cookie_t cookie)
+{
+       struct cyapa *cyapa =3D (struct cyapa *)data;
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return;
+
+       /* keep synchnized with sys interface process threads. */
+       cyapa_detect(cyapa);
+
+       cyapa_state_sync_exit(cyapa);
+}
+
+static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
+{
+       cyapa_detect_async(data, cookie);
+}
+
 static int cyapa_probe(struct i2c_client *client,
                       const struct i2c_device_id *dev_id)
 {
@@ -830,6 +520,7 @@ static int cyapa_probe(struct i2c_client *client,
        u8 adapter_func;
        struct cyapa *cyapa;
        struct device *dev =3D &client->dev;
+       union i2c_smbus_data dummy;

        adapter_func =3D cyapa_check_adapter_functionality(client);
        if (adapter_func =3D=3D CYAPA_ADAPTER_FUNC_NONE) {
@@ -837,41 +528,41 @@ static int cyapa_probe(struct i2c_client *client,
                return -EIO;
        }

+       /* Make sure there is something at this address */
+       if (dev->of_node && i2c_smbus_xfer(client->adapter, client->addr, 0=
,
+                       I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &dummy) < 0)
+               return -ENODEV;
+
        cyapa =3D kzalloc(sizeof(struct cyapa), GFP_KERNEL);
        if (!cyapa) {
                dev_err(dev, "allocate memory for cyapa failed\n");
                return -ENOMEM;
        }

-       cyapa->gen =3D CYAPA_GEN3;
        cyapa->client =3D client;
        i2c_set_clientdata(client, cyapa);
        sprintf(cyapa->phys, "i2c-%d-%04x/input0", client->adapter->nr,
                client->addr);

+       cyapa->ops =3D &cyapa_default_ops;
+       cyapa->in_syncing =3D false;
+       mutex_init(&cyapa->state_sync_lock);
+       cyapa->gen =3D CYAPA_GEN_UNKNOWN;
+       mutex_init(&cyapa->state_sync_lock);
+       mutex_init(&cyapa->irq_state_lock);
+
        /* i2c isn't supported, use smbus */
        if (adapter_func =3D=3D CYAPA_ADAPTER_FUNC_SMBUS)
                cyapa->smbus =3D true;
        cyapa->state =3D CYAPA_STATE_NO_DEVICE;
-       ret =3D cyapa_check_is_operational(cyapa);
-       if (ret) {
-               dev_err(dev, "device not operational, %d\n", ret);
-               goto err_mem_free;
-       }
-
-       ret =3D cyapa_create_input_dev(cyapa);
-       if (ret) {
-               dev_err(dev, "create input_dev instance failed, %d\n", ret)=
;
-               goto err_mem_free;
-       }
-
-       ret =3D cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
-       if (ret) {
-               dev_err(dev, "set active power failed, %d\n", ret);
-               goto err_unregister_device;
-       }
+       /* set to hard code default, they will be updated with trackpad set
+        * default values after probe and initialized. */
+       cyapa->suspend_power_mode =3D PWR_MODE_SLEEP;
+       cyapa->suspend_sleep_time =3D
+               cyapa_pwr_cmd_to_sleep_time(cyapa->suspend_power_mode);

        cyapa->irq =3D client->irq;
+       cyapa->irq_enabled =3D true;
        ret =3D request_threaded_irq(cyapa->irq,
                                   NULL,
                                   cyapa_irq,
@@ -882,12 +573,14 @@ static int cyapa_probe(struct i2c_client *client,
                dev_err(dev, "IRQ request failed: %d\n, ", ret);
                goto err_unregister_device;
        }
+       cyapa_disable_irq(cyapa);

+       async_schedule(cyapa_detect_and_start, cyapa);
        return 0;

 err_unregister_device:
        input_unregister_device(cyapa->input);
-err_mem_free:
+       i2c_set_clientdata(client, NULL);
        kfree(cyapa);

        return ret;
@@ -898,8 +591,11 @@ static int cyapa_remove(struct i2c_client *client)
        struct cyapa *cyapa =3D i2c_get_clientdata(client);

        free_irq(cyapa->irq, cyapa);
+
        input_unregister_device(cyapa->input);
-       cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
+       if (cyapa->ops->cyapa_set_power_mode)
+               cyapa->ops->cyapa_set_power_mode(cyapa, PWR_MODE_OFF, 0);
+       i2c_set_clientdata(client, NULL);
        kfree(cyapa);

        return 0;
@@ -912,17 +608,21 @@ static int cyapa_suspend(struct device *dev)
        u8 power_mode;
        struct cyapa *cyapa =3D dev_get_drvdata(dev);

-       disable_irq(cyapa->irq);
+       cyapa_disable_irq(cyapa);

        /*
         * Set trackpad device to idle mode if wakeup is allowed,
         * otherwise turn off.
         */
-       power_mode =3D device_may_wakeup(dev) ? PWR_MODE_IDLE
+       power_mode =3D device_may_wakeup(dev) ? cyapa->suspend_power_mode
                                            : PWR_MODE_OFF;
-       ret =3D cyapa_set_power_mode(cyapa, power_mode);
-       if (ret < 0)
-               dev_err(dev, "set power mode failed, %d\n", ret);
+       if (cyapa->ops->cyapa_set_power_mode) {
+               ret =3D cyapa->ops->cyapa_set_power_mode(cyapa, power_mode,
+                               cyapa->suspend_sleep_time);
+               if (ret < 0)
+                       dev_err(dev, "suspend set power mode failed, %d\n",
+                                       ret);
+       }

        if (device_may_wakeup(dev))
                cyapa->irq_wake =3D (enable_irq_wake(cyapa->irq) =3D=3D 0);
@@ -936,17 +636,24 @@ static int cyapa_resume(struct device *dev)

        if (device_may_wakeup(dev) && cyapa->irq_wake)
                disable_irq_wake(cyapa->irq);
+       cyapa_enable_irq(cyapa);

-       ret =3D cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
-       if (ret)
-               dev_warn(dev, "resume active power failed, %d\n", ret);
+       if (cyapa->ops->cyapa_set_power_mode) {
+               ret =3D cyapa->ops->cyapa_set_power_mode(cyapa,
+                       PWR_MODE_FULL_ACTIVE, 0);
+               if (ret)
+                       dev_warn(dev, "resume active power failed, %d\n", r=
et);
+       }
+
+       async_schedule(cyapa_detect_async, cyapa);

-       enable_irq(cyapa->irq);
        return 0;
 }
 #endif /* CONFIG_PM_SLEEP */

-static SIMPLE_DEV_PM_OPS(cyapa_pm_ops, cyapa_suspend, cyapa_resume);
+static const struct dev_pm_ops cyapa_pm_ops =3D {
+       SET_SYSTEM_SLEEP_PM_OPS(cyapa_suspend, cyapa_resume)
+};

 static const struct i2c_device_id cyapa_id_table[] =3D {
        { "cyapa", 0 },
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
new file mode 100644
index 0000000..1780d82
--- /dev/null
+++ b/drivers/input/mouse/cyapa.h
@@ -0,0 +1,265 @@
+/*
+ * Cypress APA trackpad with I2C interface
+ *
+ * Author: Dudley Du <dudl@cypress.com>
+ *
+ * Copyright (C) 2014-2015 Cypress Semiconductor, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Pub=
lic
+ * License.  See the file COPYING in the main directory of this archive fo=
r
+ * more details.
+ */
+
+#ifndef _CYAPA_H
+#define _CYAPA_H
+
+#include <linux/async.h>
+#include <linux/firmware.h>
+
+/* APA trackpad firmware generation number. */
+#define CYAPA_GEN_UNKNOWN   0x00   /* unknown protocol. */
+#define CYAPA_GEN3   0x03   /* support MT-protocol B with tracking ID. */
+#define CYAPA_GEN5   0x05   /* support TrueTouch GEN5 trackpad device. */
+
+#define CYAPA_NAME   "Cypress APA Trackpad (cyapa)"
+
+/*
+ * macros for SMBus communication
+ */
+#define SMBUS_READ   0x01
+#define SMBUS_WRITE 0x00
+#define SMBUS_ENCODE_IDX(cmd, idx) ((cmd) | (((idx) & 0x03) << 1))
+#define SMBUS_ENCODE_RW(cmd, rw) ((cmd) | ((rw) & 0x01))
+#define SMBUS_BYTE_BLOCK_CMD_MASK 0x80
+#define SMBUS_GROUP_BLOCK_CMD_MASK 0x40
+
+/* commands for read/write registers of Cypress trackpad */
+#define CYAPA_CMD_SOFT_RESET       0x00
+#define CYAPA_CMD_POWER_MODE       0x01
+#define CYAPA_CMD_DEV_STATUS       0x02
+#define CYAPA_CMD_GROUP_DATA       0x03
+#define CYAPA_CMD_GROUP_CMD        0x04
+#define CYAPA_CMD_GROUP_QUERY      0x05
+#define CYAPA_CMD_BL_STATUS        0x06
+#define CYAPA_CMD_BL_HEAD          0x07
+#define CYAPA_CMD_BL_CMD           0x08
+#define CYAPA_CMD_BL_DATA          0x09
+#define CYAPA_CMD_BL_ALL           0x0a
+#define CYAPA_CMD_BLK_PRODUCT_ID   0x0b
+#define CYAPA_CMD_BLK_HEAD         0x0c
+#define CYAPA_CMD_MAX_BASELINE     0x0d
+#define CYAPA_CMD_MIN_BASELINE     0x0e
+
+#define BL_HEAD_OFFSET 0x00
+#define BL_DATA_OFFSET 0x10
+
+#define BL_STATUS_SIZE  3  /* length of gen3 bootloader status registers *=
/
+#define CYAPA_REG_MAP_SIZE  256
+
+/*
+ * Gen3 Operational Device Status Register
+ *
+ * bit 7: Valid interrupt source
+ * bit 6 - 4: Reserved
+ * bit 3 - 2: Power status
+ * bit 1 - 0: Device status
+ */
+#define REG_OP_STATUS     0x00
+#define OP_STATUS_SRC     0x80
+#define OP_STATUS_POWER   0x0c
+#define OP_STATUS_DEV     0x03
+#define OP_STATUS_MASK (OP_STATUS_SRC | OP_STATUS_POWER | OP_STATUS_DEV)
+
+/*
+ * Operational Finger Count/Button Flags Register
+ *
+ * bit 7 - 4: Number of touched finger
+ * bit 3: Valid data
+ * bit 2: Middle Physical Button
+ * bit 1: Right Physical Button
+ * bit 0: Left physical Button
+ */
+#define REG_OP_DATA1       0x01
+#define OP_DATA_VALID      0x08
+#define OP_DATA_MIDDLE_BTN 0x04
+#define OP_DATA_RIGHT_BTN  0x02
+#define OP_DATA_LEFT_BTN   0x01
+#define OP_DATA_BTN_MASK (OP_DATA_MIDDLE_BTN | OP_DATA_RIGHT_BTN | \
+                         OP_DATA_LEFT_BTN)
+
+/*
+ * Bootloader Status Register
+ *
+ * bit 7: Busy
+ * bit 6 - 5: Reserved
+ * bit 4: Bootloader running
+ * bit 3 - 2: Reserved
+ * bit 1: Watchdog Reset
+ * bit 0: Checksum valid
+ */
+#define REG_BL_STATUS        0x01
+#define BL_STATUS_REV_6_5    0x60
+#define BL_STATUS_BUSY       0x80
+#define BL_STATUS_RUNNING    0x10
+#define BL_STATUS_REV_3_2    0x0c
+#define BL_STATUS_WATCHDOG   0x02
+#define BL_STATUS_CSUM_VALID 0x01
+#define BL_STATUS_REV_MASK (BL_STATUS_WATCHDOG | BL_STATUS_REV_3_2 | \
+                           BL_STATUS_REV_6_5)
+
+/*
+ * Bootloader Error Register
+ *
+ * bit 7: Invalid
+ * bit 6: Invalid security key
+ * bit 5: Bootloading
+ * bit 4: Command checksum
+ * bit 3: Flash protection error
+ * bit 2: Flash checksum error
+ * bit 1 - 0: Reserved
+ */
+#define REG_BL_ERROR         0x02
+#define BL_ERROR_INVALID     0x80
+#define BL_ERROR_INVALID_KEY 0x40
+#define BL_ERROR_BOOTLOADING 0x20
+#define BL_ERROR_CMD_CSUM    0x10
+#define BL_ERROR_FLASH_PROT  0x08
+#define BL_ERROR_FLASH_CSUM  0x04
+#define BL_ERROR_RESERVED    0x03
+
+#define CAPABILITY_LEFT_BTN_MASK       (0x01 << 3)
+#define CAPABILITY_RIGHT_BTN_MASK      (0x01 << 4)
+#define CAPABILITY_MIDDLE_BTN_MASK     (0x01 << 5)
+#define CAPABILITY_BTN_MASK  (CAPABILITY_LEFT_BTN_MASK | \
+                             CAPABILITY_RIGHT_BTN_MASK | \
+                             CAPABILITY_MIDDLE_BTN_MASK)
+
+#define PWR_MODE_MASK   0xfc
+#define PWR_MODE_FULL_ACTIVE (0x3f << 2)
+#define PWR_MODE_IDLE        (0x03 << 2) /* default rt suspend scanrate: 3=
0ms */
+#define PWR_MODE_SLEEP       (0x05 << 2) /* default suspend scanrate: 50ms=
 */
+#define PWR_MODE_BTN_ONLY    (0x01 << 2)
+#define PWR_MODE_OFF         (0x00 << 2)
+
+#define PWR_STATUS_MASK      0x0c
+#define PWR_STATUS_ACTIVE    (0x03 << 2)
+#define PWR_STATUS_IDLE      (0x02 << 2)
+#define PWR_STATUS_BTN_ONLY  (0x01 << 2)
+#define PWR_STATUS_OFF       (0x00 << 2)
+
+#define AUTOSUSPEND_DELAY   2000 /* unit : ms */
+
+#define BTN_ONLY_MODE_NAME   "buttononly"
+#define OFF_MODE_NAME        "off"
+
+/* The touch.id is used as the MT slot id, thus max MT slot is 15 */
+#define CYAPA_MAX_MT_SLOTS  15
+
+struct cyapa;
+
+typedef bool (*cb_sort)(struct cyapa *, u8 *, int);
+
+struct cyapa_dev_ops {
+       size_t (*cyapa_get_private_size)(void);
+       int (*cyapa_private_init)(struct cyapa *cyapa, void *private_mem);
+
+       int (*cyapa_state_parse)(struct cyapa *cyapa, u8 *reg_status, int l=
en);
+       int (*cyapa_operational_check)(struct cyapa *cyapa);
+
+       void (*cyapa_irq_handler)(struct cyapa *);
+       bool (*cyapa_irq_cmd_handler)(struct cyapa *);
+       int (*cyapa_sort_empty_output_data)(struct cyapa *,
+                       u8 *, int *, cb_sort);
+
+       int (*cyapa_set_power_mode)(struct cyapa *, u8, u16);
+};
+
+enum cyapa_state {
+       CYAPA_STATE_OP,
+       CYAPA_STATE_BL_IDLE,
+       CYAPA_STATE_BL_ACTIVE,
+       CYAPA_STATE_GEN5_BL,
+       CYAPA_STATE_GEN5_APP,
+       CYAPA_STATE_BL_BUSY,
+       CYAPA_STATE_NO_DEVICE,
+};
+
+/* The main device structure */
+struct cyapa {
+       enum cyapa_state state;
+       u8 status[BL_STATUS_SIZE];
+
+       struct i2c_client *client;
+       struct input_dev *input;
+       char phys[32];  /* device physical location */
+       int irq;
+       bool irq_wake;  /* irq wake is enabled */
+       bool smbus;
+
+       /* power mode settings */
+       u8 suspend_power_mode;
+       u16 suspend_sleep_time;
+
+       /* read from query data region. */
+       char product_id[16];
+       u8 fw_maj_ver;  /* firmware major version. */
+       u8 fw_min_ver;  /* firmware minor version. */
+       u8 btn_capability;
+       u8 gen;
+       int max_abs_x;
+       int max_abs_y;
+       int physical_size_x;
+       int physical_size_y;
+
+       /* used in ttsp and truetouch based trackpad devices. */
+       u8 x_origin;  /* X Axis Origin: 0 =3D left side; 1 =3D rigth side. =
*/
+       u8 y_origin;  /* Y Axis Origin: 0 =3D top; 1 =3D bottom. */
+       int electrodes_x;  /* Number of electrodes on the X Axis*/
+       int electrodes_y;  /* Number of electrodes on the Y Axis*/
+       int electrodes_rx;  /* Number of Rx electrodes */
+       int max_z;
+
+       struct mutex state_sync_lock;
+       bool in_syncing;
+
+       /* record irq disabled/enable state. */
+       struct mutex irq_state_lock;
+       bool irq_enabled;
+       bool prev_irq_enabled;
+
+       const struct cyapa_dev_ops *ops;
+};
+
+
+void cyapa_enable_irq(struct cyapa *cyapa);
+void cyapa_disable_irq(struct cyapa *cyapa);
+void cyapa_enable_irq_save(struct cyapa *cyapa);
+void cyapa_disable_irq_save(struct cyapa *cyapa);
+void cyapa_irq_restore(struct cyapa *cyapa);
+bool cyapa_is_irq_enabled(struct cyapa *cyapa);
+
+ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
+                               u8 *values);
+ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
+                               size_t len, const u8 *values);
+ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
+                               u8 *values);
+
+s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx);
+s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value);
+ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values);
+
+ssize_t cyapa_i2c_read(struct cyapa *cyapa, u8 reg, size_t len, u8 *values=
);
+ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
+                               size_t len, const u8 *values);
+
+int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout);
+void cyapa_detect_async(void *data, async_cookie_t cookie);
+
+u8 cyapa_sleep_time_to_pwr_cmd(u16 sleep_time);
+u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode);
+
+
+extern const char unique_str[];
+
+#endif
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406B897S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IpZMAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAAEEwNjYwOEU3
MUExNzNGNDNBREI1NThFRjQ0NEU3OUQ0ADgHAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBgAGAAcA
HAAgAAUAOQEBIIADAA4AAADeBwYABgAHABwAIAAFADkBAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAF4AAABbUEFUQ0ggdjIgMS8xNF0gaW5wdXQ6IGN5YXBhOiByZS1hcmNo
aXRlY3R1cmUgZHJpdmVyIHRvIHN1cHBvcnQgbXVsdGktdHJhY2twYWRzIGluIG9uZSBkcml2ZXIA
FCEBA5AGABxcAABLAAAAAgF/AAEAAABCAAAAPDc3QkM3MjVDOTA2Mjc2NEY4NzRENzlGNTFFMUYx
QThGNDQwNkI4OTdAUzA0LU1CWDAxLTAxLnMwNC5sb2NhbD4AAAALAB8OAQAAAAIBCRABAAAAjk8A
AIpPAACo9wAATFpGdTldwm9hAApmYmlkBAAAY2PAcGcxMjUyAP4DQ/B0ZXh0AfcCpAPjAgAEY2gK
wHNldDAg7wdtAoMAUBFNMgqABrQCgJZ9CoAIyDsJYjE5DsC/CcMWcgoyFnECgBViKgmwcwnwBJBh
dAWyDlADYHOibwGAIEV4EcFuGDBdBlJ2BJAXtgIQcgDAdH0IUG4aMRAgBcAFoBtkZJogA1IgECIX
slx2CJDkd2sLgGQ1HVME8AdADRdwMApxF/Jia21rBnMBkAAgIEJNX0LgRUdJTn0K/AHxC/E8IEkD
oAWwBIEcwG8gsHN1cHAJERzAdyJAPw3gASAEkAnwBUAFoG1tJnUDAB5QdGkCICBwxwNgGJAI4SBi
YRIAHGCydBhwY2sKsAswbAuA7mUKgAEAHWBjGeALgCHAUxhQG9B5YQqwLBzAaP8Z4BhQB+AnYyMQ
BRAaMSbg2wQgCXAtAQAAkGcYUBxg/wPwJ9AmFScnKKYFoRngAHBnJXEi8iaTcycccCQAY78kUgQg
I8EikBhQAjAuJhX+VCfhKw8pEhvhAZAmMRxg7ybxJ9ApIQqwdBHAJ7AqIP8iUyYgB5En0iUxDlAm
FS02syoDJuFwdQVALCJrBJHSZQMgc3kfYGUcsCwi9wdAGSAskWYwwyfSC4Abof5mANAHkCYVJ9AY
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
AQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAOVfAQAAACoAAABz
AGkAcAA6AGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AGgwBAAAAFAAAAEQA
dQBkAGwAZQB5ACAARAB1AAAAHwAfDAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBj
AG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABYAAAAAAAAAIErH6S+oxAZ
nW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBw
AHIAZQBzAHMALgBjAG8AbQAAAB8AAV0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4A
YwBvAG0AAAAAAB8A+D8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAHwAjQAEAAAAiAAAAZAB1
AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAA
AgH5PwEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABEAHUAAABT
AE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8ACV0BAAAAIgAAAGQA
dQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AMUABAAAAAgAAAAAAAAALAEA6AQAA
AB8AMEABAAAAAgAAAAAAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8ECAAA
CwBAOgEAAAADAP0/qAMAAAIBCzABAAAAEAAAAKBmCOcaFz9DrbVY70ROedQDABcAAQAAAEAAOQAA
EDHrWIHPAUAACDBtxmvrWIHPAQsAKQAAAAAACwAjAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEA
AAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAAGgAAAHoAaAAtAEMATgAs
ACAAZQBuAC0AVQBTAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAA
vAAAAFsAUABBAFQAQwBIACAAdgAyACAAMQAvADEANABdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBw
AGEAOgAgAHIAZQAtAGEAcgBjAGgAaQB0AGUAYwB0AHUAcgBlACAAZAByAGkAdgBlAHIAIAB0AG8A
IABzAHUAcABwAG8AcgB0ACAAbQB1AGwAdABpAC0AdAByAGEAYwBrAHAAYQBkAHMAIABpAG4AIABv
AG4AZQAgAGQAcgBpAHYAZQByAAAAHwA9AAEAAAACAAAAAAAAAAMANgAAAAAAAgFxAAEAAAAWAAAA
Ac+BWOPDpsXwZFzKTQikGLKtbJwV3QAAHwBwAAEAAAC8AAAAWwBQAEEAVABDAEgAIAB2ADIAIAAx
AC8AMQA0AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6ACAAcgBlAC0AYQByAGMAaABpAHQA
ZQBjAHQAdQByAGUAIABkAHIAaQB2AGUAcgAgAHQAbwAgAHMAdQBwAHAAbwByAHQAIABtAHUAbAB0
AGkALQB0AHIAYQBjAGsAcABhAGQAcwAgAGkAbgAgAG8AbgBlACAAZAByAGkAdgBlAHIAAAAfADUQ
AQAAAIQAAAA8ADcANwBCAEMANwAyADUAQwA5ADAANgAyADcANgA0AEYAOAA3ADQARAA3ADkARgA1
ADEARQAxAEYAMQBBADgARgA0ADQAMAA2AEIAOAA5ADcAQABTADAANAAtAE0AQgBYADAAMQAtADAA
MQAuAHMAMAA0AC4AbABvAGMAYQBsAD4AAAADAN4/n04AAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAA
AAOFAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAAYUAAAAAAAADAACAAyAGAAAAAADAAAAA
AAAARgAAAAABgQAAAAAAAAMAgBD/////BQAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAoEAAAAAAAAA
AAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAHIEAAAAAAABAAAcw2OMb51iBzwELAAIAAQAAAAMA
JgAAAAAAAgEQMAEAAABGAAAAAAAAALEfoTkwIFFGnbSlcN7Qn9QHAHe8clyQYnZPh0159R4fGo8A
AACZPBsAALqnPu7L1/dAo3bvNfxhWYkAGIP8w0YAAAAAHwD6PwEAAAAUAAAARAB1AGQAbABlAHkA
IABEAHUAAAADAAlZAQAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABCFAAAAAAAAHwAAgB+k6zOo
ei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIA
YQBjAGsAaQBuAGcARQB4AAAAAQAAALoAAABJAEkAPQAwADEAQwBGADgAMQA1ADgARQAzAEMAMwBB
ADYAQwA1AEYAMAA2ADQANQBDAEMAQQA0AEQAMAA4AEEANAAxADgAQgAyAEEARAA2AEMAOQBDADEA
NQBEAEQAOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADMAIAAoAEIAdQBp
AGwAZAAgADEANwA0AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADQAAAAAAAMAAIADIAYAAAAAAMAA
AAAAAABGAAAAABOBAAABAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAI4EAAP///38DAACAAyAG
AAAAAADAAAAAAAAARgAAAAAQgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABGBAAAAAAAA
CwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJIEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAs
gQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACmBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAKoEAAAAAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAngQAAAQAAAAIAAAAAAAAAAwAA
gAMgBgAAAAAAwAAAAAAAAEYAAAAAEoEAAAEAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAhgQAA
AQAAAAIAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAA4EAAAAAAAALAACAAyAGAAAAAADA
AAAAAAAARgAAAAAmgQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAA6FAAAAAAAAAwAAgAgg
BgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAACChQAAAAAA
AEAAAIAIIAYAAAAAAMAAAAAAAABGAAAAAL+FAADQsQkqV4HPAQMADTT9PwAAHwAAgIYDAgAAAAAA
wAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAA
AAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcA
LQBpAHAAAAAAAAEAAAAeAAAAWwAxADAALgAzADAALgAxADIALgAxADQANgBdAAAAAAAq7A==

--_000_77BC725C9062764F874D79F51E1F1A8F4406B897S04MBX0101s04lo_--
