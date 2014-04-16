Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaDPIg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:36:57 -0400
Received: from relay-s04-hub003.domainlocalhost.com ([74.115.207.102]:48818
	"EHLO relay-S04-HUB003.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbaDPIgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:36:53 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F40C14074S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "David Solda" <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] input: cyapa: add gen5 trackpad device supported in one
 driver
Thread-Topic: [PATCH 2/6] input: cyapa: add gen5 trackpad device supported
 in one driver
Thread-Index: Ac9XtrPc1irG1GfNSfqflEp0mphyywBmC+Hg
Date: Wed, 16 Apr 2014 08:36:51 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C14074@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F40C14074@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.153]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F40C14074S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add variable, macros, fucntions and interfaces to support gen5 trackpad dev=
ice,
The gen5 trackpad device is different protocol with gen3 trackpad device.
And in order to keep compatible with old products and easy customer support=
,
these two type devices must be integrated and supported in one driver.
So this cyapa driver is rearchitecture to support multi-type devices.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 4361ee1..7b269d8 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -22,12 +22,16 @@
 #include <linux/input/mt.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/completion.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/unaligned/access_ok.h>

 /* APA trackpad firmware generation */
 #define CYAPA_GEN_UNKNOWN   0x00   /* unknown protocol. */
 #define CYAPA_GEN3   0x03   /* support MT-protocol B with tracking ID. */
+#define CYAPA_GEN5   0x05   /* support TrueTouch GEN5 trackpad device. */

 #define CYAPA_NAME   "Cypress APA Trackpad (cyapa)"

@@ -178,6 +182,144 @@

 #define MAX_TMP_BUF_SIZE (CYAPA_REG_MAP_SIZE)

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
 struct cyapa;
 typedef void (*irq_handler_func)(struct cyapa *);
 typedef int (*set_power_mode_func)(struct cyapa *, u8, u16);
@@ -200,6 +342,8 @@ enum cyapa_state {
        CYAPA_STATE_OP,
        CYAPA_STATE_BL_IDLE,
        CYAPA_STATE_BL_ACTIVE,
+       CYAPA_STATE_GEN5_BL,
+       CYAPA_STATE_GEN5_APP,
        CYAPA_STATE_BL_BUSY,
        CYAPA_STATE_NO_DEVICE,
 };
