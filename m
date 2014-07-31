Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaGaTPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:15:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51919 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaGaTPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:15:07 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <linux-input@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <mark.rutland@arm.com>, <madcatxster@devoid-pointer.net>,
        <simon@mungewell.org>, <elias.vds@gmail.com>,
        <dmitry.torokhov@gmail.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v5] input: drv260x: Add TI drv260x haptics driver
Date: Thu, 31 Jul 2014 14:14:49 -0500
Message-ID: <1406834089-15095-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the TI drv260x haptics/vibrator driver.
This device uses the input force feedback
to produce a wave form to driver an
ERM or LRA actuator device.

The initial driver supports the devices
real time playback mode.  But the device
has additional wave patterns in ROM.

This functionality will be added in
future patchsets.

Product data sheet is located here:
http://www.ti.com/product/drv2605

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---

v5 - Move register defines to c file and rm header file, error check
init in probe, fixed identation, remove empty labels in probe
and just return on fail and removed the remove callback and function.
Did not factor out the suspend into a stop function. - https://patchwork.kernel.org/patch/4649631/
v4 - Convert regulator to devm, added error checking where required,
updated bindings doc, moved dt parsing to separate call and made platform
data the first data point, moved vibrator enable and mode programming from
play entry to worker thread, added user check and input mutex in suspend/resume
calls, moved platform data to individual file and into include platform-data directory,
removed file names from file headers - https://patchwork.kernel.org/patch/4642221/
v3 - Updated binding doc, changed to memless device, updated input alloc to
devm, removed mutex locking, add sanity checks for mode and library - https://patchwork.kernel.org/patch/4635421/
v2 - Fixed binding doc and patch headline - https://patchwork.kernel.org/patch/4619641/


 .../devicetree/bindings/input/ti,drv260x.txt       |   50 ++
 drivers/input/misc/Kconfig                         |    9 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/drv260x.c                       |  697 ++++++++++++++++++++
 include/dt-bindings/input/ti-drv260x.h             |   35 +
 include/linux/platform_data/drv260x-pdata.h        |   29 +
 6 files changed, 821 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/ti,drv260x.txt
 create mode 100644 drivers/input/misc/drv260x.c
 create mode 100644 include/dt-bindings/input/ti-drv260x.h
 create mode 100644 include/linux/platform_data/drv260x-pdata.h

diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/Documentation/devicetree/bindings/input/ti,drv260x.txt
new file mode 100644
index 0000000..8e6970d
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
@@ -0,0 +1,50 @@
+Texas Instruments - drv260x Haptics driver family
+
+The drv260x family serial control bus communicates through I2C protocols
+
+Required properties:
+	- compatible - One of:
+		"ti,drv2604" - DRV2604
+		"ti,drv2605" - DRV2605
+		"ti,drv2605l" - DRV2605L
+	- reg -  I2C slave address
+	- supply- Required supply regulators are:
+		"vbat" - battery voltage
+	- mode - Power up mode of the chip (defined in include/dt-bindings/input/ti-drv260x.h)
+		DRV260X_LRA_MODE - Linear Resonance Actuator mode (Piezoelectric)
+		DRV260X_LRA_NO_CAL_MODE - This is a LRA Mode but there is no calibration
+				sequence during init.  And the device is configured for real
+				time playback mode (RTP mode).
+		DRV260X_ERM_MODE - Eccentric Rotating Mass mode (Rotary vibrator)
+	- library-sel - These are ROM based waveforms pre-programmed into the IC.
+				This should be set to set the library to use at power up.
+				(defined in include/dt-bindings/input/ti-drv260x.h)
+		DRV260X_LIB_A - Pre-programmed Library
+		DRV260X_LIB_B - Pre-programmed Library
+		DRV260X_LIB_C - Pre-programmed Library
+		DRV260X_LIB_D - Pre-programmed Library
+		DRV260X_LIB_E - Pre-programmed Library
+		DRV260X_LIB_F - Pre-programmed Library
+
+Optional properties:
+	- enable-gpio - gpio pin to enable/disable the device.
+	- vib_rated_voltage - The rated voltage of the actuator in millivolts.
+			  If this is not set then the value will be defaulted to
+			  3.2 v.
+	- vib_overdrive_voltage - The overdrive voltage of the actuator in millivolts.
+			  If this is not set then the value will be defaulted to
+			  3.2 v.
+Example:
+
+drv2605l: drv2605l@5a {
+		compatible = "ti,drv2605l";
+		reg = <0x5a>;
+		enable-gpio = <&gpio1 28 GPIO_ACTIVE_HIGH>;
+		mode = <DRV260X_LRA_MODE>;
+		library-sel = <DRV260X_LIB_SEL_DEFAULT>;
+		vib-rated-voltage = <3200>;
+		vib-overdriver-voltage = <3200>;
+};
+
+For more product information please see the link below:
+http://www.ti.com/product/drv2605
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 2ff4425..99f6762 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -676,4 +676,13 @@ config INPUT_SOC_BUTTON_ARRAY
 	  To compile this driver as a module, choose M here: the
 	  module will be called soc_button_array.
 
