Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaDNH7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:59:43 -0400
Received: from relay-s04-hub005.domainlocalhost.com ([74.115.207.216]:48917
	"EHLO relay-S04-HUB005.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbaDNH7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:59:37 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F40C11432S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] input: cyapa: rearchitecture driver to support function
 pointers
Thread-Topic: [PATCH 1/6] input: cyapa: rearchitecture driver to support
 function pointers
Thread-Index: Ac9Xtq9L7NojvOgjROesZ4GoflAFFA==
Date: Mon, 14 Apr 2014 07:53:57 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C11432@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F40C11432@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.148]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F40C11432S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Re-architecture the driver to support function pointers, so it can
support and integrate new devices later in one driver. Including use
async thread in device proble to speed up system boot time.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index b409c3d..4361ee1 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -14,15 +14,19 @@
  * more details.
  */

+#include <linux/async.h>
 #include <linux/delay.h>
+#include <linux/firmware.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
 #include <linux/input/mt.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/completion.h>
 #include <linux/slab.h>

 /* APA trackpad firmware generation */
+#define CYAPA_GEN_UNKNOWN   0x00   /* unknown protocol. */
 #define CYAPA_GEN3   0x03   /* support MT-protocol B with tracking ID. */

 #define CYAPA_NAME   "Cypress APA Trackpad (cyapa)"
@@ -85,14 +89,19 @@
  * bit 7: Busy
  * bit 6 - 5: Reserved
  * bit 4: Bootloader running
- * bit 3 - 1: Reserved
+ * bit 3 - 2: Reserved
+ * bit 1: Watchdog Reset
  * bit 0: Checksum valid
  */
 #define REG_BL_STATUS        0x01
+#define BL_STATUS_REV_6_5    0x60
 #define BL_STATUS_BUSY       0x80
 #define BL_STATUS_RUNNING    0x10
-#define BL_STATUS_DATA_VALID 0x08
+#define BL_STATUS_REV_3_2    0x0c
+#define BL_STATUS_WATCHDOG   0x02
 #define BL_STATUS_CSUM_VALID 0x01
+#define BL_STATUS_REV_MASK (BL_STATUS_WATCHDOG | BL_STATUS_REV_3_2 | \
+                           BL_STATUS_REV_6_5)

 /*
  * Bootloader Error Register
@@ -112,10 +121,14 @@
 #define BL_ERROR_CMD_CSUM    0x10
 #define BL_ERROR_FLASH_PROT  0x08
 #define BL_ERROR_FLASH_CSUM  0x04
+#define BL_ERROR_RESERVED    0x03

 #define BL_STATUS_SIZE  3  /* length of bootloader status registers */
 #define BLK_HEAD_BYTES 32

+/* Macro for register map group offset. */
+#define CYAPA_REG_MAP_SIZE  256
+
 #define PRODUCT_ID_SIZE  16
 #define QUERY_DATA_SIZE  27
 #define REG_PROTOCOL_GEN_QUERY_OFFSET  20
@@ -134,17 +147,27 @@
 #define CYAPA_OFFSET_SOFT_RESET  REG_OFFSET_COMMAND_BASE

 #define REG_OFFSET_POWER_MODE (REG_OFFSET_COMMAND_BASE + 1)
+#define SET_POWER_MODE_DELAY   10000  /* unit: us */
+#define SET_POWER_MODE_TRIES   5

 #define PWR_MODE_MASK   0xfc
 #define PWR_MODE_FULL_ACTIVE (0x3f << 2)
-#define PWR_MODE_IDLE        (0x05 << 2) /* default sleep time is 50 ms. *=
/
+#define PWR_MODE_IDLE        (0x03 << 2) /* default rt suspend scanrate: 3=
0ms */
+#define PWR_MODE_SLEEP       (0x05 << 2) /* default suspend scanrate: 50ms=
 */
+#define PWR_MODE_BTN_ONLY    (0x01 << 2)
 #define PWR_MODE_OFF         (0x00 << 2)

+#define BTN_ONLY_MODE_NAME   "buttononly"
+#define OFF_MODE_NAME        "off"
+
 #define PWR_STATUS_MASK      0x0c
 #define PWR_STATUS_ACTIVE    (0x03 << 2)
 #define PWR_STATUS_IDLE      (0x02 << 2)
+#define PWR_STATUS_BTN_ONLY  (0x01 << 2)
 #define PWR_STATUS_OFF       (0x00 << 2)

