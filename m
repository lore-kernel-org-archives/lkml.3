Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3HSM5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:57:41 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43575 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3HSM5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:57:39 -0400
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        Daniel Jeong <gshark.jeong@gmail.com>
Subject: [PATCH 2/2] Add new FLASH driver for lm3565 chip
Date: Mon, 19 Aug 2013 21:57:01 +0900
Message-Id: <1376917021-1729-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is a general version for LM3565 Flash Driver chip of TI.

LM3565 :
The LM3565 is a 4MHz fixed-frequency, current mode synchronous boost
converter designed to drive two series flash LEDs at 930mA
The LM3565 is controlled via an I2C-compatible interface.
You can find more info at
http://www.ti.com/sitesearch/docs/universalsearch.tsp?searchTerm=lm3565&linkId=1

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 drivers/media/i2c/Kconfig  |    9 +
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/lm3565.c |  602 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/lm3565.h     |   81 ++++++
 4 files changed, 693 insertions(+)
 create mode 100644 drivers/media/i2c/lm3565.c
 create mode 100644 include/media/lm3565.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index b2cd8ca..0284d77 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -598,6 +598,15 @@ config VIDEO_AS3645A
 	  This is a driver for the AS3645A and LM3555 flash controllers. It has
 	  build in control for flash, torch and indicator LEDs.
 
+config VIDEO_LM3565
+	tristate "LM3565 flash driver support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on MEDIA_CAMERA_SUPPORT
+	select REGMAP_I2C
+	---help---
+	  This is a driver for the LM3565 flash controller.
+	  It is 4MHz, High Current Flash LED Driver.
+
 comment "Video improvement chips"
 
 config VIDEO_UPD64031A
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index dc20653..d6141f7 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_VIDEO_S5K4ECGX)	+= s5k4ecgx.o
 obj-$(CONFIG_VIDEO_S5C73M3)	+= s5c73m3/
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
 obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
+obj-$(CONFIG_VIDEO_LM3565)	+= lm3565.o
 obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
 obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
