Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaGaFoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:44:23 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39557 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaGaFoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:44:21 -0400
Date: Wed, 30 Jul 2014 22:44:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        madcatxster@devoid-pointer.net, simon@mungewell.org,
        elias.vds@gmail.com
Subject: Re: [Patch v4] input: drv260x: Add TI drv260x haptics driver
Message-ID: <20140731054415.GA22897@core.coreip.homeip.net>
References: <1406729680-3591-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406729680-3591-1-git-send-email-dmurphy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Wed, Jul 30, 2014 at 09:14:40AM -0500, Dan Murphy wrote:
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
> 
> v4 - Convert regulator to devm, added error checking where required,
> updated bindings doc, moved dt parsing to separate call and made platform
> data the first data point, moved vibrator enable and mode programming from
> play entry to worker thread, added user check and input mutex in suspend/resume
> calls, moved platform data to individual file and into include platform-data directory,
> removed file names from file headers - https://patchwork.kernel.org/patch/4642221/
> v3 - Updated binding doc, changed to memless device, updated input alloc to
> devm, removed mutex locking, add sanity checks for mode and library - https://patchwork.kernel.org/patch/4635421/
> v2 - Fixed binding doc and patch headline - https://patchwork.kernel.org/patch/4619641/

Thank you for making changes, just a few more small nits from me and if
Mark is OK with the bindings then I will merge it.

...

> +
> +
> +	if (haptics->mode < DRV260X_LRA_MODE ||
> +		haptics->mode > DRV260X_ERM_MODE) {
> +			dev_err(&client->dev,
> +				"Vibrator mode is invalid: %i\n",
> +				haptics->mode);
> +			return -EINVAL;

Indentation for the body is wrong here.

> +	}
> +	
> +	if (haptics->library < DRV260X_LIB_SEL_DEFAULT ||
> +		haptics->library > DRV260X_LIB_F) {
> +			dev_err(&client->dev,
> +				"Library value is invalid: %i\n", haptics->library);
> +			return -EINVAL;

Here as well

> +	}	
> +
> +	haptics->regulator = devm_regulator_get(&client->dev, "vbat");
> +	if (IS_ERR(haptics->regulator)) {
> +		ret = PTR_ERR(haptics->regulator);
> +		dev_err(&client->dev,
> +			"unable to get regulator, error: %d\n", ret);
> +		goto err_regulator;

Here and below you can return directly from the probe function, there is
no need keeping "empty" labels.

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
> +	haptics->input_dev = devm_input_allocate_device(&client->dev);
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
> +	ret = input_ff_create_memless(haptics->input_dev, NULL,
> +				      drv260x_haptics_play);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "input_ff_create() failed: %d\n",
> +			ret);
> +		goto err_ff_create;
> +	}
> +
> +	INIT_WORK(&haptics->work, drv260x_worker);
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

I believe we should abort if init fails.

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
> +err_ff_create:
> +err_input_alloc:
> +err_gpio:
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

Since you provide close() method and you do not activate device in
resme() if there are no users you do not need to do this here. In fact
entire remove() can be dropped now.

> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int drv260x_suspend(struct device *dev)
> +{
> +	struct drv260x_data *haptics = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	mutex_lock(&haptics->input_dev->mutex);
> +
> +	if (haptics->input_dev->users) {
> +		ret = regmap_update_bits(haptics->regmap,
> +				   DRV260X_MODE,
> +				   DRV260X_STANDBY_MASK,
> +				   DRV260X_STANDBY);
> +		if (ret) {
> +			dev_err(dev, "Failed to set standby mode\n");
> +			goto out;
> +		}
> +
> +		gpiod_set_value(haptics->enable_gpio, 0);
> +
> +		ret = regulator_disable(haptics->regulator);
> +		if (ret)
> +			dev_err(dev, "Failed to disable regulator\n");

Maybe factor this out into drv260x_stop()?

> +	}
> +out:
> +	mutex_unlock(&haptics->input_dev->mutex);
> +	return ret;
> +}
> +
> +static int drv260x_resume(struct device *dev)
> +{
> +	struct drv260x_data *haptics = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	mutex_lock(&haptics->input_dev->mutex);
> +
> +	if (haptics->input_dev->users) {
> +		ret = regulator_enable(haptics->regulator);
> +		if (ret) {
> +			dev_err(dev, "Failed to enable regulator\n");
> +			goto out;
> +		}
> +		ret = regmap_update_bits(haptics->regmap,
> +				   DRV260X_MODE,
> +				   DRV260X_STANDBY_MASK, 0);
> +		if (ret) {
> +			dev_err(dev, "Failed to unset standby mode\n");
> +			goto out;
> +		}
> +
> +		gpiod_set_value(haptics->enable_gpio, 1);
> +	}
> +
> +out:
> +	mutex_unlock(&haptics->input_dev->mutex);
> +	return ret;
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
> index 0000000..be7f245
> --- /dev/null
> +++ b/include/dt-bindings/input/ti-drv260x.h
> @@ -0,0 +1,35 @@
> +/*
> + * DRV260X haptics driver family
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
> +#ifndef _DT_BINDINGS_TI_DRV260X_H
> +#define _DT_BINDINGS_TI_DRV260X_H
> +
> +/* Calibration Types */
> +#define DRV260X_LRA_MODE		0x00
> +#define DRV260X_LRA_NO_CAL_MODE	0x01
> +#define DRV260X_ERM_MODE		0x02
> +
> +/* Library Selection */
> +#define DRV260X_LIB_SEL_DEFAULT		0x00
> +#define DRV260X_LIB_A				0x01
> +#define DRV260X_LIB_B				0x02
> +#define DRV260X_LIB_C				0x03
> +#define DRV260X_LIB_D				0x04
> +#define DRV260X_LIB_E				0x05
> +#define DRV260X_LIB_F				0x06
> +
> +#endif
> diff --git a/include/linux/input/drv260x.h b/include/linux/input/drv260x.h
> new file mode 100644
> index 0000000..85fdaa4
> --- /dev/null
> +++ b/include/linux/input/drv260x.h
> @@ -0,0 +1,173 @@
> +/*
> + * DRV260X haptics driver family
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

Hmm, are all these defines interesting to anyone but driver itself?
Maybe put majority of them into the driver code (and what is needed to
properly define platform data into drv260x-pdata.h?

Thanks!

-- 
Dmitry
