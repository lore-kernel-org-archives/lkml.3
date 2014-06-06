Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaFFH31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:29:27 -0400
Received: from relay-s04-hub001.domainlocalhost.com ([74.115.207.100]:15971
	"EHLO relay-S04-HUB001.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaFFH3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:21 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C8ECS04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 10/14] input: cyapa: add gen5 trackpad device basic
 functions supported
Thread-Topic: [PATCH v2 10/14] input: cyapa: add gen5 trackpad device basic
 functions supported
Thread-Index: Ac+BWO2zP4GJek4kSq6D/sI58RwMCw==
Date: Fri, 6 Jun 2014 07:29:19 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C8EC@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C8EC@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8ECS04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Based on the cyapa core, add the gen5 trackpad device's basic functions
supported, so gen5 trackpad device can work with kernel input system.
And also based on the state parse interface, the cyapa driver can
automatically determine the attached is gen3 or gen5 protocol trackpad
device, then set the correct protocol to work with the attached
trackpad device.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index cc2927b..59a1abd 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -35,5 +35,5 @@ psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)        +=3D trackp=
oint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)   +=3D touchkit_ps2.o
 psmouse-$(CONFIG_MOUSE_PS2_CYPRESS)    +=3D cypress_ps2.o

-cyapatp-y :=3D cyapa.o cyapa_gen3.o
+cyapatp-y :=3D cyapa.o cyapa_gen3.o cyapa_gen5.o

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 3f870e5..8d37032 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -191,6 +191,8 @@ void cyapa_default_irq_handler(struct cyapa *cyapa)
        cont =3D true;
        if (cyapa_gen3_ops.cyapa_irq_cmd_handler)
                cont =3D cyapa_gen3_ops.cyapa_irq_cmd_handler(cyapa);
+       if (cont && cyapa_gen5_ops.cyapa_irq_cmd_handler)
+               cont =3D cyapa_gen5_ops.cyapa_irq_cmd_handler(cyapa);
        if (!cont)
                return;

@@ -354,6 +356,9 @@ static int cyapa_check_is_operational(struct cyapa *cya=
pa)
                return ret;

        switch (cyapa->gen) {
+       case CYAPA_GEN5:
+               cyapa->ops =3D &cyapa_gen5_ops;
+               break;
        case CYAPA_GEN3:
                cyapa->ops =3D &cyapa_gen3_ops;
                break;
@@ -469,6 +474,14 @@ static int cyapa_get_state(struct cyapa *cyapa)
                        if (ret =3D=3D 0)
                                goto out_detected;
                }