diff --git a/drivers/media/i2c/lm3565.c b/drivers/media/i2c/lm3565.c
new file mode 100644
index 0000000..78ac76d
--- /dev/null
+++ b/drivers/media/i2c/lm3565.c
@@ -0,0 +1,602 @@
+/*
+ * drivers/media/i2c/lm3565.c
+ * General device driver for TI lm3565, FLASH LED Driver
+ *
+ * Copyright (C) 2013 Texas Instruments
+ *
+ * Contact: Daniel Jeong <gshark.jeong@gmail.com>
+ *          LDD-MLP <ldd-mlp@list.ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/regmap.h>
+#include <media/lm3565.h>
+#include <media/v4l2-device.h>
+
+/* definitions for registers */
+#define REG_I_SET		0x02
+#define MASK_FLASH_I	0x0F
+#define BITS_FLASH_I(x) ((x)<<0)
+#define MASK_ASSIST_I	0x10
+#define BITS_ASSIST_I(x) ((x)<<4)
+
+#define REG_TX_MASK 0x03
+#define REG_LVC 0x04
+#define REG_TCTRL 0x05
+#define BITS_FLASH_TOUT(x) ((x)<<0)
+
+#define REG_STROBE				0x6
+#define MASK_STROBE_ENABLE		0x80
+#define BITS_STROBE_ENABLE(x)	((x)<<7)
+
+#define REG_OUTMODE		0x07
+#define MASK_OUTENABLE		0x08
+#define BITS_OUTENABLE(x)	((x)<<3)
+#define MASK_OUTMODE		0x03
+#define BITS_OUTMODE(x)		((x)<<0)
+enum lm3565_outmode {
+	OUTMODE_EXT_TORCH = 0,
+	OUTMODE_NONE,
+	OUTMODE_ASSIST,
+	OUTMODE_FLASH,
+};
+
+#define REG_FAULT 0x08
+#define FAULT_UVLO (1<<0)
+#define FAULT_INPUT_LOW (1<<1)
+#define FAULT_TX_EVENT (1<<3)
+#define FAULT_TIMEOUT (1<<4)
+#define FAULT_OVERTEMP (1<<5)
+#define FAULT_SHORT_CIRCUIT (1<<6)
+#define FAULT_OVP (1<<7)
+
+#define REG_ADC		0x09
+#define REG_IVADC	0x0A
+#define REG_LVADC	0x0B
+#define REG_MAX		0xFF
+
+#define to_lm3565_flash(sd)	container_of(sd, struct lm3565_flash, subdev)
+
+/* struct lm3565_flash
+ *
+ * @subdev: V4L2 subdev
+ * @pdata: platform data
+ * @ctrls: contols
+ * @flash_timeout: flash timeout
+ * @flash_intensity: flash current
+ * @asist_intensity: assist current
+ * @led_mode: V4L2 LED mode
+ * @strobe: strobe source
+ * @regmap: reg. map for i2c
+ * @power_lock: Protects power_count
+ * @fault: falut data
+ * @power_count: Power reference count
+ */
+struct lm3565_flash {
+	struct v4l2_subdev subdev;
+	struct v4l2_ctrl_handler ctrls;
+	struct lm3565_platform_data *pdata;
+
+	unsigned int flash_timeout;
+	unsigned int flash_intensity;
+	unsigned int assist_intensity;
+	enum v4l2_flash_led_mode led_mode;
+	enum v4l2_flash_strobe_source strobe;
+
+	struct regmap *regmap;
+	struct mutex power_lock;
+	u8 fault;
+	int power_count;
+};
+
+/* i2c access */
+static int lm3565_read(struct lm3565_flash *flash, unsigned int reg)
+{
+	int rval;
+	unsigned int reg_val;
+
+	rval = regmap_read(flash->regmap, reg, &reg_val);
+	if (rval < 0)
+		return rval;
+	return reg_val & 0xFF;
+}
+
+static int lm3565_write(struct lm3565_flash *flash,
+			unsigned int reg, unsigned int data)
+{
+	return regmap_write(flash->regmap, reg, data);
+}
+
+static int lm3565_update(struct lm3565_flash *flash,
+			 unsigned int reg, unsigned int mask, unsigned int data)
+{
+	return regmap_update_bits(flash->regmap, reg, mask, data);
+}
+
+/* set/clear out-enable bit */
+static int lm3656_out_ctrl(struct lm3565_flash *flash, bool enable)
+{
+	int rval;
+
+	if (enable == true)
+		rval = lm3565_update(flash, REG_OUTMODE,
+				     MASK_OUTENABLE, BITS_OUTENABLE(1));
+	else
+		rval = lm3565_update(flash, REG_OUTMODE,
+				     MASK_OUTENABLE, BITS_OUTENABLE(0));
+	return rval;
+}
+
+/* chip configuration */
+static int lm3565_chip_config(struct lm3565_flash *flash)
+{
+	u8 bval;
+	int rval;
+
+	/* current config */
+	bval = (flash->flash_intensity - LM3565_FLASH_INTENSITY_MIN)
+	    / LM3565_FLASH_INTENSITY_STEP;
+	rval =
+	    lm3565_update(flash, REG_I_SET, MASK_FLASH_I, BITS_FLASH_I(bval));
+	if (rval < 0)
+		goto err_out;
+	bval = (flash->assist_intensity - LM3565_ASSIST_INTENSITY_MIN)
+	    / LM3565_ASSIST_INTENSITY_STEP;
+	rval =
+	    lm3565_update(flash, REG_I_SET, MASK_ASSIST_I, BITS_ASSIST_I(bval));
+	if (rval < 0)
+		goto err_out;
+
+	/* strobe source */
+	if (flash->strobe == V4L2_FLASH_STROBE_SOURCE_EXTERNAL)
+		rval = lm3565_update(flash, REG_STROBE,
+				     MASK_STROBE_ENABLE, BITS_STROBE_ENABLE(1));
+	else
+		rval = lm3565_update(flash, REG_STROBE,
+				     MASK_STROBE_ENABLE, BITS_STROBE_ENABLE(0));
+	if (rval < 0)
+		goto err_out;
+
+	/* timeout config */
+	bval = (flash->flash_timeout - LM3565_FLASH_TOUT_MIN)
+	    / LM3565_FLASH_TOUT_STEP;
+	rval = lm3565_write(flash, REG_TCTRL, BITS_FLASH_TOUT(bval));
+	if (rval < 0)
+		goto err_out;
+
+	/* out mode config */
+	switch (flash->led_mode) {
+	case V4L2_FLASH_LED_MODE_FLASH:
+		rval =
+		    lm3565_update(flash, REG_OUTMODE, MASK_OUTMODE,
+				  OUTMODE_EXT_TORCH);
+		if (rval < 0)
+			goto err_out;
+		rval =
+		    lm3565_update(flash, REG_OUTMODE, MASK_OUTMODE,
+				  OUTMODE_FLASH);
+		break;
+	case V4L2_FLASH_LED_MODE_TORCH:
+		rval =
+		    lm3565_update(flash, REG_OUTMODE, MASK_OUTMODE,
+				  OUTMODE_ASSIST);
+		break;
+	default:
+		rval =
+		    lm3565_update(flash, REG_OUTMODE, MASK_OUTMODE,
+				  OUTMODE_EXT_TORCH);
+		break;
+	}
+
+err_out:
+	return rval;
+}
+
+/* V4L2 controls  */
+static int lm3565_get_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct lm3565_flash *flash =
+	    container_of(ctrl->handler, struct lm3565_flash, ctrls);
+	int rval;
+
+	if (ctrl->id == V4L2_CID_FLASH_FAULT) {
+		rval = lm3565_read(flash, REG_FAULT);
+		if (rval < 0)
+			return rval;
+
+		ctrl->cur.val = 0;
+		rval |= flash->fault;
+		if (rval & FAULT_SHORT_CIRCUIT)
+			ctrl->cur.val |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
+		if (rval & FAULT_OVERTEMP)
+			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
+		if (rval & FAULT_TIMEOUT)
+			ctrl->cur.val |= V4L2_FLASH_FAULT_TIMEOUT;
+		if (rval & FAULT_OVP)
+			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
+		flash->fault = 0;
+	}
+	return 0;
+}
+
+static int lm3565_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct lm3565_flash *flash =
+	    container_of(ctrl->handler, struct lm3565_flash, ctrls);
+	int rval = 0;
+	bool enable = true;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FLASH_LED_MODE:
+		flash->led_mode = ctrl->val;
+		if (ctrl->val == V4L2_FLASH_LED_MODE_NONE ||
+		    ctrl->val == V4L2_FLASH_LED_MODE_FLASH)
+			enable = false;
+
+		rval = lm3565_chip_config(flash);
+		if (rval < 0)
+			goto err_out;
+		rval = lm3656_out_ctrl(flash, enable);
+		if (rval < 0)
+			goto err_out;
+		break;
+
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		flash->strobe = ctrl->val;
+		rval = lm3565_chip_config(flash);
+		if (rval < 0)
+			goto err_out;
+		rval = lm3656_out_ctrl(flash, false);
+		break;
+
+	case V4L2_CID_FLASH_STROBE:
+		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
+			return -EBUSY;
+		rval = lm3656_out_ctrl(flash, true);
+		break;
+
+	case V4L2_CID_FLASH_STROBE_STOP:
+		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
+			return -EBUSY;
+		rval = lm3656_out_ctrl(flash, false);
+		break;
+
+	case V4L2_CID_FLASH_TIMEOUT:
+		flash->flash_timeout = ctrl->val;
+		rval = lm3565_chip_config(flash);
+		break;
+
+	case V4L2_CID_FLASH_INTENSITY:
+		flash->flash_intensity = ctrl->val;
+		rval = lm3565_chip_config(flash);
+		break;
+
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		flash->assist_intensity = ctrl->val;
+		rval = lm3565_chip_config(flash);
+		break;
+	}
+	if (rval < 0)
+		goto err_out;
+
+	rval = lm3565_read(flash, REG_FAULT);
+	if (rval < 0)
+		goto err_out;
+	flash->fault |= rval;
+
+	return 0;
+err_out:
+	return rval;
+}
+
+static const struct v4l2_ctrl_ops lm3565_ctrl_ops = {
+	.g_volatile_ctrl = lm3565_get_ctrl,
+	.s_ctrl = lm3565_set_ctrl,
+};
+
+static int lm3565_init_controls(struct lm3565_flash *flash)
+{
+	struct v4l2_ctrl *fault;
+
+	v4l2_ctrl_handler_init(&flash->ctrls, 8);
+
+	/* flash mode */
+	v4l2_ctrl_new_std_menu(&flash->ctrls, &lm3565_ctrl_ops,
+			       V4L2_CID_FLASH_LED_MODE,
+			       V4L2_FLASH_LED_MODE_TORCH,
+			       ~0x7, V4L2_FLASH_LED_MODE_NONE);
+	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
+
+	/* flash source */
+	v4l2_ctrl_new_std_menu(&flash->ctrls, &lm3565_ctrl_ops,
+			       V4L2_CID_FLASH_STROBE_SOURCE,
+			       0x1, ~0x3, V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
+	flash->strobe = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+
+	/* flash strobe */
+	v4l2_ctrl_new_std(&flash->ctrls, &lm3565_ctrl_ops,
+			  V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
+	/* flash strobe stop */
+	v4l2_ctrl_new_std(&flash->ctrls, &lm3565_ctrl_ops,
+			  V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
+
+	/* flash strobe timeout */
+	v4l2_ctrl_new_std(&flash->ctrls, &lm3565_ctrl_ops,
+			  V4L2_CID_FLASH_TIMEOUT, LM3565_FLASH_TOUT_MIN,
+			  flash->pdata->max_flash_timeout,
+			  LM3565_FLASH_TOUT_STEP,
+			  flash->pdata->max_flash_timeout);
+	flash->flash_timeout = flash->pdata->max_flash_timeout;
+
+	/* flash intensity */
+	v4l2_ctrl_new_std(&flash->ctrls, &lm3565_ctrl_ops,
+			  V4L2_CID_FLASH_INTENSITY,
+			  LM3565_FLASH_INTENSITY_MIN,
+			  flash->pdata->max_flash_intensity,
+			  LM3565_FLASH_INTENSITY_STEP,
+			  flash->pdata->max_flash_intensity);
+	flash->flash_intensity = flash->pdata->max_flash_intensity;
+
+	/* assist intensity */
+	v4l2_ctrl_new_std(&flash->ctrls, &lm3565_ctrl_ops,
+			  V4L2_CID_FLASH_TORCH_INTENSITY,
+			  LM3565_ASSIST_INTENSITY_MIN,
+			  flash->pdata->max_assist_intensity,
+			  LM3565_ASSIST_INTENSITY_STEP,
+			  flash->pdata->max_assist_intensity);
+	flash->assist_intensity = flash->pdata->max_assist_intensity;
+
+	/* fault */
+	fault = v4l2_ctrl_new_std(&flash->ctrls, &lm3565_ctrl_ops,
+				  V4L2_CID_FLASH_FAULT, 0,
+				  V4L2_FLASH_FAULT_OVER_VOLTAGE
+				  | V4L2_FLASH_FAULT_OVER_TEMPERATURE
+				  | V4L2_FLASH_FAULT_SHORT_CIRCUIT
+				  | V4L2_FLASH_FAULT_TIMEOUT, 0, 0);
+	if (fault != NULL)
+		fault->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+	if (flash->ctrls.error)
+		return flash->ctrls.error;
+
+	flash->subdev.ctrl_handler = &flash->ctrls;
+	return 0;
+}
+
+/*V4L2 subdev operations */
+static int lm3565_init_device(struct lm3565_flash *flash)
+{
+	int rval;
+
+	/* Reset faults */
+	rval = lm3565_read(flash, REG_FAULT);
+	if (rval < 0)
+		goto err_out;
+	/* output disable */
+	rval = lm3656_out_ctrl(flash, false);
+	if (rval < 0)
+		goto err_out;
+	/* chip configuration */
+	rval = lm3565_chip_config(flash);
+	if (rval < 0)
+		goto err_out;
+	return 0;
+
+err_out:
+	return rval;
+}
+
+static int __lm3565_set_power(struct lm3565_flash *flash, int on)
+{
+	int rval = 0;
+
+	if (!on) {
+		rval = lm3656_out_ctrl(flash, false);
+		if (rval < 0)
+			return rval;
+	}
+
+	if (flash->pdata->set_power != NULL) {
+		rval = flash->pdata->set_power(&flash->subdev, on);
+		if (rval < 0)
+			return rval;
+	}
+
+	if (on) {
+		rval = lm3565_init_device(flash);
+		if ((rval < 0) && (flash->pdata->set_power != NULL))
+			flash->pdata->set_power(&flash->subdev, 0);
+	}
+	return rval;
+}
+
+static int lm3565_set_power(struct v4l2_subdev *subdev, int on)
+{
+	int rval = 0;
+	struct lm3565_flash *flash = to_lm3565_flash(subdev);
+
+	mutex_lock(&flash->power_lock);
+	if (flash->power_count == !on) {
+		rval = __lm3565_set_power(flash, !!on);
+		if (rval < 0)
+			goto out;
+	}
+	flash->power_count += on ? 1 : -1;
+	WARN_ON(flash->power_count < 0);
+out:
+	mutex_unlock(&flash->power_lock);
+	return rval;
+}
+
+static int lm3565_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return lm3565_set_power(sd, 1);
+}
+
+static int lm3565_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return lm3565_set_power(sd, 0);
+}
+
+static const struct v4l2_subdev_core_ops lm3565_core_ops = {
+	.s_power = lm3565_set_power,
+};
+
+static const struct v4l2_subdev_ops lm3565_ops = {
+	.core = &lm3565_core_ops,
+};
+
+static const struct v4l2_subdev_internal_ops lm3565_internal_ops = {
+	.open = lm3565_open,
+	.close = lm3565_close,
+};
+
+#ifdef CONFIG_PM
+static int lm3565_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct lm3565_flash *flash = to_lm3565_flash(subdev);
+
+	if (flash->power_count == 0)
+		return 0;
+
+	return __lm3565_set_power(flash, 0);
+}
+
+static int lm3565_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct lm3565_flash *flash = to_lm3565_flash(subdev);
+
+	if (flash->power_count == 0)
+		return 0;
+	return __lm3565_set_power(flash, 1);
+}
+#else
+
+#define lm3565_suspend	NULL
+#define lm3565_resume	NULL
+
+#endif
+
+static const struct regmap_config lm3565_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = REG_MAX,
+};
+
+static int lm3565_probe(struct i2c_client *client,
+			const struct i2c_device_id *devid)
+{
+	int rval;
+	struct lm3565_flash *flash;
+
+	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
+	if (flash == NULL)
+		return -ENOMEM;
+
+	flash->regmap = devm_regmap_init_i2c(client, &lm3565_regmap);
+	if (IS_ERR(flash->regmap)) {
+		rval = PTR_ERR(flash->regmap);
+		return rval;
+	}
+
+	/* if there is no platform data, use chip default value */
+	if (client->dev.platform_data == NULL) {
+		flash->pdata =
+		    kzalloc(sizeof(struct lm3565_platform_data), GFP_KERNEL);
+		if (flash->pdata == NULL)
+			return -ENODEV;
+		flash->pdata->max_flash_timeout = LM3565_FLASH_TOUT_MAX;
+		flash->pdata->max_flash_intensity = LM3565_FLASH_INTENSITY_MAX;
+		flash->pdata->max_assist_intensity =
+		    LM3565_ASSIST_INTENSITY_MAX;
+		flash->pdata->set_power = NULL;
+	} else {
+		flash->pdata = client->dev.platform_data;
+	}
+
+	mutex_init(&flash->power_lock);
+
+	v4l2_i2c_subdev_init(&flash->subdev, client, &lm3565_ops);
+	flash->subdev.internal_ops = &lm3565_internal_ops;
+	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	rval = lm3565_init_controls(flash);
+	if (rval)
+		goto err_out;
+
+	rval = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
+	if (rval < 0)
+		goto err_out;
+
+	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
+
+	return 0;
+
+err_out:
+	v4l2_ctrl_handler_free(&flash->ctrls);
+	kfree(flash);
+	return rval;
+}
+
+static int lm3565_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct lm3565_flash *flash = to_lm3565_flash(subdev);
+
+	v4l2_device_unregister_subdev(&flash->subdev);
+	v4l2_ctrl_handler_free(&flash->ctrls);
+	media_entity_cleanup(&flash->subdev.entity);
+	kfree(flash);
+	return 0;
+}
+
+static const struct i2c_device_id lm3565_id_table[] = {
+	{LM3565_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lm3565_id_table);
+
+static const struct dev_pm_ops lm3565_pm_ops = {
+	.suspend = lm3565_suspend,
+	.resume = lm3565_resume,
+};
+
+static struct i2c_driver lm3565_i2c_driver = {
+	.driver = {
+		   .name = LM3565_NAME,
+		   .pm = &lm3565_pm_ops,
+		   },
+	.probe = lm3565_probe,
+	.remove = lm3565_remove,
+	.id_table = lm3565_id_table,
+};
+
+module_i2c_driver(lm3565_i2c_driver);
+
+MODULE_AUTHOR("Daniel Jeong <gshark.jeong@gmail.com>");
+MODULE_AUTHOR("LDD MLP <ldd-mlp@list.ti.com>");
+MODULE_DESCRIPTION("Texas Instruments LM3565 LED flash driver");
+MODULE_LICENSE("GPL");
diff --git a/include/media/lm3565.h b/include/media/lm3565.h
new file mode 100644
index 0000000..f0602ee
--- /dev/null
+++ b/include/media/lm3565.h
@@ -0,0 +1,81 @@
+/*
+ * include/media/lm3565.h
+ *
+ * Copyright (C) 2013 Texas Instruments
+ *
+ * Contact: Daniel Jeong <daniel.jeong@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef LM3565_H
+#define LM3565_H
+
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
+
+#define LM3565_NAME "lm3565"
+#define LM3565_ADDR 0x30
+
+/*  FLASH INTENSITY
+ *	min 480mA, step 30mA, max 930mA
+ */
+#define LM3565_FLASH_INTENSITY_MIN 480
+#define LM3565_FLASH_INTENSITY_STEP 30
+#define LM3565_FLASH_INTENSITY_MAX 930
+#define LM3565_FLASH_INTENSITY_mA_TO_REG(a)	\
+	((a) < LM3565_FLASH_INTENSITY_MIN ? 0 :	\
+	 (((a) - LM3565_FLASH_INTENSITY_BASE) / LM3565_FLASH_INTENSITY_STEP))
+#define LM3565_FLASH_INTENSITY_REG_TO_mA(a)		\
+	((a) * LM3565_FLASH_INTENSITY_STEP + LM3565_FLASH_INTENSITY_BASE)
+
+/*  FLASH TIMEOUT DURATION
+ *	min 2ms, step 2ms, max 512ms
+ */
+#define LM3565_FLASH_TOUT_MIN 2
+#define LM3565_FLASH_TOUT_STEP 2
+#define LM3565_FLASH_TOUT_MAX 512
+#define LM3565_FLASH_TOUT_ms_TO_REG(a)	\
+	((a) < LM3565_FLASH_TOUT_MIN ? 0 :	\
+	 (((a) - LM3565_FLASH_TOUT_BASE) / LM3565_FLASH_TOUT_STEP))
+#define LM3565_FLASH_TOUT_REG_TO_mA(a)		\
+	((a) * LM3565_FLASH_TOUT_STEP + LM3565_FLASH_TOUT_BASE)
+
+/*  TORCH INTENSITY
+ *	min 60mA, step 30mA, max 90mA
+ */
+#define LM3565_ASSIST_INTENSITY_MIN 60
+#define LM3565_ASSIST_INTENSITY_STEP 30
+#define LM3565_ASSIST_INTENSITY_MAX 90
+#define LM3565_ASSIST_INTENSITY_mA_TO_REG(a)	\
+	((a) < LM3565_ASSIST_INTENSITY_MIN ? 0 :	\
+	 (((a) - LM3565_ASSIST_INTENSITY_MIN) / LM3565_ASSIST_INTENSITY_STEP))
+#define LM3565_ASSIST_INTENSITY_REG_TO_mA(a)		\
+	((a) * LM3565_ASSIST_INTENSITY_STEP + LM3565_ASSIST_INTENSITY_BASE)
+
+struct lm3565_platform_data {
+	int (*set_power) (struct v4l2_subdev *sd, int on);
+
+	u32 max_flash_timeout;	/* flash light timeout */
+	u32 max_flash_intensity;	/* led intensity, flash mode */
+	u32 max_assist_intensity;	/* led intensity, assist mode */
+};
+
+#endif /* LM3565_H */
-- 
1.7.9.5

