Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaFFH3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:29:04 -0400
Received: from relay-s04-hub006.domainlocalhost.com ([74.115.207.217]:38376
	"EHLO relay-S04-HUB006.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaFFH27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:28:59 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C8CBS04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 6/14] input: cyapa: add gen3 trackpad device basic
 functions supported
Thread-Topic: [PATCH v2 6/14] input: cyapa: add gen3 trackpad device basic
 functions supported
Thread-Index: Ac+BWOpIqN/8jiLbSL2d8iRXUn0CTA==
Date: Fri, 6 Jun 2014 07:28:56 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C8CB@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C8CB@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8CBS04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Based on the cyapa core, add the gen3 trackpad device's basic functions
supported, so gen3 trackpad device can work with kernel input system.
The basic function is absolutely same as previous cyapa driver only
support gen3 trackpad device.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index d8948df..cc2927b 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -35,5 +35,5 @@ psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)        +=3D trackp=
oint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)   +=3D touchkit_ps2.o
 psmouse-$(CONFIG_MOUSE_PS2_CYPRESS)    +=3D cypress_ps2.o

-cyapatp-y :=3D cyapa.o
+cyapatp-y :=3D cyapa.o cyapa_gen3.o

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index b5dc9f9..3f870e5 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -185,6 +185,15 @@ ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,

 void cyapa_default_irq_handler(struct cyapa *cyapa)
 {
+       bool cont;
+
+       /* interrupt triggerred by command response in detecting. */
+       cont =3D true;
+       if (cyapa_gen3_ops.cyapa_irq_cmd_handler)
+               cont =3D cyapa_gen3_ops.cyapa_irq_cmd_handler(cyapa);
+       if (!cont)
+               return;
+
        /* do redetecting when device states is still unknown and
         * interrupt envent is received from device. */
        async_schedule(cyapa_detect_async, cyapa);
@@ -345,6 +354,9 @@ static int cyapa_check_is_operational(struct cyapa *cya=
pa)
                return ret;

        switch (cyapa->gen) {
+       case CYAPA_GEN3:
+               cyapa->ops =3D &cyapa_gen3_ops;
+               break;
        default:
                cyapa->ops =3D &cyapa_default_ops;
                cyapa->gen =3D CYAPA_GEN_UNKNOWN;
@@ -409,9 +421,85 @@ out:
  */
 static int cyapa_get_state(struct cyapa *cyapa)
 {
+       int ret;
+       u8 status[BL_STATUS_SIZE];
+       u8 cmd[32];
+       /* The i2c address of gen4 and gen5 trackpad device must be even. *=
/
+       bool even_addr =3D ((cyapa->client->addr & 0x0001) =3D=3D 0);
+       bool smbus =3D false;
+       int retires =3D 2;
+
        cyapa->state =3D CYAPA_STATE_NO_DEVICE;

-       return -ENODEV;
+       /*
+        * Get trackpad status by reading 3 registers starting from 0.
+        * If the device is in the bootloader, this will be BL_HEAD.
+        * If the device is in operation mode, this will be the DATA regs.
+        *
+        */
+       ret =3D cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET, BL_STATUS_S=
IZE,
+                                      status);
+
+       /*
+        * On smbus systems in OP mode, the i2c_reg_read will fail with
+        * -ETIMEDOUT.  In this case, try again using the smbus equivalent
+        * command.  This should return a BL_HEAD indicating CYAPA_STATE_OP=
.
+        */
+       if (cyapa->smbus && (ret =3D=3D -ETIMEDOUT || ret =3D=3D -ENXIO)) {
+               if (!even_addr)
+                       ret =3D cyapa_read_block(cyapa,
+                                       CYAPA_CMD_BL_STATUS, status);
+               smbus =3D true;
+       }
+       if (ret !=3D BL_STATUS_SIZE)
+               goto error;
+
+       /*
+        * detect trackpad protocol based on characristic registers and bit=
s.
+        */
+       do {
+               cyapa->status[REG_OP_STATUS] =3D status[REG_OP_STATUS];
+               cyapa->status[REG_BL_STATUS] =3D status[REG_BL_STATUS];
+               cyapa->status[REG_BL_ERROR] =3D status[REG_BL_ERROR];
+
+               if (cyapa->gen =3D=3D CYAPA_GEN_UNKNOWN ||
+                               cyapa->gen =3D=3D CYAPA_GEN3) {
+                       ret =3D cyapa_gen3_ops.cyapa_state_parse(cyapa,
+                                       status, BL_STATUS_SIZE);
+                       if (ret =3D=3D 0)
+                               goto out_detected;
+               }
+
+               /*
+                * cannot detect communication protocol based on current
+                * charateristic registers and bits.
+                * So write error command to do further detection.
+                * this method only valid on I2C bus.
+                * for smbus interface, it won't have overwrite issue.
+                */
+               if (!smbus) {
+                       cmd[0] =3D 0x00;
+                       cmd[1] =3D 0x00;
+                       ret =3D cyapa_i2c_write(cyapa, 0x00, 2, cmd);
+                       if (ret)
+                               goto error;
+
+                       msleep(50);
+
+                       ret =3D cyapa_i2c_read(cyapa, BL_HEAD_OFFSET,
+                                       BL_STATUS_SIZE, status);
+                       if (ret !=3D BL_STATUS_SIZE)
+                               goto error;
+               }
+       } while (--retires > 0 && !smbus);
+
+       goto error;
+
+out_detected:
+       return 0;
+
+error:
+       return (ret < 0) ? ret : -EAGAIN;
 }

 /*
@@ -1095,6 +1183,8 @@ static int cyapa_probe(struct i2c_client *client,
        struct cyapa *cyapa;
        struct device *dev =3D &client->dev;
        union i2c_smbus_data dummy;
+       int private_size;
+       void *private_mem;

        adapter_func =3D cyapa_check_adapter_functionality(client);
        if (adapter_func =3D=3D CYAPA_ADAPTER_FUNC_NONE) {
@@ -1107,7 +1197,10 @@ static int cyapa_probe(struct i2c_client *client,
                        I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &dummy) < 0)
                return -ENODEV;

-       cyapa =3D kzalloc(sizeof(struct cyapa), GFP_KERNEL);
+       private_size =3D 0;
+       if (cyapa_gen3_ops.cyapa_get_private_size)
+               private_size +=3D cyapa_gen3_ops.cyapa_get_private_size();
+       cyapa =3D kzalloc(sizeof(struct cyapa) + private_size, GFP_KERNEL);
        if (!cyapa) {
                dev_err(dev, "allocate memory for cyapa failed\n");
                return -ENOMEM;
@@ -1118,6 +1211,13 @@ static int cyapa_probe(struct i2c_client *client,
        sprintf(cyapa->phys, "i2c-%d-%04x/input0", client->adapter->nr,
                client->addr);

+       private_mem =3D (void *)cyapa + sizeof(struct cyapa);
+       ret =3D 0;
+       if (cyapa_gen3_ops.cyapa_private_init)
+               ret =3D cyapa_gen3_ops.cyapa_private_init(cyapa, private_me=
m);
+       if (ret)
+               goto err_unregister_device;
+
        cyapa->ops =3D &cyapa_default_ops;
        cyapa->in_syncing =3D false;
        mutex_init(&cyapa->state_sync_lock);
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 319f19d..7bd27b7 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -292,5 +292,6 @@ u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode);


 extern const char unique_str[];
+extern const struct cyapa_dev_ops cyapa_gen3_ops;

 #endif
diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_g=
en3.c
new file mode 100644
index 0000000..5345a9e
--- /dev/null
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -0,0 +1,734 @@
+/*
+ * Cypress APA trackpad with I2C interface
+ *
+ * Author: Dudley Du <dudl@cypress.com>
+ * Further cleanup and restructuring by:
+ *   Daniel Kurtz <djkurtz@chromium.org>
+ *   Benson Leung <bleung@chromium.org>
+ *
+ * Copyright (C) 2011-2012 Cypress Semiconductor, Inc.
+ * Copyright (C) 2011-2012 Google, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Pub=
lic
+ * License.  See the file COPYING in the main directory of this archive fo=
r
+ * more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/input/mt.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "cyapa.h"
+
+
+#define BLK_HEAD_BYTES 32
+
+/* Macro for register map group offset. */
+#define PRODUCT_ID_SIZE  16
+#define QUERY_DATA_SIZE  27
+#define REG_PROTOCOL_GEN_QUERY_OFFSET  20
+
+#define REG_OFFSET_DATA_BASE     0x0000
+#define REG_OFFSET_COMMAND_BASE  0x0028
+#define REG_OFFSET_QUERY_BASE    0x002a
+
+#define CYAPA_OFFSET_SOFT_RESET  REG_OFFSET_COMMAND_BASE
+#define OP_RECALIBRATION_MASK    0x80
+#define OP_REPORT_BASELINE_MASK  0x40
+#define REG_OFFSET_MAX_BASELINE  0x0026
+#define REG_OFFSET_MIN_BASELINE  0x0027
+
+#define REG_OFFSET_POWER_MODE (REG_OFFSET_COMMAND_BASE + 1)
+#define SET_POWER_MODE_DELAY   10000  /* unit: us */
+#define SET_POWER_MODE_TRIES   5
+
+/*
+ * CYAPA trackpad device states.
+ * Used in register 0x00, bit1-0, DeviceStatus field.
+ * Other values indicate device is in an abnormal state and must be reset.
+ */
+#define CYAPA_DEV_NORMAL  0x03
+#define CYAPA_DEV_BUSY    0x01
+
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
+
+struct cyapa_touch {
+       /*
+        * high bits or x/y position value
+        * bit 7 - 4: high 4 bits of x position value
+        * bit 3 - 0: high 4 bits of y position value
+        */
+       u8 xy_hi;
+       u8 x_lo;  /* low 8 bits of x position value. */
+       u8 y_lo;  /* low 8 bits of y position value. */
+       u8 pressure;
+       /* id range is 1 - 15.  It is incremented with every new touch. */
+       u8 id;
+} __packed;
+
+struct cyapa_reg_data {
+       /*
+        * bit 0 - 1: device status
+        * bit 3 - 2: power mode
+        * bit 6 - 4: reserved
+        * bit 7: interrupt valid bit
+        */
+       u8 device_status;
+       /*
+        * bit 7 - 4: number of fingers currently touching pad
+        * bit 3: valid data check bit
+        * bit 2: middle mechanism button state if exists
+        * bit 1: right mechanism button state if exists
+        * bit 0: left mechanism button state if exists
+        */
+       u8 finger_btn;
+       /* CYAPA reports up to 5 touches per packet. */
+       struct cyapa_touch touches[5];
+} __packed;
+
+static const u8 bl_activate[] =3D { 0x00, 0xff, 0x38, 0x00, 0x01, 0x02, 0x=
03,
+               0x04, 0x05, 0x06, 0x07 };
+static const u8 bl_deactivate[] =3D { 0x00, 0xff, 0x3b, 0x00, 0x01, 0x02, =
0x03,
+               0x04, 0x05, 0x06, 0x07 };
+static const u8 bl_exit[] =3D { 0x00, 0xff, 0xa5, 0x00, 0x01, 0x02, 0x03, =
0x04,
+               0x05, 0x06, 0x07 };
+
+
+ /* for byte read/write command */
+#define CMD_RESET 0
+#define CMD_POWER_MODE 1
+#define CMD_DEV_STATUS 2
+#define CMD_REPORT_MAX_BASELINE 3
+#define CMD_REPORT_MIN_BASELINE 4
+#define SMBUS_BYTE_CMD(cmd) (((cmd) & 0x3f) << 1)
+#define CYAPA_SMBUS_RESET SMBUS_BYTE_CMD(CMD_RESET)
+#define CYAPA_SMBUS_POWER_MODE SMBUS_BYTE_CMD(CMD_POWER_MODE)
+#define CYAPA_SMBUS_DEV_STATUS SMBUS_BYTE_CMD(CMD_DEV_STATUS)
+#define CYAPA_SMBUS_MAX_BASELINE SMBUS_BYTE_CMD(CMD_REPORT_MAX_BASELINE)
+#define CYAPA_SMBUS_MIN_BASELINE SMBUS_BYTE_CMD(CMD_REPORT_MIN_BASELINE)
+
+ /* for group registers read/write command */
+#define REG_GROUP_DATA 0
+#define REG_GROUP_CMD 2
+#define REG_GROUP_QUERY 3
+#define SMBUS_GROUP_CMD(grp) (0x80 | (((grp) & 0x07) << 3))
+#define CYAPA_SMBUS_GROUP_DATA SMBUS_GROUP_CMD(REG_GROUP_DATA)
+#define CYAPA_SMBUS_GROUP_CMD SMBUS_GROUP_CMD(REG_GROUP_CMD)
+#define CYAPA_SMBUS_GROUP_QUERY SMBUS_GROUP_CMD(REG_GROUP_QUERY)
+
+ /* for register block read/write command */
+#define CMD_BL_STATUS 0
+#define CMD_BL_HEAD 1
+#define CMD_BL_CMD 2
+#define CMD_BL_DATA 3
+#define CMD_BL_ALL 4
+#define CMD_BLK_PRODUCT_ID 5
+#define CMD_BLK_HEAD 6
+#define SMBUS_BLOCK_CMD(cmd) (0xc0 | (((cmd) & 0x1f) << 1))
+
+/* register block read/write command in bootloader mode */
+#define CYAPA_SMBUS_BL_STATUS SMBUS_BLOCK_CMD(CMD_BL_STATUS)
+#define CYAPA_SMBUS_BL_HEAD SMBUS_BLOCK_CMD(CMD_BL_HEAD)
+#define CYAPA_SMBUS_BL_CMD SMBUS_BLOCK_CMD(CMD_BL_CMD)
+#define CYAPA_SMBUS_BL_DATA SMBUS_BLOCK_CMD(CMD_BL_DATA)
+#define CYAPA_SMBUS_BL_ALL SMBUS_BLOCK_CMD(CMD_BL_ALL)
+
+/* register block read/write command in operational mode */
+#define CYAPA_SMBUS_BLK_PRODUCT_ID SMBUS_BLOCK_CMD(CMD_BLK_PRODUCT_ID)
+#define CYAPA_SMBUS_BLK_HEAD SMBUS_BLOCK_CMD(CMD_BLK_HEAD)
+
+ /* for byte read/write command */
+#define CMD_RESET 0
+#define CMD_POWER_MODE 1
+#define CMD_DEV_STATUS 2
+#define CMD_REPORT_MAX_BASELINE 3
+#define CMD_REPORT_MIN_BASELINE 4
+#define SMBUS_BYTE_CMD(cmd) (((cmd) & 0x3f) << 1)
+#define CYAPA_SMBUS_RESET SMBUS_BYTE_CMD(CMD_RESET)
+#define CYAPA_SMBUS_POWER_MODE SMBUS_BYTE_CMD(CMD_POWER_MODE)
+#define CYAPA_SMBUS_DEV_STATUS SMBUS_BYTE_CMD(CMD_DEV_STATUS)
+#define CYAPA_SMBUS_MAX_BASELINE SMBUS_BYTE_CMD(CMD_REPORT_MAX_BASELINE)
+#define CYAPA_SMBUS_MIN_BASELINE SMBUS_BYTE_CMD(CMD_REPORT_MIN_BASELINE)
+
+ /* for group registers read/write command */
+#define REG_GROUP_DATA 0
+#define REG_GROUP_CMD 2
+#define REG_GROUP_QUERY 3
+#define SMBUS_GROUP_CMD(grp) (0x80 | (((grp) & 0x07) << 3))
+#define CYAPA_SMBUS_GROUP_DATA SMBUS_GROUP_CMD(REG_GROUP_DATA)
+#define CYAPA_SMBUS_GROUP_CMD SMBUS_GROUP_CMD(REG_GROUP_CMD)
+#define CYAPA_SMBUS_GROUP_QUERY SMBUS_GROUP_CMD(REG_GROUP_QUERY)
+
+ /* for register block read/write command */
+#define CMD_BL_STATUS 0
+#define CMD_BL_HEAD 1
+#define CMD_BL_CMD 2
+#define CMD_BL_DATA 3
+#define CMD_BL_ALL 4
+#define CMD_BLK_PRODUCT_ID 5
+#define CMD_BLK_HEAD 6
+#define SMBUS_BLOCK_CMD(cmd) (0xc0 | (((cmd) & 0x1f) << 1))
+
+/* register block read/write command in bootloader mode */
+#define CYAPA_SMBUS_BL_STATUS SMBUS_BLOCK_CMD(CMD_BL_STATUS)
+#define CYAPA_SMBUS_BL_HEAD SMBUS_BLOCK_CMD(CMD_BL_HEAD)
+#define CYAPA_SMBUS_BL_CMD SMBUS_BLOCK_CMD(CMD_BL_CMD)
+#define CYAPA_SMBUS_BL_DATA SMBUS_BLOCK_CMD(CMD_BL_DATA)
+#define CYAPA_SMBUS_BL_ALL SMBUS_BLOCK_CMD(CMD_BL_ALL)
+
+/* register block read/write command in operational mode */
+#define CYAPA_SMBUS_BLK_PRODUCT_ID SMBUS_BLOCK_CMD(CMD_BLK_PRODUCT_ID)
+#define CYAPA_SMBUS_BLK_HEAD SMBUS_BLOCK_CMD(CMD_BLK_HEAD)
+
+struct cyapa_cmd_len {
+       u8 cmd;
+       u8 len;
+};
+
+static const struct cyapa_cmd_len cyapa_i2c_cmds[] =3D {
+       { CYAPA_OFFSET_SOFT_RESET, 1 },
+       { REG_OFFSET_COMMAND_BASE + 1, 1 },
+       { REG_OFFSET_DATA_BASE, 1 },
+       { REG_OFFSET_DATA_BASE, sizeof(struct cyapa_reg_data) },
+       { REG_OFFSET_COMMAND_BASE, 0 },
+       { REG_OFFSET_QUERY_BASE, QUERY_DATA_SIZE },
+       { BL_HEAD_OFFSET, 3 },
+       { BL_HEAD_OFFSET, 16 },
+       { BL_HEAD_OFFSET, 16 },
+       { BL_DATA_OFFSET, 16 },
+       { BL_HEAD_OFFSET, 32 },
+       { REG_OFFSET_QUERY_BASE, PRODUCT_ID_SIZE },
+       { REG_OFFSET_DATA_BASE, 32 },
+       { REG_OFFSET_MAX_BASELINE, 1 },
+       { REG_OFFSET_MIN_BASELINE, 1 },
+};
+
+static const struct cyapa_cmd_len cyapa_smbus_cmds[] =3D {
+       { CYAPA_SMBUS_RESET, 1 },
+       { CYAPA_SMBUS_POWER_MODE, 1 },
+       { CYAPA_SMBUS_DEV_STATUS, 1 },
+       { CYAPA_SMBUS_GROUP_DATA, sizeof(struct cyapa_reg_data) },
+       { CYAPA_SMBUS_GROUP_CMD, 2 },
+       { CYAPA_SMBUS_GROUP_QUERY, QUERY_DATA_SIZE },
+       { CYAPA_SMBUS_BL_STATUS, 3 },
+       { CYAPA_SMBUS_BL_HEAD, 16 },
+       { CYAPA_SMBUS_BL_CMD, 16 },
+       { CYAPA_SMBUS_BL_DATA, 16 },
+       { CYAPA_SMBUS_BL_ALL, 32 },
+       { CYAPA_SMBUS_BLK_PRODUCT_ID, PRODUCT_ID_SIZE },
+       { CYAPA_SMBUS_BLK_HEAD, 16 },
+       { CYAPA_SMBUS_MAX_BASELINE, 1 },
+       { CYAPA_SMBUS_MIN_BASELINE, 1 },
+};
+
+ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
+                                       u8 *values)
+{
+       return i2c_smbus_read_i2c_block_data(cyapa->client, reg, len, value=
s);
+}
+
+ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
+                                        size_t len, const u8 *values)
+{
+       return i2c_smbus_write_i2c_block_data(cyapa->client, reg, len, valu=
es);
+}
+
+/*
+ * cyapa_smbus_read_block - perform smbus block read command
+ * @cyapa  - private data structure of the driver
+ * @cmd    - the properly encoded smbus command
+ * @len    - expected length of smbus command result
+ * @values - buffer to store smbus command result
+ *
+ * Returns negative errno, else the number of bytes written.
+ *
+ * Note:
+ * In trackpad device, the memory block allocated for I2C register map
+ * is 256 bytes, so the max read block for I2C bus is 256 bytes.
+ */
+ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
+                                     u8 *values)
+{
+       ssize_t ret;
+       u8 index;
+       u8 smbus_cmd;
+       u8 *buf;
+       struct i2c_client *client =3D cyapa->client;
+
+       if (!(SMBUS_BYTE_BLOCK_CMD_MASK & cmd))
+               return -EINVAL;
+
+       if (SMBUS_GROUP_BLOCK_CMD_MASK & cmd) {
+               /* read specific block registers command. */
+               smbus_cmd =3D SMBUS_ENCODE_RW(cmd, SMBUS_READ);
+               ret =3D i2c_smbus_read_block_data(client, smbus_cmd, values=
);
+               goto out;
+       }
+
+       ret =3D 0;
+       for (index =3D 0; index * I2C_SMBUS_BLOCK_MAX < len; index++) {
+               smbus_cmd =3D SMBUS_ENCODE_IDX(cmd, index);
+               smbus_cmd =3D SMBUS_ENCODE_RW(smbus_cmd, SMBUS_READ);
+               buf =3D values + I2C_SMBUS_BLOCK_MAX * index;
+               ret =3D i2c_smbus_read_block_data(client, smbus_cmd, buf);
+               if (ret < 0)
+                       goto out;
+       }
+
+out:
+       return ret > 0 ? len : ret;
+}
+
+s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx)
+{
+       u8 cmd;
+
+       if (cyapa->smbus) {
+               cmd =3D cyapa_smbus_cmds[cmd_idx].cmd;
+               cmd =3D SMBUS_ENCODE_RW(cmd, SMBUS_READ);
+       } else {
+               cmd =3D cyapa_i2c_cmds[cmd_idx].cmd;
+       }
+       return i2c_smbus_read_byte_data(cyapa->client, cmd);
+}
+
+s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value)
+{
+       u8 cmd;
+
+       if (cyapa->smbus) {
+               cmd =3D cyapa_smbus_cmds[cmd_idx].cmd;
+               cmd =3D SMBUS_ENCODE_RW(cmd, SMBUS_WRITE);
+       } else {
+               cmd =3D cyapa_i2c_cmds[cmd_idx].cmd;
+       }
+       return i2c_smbus_write_byte_data(cyapa->client, cmd, value);
+}
+
+ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values)
+{
+       u8 cmd;
+       size_t len;
+
+       if (cyapa->smbus) {
+               cmd =3D cyapa_smbus_cmds[cmd_idx].cmd;
+               len =3D cyapa_smbus_cmds[cmd_idx].len;
+               return cyapa_smbus_read_block(cyapa, cmd, len, values);
+       } else {
+               cmd =3D cyapa_i2c_cmds[cmd_idx].cmd;
+               len =3D cyapa_i2c_cmds[cmd_idx].len;
+               return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
+       }
+}
+
+
+/*
+ * Determine the Gen3 trackpad device's current operating state.
+ *
+ */
+static int cyapa_gen3_state_parse(struct cyapa *cyapa, u8 *reg_data, int l=
en)
+{
+       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+
+       /* Parse based on Gen3 characteristic regiters and bits */
+       if (reg_data[0] =3D=3D 0x00 && reg_data[2] =3D=3D 0x00 &&
+               (reg_data[1] =3D=3D 0x11 || reg_data[1] =3D=3D 0x10)) {
+               /* normal state after power on or reset,
+                * reg_data[1] =3D=3D 0x11, firmware image checksum is vali=
d.
+                * reg_data[1] =3D=3D 0x10, firmware image checksum is inva=
lid. */
+               cyapa->gen =3D CYAPA_GEN3;
+               cyapa->state =3D CYAPA_STATE_BL_IDLE;
+       } else if (reg_data[0] =3D=3D 0x00 &&
+               (reg_data[1] & 0x10) =3D=3D 0x10) {
+               cyapa->gen =3D CYAPA_GEN3;
+               if (reg_data[1] & BL_STATUS_BUSY) {
+                       cyapa->state =3D CYAPA_STATE_BL_BUSY;
+               } else {
+                       if ((reg_data[2] & 0x20) =3D=3D 0x00)
+                               cyapa->state =3D CYAPA_STATE_BL_IDLE;
+                       else
+                               cyapa->state =3D CYAPA_STATE_BL_ACTIVE;
+               }
+       } else if ((reg_data[0] & 0x80) && (reg_data[1] & 0x08)) {
+               /* normal state when running in operaitonal mode,
+                * may also not in full power state or
+                * busying in command process. */
+               if (((reg_data[1] >> 4) & 0x07) <=3D 5) {
+                       /* only finger number data is valid. */
+                       cyapa->gen =3D CYAPA_GEN3;
+                       cyapa->state =3D CYAPA_STATE_OP;
+               }
+       } else if (reg_data[0] =3D=3D 0x0C && reg_data[1] =3D=3D 0x08) {
+               /* Op state when first two registers overwritten with 0x00 =
*/
+               cyapa->gen =3D CYAPA_GEN3;
+               cyapa->state =3D CYAPA_STATE_OP;
+       } else if (reg_data[1] & (BL_STATUS_RUNNING | BL_STATUS_BUSY)) {
+               cyapa->gen =3D CYAPA_GEN3;
+               cyapa->state =3D CYAPA_STATE_BL_BUSY;
+       }
+
+       if (cyapa->gen =3D=3D CYAPA_GEN3 && (cyapa->state =3D=3D CYAPA_STAT=
E_OP ||
+               cyapa->state =3D=3D CYAPA_STATE_BL_IDLE ||
+               cyapa->state =3D=3D CYAPA_STATE_BL_ACTIVE ||
+               cyapa->state =3D=3D CYAPA_STATE_BL_BUSY))
+               return 0;
+
+       return -EAGAIN;
+}
+
+static int cyapa_gen3_bl_deactivate(struct cyapa *cyapa)
+{
+       int ret;
+
+       ret =3D cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_deactivate),
+                                       bl_deactivate);
+       if (ret < 0)
+               return ret;
+
+       /* wait for bootloader to switch to idle state; should take < 100ms=
 */