+               if ((cyapa->gen =3D=3D CYAPA_GEN_UNKNOWN ||
+                               cyapa->gen =3D=3D CYAPA_GEN5) &&
+                       !smbus && even_addr) {
+                       ret =3D cyapa_gen5_ops.cyapa_state_parse(cyapa,
+                                       status, BL_STATUS_SIZE);
+                       if (ret =3D=3D 0)
+                               goto out_detected;
+               }

                /*
                 * cannot detect communication protocol based on current
@@ -1200,6 +1213,8 @@ static int cyapa_probe(struct i2c_client *client,
        private_size =3D 0;
        if (cyapa_gen3_ops.cyapa_get_private_size)
                private_size +=3D cyapa_gen3_ops.cyapa_get_private_size();
+       if (cyapa_gen5_ops.cyapa_get_private_size)
+               private_size +=3D cyapa_gen5_ops.cyapa_get_private_size();
        cyapa =3D kzalloc(sizeof(struct cyapa) + private_size, GFP_KERNEL);
        if (!cyapa) {
                dev_err(dev, "allocate memory for cyapa failed\n");
@@ -1215,6 +1230,11 @@ static int cyapa_probe(struct i2c_client *client,
        ret =3D 0;
        if (cyapa_gen3_ops.cyapa_private_init)
                ret =3D cyapa_gen3_ops.cyapa_private_init(cyapa, private_me=
m);
+       if (!ret && cyapa_gen5_ops.cyapa_private_init) {
+               if (cyapa_gen3_ops.cyapa_get_private_size)
+                       private_mem +=3D cyapa_gen3_ops.cyapa_get_private_s=
ize();
+               ret =3D cyapa_gen5_ops.cyapa_private_init(cyapa, private_me=
m);
+       }
        if (ret)
                goto err_unregister_device;

diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 7bd27b7..7f8c3d4 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -293,5 +293,6 @@ u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode);

 extern const char unique_str[];
 extern const struct cyapa_dev_ops cyapa_gen3_ops;
+extern const struct cyapa_dev_ops cyapa_gen5_ops;

 #endif
diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_g=
en5.c
new file mode 100644
index 0000000..00ca3a6
--- /dev/null
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -0,0 +1,1595 @@
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
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/input/mt.h>
+#include <linux/mutex.h>
+#include <linux/completion.h>
+#include <linux/slab.h>
+#include <linux/unaligned/access_ok.h>
+#include "cyapa.h"
+
+
+/* mcros of Gen5 */
+#define RECORD_EVENT_NONE        0
+#define RECORD_EVENT_TOUCHDOWN  1
+#define RECORD_EVENT_DISPLACE    2
+#define RECORD_EVENT_LIFTOFF     3
+
+#define CYAPA_TSG_FLASH_MAP_BLOCK_SIZE      0x80
+#define CYAPA_TSG_IMG_FW_HDR_SIZE           13
+#define CYAPA_TSG_FW_ROW_SIZE               (CYAPA_TSG_FLASH_MAP_BLOCK_SIZ=
E)
+#define CYAPA_TSG_IMG_START_ROW_NUM         0x002e
+#define CYAPA_TSG_IMG_END_ROW_NUM           0x01fe
+#define CYAPA_TSG_IMG_APP_INTEGRITY_ROW_NUM 0x01ff
+#define CYAPA_TSG_IMG_MAX_RECORDS           (CYAPA_TSG_IMG_END_ROW_NUM - \
+                               CYAPA_TSG_IMG_START_ROW_NUM + 1 + 1)
+#define CYAPA_TSG_IMG_READ_SIZE             (CYAPA_TSG_FLASH_MAP_BLOCK_SIZ=
E / 2)
+#define CYAPA_TSG_START_OF_APPLICATION      0x1700
+#define CYAPA_TSG_APP_INTEGRITY_SIZE        60
+#define CYAPA_TSG_FLASH_MAP_METADATA_SIZE   60
+#define CYAPA_TSG_BL_KEY_SIZE               8
+
+/* Macro definitions for Gen5 trackpad device. */
+#define GEN5_TOUCH_REPORT_HEAD_SIZE     7
+#define GEN5_TOUCH_REPORT_MAX_SIZE      127
+#define GEN5_BTN_REPORT_HEAD_SIZE       6
+#define GEN5_BTN_REPORT_MAX_SIZE        14
+#define GEN5_WAKEUP_EVENT_SIZE          4
+#define GEN5_RAW_DATA_HEAD_SIZE         24
+
+#define GEN5_BL_CMD_REPORT_ID           0x40
+#define GEN5_BL_RESP_REPORT_ID          0x30
+#define GEN5_APP_CMD_REPORT_ID          0x2f
+#define GEN5_APP_RESP_REPORT_ID         0x1f
+
+#define GEN5_APP_DEEP_SLEEP_REPORT_ID   0xf0
+#define GEN5_DEEP_SLEEP_RESP_LENGTH     5
+
+#define GEN5_PARAMETER_ACT_INTERVL_ID        0x4d
+#define GEN5_PARAMETER_ACT_INTERVL_SIZE      1
+#define GEN5_PARAMETER_ACT_LFT_INTERVL_ID    0x4f
+#define GEN5_PARAMETER_ACT_LFT_INTERVL_SIZE  2
+#define GEN5_PARAMETER_LP_INTRVL_ID          0x4c
+#define GEN5_PARAMETER_LP_INTRVL_SIZE        2
+
+#define GEN5_PARAMETER_DISABLE_PIP_REPORT    0x08
+
+#define GEN5_POWER_STATE_ACTIVE              0x01
+#define GEN5_POWER_STATE_LOOK_FOR_TOUCH      0x02
+#define GEN5_POWER_STATE_READY               0x03
+#define GEN5_POWER_STATE_IDLE                0x04
+#define GEN5_POWER_STATE_BTN_ONLY            0x05
+#define GEN5_POWER_STATE_OFF                 0x06
+
+#define GEN5_DEEP_SLEEP_STATE_MASK  0x03
+#define GEN5_DEEP_SLEEP_STATE_ON    0x00
+#define GEN5_DEEP_SLEEP_STATE_OFF   0x01
+
+#define GEN5_DEEP_SLEEP_OPCODE      0x08
+#define GEN5_DEEP_SLEEP_OPCODE_MASK 0x0f
+
+#define GEN5_POWER_READY_MAX_INTRVL_TIME  50   /* unit: ms */
+#define GEN5_POWER_IDLE_MAX_INTRVL_TIME   250  /* unit: ms */
+
+#define GEN5_CMD_REPORT_ID_OFFSET       4
+
+#define GEN5_RESP_REPORT_ID_OFFSET      2
+#define GEN5_RESP_RSVD_OFFSET           3
+#define     GEN5_RESP_RSVD_KEY          0x00
+#define GEN5_RESP_BL_SOP_OFFSET         4
+#define     GEN5_SOP_KEY                0x01  /* Start of Packet */
+#define     GEN5_EOP_KEY                0x17  /* End of Packet */
+#define GEN5_RESP_APP_CMD_OFFSET        4
+#define     GET_GEN5_CMD_CODE(reg)      ((reg) & 0x7f)
+
+#define GEN5_MIN_BL_CMD_LENGTH           13
+#define GEN5_MIN_BL_RESP_LENGTH          11
+#define GEN5_MIN_APP_CMD_LENGTH          7
+#define GEN5_MIN_APP_RESP_LENGTH         5
+#define GEN5_UNSUPPORTED_CMD_RESP_LENGTH 6
+
+#define GEN5_RESP_LENGTH_SIZE 2
+
+#define GEN5_HID_DESCRIPTOR_SIZE      32
+#define GEN5_BL_HID_REPORT_ID         0xff
+#define GEN5_APP_HID_REPORT_ID        0xf7
+#define GEN5_BL_MAX_OUTPUT_LENGTH     0x0100
+#define GEN5_APP_MAX_OUTPUT_LENGTH    0x00fe
+
+#define GEN5_BL_REPORT_DESCRIPTOR_SIZE            0x1d
+#define GEN5_BL_REPORT_DESCRIPTOR_ID              0xfe
+#define GEN5_APP_REPORT_DESCRIPTOR_SIZE           0xee
+#define GEN5_APP_CONTRACT_REPORT_DESCRIPTOR_SIZE  0xfa
+#define GEN5_APP_REPORT_DESCRIPTOR_ID             0xf6
+
+#define GEN5_TOUCH_REPORT_ID         0x01
+#define GEN5_BTN_REPORT_ID           0x03
+#define GEN5_WAKEUP_EVENT_REPORT_ID  0x04
+#define GEN5_OLD_PUSH_BTN_REPORT_ID  0x05
+#define GEN5_PUSH_BTN_REPORT_ID      0x06
+
+#define GEN5_CMD_COMPLETE_SUCCESS(status) ((status) =3D=3D 0x00)
+
+#define GEN5_BL_INITIATE_RESP_LEN            11
+#define GEN5_BL_FAIL_EXIT_RESP_LEN           11
+#define GEN5_BL_FAIL_EXIT_STATUS_CODE        0x0c
+#define GEN5_BL_VERIFY_INTEGRITY_RESP_LEN    12
+#define GEN5_BL_INTEGRITY_CHEKC_PASS         0x00
+#define GEN5_BL_BLOCK_WRITE_RESP_LEN         11
+#define GEN5_BL_READ_APP_INFO_RESP_LEN       31
+#define GEN5_CMD_CALIBRATE                   0x28
+#define CYAPA_SENSING_MODE_MUTUAL_CAP_FINE   0x00
+#define CYAPA_SENSING_MODE_SELF_CAP          0x02
+
+#define GEN5_CMD_RETRIEVE_DATA_STRUCTURE     0x24
+#define GEN5_RETRIEVE_MUTUAL_PWC_DATA        0x00
+#define GEN5_RETRIEVE_SELF_CAP_PWC_DATA      0x01
+
+#define GEN5_RETRIEVE_DATA_ELEMENT_SIZE_MASK 0x07
+
+#define GEN5_CMD_EXECUTE_PANEL_SCAN          0x2a
+#define GEN5_CMD_RETRIEVE_PANEL_SCAN         0x2b
+#define GEN5_PANEL_SCAN_MUTUAL_RAW_DATA      0x00
+#define GEN5_PANEL_SCAN_MUTUAL_BASELINE      0x01
+#define GEN5_PANEL_SCAN_MUTUAL_DIFFCOUNT     0x02
+#define GEN5_PANEL_SCAN_SELF_RAW_DATA        0x03
+#define GEN5_PANEL_SCAN_SELF_BASELINE        0x04
+#define GEN5_PANEL_SCAN_SELF_DIFFCOUNT       0x05
+
+#define GEN5_PWC_DATA_ELEMENT_SIZE_MASK      0x07
+
+#define GEN5_NUMBER_OF_TOUCH_MASK    0x1f
+#define GEN5_GET_EVENT_ID(reg)       (((reg) >> 5) & 0x03)
+#define GEN5_GET_TOUCH_ID(reg)       ((reg) & 0x1f)
+
+#define GEN5_PRODUCT_FAMILY_MASK        0xf000
+#define GEN5_PRODUCT_FAMILY_TRACKPAD    0x1000
+
+#define TSG_INVALID_CMD   0xff
+
+struct cyapa_gen5_touch_record {
+       /*
+        * bit 7 - 3: reserved
+        * bit 2 - 0: touch type;
+        *            0 : standard finger;
+        *            1 - 15 : reserved.
+        */
+       u8 touch_type;
+
+       /*
+        * bit 7: indicates touch liftoff status.
+        *              0 : touch is currently on the panel.
+        *              1 : touch record indicates a liftoff.
+        * bit 6 - 5: indicates an event associated with this touch instanc=
e
+        *              0 : no event
+        *              1 : touchdown
+        *              2 : significant displacement (> active distance)
+        *              3 : liftoff (record reports last known coordinates)
+        * bit 4 - 0: An arbitrary ID tag associated with a finger
+        *              to alow tracking a touch as it moves around the pan=
el.
+        */
+       u8 touch_tip_event_id;
+
+       /* bit 7 - 0 of X-axis corrinate of the touch in pixel. */
+       u8 x_lo;
+
+       /* bit 15 - 8 of X-axis corrinate of the touch in pixel. */
+       u8 x_hi;
+
+       /* bit 7 - 0 of Y-axis corrinate of the touch in pixel. */
+       u8 y_lo;
+
+       /* bit 15 - 8 of Y-axis corrinate of the touch in pixel. */
+       u8 y_hi;
+
+       /* touch intensity in counts, pressure value. */
+       u8 z;
+
+       /*
+        * The length of the major axis of the ellipse of contact between
+        * the finger and the panel (ABS_MT_TOUCH_MAJOR).
+        */
+       u8 major_axis_len;
+
+       /*
+        * The length of the minor axis of the ellipse of contact between
+        * the finger and the panel (ABS_MT_TOUCH_MINOR).
+        */
+       u8 minor_axis_len;
+
+       /*
+        * The length of the major axis of the approaching tool.
+        * (ABS_MT_WIDTH_MAJOR)
+        */
+       u8 major_tool_len;
+
+       /*
+        * The length of the minor axis of the approaching tool.
+        * (ABS_MT_WIDTH_MINOR)
+        */
+       u8 minor_tool_len;
+
+       /*
+        * The angle between the panel vertical axis and
+        * the major axis of the contact ellipse. This value is an 8-bit
+        * signed integer. The range is -127 to +127 (corresponding to
+        * -90 degree and +90 degree respectively).
+        * The positive direction is clockwise from the vertical axis.
+        * If the ellipse of contact degenerates into a circle,
+        * orientation is reported as 0.
+        */
+       u8 orientation;
+} __packed;
+
+struct cyapa_gen5_report_data {
+       u8 report_head[GEN5_TOUCH_REPORT_HEAD_SIZE];
+       struct cyapa_gen5_touch_record touch_records[10];
+} __packed;
+
+struct cyapa_tsg_bin_image_head {
+       u8 head_size;  /* in bytes, including itself. */
+       u8 ttda_driver_major_version;  /* reserved as 0. */
+       u8 ttda_driver_minor_version;  /* reserved as 0. */
+       u8 fw_major_version;
+       u8 fw_minor_version;
+       u8 fw_revision_control_number[8];
+} __packed;
+
+struct cyapa_tsg_bin_image_data_record {
+       u8 flash_array_id;
+       __be16 row_number;
+       /* the number of bytes of flash data contained in this record. */
+       __be16 record_len;
+       /* the flash program data. */
+       u8 record_data[CYAPA_TSG_FW_ROW_SIZE];
+} __packed;
+
+struct cyapa_tsg_bin_image {
+       struct cyapa_tsg_bin_image_head image_head;
+       struct cyapa_tsg_bin_image_data_record records[0];
+} __packed;
+
+/* variables for PIP irq sync command processing. */
+struct pip_sync_cmd_states {
+       struct mutex cmd_lock;
+       struct completion cmd_ready;
+       atomic_t cmd_issued;
+       u8 in_progress_cmd;
+
+       cb_sort resp_sort_func;
+       u8 *resp_data;
+       int *resp_len;
+
+       u8 irq_cmd_buf[CYAPA_REG_MAP_SIZE];
+       u8 empty_buf[CYAPA_REG_MAP_SIZE];
+};
+
+static struct pip_sync_cmd_states *gen5_pip;
+static struct cyapa_tsg_bin_image_head gen5_fw_img_head;
+/* record current read the power states of gen5 trackpad device. */
+#define UNINIT_SLEEP_TIME 0xFFFF
+static u8 gen5_pwr_mode =3D 0xFF;
+static u16 gen5_sleep_time =3D UNINIT_SLEEP_TIME;
+#define GEN5_UNINIT_SLEEP_TIME(sleep_time)  \
+               ((sleep_time) =3D=3D UNINIT_SLEEP_TIME)
+
+
+static size_t cyapa_gen5_get_private_size(void)
+{
+       return sizeof(struct pip_sync_cmd_states);
+}
+
+static int cyapa_gen5_private_init(struct cyapa *cyapa, void *private_mem)
+{
+       if (!private_mem)
+               return -ENOMEM;
+
+       gen5_pip =3D (struct pip_sync_cmd_states *)private_mem;
+       init_completion(&gen5_pip->cmd_ready);
+       atomic_set(&gen5_pip->cmd_issued, 0);
+       mutex_init(&gen5_pip->cmd_lock);
+       atomic_set(&gen5_pip->cmd_issued, 0);
+
+       gen5_pip->resp_sort_func =3D NULL;
+       gen5_pip->in_progress_cmd =3D TSG_INVALID_CMD;
+       gen5_pip->resp_data =3D NULL;
+       gen5_pip->resp_len =3D NULL;
+
+       return 0;
+}
+
+/* Return negative errno, or else the number of bytes read. */
+static ssize_t cyapa_i2c_pip_read(struct cyapa *cyapa, u8 *buf, size_t siz=
e)
+{
+       int ret;
+
+       if (size =3D=3D 0)
+               return 0;
+
+       if (!buf || size > CYAPA_REG_MAP_SIZE)
+               return -EINVAL;
+
+       ret =3D i2c_master_recv(cyapa->client, buf, size);
+
+       if (ret !=3D size)
+               return (ret < 0) ? ret : -EIO;
+
+       return size;
+}
+
+/**
+ * Return a negative errno code else zero on success.
+ */
+static ssize_t cyapa_i2c_pip_write(struct cyapa *cyapa, u8 *buf, size_t si=
ze)
+{
+       int ret;
+
+       if (!buf || !size)
+               return -EINVAL;
+
+       ret =3D i2c_master_send(cyapa->client, buf, size);
+
+       if (ret !=3D size)
+               return (ret < 0) ? ret : -EIO;
+
+       return 0;
+}
+
+/**
+ * this function is aimed to dump all not read data in Gen5 trackpad
+ * before send any command, otherwise, the interrupt line will be blocked.
+ */
+int cyapa_empty_pip_output_data(struct cyapa *cyapa,
+               u8 *buf, int *len, cb_sort func)
+{
+       int ret;
+       int length;
+       int report_count;
+       int empty_count;
+       int buf_len;
+
+       buf_len =3D 0;
+       if (len) {
+               buf_len =3D (*len < CYAPA_REG_MAP_SIZE) ?
+                               *len : CYAPA_REG_MAP_SIZE;
+               *len =3D 0;
+       }
+
+       report_count =3D 8;  /* max 7 pending data before command response =
data */
+       empty_count =3D 0;
+       do {
+               /*
+                * Depnding on testing in cyapa driver, there are max 5 "02=
 00"
+                * packets between two valid bufferred data report in firmw=
are.
+                * So in order to dump all buffered data out and
+                * make interrupt line release for reassert again,
+                * we must set the empty_count check value bigger than 5 to
+                * make it work. Otherwise, in some situation,
+                * the interrupt line may unable to reactive again,
+                * which will cause trackpad device unable to
+                * report data any more.
+                * for example, it may happen in EFT and ESD testing.
+                */
+               if (empty_count > 5)
+                       return 0;
+
+               ret =3D cyapa_i2c_pip_read(cyapa, gen5_pip->empty_buf,
+                               GEN5_RESP_LENGTH_SIZE);
+               if (ret < 0)
+                       return ret;
+
+               length =3D get_unaligned_le16(gen5_pip->empty_buf);
+               if (length =3D=3D GEN5_RESP_LENGTH_SIZE) {
+                       empty_count++;
+                       continue;
+               } else if (length > CYAPA_REG_MAP_SIZE) {
+                       /* should not happen */
+                       return -EINVAL;
+               } else if (length =3D=3D 0) {
+                       /* application or bootloader launch data polled out=
. */
+                       length =3D GEN5_RESP_LENGTH_SIZE;
+                       if (buf && buf_len && func &&
+                               func(cyapa, gen5_pip->empty_buf, length)) {
+                               length =3D min(buf_len, length);
+                               memcpy(buf, gen5_pip->empty_buf, length);
+                               *len =3D length;
+                               /* response found, success. */
+                               return 0;
+                       } else {
+                               continue;
+                       }
+               }
+
+               ret =3D cyapa_i2c_pip_read(cyapa, gen5_pip->empty_buf, leng=
th);
+               if (ret < 0)
+                       return ret;
+
+               report_count--;
+               empty_count =3D 0;
+               length =3D get_unaligned_le16(gen5_pip->empty_buf);
+               if (length <=3D GEN5_RESP_LENGTH_SIZE)
+                       empty_count++;
+               else if (buf && buf_len && func &&
+                       func(cyapa, gen5_pip->empty_buf, length)) {
+                       length =3D min(buf_len, length);
+                       memcpy(buf, gen5_pip->empty_buf, length);
+                       *len =3D length;
+                       /* response found, success. */
+                       return 0;
+               }
+
+               ret =3D -EINVAL;
+       } while (report_count);
+
+       return ret;
+}
+
+static int cyapa_do_i2c_pip_cmd_irq_sync(
+               struct cyapa *cyapa,
+               u8 *cmd, size_t cmd_len,
+               unsigned long timeout)
+{
+       int ret;
+
+       /* wait for interrupt to set ready completion */
+       init_completion(&gen5_pip->cmd_ready);
+
+       atomic_inc(&gen5_pip->cmd_issued);
+       ret =3D cyapa_i2c_pip_write(cyapa, cmd, cmd_len);
+       if (ret) {
+               atomic_dec(&gen5_pip->cmd_issued);
+               return (ret < 0) ? ret : -EIO;
+       }
+
+       /* wait for interrupt to indicate command is completed. */
+       timeout =3D wait_for_completion_timeout(&gen5_pip->cmd_ready,
+                               msecs_to_jiffies(timeout));
+       if (timeout =3D=3D 0) {
+               atomic_dec(&gen5_pip->cmd_issued);
+               return -ETIMEDOUT;
+       }
+       return 0;
+}
+
+static int cyapa_i2c_pip_cmd_irq_sync(
+               struct cyapa *cyapa,
+               u8 *cmd, int cmd_len,
+               u8 *resp_data, int *resp_len,
+               unsigned long timeout,
+               cb_sort func)
+{
+       int ret;
+       int tries;
+       int length;
+
+       if (!cmd || !cmd_len)
+               return -EINVAL;
+
+       /* commands must be serialized. */
+       mutex_lock(&gen5_pip->cmd_lock);
+
+       gen5_pip->resp_sort_func =3D func;
+       gen5_pip->resp_data =3D resp_data;
+       gen5_pip->resp_len =3D resp_len;
+
+       if (cmd_len >=3D GEN5_MIN_APP_CMD_LENGTH &&
+                       cmd[4] =3D=3D GEN5_APP_CMD_REPORT_ID) {
+               /* application command */
+               gen5_pip->in_progress_cmd =3D cmd[6] & 0x7f;
+       } else if (cmd_len >=3D GEN5_MIN_BL_CMD_LENGTH &&
+                       cmd[4] =3D=3D GEN5_BL_CMD_REPORT_ID) {
+               /* bootloader command */
+               gen5_pip->in_progress_cmd =3D cmd[7];
+       }
+
+       /* send command data, wait and read output response data's length. =
*/
+       if (cyapa_is_irq_enabled(cyapa)) {
+               ret =3D cyapa_do_i2c_pip_cmd_irq_sync(cyapa, cmd, cmd_len,
+                                                       timeout);
+               if (ret =3D=3D -ETIMEDOUT && resp_data &&
+                               resp_len && *resp_len !=3D 0 && func) {
+                       /*
+                        * for some old version with some unknown reasons,
+                        * there was no interrupt for the command response =
data,
+                        * so need to poll here to try to get the response =
data.
+                        */
+                       ret =3D cyapa_empty_pip_output_data(cyapa,
+                                       resp_data, resp_len, func);
+                       if (ret || *resp_len =3D=3D 0)
+                               ret =3D ret ? ret : -ETIMEDOUT;
+               }
+       } else {
+               ret =3D cyapa_i2c_pip_write(cyapa, cmd, cmd_len);
+               if (ret) {
+                       ret =3D ret < 0 ? ret : -EIO;
+                       goto out;
+               }
+
+               tries =3D timeout / 5;
+               length =3D *resp_len;
+               if (resp_data && resp_len && length !=3D 0 && func) {
+                       do {
+                               usleep_range(3000, 5000);
+                               *resp_len =3D length;
+                               ret =3D cyapa_empty_pip_output_data(cyapa,
+                                               resp_data, resp_len, func);
+                               if (ret || *resp_len =3D=3D 0)
+                                       continue;
+                               else
+                                       break;
+                       } while (--tries > 0);
+                       if ((ret || *resp_len =3D=3D 0) || tries <=3D 0)
+                               ret =3D ret ? ret : -ETIMEDOUT;
+               }
+       }
+
+out:
+       gen5_pip->resp_sort_func =3D NULL;
+       gen5_pip->resp_data =3D NULL;
+       gen5_pip->resp_len =3D NULL;
+       gen5_pip->in_progress_cmd =3D TSG_INVALID_CMD;
+
+       mutex_unlock(&gen5_pip->cmd_lock);
+       return ret;
+}
+
+bool cyapa_gen5_sort_tsg_pip_bl_resp_data(struct cyapa *cyapa,
+               u8 *data, int len)
+{
+       if (!data || len < GEN5_MIN_BL_RESP_LENGTH)
+               return false;
+
+       /* bootloader input report id 30h */
+       if (data[GEN5_RESP_REPORT_ID_OFFSET] =3D=3D GEN5_BL_RESP_REPORT_ID =
&&
+                       data[GEN5_RESP_RSVD_OFFSET] =3D=3D GEN5_RESP_RSVD_K=
EY &&
+                       data[GEN5_RESP_BL_SOP_OFFSET] =3D=3D GEN5_SOP_KEY)
+               return true;
+
+       return false;
+}
+
+bool cyapa_gen5_sort_tsg_pip_app_resp_data(struct cyapa *cyapa,
+               u8 *data, int len)
+{
+       int resp_len;
+
+       if (!data || len < GEN5_MIN_APP_RESP_LENGTH)
+               return false;
+
+       if (data[GEN5_RESP_REPORT_ID_OFFSET] =3D=3D GEN5_APP_RESP_REPORT_ID=
 &&
+                       data[GEN5_RESP_RSVD_OFFSET] =3D=3D GEN5_RESP_RSVD_K=
EY) {
+               resp_len =3D get_unaligned_le16(&data[0]);
+               if (GET_GEN5_CMD_CODE(data[GEN5_RESP_APP_CMD_OFFSET]) =3D=
=3D 0x00 &&
+                       resp_len =3D=3D GEN5_UNSUPPORTED_CMD_RESP_LENGTH &&
+                       data[5] =3D=3D gen5_pip->in_progress_cmd) {
+                       /* unsupported command code */
+                       return false;
+               } else if (GET_GEN5_CMD_CODE(data[GEN5_RESP_APP_CMD_OFFSET]=
) =3D=3D
+                               gen5_pip->in_progress_cmd) {
+                       /* correct command response received */
+                       return true;
+               }
+       }
+
+       return false;
+}
+
+bool cyapa_gen5_sort_application_launch_data(struct cyapa *cyapa,
+               u8 *buf, int len)
+{
+       if (buf =3D=3D NULL || len < GEN5_RESP_LENGTH_SIZE)
+               return false;
+
+       if (buf[0] =3D=3D 0 && buf[1] =3D=3D 0)
+               return true;
+
+       return false;
+}
+
+static bool cyapa_gen5_sort_hid_descriptor_data(struct cyapa *cyapa,
+               u8 *buf, int len)
+{
+       int resp_len;
+       int max_output_len;
+
+       /* check hid descriptor. */
+       if (len !=3D GEN5_HID_DESCRIPTOR_SIZE)
+               return false;
+
+       resp_len =3D get_unaligned_le16(&buf[0]);
+       max_output_len =3D get_unaligned_le16(&buf[16]);
+       if (resp_len =3D=3D GEN5_HID_DESCRIPTOR_SIZE) {
+               if (buf[2] =3D=3D GEN5_BL_HID_REPORT_ID &&
+                               max_output_len =3D=3D GEN5_BL_MAX_OUTPUT_LE=
NGTH) {
+                       /* BL mode HID Descriptor */
+                       return true;
+               } else if (buf[2] =3D=3D GEN5_APP_HID_REPORT_ID &&
+                               max_output_len =3D=3D GEN5_APP_MAX_OUTPUT_L=
ENGTH) {
+                       /* APP mode HID Descriptor */
+                       return true;
+               }
+       }
+
+       return false;
+}
+
+static bool cyapa_gen5_sort_deep_sleep_data(struct cyapa *cyapa,
+               u8 *buf, int len)
+{
+       if (len =3D=3D GEN5_DEEP_SLEEP_RESP_LENGTH &&
+               buf[2] =3D=3D GEN5_APP_DEEP_SLEEP_REPORT_ID &&
+               (buf[4] & GEN5_DEEP_SLEEP_OPCODE_MASK) =3D=3D
+                       GEN5_DEEP_SLEEP_OPCODE)
+               return true;
+       return false;
+}
+
+static int cyapa_gen5_state_parse(struct cyapa *cyapa, u8 *reg_data, int l=
en)
+{
+       int ret;
+       int length;
+       u8 cmd[2];
+       u8 resp_data[32];
+       int max_output_len;
+
+       /*
+        * Try to dump all bufferred data if it's known gen5 trackpad
+        * before detecting. Because the irq routine may disabled
+        * before enter this routine.
+        */
+       if (cyapa->gen =3D=3D CYAPA_GEN5)
+               cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+       cyapa_enable_irq_save(cyapa);
+
+       /* Parse based on Gen5 characteristic regiters and bits */
+       length =3D get_unaligned_le16(&reg_data[0]);
+       if (length =3D=3D 0 || length =3D=3D GEN5_RESP_LENGTH_SIZE) {
+               /* dump all buffered data firstly for the situation
+                * when the trackpad is just power on the cyapa go here. */
+               cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+               memset(resp_data, 0, sizeof(resp_data));
+               ret =3D cyapa_i2c_pip_read(cyapa, resp_data, 3);
+               if (ret !=3D 3)
+                       goto out;
+
+               length =3D get_unaligned_le16(&resp_data[0]);
+               if (length =3D=3D GEN5_RESP_LENGTH_SIZE) {
+                       /* normal state of Gen5 with no data to respose */
+                       cyapa->gen =3D CYAPA_GEN5;
+
+                       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL=
);
+
+                       /* read description from trackpad device */
+                       cmd[0] =3D 0x01;
+                       cmd[1] =3D 0x00;
+                       length =3D GEN5_HID_DESCRIPTOR_SIZE;
+                       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                                       cmd, 2,
+                                       resp_data, &length,
+                                       300,
+                                       cyapa_gen5_sort_hid_descriptor_data=
);
+                       if (ret)
+                               goto out;
+
+                       length =3D get_unaligned_le16(&resp_data[0]);
+                       max_output_len =3D get_unaligned_le16(&resp_data[16=
]);
+                       if ((length =3D=3D GEN5_HID_DESCRIPTOR_SIZE ||
+                                       length =3D=3D GEN5_RESP_LENGTH_SIZE=
) &&
+                               resp_data[2] =3D=3D GEN5_BL_HID_REPORT_ID &=
&
+                               max_output_len =3D=3D GEN5_BL_MAX_OUTPUT_LE=
NGTH) {
+                               /* BL mode HID Description read */
+                               cyapa->state =3D CYAPA_STATE_GEN5_BL;
+                       } else if ((length =3D=3D GEN5_HID_DESCRIPTOR_SIZE =
||
+                                       length =3D=3D GEN5_RESP_LENGTH_SIZE=
) &&
+                               resp_data[2] =3D=3D GEN5_APP_HID_REPORT_ID =
&&
+                               max_output_len =3D=3D GEN5_APP_MAX_OUTPUT_L=
ENGTH) {
+                               /* APP mode HID Description read */
+                               cyapa->state =3D CYAPA_STATE_GEN5_APP;
+                       } else {
+                               /* should not happen!!! */
+                               cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+                       }
+               }
+       } else if (length =3D=3D GEN5_HID_DESCRIPTOR_SIZE &&
+                       (reg_data[2] =3D=3D GEN5_BL_HID_REPORT_ID ||
+                               reg_data[2] =3D=3D GEN5_APP_HID_REPORT_ID))=
 {
+               /* 0x20 0x00 0xF7 is Gen5 Application HID Description Heade=
r;
+                * 0x20 0x00 0xFF is Gen5 Booloader HID Description Header.
+                *
+                * must read Report Description content through out,
+                * otherwise Gen5 trackpad cannot reponse next command
+                * or report any touch or button data.
+                */
+               ret =3D cyapa_i2c_pip_read(cyapa, resp_data,
+                               GEN5_HID_DESCRIPTOR_SIZE);
+               if (ret !=3D GEN5_HID_DESCRIPTOR_SIZE)
+                       goto out;
+               length =3D get_unaligned_le16(&resp_data[0]);
+               max_output_len =3D get_unaligned_le16(&resp_data[16]);
+               if (length =3D=3D GEN5_RESP_LENGTH_SIZE) {
+                       if (reg_data[2] =3D=3D GEN5_BL_HID_REPORT_ID) {
+                               /* BL mode HID Description has been previou=
sly
+                                * read out */
+                               cyapa->gen =3D CYAPA_GEN5;
+                               cyapa->state =3D CYAPA_STATE_GEN5_BL;
+                       } else {
+                               /* APP mode HID Description has been previo=
usly
+                                * read out */
+                               cyapa->gen =3D CYAPA_GEN5;
+                               cyapa->state =3D CYAPA_STATE_GEN5_APP;
+                       }
+               } else if (length =3D=3D GEN5_HID_DESCRIPTOR_SIZE &&
+                               resp_data[2] =3D=3D GEN5_BL_HID_REPORT_ID &=
&
+                               max_output_len =3D=3D GEN5_BL_MAX_OUTPUT_LE=
NGTH) {
+                       /* BL mode HID Description read */
+                       cyapa->gen =3D CYAPA_GEN5;
+                       cyapa->state =3D CYAPA_STATE_GEN5_BL;
+               } else if (length =3D=3D GEN5_HID_DESCRIPTOR_SIZE &&
+                               resp_data[2] =3D=3D GEN5_APP_HID_REPORT_ID =
&&
+                               max_output_len =3D=3D GEN5_APP_MAX_OUTPUT_L=
ENGTH) {
+                       /* APP mode HID Description read */
+                       cyapa->gen =3D CYAPA_GEN5;
+                       cyapa->state =3D CYAPA_STATE_GEN5_APP;
+               } else {
+                       /* should not happen!!! */
+                       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+               }
+       } else if ((length =3D=3D GEN5_APP_REPORT_DESCRIPTOR_SIZE ||
+                       length =3D=3D GEN5_APP_CONTRACT_REPORT_DESCRIPTOR_S=
IZE) &&
+                       reg_data[2] =3D=3D GEN5_APP_REPORT_DESCRIPTOR_ID) {
+               /* 0xEE 0x00 0xF6 is Gen5 APP Report Description header. */
+               cyapa->gen =3D CYAPA_GEN5;
+               cyapa->state =3D CYAPA_STATE_GEN5_APP;
+
+               /*
+                * must read Report Description content through out,
+                * otherwise Gen5 trackpad cannot reponse next command
+                * or report any touch or button data.
+                */
+       } else if (length =3D=3D GEN5_BL_REPORT_DESCRIPTOR_SIZE &&
+                       reg_data[2] =3D=3D GEN5_BL_REPORT_DESCRIPTOR_ID) {
+               /* 0x1D 0x00 0xFE is Gen5 BL Report Descriptior header. */
+               cyapa->gen =3D CYAPA_GEN5;
+               cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+
+               /*
+                * must read Report Description content through out,
+                * otherwise Gen5 trackpad cannot reponse next command
+                * or report any touch or button data.
+                */
+               ret =3D cyapa_i2c_pip_read(cyapa, gen5_pip->empty_buf,
+                               GEN5_BL_REPORT_DESCRIPTOR_SIZE);
+               if (ret =3D=3D GEN5_BL_REPORT_DESCRIPTOR_SIZE)
+                       cyapa->state =3D CYAPA_STATE_GEN5_BL;
+       } else if (reg_data[2] =3D=3D GEN5_TOUCH_REPORT_ID ||
+                       reg_data[2] =3D=3D GEN5_BTN_REPORT_ID ||
+                       reg_data[2] =3D=3D GEN5_OLD_PUSH_BTN_REPORT_ID ||
+                       reg_data[2] =3D=3D GEN5_PUSH_BTN_REPORT_ID ||
+                       reg_data[2] =3D=3D GEN5_WAKEUP_EVENT_REPORT_ID) {
+               ret =3D 0;
+               length =3D get_unaligned_le16(&reg_data[0]);
+               switch (reg_data[2]) {
+               case GEN5_TOUCH_REPORT_ID:
+                       if (length < GEN5_TOUCH_REPORT_HEAD_SIZE ||
+                               length > GEN5_TOUCH_REPORT_MAX_SIZE)
+                               ret =3D -EAGAIN;
+                       break;
+               case GEN5_BTN_REPORT_ID:
+               case GEN5_OLD_PUSH_BTN_REPORT_ID:
+               case GEN5_PUSH_BTN_REPORT_ID:
+                       if (length < GEN5_BTN_REPORT_HEAD_SIZE ||
+                               length > GEN5_BTN_REPORT_MAX_SIZE)
+                               ret =3D -EAGAIN;
+                       break;
+               case GEN5_WAKEUP_EVENT_REPORT_ID:
+                       if (length !=3D GEN5_WAKEUP_EVENT_SIZE)
+                               ret =3D -EAGAIN;
+                       break;
+               }
+
+               if (ret =3D=3D 0) {
+                       cyapa->gen =3D CYAPA_GEN5;
+                       cyapa->state =3D CYAPA_STATE_GEN5_APP;
+               }
+       } else if (reg_data[2] =3D=3D GEN5_BL_RESP_REPORT_ID ||
+                       reg_data[2] =3D=3D GEN5_APP_RESP_REPORT_ID) {
+               /*
+                * must read report data through out,
+                * otherwise Gen5 trackpad cannot reponse next command
+                * or report any touch or button data.
+                */
+               length =3D get_unaligned_le16(reg_data);
+               ret =3D cyapa_i2c_pip_read(cyapa, gen5_pip->empty_buf, leng=
th);
+               if (ret !=3D length)
+                       goto out;
+
+               if (length =3D=3D GEN5_RESP_LENGTH_SIZE) {
+                       /* previous command has read the data through out. =
*/
+                       if (reg_data[2] =3D=3D GEN5_BL_RESP_REPORT_ID) {
+                               /* Gen5 BL command response data detected *=
/
+                               cyapa->gen =3D CYAPA_GEN5;
+                               cyapa->state =3D CYAPA_STATE_GEN5_BL;
+                       } else {
+                               /* Gen5 APP command response data detected =
*/
+                               cyapa->gen =3D CYAPA_GEN5;
+                               cyapa->state =3D CYAPA_STATE_GEN5_APP;
+                       }
+               } else if (gen5_pip->empty_buf[2] =3D=3D GEN5_BL_RESP_REPOR=
T_ID &&
+                               gen5_pip->empty_buf[3] =3D=3D GEN5_RESP_RSV=
D_KEY &&
+                               gen5_pip->empty_buf[4] =3D=3D GEN5_SOP_KEY =
&&
+                               gen5_pip->empty_buf[length - 1] =3D=3D
+                                       GEN5_EOP_KEY) {
+                       /* Gen5 BL command response data detected */
+                       cyapa->gen =3D CYAPA_GEN5;
+                       cyapa->state =3D CYAPA_STATE_GEN5_BL;
+               } else if (gen5_pip->empty_buf[2] =3D=3D GEN5_APP_RESP_REPO=
RT_ID &&
+                               gen5_pip->empty_buf[3] =3D=3D GEN5_RESP_RSV=
D_KEY) {
+                       /* Gen5 APP command response data detected */
+                       cyapa->gen =3D CYAPA_GEN5;
+                       cyapa->state =3D CYAPA_STATE_GEN5_APP;
+               } else {
+                       /* should not happen!!! */
+                       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+               }
+       }
+out:
+       cyapa_irq_restore(cyapa);
+       if (cyapa->gen =3D=3D CYAPA_GEN5 && (cyapa->state =3D=3D CYAPA_STAT=
E_GEN5_APP ||
+                       cyapa->state =3D=3D CYAPA_STATE_GEN5_BL)) {
+               cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+               return 0;
+       }
+       return -EAGAIN;
+}
+
+bool cyapa_gen5_sort_bl_exit_data(struct cyapa *cyapa, u8 *buf, int len)
+{
+       if (buf =3D=3D NULL || len < GEN5_RESP_LENGTH_SIZE)
+               return false;
+
+       if (buf[0] =3D=3D 0 && buf[1] =3D=3D 0)
+               return true;
+
+       /* exit bootloader failed for some reason. */
+       if (len =3D=3D GEN5_BL_FAIL_EXIT_RESP_LEN &&
+                       buf[2] =3D=3D GEN5_BL_RESP_REPORT_ID &&
+                       buf[3] =3D=3D GEN5_RESP_RSVD_KEY &&
+                       buf[4] =3D=3D GEN5_SOP_KEY &&
+                       buf[10] =3D=3D GEN5_EOP_KEY)
+               return true;
+
+       return false;
+}
+static int cyapa_gen5_bl_exit(struct cyapa *cyapa)
+{
+       int ret;
+       u8 resp_data[11];
+       int resp_len;
+       u8 bl_gen5_bl_exit[] =3D { 0x04, 0x00,
+               0x0B, 0x00, 0x40, 0x00, 0x01, 0x3b, 0x00, 0x00,
+               0x20, 0xc7, 0x17
+       };
+
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       bl_gen5_bl_exit, sizeof(bl_gen5_bl_exit),
+                       resp_data, &resp_len,
+                       5000, cyapa_gen5_sort_bl_exit_data);
+       if (ret)
+               return ret;
+
+       if (resp_len =3D=3D GEN5_BL_FAIL_EXIT_RESP_LEN ||
+                       resp_data[2] =3D=3D GEN5_BL_RESP_REPORT_ID)
+               return -EAGAIN;
+
+       if (resp_data[0] =3D=3D 0x00 && resp_data[1] =3D=3D 0x00)
+               return 0;
+
+       return -EAGAIN;
+}
+
+static int cyapa_gen5_change_power_state(struct cyapa *cyapa, u8 power_sta=
te)
+{
+       int ret;
+       u8 cmd[8] =3D { 0x04, 0x00, 0x06, 0x00, 0x2f, 0x00, 0x08, 0x01 };
+       u8 resp_data[6];
+       int resp_len;
+
+       cmd[7] =3D power_state;
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, sizeof(cmd),
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+       if (ret || resp_data[2] !=3D GEN5_APP_RESP_REPORT_ID ||
+                       resp_data[3] !=3D GEN5_RESP_RSVD_KEY ||
+                       GET_GEN5_CMD_CODE(resp_data[4]) !=3D 0x08 ||
+                       !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+               return ret < 0 ? ret : -EINVAL;
+
+       return 0;
+}
+
+static int cyapa_gen5_set_interval_time(struct cyapa *cyapa,
+               u8 parameter_id, u16 interval_time)
+{
+       int ret;
+       u8 cmd[13];
+       int cmd_len;
+       u8 resp_data[7];
+       int resp_len;
+       u8 parameter_size;
+
+       switch (parameter_id) {
+       case GEN5_PARAMETER_ACT_INTERVL_ID:
+               parameter_size =3D GEN5_PARAMETER_ACT_INTERVL_SIZE;
+               break;
+       case GEN5_PARAMETER_ACT_LFT_INTERVL_ID:
+               parameter_size =3D GEN5_PARAMETER_ACT_LFT_INTERVL_SIZE;
+               break;
+       case GEN5_PARAMETER_LP_INTRVL_ID:
+               parameter_size =3D GEN5_PARAMETER_LP_INTRVL_SIZE;
+               break;
+       default:
+               return -EINVAL;
+       }
+       cmd_len =3D 7 + parameter_size;  /* not incuding 2 bytes address */
+       cmd[0] =3D 0x04;
+       cmd[1] =3D 0x00;
+       put_unaligned_le16(cmd_len, &cmd[2]);
+       cmd[4] =3D 0x2f;
+       cmd[5] =3D 0x00;
+       cmd[6] =3D 0x06; /* set parameter command code */
+       cmd[7] =3D parameter_id;
+       cmd[8] =3D parameter_size;
+       put_unaligned_le16(interval_time, &cmd[9]);
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, cmd_len + 2,
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+       if (ret || resp_data[2] !=3D GEN5_APP_RESP_REPORT_ID ||
+                       resp_data[3] !=3D GEN5_RESP_RSVD_KEY ||
+                       GET_GEN5_CMD_CODE(resp_data[4]) !=3D 0x06 ||
+                       resp_data[5] !=3D parameter_id ||
+                       resp_data[6] !=3D parameter_size)
+               return ret < 0 ? ret : -EINVAL;
+
+       return 0;
+}
+
+static int cyapa_gen5_get_interval_time(struct cyapa *cyapa,
+               u8 parameter_id, u16 *interval_time)
+{
+       int ret;
+       u8 cmd[8];
+       u8 resp_data[11];
+       int resp_len;
+       u8 parameter_size;
+       u16 mask, i;
+
+       *interval_time =3D 0;
+       switch (parameter_id) {
+       case GEN5_PARAMETER_ACT_INTERVL_ID:
+               parameter_size =3D GEN5_PARAMETER_ACT_INTERVL_SIZE;
+               break;
+       case GEN5_PARAMETER_ACT_LFT_INTERVL_ID:
+               parameter_size =3D GEN5_PARAMETER_ACT_LFT_INTERVL_SIZE;
+               break;
+       case GEN5_PARAMETER_LP_INTRVL_ID:
+               parameter_size =3D GEN5_PARAMETER_LP_INTRVL_SIZE;
+               break;
+       default:
+               return -EINVAL;
+       }
+
+       cmd[0] =3D 0x04;
+       cmd[1] =3D 0x00;
+       cmd[2] =3D 0x06;
+       cmd[3] =3D 0x00;
+       cmd[4] =3D 0x2f;
+       cmd[5] =3D 0x00;
+       cmd[6] =3D 0x05; /* get parameter command code */
+       cmd[7] =3D parameter_id;
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, sizeof(cmd),
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+       if (ret || resp_data[2] !=3D GEN5_APP_RESP_REPORT_ID ||
+                       resp_data[3] !=3D GEN5_RESP_RSVD_KEY ||
+                       GET_GEN5_CMD_CODE(resp_data[4]) !=3D 0x05 ||
+                       resp_data[5] !=3D parameter_id ||
+                       resp_data[6] =3D=3D 0)
+               return ret < 0 ? ret : -EINVAL;
+
+       mask =3D 0;
+       for (i =3D 0; i < parameter_size; i++)
+               mask |=3D (0xff << (i * 8));
+       *interval_time =3D get_unaligned_le16(&resp_data[7]) & mask;
+
+       return 0;
+}
+
+static int cyapa_gen5_disable_pip_report(struct cyapa *cyapa)
+{
+       int ret;
+       u8 cmd[10];
+       u8 resp_data[7];
+       int resp_len;
+
+       cmd[0] =3D 0x04;
+       cmd[1] =3D 0x00;
+       put_unaligned_le16(8, &cmd[2]);
+       cmd[4] =3D 0x2f;
+       cmd[5] =3D 0x00;
+       cmd[6] =3D 0x06; /* set parameter command code */
+       cmd[7] =3D GEN5_PARAMETER_DISABLE_PIP_REPORT;
+       cmd[8] =3D 0x01;
+       cmd[9] =3D 0x01;
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, 10,
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+       if (ret || resp_data[2] !=3D GEN5_APP_RESP_REPORT_ID ||
+                       resp_data[3] !=3D GEN5_RESP_RSVD_KEY ||
+                       GET_GEN5_CMD_CODE(resp_data[4]) !=3D 0x06 ||
+                       resp_data[5] !=3D GEN5_PARAMETER_DISABLE_PIP_REPORT=
 ||
+                       resp_data[6] !=3D 0x01)
+               return ret < 0 ? ret : -EINVAL;
+
+       return 0;
+}
+
+static int cyapa_gen5_deep_sleep(struct cyapa *cyapa, u8 state)
+{
+       int ret;
+       u8 cmd[4] =3D { 0x05, 0x00, 0x00, 0x08};
+       u8 resp_data[5];
+       int resp_len;
+
+       cmd[0] =3D 0x05;
+       cmd[1] =3D 0x00;
+       cmd[2] =3D state & GEN5_DEEP_SLEEP_STATE_MASK;
+       cmd[3] =3D 0x08;
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, sizeof(cmd),
+                       resp_data, &resp_len,
+                       100, cyapa_gen5_sort_deep_sleep_data);
+       if (ret || ((resp_data[3] & GEN5_DEEP_SLEEP_STATE_MASK) !=3D state)=
)
+               return -EINVAL;
+
+       return 0;
+}
+
+static int cyapa_gen5_set_power_mode(struct cyapa *cyapa,
+               u8 power_mode, u16 sleep_time)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       int ret;
+       u8 power_state;
+
+       if (cyapa->state !=3D CYAPA_STATE_GEN5_APP)
+               return 0;
+
+       /* dump all the report data before do power mode commmands. */
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       if (gen5_pwr_mode !=3D PWR_MODE_OFF &&
+                       GEN5_UNINIT_SLEEP_TIME(gen5_sleep_time)) {
+               if (cyapa_gen5_get_interval_time(cyapa,
+                               GEN5_PARAMETER_LP_INTRVL_ID,
+                               &gen5_sleep_time) !=3D 0)
+                       gen5_sleep_time =3D UNINIT_SLEEP_TIME;
+       }
+
+       switch (power_mode) {
+       case PWR_MODE_OFF:
+       case PWR_MODE_FULL_ACTIVE:
+       case PWR_MODE_BTN_ONLY:
+               /* has in correct power mode state, early return. */
+               if (gen5_pwr_mode =3D=3D power_mode)
+                       return 0;
+
+               /* enter deep sleep directly without any additional steps. =
*/
+               if (power_mode =3D=3D PWR_MODE_OFF) {
+                       ret =3D cyapa_gen5_deep_sleep(cyapa,
+                               GEN5_DEEP_SLEEP_STATE_OFF);
+                       if (ret) {
+                               dev_err(dev, "enter deep sleep fail, (%d)\n=
",
+                                       ret);
+                               return ret;
+                       }
+                       gen5_pwr_mode =3D power_mode;
+                       return 0;
+               }
+       default:
+               /* has in correct power mode state, early return. */
+               if (gen5_sleep_time =3D=3D sleep_time &&
+                       gen5_pwr_mode =3D=3D power_mode)
+                       return 0;
+       }
+
+       /* when trackpad in power off mode, it cannot change to other power
+        * state directly, must be wake up from sleep firstly, then
+        * continue to do next power sate change. */
+       if (gen5_pwr_mode =3D=3D PWR_MODE_OFF) {
+               ret =3D cyapa_gen5_deep_sleep(cyapa, GEN5_DEEP_SLEEP_STATE_=
ON);
+               if (ret) {
+                       dev_err(dev, "deep sleep wake fail, (%d)\n", ret);
+                       return ret;
+               }
+       }
+
+       if (power_mode =3D=3D PWR_MODE_FULL_ACTIVE) {
+               ret =3D cyapa_gen5_change_power_state(cyapa,
+                               GEN5_POWER_STATE_ACTIVE);
+               if (ret) {
+                       dev_err(dev, "change to active fail, (%d)\n", ret);
+                       return ret;
+               }
+
+               gen5_pwr_mode =3D PWR_MODE_FULL_ACTIVE;
+       } else if (power_mode =3D=3D PWR_MODE_BTN_ONLY) {
+               ret =3D cyapa_gen5_change_power_state(cyapa,
+                               GEN5_POWER_STATE_BTN_ONLY);
+               if (ret) {
+                       dev_err(dev, "fail change to active, (%d)\n", ret);
+                       return ret;
+               }
+
+               gen5_pwr_mode =3D PWR_MODE_BTN_ONLY;
+       } else {
+               /* continue to change power mode even failed to set
+                * interval time, it won't affect the power mode change.
+                * except the sleep interval time is not correct. */
+               if (GEN5_UNINIT_SLEEP_TIME(gen5_sleep_time) ||
+                               sleep_time !=3D gen5_sleep_time)
+                       if (cyapa_gen5_set_interval_time(cyapa,
+                               GEN5_PARAMETER_LP_INTRVL_ID, sleep_time) =
=3D=3D 0)
+                                       gen5_sleep_time =3D sleep_time;
+
+               if (sleep_time <=3D GEN5_POWER_READY_MAX_INTRVL_TIME)
+                       power_state =3D GEN5_POWER_STATE_READY;
+               else
+                       power_state =3D GEN5_POWER_STATE_IDLE;
+               ret =3D cyapa_gen5_change_power_state(cyapa, power_state);
+               if (ret) {
+                       dev_err(dev, "set power state %d fail, (%d)\n",
+                               power_state, ret);
+                       return ret;
+               }
+
+               /* disable pip report for a little time, firmware will
+                * re-enable it automatically. It's used to fix the issue
+                * that trackpad unable to report signal to wake system up
+                * in the special situation that system is in suspending, a=
nd
+                * at the same time, user touch trackpad to wake system up.
+                * This function can avoid the data to be buffured when sys=
tem
+                * is suspending which may cause interrput line unable to b=
e
+                * asserted again. */
+               cyapa_gen5_disable_pip_report(cyapa);
+
+               gen5_pwr_mode =3D cyapa_sleep_time_to_pwr_cmd(sleep_time);
+       }
+
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+       return ret;
+}
+
+static bool cyapa_gen5_sort_system_info_data(struct cyapa *cyapa,
+               u8 *buf, int len)
+{
+       /* check the report id and command code */
+       if (buf[2] =3D=3D GEN5_APP_RESP_REPORT_ID &&
+                       GET_GEN5_CMD_CODE(buf[4]) =3D=3D 0x02)
+               return true;
+
+       return false;
+}
+
+static int cyapa_gen5_bl_query_data(struct cyapa *cyapa)
+{
+       int ret;
+       u8 cmd[16];
+       int cmd_len;
+       u8 resp_data[GEN5_BL_READ_APP_INFO_RESP_LEN];
+       int resp_len;
+
+       /* read application information. */
+       cmd[0] =3D 0x04;
+       cmd[1] =3D 0x00;
+       cmd[2] =3D 0x0b;
+       cmd[3] =3D 0x00;
+       cmd[4] =3D 0x40;
+       cmd[5] =3D 0x00;
+       cmd[6] =3D GEN5_SOP_KEY;
+       cmd[7] =3D 0x3c;  /* read application information command code */
+       cmd[8] =3D 0x00;
+       cmd[9] =3D 0x00;
+       cmd[10] =3D 0xb0;
+       cmd[11] =3D 0x42;
+       cmd[12] =3D GEN5_EOP_KEY;
+       cmd_len =3D 13;
+       resp_len =3D GEN5_BL_READ_APP_INFO_RESP_LEN;
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, cmd_len,
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_bl_resp_data);
+       if (ret || resp_len !=3D GEN5_BL_READ_APP_INFO_RESP_LEN ||
+                       resp_data[2] !=3D GEN5_BL_RESP_REPORT_ID ||
+                       !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+               return (ret < 0) ? ret : -EIO;
+
+       memcpy(&cyapa->product_id[0], &resp_data[8], 5);
+       cyapa->product_id[5] =3D '-';
+       memcpy(&cyapa->product_id[6], &resp_data[13], 6);
+       cyapa->product_id[12] =3D '-';
+       memcpy(&cyapa->product_id[13], &resp_data[19], 2);
+       cyapa->product_id[15] =3D '\0';
+
+       cyapa->fw_maj_ver =3D resp_data[22];
+       cyapa->fw_min_ver =3D resp_data[23];
+
+       return 0;
+}
+
+static int cyapa_gen5_get_query_data(struct cyapa *cyapa)
+{
+       int ret;
+       u8 resp_data[71];
+       int resp_len;
+       u8 get_system_information[] =3D {
+               0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x02
+       };
+       u16 product_family;
+
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       get_system_information, sizeof(get_system_informati=
on),
+                       resp_data, &resp_len,
+                       2000, cyapa_gen5_sort_system_info_data);
+       if (ret || resp_len < sizeof(resp_data))
+               return ret;
+
+       gen5_fw_img_head.head_size =3D
+               sizeof(struct cyapa_tsg_bin_image_head) - 1;
+       memcpy(&gen5_fw_img_head.ttda_driver_major_version,
+               &resp_data[5], gen5_fw_img_head.head_size);
+
+       product_family =3D get_unaligned_le16(&resp_data[7]);
+       if ((product_family & GEN5_PRODUCT_FAMILY_MASK) !=3D
+               GEN5_PRODUCT_FAMILY_TRACKPAD)
+               return -EINVAL;
+
+       cyapa->fw_maj_ver =3D resp_data[15];
+       cyapa->fw_min_ver =3D resp_data[16];
+
+       cyapa->electrodes_x =3D resp_data[52];
+       cyapa->electrodes_y =3D resp_data[53];
+
+       cyapa->physical_size_x =3D  get_unaligned_le16(&resp_data[54]) / 10=
0;
+       cyapa->physical_size_y =3D get_unaligned_le16(&resp_data[56]) / 100=
;
+
+       cyapa->max_abs_x =3D get_unaligned_le16(&resp_data[58]);
+       cyapa->max_abs_y =3D get_unaligned_le16(&resp_data[60]);
+
+       cyapa->max_z =3D get_unaligned_le16(&resp_data[62]);
+
+       cyapa->x_origin =3D resp_data[64] & 0x01;
+       cyapa->y_origin =3D resp_data[65] & 0x01;
+
+       cyapa->btn_capability =3D (resp_data[70] << 3) & CAPABILITY_BTN_MAS=
K;
+
+       memcpy(&cyapa->product_id[0], &resp_data[33], 5);
+       cyapa->product_id[5] =3D '-';
+       memcpy(&cyapa->product_id[6], &resp_data[38], 6);
+       cyapa->product_id[12] =3D '-';
+       memcpy(&cyapa->product_id[13], &resp_data[44], 2);
+       cyapa->product_id[15] =3D '\0';
+
+       if (!cyapa->electrodes_x || !cyapa->electrodes_y ||
+               !cyapa->physical_size_x || !cyapa->physical_size_y ||
+               !cyapa->max_abs_x || !cyapa->max_abs_y || !cyapa->max_z)
+               return -EINVAL;
+
+       return 0;
+}
+
+static int cyapa_gen5_do_operational_check(struct cyapa *cyapa)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       int ret;
+
+       if (cyapa->gen !=3D CYAPA_GEN5)
+               return -EINVAL;
+
+       cyapa_enable_irq_save(cyapa);
+       switch (cyapa->state) {
+       case CYAPA_STATE_GEN5_BL:
+               ret =3D cyapa_gen5_bl_exit(cyapa);
+               if (ret) {
+                       /* try to update trackpad product information. */
+                       cyapa_gen5_bl_query_data(cyapa);
+                       goto out;
+               }
+
+               cyapa->state =3D CYAPA_STATE_GEN5_APP;
+
+       case CYAPA_STATE_GEN5_APP:
+               /* if trackpad device in deep sleep mode,
+                * the app command will fail.
+                * So always reset trackpad device to full active when
+                * the device state is requeried.
+                */
+               ret =3D cyapa_gen5_set_power_mode(cyapa, PWR_MODE_FULL_ACTI=
VE, 0);
+               if (ret)
+                       goto out;
+
+               /* Get trackpad product information. */
+               ret =3D cyapa_gen5_get_query_data(cyapa);
+               if (ret)
+                       goto out;
+               /* only support product ID starting with CYTRA */
+               if (memcmp(cyapa->product_id, unique_str,
+                               strlen(unique_str)) !=3D 0) {
+                       dev_err(dev, "%s: unknown product ID (%s)\n",
+                               __func__, cyapa->product_id);
+                       ret =3D -EINVAL;
+               }
+               break;
+       default:
+               ret =3D -EINVAL;
+       }
+
+out:
+       cyapa_irq_restore(cyapa);
+       return ret;
+}
+
+/*
+ * return false, do not continue process
+ * return true, continue process.
+ */
+static bool cyapa_gen5_irq_cmd_handler(struct cyapa *cyapa)
+{
+       int length;
+
+       if (atomic_read(&gen5_pip->cmd_issued)) {
+               /*
+                * read out all none command response data.
+                * these output data may caused by user put finger on
+                * trackpad when host waiting the command response.
+                */
+               cyapa_i2c_pip_read(cyapa, gen5_pip->irq_cmd_buf, 2);
+               length =3D get_unaligned_le16(gen5_pip->irq_cmd_buf);
+               length =3D (length <=3D 2) ? 2 : length;
+               if (length > 2)
+                       cyapa_i2c_pip_read(cyapa,
+                               gen5_pip->irq_cmd_buf, length);
+               if (!(gen5_pip->resp_sort_func &&
+                       gen5_pip->resp_sort_func(cyapa,
+                               gen5_pip->irq_cmd_buf, length))) {
+                       /*
+                        * Cover the Gen5 V1 firmware issue.
+                        * The issue is there is no interrut will be
+                        * asserted to notityf host to read a command
+                        * data out when always has finger touch on
+                        * trackpad during the command is issued to
+                        * trackad device.
+                        * This issue has the scenario is that,
+                        * user always has his fingers touched on
+                        * trackpad device when booting/rebooting
+                        * their chrome book.
+                        */
+                       length =3D *gen5_pip->resp_len;
+                       cyapa_empty_pip_output_data(cyapa,
+                                       gen5_pip->resp_data,
+                                       &length,
+                                       gen5_pip->resp_sort_func);
+                       if (gen5_pip->resp_len && length !=3D 0) {
+                               *gen5_pip->resp_len =3D length;
+                               atomic_dec(&gen5_pip->cmd_issued);
+                               complete(&gen5_pip->cmd_ready);
+                       }
+                       return false;
+               }
+
+               if (gen5_pip->resp_data && gen5_pip->resp_len) {
+                       *gen5_pip->resp_len =3D (*gen5_pip->resp_len < leng=
th) ?
+                               *gen5_pip->resp_len : length;
+                       memcpy(gen5_pip->resp_data, gen5_pip->irq_cmd_buf,
+                               *gen5_pip->resp_len);
+               }
+               atomic_dec(&gen5_pip->cmd_issued);
+               complete(&gen5_pip->cmd_ready);
+               return false;
+       }
+
+       return true;
+}
+
+static void cyapa_gen5_irq_handler(struct cyapa *cyapa)
+{
+       struct input_dev *input =3D cyapa->input;
+       struct cyapa_gen5_report_data report_data;
+       int i;
+       int ret;
+       u8 report_id;
+       u8 buttons;
+       unsigned int report_len, touch_num;
+       int x, y;
+
+       if (cyapa->gen !=3D CYAPA_GEN5 ||
+               cyapa->state !=3D CYAPA_STATE_GEN5_APP) {
+               async_schedule(cyapa_detect_async, cyapa);
+               return;
+       }
+
+       ret =3D cyapa_i2c_pip_read(cyapa, (u8 *)&report_data,
+                       GEN5_TOUCH_REPORT_HEAD_SIZE);
+       if (ret !=3D GEN5_TOUCH_REPORT_HEAD_SIZE) {
+               /* failed to read report head data. */
+               async_schedule(cyapa_detect_async, cyapa);
+               return;
+       }
+
+       report_len =3D get_unaligned_le16(&report_data.report_head[0]);
+       if (report_len <=3D 2) {
+               /*
+                * trackpad power up event or end of one touch packets repo=
rt,
+                * no data for report.
+                */
+               if (report_len !=3D 2)
+                       async_schedule(cyapa_detect_async, cyapa);
+
+               return;
+       }
+
+       report_id =3D report_data.report_head[2];
+       if (report_id =3D=3D GEN5_WAKEUP_EVENT_REPORT_ID &&
+                       report_len =3D=3D GEN5_WAKEUP_EVENT_SIZE) {
+               /* Wake event from deep sleep mode, reset power state. */
+               return;
+       } else if (report_id !=3D GEN5_TOUCH_REPORT_ID &&
+                       report_id !=3D GEN5_BTN_REPORT_ID &&
+                       report_id !=3D GEN5_OLD_PUSH_BTN_REPORT_ID &&
+                       report_id !=3D GEN5_PUSH_BTN_REPORT_ID) {
+               /* Running in BL mode or unknown response data read. */
+
+               async_schedule(cyapa_detect_async, cyapa);
+               return;
+       }
+
+       if (report_len > GEN5_TOUCH_REPORT_HEAD_SIZE) {
+               /* must make sure to read all data through out before retur=
n. */
+               ret =3D cyapa_i2c_pip_read(cyapa, (u8 *)&report_data, repor=
t_len);
+               if (ret !=3D report_len) {
+                       /* failed to read report head data. */
+                       async_schedule(cyapa_detect_async, cyapa);
+                       return;
+               }
+       }
+
+       if (report_id =3D=3D GEN5_TOUCH_REPORT_ID &&
+               (report_len < GEN5_TOUCH_REPORT_HEAD_SIZE ||
+                       report_len > GEN5_TOUCH_REPORT_MAX_SIZE)) {
+               /* Invald report data length for finger packet. */
+               async_schedule(cyapa_detect_async, cyapa);
+               return;
+       }
+
+       if ((report_id =3D=3D GEN5_BTN_REPORT_ID ||
+                       report_id =3D=3D GEN5_OLD_PUSH_BTN_REPORT_ID ||
+                       report_id =3D=3D GEN5_PUSH_BTN_REPORT_ID) &&
+               (report_len < GEN5_BTN_REPORT_HEAD_SIZE ||
+                       report_len > GEN5_BTN_REPORT_MAX_SIZE)) {
+               /* Invald report data length of button packet. */
+               async_schedule(cyapa_detect_async, cyapa);
+               return;
+       }
+
+       if (report_id =3D=3D GEN5_BTN_REPORT_ID ||
+                       report_id =3D=3D GEN5_OLD_PUSH_BTN_REPORT_ID ||
+                       report_id =3D=3D GEN5_PUSH_BTN_REPORT_ID) {
+               /* button report data */
+               buttons =3D (report_data.report_head[5] << 3) &
+                                       CAPABILITY_BTN_MASK;
+               if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK) {
+                       input_report_key(input, BTN_LEFT,
+                               !!(buttons & CAPABILITY_LEFT_BTN_MASK));
+               }
+               if (cyapa->btn_capability & CAPABILITY_MIDDLE_BTN_MASK) {
+                       input_report_key(input, BTN_MIDDLE,
+                               !!(buttons & CAPABILITY_MIDDLE_BTN_MASK));
+               }
+               if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK) {
+                       input_report_key(input, BTN_RIGHT,
+                               !!(buttons & CAPABILITY_RIGHT_BTN_MASK));
+               }
+
+               input_sync(input);
+       } else {
+               /* touch report data */
+               touch_num =3D report_data.report_head[5] &
+                                       GEN5_NUMBER_OF_TOUCH_MASK;
+
+               for (i =3D 0; i < touch_num; i++) {
+                       const struct cyapa_gen5_touch_record *touch =3D
+                               &report_data.touch_records[i];
+                       u8 event_id =3D
+                               GEN5_GET_EVENT_ID(touch->touch_tip_event_id=
);
+                       int slot =3D GEN5_GET_TOUCH_ID(touch->touch_tip_eve=
nt_id);
+
+                       if (event_id =3D=3D RECORD_EVENT_LIFTOFF)
+                               continue;
+
+                       input_mt_slot(input, slot);
+                       input_mt_report_slot_state(input, MT_TOOL_FINGER, t=
rue);
+                       x =3D (touch->x_hi << 8) | touch->x_lo;
+                       if (cyapa->x_origin)
+                               x =3D cyapa->max_abs_x - x;
+                       input_report_abs(input, ABS_MT_POSITION_X, x);
+                       y =3D (touch->y_hi << 8) | touch->y_lo;
+                       if (cyapa->y_origin)
+                               y =3D cyapa->max_abs_y - y;
+                       input_report_abs(input, ABS_MT_POSITION_Y, y);
+                       input_report_abs(input, ABS_MT_PRESSURE,
+                               touch->z);
+                       input_report_abs(input, ABS_MT_TOUCH_MAJOR,
+                               touch->major_axis_len);
+                       input_report_abs(input, ABS_MT_TOUCH_MINOR,
+                               touch->minor_axis_len);
+
+                       input_report_abs(input, ABS_MT_WIDTH_MAJOR,
+                               touch->major_tool_len);
+                       input_report_abs(input, ABS_MT_WIDTH_MINOR,
+                               touch->minor_tool_len);
+
+                       input_report_abs(input, ABS_MT_ORIENTATION,
+                               touch->orientation);
+               }
+
+               input_mt_sync_frame(input);
+
+               input_sync(input);
+       }
+}
+
+const struct cyapa_dev_ops cyapa_gen5_ops =3D {
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
+       cyapa_gen5_get_private_size,
+       cyapa_gen5_private_init,
+
+       cyapa_gen5_state_parse,
+       cyapa_gen5_do_operational_check,
+
+       cyapa_gen5_irq_handler,
+       cyapa_gen5_irq_cmd_handler,
+       cyapa_empty_pip_output_data,
+       cyapa_gen5_set_power_mode,
+};
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8ECS04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
4TQMowyUMDG5CjIzYg0ZCo8LmDIMo+RjNw6SMTfM7/sPIWcDBvQ10XNpemVvZp9N4QTlys85TzpR
Y202wOG7EnN5bmM6xQ8P9o3vCJw7IBS1CI0pGS/5bwTl3TsgJgbWHa8h3TUO0Ayh/9HP0tkVvz6F
+N/L7ANqJS//TdIUJugP6RrBnx6vBNfsL/9Pmiz/zo/PmylPFRjelg5h/77yBMk2FzFPy+8zzzJ/
z6+3Onr+f50jY0mwhFBll7D8b3fksCPgtJIAT9SWQAmfAY8CnwdvpsAYEFs4CY+1DpM2DFgy1UEN
NzgNdPcSWgQvBTE2BY8Gnzp/prH9RkE3RoJACRXPFB8VLxY//xdPGFxGIhwXVXEdny3vH78PIM9b
3yLhIy9fdHNnf8hDsXG7QlLPJbvYci7rIf+Y/+1nLN9YvwTX8EFiJvD8m2Pfhw9F7aAv40NN8XD8
Q0+18DVZ9CDF4GIhSTLLaA9tnyFqaU1Q2bCrwUhTVUO2MFNTNVk1X2vwOC8nn9jh3wA/VCM68zwB
PGBWQZUoU085zj0vvz4/I6SkQLsA1YDksHbcYH1eMGnlsEC/GP+3CEISYTxyYeWwegG7AFbRdTF+
Nv7SehhC/0QPSh9GIzH/8EBfr/7yVYEHLwR9T3CDTz9ND4VbfahSInSftwVzd//kAD+QNUB9qsXv
prHmAKrwoy/jwHBSQU1voVJikOpD7aFOj6FW7OAxILm+/7cGidxR8Y7/kAjaIsrf63ad5eFrlU6O
r4+1TEaQD/+Vn5Ivkz+ZXpUPlh+XL5g//9mg9PCZ0Zofmy+cP6Kfnr//n8+g37cA5KDcULDgua8y
T890TM1vTshRtTcgbTCJ3Y3jk27kUP7RY3Vkq9AoZyAyGxB5tLBzIP3kkGRfAbNg5m9GMt6iCeOf
oQ+C4rVlzM/IwnVu3GD8aWer4ISifpBXYlqz9UD/RjIvgF+fRjL0Ikhjuv9GQd9xALdPTthL0LV0
NrHQ47HveaF9mMOQ5aBtP7DlMMGQ/+Sgs/9PKYzJvp9GRonft+/3uP1567pVObrfUW9Sf1OP31Sf
Va9Ws7AWbTAye/+sP/9Z31rvW/9dD14fzR9gP2FP/2JfY2/WT2WPZp9nr98/ac//at9r6H6g4n/f
T3B53HKMuv/m/+vfSzrp3KYicT9yT3Nf/3RvdX92j3ef/t4/0HnPet/3e+98/34KKn7Pf9+A74H/
/0Zh/18Er/4PiB+JL8a/AXbTfpHBwHNrHBBp8j8aVf/8bL4iqG6MP41Pob+Tz6O//6TPpd8PH56v
qO+p/w5PnZ//EC8RPxJPGG+eTxpvFk8XX/+mz6OfGu8b/yJfp98fjyCf/6sPKK+tL64/CJ+03yDf
tv//ws3cUcAFMx9GUODhMq+7r++8v73Pvt8wtTXAY/dBwO//wf/DD8Qfyz/MT9nPzm/Pf/9WL1c/
6+/Tv9TPSD/W79f//9kP2h/bL9w/3U9LD0jf4H//4Y9T/+Ov5L/lzzvwWA9dn9/pH+ovXP9eD+1V
PTnh7t9/7+/w//IPZAgH8grPKOFme04AUMBpaMNQkGXBsP5prCsrY69oGnxCACg6ALpmULA8ZdBq
QbIQOHEgfyg+Ce/3Qrj9SmSGdQ1AJn8H42cP80/0X/Vv9nuysHPcYWLRoE5zRDBwTgH4X//48f1P
/l8Ev4LEMKB9X4YP/3wfBC8+PzCPMZ8578fvuXX+OLpfNx84Lzk/i3+/r8C/Bz1/Po8mT0RJU0FC
9ExFE2BJUxaNT8XWjQH+MZTPynOWL0EfQi+Yb0RP/0Vf0Mh+wEr/ZD9J30rvS///TQ9OH5qvUD9R
T1JfU2+jT/9Vj1afV6+sP1nPWt/mT6/P/6yfXxiSv5POs/+6L+z+mCL/bD9kv2XPZt90v3XPdt93
7/5lebAl4NGgebB6D9DDAeH/w5L9P3xPfv8AZIrjyAA7w/dG4I0Cy7k4wnDJjwH6jLD/pw+B/8BP
hBs8ANE/hh8zb/+Z8ccyc2Gxw7JwqqAn4JPwCddCVEEZwF9NQVP2S9TPNek4my+Zf6Zvm5//nK+d
v0bfvL+6j6Fv4a8o679+wKR/92DE+Nyvp74ospn/reHWv9fJs2PHJLyPLI+/rz/Av8HPwt/D749h
pdBvd/0M8W2Q0cWf+W/6fPXn/ATf6GT9Dws89pQrAHb0cJDxj/0R28GJIPcCLT5j99D926B0/lD9
EekfyS/47Mcjn/CP6an+BdZUqYFDWaoA/kHXxam27i/xnwKfKOOPMSBkdW1wIHGwbCD8dGgmIHmk
KvCpESmgKxDzpWAmIGRv+VRzgJDSkEJZkHJzLpEP9NVlCkB0enml02+H0IfCqQLgBk74VUxMENrp
CAMPqCD1Q0xwd/YUqXJQVx2gTaGyYV9PRkaJECYGj9OwrqnRVU4ZoEmq4Nd0/FRJHWATtPpps2D7
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
AAAAAAIBQQABAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwAZQB5ACAARAB1
AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAfAAJdAQAAACIA
AABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAOVfAQAAACoAAABzAGkAcAA6
AGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AGgwBAAAAFAAAAEQAdQBkAGwA
ZQB5ACAARAB1AAAAHwAfDAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAA
AAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEP
VAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBz
AHMALgBjAG8AbQAAAB8AAV0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0A
AAAAAB8A+D8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAHwAjQAEAAAAiAAAAZAB1AGQAbABA
AGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEA
AABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQ
AAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8ACV0BAAAAIgAAAGQAdQBkAGwA
QABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AMUABAAAAAgAAAAAAAAALAEA6AQAAAB8AMEAB
AAAAAgAAAAAAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8ECAAACwBAOgEA
AAADAP0/qAMAAAIBCzABAAAAEAAAAFKuWpNkOQdFgv9eiXMmVAkDABcAAQAAAEAAOQCAsTQHWYHP
AUAACDACN5MHWYHPAQsAKQAAAAAACwAjAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAA
YQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAAGgAAAHoAaAAtAEMATgAsACAAZQBu
AC0AVQBTAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAApAAAAFsA
UABBAFQAQwBIACAAdgAyACAAMQAwAC8AMQA0AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6
ACAAYQBkAGQAIABnAGUAbgA1ACAAdAByAGEAYwBrAHAAYQBkACAAZABlAHYAaQBjAGUAIABiAGEA
cwBpAGMAIABmAHUAbgBjAHQAaQBvAG4AcwAgAHMAdQBwAHAAbwByAHQAZQBkAAAAHwA9AAEAAAAC
AAAAAAAAAAMANgAAAAAAAgFxAAEAAAAWAAAAAc+BWO2zP4GJek4kSq6D/sI58RwMCwAAHwBwAAEA
AACkAAAAWwBQAEEAVABDAEgAIAB2ADIAIAAxADAALwAxADQAXQAgAGkAbgBwAHUAdAA6ACAAYwB5
AGEAcABhADoAIABhAGQAZAAgAGcAZQBuADUAIAB0AHIAYQBjAGsAcABhAGQAIABkAGUAdgBpAGMA
ZQAgAGIAYQBzAGkAYwAgAGYAdQBuAGMAdABpAG8AbgBzACAAcwB1AHAAcABvAHIAdABlAGQAAAAf
ADUQAQAAAIQAAAA8ADcANwBCAEMANwAyADUAQwA5ADAANgAyADcANgA0AEYAOAA3ADQARAA3ADkA
RgA1ADEARQAxAEYAMQBBADgARgA0ADQAMAA2AEMAOABFAEMAQABTADAANAAtAE0AQgBYADAAMQAt
ADAAMQAuAHMAMAA0AC4AbABvAGMAYQBsAD4AAAADAN4/n04AAAsAAIAIIAYAAAAAAMAAAAAAAABG
AAAAAAOFAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAAYUAAAAAAAADAACAAyAGAAAAAADA
AAAAAAAARgAAAAABgQAAAAAAAAMAgBD/////BQAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAoEAAAAA
AAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAHIEAAAAAAABAAAcwC53NA1mBzwELAAIAAQAA
AAMAJgAAAAAAAgEQMAEAAABGAAAAAAAAALEfoTkwIFFGnbSlcN7Qn9QHAHe8clyQYnZPh0159R4f
Go8AAACZPBsAALqnPu7L1/dAo3bvNfxhWYkAGIP8w08AAAAAHwD6PwEAAAAUAAAARAB1AGQAbABl
AHkAIABEAHUAAAADAAlZAQAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABCFAAAAAAAAHwAAgB+k
6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABU
AHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAALoAAABJAEkAPQAwADEAQwBGADgAMQA1ADgARQBEAEIA
MwAzAEYAOAAxADgAOQA3AEEANABFADIANAA0AEEAQQBFADgAMwBGAEUAQwAyADMAOQBGADEAMQBD
ADAAQwAwAEIAOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADMAIAAoAEIA
dQBpAGwAZAAgADEANwA0AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADQAAAAAAAMAAIADIAYAAAAA
AMAAAAAAAABGAAAAABOBAAABAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAI4EAAP///38DAACA
AyAGAAAAAADAAAAAAAAARgAAAAAQgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABGBAAAA
AAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJIEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAA
AAAsgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACmBAAAAAAAAAwAAgAMgBgAAAAAAwAAA
AAAAAEYAAAAAKoEAAAAAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAngQAAAQAAAAIAAAAAAAAA
AwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEoEAAAEAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAh
gQAAAQAAAAIAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAA4EAAAAAAAALAACAAyAGAAAA
AADAAAAAAAAARgAAAAAmgQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAA6FAAAAAAAAAwAA
gAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAACChQAA
AAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAt
AGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgA
LQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAeAAAAWwAxADAALgAzADAALgAx
ADIALgAxADQANgBdAAAAAAAOkw==

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8ECS04MBX0101s04lo_--