+#define AUTOSUSPEND_DELAY   2000 /* unit : ms */
+
 /*
  * CYAPA trackpad device states.
  * Used in register 0x00, bit1-0, DeviceStatus field.
@@ -153,6 +176,26 @@
 #define CYAPA_DEV_NORMAL  0x03
 #define CYAPA_DEV_BUSY    0x01

+#define MAX_TMP_BUF_SIZE (CYAPA_REG_MAP_SIZE)
+
+struct cyapa;
+typedef void (*irq_handler_func)(struct cyapa *);
+typedef int (*set_power_mode_func)(struct cyapa *, u8, u16);
+typedef int (*bl_enter_func)(struct cyapa *);
+typedef int (*bl_activate_func)(struct cyapa *);
+typedef int (*bl_verify_app_integrity_func)(struct cyapa *);
+typedef int (*bl_deactivate_func)(struct cyapa *);
+typedef int (*bl_read_fw_func)(struct cyapa *);
+typedef int (*check_fw_func)(struct cyapa *, const struct firmware *);
+typedef int (*bl_initiate_func)(struct cyapa *, const struct firmware *);
+typedef int (*update_fw_func)(struct cyapa *, const struct firmware *);
+typedef ssize_t (*show_baseline_func)(
+       struct device *, struct device_attribute *, char *);
+typedef ssize_t (*calibrate_store_func)(
+       struct device *, struct device_attribute *, const char *, size_t);
+typedef bool (*func_sort)(struct cyapa *, u8 *, int);
+typedef int (*read_raw_data_func)(struct cyapa *);
+
 enum cyapa_state {
        CYAPA_STATE_OP,
        CYAPA_STATE_BL_IDLE,
@@ -210,14 +253,41 @@ struct cyapa {
        bool irq_wake;  /* irq wake is enabled */
        bool smbus;

+       /* power mode settings */
+       u8 suspend_power_mode;
+       u16 suspend_sleep_time;
+       bool suspended;
+
        /* read from query data region. */
        char product_id[16];
+       u8 fw_maj_ver;  /* firmware major version. */
+       u8 fw_min_ver;  /* firmware minor version. */
        u8 btn_capability;
        u8 gen;
        int max_abs_x;
        int max_abs_y;
        int physical_size_x;
        int physical_size_y;
+
+       u8 gen_detecting;
+
+       atomic_t in_detecting;
+
+       u8 tmp_buf[MAX_TMP_BUF_SIZE];
+
+       check_fw_func cyapa_check_fw;
+       bl_enter_func cyapa_bl_enter;
+       bl_activate_func cyapa_bl_activate;
+       bl_initiate_func cyapa_bl_initiate;
+       update_fw_func cyapa_update_fw;
+       bl_verify_app_integrity_func cyapa_bl_verify_app_integrity;
+       bl_deactivate_func cyapa_bl_deactivate;
+       show_baseline_func cyapa_show_baseline;
+       calibrate_store_func cyapa_calibrate_store;
+       irq_handler_func cyapa_irq_handler;
+       set_power_mode_func cyapa_set_power_mode;
+       bl_read_fw_func cyapa_read_fw;
+       read_raw_data_func cyapa_read_raw_data;
 };

 static const u8 bl_deactivate[] =3D { 0x00, 0xff, 0x3b, 0x00, 0x01, 0x02, =
0x03,
@@ -316,6 +386,12 @@ static const struct cyapa_cmd_len cyapa_smbus_cmds[] =
=3D {
        { CYAPA_SMBUS_BLK_HEAD, 16 },
 };

+static const char unique_str[] =3D "CYTRA";
+
+static int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout);
+static void cyapa_detect(struct cyapa *cyapa);
+static void cyapa_detect_async(void *data, async_cookie_t cookie);
+
 static ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_=
t len,
                                        u8 *values)
 {
@@ -417,88 +493,57 @@ static ssize_t cyapa_read_block(struct cyapa *cyapa, =
u8 cmd_idx, u8 *values)
 }

 /*
- * Query device for its current operating state.
+ * Determine the Gen3 trackpad device's current operating state.
  *
  */
-static int cyapa_get_state(struct cyapa *cyapa)
+static int cyapa_gen3_state_parse(struct cyapa *cyapa, u8 *reg_data, int l=
en)
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
-
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
+               return 0;
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
+               return 0;
+       } else if ((reg_data[0] & 0x80) && (reg_data[1] & 0x08)) {
+               /* normal state when running in operaitonal mode,
+                * may also not in full power state or
+                * busying in command process. */
+               if (((reg_data[1] >> 4) & 0x07) <=3D 5) {
+                       /* only finger number data is valid. */
+                       cyapa->gen =3D CYAPA_GEN3;
                        cyapa->state =3D CYAPA_STATE_OP;
-                       break;
-               default:
-                       ret =3D -EAGAIN;
-                       goto error;
+                       return 0;
                }
-       } else {
-               if (status[REG_BL_STATUS] & BL_STATUS_BUSY)
-                       cyapa->state =3D CYAPA_STATE_BL_BUSY;
-               else if (status[REG_BL_ERROR] & BL_ERROR_BOOTLOADING)
-                       cyapa->state =3D CYAPA_STATE_BL_ACTIVE;
-               else
-                       cyapa->state =3D CYAPA_STATE_BL_IDLE;
+       } else if (reg_data[0] =3D=3D 0x0C && reg_data[1] =3D=3D 0x08) {
+               /* Op state when first two registers overwritten with 0x00 =
*/
+               cyapa->gen =3D CYAPA_GEN3;
+               cyapa->state =3D CYAPA_STATE_OP;
+               return 0;
+       } else if (reg_data[1] & (BL_STATUS_RUNNING | BL_STATUS_BUSY)) {
+               cyapa->gen =3D CYAPA_GEN3;
+               cyapa->state =3D CYAPA_STATE_BL_BUSY;
+               return 0;
        }

