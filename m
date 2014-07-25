Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbaGYSSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:18:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57909 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758149AbaGYSST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:18:19 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: drv260x: Introduce TI drv260x haptics driver
Thread-Topic: [PATCH] input: drv260x: Introduce TI drv260x haptics driver
Thread-Index: AQHPp3KVaTeYIaoCGkGdt9wpRg+DIQ==
Date: Fri, 25 Jul 2014 18:18:17 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DA8C5F@DFLE09.ent.ti.com>
References: <1406228875-21539-1-git-send-email-dmurphy@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 02:07 PM, Murphy, Dan wrote:
> Add the TI drv260x haptics/vibrator driver.
> This device uses the input force feedback
> to produce a wave form to driver an
> ERM or LRA actuator device.
>
> The initial driver supports the devices
> real time playback mode.  But the device
> has additional wave patterns in ROM.
>
> This functionality will be added in
> future patchsets.
>
> Product data sheet is located here:
> http://www.ti.com/product/drv2605
>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/input/ti,drv260x.txt       |   44 ++
>  drivers/input/misc/Kconfig                         |    9 +
>  drivers/input/misc/Makefile                        |    1 +
>  drivers/input/misc/drv260x.c                       |  537 ++++++++++++++++++++
>  include/dt-bindings/input/ti-drv260x.h             |   30 ++
>  include/linux/input/drv260x.h                      |  181 +++++++
>  6 files changed, 802 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/ti,drv260x.txt
>  create mode 100644 drivers/input/misc/drv260x.c
>  create mode 100644 include/dt-bindings/input/ti-drv260x.h
>  create mode 100644 include/linux/input/drv260x.h
>
> diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/Documentation/devicetree/bindings/input/ti,drv260x.txt
> new file mode 100644
> index 0000000..0860661
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
> @@ -0,0 +1,44 @@
> +Texas Instruments - drv260x Haptics driver family
> +
> +The drv260x family serial control bus communicates through I2C protocols
> +
> +Required properties:
> +	- compatible - One of:
> +		"ti,drv2604" - DRV2604
> +		"ti,drv2605" - DRV2605
> +		"ti,drv2605l" - DRV2605L
> +	- reg -  I2C slave address
> +	- mode - Power up mode of the chip (defined in include/dt-bindings/input/ti-drv260x.h)
> +		DRV260X_RTP_MODE - Real time playback mode
> +		DRV260X_LRA_MODE - Linear Resonance Actuator mode (Piezoelectric)
> +		DRV260X_ERM_MODE - Eccentric Rotating Mass mode (Rotary vibrator)
> +	- library_sel - Library to use at power up (defined in include/dt-bindings/input/ti-drv260x.h)
> +		DRV260X_LIB_A - Pre-programmed Library
> +		DRV260X_LIB_B - Pre-programmed Library
> +		DRV260X_LIB_C - Pre-programmed Library
> +		DRV260X_LIB_D - Pre-programmed Library
> +		DRV260X_LIB_E - Pre-programmed Library
> +		DRV260X_LIB_F - Pre-programmed Library
> +
> +Optional properties:
> +	- enable-gpio - gpio pin to enable/disable the device.
> +	- vib_rated_voltage - The rated voltage of the actuator.  If this is not
> +						  set then the value will be defaulted to 0x90 in the
> +						  driver.
> +	- vib_overdrive_voltage - The overdrive voltage of the actuator.
> +							If this is not set then the value
> +							will be defaulted to 0x90 in the driver.
> +Example:
> +
> +drv2605l: drv2605l@41 {

This needs to be updated

> +		compatible = "ti,drv2605l";
> +		reg = <0x5a>;
> +		enable-gpio = <&gpio1 28 GPIO_ACTIVE_HIGH>;  /* GPIO 60 */
> +		mode = <DRV260X_RTP_MODE>;
> +		library_sel = <DRV260X_LIB_SEL_DEFAULT>;
> +		vib_rated_voltage = <3200>;
> +		vib_overdriver_voltage = <3200>;
> +};
> +
> +For more product information please see the link below:
> +http://www.ti.com/product/drv2605
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 2ff4425..99f6762 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -676,4 +676,13 @@ config INPUT_SOC_BUTTON_ARRAY
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called soc_button_array.
>  
> +config INPUT_DRV260X_HAPTICS
> +	tristate "TI DRV260X haptics support"
> +	depends on INPUT && I2C
> +	help
> +	  Say Y to enable support for the TI DRV260X haptics driver.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called drv260x-haptics.
> +
>  endif
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 4955ad3..d8ef3c7 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -64,3 +64,4 @@ obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
>  obj-$(CONFIG_INPUT_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
>  obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
>  obj-$(CONFIG_INPUT_IDEAPAD_SLIDEBAR)	+= ideapad_slidebar.o
> +obj-$(CONFIG_INPUT_DRV260X_HAPTICS)	+= drv260x.o
> diff --git a/drivers/input/misc/drv260x.c b/drivers/input/misc/drv260x.c
> new file mode 100644
> index 0000000..aadfd57
> --- /dev/null
> +++ b/drivers/input/misc/drv260x.c
> @@ -0,0 +1,537 @@
> +/*
> + * drv260x.c - DRV260X haptics driver family
> + *
> + * Author: Dan Murphy <dmurphy@ti.com>
> + *
> + * Copyright:   (C) 2014 Texas Instruments, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/input.h>
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/regulator/consumer.h>
> +
> +#include <linux/input/drv260x.h>
> +#include <dt-bindings/input/ti-drv260x.h>
> +
> +#define DRV260X_MAX_EFFECTS	255
> +
> +/**
> + * struct drv260x_data -
> + * @input_dev - Pointer to the input device
> + * @client - Pointer to the I2C client
> + * @timer - High res timer used to turn on/off vibration
> + * @regmap - Register map of the device
> + * @lock - Lock for device access
> + * @work - Work item used to off load the enable/disable of the vibration
> + * @enable_gpio - Pointer to the gpio used for enable/disabling
> + * @regulator - Pointer to the regulator for the IC
> + * @upload_effects - Vibration effect data array
> + * @runtime_left - Indicates how much runtime is remaining in the timer
> + * @effect_id - The ID of the vibration effect requested to be played
> + * @mode - The operating mode of the IC (RTP, ERM or LRA)
> + * @library - The vibration library to be used
> + * @rated_voltage - The rated_voltage of the actuator
> + * @overdriver_voltage - The over drive voltage of the actuator
> +**/
> +struct drv260x_data {
> +	struct input_dev *input_dev;
> +	struct i2c_client *client;
> +	struct hrtimer timer;
> +	struct regmap *regmap;
> +	struct mutex lock;
> +	struct work_struct work;
> +	struct gpio_desc *enable_gpio;
> +	struct regulator *regulator;
> +	struct ff_effect upload_effects[DRV260X_MAX_EFFECTS];
> +	u32 runtime_left;
> +	u32 effect_id;
> +	int mode;
> +	int library;
> +	int rated_voltage;
> +	int overdrive_voltage;
> +};
> +
> +static struct reg_default drv260x_reg_defs[] = {
> +	{ DRV260X_STATUS, 0xe0 },
> +	{ DRV260X_MODE, 0x40 },
> +	{ DRV260X_RT_PB_IN, 0x00},
> +	{ DRV260X_LIB_SEL, 0x00},
> +	{ DRV260X_WV_SEQ_1, 0x01},
> +	{ DRV260X_WV_SEQ_2, 0x00},
> +	{ DRV260X_WV_SEQ_3, 0x00},
> +	{ DRV260X_WV_SEQ_4, 0x00},
> +	{ DRV260X_WV_SEQ_5, 0x00},
> +	{ DRV260X_WV_SEQ_6, 0x00},
> +	{ DRV260X_WV_SEQ_7, 0x00},
> +	{ DRV260X_WV_SEQ_8, 0x00},
> +	{ DRV260X_GO, 0x00},
> +	{ DRV260X_OVERDRIVE_OFF, 0x00},
> +	{ DRV260X_SUSTAIN_P_OFF, 0x00},
> +	{ DRV260X_SUSTAIN_N_OFF, 0x00},
> +	{ DRV260X_BRAKE_OFF	, 0x00},
> +	{ DRV260X_A_TO_V_CTRL	, 0x05},
> +	{ DRV260X_A_TO_V_MIN_INPUT, 0x19},
> +	{ DRV260X_A_TO_V_MAX_INPUT, 0xff},
> +	{ DRV260X_A_TO_V_MIN_OUT, 0x19},
> +	{ DRV260X_A_TO_V_MAX_OUT, 0xff},
> +	{ DRV260X_RATED_VOLT, 0x3e},
> +	{ DRV260X_OD_CLAMP_VOLT, 0x8c},
> +	{ DRV260X_CAL_COMP, 0x0c},
> +	{ DRV260X_CAL_BACK_EMF, 0x6c},
> +	{ DRV260X_FEEDBACK_CTRL, 0x36},
> +	{ DRV260X_CTRL1, 0x93},
> +	{ DRV260X_CTRL2, 0xfa},
> +	{ DRV260X_CTRL3, 0xa0},
> +	{ DRV260X_CTRL4, 0x20},
> +	{ DRV260X_CTRL5, 0x80},
> +	{ DRV260X_LRA_LOOP_PERIOD, 0x33},
> +	{ DRV260X_VBAT_MON, 0x00},
> +	{ DRV260X_LRA_RES_PERIOD, 0x00},
> +};
> +
> +/**
> + * Rated and Overdriver Voltages:
> + * Calculated using the formula r = v * 255 / 5.6
> + * where r is what will be written to the register
> + * and v is the rated or overdriver voltage of the actuator
> + **/
> +#define DRV260X_DEF_RATED_VOLT		0x90
> +#define DRV260X_DEF_OD_CLAMP_VOLT	0x90
> +
> +static int drv260x_calculate_voltage(int voltage)
> +{
> +	return (voltage * 255 / 5600);
> +}
> +
> +static void drv260x_worker(struct work_struct *work)
> +{
> +	struct drv260x_data *haptics = container_of(work, struct drv260x_data, work);
> +	int effect_id = haptics->effect_id;
> +	int magnitude;
> +
> +	mutex_lock(&haptics->lock);
> +
> +	if (haptics->upload_effects[effect_id].u.rumble.strong_magnitude > 0)
> +		magnitude = haptics->upload_effects[effect_id].u.rumble.strong_magnitude;
> +	else if	(haptics->upload_effects[effect_id].u.rumble.weak_magnitude > 0)
> +		magnitude = haptics->upload_effects[effect_id].u.rumble.weak_magnitude;
> +	else
> +		goto out;
> +
> +	if (haptics->runtime_left > 0)
> +		regmap_write(haptics->regmap, DRV260X_RT_PB_IN,	magnitude);
> +	else
> +		regmap_write(haptics->regmap, DRV260X_RT_PB_IN, 0x0);
> +
> +out:
> +	mutex_unlock(&haptics->lock);
> +}
> +
> +static enum hrtimer_restart drv260x_timer(struct hrtimer *timer)
> +{
> +	struct drv260x_data *data = container_of(timer, struct drv260x_data, timer);
> +
> +	data->runtime_left = 0;
> +	schedule_work(&data->work);
> +
> +	return HRTIMER_NORESTART;
> +}
> +
> +static int drv260x_playback(struct input_dev *input, int effect_id, int value)
> +{
> +	struct drv260x_data *haptics = input_get_drvdata(input);
> +	unsigned long time_ms;
> +
> +	gpiod_set_value(haptics->enable_gpio, 1);
> +	/* Data sheet says to wait 250us before trying to communicate */
> +	udelay(250);
> +
> +	regmap_write(haptics->regmap, DRV260X_MODE, DRV260X_RT_PLAYBACK);
> +
> +	haptics->mode = DRV260X_RTP_MODE;
> +	haptics->runtime_left = haptics->upload_effects[effect_id].replay.length;
> +	haptics->effect_id = effect_id;
> +
> +	time_ms = haptics->runtime_left * NSEC_PER_MSEC;
> +
> +	schedule_work(&haptics->work);
> +	hrtimer_start(&haptics->timer, ktime_set(0, time_ms), HRTIMER_MODE_REL);
> +
> +	return 0;
> +}
> +
> +static int drv260x_upload_effect(struct input_dev *input,
> +				 struct ff_effect *effect,
> +				 struct ff_effect *old)
> +{
> +	struct drv260x_data *haptics = input_get_drvdata(input);
> +
> +	haptics->upload_effects[effect->id] = *effect;
> +
> +	return 0;
> +}
> +
> +static void drv260x_close(struct input_dev *input)
> +{
> +	struct drv260x_data *haptics = input_get_drvdata(input);
> +
> +	cancel_work_sync(&haptics->work);
> +	regmap_write(haptics->regmap, DRV260X_MODE, DRV260X_STANDBY);
> +	gpiod_set_value(haptics->enable_gpio, 0);
> +}
> +
> +static const struct reg_default drv260x_lra_cal_regs[] = {
> +	{ DRV260X_MODE, DRV260X_AUTO_CAL },
> +	{ DRV260X_CTRL3, DRV260X_NG_THRESH_2},
> +	{ DRV260X_FEEDBACK_CTRL, DRV260X_FB_REG_LRA_MODE | DRV260X_BRAKE_FACTOR_4X | DRV260X_LOOP_GAIN_HIGH },
> +};
> +
> +static const struct reg_default drv260x_lra_init_regs[] = {
> +	{ DRV260X_MODE, DRV260X_RT_PLAYBACK},
> +	{ DRV260X_LIB_SEL, DRV260X_LIB_F },
> +	{ DRV260X_A_TO_V_CTRL, DRV260X_AUDIO_HAPTICS_PEAK_20MS | DRV260X_AUDIO_HAPTICS_FILTER_125HZ},
> +	{ DRV260X_A_TO_V_MIN_INPUT, DRV260X_AUDIO_HAPTICS_MIN_IN_VOLT },
> +	{ DRV260X_A_TO_V_MAX_INPUT, DRV260X_AUDIO_HAPTICS_MAX_IN_VOLT },
> +	{ DRV260X_A_TO_V_MIN_OUT, DRV260X_AUDIO_HAPTICS_MIN_OUT_VOLT },
> +	{ DRV260X_A_TO_V_MAX_OUT, DRV260X_AUDIO_HAPTICS_MAX_OUT_VOLT },
> +	{ DRV260X_FEEDBACK_CTRL, DRV260X_FB_REG_LRA_MODE | DRV260X_BRAKE_FACTOR_2X | DRV260X_LOOP_GAIN_MED | DRV260X_BEMF_GAIN_3 },
> +	{ DRV260X_CTRL1, DRV260X_STARTUP_BOOST },
> +	{ DRV260X_CTRL2, DRV260X_SAMP_TIME_250 },
> +	{ DRV260X_CTRL3, DRV260X_NG_THRESH_2 | DRV260X_ANANLOG_IN },
> +	{ DRV260X_CTRL4, DRV260X_AUTOCAL_TIME_500MS },
> +};
> +
> +static const struct reg_default drv260x_erm_cal_regs[] = {
> +	{ DRV260X_MODE, DRV260X_AUTO_CAL },
> +	{ DRV260X_A_TO_V_MIN_INPUT, DRV260X_AUDIO_HAPTICS_MIN_IN_VOLT },
> +	{ DRV260X_A_TO_V_MAX_INPUT, DRV260X_AUDIO_HAPTICS_MAX_IN_VOLT },
> +	{ DRV260X_A_TO_V_MIN_OUT, DRV260X_AUDIO_HAPTICS_MIN_OUT_VOLT },
> +	{ DRV260X_A_TO_V_MAX_OUT, DRV260X_AUDIO_HAPTICS_MAX_OUT_VOLT },
> +	{ DRV260X_FEEDBACK_CTRL, DRV260X_BRAKE_FACTOR_3X | DRV260X_LOOP_GAIN_MED | DRV260X_BEMF_GAIN_2 },
> +	{ DRV260X_CTRL1, DRV260X_STARTUP_BOOST },
> +	{ DRV260X_CTRL2, DRV260X_SAMP_TIME_250 | DRV260X_BLANK_TIME_75 | DRV260X_SAMP_TIME_250 | DRV260X_IDISS_TIME_75 },
> +	{ DRV260X_CTRL3, DRV260X_NG_THRESH_2 | DRV260X_ERM_OPEN_LOOP },
> +	{ DRV260X_CTRL4, DRV260X_AUTOCAL_TIME_500MS },
> +};
> +
> +static int drv260x_init(struct drv260x_data *haptics)
> +{
> +	int ret;
> +	unsigned int cal_buf;
> +
> +	ret = regmap_write(haptics->regmap,
> +			   DRV260X_RATED_VOLT, haptics->rated_voltage);
> +	if (ret != 0)
> +		goto write_failure;
> +
> +	ret = regmap_write(haptics->regmap,
> +			   DRV260X_OD_CLAMP_VOLT, haptics->overdrive_voltage);
> +	if (ret != 0)
> +		goto write_failure;
> +
> +	if (haptics->mode == DRV260X_LRA_MODE) {
> +		ret = regmap_register_patch(haptics->regmap,
> +					drv260x_lra_cal_regs,
> +					ARRAY_SIZE(drv260x_lra_cal_regs));
> +		if (ret != 0)
> +			goto write_failure;
> +
> +	} else if (haptics->mode == DRV260X_ERM_MODE) {
> +		ret = regmap_register_patch(haptics->regmap,
> +					drv260x_erm_cal_regs,
> +					ARRAY_SIZE(drv260x_erm_cal_regs));
> +		if (ret != 0)
> +			goto write_failure;
> +
> +		ret = regmap_update_bits(haptics->regmap, DRV260X_LIB_SEL,
> +					DRV260X_LIB_SEL_MASK,
> +					haptics->library);
> +		if (ret != 0)
> +			goto write_failure;
> +
> +	} else {
> +		ret = regmap_register_patch(haptics->regmap,
> +					drv260x_lra_init_regs,
> +					ARRAY_SIZE(drv260x_lra_init_regs));
> +		if (ret != 0)
> +			goto write_failure;
> +
> +		goto skip_go_bit;
> +	}
> +
> +	if (ret != 0) {
> +		dev_err(&haptics->client->dev,
> +			"Failed to write init registers: %d\n",
> +			ret);
> +		goto write_failure;
> +	}
> +
> +	ret = regmap_write(haptics->regmap, DRV260X_GO, DRV260X_GO_BIT);
> +	if (ret != 0)
> +		goto write_failure;
> +
> +	do {
> +		ret = regmap_read(haptics->regmap, DRV260X_GO, &cal_buf);
> +		if (ret != 0)
> +			goto write_failure;
> +	} while (cal_buf == DRV260X_GO_BIT || ret != 0);
> +
> +	return ret;
> +
> +write_failure:
> +	dev_err(&haptics->client->dev,
> +		"Failed to write init registers: %d\n",
> +		ret);
> +skip_go_bit:
> +	return ret;
> +}
> +
> +static const struct regmap_config drv260x_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = DRV260X_MAX_REG,
> +	.reg_defaults = drv260x_reg_defs,
> +	.num_reg_defaults = ARRAY_SIZE(drv260x_reg_defs),
> +	.cache_type = REGCACHE_NONE,
> +};
> +
> +static int drv260x_probe(struct i2c_client *client,
> +			   const struct i2c_device_id *id)
> +{
> +	struct drv260x_data *haptics;
> +	struct device_node *np = client->dev.of_node;
> +	struct drv260x_platform_data *pdata = client->dev.platform_data;
> +	struct ff_device *ff;
> +	int ret;
> +	int voltage;
> +
> +	haptics = devm_kzalloc(&client->dev, sizeof(*haptics), GFP_KERNEL);
> +	if (!haptics)
> +		return -ENOMEM;
> +
> +	haptics->rated_voltage = DRV260X_DEF_OD_CLAMP_VOLT;
> +	haptics->rated_voltage = DRV260X_DEF_RATED_VOLT;
> +
> +	if (np) {
> +		ret = of_property_read_u32(np, "mode", &haptics->mode);
> +		if (ret < 0) {
> +			dev_err(&client->dev,
> +				"%s: No entry for mode\n", __func__);
> +
> +			return ret;
> +		}
> +		ret = of_property_read_u32(np, "library_sel",
> +					&haptics->library);
> +		if (ret < 0) {
> +			dev_err(&client->dev,
> +				"%s: No entry for library selection\n", __func__);
> +
> +			return ret;
> +		}
> +		ret = of_property_read_u32(np, "vib_rated_voltage",
> +					&voltage);
> +		if (!ret)
> +			haptics->rated_voltage = drv260x_calculate_voltage(voltage);
> +
> +
> +		ret = of_property_read_u32(np, "vib_overdrive_voltage",
> +					&voltage);
> +		if (!ret)
> +			haptics->overdrive_voltage = drv260x_calculate_voltage(voltage);
> +
> +	} else if (pdata) {
> +		haptics->mode = pdata->mode;
> +		haptics->library = pdata->library_selection;
> +		if (pdata->vib_overdrive_voltage)
> +			haptics->overdrive_voltage = drv260x_calculate_voltage(pdata->vib_overdrive_voltage);
> +		if (pdata->vib_rated_voltage)
> +			haptics->rated_voltage = drv260x_calculate_voltage(pdata->vib_rated_voltage);
> +	} else {
> +		dev_err(&client->dev, "Platform data not set\n");
> +		return -ENODEV;
> +	}
> +
> +	haptics->regulator = regulator_get(&client->dev, "vbat");
> +	if (IS_ERR(haptics->regulator)) {
> +		ret = PTR_ERR(haptics->regulator);
> +		dev_err(&client->dev,
> +			"unable to get regulator, error: %d\n", ret);
> +		goto err_regulator;
> +	}
> +
> +	haptics->enable_gpio = devm_gpiod_get(&client->dev, "enable");
> +	if (IS_ERR(haptics->enable_gpio)) {
> +		ret = PTR_ERR(haptics->enable_gpio);
> +		if (ret != -ENOENT && ret != -ENOSYS)
> +			goto err_gpio;
> +
> +		haptics->enable_gpio = NULL;
> +	} else {
> +		gpiod_direction_output(haptics->enable_gpio, 1);
> +	}
> +
> +	haptics->input_dev = input_allocate_device();
> +	if (haptics->input_dev == NULL) {
> +		dev_err(&client->dev, "Failed to allocate input device\n");
> +		ret = -ENOMEM;
> +		goto err_input_alloc;
> +	}
> +
> +	haptics->input_dev->name = "drv260x:haptics";
> +	haptics->input_dev->dev.parent = client->dev.parent;
> +	haptics->input_dev->close = drv260x_close;
> +	input_set_drvdata(haptics->input_dev, haptics);
> +	input_set_capability(haptics->input_dev, EV_FF, FF_RUMBLE);
> +
> +	ret = input_ff_create(haptics->input_dev, DRV260X_MAX_EFFECTS);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "input_ff_create() failed: %d\n",
> +			ret);
> +		goto err_ff_create;
> +	}
> +
> +	ff = haptics->input_dev->ff;
> +	ff->playback = drv260x_playback;
> +	ff->upload = drv260x_upload_effect;
> +
> +	mutex_init(&haptics->lock);
> +	INIT_WORK(&haptics->work, drv260x_worker);
> +	hrtimer_init(&haptics->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	haptics->timer.function = drv260x_timer;
> +
> +	haptics->client = client;
> +	i2c_set_clientdata(client, haptics);
> +
> +	haptics->regmap = devm_regmap_init_i2c(client, &drv260x_regmap_config);
> +	if (IS_ERR(haptics->regmap)) {
> +		ret = PTR_ERR(haptics->regmap);
> +		dev_err(&client->dev, "Failed to allocate register map: %d\n",
> +			ret);
> +		goto err_regmap;
> +	}
> +
> +	drv260x_init(haptics);
> +
> +	ret = input_register_device(haptics->input_dev);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "couldn't register input device: %d\n",
> +			ret);
> +		goto err_iff;
> +	}
> +	return 0;
> +
> +err_iff:
> +err_regmap:
> +	if (haptics->input_dev)
> +		input_ff_destroy(haptics->input_dev);
> +err_ff_create:
> +	input_free_device(haptics->input_dev);
> +err_input_alloc:
> +err_gpio:
> +	regulator_put(haptics->regulator);
> +err_regulator:
> +	return ret;
> +}
> +
> +static int drv260x_remove(struct i2c_client *client)
> +{
> +	struct drv260x_data *haptics = i2c_get_clientdata(client);
> +
> +	cancel_work_sync(&haptics->work);
> +
> +	regmap_write(haptics->regmap, DRV260X_MODE, DRV260X_STANDBY);
> +	gpiod_set_value(haptics->enable_gpio, 0);
> +
> +	input_unregister_device(haptics->input_dev);
> +	regulator_put(haptics->regulator);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int drv260x_suspend(struct device *dev)
> +{
> +	struct drv260x_data *haptics = dev_get_drvdata(dev);
> +
> +	regmap_update_bits(haptics->regmap,
> +			   DRV260X_MODE,
> +			   DRV260X_STANDBY_MASK,
> +			   DRV260X_STANDBY);
> +	gpiod_set_value(haptics->enable_gpio, 0);
> +
> +	regulator_disable(haptics->regulator);
> +
> +	return 0;
> +}
> +
> +static int drv260x_resume(struct device *dev)
> +{
> +	struct drv260x_data *haptics = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = regulator_enable(haptics->regulator);
> +	if (ret) {
> +		dev_err(dev, "Failed to enable regulator\n");
> +		return ret;
> +	}
> +	regmap_update_bits(haptics->regmap,
> +			   DRV260X_MODE,
> +			   DRV260X_STANDBY_MASK, 0);
> +
> +	gpiod_set_value(haptics->enable_gpio, 1);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(drv260x_pm_ops, drv260x_suspend, drv260x_resume);
> +
> +static const struct i2c_device_id drv260x_id[] = {
> +	{ "drv2605l", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, drv260x_id);
> +
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id drv260x_of_match[] = {
> +	{ .compatible = "ti,drv2604", },
> +	{ .compatible = "ti,drv2605", },
> +	{ .compatible = "ti,drv2605l", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, drv260x_of_match);
> +#endif
> +
> +static struct i2c_driver drv260x_driver = {
> +	.probe		= drv260x_probe,
> +	.remove		= drv260x_remove,
> +	.driver		= {
> +		.name	= "drv260x-haptics",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(drv260x_of_match),
> +		.pm	= &drv260x_pm_ops,
> +	},
> +	.id_table = drv260x_id,
> +};
> +module_i2c_driver(drv260x_driver);
> +
> +MODULE_ALIAS("platform:drv260x-haptics");
> +MODULE_DESCRIPTION("TI DRV260x haptics driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Dan Murphy <dmurphy@ti.com>");
> diff --git a/include/dt-bindings/input/ti-drv260x.h b/include/dt-bindings/input/ti-drv260x.h
> new file mode 100644
> index 0000000..28f1dfa
> --- /dev/null
> +++ b/include/dt-bindings/input/ti-drv260x.h
> @@ -0,0 +1,30 @@
> +/*
> + * ti-drv260x.h - DRV260X haptics driver family
> + *
> + * Author: Dan Murphy <dmurphy@ti.com>
> + *
> + * Copyright:   (C) 2014 Texas Instruments, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +/* Calibration Types */
> +#define DRV260X_RTP_MODE	0x00
> +#define DRV260X_LRA_MODE	0x01
> +#define DRV260X_ERM_MODE	0x02
> +
> +/* Library Selection */
> +#define DRV260X_LIB_SEL_DEFAULT		0x00
> +#define DRV260X_LIB_A				0x01
> +#define DRV260X_LIB_B				0x02
> +#define DRV260X_LIB_C				0x03
> +#define DRV260X_LIB_D				0x04
> +#define DRV260X_LIB_E				0x05
> +#define DRV260X_LIB_F				0x06
> diff --git a/include/linux/input/drv260x.h b/include/linux/input/drv260x.h
> new file mode 100644
> index 0000000..709395e
> --- /dev/null
> +++ b/include/linux/input/drv260x.h
> @@ -0,0 +1,181 @@
> +/*
> + * drv260x.h - DRV260X haptics driver family
> + *
> + * Author: Dan Murphy <dmurphy@ti.com>
> + *
> + * Copyright:   (C) 2014 Texas Instruments, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#ifndef _LINUX_DRV260X_I2C_H
> +#define _LINUX_DRV260X_I2C_H
> +
> +#define DRV260X_STATUS		0x0
> +#define DRV260X_MODE		0x1
> +#define DRV260X_RT_PB_IN	0x2
> +#define DRV260X_LIB_SEL		0x3
> +#define DRV260X_WV_SEQ_1	0x4
> +#define DRV260X_WV_SEQ_2	0x5
> +#define DRV260X_WV_SEQ_3	0x6
> +#define DRV260X_WV_SEQ_4	0x7
> +#define DRV260X_WV_SEQ_5	0x8
> +#define DRV260X_WV_SEQ_6	0x9
> +#define DRV260X_WV_SEQ_7	0xa
> +#define DRV260X_WV_SEQ_8	0xb
> +#define DRV260X_GO				0xc
> +#define DRV260X_OVERDRIVE_OFF	0xd
> +#define DRV260X_SUSTAIN_P_OFF	0xe
> +#define DRV260X_SUSTAIN_N_OFF	0xf
> +#define DRV260X_BRAKE_OFF		0x10
> +#define DRV260X_A_TO_V_CTRL		0x11
> +#define DRV260X_A_TO_V_MIN_INPUT	0x12
> +#define DRV260X_A_TO_V_MAX_INPUT	0x13
> +#define DRV260X_A_TO_V_MIN_OUT	0x14
> +#define DRV260X_A_TO_V_MAX_OUT	0x15
> +#define DRV260X_RATED_VOLT		0x16
> +#define DRV260X_OD_CLAMP_VOLT	0x17
> +#define DRV260X_CAL_COMP		0x18
> +#define DRV260X_CAL_BACK_EMF	0x19
> +#define DRV260X_FEEDBACK_CTRL	0x1a
> +#define DRV260X_CTRL1			0x1b
> +#define DRV260X_CTRL2			0x1c
> +#define DRV260X_CTRL3			0x1d
> +#define DRV260X_CTRL4			0x1e
> +#define DRV260X_CTRL5			0x1f
> +#define DRV260X_LRA_LOOP_PERIOD	0x20
> +#define DRV260X_VBAT_MON		0x21
> +#define DRV260X_LRA_RES_PERIOD	0x22
> +#define DRV260X_MAX_REG			0x23
> +
> +#define DRV260X_ALLOWED_R_BYTES	25
> +#define DRV260X_ALLOWED_W_BYTES	2
> +#define DRV260X_MAX_RW_RETRIES	5
> +#define DRV260X_I2C_RETRY_DELAY 10
> +
> +#define DRV260X_GO_BIT				0x01
> +
> +/* Library Selection */
> +#define DRV260X_LIB_SEL_MASK		0x07
> +#define DRV260X_LIB_SEL_RAM			0x0
> +#define DRV260X_LIB_SEL_OD			0x1
> +#define DRV260X_LIB_SEL_40_60		0x2
> +#define DRV260X_LIB_SEL_60_80		0x3
> +#define DRV260X_LIB_SEL_100_140		0x4
> +#define DRV260X_LIB_SEL_140_PLUS	0x5
> +
> +#define DRV260X_LIB_SEL_HIZ_MASK	0x10
> +#define DRV260X_LIB_SEL_HIZ_EN		0x01
> +#define DRV260X_LIB_SEL_HIZ_DIS		0
> +
> +/* Mode register */
> +#define DRV260X_STANDBY				(1 << 6)
> +#define DRV260X_STANDBY_MASK		0x40
> +#define DRV260X_INTERNAL_TRIGGER	0x00
> +#define DRV260X_EXT_TRIGGER_EDGE	0x01
> +#define DRV260X_EXT_TRIGGER_LEVEL	0x02
> +#define DRV260X_PWM_ANALOG_IN		0x03
> +#define DRV260X_AUDIOHAPTIC			0x04
> +#define DRV260X_RT_PLAYBACK			0x05
> +#define DRV260X_DIAGNOSTICS			0x06
> +#define DRV260X_AUTO_CAL			0x07
> +
> +/* Audio to Haptics Control */
> +#define DRV260X_AUDIO_HAPTICS_PEAK_10MS		(0 << 2)
> +#define DRV260X_AUDIO_HAPTICS_PEAK_20MS		(1 << 2)
> +#define DRV260X_AUDIO_HAPTICS_PEAK_30MS		(2 << 2)
> +#define DRV260X_AUDIO_HAPTICS_PEAK_40MS		(3 << 2)
> +
> +#define DRV260X_AUDIO_HAPTICS_FILTER_100HZ	0x00
> +#define DRV260X_AUDIO_HAPTICS_FILTER_125HZ	0x01
> +#define DRV260X_AUDIO_HAPTICS_FILTER_150HZ	0x02
> +#define DRV260X_AUDIO_HAPTICS_FILTER_200HZ	0x03
> +
> +/* Min/Max Input/Output Voltages */
> +#define DRV260X_AUDIO_HAPTICS_MIN_IN_VOLT	0x19
> +#define DRV260X_AUDIO_HAPTICS_MAX_IN_VOLT	0x64
> +#define DRV260X_AUDIO_HAPTICS_MIN_OUT_VOLT	0x19
> +#define DRV260X_AUDIO_HAPTICS_MAX_OUT_VOLT	0xFF
> +
> +/* Feedback register */
> +#define DRV260X_FB_REG_ERM_MODE			0x7f
> +#define DRV260X_FB_REG_LRA_MODE			(1 << 7)
> +
> +#define DRV260X_BRAKE_FACTOR_MASK	0x1f
> +#define DRV260X_BRAKE_FACTOR_2X		(1 << 0)
> +#define DRV260X_BRAKE_FACTOR_3X		(2 << 4)
> +#define DRV260X_BRAKE_FACTOR_4X		(3 << 4)
> +#define DRV260X_BRAKE_FACTOR_6X		(4 << 4)
> +#define DRV260X_BRAKE_FACTOR_8X		(5 << 4)
> +#define DRV260X_BRAKE_FACTOR_16		(6 << 4)
> +#define DRV260X_BRAKE_FACTOR_DIS	(7 << 4)
> +
> +#define DRV260X_LOOP_GAIN_LOW		0xf3
> +#define DRV260X_LOOP_GAIN_MED		(1 << 2)
> +#define DRV260X_LOOP_GAIN_HIGH		(2 << 2)
> +#define DRV260X_LOOP_GAIN_VERY_HIGH	(3 << 2)
> +
> +#define DRV260X_BEMF_GAIN_0			0xfc
> +#define DRV260X_BEMF_GAIN_1		(1 << 0)
> +#define DRV260X_BEMF_GAIN_2		(2 << 0)
> +#define DRV260X_BEMF_GAIN_3		(3 << 0)
> +
> +/* Control 1 register */
> +#define DRV260X_AC_CPLE_EN			(1 << 5)
> +#define DRV260X_STARTUP_BOOST		(1 << 7)
> +
> +/* Control 2 register */
> +
> +#define DRV260X_IDISS_TIME_45		0
> +#define DRV260X_IDISS_TIME_75		(1 << 0)
> +#define DRV260X_IDISS_TIME_150		(1 << 1)
> +#define DRV260X_IDISS_TIME_225		0x03
> +
> +#define DRV260X_BLANK_TIME_45	(0 << 2)
> +#define DRV260X_BLANK_TIME_75	(1 << 2)
> +#define DRV260X_BLANK_TIME_150	(2 << 2)
> +#define DRV260X_BLANK_TIME_225	(3 << 2)
> +
> +#define DRV260X_SAMP_TIME_150	(0 << 4)
> +#define DRV260X_SAMP_TIME_200	(1 << 4)
> +#define DRV260X_SAMP_TIME_250	(2 << 4)
> +#define DRV260X_SAMP_TIME_300	(3 << 4)
> +
> +#define DRV260X_BRAKE_STABILIZER	(1 << 6)
> +#define DRV260X_UNIDIR_IN			(0 << 7)
> +#define DRV260X_BIDIR_IN			(1 << 7)
> +
> +/* Control 3 Register */
> +#define DRV260X_LRA_OPEN_LOOP		(1 << 0)
> +#define DRV260X_ANANLOG_IN			(1 << 1)
> +#define DRV260X_LRA_DRV_MODE		(1 << 2)
> +#define DRV260X_RTP_UNSIGNED_DATA	(1 << 3)
> +#define DRV260X_SUPPLY_COMP_DIS		(1 << 4)
> +#define DRV260X_ERM_OPEN_LOOP		(1 << 5)
> +#define DRV260X_NG_THRESH_0			(0 << 6)
> +#define DRV260X_NG_THRESH_2			(1 << 6)
> +#define DRV260X_NG_THRESH_4			(2 << 6)
> +#define DRV260X_NG_THRESH_8			(3 << 6)
> +
> +/* Control 4 Register */
> +#define DRV260X_AUTOCAL_TIME_150MS		(0 << 4)
> +#define DRV260X_AUTOCAL_TIME_250MS		(1 << 4)
> +#define DRV260X_AUTOCAL_TIME_500MS		(2 << 4)
> +#define DRV260X_AUTOCAL_TIME_1000MS		(3 << 4)
> +
> +struct drv260x_platform_data {
> +	int enable_gpio;
> +	int library_selection;
> +	int mode;
> +	int vib_rated_voltage;
> +	int vib_overdrive_voltage;
> +};
> +
> +#endif


-- 
------------------
Dan Murphy