+       msleep(100);
+       ret =3D cyapa_poll_state(cyapa, 500);
+       if (ret < 0)
+               return ret;
+       if (cyapa->state !=3D CYAPA_STATE_BL_IDLE)
+               return -EAGAIN;
+       return 0;
+}
+
+/*
+ * Exit bootloader
+ *
+ * Send bl_exit command, then wait 50 - 100 ms to let device transition to
+ * operational mode.  If this is the first time the device's firmware is
+ * running, it can take up to 2 seconds to calibrate its sensors.  So, pol=
l
+ * the device's new state for up to 2 seconds.
+ *
+ * Returns:
+ *   -EIO    failure while reading from device
+ *   -EAGAIN device is stuck in bootloader, b/c it has invalid firmware
+ *   0       device is supported and in operational mode
+ */
+static int cyapa_gen3_bl_exit(struct cyapa *cyapa)
+{
+       int ret;
+
+       ret =3D cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_exit), bl_exi=
t);
+       if (ret < 0)
+               return ret;
+
+       /*
+        * Wait for bootloader to exit, and operation mode to start.
+        * Normally, this takes at least 50 ms.
+        */
+       usleep_range(50000, 100000);
+       /*
+        * In addition, when a device boots for the first time after being
+        * updated to new firmware, it must first calibrate its sensors, wh=
ich
+        * can take up to an additional 2 seconds. If the device power is
+        * running low, this may take even longer.
+        */
+       ret =3D cyapa_poll_state(cyapa, 4000);
+       if (ret < 0)
+               return ret;
+       if (cyapa->state !=3D CYAPA_STATE_OP)
+               return -EAGAIN;
+
+       return 0;
+}
+
+/*
+ * cyapa_get_wait_time_for_pwr_cmd
+ *
+ * Compute the amount of time we need to wait after updating the touchpad
+ * power mode. The touchpad needs to consume the incoming power mode set
+ * command at the current clock rate.
+ */
+
+static u16 cyapa_get_wait_time_for_pwr_cmd(u8 pwr_mode)
+{
+       switch (pwr_mode) {
+       case PWR_MODE_FULL_ACTIVE: return 20;
+       case PWR_MODE_BTN_ONLY: return 20;
+       case PWR_MODE_OFF: return 20;
+       default: return cyapa_pwr_cmd_to_sleep_time(pwr_mode) + 50;
+       }
+}
+
+/*
+ * Set device power mode
+ *
+ * Write to the field to configure power state. Power states include :
+ *   Full : Max scans and report rate.
+ *   Idle : Report rate set by user specified time.
+ *   ButtonOnly : No scans for fingers. When the button is triggered,
+ *     a slave interrupt is asserted to notify host to wake up.
+ *   Off : Only awake for i2c commands from host. No function for button
+ *     or touch sensors.
+ *
+ * The power_mode command should conform to the following :
+ *   Full : 0x3f
+ *   Idle : Configurable from 20 to 1000ms. See note below for
+ *     cyapa_sleep_time_to_pwr_cmd and cyapa_pwr_cmd_to_sleep_time
+ *   ButtonOnly : 0x01
+ *   Off : 0x00
+ *
+ * Device power mode can only be set when device is in operational mode.
+ */
+static int cyapa_gen3_set_power_mode(struct cyapa *cyapa, u8 power_mode,
+               u16 reverved)
+{
+       int ret;
+       u8 power;
+       int tries =3D SET_POWER_MODE_TRIES;
+       u16 sleep_time;
+
+       /* Specific parameter for Gen4 and later trackpad devices.
+        * Avoid compile warning.
+        */
+       reverved =3D 0;
+       if (cyapa->state !=3D CYAPA_STATE_OP)
+               return 0;
+
+       while (true) {
+               ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_POWER_MODE);
+               if (ret >=3D 0 || --tries < 1)
+                       break;
+               usleep_range(SET_POWER_MODE_DELAY, 2 * SET_POWER_MODE_DELAY=
);
+       }
+       if (ret < 0)
+               return ret;
+
+       /*
+        * Return early if the power mode to set is the same as the current
+        * one.
+        */
+       if ((ret & PWR_MODE_MASK) =3D=3D power_mode)
+               return 0;
+
+       sleep_time =3D cyapa_get_wait_time_for_pwr_cmd(ret & PWR_MODE_MASK)=
;
+       power =3D ret;
+       power &=3D ~PWR_MODE_MASK;
+       power |=3D power_mode & PWR_MODE_MASK;
+       while (true) {
+               ret =3D cyapa_write_byte(cyapa, CYAPA_CMD_POWER_MODE, power=
);
+               if (!ret || --tries < 1)
+                       break;
+               usleep_range(SET_POWER_MODE_DELAY, 2 * SET_POWER_MODE_DELAY=
);
+       }
+
+       /*
+        * Wait for the newly set power command to go in at the previous
+        * clock speed (scanrate) used by the touchpad firmware. Not
+        * doing so before issuing the next command may result in errors
+        * depending on the command's content.
+        */
+       msleep(sleep_time);
+       return ret;
+}
+
+static int cyapa_gen3_get_query_data(struct cyapa *cyapa)
+{
+       u8 query_data[QUERY_DATA_SIZE];
+       int ret;
+
+       if (cyapa->state !=3D CYAPA_STATE_OP)
+               return -EBUSY;
+
+       ret =3D cyapa_read_block(cyapa, CYAPA_CMD_GROUP_QUERY, query_data);
+       if (ret !=3D QUERY_DATA_SIZE)
+               return (ret < 0) ? ret : -EIO;
+
+       memcpy(&cyapa->product_id[0], &query_data[0], 5);
+       cyapa->product_id[5] =3D '-';
+       memcpy(&cyapa->product_id[6], &query_data[5], 6);
+       cyapa->product_id[12] =3D '-';
+       memcpy(&cyapa->product_id[13], &query_data[11], 2);
+       cyapa->product_id[15] =3D '\0';
+
+       cyapa->fw_maj_ver =3D query_data[15];
+       cyapa->fw_min_ver =3D query_data[16];
+
+       cyapa->btn_capability =3D query_data[19] & CAPABILITY_BTN_MASK;
+
+       cyapa->gen =3D query_data[20] & 0x0f;
+
+       cyapa->max_abs_x =3D ((query_data[21] & 0xf0) << 4) | query_data[22=
];
+       cyapa->max_abs_y =3D ((query_data[21] & 0x0f) << 8) | query_data[23=
];
+
+       cyapa->physical_size_x =3D
+               ((query_data[24] & 0xf0) << 4) | query_data[25];
+       cyapa->physical_size_y =3D
+               ((query_data[24] & 0x0f) << 8) | query_data[26];
+
+       cyapa->max_z =3D 255;
+
+       return 0;
+}
+
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
+static int cyapa_gen3_do_operational_check(struct cyapa *cyapa)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       int ret;
+
+       switch (cyapa->state) {
+       case CYAPA_STATE_BL_ACTIVE:
+               ret =3D cyapa_gen3_bl_deactivate(cyapa);
+               if (ret) {
+                       dev_err(dev, "failed to bl_deactivate. %d\n", ret);
+                       return ret;
+               }
+
+       /* Fallthrough state */
+       case CYAPA_STATE_BL_IDLE:
+               ret =3D cyapa_gen3_bl_exit(cyapa);
+               if (ret) {
+                       dev_err(dev, "failed to bl_exit. %d\n", ret);
+                       return ret;
+               }
+
+       /* Fallthrough state */
+       case CYAPA_STATE_OP:
+               /*
+                * Reading query data before going back to the full mode
+                * may cause problems, so we set the power mode first here.
+                */
+               ret =3D cyapa_gen3_set_power_mode(cyapa, PWR_MODE_FULL_ACTI=
VE, 0);
+               if (ret)
+                       dev_err(dev, "%s: set full power mode failed, (%d)\=
n",
+                               __func__, ret);
+               ret =3D cyapa_gen3_get_query_data(cyapa);
+               if (ret < 0)
+                       return ret;
+
+               /* only support firmware protocol gen3 */
+               if (cyapa->gen !=3D CYAPA_GEN3) {
+                       dev_err(dev, "unsupported protocol version (%d)",
+                               cyapa->gen);
+                       return -EINVAL;
+               }
+
+               /* only support product ID starting with CYTRA */
+               if (memcmp(cyapa->product_id, unique_str,
+                               strlen(unique_str)) !=3D 0) {
+                       dev_err(dev, "unsupported product ID (%s)\n",
+                               cyapa->product_id);
+                       return -EINVAL;
+               }
+               return 0;
+
+       default:
+               return -EIO;
+       }
+       return 0;
+}
+
+static void cyapa_gen3_irq_handler(struct cyapa *cyapa)
+{
+       struct input_dev *input =3D cyapa->input;
+       struct cyapa_reg_data data;
+       int i;
+       int ret;
+       int num_fingers;
+
+       if (!input)
+               return;
+
+       ret =3D cyapa_read_block(cyapa, CYAPA_CMD_GROUP_DATA, (u8 *)&data);
+       if (ret !=3D sizeof(data)) {
+               async_schedule(cyapa_detect_async, cyapa);
+               return;
+       }
+
+       if ((data.device_status & OP_STATUS_SRC) !=3D OP_STATUS_SRC ||
+           (data.device_status & OP_STATUS_DEV) !=3D CYAPA_DEV_NORMAL ||
+           (data.finger_btn & OP_DATA_VALID) !=3D OP_DATA_VALID) {
+               async_schedule(cyapa_detect_async, cyapa);
+               return;
+       }
+
+       num_fingers =3D (data.finger_btn >> 4) & 0x0f;
+       for (i =3D 0; i < num_fingers; i++) {
+               const struct cyapa_touch *touch =3D &data.touches[i];
+               /* Note: touch->id range is 1 to 15; slots are 0 to 14. */
+               int slot =3D touch->id - 1;
+
+               input_mt_slot(input, slot);
+               input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
+               input_report_abs(input, ABS_MT_POSITION_X,
+                                ((touch->xy_hi & 0xf0) << 4) | touch->x_lo=
);
+               input_report_abs(input, ABS_MT_POSITION_Y,
+                                ((touch->xy_hi & 0x0f) << 8) | touch->y_lo=
);
+               input_report_abs(input, ABS_MT_PRESSURE, touch->pressure);
+       }
+
+       input_mt_sync_frame(input);
+
+       if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK)
+               input_report_key(input, BTN_LEFT,
+                                !!(data.finger_btn & OP_DATA_LEFT_BTN));
+       if (cyapa->btn_capability & CAPABILITY_MIDDLE_BTN_MASK)
+               input_report_key(input, BTN_MIDDLE,
+                                !!(data.finger_btn & OP_DATA_MIDDLE_BTN));
+       if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK)
+               input_report_key(input, BTN_RIGHT,
+                                !!(data.finger_btn & OP_DATA_RIGHT_BTN));
+       input_sync(input);
+}
+
+
+const struct cyapa_dev_ops cyapa_gen3_ops =3D {
+       NULL,
+       NULL,
+       NULL,
+       NULL,
+       NULL,
+       NULL,
+       NULL,
+
+       NULL,
+       NULL,
+
+       NULL,
+       NULL,
+
+       NULL,
+       NULL,
+
+       cyapa_gen3_state_parse,
+       cyapa_gen3_do_operational_check,
+
+       cyapa_gen3_irq_handler,
+       NULL,
+       NULL,
+       cyapa_gen3_set_power_mode,
+};
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8CBS04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMA
LgBjAG8AbQAAAB8AAl0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAA
AB8A5V8BAAAAKgAAAHMAaQBwADoAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAA
HwAaDAEAAAAUAAAARAB1AGQAbABlAHkAIABEAHUAAAAfAB8MAQAAACIAAABkAHUAZABsAEAAYwB5
AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAB4MAQAAAAoAAABTAE0AVABQAAAAAAACARkMAQAAAFgA
AAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBEAHUAZABsAGUAeQAgAEQAdQAAAFMATQBUAFAAAABk
AHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAHwABXQEAAAAiAAAAZAB1AGQAbABAAGMA
eQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwD4PwEAAAAUAAAARAB1AGQAbABlAHkAIABEAHUAAAAf
ACNAAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfACJAAQAAAAoA
AABTAE0AVABQAAAAAAACAfk/AQAAAFgAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBEAHUAZABs
AGUAeQAgAEQAdQAAAFMATQBUAFAAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAA
HwAJXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAxQAEAAAAC
AAAAAAAAAAsAQDoBAAAAHwAwQAEAAAACAAAAAAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQA
ZQAAAAAAAwDxPwQIAAALAEA6AQAAAAMA/T+oAwAAAgELMAEAAAAQAAAAm9w77JNaNUScdPnvQTKQ
dgMAFwABAAAAQAA5AAAsf/lYgc8BQAAIMM0zBvpYgc8BCwApAAAAAAALACMAAAAAAB8AAICGAwIA
AAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAa
AAAAegBoAC0AQwBOACwAIABlAG4ALQBVAFMAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaF
AAAAAAAAHwA3AAEAAACiAAAAWwBQAEEAVABDAEgAIAB2ADIAIAA2AC8AMQA0AF0AIABpAG4AcAB1
AHQAOgAgAGMAeQBhAHAAYQA6ACAAYQBkAGQAIABnAGUAbgAzACAAdAByAGEAYwBrAHAAYQBkACAA
ZABlAHYAaQBjAGUAIABiAGEAcwBpAGMAIABmAHUAbgBjAHQAaQBvAG4AcwAgAHMAdQBwAHAAbwBy
AHQAZQBkAAAAAAAfAD0AAQAAAAIAAAAAAAAAAwA2AAAAAAACAXEAAQAAABYAAAABz4FY6kio3/yO
IttIvZ3yJFdSfQJMAAAfAHAAAQAAAKIAAABbAFAAQQBUAEMASAAgAHYAMgAgADYALwAxADQAXQAg
AGkAbgBwAHUAdAA6ACAAYwB5AGEAcABhADoAIABhAGQAZAAgAGcAZQBuADMAIAB0AHIAYQBjAGsA
cABhAGQAIABkAGUAdgBpAGMAZQAgAGIAYQBzAGkAYwAgAGYAdQBuAGMAdABpAG8AbgBzACAAcwB1
AHAAcABvAHIAdABlAGQAAAAAAB8ANRABAAAAhAAAADwANwA3AEIAQwA3ADIANQBDADkAMAA2ADIA
NwA2ADQARgA4ADcANABEADcAOQBGADUAMQBFADEARgAxAEEAOABGADQANAAwADYAQwA4AEMAQgBA
AFMAMAA0AC0ATQBCAFgAMAAxAC0AMAAxAC4AcwAwADQALgBsAG8AYwBhAGwAPgAAAAMA3j+fTgAA
CwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAA4UAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAB
hQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAAAGBAAAAAAAAAwCAEP////8FAACAAyAGAAAA
AADAAAAAAAAARgAAAAACgQAAAAAAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAcgQAAAAAA
AEAABzBOvGn4WIHPAQsAAgABAAAAAwAmAAAAAAACARAwAQAAAEYAAAAAAAAAsR+hOTAgUUadtKVw
3tCf1AcAd7xyXJBidk+HTXn1Hh8ajwAAAJk8GwAAuqc+7svX90Cjdu81/GFZiQAYg/zDSwAAAAAf
APo/AQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAAMACVkBAAAAAwAAgAggBgAAAAAAwAAAAAAA
AEYAAAAAEIUAAAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBh
AHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAAugAAAEkASQA9ADAA
MQBDAEYAOAAxADUAOABFAEEANAA4AEEAOABEAEYARgBDADgARQAyADIARABCADQAOABCAEQAOQBE
AEYAMgAyADQANQA3ADUAMgA3AEQAMAAyADQAQwA7AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkA
bwBuACAAMQA0AC4AMwAgACgAQgB1AGkAbABkACAAMQA3ADQALgAwACkALAAgAFMAdABhAGcAZQA9
AEgANAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAE4EAAAEAAAADAACAAyAGAAAAAADAAAAA
AAAARgAAAAAjgQAA////fwMAAIADIAYAAAAAAMAAAAAAAABGAAAAABCBAAAAAAAAAwAAgAMgBgAA
AAAAwAAAAAAAAEYAAAAAEYEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAkgQAAAAAAAAsA
AIADIAYAAAAAAMAAAAAAAABGAAAAACyBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKYEA
AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAqgQAAAAAAAB8AAIADIAYAAAAAAMAAAAAAAABG
AAAAACeBAAABAAAAAgAAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAASgQAAAQAAAB8AAIAD
IAYAAAAAAMAAAAAAAABGAAAAACGBAAABAAAAAgAAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAA
AAADgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACaBAAAAAAAACwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAADoUAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAYhQAAAAAAAAsAAIAIIAYA
AAAAAMAAAAAAAABGAAAAAIKFAAAAAAAAAwANNP0/AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAg
AAAAeAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAAAAAfAACAhgMCAAAA
AADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAtAGkAcAAAAAAAAQAA
AB4AAABbADEAMAAuADMAMAAuADEAMgAuADEANAA2AF0AAAAAAFg6

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8CBS04MBX0101s04lo_--