-       return 0;
-error:
-       return (ret < 0) ? ret : -EAGAIN;
+       return -EAGAIN;
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
-{
-       int ret;
-       int tries =3D timeout / 100;
-
-       ret =3D cyapa_get_state(cyapa);
-       while ((ret || cyapa->state >=3D CYAPA_STATE_BL_BUSY) && tries--) {
-               msleep(100);
-               ret =3D cyapa_get_state(cyapa);
-       }
-       return (ret =3D=3D -EAGAIN || ret =3D=3D -ETIMEDOUT) ? -ETIMEDOUT :=
 ret;
-}
-
-static int cyapa_bl_deactivate(struct cyapa *cyapa)
+static int cyapa_gen3_bl_deactivate(struct cyapa *cyapa)
 {
        int ret;

@@ -530,7 +575,7 @@ static int cyapa_bl_deactivate(struct cyapa *cyapa)
  *   -EAGAIN device is stuck in bootloader, b/c it has invalid firmware
  *   0       device is supported and in operational mode
  */
-static int cyapa_bl_exit(struct cyapa *cyapa)
+static int cyapa_gen3_bl_exit(struct cyapa *cyapa)
 {
        int ret;

@@ -546,9 +591,10 @@ static int cyapa_bl_exit(struct cyapa *cyapa)
        /*
         * In addition, when a device boots for the first time after being
         * updated to new firmware, it must first calibrate its sensors, wh=
ich
-        * can take up to an additional 2 seconds.
+        * can take up to an additional 2 seconds. If the device power is
+        * running low, this may take even longer.
         */
-       ret =3D cyapa_poll_state(cyapa, 2000);
+       ret =3D cyapa_poll_state(cyapa, 4000);
        if (ret < 0)
                return ret;
        if (cyapa->state !=3D CYAPA_STATE_OP)
@@ -557,33 +603,104 @@ static int cyapa_bl_exit(struct cyapa *cyapa)
        return 0;
 }

+static u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode)
+{
+       u8 encoded_time =3D pwr_mode >> 2;
+       return (encoded_time < 10) ? encoded_time * 10
+                                  : (encoded_time - 5) * 20;
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
 /*
  * Set device power mode
  *
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
  */
-static int cyapa_set_power_mode(struct cyapa *cyapa, u8 power_mode)
+static int cyapa_gen3_set_power_mode(struct cyapa *cyapa, u8 power_mode,
+               u16 reverved)
 {
-       struct device *dev =3D &cyapa->client->dev;
        int ret;
        u8 power;
+       int tries =3D SET_POWER_MODE_TRIES;
+       u16 sleep_time;

+       /* Specific parameter for Gen4 and later trackpad devices.
+        * Avoid compile warning.
+        */
+       reverved =3D 0;
        if (cyapa->state !=3D CYAPA_STATE_OP)
                return 0;

-       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_POWER_MODE);
+       while (true) {
+               ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_POWER_MODE);
+               if (ret >=3D 0 || --tries < 1)
+                       break;
+               usleep_range(SET_POWER_MODE_DELAY, 2 * SET_POWER_MODE_DELAY=
);
+       }
        if (ret < 0)
                return ret;

-       power =3D ret & ~PWR_MODE_MASK;
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
        power |=3D power_mode & PWR_MODE_MASK;
-       ret =3D cyapa_write_byte(cyapa, CYAPA_CMD_POWER_MODE, power);
-       if (ret < 0)
-               dev_err(dev, "failed to set power_mode 0x%02x err =3D %d\n"=
,
-                       power_mode, ret);
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
        return ret;
 }