@@ -242,6 +386,109 @@ struct cyapa_reg_data {
        struct cyapa_touch touches[5];
 } __packed;

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
 /* The main device structure */
 struct cyapa {
        enum cyapa_state state;
@@ -256,6 +503,8 @@ struct cyapa {
        /* power mode settings */
        u8 suspend_power_mode;
        u16 suspend_sleep_time;
+       u8 real_power_mode;
+       u16 real_sleep_time;
        bool suspended;

        /* read from query data region. */
@@ -269,10 +518,33 @@ struct cyapa {
        int physical_size_x;
        int physical_size_y;

-       u8 gen_detecting;
+       /* used in ttsp and truetouch based trackpad devices. */
+       u8 x_origin;  /* X Axis Origin: 0 =3D left side; 1 =3D rigth side. =
*/
+       u8 y_origin;  /* Y Axis Origin: 0 =3D top; 1 =3D bottom. */
+       int electrodes_x;  /* Number of electrodes on the X Axis*/
+       int electrodes_y;  /* Number of electrodes on the Y Axis*/
+       int electrodes_rx;  /* Number of Rx electrodes */
+       int max_z;

+       u8 gen_detecting;
+       u8 in_progress_cmd;
+       func_sort resp_sort_func;
+       u8 *resp_data;
+       int *resp_len;
+
+       /* trackpad is ready for next command */
+       struct completion cmd_ready;
+       atomic_t cmd_issued;
        atomic_t in_detecting;

+       /* record irq disabled/enable state. */
+       struct mutex irq_state_lock;
+       bool irq_enabled;
+       bool prev_irq_enabled;
+       struct mutex cmd_lock;
+
+       /* temple buffer to read all data out. */
+       u8 tmp_irq_buf[MAX_TMP_BUF_SIZE];
        u8 tmp_buf[MAX_TMP_BUF_SIZE];

        check_fw_func cyapa_check_fw;
@@ -288,6 +560,8 @@ struct cyapa {
        set_power_mode_func cyapa_set_power_mode;
        bl_read_fw_func cyapa_read_fw;
        read_raw_data_func cyapa_read_raw_data;
+
+       struct cyapa_tsg_bin_image_head fw_img_head;
 };

 static const u8 bl_deactivate[] =3D { 0x00, 0xff, 0x3b, 0x00, 0x01, 0x02, =
0x03,
@@ -392,6 +666,71 @@ static int cyapa_poll_state(struct cyapa *cyapa, unsig=
ned int timeout);
 static void cyapa_detect(struct cyapa *cyapa);
 static void cyapa_detect_async(void *data, async_cookie_t cookie);

+void cyapa_enable_irq(struct cyapa *cyapa)
+{
+       mutex_lock(&cyapa->irq_state_lock);
+       if (!cyapa->irq_enabled)
+               enable_irq(cyapa->irq);
+       cyapa->irq_enabled =3D true;
+       cyapa->prev_irq_enabled =3D true;
+       mutex_unlock(&cyapa->irq_state_lock);
+}
+
+void cyapa_disable_irq(struct cyapa *cyapa)
+{
+       mutex_lock(&cyapa->irq_state_lock);
+       if (cyapa->irq_enabled)
+               disable_irq(cyapa->irq);
+       cyapa->irq_enabled =3D false;
+       cyapa->prev_irq_enabled =3D false;
+       mutex_unlock(&cyapa->irq_state_lock);
+}
+
+void cyapa_enable_irq_save(struct cyapa *cyapa)
+{
+       mutex_lock(&cyapa->irq_state_lock);
+       if (!cyapa->irq_enabled) {
+               enable_irq(cyapa->irq);
+               cyapa->irq_enabled =3D true;
+       }
+       mutex_unlock(&cyapa->irq_state_lock);
+}
+
+void cyapa_disable_irq_save(struct cyapa *cyapa)
+{
+       mutex_lock(&cyapa->irq_state_lock);
+       if (cyapa->irq_enabled) {
+               disable_irq(cyapa->irq);
+               cyapa->irq_enabled =3D false;
+       }
+       mutex_unlock(&cyapa->irq_state_lock);
+}
+
+void cyapa_irq_restore(struct cyapa *cyapa)
+{
+       mutex_lock(&cyapa->irq_state_lock);
+       if (cyapa->irq_enabled !=3D cyapa->prev_irq_enabled) {
+               if (cyapa->prev_irq_enabled) {
+                       enable_irq(cyapa->irq);
+                       cyapa->irq_enabled =3D true;
+               } else {
+                       disable_irq(cyapa->irq);
+                       cyapa->irq_enabled =3D false;
+               }
+       }
+       mutex_unlock(&cyapa->irq_state_lock);
+}
+
+bool cyapa_is_irq_enabled(struct cyapa *cyapa)
+{
+       bool enabled;
+
+       mutex_lock(&cyapa->irq_state_lock);
+       enabled =3D cyapa->irq_enabled;
+       mutex_unlock(&cyapa->irq_state_lock);
+       return enabled;
+}
+
 static ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_=
t len,
                                        u8 *values)
 {
@@ -603,6 +942,33 @@ static int cyapa_gen3_bl_exit(struct cyapa *cyapa)
        return 0;
 }

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
+static u8 cyapa_sleep_time_to_pwr_cmd(u16 sleep_time)
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
 static u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode)
 {
        u8 encoded_time =3D pwr_mode >> 2;
@@ -734,6 +1100,8 @@ static int cyapa_gen3_get_query_data(struct cyapa *cya=
pa)
        cyapa->physical_size_y =3D
                ((query_data[24] & 0x0f) << 8) | query_data[26];

+       cyapa->max_z =3D 255;
+
        return 0;
 }

@@ -906,6 +1274,1209 @@ static ssize_t cyapa_i2c_write(struct cyapa *cyapa,=
 u8 reg,
        return (ret =3D=3D (len + 1)) ? 0 : ((ret < 0) ? ret : -EIO);
 }

+
+/*******************************************************************
+ * Functions defined for Gen5 trackapd device.
+ *******************************************************************/
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
+static int cyapa_do_i2c_pip_cmd_irq_sync(
+               struct cyapa *cyapa,
+               u8 *cmd, size_t cmd_len,
+               unsigned long timeout)
+{
+       int ret;
+
+       /* wait for interrupt to set ready completion */
+       init_completion(&cyapa->cmd_ready);
+
+       atomic_inc(&cyapa->cmd_issued);
+       ret =3D cyapa_i2c_pip_write(cyapa, cmd, cmd_len);
+       if (ret) {
+               atomic_dec(&cyapa->cmd_issued);
+               return (ret < 0) ? ret : -EIO;
+       }
+
+       /* wait for interrupt to indicate command is completed. */
+       timeout =3D wait_for_completion_timeout(&cyapa->cmd_ready,
+                               msecs_to_jiffies(timeout));
+       if (timeout =3D=3D 0) {
+               atomic_dec(&cyapa->cmd_issued);
+               return -ETIMEDOUT;
+       }
+
+       return 0;
+}
+
+/**
+ * this function is aimed to dump all not read data in Gen5 trackpad
+ * before send any command, otherwise, the interrupt line will be blocked.
+ */
+static int cyapa_empty_pip_output_data(struct cyapa *cyapa,
+               u8 *buf, int *len, func_sort func)
+{
+       int ret;
+       int length;
+       int report_count;
+       int empty_count;
+       int buf_len;
+
+       buf_len =3D 0;
+       if (len) {
+               buf_len =3D (*len < MAX_TMP_BUF_SIZE) ? *len : MAX_TMP_BUF_=
SIZE;
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
+               ret =3D cyapa_i2c_pip_read(cyapa, cyapa->tmp_buf,
+                               GEN5_RESP_LENGTH_SIZE);
+               if (ret < 0)
+                       return ret;
+
+               length =3D get_unaligned_le16(cyapa->tmp_buf);
+               if (length =3D=3D GEN5_RESP_LENGTH_SIZE) {
+                       empty_count++;
+                       continue;
+               } else if (length > MAX_TMP_BUF_SIZE) {
+                       /* should not happen */
+                       return -EINVAL;
+               } else if (length =3D=3D 0) {
+                       /* application or bootloader launch data polled out=
. */
+                       length =3D GEN5_RESP_LENGTH_SIZE;
+                       if (buf && buf_len && func &&
+                               func(cyapa, cyapa->tmp_buf, length)) {
+                               length =3D min(buf_len, length);
+                               memcpy(buf, cyapa->tmp_buf, length);
+                               *len =3D length;
+                               /* response found, success. */
+                               return 0;
+                       } else {
+                               continue;
+                       }
+               }
+
+               ret =3D cyapa_i2c_pip_read(cyapa, cyapa->tmp_buf, length);
+               if (ret < 0)
+                       return ret;
+
+               report_count--;
+               empty_count =3D 0;
+               length =3D get_unaligned_le16(cyapa->tmp_buf);
+               if (length <=3D GEN5_RESP_LENGTH_SIZE) {
+                       empty_count++;
+               } else if (buf && buf_len && func &&
+                       func(cyapa, cyapa->tmp_buf, length)) {
+                       length =3D min(buf_len, length);
+                       memcpy(buf, cyapa->tmp_buf, length);
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
+static int cyapa_i2c_pip_cmd_irq_sync(
+               struct cyapa *cyapa,
+               u8 *cmd, int cmd_len,
+               u8 *resp_data, int *resp_len,
+               unsigned long timeout,
+               func_sort func)
+{
+       int ret;
+       int tries;
+       int length;
+
+       if (!cmd || !cmd_len)
+               return -EINVAL;
+
+       mutex_lock(&cyapa->cmd_lock);
+
+       cyapa->resp_sort_func =3D func;
+       cyapa->resp_data =3D resp_data;
+       cyapa->resp_len =3D resp_len;
+
+       if (cmd_len >=3D GEN5_MIN_APP_CMD_LENGTH &&
+                       cmd[4] =3D=3D GEN5_APP_CMD_REPORT_ID) {
+               /* application command */
+               cyapa->in_progress_cmd =3D cmd[6] & 0x7f;
+       } else if (cmd_len >=3D GEN5_MIN_BL_CMD_LENGTH &&
+                       cmd[4] =3D=3D GEN5_BL_CMD_REPORT_ID) {
+               /* bootloader command */
+               cyapa->in_progress_cmd =3D cmd[7];
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
+       cyapa->resp_sort_func =3D NULL;
+       cyapa->resp_data =3D NULL;
+       cyapa->resp_len =3D NULL;
+       cyapa->in_progress_cmd =3D TSG_INVALID_CMD;
+
+       mutex_unlock(&cyapa->cmd_lock);
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
+                       data[5] =3D=3D cyapa->in_progress_cmd) {
+                       /* unsupported command code */
+                       return false;
+               } else if (GET_GEN5_CMD_CODE(data[GEN5_RESP_APP_CMD_OFFSET]=
) =3D=3D
+                               cyapa->in_progress_cmd) {
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
+       /* Parse based on Gen5 characteristic regiters and bits */
+       length =3D get_unaligned_le16(&reg_data[0]);
+       if (length =3D=3D 0 || length =3D=3D GEN5_RESP_LENGTH_SIZE) {
+               /* dump all buffered data firstly, specific for the situati=
on
+                * that when trackpad is just power on the cyapa go here. *=
/
+               cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+               memset(resp_data, 0, sizeof(resp_data));
+               ret =3D cyapa_i2c_pip_read(cyapa, resp_data, 3);
+               if (ret !=3D 3)
+                       return -EAGAIN;
+
+               length =3D get_unaligned_le16(&resp_data[0]);
+               if (length =3D=3D GEN5_RESP_LENGTH_SIZE) {
+                       /* normal state of Gen5 with no data to respose */
+                       cyapa->gen =3D CYAPA_GEN5;
+
+                       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL=
);
+
+                       /* read HID Description from trackpad device */
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
+                               return -EAGAIN;
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
+                               return 0;
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
+                               return 0;
+                       } else {
+                               /* should not happen!!! */
+                               cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+                               return -EAGAIN;
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
+                       return -EAGAIN;
+               length =3D get_unaligned_le16(&resp_data[0]);
+               max_output_len =3D get_unaligned_le16(&resp_data[16]);
+               if (length =3D=3D GEN5_RESP_LENGTH_SIZE) {
+                       if (reg_data[2] =3D=3D GEN5_BL_HID_REPORT_ID) {
+                               /* BL mode HID Description has been previou=
sly
+                                * read out */
+                               cyapa->gen =3D CYAPA_GEN5;
+                               cyapa->state =3D CYAPA_STATE_GEN5_BL;
+                               return 0;
+                       } else {
+                               /* APP mode HID Description has been previo=
usly
+                                * read out */
+                               cyapa->gen =3D CYAPA_GEN5;
+                               cyapa->state =3D CYAPA_STATE_GEN5_APP;
+                               return 0;
+                       }
+               } else if (length =3D=3D GEN5_HID_DESCRIPTOR_SIZE &&
+                               resp_data[2] =3D=3D GEN5_BL_HID_REPORT_ID &=
&
+                               max_output_len =3D=3D GEN5_BL_MAX_OUTPUT_LE=
NGTH) {
+                       /* BL mode HID Description read */
+                       cyapa->gen =3D CYAPA_GEN5;
+                       cyapa->state =3D CYAPA_STATE_GEN5_BL;
+                       return 0;
+               } else if (length =3D=3D GEN5_HID_DESCRIPTOR_SIZE &&
+                               resp_data[2] =3D=3D GEN5_APP_HID_REPORT_ID =
&&
+                               max_output_len =3D=3D GEN5_APP_MAX_OUTPUT_L=
ENGTH) {
+                       /* APP mode HID Description read */
+                       cyapa->gen =3D CYAPA_GEN5;
+                       cyapa->state =3D CYAPA_STATE_GEN5_APP;
+                       return 0;
+               } else {
+                       /* should not happen!!! */
+                       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+                       return -EAGAIN;
+               }
+       } else if ((length =3D=3D GEN5_APP_REPORT_DESCRIPTOR_SIZE ||
+                       length =3D=3D GEN5_APP_CONTRACT_REPORT_DESCRIPTOR_S=
IZE) &&
+                       reg_data[2] =3D=3D GEN5_APP_REPORT_DESCRIPTOR_ID) {
+               /* 0xEE 0x00 0xF6 is Gen5 APP Report Description header. */
+               cyapa->gen =3D CYAPA_GEN5;
+               cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+
+               /*
+                * must read Report Description content through out,
+                * otherwise Gen5 trackpad cannot reponse next command
+                * or report any touch or button data.
+                */
+
+               cyapa->state =3D CYAPA_STATE_GEN5_APP;
+               return 0;
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
+               ret =3D cyapa_i2c_pip_read(cyapa, cyapa->tmp_buf,
+                               GEN5_BL_REPORT_DESCRIPTOR_SIZE);
+               if (ret !=3D GEN5_BL_REPORT_DESCRIPTOR_SIZE)
+                       return -EAGAIN;
+
+               cyapa->state =3D CYAPA_STATE_GEN5_BL;
+               return 0;
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
+                               ret =3D -EINVAL;
+                       break;
+               case GEN5_BTN_REPORT_ID:
+               case GEN5_OLD_PUSH_BTN_REPORT_ID:
+               case GEN5_PUSH_BTN_REPORT_ID:
+                       if (length < GEN5_BTN_REPORT_HEAD_SIZE ||
+                               length > GEN5_BTN_REPORT_MAX_SIZE)
+                               ret =3D -EINVAL;
+                       break;
+               case GEN5_WAKEUP_EVENT_REPORT_ID:
+                       if (length !=3D GEN5_WAKEUP_EVENT_SIZE)
+                               ret =3D -EINVAL;
+                       break;
+               }
+
+               if (ret < 0)
+                       return -EAGAIN;
+
+               cyapa->gen =3D CYAPA_GEN5;
+               cyapa->state =3D CYAPA_STATE_GEN5_APP;
+               return 0;
+       } else if (reg_data[2] =3D=3D GEN5_BL_RESP_REPORT_ID ||
+                       reg_data[2] =3D=3D GEN5_APP_RESP_REPORT_ID) {
+               /*
+                * must read report data through out,
+                * otherwise Gen5 trackpad cannot reponse next command
+                * or report any touch or button data.
+                */
+               length =3D get_unaligned_le16(reg_data);
+               ret =3D cyapa_i2c_pip_read(cyapa, cyapa->tmp_buf, length);
+               if (ret !=3D length)
+                       return -EAGAIN;
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
+               } else if (cyapa->tmp_buf[2] =3D=3D GEN5_BL_RESP_REPORT_ID =
&&
+                               cyapa->tmp_buf[3] =3D=3D GEN5_RESP_RSVD_KEY=
 &&
+                               cyapa->tmp_buf[4] =3D=3D GEN5_SOP_KEY &&
+                               cyapa->tmp_buf[length - 1] =3D=3D GEN5_EOP_=
KEY) {
+                       /* Gen5 BL command response data detected */
+                       cyapa->gen =3D CYAPA_GEN5;
+                       cyapa->state =3D CYAPA_STATE_GEN5_BL;
+               } else if (cyapa->tmp_buf[2] =3D=3D GEN5_APP_RESP_REPORT_ID=
 &&
+                               cyapa->tmp_buf[3] =3D=3D GEN5_RESP_RSVD_KEY=
) {
+                       /* Gen5 APP command response data detected */
+                       cyapa->gen =3D CYAPA_GEN5;
+                       cyapa->state =3D CYAPA_STATE_GEN5_APP;
+               } else {
+                       /* should not happen!!! */
+                       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+               }
+
+               if (cyapa->state =3D=3D CYAPA_STATE_NO_DEVICE)
+                       return -EAGAIN;
+               return 0;
+       }
+
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
+       switch (power_mode) {
+       case PWR_MODE_OFF:
+       case PWR_MODE_FULL_ACTIVE:
+       case PWR_MODE_BTN_ONLY:
+               if (power_mode =3D=3D cyapa->real_power_mode)
+                       return 0;
+
+               if (power_mode =3D=3D PWR_MODE_OFF) {
+                       ret =3D cyapa_gen5_deep_sleep(cyapa,
+                                       GEN5_DEEP_SLEEP_STATE_OFF);
+                       if (ret) {
+                               dev_err(dev, "enter deep sleep fail, (%d)\n=
",
+                                       ret);
+                               return ret;
+                       }
+
+                       cyapa->real_power_mode =3D PWR_MODE_OFF;
+                       return 0;
+               }
+               break;
+       default:
+               if (sleep_time =3D=3D cyapa->real_sleep_time &&
+                       power_mode =3D=3D cyapa->real_power_mode)
+                       return 0;
+       }
+
+       if (cyapa->real_power_mode =3D=3D PWR_MODE_OFF) {
+               ret =3D cyapa_gen5_deep_sleep(cyapa, GEN5_DEEP_SLEEP_STATE_=
ON);
+               if (ret) {
+                       dev_err(dev, "deep sleep wake fail, (%d)\n", ret);
+                       return ret;
+               }
+               /* set current power state in driver. */
+               cyapa->real_power_mode =3D cyapa->suspend_power_mode;
+               cyapa->real_sleep_time =3D cyapa->suspend_sleep_time;
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
+               cyapa->real_power_mode =3D PWR_MODE_FULL_ACTIVE;
+       } else if (power_mode =3D=3D PWR_MODE_BTN_ONLY) {
+               ret =3D cyapa_gen5_change_power_state(cyapa,
+                               GEN5_POWER_STATE_BTN_ONLY);
+               if (ret) {
+                       dev_err(dev, "fail change to active, (%d)\n", ret);
+                       return ret;
+               }
+
+               cyapa->real_power_mode =3D PWR_MODE_BTN_ONLY;
+       } else {
+               /* continue to change power mode even failed to set
+                * interval time, it won't affect the power mode change. */
+               cyapa_gen5_set_interval_time(cyapa,
+                       GEN5_PARAMETER_LP_INTRVL_ID, sleep_time);
+
+               if (sleep_time <=3D GEN5_POWER_READY_MAX_INTRVL_TIME)
+                       power_state =3D GEN5_POWER_STATE_READY;
+               else
+                       power_state =3D GEN5_POWER_STATE_IDLE;
+               ret =3D cyapa_gen5_change_power_state(cyapa, power_state);
+               if (ret) {
+                       dev_err(dev, "set power state %d fail, (%d)\n",
+                               power_state, ret);
+                       cyapa_gen5_set_interval_time(cyapa,
+                                       GEN5_PARAMETER_LP_INTRVL_ID,
+                                       cyapa->real_sleep_time);
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
+               cyapa->real_power_mode =3D
+                               cyapa_sleep_time_to_pwr_cmd(sleep_time);
+               cyapa->real_sleep_time =3D sleep_time;
+       }
+
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
+       cyapa->fw_img_head.head_size =3D
+               sizeof(struct cyapa_tsg_bin_image_head) - 1;
+       memcpy(&cyapa->fw_img_head.ttda_driver_major_version,
+               &resp_data[5], cyapa->fw_img_head.head_size);
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
+       switch (cyapa->state) {
+       case CYAPA_STATE_GEN5_BL:
+               ret =3D cyapa_gen5_bl_exit(cyapa);
+               if (ret) {
+                       /* try to update trackpad product information. */
+                       cyapa_gen5_bl_query_data(cyapa);
+                       return ret;
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
+               if (cyapa->real_power_mode =3D=3D PWR_MODE_OFF) {
+                       ret =3D cyapa_gen5_set_power_mode(cyapa,
+                                       PWR_MODE_FULL_ACTIVE, 0);
+                       if (ret)
+                               return ret;
+
+                       /* set initial power state of trackpad device. */
+                       cyapa->real_power_mode =3D PWR_MODE_FULL_ACTIVE;
+                       cyapa_gen5_get_interval_time(cyapa,
+                               GEN5_PARAMETER_LP_INTRVL_ID,
+                               &cyapa->real_sleep_time);
+                       cyapa->suspend_power_mode =3D
+                               cyapa_sleep_time_to_pwr_cmd(
+                                       cyapa->real_sleep_time);
+                       cyapa->suspend_sleep_time =3D cyapa->real_sleep_tim=
e;
+               }
+
+               /* Get trackpad product information. */
+               ret =3D cyapa_gen5_get_query_data(cyapa);
+               if (ret)
+                       return ret;
+               /* only support product ID starting with CYTRA */
+               if (memcmp(cyapa->product_id, unique_str,
+                          sizeof(unique_str) - 1) !=3D 0) {
+                       dev_err(dev, "%s: unknown product ID (%s)\n",
+                               __func__, cyapa->product_id);
+                       return -EINVAL;
+               }
+               break;
+       default:
+               return -EINVAL;
+       }
+
+       return 0;
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
 static void cyapa_default_irq_handler(struct cyapa *cyapa)
 {
        async_schedule(cyapa_detect_async, cyapa);
@@ -934,6 +2505,26 @@ static int cyapa_check_is_operational(struct cyapa *c=
yapa)
                return ret;

        switch (cyapa->gen) {
+       case CYAPA_GEN5:
+               cyapa->cyapa_check_fw =3D NULL;
+               cyapa->cyapa_bl_enter =3D NULL;
+               cyapa->cyapa_bl_activate =3D NULL;
+               cyapa->cyapa_bl_initiate =3D NULL;
+               cyapa->cyapa_update_fw =3D NULL;
+               cyapa->cyapa_bl_verify_app_integrity =3D NULL;
+               cyapa->cyapa_bl_deactivate =3D NULL;
+               cyapa->cyapa_show_baseline =3D NULL;
+               cyapa->cyapa_calibrate_store =3D NULL;
+               cyapa->cyapa_irq_handler =3D cyapa_gen5_irq_handler;
+               cyapa->cyapa_set_power_mode =3D cyapa_gen5_set_power_mode;
+               cyapa->cyapa_read_fw =3D NULL;
+               cyapa->cyapa_read_raw_data =3D NULL;
+
+               cyapa_enable_irq_save(cyapa);
+               ret =3D cyapa_gen5_do_operational_check(cyapa);
+               cyapa_irq_restore(cyapa);
+
+               break;
        case CYAPA_GEN3:
                cyapa->cyapa_check_fw =3D NULL;
                cyapa->cyapa_bl_enter =3D NULL;
@@ -983,14 +2574,75 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
        if (device_may_wakeup(dev))
                pm_wakeup_event(dev, 0);

+       if (atomic_read(&cyapa->cmd_issued)) {
+               if (cyapa->gen_detecting =3D=3D CYAPA_GEN5) {
+                       /*
+                        * read out all none command response data.
+                        * these output data may caused by user put finger =
on
+                        * trackpad when host waiting the command response.
+                        */
+                       cyapa_i2c_pip_read(cyapa, cyapa->tmp_irq_buf, 2);
+                       length =3D get_unaligned_le16(cyapa->tmp_irq_buf);
+                       length =3D (length <=3D 2) ? 2 : length;
+                       if (length > 2)
+                               cyapa_i2c_pip_read(cyapa,
+                                       cyapa->tmp_irq_buf, length);
+                       if (!(cyapa->resp_sort_func &&
+                               cyapa->resp_sort_func(cyapa,
+                                       cyapa->tmp_irq_buf, length))) {
+                               /*
+                                * Cover the Gen5 V1 firmware issue.
+                                * The issue is there is no interrut will b=
e
+                                * asserted to notityf host to read a comma=
nd
+                                * data out when always has finger touch on
+                                * trackpad during the command is issued to
+                                * trackad device.
+                                * This issue has the scenario is that,
+                                * user always has his fingers touched on
+                                * trackpad device when booting/rebooting
+                                * their chrome book.
+                                */
+                               length =3D *cyapa->resp_len;
+                               cyapa_empty_pip_output_data(cyapa,
+                                               cyapa->resp_data,
+                                               &length,
+                                               cyapa->resp_sort_func);
+                               if (cyapa->resp_len && length !=3D 0) {
+                                       *cyapa->resp_len =3D length;
+                                       complete(&cyapa->cmd_ready);
+                                       atomic_dec(&cyapa->cmd_issued);
+                               }
+                               goto out;
+                       }
+
+                       if (cyapa->resp_data && cyapa->resp_len) {
+                               *cyapa->resp_len =3D (*cyapa->resp_len < le=
ngth) ?
+                                       *cyapa->resp_len : length;
+                               memcpy(cyapa->resp_data, cyapa->tmp_irq_buf=
,
+                                       *cyapa->resp_len);
+                       }
+               }
+               complete(&cyapa->cmd_ready);
+               atomic_dec(&cyapa->cmd_issued);
+               goto out;
+       }
+
        /*
         * Don't read input if input device has not been configured.
         * This check solves a race during probe() between irq_request()
         * and irq_disable(), since there is no way to request an irq that =
is
         * initially disabled.
         */
-       if (!input || atomic_read(&cyapa->in_detecting))
+       if (!input || atomic_read(&cyapa->in_detecting)) {
+               if (cyapa->gen_detecting =3D=3D CYAPA_GEN5) {
+                       cyapa_i2c_pip_read(cyapa, cyapa->tmp_irq_buf, 2);
+                       length =3D get_unaligned_le16(cyapa->tmp_irq_buf);
+                       if (length > 2)
+                               cyapa_i2c_pip_read(cyapa,
+                                       cyapa->tmp_irq_buf, length);
+               }
                goto out;
+       }

        if (cyapa->cyapa_irq_handler)
                cyapa->cyapa_irq_handler(cyapa);
@@ -1051,6 +2703,22 @@ static int cyapa_get_state(struct cyapa *cyapa)
                                goto out_detected;
                        cyapa->gen_detecting =3D CYAPA_GEN_UNKNOWN;
                }
+               if ((cyapa->gen =3D=3D CYAPA_GEN_UNKNOWN ||
+                               cyapa->gen =3D=3D CYAPA_GEN5) &&
+                       !smbus && even_addr) {
+                       cyapa->gen_detecting =3D CYAPA_GEN5;
+
+                       cyapa_enable_irq_save(cyapa);
+                       ret =3D cyapa_gen5_state_parse(cyapa,
+                                       status, BL_STATUS_SIZE);
+                       cyapa_irq_restore(cyapa);
+                       if (ret =3D=3D 0) {
+                               cyapa_empty_pip_output_data(cyapa,
+                                               NULL, NULL, NULL);
+                               goto out_detected;
+                       }
+                       cyapa->gen_detecting =3D CYAPA_GEN_UNKNOWN;
+               }

                /*
                 * cannot detect communication protocol based on current
@@ -1157,7 +2825,27 @@ static int cyapa_create_input_dev(struct cyapa *cyap=
a)
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
@@ -1202,6 +2890,14 @@ static void cyapa_detect(struct cyapa *cyapa)
        char *envp[] =3D {"ERROR=3D1", NULL};
        int ret;

+       /*
+        * Try to dump all bufferred data if it's known gen5 trackpad
+        * before detecting. Because the irq routine may disabled
+        * before enter this routine.
+        */
+       if (cyapa->gen =3D=3D CYAPA_GEN5)
+               cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
        ret =3D cyapa_check_is_operational(cyapa);
        if (ret =3D=3D -ETIMEDOUT)
                dev_err(dev, "no device detected, %d\n", ret);
@@ -1219,7 +2915,8 @@ static void cyapa_detect(struct cyapa *cyapa)
                        dev_err(dev, "create input_dev instance failed, %d\=
n",
                                ret);

-               enable_irq(cyapa->irq);
+               cyapa_enable_irq(cyapa);
+
                /*
                 * On some systems, a system crash / warm boot does not res=
et
                 * the device's current power mode to FULL_ACTIVE.
@@ -1238,6 +2935,14 @@ static void cyapa_detect(struct cyapa *cyapa)
                                                ret);
                }
        }
+
+       /*
+        * Try to dump all bufferred data if it's known gen5 trackpad befor=
e
+        * detecting. Because the irq routine may disabled before
+        * leave this routine.
+        */
+       if (cyapa->gen =3D=3D CYAPA_GEN5)
+               cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
 }

 static void cyapa_detect_async(void *data, async_cookie_t cookie)
@@ -1290,7 +2995,16 @@ static int cyapa_probe(struct i2c_client *client,
        cyapa->state =3D CYAPA_STATE_NO_DEVICE;
        cyapa->suspend_power_mode =3D PWR_MODE_SLEEP;

+       init_completion(&cyapa->cmd_ready);
+       atomic_set(&cyapa->cmd_issued, 0);
+       mutex_init(&cyapa->irq_state_lock);
+       mutex_init(&cyapa->cmd_lock);
+       atomic_set(&cyapa->in_detecting, 0);
+       cyapa->resp_sort_func =3D NULL;
+       cyapa->in_progress_cmd =3D TSG_INVALID_CMD;
+
        cyapa->irq =3D client->irq;
+       cyapa->irq_enabled =3D true;
        ret =3D request_threaded_irq(cyapa->irq,
                                   NULL,
                                   cyapa_irq,
@@ -1301,7 +3015,7 @@ static int cyapa_probe(struct i2c_client *client,
                dev_err(dev, "IRQ request failed: %d\n, ", ret);
                goto err_unregister_device;
        }
-       disable_irq(cyapa->irq);
+       cyapa_disable_irq(cyapa);

        async_schedule(cyapa_detect_async, cyapa);
        return 0;
@@ -1336,7 +3050,7 @@ static int cyapa_suspend(struct device *dev)
        u8 power_mode;
        struct cyapa *cyapa =3D dev_get_drvdata(dev);

-       disable_irq(cyapa->irq);
+       cyapa_disable_irq(cyapa);
        cyapa->suspended =3D true;

        /*
@@ -1365,7 +3079,7 @@ static int cyapa_resume(struct device *dev)

        if (device_may_wakeup(dev) && cyapa->irq_wake)
                disable_irq_wake(cyapa->irq);
-       enable_irq(cyapa->irq);
+       cyapa_enable_irq(cyapa);

        if (cyapa->cyapa_set_power_mode) {
                ret =3D cyapa->cyapa_set_power_mode(cyapa, PWR_MODE_FULL_AC=
TIVE,
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F40C14074S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
oeKQrGCYcPnJsEN5CMD1MYmwxFC+AW+r8N6gWECwoGlrENRQc/s4oE2hZrCgCgFPgLzQytCvdhFj
EOLywbBJvfIgawDfq/AI8MmhxGCNsGnF0NMgf03xvTHEUA7Q4sGnwEwBZD81EMIlV/Au8WsgTCJp
bfemUE9xwUBseLFWELFBxfQzS6XGxn19ywBYQAAAAB8AQgABAAAAFAAAAEQAdQBkAGwAZQB5ACAA
RAB1AAAAHwBlAAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwBk
AAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACA
RAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBj
AG8AbQAAAB8AAl0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8A
5V8BAAAAKgAAAHMAaQBwADoAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAa
DAEAAAAUAAAARAB1AGQAbABlAHkAIABEAHUAAAAfAB8MAQAAACIAAABkAHUAZABsAEAAYwB5AHAA
cgBlAHMAcwAuAGMAbwBtAAAAAAAfAB4MAQAAAAoAAABTAE0AVABQAAAAAAACARkMAQAAAFgAAAAA
AAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBEAHUAZABsAGUAeQAgAEQAdQAAAFMATQBUAFAAAABkAHUA
ZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAHwABXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBw
AHIAZQBzAHMALgBjAG8AbQAAAAAAHwD4PwEAAAAUAAAARAB1AGQAbABlAHkAIABEAHUAAAAfACNA
AQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfACJAAQAAAAoAAABT
AE0AVABQAAAAAAACAfk/AQAAAFgAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBEAHUAZABsAGUA
eQAgAEQAdQAAAFMATQBUAFAAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAHwAJ
XQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAxQAEAAAACAAAA
AAAAAAsAQDoBAAAAHwAwQAEAAAACAAAAAAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAA
AAAAAwDxPwQIAAALAEA6AQAAAAMA/T+oAwAAAgELMAEAAAAQAAAALFc2pb3LQ0CAhYNTX6ofYwMA
FwABAAAAQAA5AICTUQNPWc8BQAAIMPl1kQNPWc8BCwApAAAAAAALACMAAAAAAB8AAICGAwIAAAAA
AMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAaAAAA
egBoAC0AQwBOACwAIABlAG4ALQBVAFMAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAA
AAAAHwA3AAEAAACWAAAAWwBQAEEAVABDAEgAIAAyAC8ANgBdACAAaQBuAHAAdQB0ADoAIABjAHkA
YQBwAGEAOgAgAGEAZABkACAAZwBlAG4ANQAgAHQAcgBhAGMAawBwAGEAZAAgAGQAZQB2AGkAYwBl
ACAAcwB1AHAAcABvAHIAdABlAGQAIABpAG4AIABvAG4AZQAgAGQAcgBpAHYAZQByAAAAAAAfAD0A
AQAAAAIAAAAAAAAAAwA2AAAAAAADAC4AAAAAAB8AQhABAAAAAgAAAAAAAAACAXEAAQAAABsAAAAB
z1e2s9zWKsbUZ81J+p+USnSamHLLAGYL4eAAHwBwAAEAAACWAAAAWwBQAEEAVABDAEgAIAAyAC8A
NgBdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAgAGEAZABkACAAZwBlAG4ANQAgAHQAcgBh
AGMAawBwAGEAZAAgAGQAZQB2AGkAYwBlACAAcwB1AHAAcABvAHIAdABlAGQAIABpAG4AIABvAG4A
ZQAgAGQAcgBpAHYAZQByAAAAAAAfADUQAQAAAIQAAAA8ADcANwBCAEMANwAyADUAQwA5ADAANgAy
ADcANgA0AEYAOAA3ADQARAA3ADkARgA1ADEARQAxAEYAMQBBADgARgA0ADAAQwAxADQAMAA3ADQA
QABTADAANAAtAE0AQgBYADAAMQAtADAAMQAuAHMAMAA0AC4AbABvAGMAYQBsAD4AAAAfADkQAQAA
AAIAAAAAAAAAAwDeP59OAAALAACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYA
AAAAAMAAAAAAAABGAAAAAAGFAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEAAAAAAAAD
AIAQ/////wUAAIADIAYAAAAAAMAAAAAAAABGAAAAAAKBAAAAAAAAAAAAAAsAAIADIAYAAAAAAMAA
AAAAAABGAAAAAByBAAAAAAAAQAAHMGHSaQJPWc8BCwACAAEAAAADACYAAAAAAAsAKwAAAAAAAgEQ
MAEAAABGAAAAAAAAALEfoTkwIFFGnbSlcN7Qn9QHAHe8clyQYnZPh0159R4fGo8AAACZPBsAALqn
Pu7L1/dAo3bvNfxhWYkAGIP8wy0AAAAAHwD6PwEAAAAUAAAARAB1AGQAbABlAHkAIABEAHUAAAAD
AAlZAQAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABCFAAAAAAAAHwAAgB+k6zOoei5Cvnt54amO
VLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBu
AGcARQB4AAAAAQAAAN4AAABJAEkAPQAwADEAQwBGADUANwBCADYAQgAzAEQAQwBEADYAMgBBAEMA
NgBEADQANgA3AEMARAA0ADkARgBBADkARgA5ADQANABBADcANAA5AEEAOQA4ADcAMgBDAEIAMAAw
ADYANgAwAEIARQAxAEUAMAA7AFMAQgBDAEkARAA9ADQAOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIA
cwBpAG8AbgAgADEANAAuADMAIAAoAEIAdQBpAGwAZAAgADEANwA0AC4AMAApACwAIABTAHQAYQBn
AGUAPQBIADQAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABOBAAABAAAAAwAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAI4EAAP///38DAACAAyAGAAAAAADAAAAAAAAARgAAAAAQgQAAAAAAAAMAAIAD
IAYAAAAAAMAAAAAAAABGAAAAABGBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJIEAAAAA
AAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAsgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAA
ACmBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKoEAAAAAAAAfAACAAyAGAAAAAADAAAAA
AAAARgAAAAAngQAAAQAAAAIAAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEoEAAAEAAAAf
AACAAyAGAAAAAADAAAAAAAAARgAAAAAhgQAAAQAAAAIAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAA4EAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAmgQAAAAAAAAsAAIAIIAYAAAAA
AMAAAAAAAABGAAAAAA6FAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACA
CCAGAAAAAADAAAAAAAAARgAAAACChQAAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYB
AAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAA
AAEAAAAeAAAAWwAxADAALgAzADAALgAxADIALgAxADUAMwBdAAAAAAD8gA==

--_000_77BC725C9062764F874D79F51E1F1A8F40C14074S04MBX0101s04lo_--