+config INPUT_DRV260X_HAPTICS
+	tristate "TI DRV260X haptics support"
+	depends on INPUT && I2C
+	help
+	  Say Y to enable support for the TI DRV260X haptics driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called drv260x-haptics.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 4955ad3..d8ef3c7 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -64,3 +64,4 @@ obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
 obj-$(CONFIG_INPUT_IDEAPAD_SLIDEBAR)	+= ideapad_slidebar.o
+obj-$(CONFIG_INPUT_DRV260X_HAPTICS)	+= drv260x.o
diff --git a/drivers/input/misc/drv260x.c b/drivers/input/misc/drv260x.c
new file mode 100644
index 0000000..6ccdeff
--- /dev/null
+++ b/drivers/input/misc/drv260x.c
@@ -0,0 +1,697 @@
+/*
+ * DRV260X haptics driver family
+ *
+ * Author: Dan Murphy <dmurphy@ti.com>
+ *
+ * Copyright:   (C) 2014 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/regulator/consumer.h>
+
+#include <dt-bindings/input/ti-drv260x.h>
+#include <linux/platform_data/drv260x-pdata.h>
+
+#define DRV260X_STATUS		0x0
+#define DRV260X_MODE		0x1
+#define DRV260X_RT_PB_IN	0x2
+#define DRV260X_LIB_SEL		0x3
+#define DRV260X_WV_SEQ_1	0x4
+#define DRV260X_WV_SEQ_2	0x5
+#define DRV260X_WV_SEQ_3	0x6
+#define DRV260X_WV_SEQ_4	0x7
+#define DRV260X_WV_SEQ_5	0x8
+#define DRV260X_WV_SEQ_6	0x9
+#define DRV260X_WV_SEQ_7	0xa
+#define DRV260X_WV_SEQ_8	0xb
+#define DRV260X_GO				0xc
+#define DRV260X_OVERDRIVE_OFF	0xd
+#define DRV260X_SUSTAIN_P_OFF	0xe
+#define DRV260X_SUSTAIN_N_OFF	0xf
+#define DRV260X_BRAKE_OFF		0x10
+#define DRV260X_A_TO_V_CTRL		0x11
+#define DRV260X_A_TO_V_MIN_INPUT	0x12
+#define DRV260X_A_TO_V_MAX_INPUT	0x13
+#define DRV260X_A_TO_V_MIN_OUT	0x14
+#define DRV260X_A_TO_V_MAX_OUT	0x15
+#define DRV260X_RATED_VOLT		0x16
+#define DRV260X_OD_CLAMP_VOLT	0x17
+#define DRV260X_CAL_COMP		0x18
+#define DRV260X_CAL_BACK_EMF	0x19
+#define DRV260X_FEEDBACK_CTRL	0x1a
+#define DRV260X_CTRL1			0x1b
+#define DRV260X_CTRL2			0x1c
+#define DRV260X_CTRL3			0x1d
+#define DRV260X_CTRL4			0x1e
+#define DRV260X_CTRL5			0x1f
+#define DRV260X_LRA_LOOP_PERIOD	0x20
+#define DRV260X_VBAT_MON		0x21
+#define DRV260X_LRA_RES_PERIOD	0x22
+#define DRV260X_MAX_REG			0x23
+
+#define DRV260X_ALLOWED_R_BYTES	25
+#define DRV260X_ALLOWED_W_BYTES	2
+#define DRV260X_MAX_RW_RETRIES	5
+#define DRV260X_I2C_RETRY_DELAY 10
+
+#define DRV260X_GO_BIT				0x01
+
+/* Library Selection */
+#define DRV260X_LIB_SEL_MASK		0x07
+#define DRV260X_LIB_SEL_RAM			0x0
+#define DRV260X_LIB_SEL_OD			0x1
+#define DRV260X_LIB_SEL_40_60		0x2
+#define DRV260X_LIB_SEL_60_80		0x3
+#define DRV260X_LIB_SEL_100_140		0x4
+#define DRV260X_LIB_SEL_140_PLUS	0x5
+
+#define DRV260X_LIB_SEL_HIZ_MASK	0x10
+#define DRV260X_LIB_SEL_HIZ_EN		0x01
+#define DRV260X_LIB_SEL_HIZ_DIS		0
+
+/* Mode register */
+#define DRV260X_STANDBY				(1 << 6)
+#define DRV260X_STANDBY_MASK		0x40
+#define DRV260X_INTERNAL_TRIGGER	0x00
+#define DRV260X_EXT_TRIGGER_EDGE	0x01
+#define DRV260X_EXT_TRIGGER_LEVEL	0x02
+#define DRV260X_PWM_ANALOG_IN		0x03
+#define DRV260X_AUDIOHAPTIC			0x04
+#define DRV260X_RT_PLAYBACK			0x05
+#define DRV260X_DIAGNOSTICS			0x06
+#define DRV260X_AUTO_CAL			0x07
+
+/* Audio to Haptics Control */
+#define DRV260X_AUDIO_HAPTICS_PEAK_10MS		(0 << 2)
+#define DRV260X_AUDIO_HAPTICS_PEAK_20MS		(1 << 2)
+#define DRV260X_AUDIO_HAPTICS_PEAK_30MS		(2 << 2)
+#define DRV260X_AUDIO_HAPTICS_PEAK_40MS		(3 << 2)
+
+#define DRV260X_AUDIO_HAPTICS_FILTER_100HZ	0x00
+#define DRV260X_AUDIO_HAPTICS_FILTER_125HZ	0x01
+#define DRV260X_AUDIO_HAPTICS_FILTER_150HZ	0x02
+#define DRV260X_AUDIO_HAPTICS_FILTER_200HZ	0x03
+
+/* Min/Max Input/Output Voltages */
+#define DRV260X_AUDIO_HAPTICS_MIN_IN_VOLT	0x19
+#define DRV260X_AUDIO_HAPTICS_MAX_IN_VOLT	0x64
+#define DRV260X_AUDIO_HAPTICS_MIN_OUT_VOLT	0x19
+#define DRV260X_AUDIO_HAPTICS_MAX_OUT_VOLT	0xFF
+
+/* Feedback register */
+#define DRV260X_FB_REG_ERM_MODE			0x7f
+#define DRV260X_FB_REG_LRA_MODE			(1 << 7)
+
+#define DRV260X_BRAKE_FACTOR_MASK	0x1f
+#define DRV260X_BRAKE_FACTOR_2X		(1 << 0)
+#define DRV260X_BRAKE_FACTOR_3X		(2 << 4)
+#define DRV260X_BRAKE_FACTOR_4X		(3 << 4)
+#define DRV260X_BRAKE_FACTOR_6X		(4 << 4)
+#define DRV260X_BRAKE_FACTOR_8X		(5 << 4)
+#define DRV260X_BRAKE_FACTOR_16		(6 << 4)
+#define DRV260X_BRAKE_FACTOR_DIS	(7 << 4)
+
+#define DRV260X_LOOP_GAIN_LOW		0xf3
+#define DRV260X_LOOP_GAIN_MED		(1 << 2)
+#define DRV260X_LOOP_GAIN_HIGH		(2 << 2)
+#define DRV260X_LOOP_GAIN_VERY_HIGH	(3 << 2)
+
+#define DRV260X_BEMF_GAIN_0			0xfc
+#define DRV260X_BEMF_GAIN_1		(1 << 0)
+#define DRV260X_BEMF_GAIN_2		(2 << 0)
+#define DRV260X_BEMF_GAIN_3		(3 << 0)
+
+/* Control 1 register */
+#define DRV260X_AC_CPLE_EN			(1 << 5)
+#define DRV260X_STARTUP_BOOST		(1 << 7)
+
+/* Control 2 register */
+
+#define DRV260X_IDISS_TIME_45		0
+#define DRV260X_IDISS_TIME_75		(1 << 0)
+#define DRV260X_IDISS_TIME_150		(1 << 1)
+#define DRV260X_IDISS_TIME_225		0x03
+
+#define DRV260X_BLANK_TIME_45	(0 << 2)
+#define DRV260X_BLANK_TIME_75	(1 << 2)
+#define DRV260X_BLANK_TIME_150	(2 << 2)
+#define DRV260X_BLANK_TIME_225	(3 << 2)
+
+#define DRV260X_SAMP_TIME_150	(0 << 4)
+#define DRV260X_SAMP_TIME_200	(1 << 4)
+#define DRV260X_SAMP_TIME_250	(2 << 4)
+#define DRV260X_SAMP_TIME_300	(3 << 4)
+
+#define DRV260X_BRAKE_STABILIZER	(1 << 6)
+#define DRV260X_UNIDIR_IN			(0 << 7)
+#define DRV260X_BIDIR_IN			(1 << 7)
+
+/* Control 3 Register */
+#define DRV260X_LRA_OPEN_LOOP		(1 << 0)
+#define DRV260X_ANANLOG_IN			(1 << 1)
+#define DRV260X_LRA_DRV_MODE		(1 << 2)
+#define DRV260X_RTP_UNSIGNED_DATA	(1 << 3)
+#define DRV260X_SUPPLY_COMP_DIS		(1 << 4)
+#define DRV260X_ERM_OPEN_LOOP		(1 << 5)
+#define DRV260X_NG_THRESH_0			(0 << 6)
+#define DRV260X_NG_THRESH_2			(1 << 6)
+#define DRV260X_NG_THRESH_4			(2 << 6)
+#define DRV260X_NG_THRESH_8			(3 << 6)
+
+/* Control 4 Register */
+#define DRV260X_AUTOCAL_TIME_150MS		(0 << 4)
+#define DRV260X_AUTOCAL_TIME_250MS		(1 << 4)
+#define DRV260X_AUTOCAL_TIME_500MS		(2 << 4)
+#define DRV260X_AUTOCAL_TIME_1000MS		(3 << 4)
+
+/**
+ * struct drv260x_data -
+ * @input_dev - Pointer to the input device
+ * @client - Pointer to the I2C client
+ * @regmap - Register map of the device
+ * @work - Work item used to off load the enable/disable of the vibration
+ * @enable_gpio - Pointer to the gpio used for enable/disabling
+ * @regulator - Pointer to the regulator for the IC
+ * @magnitude - Magnitude of the vibration event
+ * @mode - The operating mode of the IC (LRA_NO_CAL, ERM or LRA)
+ * @library - The vibration library to be used
+ * @rated_voltage - The rated_voltage of the actuator
+ * @overdriver_voltage - The over drive voltage of the actuator
+**/
+struct drv260x_data {
+	struct input_dev *input_dev;
+	struct i2c_client *client;
+	struct regmap *regmap;
+	struct work_struct work;
+	struct gpio_desc *enable_gpio;
+	struct regulator *regulator;
+	u32 magnitude;
+	u32 mode;
+	u32 library;
+	int rated_voltage;
+	int overdrive_voltage;
+};
+
+static struct reg_default drv260x_reg_defs[] = {
+	{ DRV260X_STATUS, 0xe0 },
+	{ DRV260X_MODE, 0x40 },
+	{ DRV260X_RT_PB_IN, 0x00},
+	{ DRV260X_LIB_SEL, 0x00},
+	{ DRV260X_WV_SEQ_1, 0x01},
+	{ DRV260X_WV_SEQ_2, 0x00},
+	{ DRV260X_WV_SEQ_3, 0x00},
+	{ DRV260X_WV_SEQ_4, 0x00},
+	{ DRV260X_WV_SEQ_5, 0x00},
+	{ DRV260X_WV_SEQ_6, 0x00},
+	{ DRV260X_WV_SEQ_7, 0x00},
+	{ DRV260X_WV_SEQ_8, 0x00},
+	{ DRV260X_GO, 0x00},
+	{ DRV260X_OVERDRIVE_OFF, 0x00},
+	{ DRV260X_SUSTAIN_P_OFF, 0x00},
+	{ DRV260X_SUSTAIN_N_OFF, 0x00},
+	{ DRV260X_BRAKE_OFF	, 0x00},
+	{ DRV260X_A_TO_V_CTRL	, 0x05},
+	{ DRV260X_A_TO_V_MIN_INPUT, 0x19},
+	{ DRV260X_A_TO_V_MAX_INPUT, 0xff},
+	{ DRV260X_A_TO_V_MIN_OUT, 0x19},
+	{ DRV260X_A_TO_V_MAX_OUT, 0xff},
+	{ DRV260X_RATED_VOLT, 0x3e},
+	{ DRV260X_OD_CLAMP_VOLT, 0x8c},
+	{ DRV260X_CAL_COMP, 0x0c},
+	{ DRV260X_CAL_BACK_EMF, 0x6c},
+	{ DRV260X_FEEDBACK_CTRL, 0x36},
+	{ DRV260X_CTRL1, 0x93},
+	{ DRV260X_CTRL2, 0xfa},
+	{ DRV260X_CTRL3, 0xa0},
+	{ DRV260X_CTRL4, 0x20},
+	{ DRV260X_CTRL5, 0x80},
+	{ DRV260X_LRA_LOOP_PERIOD, 0x33},
+	{ DRV260X_VBAT_MON, 0x00},
+	{ DRV260X_LRA_RES_PERIOD, 0x00},
+};
+
+/**
+ * Rated and Overdriver Voltages:
+ * Calculated using the formula r = v * 255 / 5.6
+ * where r is what will be written to the register
+ * and v is the rated or overdriver voltage of the actuator
+ **/
+#define DRV260X_DEF_RATED_VOLT		0x90
+#define DRV260X_DEF_OD_CLAMP_VOLT	0x90
+
+static int drv260x_calculate_voltage(int voltage)
+{
+	return (voltage * 255 / 5600);
+}
+
+static void drv260x_worker(struct work_struct *work)
+{
+	struct drv260x_data *haptics = container_of(work, struct drv260x_data, work);
+	int ret;
+
+	gpiod_set_value(haptics->enable_gpio, 1);
+	/* Data sheet says to wait 250us before trying to communicate */
+	udelay(250);
+
+	ret = regmap_write(haptics->regmap, DRV260X_MODE, DRV260X_RT_PLAYBACK);
+	if (ret != 0) {
+		dev_err(&haptics->client->dev,
+			"Failed to write set mode: %d\n", ret);
+		return;
+	}
+
+	ret = regmap_write(haptics->regmap, DRV260X_RT_PB_IN, haptics->magnitude);
+	if (ret != 0) {
+		dev_err(&haptics->client->dev,
+			"Failed to set magnitude: %d\n", ret);
+	}
+}
+
+static int drv260x_haptics_play(struct input_dev *input, void *data,
+				struct ff_effect *effect)
+{
+	struct drv260x_data *haptics = input_get_drvdata(input);
+
+	haptics->mode = DRV260X_LRA_NO_CAL_MODE;
+	haptics->magnitude = 0;
+
+	if (effect->u.rumble.strong_magnitude ||
+		effect->u.rumble.weak_magnitude) {
+		if (effect->u.rumble.strong_magnitude > 0)
+			haptics->magnitude = effect->u.rumble.strong_magnitude;
+		else if	(effect->u.rumble.weak_magnitude > 0)
+			haptics->magnitude = effect->u.rumble.weak_magnitude;
+	}
+
+	schedule_work(&haptics->work);
+
+	return 0;
+}
+
+static void drv260x_close(struct input_dev *input)
+{
+	struct drv260x_data *haptics = input_get_drvdata(input);
+	int ret;
+
+	cancel_work_sync(&haptics->work);
+
+	ret = regmap_write(haptics->regmap, DRV260X_MODE, DRV260X_STANDBY);
+	if (ret != 0) {
+		dev_err(&haptics->client->dev,
+			"Failed to write standby mode: %d\n", ret);
+	}
+
+	gpiod_set_value(haptics->enable_gpio, 0);
+}
+
+static const struct reg_default drv260x_lra_cal_regs[] = {
+	{ DRV260X_MODE, DRV260X_AUTO_CAL },
+	{ DRV260X_CTRL3, DRV260X_NG_THRESH_2},
+	{ DRV260X_FEEDBACK_CTRL, DRV260X_FB_REG_LRA_MODE | DRV260X_BRAKE_FACTOR_4X | DRV260X_LOOP_GAIN_HIGH },
+};
+
+static const struct reg_default drv260x_lra_init_regs[] = {
+	{ DRV260X_MODE, DRV260X_RT_PLAYBACK},
+	{ DRV260X_A_TO_V_CTRL, DRV260X_AUDIO_HAPTICS_PEAK_20MS | DRV260X_AUDIO_HAPTICS_FILTER_125HZ},
+	{ DRV260X_A_TO_V_MIN_INPUT, DRV260X_AUDIO_HAPTICS_MIN_IN_VOLT },
+	{ DRV260X_A_TO_V_MAX_INPUT, DRV260X_AUDIO_HAPTICS_MAX_IN_VOLT },
+	{ DRV260X_A_TO_V_MIN_OUT, DRV260X_AUDIO_HAPTICS_MIN_OUT_VOLT },
+	{ DRV260X_A_TO_V_MAX_OUT, DRV260X_AUDIO_HAPTICS_MAX_OUT_VOLT },
+	{ DRV260X_FEEDBACK_CTRL, DRV260X_FB_REG_LRA_MODE | DRV260X_BRAKE_FACTOR_2X | DRV260X_LOOP_GAIN_MED | DRV260X_BEMF_GAIN_3 },
+	{ DRV260X_CTRL1, DRV260X_STARTUP_BOOST },
+	{ DRV260X_CTRL2, DRV260X_SAMP_TIME_250 },
+	{ DRV260X_CTRL3, DRV260X_NG_THRESH_2 | DRV260X_ANANLOG_IN },
+	{ DRV260X_CTRL4, DRV260X_AUTOCAL_TIME_500MS },
+};
+
+static const struct reg_default drv260x_erm_cal_regs[] = {
+	{ DRV260X_MODE, DRV260X_AUTO_CAL },
+	{ DRV260X_A_TO_V_MIN_INPUT, DRV260X_AUDIO_HAPTICS_MIN_IN_VOLT },
+	{ DRV260X_A_TO_V_MAX_INPUT, DRV260X_AUDIO_HAPTICS_MAX_IN_VOLT },
+	{ DRV260X_A_TO_V_MIN_OUT, DRV260X_AUDIO_HAPTICS_MIN_OUT_VOLT },
+	{ DRV260X_A_TO_V_MAX_OUT, DRV260X_AUDIO_HAPTICS_MAX_OUT_VOLT },
+	{ DRV260X_FEEDBACK_CTRL, DRV260X_BRAKE_FACTOR_3X | DRV260X_LOOP_GAIN_MED | DRV260X_BEMF_GAIN_2 },
+	{ DRV260X_CTRL1, DRV260X_STARTUP_BOOST },
+	{ DRV260X_CTRL2, DRV260X_SAMP_TIME_250 | DRV260X_BLANK_TIME_75 | DRV260X_SAMP_TIME_250 | DRV260X_IDISS_TIME_75 },
+	{ DRV260X_CTRL3, DRV260X_NG_THRESH_2 | DRV260X_ERM_OPEN_LOOP },
+	{ DRV260X_CTRL4, DRV260X_AUTOCAL_TIME_500MS },
+};
+
+static int drv260x_init(struct drv260x_data *haptics)
+{
+	int ret;
+	unsigned int cal_buf;
+
+	ret = regmap_write(haptics->regmap,
+			   DRV260X_RATED_VOLT, haptics->rated_voltage);
+	if (ret != 0)
+		goto write_failure;
+
+	ret = regmap_write(haptics->regmap,
+			   DRV260X_OD_CLAMP_VOLT, haptics->overdrive_voltage);
+	if (ret != 0)
+		goto write_failure;
+
+	switch(haptics->mode) {
+	case DRV260X_LRA_MODE:
+		ret = regmap_register_patch(haptics->regmap,
+					drv260x_lra_cal_regs,
+					ARRAY_SIZE(drv260x_lra_cal_regs));
+		if (ret != 0)
+			goto write_failure;
+		break;
+	case DRV260X_ERM_MODE:
+		ret = regmap_register_patch(haptics->regmap,
+					drv260x_erm_cal_regs,
+					ARRAY_SIZE(drv260x_erm_cal_regs));
+		if (ret != 0)
+			goto write_failure;
+
+		ret = regmap_update_bits(haptics->regmap, DRV260X_LIB_SEL,
+					DRV260X_LIB_SEL_MASK,
+					haptics->library);
+		if (ret != 0)
+			goto write_failure;
+		break;
+	default:
+		ret = regmap_register_patch(haptics->regmap,
+					drv260x_lra_init_regs,
+					ARRAY_SIZE(drv260x_lra_init_regs));
+		if (ret != 0)
+			goto write_failure;
+
+		ret = regmap_update_bits(haptics->regmap, DRV260X_LIB_SEL,
+					DRV260X_LIB_SEL_MASK,
+					haptics->library);
+		if (ret != 0)
+			goto write_failure;
+
+		goto skip_go_bit;
+		break;
+	}
+
+	if (ret != 0) {
+		dev_err(&haptics->client->dev,
+			"Failed to write init registers: %d\n",
+			ret);
+		goto write_failure;
+	}
+
+	ret = regmap_write(haptics->regmap, DRV260X_GO, DRV260X_GO_BIT);
+	if (ret != 0)
+		goto write_failure;
+
+	do {
+		ret = regmap_read(haptics->regmap, DRV260X_GO, &cal_buf);
+		if (ret != 0)
+			goto write_failure;
+	} while (cal_buf == DRV260X_GO_BIT || ret != 0);
+
+	return ret;
+
+write_failure:
+	dev_err(&haptics->client->dev,
+		"Failed to write init registers: %d\n",
+		ret);
+skip_go_bit:
+	return ret;
+}
+
+static const struct regmap_config drv260x_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = DRV260X_MAX_REG,
+	.reg_defaults = drv260x_reg_defs,
+	.num_reg_defaults = ARRAY_SIZE(drv260x_reg_defs),
+	.cache_type = REGCACHE_NONE,
+};
+
+#ifdef CONFIG_OF
+static int drv260x_parse_dt(struct device_node *dev_node,
+				struct drv260x_data *haptics,
+				struct device *dev)
+{
+	int ret;
+	int voltage;
+
+	ret = of_property_read_u32(dev_node, "mode", &haptics->mode);
+	if (ret < 0) {
+		dev_err(dev, "%s: No entry for mode\n", __func__);
+
+		return ret;
+	}
+	ret = of_property_read_u32(dev_node, "library-sel",
+				&haptics->library);
+	if (ret < 0) {
+		dev_err(dev, "%s: No entry for library selection\n",
+			__func__);
+
+		return ret;
+	}
+	ret = of_property_read_u32(dev_node, "vib-rated-voltage",
+				&voltage);
+	if (!ret)
+		haptics->rated_voltage = drv260x_calculate_voltage(voltage);
+
+
+	ret = of_property_read_u32(dev_node, "vib-overdrive-voltage",
+				&voltage);
+	if (!ret)
+		haptics->overdrive_voltage = drv260x_calculate_voltage(voltage);
+
+	return ret;
+
+}
+#else
+static inline int drv260x_parse_dt(struct device *dev)
+{
+	dev_err(dev, "no platform data defined\n");
+
+	return -EINVAL;
+}
+#endif
+static int drv260x_probe(struct i2c_client *client,
+			   const struct i2c_device_id *id)
+{
+	struct drv260x_data *haptics;
+	struct device_node *np = client->dev.of_node;
+	struct drv260x_platform_data *pdata = dev_get_platdata(&client->dev);
+	int ret;
+
+	haptics = devm_kzalloc(&client->dev, sizeof(*haptics), GFP_KERNEL);
+	if (!haptics)
+		return -ENOMEM;
+
+	haptics->rated_voltage = DRV260X_DEF_OD_CLAMP_VOLT;
+	haptics->rated_voltage = DRV260X_DEF_RATED_VOLT;
+
+	 if (pdata) {
+		haptics->mode = pdata->mode;
+		haptics->library = pdata->library_selection;
+		if (pdata->vib_overdrive_voltage)
+			haptics->overdrive_voltage = drv260x_calculate_voltage(pdata->vib_overdrive_voltage);
+		if (pdata->vib_rated_voltage)
+			haptics->rated_voltage = drv260x_calculate_voltage(pdata->vib_rated_voltage);
+	} else if (np) {
+		ret = drv260x_parse_dt(np, haptics, &client->dev);
+		if (ret)
+			return ret;
+	} else {
+		dev_err(&client->dev, "Platform data not set\n");
+		return -ENODEV;
+	}
+
+
+	if (haptics->mode < DRV260X_LRA_MODE ||
+	    haptics->mode > DRV260X_ERM_MODE) {
+		dev_err(&client->dev,
+			"Vibrator mode is invalid: %i\n",
+			haptics->mode);
+		return -EINVAL;
+	}
+	
+	if (haptics->library < DRV260X_LIB_SEL_DEFAULT ||
+	    haptics->library > DRV260X_LIB_F) {
+		dev_err(&client->dev,
+			"Library value is invalid: %i\n", haptics->library);
+		return -EINVAL;
+	}	
+
+	haptics->regulator = devm_regulator_get(&client->dev, "vbat");
+	if (IS_ERR(haptics->regulator)) {
+		ret = PTR_ERR(haptics->regulator);
+		dev_err(&client->dev,
+			"unable to get regulator, error: %d\n", ret);
+		return ret;
+	}
+
+	haptics->enable_gpio = devm_gpiod_get(&client->dev, "enable");
+	if (IS_ERR(haptics->enable_gpio)) {
+		ret = PTR_ERR(haptics->enable_gpio);
+		if (ret != -ENOENT && ret != -ENOSYS)
+			return ret;
+		haptics->enable_gpio = NULL;
+	} else {
+		gpiod_direction_output(haptics->enable_gpio, 1);
+	}
+
+	haptics->input_dev = devm_input_allocate_device(&client->dev);
+	if (haptics->input_dev == NULL) {
+		dev_err(&client->dev, "Failed to allocate input device\n");
+		ret = -ENOMEM;
+		return ret;
+	}
+
+	haptics->input_dev->name = "drv260x:haptics";
+	haptics->input_dev->dev.parent = client->dev.parent;
+	haptics->input_dev->close = drv260x_close;
+	input_set_drvdata(haptics->input_dev, haptics);
+	input_set_capability(haptics->input_dev, EV_FF, FF_RUMBLE);
+
+	ret = input_ff_create_memless(haptics->input_dev, NULL,
+				      drv260x_haptics_play);
+	if (ret < 0) {
+		dev_err(&client->dev, "input_ff_create() failed: %d\n",
+			ret);
+		return ret;
+	}
+
+	INIT_WORK(&haptics->work, drv260x_worker);
+
+	haptics->client = client;
+	i2c_set_clientdata(client, haptics);
+
+	haptics->regmap = devm_regmap_init_i2c(client, &drv260x_regmap_config);
+	if (IS_ERR(haptics->regmap)) {
+		ret = PTR_ERR(haptics->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	ret = drv260x_init(haptics);
+	if (ret < 0) {
+		dev_err(&client->dev, "Device init failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = input_register_device(haptics->input_dev);
+	if (ret < 0) {
+		dev_err(&client->dev, "couldn't register input device: %d\n",
+			ret);
+		return ret;
+	}
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int drv260x_suspend(struct device *dev)
+{
+	struct drv260x_data *haptics = dev_get_drvdata(dev);
+	int ret = 0;
+
+	mutex_lock(&haptics->input_dev->mutex);
+
+	if (haptics->input_dev->users) {
+		ret = regmap_update_bits(haptics->regmap,
+				   DRV260X_MODE,
+				   DRV260X_STANDBY_MASK,
+				   DRV260X_STANDBY);
+		if (ret) {
+			dev_err(dev, "Failed to set standby mode\n");
+			goto out;
+		}
+
+		gpiod_set_value(haptics->enable_gpio, 0);
+
+		ret = regulator_disable(haptics->regulator);
+		if (ret)
+			dev_err(dev, "Failed to disable regulator\n");
+	}
+out:
+	mutex_unlock(&haptics->input_dev->mutex);
+	return ret;
+}
+
+static int drv260x_resume(struct device *dev)
+{
+	struct drv260x_data *haptics = dev_get_drvdata(dev);
+	int ret = 0;
+
+	mutex_lock(&haptics->input_dev->mutex);
+
+	if (haptics->input_dev->users) {
+		ret = regulator_enable(haptics->regulator);
+		if (ret) {
+			dev_err(dev, "Failed to enable regulator\n");
+			goto out;
+		}
+		ret = regmap_update_bits(haptics->regmap,
+				   DRV260X_MODE,
+				   DRV260X_STANDBY_MASK, 0);
+		if (ret) {
+			dev_err(dev, "Failed to unset standby mode\n");
+			goto out;
+		}
+
+		gpiod_set_value(haptics->enable_gpio, 1);
+	}
+
+out:
+	mutex_unlock(&haptics->input_dev->mutex);
+	return ret;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(drv260x_pm_ops, drv260x_suspend, drv260x_resume);
+
+static const struct i2c_device_id drv260x_id[] = {
+	{ "drv2605l", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, drv260x_id);
+
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id drv260x_of_match[] = {
+	{ .compatible = "ti,drv2604", },
+	{ .compatible = "ti,drv2604l", },
+	{ .compatible = "ti,drv2605", },
+	{ .compatible = "ti,drv2605l", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, drv260x_of_match);
+#endif
+
+static struct i2c_driver drv260x_driver = {
+	.probe		= drv260x_probe,
+	.driver		= {
+		.name	= "drv260x-haptics",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(drv260x_of_match),
+		.pm	= &drv260x_pm_ops,
+	},
+	.id_table = drv260x_id,
+};
+module_i2c_driver(drv260x_driver);
+
+MODULE_ALIAS("platform:drv260x-haptics");
+MODULE_DESCRIPTION("TI DRV260x haptics driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dan Murphy <dmurphy@ti.com>");
diff --git a/include/dt-bindings/input/ti-drv260x.h b/include/dt-bindings/input/ti-drv260x.h
new file mode 100644
index 0000000..be7f245
--- /dev/null
+++ b/include/dt-bindings/input/ti-drv260x.h
@@ -0,0 +1,35 @@
+/*
+ * DRV260X haptics driver family
+ *
+ * Author: Dan Murphy <dmurphy@ti.com>
+ *
+ * Copyright:   (C) 2014 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_TI_DRV260X_H
+#define _DT_BINDINGS_TI_DRV260X_H
+
+/* Calibration Types */
+#define DRV260X_LRA_MODE		0x00
+#define DRV260X_LRA_NO_CAL_MODE	0x01
+#define DRV260X_ERM_MODE		0x02
+
+/* Library Selection */
+#define DRV260X_LIB_SEL_DEFAULT		0x00
+#define DRV260X_LIB_A				0x01
+#define DRV260X_LIB_B				0x02
+#define DRV260X_LIB_C				0x03
+#define DRV260X_LIB_D				0x04
+#define DRV260X_LIB_E				0x05
+#define DRV260X_LIB_F				0x06
+
+#endif
diff --git a/include/linux/platform_data/drv260x-pdata.h b/include/linux/platform_data/drv260x-pdata.h
new file mode 100644
index 0000000..4091a9b
--- /dev/null
+++ b/include/linux/platform_data/drv260x-pdata.h
@@ -0,0 +1,29 @@
+/*
+ * Platform data for DRV260X haptics driver family
+ *
+ * Author: Dan Murphy <dmurphy@ti.com>
+ *
+ * Copyright:   (C) 2014 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _LINUX_DRV260X_PDATA_H
+#define _LINUX_DRV260X_PDATA_H
+
+struct drv260x_platform_data {
+	int enable_gpio;
+	u32 library_selection;
+	u32 mode;
+	u32 vib_rated_voltage;
+	u32 vib_overdrive_voltage;
+};
+
+#endif
-- 
1.7.9.5