-static int cyapa_get_query_data(struct cyapa *cyapa)
+static int cyapa_gen3_get_query_data(struct cyapa *cyapa)
 {
        u8 query_data[QUERY_DATA_SIZE];
        int ret;
@@ -592,10 +709,8 @@ static int cyapa_get_query_data(struct cyapa *cyapa)
                return -EBUSY;

        ret =3D cyapa_read_block(cyapa, CYAPA_CMD_GROUP_QUERY, query_data);
-       if (ret < 0)
-               return ret;
        if (ret !=3D QUERY_DATA_SIZE)
-               return -EIO;
+               return (ret < 0) ? ret : -EIO;

        memcpy(&cyapa->product_id[0], &query_data[0], 5);
        cyapa->product_id[5] =3D '-';
@@ -604,6 +719,9 @@ static int cyapa_get_query_data(struct cyapa *cyapa)
        memcpy(&cyapa->product_id[13], &query_data[11], 2);
        cyapa->product_id[15] =3D '\0';

+       cyapa->fw_maj_ver =3D query_data[15];
+       cyapa->fw_min_ver =3D query_data[16];
+
        cyapa->btn_capability =3D query_data[19] & CAPABILITY_BTN_MASK;

        cyapa->gen =3D query_data[20] & 0x0f;
@@ -633,30 +751,38 @@ static int cyapa_get_query_data(struct cyapa *cyapa)
  *   -EINVAL device is in operational mode, but not supported by this driv=
er
  *   0       device is supported
  */
-static int cyapa_check_is_operational(struct cyapa *cyapa)
+static int cyapa_gen3_do_operational_check(struct cyapa *cyapa)
 {
        struct device *dev =3D &cyapa->client->dev;
-       static const char unique_str[] =3D "CYTRA";
        int ret;

-       ret =3D cyapa_poll_state(cyapa, 2000);
-       if (ret < 0)
-               return ret;
        switch (cyapa->state) {
        case CYAPA_STATE_BL_ACTIVE:
-               ret =3D cyapa_bl_deactivate(cyapa);
-               if (ret)
+               ret =3D cyapa_gen3_bl_deactivate(cyapa);
+               if (ret) {
+                       dev_err(dev, "failed to bl_deactivate. %d\n", ret);
                        return ret;
+               }

        /* Fallthrough state */
        case CYAPA_STATE_BL_IDLE:
-               ret =3D cyapa_bl_exit(cyapa);
-               if (ret)
+               ret =3D cyapa_gen3_bl_exit(cyapa);
+               if (ret) {
+                       dev_err(dev, "failed to bl_exit. %d\n", ret);
                        return ret;
+               }

        /* Fallthrough state */
        case CYAPA_STATE_OP:
-               ret =3D cyapa_get_query_data(cyapa);
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
                if (ret < 0)
                        return ret;

@@ -682,27 +808,25 @@ static int cyapa_check_is_operational(struct cyapa *c=
yapa)
        return 0;
 }

-static irqreturn_t cyapa_irq(int irq, void *dev_id)
+static void cyapa_gen3_irq_handler(struct cyapa *cyapa)
 {
-       struct cyapa *cyapa =3D dev_id;
-       struct device *dev =3D &cyapa->client->dev;
        struct input_dev *input =3D cyapa->input;
        struct cyapa_reg_data data;
        int i;
        int ret;
        int num_fingers;

-       if (device_may_wakeup(dev))
-               pm_wakeup_event(dev, 0);
-
        ret =3D cyapa_read_block(cyapa, CYAPA_CMD_GROUP_DATA, (u8 *)&data);
-       if (ret !=3D sizeof(data))
-               goto out;
+       if (ret !=3D sizeof(data)) {
+               async_schedule(cyapa_detect_async, cyapa);
+               return;
+       }

        if ((data.device_status & OP_STATUS_SRC) !=3D OP_STATUS_SRC ||
            (data.device_status & OP_STATUS_DEV) !=3D CYAPA_DEV_NORMAL ||
            (data.finger_btn & OP_DATA_VALID) !=3D OP_DATA_VALID) {
-               goto out;
+               async_schedule(cyapa_detect_async, cyapa);
+               return;
        }

        num_fingers =3D (data.finger_btn >> 4) & 0x0f;
@@ -724,22 +848,271 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)

        if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK)
                input_report_key(input, BTN_LEFT,
-                                data.finger_btn & OP_DATA_LEFT_BTN);
-
+                                !!(data.finger_btn & OP_DATA_LEFT_BTN));
        if (cyapa->btn_capability & CAPABILITY_MIDDLE_BTN_MASK)
                input_report_key(input, BTN_MIDDLE,
-                                data.finger_btn & OP_DATA_MIDDLE_BTN);
-
+                                !!(data.finger_btn & OP_DATA_MIDDLE_BTN));
        if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK)
                input_report_key(input, BTN_RIGHT,
-                                data.finger_btn & OP_DATA_RIGHT_BTN);
-
+                                !!(data.finger_btn & OP_DATA_RIGHT_BTN));
        input_sync(input);
