Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaDPIgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:36:00 -0400
Received: from relay-s04-hub001.domainlocalhost.com ([74.115.207.100]:10222
	"EHLO relay-S04-HUB001.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbaDPIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:35:54 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F40C1405ES04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "David Solda" <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] input: cyapa: rearchitecture driver to support function
 pointers
Thread-Topic: [PATCH 1/6] input: cyapa: rearchitecture driver to support
 function pointers
Thread-Index: Ac9Xtq9L7NojvOgjROesZ4GoflAFFABl+2Kw
Date: Wed, 16 Apr 2014 08:35:52 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C1405E@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F40C1405E@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.153]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F40C1405ES04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Re-architecture the driver to support function pointers, so it can support =
and integrate new devices later in one driver.
Including use async thread in device proble to speed up system boot time.
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

--_000_77BC725C9062764F874D79F51E1F1A8F40C1405ES04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+Ij88AQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADU0QjMxNjNE
MDI2OENBNERCMkVBNjQwNUZDNjBCNTUxAB0HAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBAAQAAgA
IwA0AAMAWwEBIIADAA4AAADeBwQAEAAIACMANAADAFsBAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAE0AAABbUEFUQ0ggMS82XSBpbnB1dDogY3lhcGE6IHJlYXJjaGl0ZWN0
dXJlIGRyaXZlciB0byBzdXBwb3J0IGZ1bmN0aW9uIHBvaW50ZXJzANAbAQOQBgCsQwAATgAAAAIB
fwABAAAAQgAAADw3N0JDNzI1QzkwNjI3NjRGODc0RDc5RjUxRTFGMUE4RjQwQzE0MDVFQFMwNC1N
QlgwMS0wMS5zMDQubG9jYWw+AAAACwAfDgEAAAACAQkQAQAAACs3AAAnNwAAVaoAAExaRnW3iAL2
YQAKZmJpZAQAAGNjwHBnMTI1MgD+A0PwdGV4dAH3AqQD4wIABGNoCsBzZXQwIO8HbQKDAFARTTIK
gAa0AoCWfQqACMg7CWIxOQ7AvwnDFnIKMhZxAoAVYioJsHMJ8ASQYXQFsg5QA2Bzom8BgCBFeBHB
bhgwXQZSdgSQF7YCEHIAwHR9CFBuGjEQIAXABaAbZGSaIANSIBAiF7JcdgiQ5HdrC4BkNR1TBPAH
QA0XcDAKcRfyYmttawZzAZAAICBCTV9C4EVHSU59CvwB8QvxWQfwZS0KwBHAaRAgY6Z0CHAZ4HRo
GeBkBRADGjEcwG8gc3VwcFMJERxwdW4iQGkCICDnI7ALgBuhcywjcCNgIhD/G9ADkSOGAHAcYCSy
CcAYgN8Z4BhQB+ABAB1gYweRC2AbG6ILgCACICLGLlxs9QuAZQqASSQgCkAN4BnAzCB1EgAmQHN5
JCAikf0JcGEmcidlJIADYAJgIoG9I2FwCeAcYCOQI3B5H2D2ZRywBuBvBUAkQAeAKSbgVEVTVD0Q
IB9gKHHoIENoA3BlLZEfUCkmkSk1U2lnGFBkLRkwAGYtYnk6IER1CyUQMfBkHnB5IDxk8TJBQGN5
K/AHkDAABaD0bT4pNS00MCk1DeABIEogNDBnJWFhLyLkc8IvC4BwdXQvBGAqQfovMwBhCrAzcC2A
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
AAAACgAAAFMATQBUAFAAAAAAAAIBQQABAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQA
dQBkAGwAZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBv
AG0AAAAfAAJdAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAOVf
AQAAACoAAABzAGkAcAA6AGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AGgwB
AAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAHwAfDAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIA
ZQBzAHMALgBjAG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABYAAAAAAAA
AIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQA
bABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8AAV0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcABy
AGUAcwBzAC4AYwBvAG0AAAAAAB8A+D8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAHwAjQAEA
AAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBN
AFQAUAAAAAAAAgH5PwEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkA
IABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8ACV0B
AAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AMUABAAAAAgAAAAAA
AAALAEA6AQAAAB8AMEABAAAAAgAAAAAAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAA
AAMA8T8ECAAACwBAOgEAAAADAP0/qAMAAAIBCzABAAAAEAAAAFSzFj0CaMpNsupkBfxgtVEDABcA
AQAAAEAAOQAA5CbgTlnPAUAACDAZ7IzgTlnPAQsAKQAAAAAACwAjAAAAAAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAAGgAAAHoA
aAAtAEMATgAsACAAZQBuAC0AVQBTAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAA
AB8ANwABAAAAmgAAAFsAUABBAFQAQwBIACAAMQAvADYAXQAgAGkAbgBwAHUAdAA6ACAAYwB5AGEA
cABhADoAIAByAGUAYQByAGMAaABpAHQAZQBjAHQAdQByAGUAIABkAHIAaQB2AGUAcgAgAHQAbwAg
AHMAdQBwAHAAbwByAHQAIABmAHUAbgBjAHQAaQBvAG4AIABwAG8AaQBuAHQAZQByAHMAAAAAAB8A
PQABAAAAAgAAAAAAAAADADYAAAAAAAMALgAAAAAAHwBCEAEAAAACAAAAAAAAAAIBcQABAAAAGwAA
AAHPV7avS+zaI7zoI0TnrGeBqH5QBRQAZftisAAfAHAAAQAAAJoAAABbAFAAQQBUAEMASAAgADEA
LwA2AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6ACAAcgBlAGEAcgBjAGgAaQB0AGUAYwB0
AHUAcgBlACAAZAByAGkAdgBlAHIAIAB0AG8AIABzAHUAcABwAG8AcgB0ACAAZgB1AG4AYwB0AGkA
bwBuACAAcABvAGkAbgB0AGUAcgBzAAAAAAAfADUQAQAAAIQAAAA8ADcANwBCAEMANwAyADUAQwA5
ADAANgAyADcANgA0AEYAOAA3ADQARAA3ADkARgA1ADEARQAxAEYAMQBBADgARgA0ADAAQwAxADQA
MAA1AEUAQABTADAANAAtAE0AQgBYADAAMQAtADAAMQAuAHMAMAA0AC4AbABvAGMAYQBsAD4AAAAf
ADkQAQAAAAIAAAAAAAAAAwDeP59OAAALAACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMA
AIAIIAYAAAAAAMAAAAAAAABGAAAAAAGFAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEA
AAAAAAADAIAQ/////wUAAIADIAYAAAAAAMAAAAAAAABGAAAAAAKBAAAAAAAAAAAAAAsAAIADIAYA
AAAAAMAAAAAAAABGAAAAAByBAAAAAAAAQAAHMJ2Wc99OWc8BCwACAAEAAAADACYAAAAAAAsAKwAA
AAAAAgEQMAEAAABGAAAAAAAAALEfoTkwIFFGnbSlcN7Qn9QHAHe8clyQYnZPh0159R4fGo8AAACZ
PBsAALqnPu7L1/dAo3bvNfxhWYkAGIP8wywAAAAAHwD6PwEAAAAUAAAARAB1AGQAbABlAHkAIABE
AHUAAAADAAlZAQAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABCFAAAAAAAAHwAAgB+k6zOoei5C
vnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBj
AGsAaQBuAGcARQB4AAAAAQAAAN4AAABJAEkAPQAwADEAQwBGADUANwBCADYAQQBGADQAQgBFAEMA
RABBADIAMwBCAEMARQA4ADIAMwA0ADQARQA3AEEAQwA2ADcAOAAxAEEAOAA3AEUANQAwADAANQAx
ADQAMAAwADYANQBGAEIANgAyAEIAMAA7AFMAQgBDAEkARAA9ADUAOwBWAGUAcgBzAGkAbwBuAD0A
VgBlAHIAcwBpAG8AbgAgADEANAAuADMAIAAoAEIAdQBpAGwAZAAgADEANwA0AC4AMAApACwAIABT
AHQAYQBnAGUAPQBIADQAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABOBAAABAAAAAwAAgAMg
BgAAAAAAwAAAAAAAAEYAAAAAI4EAAP///38DAACAAyAGAAAAAADAAAAAAAAARgAAAAAQgQAAAAAA
AAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABGBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAA
JIEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAsgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAA
AABGAAAAACmBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKoEAAAAAAAAfAACAAyAGAAAA
AADAAAAAAAAARgAAAAAngQAAAQAAAAIAAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEoEA
AAEAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAhgQAAAQAAAAIAAAAAAAAACwAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAA4EAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAmgQAAAAAAAAsAAIAI
IAYAAAAAAMAAAAAAAABGAAAAAA6FAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAA
AAALAACACCAGAAAAAADAAAAAAAAARgAAAACChQAAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAA
AAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAA
HwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBp
AHAAAAAAAAEAAAAeAAAAWwAxADAALgAzADAALgAxADIALgAxADUAMwBdAAAAAAA5cQ==

--_000_77BC725C9062764F874D79F51E1F1A8F40C1405ES04MBX0101s04lo_--
