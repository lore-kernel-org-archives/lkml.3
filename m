Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaIJEj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:39:56 -0400
Received: from bay004-omc1s20.hotmail.com ([65.54.190.31]:52396 "EHLO
	BAY004-OMC1S20.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbaIJEjx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:39:53 -0400
X-TMN: [nMMb3GUw081h5Ch4AMiFnHdDLWRvITQ5]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS1532BDD102C9048C2B2141BDCF0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 10/13] input: cyapa: add gen5 trackpad device basic functions support
Date: Wed, 10 Sep 2014 12:35:04 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/MsJc3t4SZfELLTSKP1fiLuA+vuA==
Content-Language: zh-cn
X-OriginalArrivalTime: 10 Sep 2014 04:35:05.0912 (UTC) FILETIME=[98560B80:01CFCCB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the cyapa core, add the gen5 trackpad device's basic functions
supported, so gen5 trackpad device can work with kernel input system.
And also based on the state parse interface, the cyapa driver can
automatically determine the attached is gen3 or gen5 protocol trackpad
device, then set the correct protocol to work with the attached
trackpad device.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/Makefile     |    2 +-
 drivers/input/mouse/cyapa.c      |   29 +-
 drivers/input/mouse/cyapa.h      |    1 +
 drivers/input/mouse/cyapa_gen5.c | 1660 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 1687 insertions(+), 5 deletions(-)
 create mode 100644 drivers/input/mouse/cyapa_gen5.c

diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 63b42e0..08785a5 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -35,4 +35,4 @@ psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
 psmouse-$(CONFIG_MOUSE_PS2_CYPRESS)	+= cypress_ps2.o
 
-cyapatp-y := cyapa.o cyapa_gen3.o
+cyapatp-y := cyapa.o cyapa_gen3.o cyapa_gen5.o
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 7ac2fdf..391c95c 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -122,6 +122,8 @@ void cyapa_default_irq_handler(struct cyapa *cyapa)
 	cont = true;
 	if (cyapa_gen3_ops.irq_cmd_handler)
 		cont = cyapa_gen3_ops.irq_cmd_handler(cyapa);
+	if (cont && cyapa_gen5_ops.irq_cmd_handler)
+		cont = cyapa_gen5_ops.irq_cmd_handler(cyapa);
 	if (!cont)
 		return;
 
@@ -264,6 +266,9 @@ static int cyapa_check_is_operational(struct cyapa *cyapa)
 		return ret;
 
 	switch (cyapa->gen) {
+	case CYAPA_GEN5:
+		cyapa->ops = &cyapa_gen5_ops;
+		break;
 	case CYAPA_GEN3:
 		cyapa->ops = &cyapa_gen3_ops;
 		break;
@@ -377,6 +382,14 @@ static int cyapa_get_state(struct cyapa *cyapa)
 			if (ret == 0)
 				goto out_detected;
 		}
+		if ((cyapa->gen == CYAPA_GEN_UNKNOWN ||
+				cyapa->gen == CYAPA_GEN5) &&
+			!smbus && even_addr) {
+			ret = cyapa_gen5_ops.state_parse(cyapa,
+					status, BL_STATUS_SIZE);
+			if (ret == 0)
+				goto out_detected;
+		}
 
 		/*
 		 * Cannot detect communication protocol based on current
@@ -1096,18 +1109,26 @@ static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
 
 static int cyapa_tp_modules_init(struct cyapa *cyapa)
 {
+	int ret = 0;
+
 	if (cyapa_gen3_ops.initialize)
-		return cyapa_gen3_ops.initialize(cyapa);
+		ret = cyapa_gen3_ops.initialize(cyapa);
+	if (!ret && cyapa_gen5_ops.initialize)
+		ret = cyapa_gen5_ops.initialize(cyapa);
 
-	return 0;
+	return ret;
 }
 
 static int cyapa_tp_modules_uninit(struct cyapa *cyapa)
 {
+	int ret = 0;
+
 	if (cyapa_gen3_ops.uninitialize)
-		return cyapa_gen3_ops.uninitialize(cyapa);
+		ret = cyapa_gen3_ops.uninitialize(cyapa);
+	if (!ret && cyapa_gen5_ops.uninitialize)
+		ret = cyapa_gen5_ops.uninitialize(cyapa);
 
-	return 0;
+	return ret;
 }
 
 static int cyapa_probe(struct i2c_client *client,
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 0b8d023..36e87c3 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -299,5 +299,6 @@ u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode);
 
 extern const char unique_str[];
 extern const struct cyapa_dev_ops cyapa_gen3_ops;
+extern const struct cyapa_dev_ops cyapa_gen5_ops;
 
 #endif
diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
new file mode 100644
index 0000000..4f64b0b
--- /dev/null
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -0,0 +1,1660 @@
+/*
+ * Cypress APA trackpad with I2C interface
+ *
+ * Author: Dudley Du <dudl@cypress.com>
+ *
+ * Copyright (C) 2014 Cypress Semiconductor, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
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
+/* Macro of Gen5 */
+#define RECORD_EVENT_NONE        0
+#define RECORD_EVENT_TOUCHDOWN	 1
+#define RECORD_EVENT_DISPLACE    2
+#define RECORD_EVENT_LIFTOFF     3
+
+#define CYAPA_TSG_FLASH_MAP_BLOCK_SIZE      0x80
+#define CYAPA_TSG_IMG_FW_HDR_SIZE           13
+#define CYAPA_TSG_FW_ROW_SIZE               (CYAPA_TSG_FLASH_MAP_BLOCK_SIZE)
+#define CYAPA_TSG_IMG_START_ROW_NUM         0x002e
+#define CYAPA_TSG_IMG_END_ROW_NUM           0x01fe
+#define CYAPA_TSG_IMG_APP_INTEGRITY_ROW_NUM 0x01ff
+#define CYAPA_TSG_IMG_MAX_RECORDS           (CYAPA_TSG_IMG_END_ROW_NUM - \
+				CYAPA_TSG_IMG_START_ROW_NUM + 1 + 1)
+#define CYAPA_TSG_IMG_READ_SIZE             (CYAPA_TSG_FLASH_MAP_BLOCK_SIZE / 2)
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
+#define VALID_CMD_RESP_HEADER(resp, cmd)				    \
+	(((resp)[GEN5_RESP_REPORT_ID_OFFSET] == GEN5_APP_RESP_REPORT_ID) && \
+	((resp)[GEN5_RESP_RSVD_OFFSET] == GEN5_RESP_RSVD_KEY) &&	    \
+	(GET_GEN5_CMD_CODE((resp)[GEN5_RESP_APP_CMD_OFFSET]) == (cmd)))
+
+#define GEN5_MIN_BL_CMD_LENGTH           13
+#define GEN5_MIN_BL_RESP_LENGTH          11
+#define GEN5_MIN_APP_CMD_LENGTH          7
+#define GEN5_MIN_APP_RESP_LENGTH         5
+#define GEN5_UNSUPPORTED_CMD_RESP_LENGTH 6
+
+#define GEN5_RESP_LENGTH_OFFSET  0x00
+#define GEN5_RESP_LENGTH_SIZE    2
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
+#define GEN5_CMD_COMPLETE_SUCCESS(status) ((status) == 0x00)
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
+#define	GEN5_NUMBER_OF_TOUCH_OFFSET  5
+#define GEN5_NUMBER_OF_TOUCH_MASK    0x1f
+#define GEN5_BUTTONS_OFFSET          5
+#define GEN5_BUTTONS_MASK            0x0f
+#define GEN5_GET_EVENT_ID(reg)       (((reg) >> 5) & 0x03)
+#define GEN5_GET_TOUCH_ID(reg)       ((reg) & 0x1f)
+
+#define GEN5_PRODUCT_FAMILY_MASK        0xf000
+#define GEN5_PRODUCT_FAMILY_TRACKPAD    0x1000
+
+#define TSG_INVALID_CMD   0xff
+
+struct cyapa_gen5_touch_record {
+	/*
+	 * bit 7 - 3: reserved
+	 * bit 2 - 0: touch type;
+	 *            0 : standard finger;
+	 *            1 - 15 : reserved.
+	 */
+	u8 touch_type;
+
+	/*
+	 * bit 7: indicates touch liftoff status.
+	 *		0 : touch is currently on the panel.
+	 *		1 : touch record indicates a liftoff.
+	 * bit 6 - 5: indicates an event associated with this touch instance
+	 *		0 : no event
+	 *		1 : touchdown
+	 *		2 : significant displacement (> active distance)
+	 *		3 : liftoff (record reports last known coordinates)
+	 * bit 4 - 0: An arbitrary ID tag associated with a finger
+	 *		to alow tracking a touch as it moves around the panel.
+	 */
+	u8 touch_tip_event_id;
+
+	/* bit 7 - 0 of X-axis corrinate of the touch in pixel. */
+	u8 x_lo;
+
+	/* bit 15 - 8 of X-axis corrinate of the touch in pixel. */
+	u8 x_hi;
+
+	/* bit 7 - 0 of Y-axis corrinate of the touch in pixel. */
+	u8 y_lo;
+
+	/* bit 15 - 8 of Y-axis corrinate of the touch in pixel. */
+	u8 y_hi;
+
+	/* touch intensity in counts, pressure value. */
+	u8 z;
+
+	/*
+	 * The length of the major axis of the ellipse of contact between
+	 * the finger and the panel (ABS_MT_TOUCH_MAJOR).
+	 */
+	u8 major_axis_len;
+
+	/*
+	 * The length of the minor axis of the ellipse of contact between
+	 * the finger and the panel (ABS_MT_TOUCH_MINOR).
+	 */
+	u8 minor_axis_len;
+
+	/*
+	 * The length of the major axis of the approaching tool.
+	 * (ABS_MT_WIDTH_MAJOR)
+	 */
+	u8 major_tool_len;
+
+	/*
+	 * The length of the minor axis of the approaching tool.
+	 * (ABS_MT_WIDTH_MINOR)
+	 */
+	u8 minor_tool_len;
+
+	/*
+	 * The angle between the panel vertical axis and
+	 * the major axis of the contact ellipse. This value is an 8-bit
+	 * signed integer. The range is -127 to +127 (corresponding to
+	 * -90 degree and +90 degree respectively).
+	 * The positive direction is clockwise from the vertical axis.
+	 * If the ellipse of contact degenerates into a circle,
+	 * orientation is reported as 0.
+	 */
+	u8 orientation;
+} __packed;
+
+struct cyapa_gen5_report_data {
+	u8 report_head[GEN5_TOUCH_REPORT_HEAD_SIZE];
+	struct cyapa_gen5_touch_record touch_records[10];
+} __packed;
+
+struct cyapa_tsg_bin_image_head {
+	u8 head_size;  /* Unit: bytes, including itself. */
+	u8 ttda_driver_major_version;  /* Reserved as 0. */
+	u8 ttda_driver_minor_version;  /* Reserved as 0. */
+	u8 fw_major_version;
+	u8 fw_minor_version;
+	u8 fw_revision_control_number[8];
+} __packed;
+
+struct cyapa_tsg_bin_image_data_record {
+	u8 flash_array_id;
+	__be16 row_number;
+	/* The number of bytes of flash data contained in this record. */
+	__be16 record_len;
+	/* The flash program data. */
+	u8 record_data[CYAPA_TSG_FW_ROW_SIZE];
+} __packed;
+
+struct cyapa_tsg_bin_image {
+	struct cyapa_tsg_bin_image_head image_head;
+	struct cyapa_tsg_bin_image_data_record records[0];
+} __packed;
+
+/* Variables for PIP irq sync command processing. */
+struct pip_sync_cmd_states {
+	struct mutex cmd_lock;
+	struct completion cmd_ready;
+	atomic_t cmd_issued;
+	u8 in_progress_cmd;
+
+	cb_sort resp_sort_func;
+	u8 *resp_data;
+	int *resp_len;
+
+	u8 irq_cmd_buf[CYAPA_REG_MAP_SIZE];
+	u8 empty_buf[CYAPA_REG_MAP_SIZE];
+};
+
+static struct pip_sync_cmd_states *gen5_pip;
+static struct cyapa_tsg_bin_image_head gen5_fw_img_head;
+
+/* Variables to record latest gen5 trackpad power states. */
+#define UNINIT_SLEEP_TIME 0xFFFF
+static u8 gen5_pwr_mode = 0xFF;
+static u16 gen5_sleep_time = UNINIT_SLEEP_TIME;
+#define GEN5_UNINIT_SLEEP_TIME(sleep_time)  \
+		((sleep_time) == UNINIT_SLEEP_TIME)
+#define SET_GEN5_POWER_STATE(s)	(gen5_pwr_mode = (s))
+#define GEN5_POWER_STATE()	(gen5_pwr_mode)
+
+
+static int cyapa_gen5_initialize(struct cyapa *cyapa)
+{
+	gen5_pip = kzalloc(sizeof(struct pip_sync_cmd_states), GFP_KERNEL);
+	if (!gen5_pip)
+		return -ENOMEM;
+
+	init_completion(&gen5_pip->cmd_ready);
+	atomic_set(&gen5_pip->cmd_issued, 0);
+	mutex_init(&gen5_pip->cmd_lock);
+	atomic_set(&gen5_pip->cmd_issued, 0);
+
+	gen5_pip->resp_sort_func = NULL;
+	gen5_pip->in_progress_cmd = TSG_INVALID_CMD;
+	gen5_pip->resp_data = NULL;
+	gen5_pip->resp_len = NULL;
+
+	return 0;
+}
+
+static int cyapa_gen5_uninitialize(struct cyapa *cyapa)
+{
+	kfree(gen5_pip);
+	return 0;
+}
+
+/* Return negative errno, or else the number of bytes read. */
+static ssize_t cyapa_i2c_pip_read(struct cyapa *cyapa, u8 *buf, size_t size)
+{
+	int ret;
+
+	if (size == 0)
+		return 0;
+
+	if (!buf || size > CYAPA_REG_MAP_SIZE)
+		return -EINVAL;
+
+	ret = i2c_master_recv(cyapa->client, buf, size);
+
+	if (ret != size)
+		return (ret < 0) ? ret : -EIO;
+
+	return size;
+}
+
+/**
+ * Return a negative errno code else zero on success.
+ */
+static ssize_t cyapa_i2c_pip_write(struct cyapa *cyapa, u8 *buf, size_t size)
+{
+	int ret;
+
+	if (!buf || !size)
+		return -EINVAL;
+
+	ret = i2c_master_send(cyapa->client, buf, size);
+
+	if (ret != size)
+		return (ret < 0) ? ret : -EIO;
+
+	return 0;
+}
+
+/**
+ * This function is aimed to dump all not read data in Gen5 trackpad
+ * before send any command, otherwise, the interrupt line will be blocked.
+ */
+int cyapa_empty_pip_output_data(struct cyapa *cyapa,
+		u8 *buf, int *len, cb_sort func)
+{
+	int ret;
+	int length;
+	int report_count;
+	int empty_count;
+	int buf_len;
+
+	buf_len = 0;
+	if (len) {
+		buf_len = (*len < CYAPA_REG_MAP_SIZE) ?
+				*len : CYAPA_REG_MAP_SIZE;
+		*len = 0;
+	}
+
+	report_count = 8;  /* max 7 pending data before command response data */
+	empty_count = 0;
+	do {
+		/*
+		 * Depnding on testing in cyapa driver, there are max 5 "02 00"
+		 * packets between two valid bufferred data report in firmware.
+		 * So in order to dump all buffered data out and
+		 * make interrupt line release for reassert again,
+		 * we must set the empty_count check value bigger than 5 to
+		 * make it work. Otherwise, in some situation,
+		 * the interrupt line may unable to reactive again,
+		 * which will cause trackpad device unable to
+		 * report data any more.
+		 * for example, it may happen in EFT and ESD testing.
+		 */
+		if (empty_count > 5)
+			return 0;
+
+		ret = cyapa_i2c_pip_read(cyapa, gen5_pip->empty_buf,
+				GEN5_RESP_LENGTH_SIZE);
+		if (ret < 0)
+			return ret;
+
+		length = get_unaligned_le16(gen5_pip->empty_buf);
+		if (length == GEN5_RESP_LENGTH_SIZE) {
+			empty_count++;
+			continue;
+		} else if (length > CYAPA_REG_MAP_SIZE) {
+			/* Should not happen */
+			return -EINVAL;
+		} else if (length == 0) {
+			/* Application or bootloader launch data polled out. */
+			length = GEN5_RESP_LENGTH_SIZE;
+			if (buf && buf_len && func &&
+				func(cyapa, gen5_pip->empty_buf, length)) {
+				length = min(buf_len, length);
+				memcpy(buf, gen5_pip->empty_buf, length);
+				*len = length;
+				/* Response found, success. */
+				return 0;
+			}
+			continue;
+		}
+
+		ret = cyapa_i2c_pip_read(cyapa, gen5_pip->empty_buf, length);
+		if (ret < 0)
+			return ret;
+
+		report_count--;
+		empty_count = 0;
+		length = get_unaligned_le16(gen5_pip->empty_buf);
+		if (length <= GEN5_RESP_LENGTH_SIZE)
+			empty_count++;
+		else if (buf && buf_len && func &&
+			func(cyapa, gen5_pip->empty_buf, length)) {
+			length = min(buf_len, length);
+			memcpy(buf, gen5_pip->empty_buf, length);
+			*len = length;
+			/* Response found, success. */
+			return 0;
+		}
+
+		ret = -EINVAL;
+	} while (report_count);
+
+	return ret;
+}
+
+static int cyapa_do_i2c_pip_cmd_irq_sync(
+		struct cyapa *cyapa,
+		u8 *cmd, size_t cmd_len,
+		unsigned long timeout)
+{
+	int ret;
+
+	/* Wait for interrupt to set ready completion */
+	init_completion(&gen5_pip->cmd_ready);
+
+	atomic_inc(&gen5_pip->cmd_issued);
+	ret = cyapa_i2c_pip_write(cyapa, cmd, cmd_len);
+	if (ret) {
+		atomic_dec(&gen5_pip->cmd_issued);
+		return (ret < 0) ? ret : -EIO;
+	}
+
+	/* Wait for interrupt to indicate command is completed. */
+	timeout = wait_for_completion_timeout(&gen5_pip->cmd_ready,
+				msecs_to_jiffies(timeout));
+	if (timeout == 0) {
+		atomic_dec(&gen5_pip->cmd_issued);
+		return -ETIMEDOUT;
+	}
+	return 0;
+}
+
+static int cyapa_i2c_pip_cmd_irq_sync(
+		struct cyapa *cyapa,
+		u8 *cmd, int cmd_len,
+		u8 *resp_data, int *resp_len,
+		unsigned long timeout,
+		cb_sort func)
+{
+	int ret;
+	int tries;
+	int length;
+
+	if (!cmd || !cmd_len)
+		return -EINVAL;
+
+	/* Commands must be serialized. */
+	mutex_lock(&gen5_pip->cmd_lock);
+
+	gen5_pip->resp_sort_func = func;
+	gen5_pip->resp_data = resp_data;
+	gen5_pip->resp_len = resp_len;
+
+	if (cmd_len >= GEN5_MIN_APP_CMD_LENGTH &&
+			cmd[4] == GEN5_APP_CMD_REPORT_ID) {
+		/* Application command */
+		gen5_pip->in_progress_cmd = cmd[6] & 0x7f;
+	} else if (cmd_len >= GEN5_MIN_BL_CMD_LENGTH &&
+			cmd[4] == GEN5_BL_CMD_REPORT_ID) {
+		/* Bootloader command */
+		gen5_pip->in_progress_cmd = cmd[7];
+	}
+
+	/* Send command data, wait and read output response data's length. */
+	if (!cyapa->suspended) {
+		ret = cyapa_do_i2c_pip_cmd_irq_sync(cyapa, cmd, cmd_len,
+							timeout);
+		if (ret == -ETIMEDOUT && resp_data &&
+				resp_len && *resp_len != 0 && func) {
+			/*
+			 * For some old version with some unknown reasons,
+			 * there was no interrupt for the command response data,
+			 * so need to poll here to try to get the response data.
+			 */
+			ret = cyapa_empty_pip_output_data(cyapa,
+					resp_data, resp_len, func);
+			if (ret || *resp_len == 0)
+				ret = ret ? ret : -ETIMEDOUT;
+		}
+	} else {
+		ret = cyapa_i2c_pip_write(cyapa, cmd, cmd_len);
+		if (ret) {
+			ret = ret < 0 ? ret : -EIO;
+			goto out;
+		}
+
+		tries = timeout / 5;
+		length = *resp_len;
+		if (resp_data && resp_len && length != 0 && func) {
+			do {
+				usleep_range(3000, 5000);
+				*resp_len = length;
+				ret = cyapa_empty_pip_output_data(cyapa,
+						resp_data, resp_len, func);
+				if (ret || *resp_len == 0)
+					continue;
+				else
+					break;
+			} while (--tries > 0);
+			if ((ret || *resp_len == 0) || tries <= 0)
+				ret = ret ? ret : -ETIMEDOUT;
+		}
+	}
+
+out:
+	gen5_pip->resp_sort_func = NULL;
+	gen5_pip->resp_data = NULL;
+	gen5_pip->resp_len = NULL;
+	gen5_pip->in_progress_cmd = TSG_INVALID_CMD;
+
+	mutex_unlock(&gen5_pip->cmd_lock);
+	return ret;
+}
+
+bool cyapa_gen5_sort_tsg_pip_bl_resp_data(struct cyapa *cyapa,
+		u8 *data, int len)
+{
+	if (!data || len < GEN5_MIN_BL_RESP_LENGTH)
+		return false;
+
+	/* Bootloader input report id 30h */
+	if (data[GEN5_RESP_REPORT_ID_OFFSET] == GEN5_BL_RESP_REPORT_ID &&
+			data[GEN5_RESP_RSVD_OFFSET] == GEN5_RESP_RSVD_KEY &&
+			data[GEN5_RESP_BL_SOP_OFFSET] == GEN5_SOP_KEY)
+		return true;
+
+	return false;
+}
+
+bool cyapa_gen5_sort_tsg_pip_app_resp_data(struct cyapa *cyapa,
+		u8 *data, int len)
+{
+	int resp_len;
+
+	if (!data || len < GEN5_MIN_APP_RESP_LENGTH)
+		return false;
+
+	if (data[GEN5_RESP_REPORT_ID_OFFSET] == GEN5_APP_RESP_REPORT_ID &&
+			data[GEN5_RESP_RSVD_OFFSET] == GEN5_RESP_RSVD_KEY) {
+		resp_len = get_unaligned_le16(&data[GEN5_RESP_LENGTH_OFFSET]);
+		if (GET_GEN5_CMD_CODE(data[GEN5_RESP_APP_CMD_OFFSET]) == 0x00 &&
+			resp_len == GEN5_UNSUPPORTED_CMD_RESP_LENGTH &&
+			data[5] == gen5_pip->in_progress_cmd) {
+			/* Unsupported command code */
+			return false;
+		} else if (GET_GEN5_CMD_CODE(data[GEN5_RESP_APP_CMD_OFFSET]) ==
+				gen5_pip->in_progress_cmd) {
+			/* Correct command response received */
+			return true;
+		}
+	}
+
+	return false;
+}
+
+bool cyapa_gen5_sort_application_launch_data(struct cyapa *cyapa,
+		u8 *buf, int len)
+{
+	if (buf == NULL || len < GEN5_RESP_LENGTH_SIZE)
+		return false;
+
+	/*
+	 * After reset or power on, trackpad device always sets to 0x00 0x00
+	 * to indicate a reset or power on event.
+	 */
+	if (buf[0] == 0 && buf[1] == 0)
+		return true;
+
+	return false;
+}
+
+static bool cyapa_gen5_sort_hid_descriptor_data(struct cyapa *cyapa,
+		u8 *buf, int len)
+{
+	int resp_len;
+	int max_output_len;
+
+	/* Check hid descriptor. */
+	if (len != GEN5_HID_DESCRIPTOR_SIZE)
+		return false;
+
+	resp_len = get_unaligned_le16(&buf[GEN5_RESP_LENGTH_OFFSET]);
+	max_output_len = get_unaligned_le16(&buf[16]);
+	if (resp_len == GEN5_HID_DESCRIPTOR_SIZE) {
+		if (buf[GEN5_RESP_REPORT_ID_OFFSET] == GEN5_BL_HID_REPORT_ID &&
+				max_output_len == GEN5_BL_MAX_OUTPUT_LENGTH) {
+			/* BL mode HID Descriptor */
+			return true;
+		} else if (buf[2] == GEN5_APP_HID_REPORT_ID &&
+				max_output_len == GEN5_APP_MAX_OUTPUT_LENGTH) {
+			/* APP mode HID Descriptor */
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool cyapa_gen5_sort_deep_sleep_data(struct cyapa *cyapa,
+		u8 *buf, int len)
+{
+	if (len == GEN5_DEEP_SLEEP_RESP_LENGTH &&
+		buf[GEN5_RESP_REPORT_ID_OFFSET] ==
+			GEN5_APP_DEEP_SLEEP_REPORT_ID &&
+		(buf[4] & GEN5_DEEP_SLEEP_OPCODE_MASK) ==
+			GEN5_DEEP_SLEEP_OPCODE)
+		return true;
+	return false;
+}
+
+static int gen5_idle_state_parse(struct cyapa *cyapa)
+{
+	int ret;
+	int length;
+	u8 cmd[2];
+	u8 resp_data[32];
+	int max_output_len;
+
+	/*
+	 * Dump all buffered data firstly for the situation
+	 * when the trackpad is just power on the cyapa go here.
+	 */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	memset(resp_data, 0, sizeof(resp_data));
+	ret = cyapa_i2c_pip_read(cyapa, resp_data, 3);
+	if (ret != 3)
+		return ret < 0 ? ret : -EIO;
+
+	length = get_unaligned_le16(&resp_data[GEN5_RESP_LENGTH_OFFSET]);
+	if (length == GEN5_RESP_LENGTH_SIZE) {
+		/* Normal state of Gen5 with no data to respose */
+		cyapa->gen = CYAPA_GEN5;
+
+		cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+		/* Read description from trackpad device */
+		cmd[0] = 0x01;
+		cmd[1] = 0x00;
+		length = GEN5_HID_DESCRIPTOR_SIZE;
+		ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+				cmd, GEN5_RESP_LENGTH_SIZE,
+				resp_data, &length,
+				300,
+				cyapa_gen5_sort_hid_descriptor_data);
+		if (ret)
+			return ret;
+
+		length = get_unaligned_le16(
+				&resp_data[GEN5_RESP_LENGTH_OFFSET]);
+		max_output_len = get_unaligned_le16(&resp_data[16]);
+		if ((length == GEN5_HID_DESCRIPTOR_SIZE ||
+				length == GEN5_RESP_LENGTH_SIZE) &&
+			(resp_data[GEN5_RESP_REPORT_ID_OFFSET] ==
+				GEN5_BL_HID_REPORT_ID) &&
+			max_output_len == GEN5_BL_MAX_OUTPUT_LENGTH) {
+			/* BL mode HID Description read */
+			cyapa->state = CYAPA_STATE_GEN5_BL;
+		} else if ((length == GEN5_HID_DESCRIPTOR_SIZE ||
+				length == GEN5_RESP_LENGTH_SIZE) &&
+			(resp_data[GEN5_RESP_REPORT_ID_OFFSET] ==
+				GEN5_APP_HID_REPORT_ID) &&
+			max_output_len == GEN5_APP_MAX_OUTPUT_LENGTH) {
+			/* APP mode HID Description read */
+			cyapa->state = CYAPA_STATE_GEN5_APP;
+		} else {
+			/* Should not happen!!! */
+			cyapa->state = CYAPA_STATE_NO_DEVICE;
+		}
+	}
+
+	return 0;
+}
+
+static int gen5_hid_description_header_parse(struct cyapa *cyapa, u8 *reg_data)
+{
+	int ret;
+	int length;
+	u8 resp_data[32];
+	int max_output_len;
+
+	/* 0x20 0x00 0xF7 is Gen5 Application HID Description Header;
+	 * 0x20 0x00 0xFF is Gen5 Booloader HID Description Header.
+	 *
+	 * Must read HID Description content through out,
+	 * otherwise Gen5 trackpad cannot reponse next command
+	 * or report any touch or button data.
+	 */
+	ret = cyapa_i2c_pip_read(cyapa, resp_data,
+			GEN5_HID_DESCRIPTOR_SIZE);
+	if (ret != GEN5_HID_DESCRIPTOR_SIZE)
+		return ret < 0 ? ret : -EIO;
+	length = get_unaligned_le16(&resp_data[GEN5_RESP_LENGTH_OFFSET]);
+	max_output_len = get_unaligned_le16(&resp_data[16]);
+	if (length == GEN5_RESP_LENGTH_SIZE) {
+		if (reg_data[GEN5_RESP_REPORT_ID_OFFSET] ==
+				GEN5_BL_HID_REPORT_ID) {
+			/*
+			 * BL mode HID Description has been previously
+			 * read out.
+			 */
+			cyapa->gen = CYAPA_GEN5;
+			cyapa->state = CYAPA_STATE_GEN5_BL;
+		} else {
+			/*
+			 * APP mode HID Description has been previously
+			 * read out.
+			 */
+			cyapa->gen = CYAPA_GEN5;
+			cyapa->state = CYAPA_STATE_GEN5_APP;
+		}
+	} else if (length == GEN5_HID_DESCRIPTOR_SIZE &&
+			resp_data[2] == GEN5_BL_HID_REPORT_ID &&
+			max_output_len == GEN5_BL_MAX_OUTPUT_LENGTH) {
+		/* BL mode HID Description read. */
+		cyapa->gen = CYAPA_GEN5;
+		cyapa->state = CYAPA_STATE_GEN5_BL;
+	} else if (length == GEN5_HID_DESCRIPTOR_SIZE &&
+			(resp_data[GEN5_RESP_REPORT_ID_OFFSET] ==
+				GEN5_APP_HID_REPORT_ID) &&
+			max_output_len == GEN5_APP_MAX_OUTPUT_LENGTH) {
+		/* APP mode HID Description read. */
+		cyapa->gen = CYAPA_GEN5;
+		cyapa->state = CYAPA_STATE_GEN5_APP;
+	} else {
+		/* Should not happen!!! */
+		cyapa->state = CYAPA_STATE_NO_DEVICE;
+	}
+
+	return 0;
+}
+
+static int gen5_report_data_header_parse(struct cyapa *cyapa, u8 *reg_data)
+{
+	int length;
+
+	length = get_unaligned_le16(&reg_data[GEN5_RESP_LENGTH_OFFSET]);
+	switch (reg_data[GEN5_RESP_REPORT_ID_OFFSET]) {
+	case GEN5_TOUCH_REPORT_ID:
+		if (length < GEN5_TOUCH_REPORT_HEAD_SIZE ||
+			length > GEN5_TOUCH_REPORT_MAX_SIZE)
+			return -EINVAL;
+		break;
+	case GEN5_BTN_REPORT_ID:
+	case GEN5_OLD_PUSH_BTN_REPORT_ID:
+	case GEN5_PUSH_BTN_REPORT_ID:
+		if (length < GEN5_BTN_REPORT_HEAD_SIZE ||
+			length > GEN5_BTN_REPORT_MAX_SIZE)
+			return -EINVAL;
+		break;
+	case GEN5_WAKEUP_EVENT_REPORT_ID:
+		if (length != GEN5_WAKEUP_EVENT_SIZE)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	cyapa->gen = CYAPA_GEN5;
+	cyapa->state = CYAPA_STATE_GEN5_APP;
+	return 0;
+}
+
+static int gen5_cmd_resp_header_parse(struct cyapa *cyapa, u8 *reg_data)
+{
+	int ret;
+	int length;
+
+	/*
+	 * Must read report data through out,
+	 * otherwise Gen5 trackpad cannot reponse next command
+	 * or report any touch or button data.
+	 */
+	length = get_unaligned_le16(&reg_data[GEN5_RESP_LENGTH_OFFSET]);
+	ret = cyapa_i2c_pip_read(cyapa, gen5_pip->empty_buf, length);
+	if (ret != length)
+		return ret < 0 ? ret : -EIO;
+
+	if (length == GEN5_RESP_LENGTH_SIZE) {
+		/* Previous command has read the data through out. */
+		if (reg_data[GEN5_RESP_REPORT_ID_OFFSET] ==
+				GEN5_BL_RESP_REPORT_ID) {
+			/* Gen5 BL command response data detected */
+			cyapa->gen = CYAPA_GEN5;
+			cyapa->state = CYAPA_STATE_GEN5_BL;
+		} else {
+			/* Gen5 APP command response data detected */
+			cyapa->gen = CYAPA_GEN5;
+			cyapa->state = CYAPA_STATE_GEN5_APP;
+		}
+	} else if ((gen5_pip->empty_buf[GEN5_RESP_REPORT_ID_OFFSET] ==
+				GEN5_BL_RESP_REPORT_ID) &&
+			(gen5_pip->empty_buf[GEN5_RESP_RSVD_OFFSET] ==
+				GEN5_RESP_RSVD_KEY) &&
+			(gen5_pip->empty_buf[GEN5_RESP_BL_SOP_OFFSET] ==
+				GEN5_SOP_KEY) &&
+			(gen5_pip->empty_buf[length - 1] ==
+				GEN5_EOP_KEY)) {
+		/* Gen5 BL command response data detected */
+		cyapa->gen = CYAPA_GEN5;
+		cyapa->state = CYAPA_STATE_GEN5_BL;
+	} else if (gen5_pip->empty_buf[GEN5_RESP_REPORT_ID_OFFSET] ==
+				GEN5_APP_RESP_REPORT_ID &&
+			gen5_pip->empty_buf[GEN5_RESP_RSVD_OFFSET] ==
+				GEN5_RESP_RSVD_KEY) {
+		/* Gen5 APP command response data detected */
+		cyapa->gen = CYAPA_GEN5;
+		cyapa->state = CYAPA_STATE_GEN5_APP;
+	} else {
+		/* Should not happen!!! */
+		cyapa->state = CYAPA_STATE_NO_DEVICE;
+	}
+
+	return 0;
+}
+
+static int cyapa_gen5_state_parse(struct cyapa *cyapa, u8 *reg_data, int len)
+{
+	int length;
+
+	if (!reg_data || len < 3)
+		return -EINVAL;
+
+	/*
+	 * Try to dump all bufferred data if it's known gen5 trackpad
+	 * before detecting. Because the irq routine may disabled
+	 * before enter this routine.
+	 */
+	if (cyapa->gen == CYAPA_GEN5)
+		cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+	cyapa->state = CYAPA_STATE_NO_DEVICE;
+
+	/* Parse based on Gen5 characteristic registers and bits */
+	length = get_unaligned_le16(&reg_data[GEN5_RESP_LENGTH_OFFSET]);
+	if (length == 0 || length == GEN5_RESP_LENGTH_SIZE)
+		gen5_idle_state_parse(cyapa);
+	else if (length == GEN5_HID_DESCRIPTOR_SIZE &&
+			(reg_data[2] == GEN5_BL_HID_REPORT_ID ||
+				reg_data[2] == GEN5_APP_HID_REPORT_ID))
+		gen5_hid_description_header_parse(cyapa, reg_data);
+	else if ((length == GEN5_APP_REPORT_DESCRIPTOR_SIZE ||
+			length == GEN5_APP_CONTRACT_REPORT_DESCRIPTOR_SIZE) &&
+			reg_data[2] == GEN5_APP_REPORT_DESCRIPTOR_ID) {
+		/* 0xEE 0x00 0xF6 is Gen5 APP Report Description header. */
+		cyapa->gen = CYAPA_GEN5;
+		cyapa->state = CYAPA_STATE_GEN5_APP;
+	} else if (length == GEN5_BL_REPORT_DESCRIPTOR_SIZE &&
+			reg_data[2] == GEN5_BL_REPORT_DESCRIPTOR_ID) {
+		/* 0x1D 0x00 0xFE is Gen5 BL Report Descriptior header. */
+		cyapa->gen = CYAPA_GEN5;
+		cyapa->state = CYAPA_STATE_GEN5_BL;
+	} else if (reg_data[2] == GEN5_TOUCH_REPORT_ID ||
+			reg_data[2] == GEN5_BTN_REPORT_ID ||
+			reg_data[2] == GEN5_OLD_PUSH_BTN_REPORT_ID ||
+			reg_data[2] == GEN5_PUSH_BTN_REPORT_ID ||
+			reg_data[2] == GEN5_WAKEUP_EVENT_REPORT_ID)
+		gen5_report_data_header_parse(cyapa, reg_data);
+	else if (reg_data[2] == GEN5_BL_RESP_REPORT_ID ||
+			reg_data[2] == GEN5_APP_RESP_REPORT_ID)
+		gen5_cmd_resp_header_parse(cyapa, reg_data);
+
+	if (cyapa->gen == CYAPA_GEN5 && (cyapa->state == CYAPA_STATE_GEN5_APP ||
+			cyapa->state == CYAPA_STATE_GEN5_BL)) {
+		/*
+		 * Must read the content (e.g.: Report Description and so on)
+		 * from trackpad device through out. Otherwise,
+		 * Gen5 trackpad cannot reponse to next command or
+		 * report any touch or button data later.
+		 */
+		cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+		return 0;
+	}
+	return -EAGAIN;
+}
+
+bool cyapa_gen5_sort_bl_exit_data(struct cyapa *cyapa, u8 *buf, int len)
+{
+	if (buf == NULL || len < GEN5_RESP_LENGTH_SIZE)
+		return false;
+
+	if (buf[0] == 0 && buf[1] == 0)
+		return true;
+
+	/* Exit bootloader failed for some reason. */
+	if (len == GEN5_BL_FAIL_EXIT_RESP_LEN &&
+			buf[GEN5_RESP_REPORT_ID_OFFSET] ==
+				GEN5_BL_RESP_REPORT_ID &&
+			buf[GEN5_RESP_RSVD_OFFSET] == GEN5_RESP_RSVD_KEY &&
+			buf[GEN5_RESP_BL_SOP_OFFSET] == GEN5_SOP_KEY &&
+			buf[10] == GEN5_EOP_KEY)
+		return true;
+
+	return false;
+}
+static int cyapa_gen5_bl_exit(struct cyapa *cyapa)
+{
+	int ret;
+	u8 resp_data[11];
+	int resp_len;
+	u8 bl_gen5_bl_exit[] = { 0x04, 0x00,
+		0x0B, 0x00, 0x40, 0x00, 0x01, 0x3b, 0x00, 0x00,
+		0x20, 0xc7, 0x17
+	};
+
+	resp_len = sizeof(resp_data);
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			bl_gen5_bl_exit, sizeof(bl_gen5_bl_exit),
+			resp_data, &resp_len,
+			5000, cyapa_gen5_sort_bl_exit_data);
+	if (ret)
+		return ret;
+
+	if (resp_len == GEN5_BL_FAIL_EXIT_RESP_LEN ||
+			resp_data[GEN5_RESP_REPORT_ID_OFFSET] ==
+				GEN5_BL_RESP_REPORT_ID)
+		return -EAGAIN;
+
+	if (resp_data[0] == 0x00 && resp_data[1] == 0x00)
+		return 0;
+
+	return -EAGAIN;
+}
+
+static int cyapa_gen5_change_power_state(struct cyapa *cyapa, u8 power_state)
+{
+	int ret;
+	u8 cmd[8] = { 0x04, 0x00, 0x06, 0x00, 0x2f, 0x00, 0x08, 0x01 };
+	u8 resp_data[6];
+	int resp_len;
+
+	cmd[7] = power_state;
+	resp_len = sizeof(resp_data);
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, sizeof(cmd),
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+	if (ret || !VALID_CMD_RESP_HEADER(resp_data, 0x08) ||
+			!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+		return ret < 0 ? ret : -EINVAL;
+
+	return 0;
+}
+
+static int cyapa_gen5_set_interval_time(struct cyapa *cyapa,
+		u8 parameter_id, u16 interval_time)
+{
+	int ret;
+	u8 cmd[13];
+	int cmd_len;
+	u8 resp_data[7];
+	int resp_len;
+	u8 parameter_size;
+
+	switch (parameter_id) {
+	case GEN5_PARAMETER_ACT_INTERVL_ID:
+		parameter_size = GEN5_PARAMETER_ACT_INTERVL_SIZE;
+		break;
+	case GEN5_PARAMETER_ACT_LFT_INTERVL_ID:
+		parameter_size = GEN5_PARAMETER_ACT_LFT_INTERVL_SIZE;
+		break;
+	case GEN5_PARAMETER_LP_INTRVL_ID:
+		parameter_size = GEN5_PARAMETER_LP_INTRVL_SIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+	cmd_len = 7 + parameter_size;  /* Not incuding 2 bytes address */
+	cmd[0] = 0x04;
+	cmd[1] = 0x00;
+	put_unaligned_le16(cmd_len, &cmd[2]);
+	cmd[4] = 0x2f;
+	cmd[5] = 0x00;
+	cmd[6] = 0x06; /* Set parameter command code */
+	cmd[7] = parameter_id;
+	cmd[8] = parameter_size;
+	put_unaligned_le16(interval_time, &cmd[9]);
+	resp_len = sizeof(resp_data);
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, cmd_len + 2,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+	if (ret || !VALID_CMD_RESP_HEADER(resp_data, 0x06) ||
+			resp_data[5] != parameter_id ||
+			resp_data[6] != parameter_size)
+		return ret < 0 ? ret : -EINVAL;
+
+	return 0;
+}
+
+static int cyapa_gen5_get_interval_time(struct cyapa *cyapa,
+		u8 parameter_id, u16 *interval_time)
+{
+	int ret;
+	u8 cmd[8];
+	u8 resp_data[11];
+	int resp_len;
+	u8 parameter_size;
+	u16 mask, i;
+
+	*interval_time = 0;
+	switch (parameter_id) {
+	case GEN5_PARAMETER_ACT_INTERVL_ID:
+		parameter_size = GEN5_PARAMETER_ACT_INTERVL_SIZE;
+		break;
+	case GEN5_PARAMETER_ACT_LFT_INTERVL_ID:
+		parameter_size = GEN5_PARAMETER_ACT_LFT_INTERVL_SIZE;
+		break;
+	case GEN5_PARAMETER_LP_INTRVL_ID:
+		parameter_size = GEN5_PARAMETER_LP_INTRVL_SIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	cmd[0] = 0x04;
+	cmd[1] = 0x00;
+	cmd[2] = 0x06;
+	cmd[3] = 0x00;
+	cmd[4] = 0x2f;
+	cmd[5] = 0x00;
+	cmd[6] = 0x05; /* Get parameter command code */
+	cmd[7] = parameter_id;
+	resp_len = sizeof(resp_data);
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, sizeof(cmd),
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+	if (ret || !VALID_CMD_RESP_HEADER(resp_data, 0x05) ||
+			resp_data[5] != parameter_id ||
+			resp_data[6] == 0)
+		return ret < 0 ? ret : -EINVAL;
+
+	mask = 0;
+	for (i = 0; i < parameter_size; i++)
+		mask |= (0xff << (i * 8));
+	*interval_time = get_unaligned_le16(&resp_data[7]) & mask;
+
+	return 0;
+}
+
+static int cyapa_gen5_disable_pip_report(struct cyapa *cyapa)
+{
+	int ret;
+	u8 cmd[10];
+	u8 resp_data[7];
+	int resp_len;
+
+	cmd[0] = 0x04;
+	cmd[1] = 0x00;
+	put_unaligned_le16(8, &cmd[2]);
+	cmd[4] = 0x2f;
+	cmd[5] = 0x00;
+	cmd[6] = 0x06; /* Set parameter command code */
+	cmd[7] = GEN5_PARAMETER_DISABLE_PIP_REPORT;
+	cmd[8] = 0x01;
+	cmd[9] = 0x01;
+	resp_len = sizeof(resp_data);
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, 10,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+	if (ret || !VALID_CMD_RESP_HEADER(resp_data, 0x06) ||
+			resp_data[5] != GEN5_PARAMETER_DISABLE_PIP_REPORT ||
+			resp_data[6] != 0x01)
+		return ret < 0 ? ret : -EINVAL;
+
+	return 0;
+}
+
+static int cyapa_gen5_deep_sleep(struct cyapa *cyapa, u8 state)
+{
+	int ret;
+	u8 cmd[4] = { 0x05, 0x00, 0x00, 0x08};
+	u8 resp_data[5];
+	int resp_len;
+
+	cmd[0] = 0x05;
+	cmd[1] = 0x00;
+	cmd[2] = state & GEN5_DEEP_SLEEP_STATE_MASK;
+	cmd[3] = 0x08;
+	resp_len = sizeof(resp_data);
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa, cmd, sizeof(cmd),
+			resp_data, &resp_len,
+			100, cyapa_gen5_sort_deep_sleep_data);
+	if (ret || ((resp_data[3] & GEN5_DEEP_SLEEP_STATE_MASK) != state))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int cyapa_gen5_set_power_mode(struct cyapa *cyapa,
+		u8 power_mode, u16 sleep_time)
+{
+	struct device *dev = &cyapa->client->dev;
+	int ret;
+	u8 power_state;
+
+	if (cyapa->state != CYAPA_STATE_GEN5_APP)
+		return 0;
+
+	/* Dump all the report data before do power mode commmands. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	if (GEN5_POWER_STATE() != PWR_MODE_OFF &&
+			GEN5_UNINIT_SLEEP_TIME(gen5_sleep_time)) {
+		if (cyapa_gen5_get_interval_time(cyapa,
+				GEN5_PARAMETER_LP_INTRVL_ID,
+				&gen5_sleep_time) != 0)
+			gen5_sleep_time = UNINIT_SLEEP_TIME;
+	}
+
+	switch (power_mode) {
+	case PWR_MODE_OFF:
+	case PWR_MODE_FULL_ACTIVE:
+	case PWR_MODE_BTN_ONLY:
+		/* Has in correct power mode state, early return. */
+		if (GEN5_POWER_STATE() == power_mode)
+			return 0;
+
+		/* Enter deep sleep directly without any additional steps. */
+		if (power_mode == PWR_MODE_OFF) {
+			ret = cyapa_gen5_deep_sleep(cyapa,
+				GEN5_DEEP_SLEEP_STATE_OFF);
+			if (ret) {
+				dev_err(dev, "enter deep sleep fail, (%d)\n",
+					ret);
+				return ret;
+			}
+
+			SET_GEN5_POWER_STATE(power_mode);
+			return 0;
+		}
+	default:
+		/* Has in correct power mode state, early return. */
+		if (gen5_sleep_time == sleep_time &&
+			GEN5_POWER_STATE() == power_mode)
+			return 0;
+	}
+
+	/*
+	 * When trackpad in power off mode, it cannot change to other power
+	 * state directly, must be wake up from sleep firstly, then
+	 * continue to do next power sate change.
+	 */
+	if (GEN5_POWER_STATE() == PWR_MODE_OFF) {
+		ret = cyapa_gen5_deep_sleep(cyapa, GEN5_DEEP_SLEEP_STATE_ON);
+		if (ret) {
+			dev_err(dev, "deep sleep wake fail, (%d)\n", ret);
+			return ret;
+		}
+	}
+
+	if (power_mode == PWR_MODE_FULL_ACTIVE) {
+		ret = cyapa_gen5_change_power_state(cyapa,
+				GEN5_POWER_STATE_ACTIVE);
+		if (ret) {
+			dev_err(dev, "change to active fail, (%d)\n", ret);
+			return ret;
+		}
+
+		SET_GEN5_POWER_STATE(PWR_MODE_FULL_ACTIVE);
+	} else if (power_mode == PWR_MODE_BTN_ONLY) {
+		ret = cyapa_gen5_change_power_state(cyapa,
+				GEN5_POWER_STATE_BTN_ONLY);
+		if (ret) {
+			dev_err(dev, "fail change to active, (%d)\n", ret);
+			return ret;
+		}
+
+		SET_GEN5_POWER_STATE(PWR_MODE_BTN_ONLY);
+	} else {
+		/*
+		 * Continue to change power mode even failed to set
+		 * interval time, it won't affect the power mode change.
+		 * except the sleep interval time is not correct.
+		 */
+		if (GEN5_UNINIT_SLEEP_TIME(gen5_sleep_time) ||
+				sleep_time != gen5_sleep_time)
+			if (cyapa_gen5_set_interval_time(cyapa,
+				GEN5_PARAMETER_LP_INTRVL_ID, sleep_time) == 0)
+					gen5_sleep_time = sleep_time;
+
+		if (sleep_time <= GEN5_POWER_READY_MAX_INTRVL_TIME)
+			power_state = GEN5_POWER_STATE_READY;
+		else
+			power_state = GEN5_POWER_STATE_IDLE;
+		ret = cyapa_gen5_change_power_state(cyapa, power_state);
+		if (ret) {
+			dev_err(dev, "set power state %d fail, (%d)\n",
+				power_state, ret);
+			return ret;
+		}
+
+		/*
+		 * Disable pip report for a little time, firmware will
+		 * re-enable it automatically. It's used to fix the issue
+		 * that trackpad unable to report signal to wake system up
+		 * in the special situation that system is in suspending, and
+		 * at the same time, user touch trackpad to wake system up.
+		 * This function can avoid the data to be buffured when system
+		 * is suspending which may cause interrput line unable to be
+		 * asserted again.
+		 */
+		cyapa_gen5_disable_pip_report(cyapa);
+
+		SET_GEN5_POWER_STATE(cyapa_sleep_time_to_pwr_cmd(sleep_time));
+	}
+
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+	return ret;
+}
+
+static bool cyapa_gen5_sort_system_info_data(struct cyapa *cyapa,
+		u8 *buf, int len)
+{
+	/* Check the report id and command code */
+	if (VALID_CMD_RESP_HEADER(buf, 0x02))
+		return true;
+
+	return false;
+}
+
+static int cyapa_gen5_bl_query_data(struct cyapa *cyapa)
+{
+	int ret;
+	u8 cmd[16];
+	int cmd_len;
+	u8 resp_data[GEN5_BL_READ_APP_INFO_RESP_LEN];
+	int resp_len;
+
+	/* Read application information. */
+	cmd[0] = 0x04;
+	cmd[1] = 0x00;
+	cmd[2] = 0x0b;
+	cmd[3] = 0x00;
+	cmd[4] = 0x40;
+	cmd[5] = 0x00;
+	cmd[6] = GEN5_SOP_KEY;
+	cmd[7] = 0x3c;  /* Read application information command code */
+	cmd[8] = 0x00;
+	cmd[9] = 0x00;
+	cmd[10] = 0xb0;
+	cmd[11] = 0x42;
+	cmd[12] = GEN5_EOP_KEY;
+	cmd_len = 13;
+	resp_len = GEN5_BL_READ_APP_INFO_RESP_LEN;
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, cmd_len,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_bl_resp_data);
+	if (ret || resp_len != GEN5_BL_READ_APP_INFO_RESP_LEN ||
+		!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+		return ret < 0 ? ret : -EIO;
+
+	memcpy(&cyapa->product_id[0], &resp_data[8], 5);
+	cyapa->product_id[5] = '-';
+	memcpy(&cyapa->product_id[6], &resp_data[13], 6);
+	cyapa->product_id[12] = '-';
+	memcpy(&cyapa->product_id[13], &resp_data[19], 2);
+	cyapa->product_id[15] = '\0';
+
+	cyapa->fw_maj_ver = resp_data[22];
+	cyapa->fw_min_ver = resp_data[23];
+
+	return 0;
+}
+
+static int cyapa_gen5_get_query_data(struct cyapa *cyapa)
+{
+	int ret;
+	u8 resp_data[71];
+	int resp_len;
+	u8 get_system_information[] = {
+		0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x02
+	};
+	u16 product_family;
+
+	resp_len = sizeof(resp_data);
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			get_system_information, sizeof(get_system_information),
+			resp_data, &resp_len,
+			2000, cyapa_gen5_sort_system_info_data);
+	if (ret || resp_len < sizeof(resp_data))
+		return ret;
+
+	gen5_fw_img_head.head_size =
+		sizeof(struct cyapa_tsg_bin_image_head) - 1;
+	memcpy(&gen5_fw_img_head.ttda_driver_major_version,
+		&resp_data[5], gen5_fw_img_head.head_size);
+
+	product_family = get_unaligned_le16(&resp_data[7]);
+	if ((product_family & GEN5_PRODUCT_FAMILY_MASK) !=
+		GEN5_PRODUCT_FAMILY_TRACKPAD)
+		return -EINVAL;
+
+	cyapa->fw_maj_ver = resp_data[15];
+	cyapa->fw_min_ver = resp_data[16];
+
+	cyapa->electrodes_x = resp_data[52];
+	cyapa->electrodes_y = resp_data[53];
+
+	cyapa->physical_size_x =  get_unaligned_le16(&resp_data[54]) / 100;
+	cyapa->physical_size_y = get_unaligned_le16(&resp_data[56]) / 100;
+
+	cyapa->max_abs_x = get_unaligned_le16(&resp_data[58]);
+	cyapa->max_abs_y = get_unaligned_le16(&resp_data[60]);
+
+	cyapa->max_z = get_unaligned_le16(&resp_data[62]);
+
+	cyapa->x_origin = resp_data[64] & 0x01;
+	cyapa->y_origin = resp_data[65] & 0x01;
+
+	cyapa->btn_capability = (resp_data[70] << 3) & CAPABILITY_BTN_MASK;
+
+	memcpy(&cyapa->product_id[0], &resp_data[33], 5);
+	cyapa->product_id[5] = '-';
+	memcpy(&cyapa->product_id[6], &resp_data[38], 6);
+	cyapa->product_id[12] = '-';
+	memcpy(&cyapa->product_id[13], &resp_data[44], 2);
+	cyapa->product_id[15] = '\0';
+
+	if (!cyapa->electrodes_x || !cyapa->electrodes_y ||
+		!cyapa->physical_size_x || !cyapa->physical_size_y ||
+		!cyapa->max_abs_x || !cyapa->max_abs_y || !cyapa->max_z)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int cyapa_gen5_do_operational_check(struct cyapa *cyapa)
+{
+	struct device *dev = &cyapa->client->dev;
+	int ret;
+
+	if (cyapa->gen != CYAPA_GEN5)
+		return -EINVAL;
+
+	switch (cyapa->state) {
+	case CYAPA_STATE_GEN5_BL:
+		ret = cyapa_gen5_bl_exit(cyapa);
+		if (ret) {
+			/* Rry to update trackpad product information. */
+			cyapa_gen5_bl_query_data(cyapa);
+			goto out;
+		}
+
+		cyapa->state = CYAPA_STATE_GEN5_APP;
+
+	case CYAPA_STATE_GEN5_APP:
+		/*
+		 * If trackpad device in deep sleep mode,
+		 * the app command will fail.
+		 * So always reset trackpad device to full active when
+		 * the device state is requeried.
+		 */
+		ret = cyapa_gen5_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE, 0);
+		if (ret)
+			goto out;
+
+		/* Get trackpad product information. */
+		ret = cyapa_gen5_get_query_data(cyapa);
+		if (ret)
+			goto out;
+		/* Only support product ID starting with CYTRA */
+		if (memcmp(cyapa->product_id, unique_str,
+				strlen(unique_str)) != 0) {
+			dev_err(dev, "%s: unknown product ID (%s)\n",
+				__func__, cyapa->product_id);
+			ret = -EINVAL;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+out:
+	return ret;
+}
+
+/*
+ * Return false, do not continue process
+ * Return true, continue process.
+ */
+static bool cyapa_gen5_irq_cmd_handler(struct cyapa *cyapa)
+{
+	int length;
+
+	if (atomic_read(&gen5_pip->cmd_issued)) {
+		/*
+		 * Read out all none command response data.
+		 * these output data may caused by user put finger on
+		 * trackpad when host waiting the command response.
+		 */
+		cyapa_i2c_pip_read(cyapa, gen5_pip->irq_cmd_buf,
+			GEN5_RESP_LENGTH_SIZE);
+		length = get_unaligned_le16(gen5_pip->irq_cmd_buf);
+		length = (length <= GEN5_RESP_LENGTH_SIZE) ?
+				GEN5_RESP_LENGTH_SIZE : length;
+		if (length > GEN5_RESP_LENGTH_SIZE)
+			cyapa_i2c_pip_read(cyapa,
+				gen5_pip->irq_cmd_buf, length);
+		if (!(gen5_pip->resp_sort_func &&
+			gen5_pip->resp_sort_func(cyapa,
+				gen5_pip->irq_cmd_buf, length))) {
+			/*
+			 * Cover the Gen5 V1 firmware issue.
+			 * The issue is there is no interrut will be
+			 * asserted to notityf host to read a command
+			 * data out when always has finger touch on
+			 * trackpad during the command is issued to
+			 * trackad device.
+			 * This issue has the scenario is that,
+			 * user always has his fingers touched on
+			 * trackpad device when booting/rebooting
+			 * their chrome book.
+			 */
+			length = *gen5_pip->resp_len;
+			cyapa_empty_pip_output_data(cyapa,
+					gen5_pip->resp_data,
+					&length,
+					gen5_pip->resp_sort_func);
+			if (gen5_pip->resp_len && length != 0) {
+				*gen5_pip->resp_len = length;
+				atomic_dec(&gen5_pip->cmd_issued);
+				complete(&gen5_pip->cmd_ready);
+			}
+			return false;
+		}
+
+		if (gen5_pip->resp_data && gen5_pip->resp_len) {
+			*gen5_pip->resp_len = (*gen5_pip->resp_len < length) ?
+				*gen5_pip->resp_len : length;
+			memcpy(gen5_pip->resp_data, gen5_pip->irq_cmd_buf,
+				*gen5_pip->resp_len);
+		}
+		atomic_dec(&gen5_pip->cmd_issued);
+		complete(&gen5_pip->cmd_ready);
+		return false;
+	}
+
+	return true;
+}
+
+static void cyapa_gen5_report_buttons(struct cyapa *cyapa,
+		const struct cyapa_gen5_report_data *report_data)
+{
+	struct input_dev *input = cyapa->input;
+	u8 buttons = report_data->report_head[GEN5_BUTTONS_OFFSET];
+
+	buttons = (buttons << CAPABILITY_BTN_SHIFT) & CAPABILITY_BTN_MASK;
+
+	if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK) {
+		input_report_key(input, BTN_LEFT,
+			!!(buttons & CAPABILITY_LEFT_BTN_MASK));
+	}
+	if (cyapa->btn_capability & CAPABILITY_MIDDLE_BTN_MASK) {
+		input_report_key(input, BTN_MIDDLE,
+			!!(buttons & CAPABILITY_MIDDLE_BTN_MASK));
+	}
+	if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK) {
+		input_report_key(input, BTN_RIGHT,
+			!!(buttons & CAPABILITY_RIGHT_BTN_MASK));
+	}
+
+	input_sync(input);
+}
+
+static void cyapa_gen5_report_slot_data(struct cyapa *cyapa,
+		const struct cyapa_gen5_touch_record *touch)
+{
+	struct input_dev *input = cyapa->input;
+	u8 event_id = GEN5_GET_EVENT_ID(touch->touch_tip_event_id);
+	int slot = GEN5_GET_TOUCH_ID(touch->touch_tip_event_id);
+	int x, y;
+
+	if (event_id == RECORD_EVENT_LIFTOFF)
+		return;
+
+	input_mt_slot(input, slot);
+	input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
+	x = (touch->x_hi << 8) | touch->x_lo;
+	if (cyapa->x_origin)
+		x = cyapa->max_abs_x - x;
+	input_report_abs(input, ABS_MT_POSITION_X, x);
+	y = (touch->y_hi << 8) | touch->y_lo;
+	if (cyapa->y_origin)
+		y = cyapa->max_abs_y - y;
+	input_report_abs(input, ABS_MT_POSITION_Y, y);
+	input_report_abs(input, ABS_MT_PRESSURE,
+		touch->z);
+	input_report_abs(input, ABS_MT_TOUCH_MAJOR,
+		touch->major_axis_len);
+	input_report_abs(input, ABS_MT_TOUCH_MINOR,
+		touch->minor_axis_len);
+
+	input_report_abs(input, ABS_MT_WIDTH_MAJOR,
+		touch->major_tool_len);
+	input_report_abs(input, ABS_MT_WIDTH_MINOR,
+		touch->minor_tool_len);
+
+	input_report_abs(input, ABS_MT_ORIENTATION,
+		touch->orientation);
+}
+
+static void cyapa_gen5_report_touches(struct cyapa *cyapa,
+		const struct cyapa_gen5_report_data *report_data)
+{
+	struct input_dev *input = cyapa->input;
+	unsigned int touch_num;
+	int i;
+
+	touch_num = report_data->report_head[GEN5_NUMBER_OF_TOUCH_OFFSET] &
+			GEN5_NUMBER_OF_TOUCH_MASK;
+
+	for (i = 0; i < touch_num; i++)
+		cyapa_gen5_report_slot_data(cyapa,
+			&report_data->touch_records[i]);
+
+	input_mt_sync_frame(input);
+	input_sync(input);
+}
+
+static void cyapa_gen5_irq_handler(struct cyapa *cyapa)
+{
+	struct cyapa_gen5_report_data report_data;
+	int ret;
+	u8 report_id;
+	unsigned int report_len;
+
+	if (cyapa->gen != CYAPA_GEN5 ||
+		cyapa->state != CYAPA_STATE_GEN5_APP) {
+		async_schedule(cyapa_detect_async, cyapa);
+		return;
+	}
+
+	ret = cyapa_i2c_pip_read(cyapa, (u8 *)&report_data,
+			GEN5_TOUCH_REPORT_HEAD_SIZE);
+	if (ret != GEN5_TOUCH_REPORT_HEAD_SIZE) {
+		/* Failed to read report head data. */
+		async_schedule(cyapa_detect_async, cyapa);
+		return;
+	}
+
+	report_len = get_unaligned_le16(
+			&report_data.report_head[GEN5_RESP_LENGTH_OFFSET]);
+	if (report_len <= GEN5_RESP_LENGTH_SIZE) {
+		/*
+		 * Trackpad power up event or end of one touch packets report,
+		 * no data for report.
+		 */
+		if (report_len != GEN5_RESP_LENGTH_SIZE)
+			async_schedule(cyapa_detect_async, cyapa);
+
+		return;
+	}
+
+	report_id = report_data.report_head[GEN5_RESP_REPORT_ID_OFFSET];
+	if (report_id == GEN5_WAKEUP_EVENT_REPORT_ID &&
+			report_len == GEN5_WAKEUP_EVENT_SIZE) {
+		/* Wake event from deep sleep mode, reset power state. */
+		return;
+	} else if (report_id != GEN5_TOUCH_REPORT_ID &&
+			report_id != GEN5_BTN_REPORT_ID &&
+			report_id != GEN5_OLD_PUSH_BTN_REPORT_ID &&
+			report_id != GEN5_PUSH_BTN_REPORT_ID) {
+		/* Running in BL mode or unknown response data read. */
+
+		async_schedule(cyapa_detect_async, cyapa);
+		return;
+	}
+
+	if (report_len > GEN5_TOUCH_REPORT_HEAD_SIZE) {
+		/* Must make sure to read all data through out before return. */
+		ret = cyapa_i2c_pip_read(cyapa, (u8 *)&report_data, report_len);
+		if (ret != report_len) {
+			/* Failed to read report head data. */
+			async_schedule(cyapa_detect_async, cyapa);
+			return;
+		}
+	}
+
+	if (report_id == GEN5_TOUCH_REPORT_ID &&
+		(report_len < GEN5_TOUCH_REPORT_HEAD_SIZE ||
+			report_len > GEN5_TOUCH_REPORT_MAX_SIZE)) {
+		/* Invald report data length for finger packet. */
+		async_schedule(cyapa_detect_async, cyapa);
+		return;
+	}
+
+	if ((report_id == GEN5_BTN_REPORT_ID ||
+			report_id == GEN5_OLD_PUSH_BTN_REPORT_ID ||
+			report_id == GEN5_PUSH_BTN_REPORT_ID) &&
+		(report_len < GEN5_BTN_REPORT_HEAD_SIZE ||
+			report_len > GEN5_BTN_REPORT_MAX_SIZE)) {
+		/* Invald report data length of button packet. */
+		async_schedule(cyapa_detect_async, cyapa);
+		return;
+	}
+
+	if (report_id == GEN5_BTN_REPORT_ID ||
+			report_id == GEN5_OLD_PUSH_BTN_REPORT_ID ||
+			report_id == GEN5_PUSH_BTN_REPORT_ID)
+		cyapa_gen5_report_buttons(cyapa, &report_data);
+	else
+		cyapa_gen5_report_touches(cyapa, &report_data);
+}
+
+const struct cyapa_dev_ops cyapa_gen5_ops = {
+	.initialize = cyapa_gen5_initialize,
+	.uninitialize = cyapa_gen5_uninitialize,
+
+	.state_parse = cyapa_gen5_state_parse,
+	.operational_check = cyapa_gen5_do_operational_check,
+
+	.irq_handler = cyapa_gen5_irq_handler,
+	.irq_cmd_handler = cyapa_gen5_irq_cmd_handler,
+	.sort_empty_output_data = cyapa_empty_pip_output_data,
+	.set_power_mode = cyapa_gen5_set_power_mode,
+};
-- 
1.9.1