+}
+
+/* Returns the number of read bytes or a negative errno code. */
+static ssize_t cyapa_i2c_read(struct cyapa *cyapa, u8 reg, size_t len,
+                                       u8 *values)
+{
+       int ret;
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
+}
+
+/**
+ * cyapa_i2c_write - execute i2c block data write operation
+ * @cyapa: Handle to this driver
+ * @ret: Offset of the data to written in the register map
+ * @len: the data length of bytes to written.
+ * @values: Data to be written
+ *
+ * This executes returns a negative errno code else zero on success.
+ */
+static ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
+                                        size_t len, const u8 *values)
+{
+       int ret;
+       struct i2c_client *client =3D cyapa->client;
+
+       cyapa->tmp_buf[0] =3D reg;
+       memcpy(&cyapa->tmp_buf[1], values, len);
+       ret =3D i2c_master_send(client, cyapa->tmp_buf, len + 1);
+
+       return (ret =3D=3D (len + 1)) ? 0 : ((ret < 0) ? ret : -EIO);
+}
+
+static void cyapa_default_irq_handler(struct cyapa *cyapa)
+{
+       async_schedule(cyapa_detect_async, cyapa);
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
+static int cyapa_check_is_operational(struct cyapa *cyapa)
+{
+       int ret;
+
+       ret =3D cyapa_poll_state(cyapa, 4000);
+       if (ret)
+               return ret;
+
+       switch (cyapa->gen) {
+       case CYAPA_GEN3:
+               cyapa->cyapa_check_fw =3D NULL;
+               cyapa->cyapa_bl_enter =3D NULL;
+               cyapa->cyapa_bl_activate =3D NULL;
+               cyapa->cyapa_bl_initiate =3D NULL;
+               cyapa->cyapa_update_fw =3D NULL;
+               cyapa->cyapa_bl_verify_app_integrity =3D NULL;
+               cyapa->cyapa_bl_deactivate =3D cyapa_gen3_bl_deactivate;
+               cyapa->cyapa_show_baseline =3D NULL;
+               cyapa->cyapa_calibrate_store =3D NULL;
+               cyapa->cyapa_irq_handler =3D cyapa_gen3_irq_handler;
+               cyapa->cyapa_set_power_mode =3D cyapa_gen3_set_power_mode;
+               cyapa->cyapa_read_fw =3D NULL;
+               cyapa->cyapa_read_raw_data =3D NULL;
+
+               ret =3D cyapa_gen3_do_operational_check(cyapa);
+               break;
+       default:
+               cyapa->gen =3D CYAPA_GEN_UNKNOWN;
+               cyapa->cyapa_check_fw =3D NULL;
+               cyapa->cyapa_bl_enter =3D NULL;
+               cyapa->cyapa_bl_activate =3D NULL;
+               cyapa->cyapa_bl_initiate =3D NULL;
+               cyapa->cyapa_update_fw =3D NULL;
+               cyapa->cyapa_bl_verify_app_integrity =3D NULL;
+               cyapa->cyapa_show_baseline =3D NULL;
+               cyapa->cyapa_calibrate_store =3D NULL;
+               cyapa->cyapa_irq_handler =3D cyapa_default_irq_handler;
+               cyapa->cyapa_set_power_mode =3D NULL;
+               cyapa->cyapa_read_fw =3D NULL;
+               cyapa->cyapa_read_raw_data =3D NULL;
+
+               ret =3D -EAGAIN;
+               break;
+       }
+
+       return ret;
+}
+
+static irqreturn_t cyapa_irq(int irq, void *dev_id)
+{
+       struct cyapa *cyapa =3D dev_id;
+       struct device *dev =3D &cyapa->client->dev;
+       struct input_dev *input =3D cyapa->input;
+       int length;
+
+       if (device_may_wakeup(dev))
+               pm_wakeup_event(dev, 0);
+
+       /*
+        * Don't read input if input device has not been configured.
+        * This check solves a race during probe() between irq_request()
+        * and irq_disable(), since there is no way to request an irq that =
is
+        * initially disabled.
+        */
+       if (!input || atomic_read(&cyapa->in_detecting))
+               goto out;
+
+       if (cyapa->cyapa_irq_handler)
+               cyapa->cyapa_irq_handler(cyapa);

 out:
        return IRQ_HANDLED;
 }

+/*
+ * Query device for its current operating state.
+ *
+ */
+static int cyapa_get_state(struct cyapa *cyapa)
+{
+       int ret;
+       u8 status[BL_STATUS_SIZE];
+       u8 cmd[32];
+       /* The i2c address of gen4 and gen5 trackpad device must be even. *=
/
+       bool even_addr =3D ((cyapa->client->addr & 0x0001) =3D=3D 0);
+       bool smbus =3D false;
+       int retires =3D 2;
+
+       cyapa->state =3D CYAPA_STATE_NO_DEVICE;
+
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
+               if (cyapa->gen =3D=3D CYAPA_GEN_UNKNOWN ||
+                               cyapa->gen =3D=3D CYAPA_GEN3) {
+                       cyapa->gen_detecting =3D CYAPA_GEN3;
+                       ret =3D cyapa_gen3_state_parse(cyapa,
+                                       status, BL_STATUS_SIZE);
+                       if (ret =3D=3D 0)
+                               goto out_detected;
+                       cyapa->gen_detecting =3D CYAPA_GEN_UNKNOWN;
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
+static int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
+{
+       int ret;
+       int tries =3D timeout / 100;
+
+       ret =3D cyapa_get_state(cyapa);
+
+       while ((ret || cyapa->state >=3D CYAPA_STATE_BL_BUSY) && tries--) {
+               msleep(100);
+               ret =3D cyapa_get_state(cyapa);
+       }
+
+       return (ret =3D=3D -EAGAIN || ret =3D=3D -ETIMEDOUT) ? -ETIMEDOUT :=
 ret;
+}
+
 static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
 {
        u8 ret =3D CYAPA_ADAPTER_FUNC_NONE;
@@ -823,6 +1196,62 @@ err_free_device:
        return ret;
 }

+static void cyapa_detect(struct cyapa *cyapa)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       char *envp[] =3D {"ERROR=3D1", NULL};
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
+               enable_irq(cyapa->irq);
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
+               if (cyapa->cyapa_set_power_mode) {
+                       ret =3D cyapa->cyapa_set_power_mode(cyapa,
+                                       PWR_MODE_FULL_ACTIVE, 0);
+                       if (ret)
+                               dev_warn(dev, "set active power failed, %d\=
n",
+                                               ret);
+               }
+       }
+}
+
+static void cyapa_detect_async(void *data, async_cookie_t cookie)
+{
+       struct cyapa *cyapa =3D (struct cyapa *)data;
+
+       if (atomic_read(&cyapa->in_detecting))
+               return;
+
+       atomic_inc(&cyapa->in_detecting);
+       cyapa_detect(cyapa);
+       atomic_dec(&cyapa->in_detecting);
+}
+
 static int cyapa_probe(struct i2c_client *client,
                       const struct i2c_device_id *dev_id)
 {
@@ -830,6 +1259,7 @@ static int cyapa_probe(struct i2c_client *client,
        u8 adapter_func;
        struct cyapa *cyapa;
        struct device *dev =3D &client->dev;
+       union i2c_smbus_data dummy;

        adapter_func =3D cyapa_check_adapter_functionality(client);
        if (adapter_func =3D=3D CYAPA_ADAPTER_FUNC_NONE) {
@@ -837,13 +1267,18 @@ static int cyapa_probe(struct i2c_client *client,
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
+       cyapa->gen =3D CYAPA_GEN_UNKNOWN;
        cyapa->client =3D client;
        i2c_set_clientdata(client, cyapa);
        sprintf(cyapa->phys, "i2c-%d-%04x/input0", client->adapter->nr,
@@ -853,23 +1288,7 @@ static int cyapa_probe(struct i2c_client *client,
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
+       cyapa->suspend_power_mode =3D PWR_MODE_SLEEP;

        cyapa->irq =3D client->irq;
        ret =3D request_threaded_irq(cyapa->irq,
@@ -882,12 +1301,14 @@ static int cyapa_probe(struct i2c_client *client,
                dev_err(dev, "IRQ request failed: %d\n, ", ret);
                goto err_unregister_device;
        }
+       disable_irq(cyapa->irq);

+       async_schedule(cyapa_detect_async, cyapa);
        return 0;

 err_unregister_device:
        input_unregister_device(cyapa->input);
-err_mem_free:
+       i2c_set_clientdata(client, NULL);
        kfree(cyapa);

        return ret;
@@ -899,7 +1320,10 @@ static int cyapa_remove(struct i2c_client *client)

        free_irq(cyapa->irq, cyapa);
        input_unregister_device(cyapa->input);
-       cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
+
+       if (cyapa->cyapa_set_power_mode)
+               cyapa->cyapa_set_power_mode(cyapa, PWR_MODE_OFF, 0);
+       i2c_set_clientdata(client, NULL);
        kfree(cyapa);

        return 0;
@@ -913,16 +1337,21 @@ static int cyapa_suspend(struct device *dev)
        struct cyapa *cyapa =3D dev_get_drvdata(dev);

        disable_irq(cyapa->irq);
+       cyapa->suspended =3D true;

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
+       if (cyapa->cyapa_set_power_mode) {
+               ret =3D cyapa->cyapa_set_power_mode(cyapa, power_mode,
+                               cyapa->suspend_sleep_time);
+               if (ret < 0)
+                       dev_err(dev, "suspend set power mode failed, %d\n",
+                                       ret);
+       }

        if (device_may_wakeup(dev))
                cyapa->irq_wake =3D (enable_irq_wake(cyapa->irq) =3D=3D 0);
@@ -936,12 +1365,18 @@ static int cyapa_resume(struct device *dev)

        if (device_may_wakeup(dev) && cyapa->irq_wake)
                disable_irq_wake(cyapa->irq);
+       enable_irq(cyapa->irq);

-       ret =3D cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
-       if (ret)
-               dev_warn(dev, "resume active power failed, %d\n", ret);
+       if (cyapa->cyapa_set_power_mode) {
+               ret =3D cyapa->cyapa_set_power_mode(cyapa, PWR_MODE_FULL_AC=
TIVE,
+                               cyapa->suspend_sleep_time);
+               if (ret)
+                       dev_warn(dev, "resume active power failed, %d\n", r=
et);
+       }

-       enable_irq(cyapa->irq);
+       async_schedule(cyapa_detect_async, cyapa);
+
+       cyapa->suspended =3D false;
        return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F40C11432S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+InkyAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAAEExMjkwMDAx
ODlCOEE2NDBCMjREMTc1Q0RDOTg1QjU0AAgHAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBAAOAAcA
NQA5AAEAbQEBIIADAA4AAADeBwQADgAHADUAOQABAG0BAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAE0AAABbUEFUQ0ggMS82XSBpbnB1dDogY3lhcGE6IHJlYXJjaGl0ZWN0
dXJlIGRyaXZlciB0byBzdXBwb3J0IGZ1bmN0aW9uIHBvaW50ZXJzANAbAQOQBgB8QwAASwAAAAIB
fwABAAAAQgAAADw3N0JDNzI1QzkwNjI3NjRGODc0RDc5RjUxRTFGMUE4RjQwQzExNDMyQFMwNC1N
QlgwMS0wMS5zMDQubG9jYWw+AAAACwAfDgEAAAACAQkQAQAAAC83AAArNwAAW6oAAExaRnXXXi61
YQAKZmJpZAQAAGNjwHBnMTI1MgD+A0PwdGV4dAH3AqQD4wIABGNoCsBzZXQwIO8HbQKDAFARTTIK
gAa0AoCWfQqACMg7CWIxOQ7AvwnDFnIKMhZxAoAVYioJsHMJ8ASQYXQFsg5QA2Bzom8BgCBFeBHB
bhgwXQZSdgSQF7YCEHIAwHR9CFBuGjEQIAXABaAbZGSaIANSIBAiF7JcdgiQ5HdrC4BkNR1TBPAH
QA0XcDAKcRfyYmttawZzAZAAICBCTV9C4EVHSU59CvwB8QvxWQfwZS0KwBHAaRAgY6Z0CHAZ4HRo
GeBkBRADGjEcwG8gc3VwcFMJERxwdW4iQGkCICDnI7ALgBuhcywjcCNgIhDTG9AAcFxsC4BlCoAj
hv8AcBxgJLIJwBiAGeAYUAfgewEAHWBjB5ELYBuiC4Ag4wIgIsYuIEkkIApADeAZGcAgdRIAJcVh
c3n3JCAikQlwYSbSJ8UkgANg9wJgIoEjYXAJ4BxgI5AjcNp5H2BlHLAG4G8FQCRABQeALiXFVEVT
VD1HECAfYCjRIENoA3Bljy3xH1AuhiXFU2lnGFAEZC0ZMGYtYnk6WCBEdSUQMlBkHnB5iCA8ZDKh
QGN5LFCnB5AwYAWgbT4lxS00kFclxQ3gASAgNJBnJWFhEi8i5HMvC4BwdXTWLwRgKkEvM2BhCrAz
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
AGQAAQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAFgAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAA
AIBEAHUAZABsAGUAeQAgAEQAdQAAAFMATQBUAFAAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAu
AGMAbwBtAAAAHwACXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAA
HwDlXwEAAAAqAAAAcwBpAHAAOgBkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAf
ABoMAQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAB8AHwwBAAAAIgAAAGQAdQBkAGwAQABjAHkA
cAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAWAAA
AAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwAZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQA
dQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAfAAFdAQAAACIAAABkAHUAZABsAEAAYwB5
AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAPg/AQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAB8A
I0ABAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AIkABAAAACgAA
AFMATQBUAFAAAAAAAAIB+T8BAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwA
ZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAf
AAldAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfADFAAQAAAAIA
AAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEAAAASAAAASQBQAE0ALgBOAG8AdABl
AAAAAAADAPE/BAgAAAsAQDoBAAAAAwD9P6gDAAACAQswAQAAABAAAAChKQABibimQLJNF1zcmFtU
AwAXAAEAAABAADkAgNhEsLZXzwFAAAgw+Vi+sLZXzwELACkAAAAAAAsAIwAAAAAAHwAAgIYDAgAA
AAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAABoA
AAB6AGgALQBDAE4ALAAgAGUAbgAtAFUAUwAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAABoUA
AAAAAAAfADcAAQAAAJoAAABbAFAAQQBUAEMASAAgADEALwA2AF0AIABpAG4AcAB1AHQAOgAgAGMA
eQBhAHAAYQA6ACAAcgBlAGEAcgBjAGgAaQB0AGUAYwB0AHUAcgBlACAAZAByAGkAdgBlAHIAIAB0
AG8AIABzAHUAcABwAG8AcgB0ACAAZgB1AG4AYwB0AGkAbwBuACAAcABvAGkAbgB0AGUAcgBzAAAA
AAAfAD0AAQAAAAIAAAAAAAAAAwA2AAAAAAACAXEAAQAAABYAAAABz1e2r0vs2iO86CNE56xngah+
UAUUAAAfAHAAAQAAAJoAAABbAFAAQQBUAEMASAAgADEALwA2AF0AIABpAG4AcAB1AHQAOgAgAGMA
eQBhAHAAYQA6ACAAcgBlAGEAcgBjAGgAaQB0AGUAYwB0AHUAcgBlACAAZAByAGkAdgBlAHIAIAB0
AG8AIABzAHUAcABwAG8AcgB0ACAAZgB1AG4AYwB0AGkAbwBuACAAcABvAGkAbgB0AGUAcgBzAAAA
AAAfADUQAQAAAIQAAAA8ADcANwBCAEMANwAyADUAQwA5ADAANgAyADcANgA0AEYAOAA3ADQARAA3
ADkARgA1ADEARQAxAEYAMQBBADgARgA0ADAAQwAxADEANAAzADIAQABTADAANAAtAE0AQgBYADAA
MQAtADAAMQAuAHMAMAA0AC4AbABvAGMAYQBsAD4AAAADAN4/n04AAAsAAIAIIAYAAAAAAMAAAAAA
AABGAAAAAAOFAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAAYUAAAAAAAADAACAAyAGAAAA
AADAAAAAAAAARgAAAAABgQAAAAAAAAMAgBD/////BQAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAoEA
AAAAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAHIEAAAAAAABAAAcwhbLUr7ZXzwELAAIA
AQAAAAMAJgAAAAAAAgEQMAEAAABGAAAAAAAAALEfoTkwIFFGnbSlcN7Qn9QHAHe8clyQYnZPh015
9R4fGo8AAACZPBsAALqnPu7L1/dAo3bvNfxhWYkAGIP8wyUAAAAAHwD6PwEAAAAUAAAARAB1AGQA
bABlAHkAIABEAHUAAAADAAlZAQAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABCFAAAAAAAAHwAA
gB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUA
eABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAALoAAABJAEkAPQAwADEAQwBGADUANwBCADYAQQBG
ADQAQgBFAEMARABBADIAMwBCAEMARQA4ADIAMwA0ADQARQA3AEEAQwA2ADcAOAAxAEEAOAA3AEUA
NQAwADAANQAxADQAOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADMAIAAo
AEIAdQBpAGwAZAAgADEANwA0AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADQAAAAAAAMAAIADIAYA
AAAAAMAAAAAAAABGAAAAABOBAAABAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAI4EAAP///38D
AACAAyAGAAAAAADAAAAAAAAARgAAAAAQgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABGB
AAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJIEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAA
RgAAAAAsgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACmBAAAAAAAAAwAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAKoEAAAAAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAngQAAAQAAAAIAAAAA
AAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEoEAAAEAAAAfAACAAyAGAAAAAADAAAAAAAAARgAA
AAAhgQAAAQAAAAIAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAA4EAAAAAAAALAACAAyAG
AAAAAADAAAAAAAAARgAAAAAmgQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAA6FAAAAAAAA
AwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAACC
hQAAAAAAAEAAAIAIIAYAAAAAAMAAAAAAAABGAAAAAL+FAACw2ZWJtVfPAQMADTT9PwAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAA
AAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQA
aQBuAGcALQBpAHAAAAAAAAEAAAAeAAAAWwAxADAALgAzADAALgAxADIALgAxADQAOABdAAAAAAB/
fg==

--_000_77BC725C9062764F874D79F51E1F1A8F40C11432S04MBX0101s04lo_--
