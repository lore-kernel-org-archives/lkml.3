Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaGBOxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:53:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41081 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbaGBOxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:53:16 -0400
Message-ID: <53B41CD6.8090403@ti.com>
Date: Wed, 2 Jul 2014 09:53:10 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-sound@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <broonie@kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3] ASoC: tas2552: Support TI TAS2552 Amplifier
References: <1404307852-10456-1-git-send-email-dmurphy@ti.com> <20140702141001.GA5541@saruman.home>
In-Reply-To: <20140702141001.GA5541@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe
Thanks for the review

On 07/02/2014 09:10 AM, Felipe Balbi wrote:
> Hi,
>
> On Wed, Jul 02, 2014 at 08:30:52AM -0500, Dan Murphy wrote:
>> Support the TI TAS2552 Class D amplifier.
>>
>> The TAS2552 is a high efficiency Class-D audio
>> power amplifier with advanced battery current
>> management and an integrated Class-G boost
>> The device constantly measures the
>> current and voltage across the load and provides a
>> digital stream of this information.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>
>> v3 - Updated bindings doc per comments, rearranged probe pdata vs 
>> np check - https://patchwork.kernel.org/patch/4453481/
>>
>>  .../devicetree/bindings/sound/tas2552.txt          |   22 +
>>  include/sound/tas2552-plat.h                       |   25 ++
>>  sound/soc/codecs/Kconfig                           |    5 +
>>  sound/soc/codecs/Makefile                          |    2 +
>>  sound/soc/codecs/tas2552.c                         |  463 ++++++++++++++++++++
>>  sound/soc/codecs/tas2552.h                         |   75 ++++
>>  6 files changed, 592 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/sound/tas2552.txt
>>  create mode 100644 include/sound/tas2552-plat.h
>>  create mode 100644 sound/soc/codecs/tas2552.c
>>  create mode 100644 sound/soc/codecs/tas2552.h
>>
>> diff --git a/Documentation/devicetree/bindings/sound/tas2552.txt b/Documentation/devicetree/bindings/sound/tas2552.txt
>> new file mode 100644
>> index 0000000..ada8fd4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/sound/tas2552.txt
>> @@ -0,0 +1,22 @@
>> +Texas Instruments - tas2552 Codec module
>> +
>> +The tas2552 serial control bus communicates through I2C protocols
>> +
>> +Required properties:
>> +
>> +- compatible - One of:
>> +    "ti,tas2552" - TAS2552
>> +
>> +- reg -  I2C slave address
>> +
>> +Optional properties:
>> +
>> +- power-gpio - gpio pin to enable/disable the device
>> +
>> +Example:
>> +
>> +tas2552: tas2552@41 {
>> +	compatible = "ti,tas2552";
>> +	reg = <0x41>;
>> +	enable-gpio = <&gpio4 2 GPIO_ACTIVE_HIGH>;
> you probably want to add:
>
> 	pvdd-supply = <&pvdd>;
> 	vbat-supply = <&vbat>;
> 	avdd-supply = <&avdd>;
> 	iovdd-supply = <&iovdd>;
>
> that way you can make sure to switch your regulators on from the driver.
> Since they must be all on, you can just grab them all with
> regulator_bulk_get() and enable them all with regulator_bulk_enable().

I could add this but I don't have a use case for this so I did not add the code.

The supplies I used were always-on so adding the regulators was not testable in this
patchset.

I could add this but it would be untested.

> Also, I wonder if it makes sense to add a link to [1] here.

Any reference to documentation is a good reference as long as the URL is
going to always be available.

>
> [1] http://www.ti.com/product/TAS2552

>> +};
>> diff --git a/include/sound/tas2552-plat.h b/include/sound/tas2552-plat.h
>> new file mode 100644
>> index 0000000..65e7627
>> --- /dev/null
>> +++ b/include/sound/tas2552-plat.h
> platform-data is usually placed under include/linux/platform_data/

I can move it if others agree.  There seems to be a mix of platform data
for sound drivers between sound and platform_data so it is up to the
maintainer if they want it moved.

I am OK with either location.

>
>> @@ -0,0 +1,25 @@
>> +/*
>> + * TAS2552 driver platform header
>> + *
>> + * Copyright (C) 2014 Texas Instruments Inc.
>> + *
>> + * Author: Dan Murphy <dmurphy@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#ifndef TAS2552_PLAT_H
>> +#define TAS2552_PLAT_H
>> +
>> +struct tas2552_platform_data {
>> +	int enable_gpio;
>> +};
>> +
>> +#endif
>> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
>> index 0b9571c..cc09261 100644
>> --- a/sound/soc/codecs/Kconfig
>> +++ b/sound/soc/codecs/Kconfig
>> @@ -99,6 +99,7 @@ config SND_SOC_ALL_CODECS
>>  	select SND_SOC_TLV320AIC32X4 if I2C
>>  	select SND_SOC_TLV320AIC3X if I2C
>>  	select SND_SOC_TPA6130A2 if I2C
>> +	select SND_SOC_TAS2552 if I2C
>>  	select SND_SOC_TLV320DAC33 if I2C
>>  	select SND_SOC_TWL4030 if TWL4030_CORE
>>  	select SND_SOC_TWL6040 if TWL6040_CORE
>> @@ -754,4 +755,8 @@ config SND_SOC_TPA6130A2
>>  	tristate "Texas Instruments TPA6130A2 headphone amplifier"
>>  	depends on I2C
>>  
>> +config SND_SOC_TAS2552
>> +	tristate "Texas Instruments TAS2552 Mono Audio amplifier"
>> +	depends on I2C
>> +
>>  endmenu
>> diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
>> index 1bd6e1c..33bc7228 100644
>> --- a/sound/soc/codecs/Makefile
>> +++ b/sound/soc/codecs/Makefile
>> @@ -162,6 +162,7 @@ snd-soc-wm-hubs-objs := wm_hubs.o
>>  # Amp
>>  snd-soc-max9877-objs := max9877.o
>>  snd-soc-tpa6130a2-objs := tpa6130a2.o
>> +snd-soc-tas2552-objs := tas2552.o
>>  
>>  obj-$(CONFIG_SND_SOC_88PM860X)	+= snd-soc-88pm860x.o
>>  obj-$(CONFIG_SND_SOC_AB8500_CODEC)	+= snd-soc-ab8500-codec.o
>> @@ -325,3 +326,4 @@ obj-$(CONFIG_SND_SOC_WM_HUBS)	+= snd-soc-wm-hubs.o
>>  # Amp
>>  obj-$(CONFIG_SND_SOC_MAX9877)	+= snd-soc-max9877.o
>>  obj-$(CONFIG_SND_SOC_TPA6130A2)	+= snd-soc-tpa6130a2.o
>> +obj-$(CONFIG_SND_SOC_TAS2552)	+= snd-soc-tas2552.o
>> diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
>> new file mode 100644
>> index 0000000..79b8212
>> --- /dev/null
>> +++ b/sound/soc/codecs/tas2552.c
>> @@ -0,0 +1,463 @@
>> +/*
>> + * ALSA SoC Texas Instruments TAS2552 Mono Audio Amplifier
>> + *
>> + * Copyright (C) 2014 Texas Instruments Inc.
>> + *
>> + * Author: Dan Murphy <dmurphy@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/errno.h>
>> +#include <linux/device.h>
>> +#include <linux/i2c.h>
>> +#include <linux/gpio.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/regmap.h>
>> +#include <linux/slab.h>
>> +
>> +#include <sound/pcm.h>
>> +#include <sound/pcm_params.h>
>> +#include <sound/soc.h>
>> +#include <sound/soc-dapm.h>
>> +#include <sound/tlv.h>
>> +#include <sound/tas2552-plat.h>
>> +
>> +#include "tas2552.h"
>> +
>> +static struct reg_default tas2552_reg_defs[] = {
>> +	{TAS2552_CFG_1, 0x16},
>> +	{TAS2552_CFG_3, 0x5E},
>> +	{TAS2552_DOUT, 0x00},
>> +	{TAS2552_OUTPUT_DATA, 0xC8},
>> +	{TAS2552_PDM_CFG, 0x02},
>> +	{TAS2552_PGA_GAIN, 0x10},
>> +	{TAS2552_BOOST_PT_CTRL, 0x0F},
>> +	{TAS2552_LIMIT_LVL_CTRL, 0x0C},
>> +	{TAS2552_LIMIT_RATE_HYS, 0x20},
>> +	{TAS2552_CFG_2, 0xEA},
>> +	{TAS2552_SER_CTRL_1, 0x00},
>> +	{TAS2552_SER_CTRL_2, 0x00},
>> +	{TAS2552_PLL_CTRL_1, 0x10},
>> +	{TAS2552_PLL_CTRL_2, 0x00},
>> +	{TAS2552_PLL_CTRL_3, 0x00},
>> +	{TAS2552_BTIP, 0x8f},
>> +	{TAS2552_BTS_CTRL, 0x80},
>> +	{TAS2552_LIMIT_RELEASE, 0x05},
>> +	{TAS2552_LIMIT_INT_COUNT, 0x00},
>> +	{TAS2552_EDGE_RATE_CTRL, 0x40},
>> +	{TAS2552_VBAT_DATA, 0x00},
>> +};
>> +
>> +struct tas2552_data {
>> +	struct mutex mutex;
>> +	struct snd_soc_codec *codec;
>> +	struct regmap *regmap;
>> +	struct i2c_client *tas2552_client;
>> +	unsigned char regs[TAS2552_VBAT_DATA];
>> +	int power_gpio;
>> +	u8 power_state:1;
>> +};
>> +
>> +static int tas2552_power(struct tas2552_data *data, u8 power)
>> +{
>> +	int	ret = 0;
>> +
>> +	BUG_ON(data->tas2552_client == NULL);
> don't hang the entire machine because of a bug on the amplifier driver,
> WARN() should be enough, followed by the return of an error code.
>
> In fact, is this really necessary ? It would be a simple bug on the
> driver to fix.

Yeah I can remove this.  I was following an older example.

>
>> +
>> +	mutex_lock(&data->mutex);
>> +	if (power == data->power_state)
> Same here. Is this really necessary ? It's simple to guarantee this case
> won't happen in code.

Yes this LOC is necessary.  It is checking the current state of the tas2552.

>> +		goto exit;
>> +
>> +	if (power) {
>> +		if (data->power_gpio >= 0)
>> +			gpio_set_value(data->power_gpio, 1);
>> +
>> +		data->power_state = 1;
>> +	} else {
>> +		if (data->power_gpio >= 0)
>> +			gpio_set_value(data->power_gpio, 0);
>> +
>> +		data->power_state = 0;
>> +	}
>> +
>> +exit:
>> +	mutex_unlock(&data->mutex);
>> +	return ret;
>> +}
>> +
>> +static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
>> +{
>> +	u8 cfg1_reg = 0x0;
>> +
>> +	if (sw_shutdown)
>> +		cfg1_reg |= (sw_shutdown << 1);
> this line is dangerous. You're using a 32-bit variable to write a single
> bit on cfg1 register. What if user passes 0xff on sw_shutdown ?
>
> I think a better approach would be to:
>
> a) first of all, move this sw_shutdown function to
> runtime_suspend/runtime_resume.

Yeah that is not the intent of this API.  This API is called when the ALSA layer
opens/closes the device.  It is not governed by pm calls.

>
> b) to the check as below:
>
> 	if (shutdown)
> 		cfg1_reg |= TAS2552_SWS;
> 	else
> 		cfg1_reg &= ~TAS2552_SWS;
>
> then, of course #define TAS2552_SWS (1 << 1) (or BIT(1), even)

But I will make this change.

>
>> +	else
>> +		cfg1_reg &= ~TAS2552_SWS_MASK;
>> +
>> +	snd_soc_update_bits(tas_data->codec, TAS2552_CFG_1,
>> +						 TAS2552_SWS_MASK, cfg1_reg);
>> +}
>> +
>> +static void tas2552_init(struct snd_soc_codec *codec)
>> +{
>> +	snd_soc_write(codec, TAS2552_CFG_1, 0x16);
>> +	snd_soc_write(codec, TAS2552_CFG_3, 0x5E);
>> +	snd_soc_write(codec, TAS2552_DOUT, 0x00);
>> +	snd_soc_write(codec, TAS2552_OUTPUT_DATA, 0xC8);
>> +	snd_soc_write(codec, TAS2552_PDM_CFG, 0x02);
>> +	snd_soc_write(codec, TAS2552_PGA_GAIN, 0x10);
>> +	snd_soc_write(codec, TAS2552_BOOST_PT_CTRL, 0x0F);
>> +	snd_soc_write(codec, TAS2552_LIMIT_LVL_CTRL, 0x0C);
>> +	snd_soc_write(codec, TAS2552_LIMIT_RATE_HYS, 0x20);
>> +	snd_soc_write(codec, TAS2552_CFG_2, 0xEA);
> what do all these magic constants mean ? Also, lower case hex numbers
> are usually preferred.

I will add comments to what the numbers mean and change to lower case

>
> No battery tracking ?  Any plans to add that at a later date ? It's
> probably not needed to have functional audio, but might have some use
> cases where you want it.

The battery tracking was not the scope of the driver.  We just need to get the basic
driver in place with audio functional and add the battery tracking later.

I also did not have a device that had the battery tracking enabled so I could not develop
that level of code anyway.

>
> /* goes re-read datasheet */
>
> Actually, I strongly believe you want to enable battery tracking (LIM_EN
> on cfg2).
>
>> +}
>> +
>> +static int tas2552_hw_params(struct snd_pcm_substream *substream,
>> +			     struct snd_pcm_hw_params *params,
>> +			     struct snd_soc_dai *dai)
>> +{
>> +	u8 wclk_reg;
>> +	struct snd_soc_codec *codec = dai->codec;
>> +
>> +	/* Setting DAC clock dividers based on substream sample rate. */
>> +	switch (params_rate(params)) {
>> +	case 8000:
>> +		wclk_reg = TAS2552_8KHZ;
>> +		break;
>> +	case 11025:
>> +		wclk_reg = TAS2552_11_12KHZ;
>> +		break;
>> +	case 16000:
>> +		wclk_reg = TAS2552_16KHZ;
>> +		break;
>> +	case 32000:
>> +		wclk_reg = TAS2552_32KHZ;
>> +		break;
>> +	case 22050:
>> +	case 24000:
>> +		wclk_reg = TAS2552_22_24KHZ;
>> +		break;
>> +	case 44100:
>> +	case 48000:
>> +		wclk_reg = TAS2552_44_48KHZ;
>> +		break;
>> +	case 96000:
>> +		wclk_reg = TAS2552_88_96KHZ;
>> +		break;
>> +	default:
> might be worth adding a dev_vdbg() here.

I could, but trying to not add a lot of logging in the code.

>
>> +		return -EINVAL;
>> +	}
>> +
>> +	snd_soc_update_bits(codec, TAS2552_CFG_3, TAS2552_WCLK_MASK, wclk_reg);
>> +
>> +	return 0;
>> +}
>> +
>> +static int tas2552_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
>> +{
>> +	u8 serial_format;
>> +	struct snd_soc_codec *codec = dai->codec;
>> +
>> +	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
>> +	case SND_SOC_DAIFMT_CBS_CFS:
>> +		serial_format = 0x00;
>> +		break;
>> +	case SND_SOC_DAIFMT_CBS_CFM:
>> +		serial_format = TAS2552_WORD_CLK_MASK;
>> +		break;
>> +	case SND_SOC_DAIFMT_CBM_CFS:
>> +		serial_format = TAS2552_BIT_CLK_MASK;
>> +		break;
>> +	case SND_SOC_DAIFMT_CBM_CFM:
>> +		serial_format = (TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK);
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	snd_soc_update_bits(codec, TAS2552_SER_CTRL_1,
>> +			    (TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK),
>> +			    serial_format);
>> +
>> +	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
>> +	case SND_SOC_DAIFMT_I2S:
>> +		serial_format = 0x0;
>> +		break;
>> +	case SND_SOC_DAIFMT_DSP_A:
>> +		serial_format = TAS2552_DAIFMT_DSP;
>> +		break;
>> +	case SND_SOC_DAIFMT_RIGHT_J:
>> +		serial_format = TAS2552_DAIFMT_RIGHT_J;
>> +		break;
>> +	case SND_SOC_DAIFMT_LEFT_J:
>> +		serial_format = TAS2552_DAIFMT_LEFT_J;
>> +		break;
>> +
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	snd_soc_update_bits(codec, TAS2552_SER_CTRL_1, TAS2552_DATA_FORMAT_MASK,
>> +						serial_format);
>> +
>> +	return 0;
>> +}
>> +
>> +static int tas2552_set_dai_sysclk(struct snd_soc_dai *dai, int clk_id,
>> +				  unsigned int freq, int dir)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +	struct tas2552_data *data = dev_get_drvdata(dai->dev);
>> +
>> +	/* Fill in the PLL control registers for J & D
>> +	 * PLL_CLK = (.5 * freq * J.D) / 2^p
>> +	 * Need to fill in J and D here based on incoming freq
>> +	 */
>> +
>> +	tas2552_sw_shutdown(data, 1);
> if you move sw_shutdown to runtime_suspend/resume, you could implement
> this as follows:
>
> 	ret = pm_runtime_get_sync(data->dev);
> 	if (ret)
> 		return ret;

See above comment about these APIs not being related to power management

>
>> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE, 0);
>> +
>> +	snd_soc_write(codec, TAS2552_PLL_CTRL_1, 0x10);
>> +	snd_soc_write(codec, TAS2552_PLL_CTRL_2, 0x00);
>> +	snd_soc_write(codec, TAS2552_PLL_CTRL_3, 0x00);
>> +
>> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE,
>> +						TAS2552_PLL_ENABLE);
>> +
>> +	tas2552_sw_shutdown(data, 0);
> and this as:
>
> 	pm_runtime_mark_last_busy(data->dev);
> 	pm_runtime_put_autosuspend(data->dev);
>
> then use a 1000 ms default timeout and you're good to go. In fact, you
> can make this even better by trying to make sure device is already
> powered when you get here. Also, I'm not sure what kind of latency you'd
> causing by constantly powering device on and off as you currently are.

Same as above

>
>> +
>> +	return 0;
>> +}
>> +
>> +static int tas2552_mute(struct snd_soc_dai *dai, int mute)
>> +{
>> +	u8 cfg1_reg = 0x0;
>> +	struct snd_soc_codec *codec = dai->codec;
>> +
>> +	if (mute)
>> +		cfg1_reg |= TAS2552_MUTE_MASK;
>> +	else
>> +		cfg1_reg &= ~TAS2552_MUTE_MASK;
>> +
>> +	snd_soc_update_bits(codec, TAS2552_CFG_1, TAS2552_MUTE_MASK, cfg1_reg);
>> +
>> +	return 0;
>> +}
>> +
>> +static int tas2552_startup(struct snd_pcm_substream *substream,
>> +			   struct snd_soc_dai *dai)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
>> +
>> +	tas2552_sw_shutdown(tas2552, 1);
>> +	tas2552_power(tas2552, 1);
> shouldn't you power first ? Looking at datasheet, if pin EN isn't high,
> device won't be enabled. It'd be surprising that it still responds to
> i2c.

Yes this is backwards.  Will fix

>> +
>> +	/* Turn on Class D amplifier */
>> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN_MASK,
>> +						TAS2552_CLASSD_EN);
>> +
>> +	tas2552_sw_shutdown(tas2552, 0);
>> +
>> +	return 0;
>> +}
>> +
>> +static void tas2552_shutdown(struct snd_pcm_substream *substream,
>> +			   struct snd_soc_dai *dai)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
>> +
>> +	tas2552_sw_shutdown(tas2552, 1);
>> +	tas2552_power(tas2552, 0);
>> +}
>> +
>> +static struct snd_soc_dai_ops tas2552_speaker_dai_ops = {
>> +	.hw_params	= tas2552_hw_params,
>> +	.set_sysclk	= tas2552_set_dai_sysclk,
>> +	.set_fmt	= tas2552_set_dai_fmt,
>> +	.startup	= tas2552_startup,
>> +	.shutdown	= tas2552_shutdown,
>> +	.digital_mute = tas2552_mute,
>> +};
>> +
>> +/* Formats supported by TAS2552 driver. */
>> +#define TAS2552_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE |\
>> +			 SNDRV_PCM_FMTBIT_S24_LE | SNDRV_PCM_FMTBIT_S32_LE)
>> +
>> +/* TAS2552 dai structure. */
>> +static struct snd_soc_dai_driver tas2552_dai[] = {
>> +	{
>> +		.name = "tas2552-amplifier",
>> +		.playback = {
>> +			.stream_name = "Speaker",
>> +			.channels_min = 2,
>> +			.channels_max = 2,
>> +			.rates = SNDRV_PCM_RATE_8000_192000,
>> +			.formats = TAS2552_FORMATS,
>> +		},
>> +		.ops = &tas2552_speaker_dai_ops,
>> +	},
>> +};
>> +
>> +/*
>> + * DAC digital volumes. From -7 to 24 dB in 1 dB steps
>> + */
>> +static DECLARE_TLV_DB_SCALE(dac_tlv, -7, 100, 24);
>> +
>> +static const struct snd_kcontrol_new tas2552_snd_controls[] = {
>> +	SOC_SINGLE_TLV("Speaker Driver Playback Volume",
>> +			 TAS2552_PGA_GAIN, 0, 0x1f, 1, dac_tlv),
>> +};
>> +
>> +static int tas2552_codec_probe(struct snd_soc_codec *codec)
>> +{
>> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
>> +
>> +	tas2552->codec = codec;
>> +	tas2552_power(tas2552, 1);
>> +	tas2552_init(codec);
>> +
>> +	return 0;
>> +}
>> +
>> +static int tas2552_codec_remove(struct snd_soc_codec *codec)
>> +{
>> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
>> +
>> +	tas2552_power(tas2552, 0);
>> +
>> +	return 0;
>> +};
>> +
>> +static struct snd_soc_codec_driver soc_codec_dev_tas2552 = {
>> +	.probe = tas2552_codec_probe,
>> +	.remove = tas2552_codec_remove,
>> +	.controls = tas2552_snd_controls,
>> +	.num_controls = ARRAY_SIZE(tas2552_snd_controls),
>> +};
>> +
>> +static const struct regmap_config tas2552_regmap_config = {
>> +	.reg_bits = 8,
>> +	.val_bits = 8,
>> +
>> +	.max_register = TAS2552_MAX_REG,
>> +	.reg_defaults = tas2552_reg_defs,
>> +	.num_reg_defaults = ARRAY_SIZE(tas2552_reg_defs),
>> +	.cache_type = REGCACHE_RBTREE,
>> +};
>> +
>> +static int tas2552_probe(struct i2c_client *client,
>> +			   const struct i2c_device_id *id)
>> +{
>> +	struct device *dev;
>> +	struct tas2552_data *data;
>> +	struct tas2552_platform_data *pdata = client->dev.platform_data;
>> +	struct device_node *np = client->dev.of_node;
>> +	int ret;
>> +
>> +	dev = &client->dev;
>> +	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
>> +	if (data == NULL)
>> +		return -ENOMEM;
>> +
>> +	if (np) {
>> +		data->power_gpio = of_get_named_gpio(np, "enable-gpio", 0);
>> +	} else if (pdata) {
>> +		data->power_gpio = pdata->enable_gpio;
>> +	} else {
>> +		dev_err(dev, "Platform or dev tree data not set\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	data->regmap = devm_regmap_init_i2c(client, &tas2552_regmap_config);
>> +	if (IS_ERR(data->regmap)) {
>> +		ret = PTR_ERR(data->regmap);
>> +		dev_err(&client->dev, "Failed to allocate register map: %d\n",
>> +			ret);
>> +		return ret;
>> +	}
>> +
>> +	data->tas2552_client = client;
>> +	data->regmap = devm_regmap_init_i2c(client, &tas2552_regmap_config);
>> +	if (IS_ERR(data->regmap)) {
>> +		ret = PTR_ERR(data->regmap);
>> +		dev_err(&client->dev, "Failed to allocate register map: %d\n",
>> +			ret);
>> +		return ret;
>> +	}
>> +
>> +	dev_set_drvdata(&client->dev, data);
>> +
>> +	mutex_init(&data->mutex);
>> +
>> +	if (data->power_gpio >= 0) {
>> +		ret = devm_gpio_request(dev, data->power_gpio,
>> +					"tas2552 enable");
>> +		if (ret < 0) {
>> +			dev_err(dev, "Failed to request power GPIO (%d)\n",
>> +				data->power_gpio);
>> +			goto err_gpio;
>> +		}
>> +		gpio_direction_output(data->power_gpio, 0);
>> +	}
>> +
>> +	ret = snd_soc_register_codec(&client->dev,
>> +				      &soc_codec_dev_tas2552,
>> +				      tas2552_dai, ARRAY_SIZE(tas2552_dai));
>> +	if (ret < 0)
>> +		dev_err(&client->dev, "Failed to register codec: %d\n", ret);
>> +
>> +	return 0;
>> +
>> +err_gpio:
>> +	data->tas2552_client = NULL;
>> +	return ret;
>> +}
>> +
>> +static int tas2552_i2c_remove(struct i2c_client *client)
>> +{
>> +	snd_soc_unregister_codec(&client->dev);
>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id tas2552_id[] = {
>> +	{ "tas2552-codec", 0 },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, tas2552_id);
>> +
>> +#if IS_ENABLED(CONFIG_OF)
>> +static const struct of_device_id tas2552_of_match[] = {
>> +	{ .compatible = "ti,tas2552", },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, tas2552_of_match);
>> +#endif
>> +
>> +static struct i2c_driver tas2552_i2c_driver = {
>> +	.driver = {
>> +		.name = "tas2552-codec",
>> +		.owner = THIS_MODULE,
>> +		.of_match_table = of_match_ptr(tas2552_of_match),
>> +	},
>> +	.probe = tas2552_probe,
>> +	.remove = tas2552_i2c_remove,
>> +	.id_table = tas2552_id,
>> +};
>> +
>> +module_i2c_driver(tas2552_i2c_driver);
>> +
>> +MODULE_AUTHOR("Dan Muprhy <dmurphy@ti.com>");
>> +MODULE_DESCRIPTION("TAS2552 Audio amplifier driver");
>> +MODULE_LICENSE("GPL");
>> diff --git a/sound/soc/codecs/tas2552.h b/sound/soc/codecs/tas2552.h
>> new file mode 100644
>> index 0000000..174c64d
>> --- /dev/null
>> +++ b/sound/soc/codecs/tas2552.h
>> @@ -0,0 +1,75 @@
>> +/*
>> + * ALSA SoC Texas Instruments TAS2552 Mono Audio Amplifier
>> + *
>> + * Copyright (C) 2014 Texas Instruments Inc.
>> + *
>> + * Author: Dan Murphy <dmurphy@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#ifndef __TAS2552_H__
>> +#define __TAS2552_H__
>> +
>> +/* Register Address Map */
>> +#define TAS2552_DEVICE_STATUS	0x00
>> +#define TAS2552_CFG_1			0x01
>> +#define TAS2552_CFG_2			0x02
>> +#define TAS2552_CFG_3			0x03
>> +#define TAS2552_DOUT			0x04
>> +#define TAS2552_SER_CTRL_1		0x05
>> +#define TAS2552_SER_CTRL_2		0x06
>> +#define TAS2552_OUTPUT_DATA		0x07
>> +#define TAS2552_PLL_CTRL_1		0x08
>> +#define TAS2552_PLL_CTRL_2		0x09
>> +#define TAS2552_PLL_CTRL_3		0x0a
>> +#define TAS2552_BTIP			0x0b
>> +#define TAS2552_BTS_CTRL		0x0c
>> +#define TAS2552_LIMIT_LVL_CTRL	0x0d
>> +#define TAS2552_LIMIT_RATE_HYS	0x0e
>> +#define TAS2552_LIMIT_RELEASE	0x0f
>> +#define TAS2552_LIMIT_INT_COUNT	0x10
>> +#define TAS2552_PDM_CFG			0x11
>> +#define TAS2552_PGA_GAIN		0x12
>> +#define TAS2552_EDGE_RATE_CTRL	0x13
>> +#define TAS2552_BOOST_PT_CTRL	0x14
>> +#define TAS2552_VER_NUM			0x16
>> +#define TAS2552_VBAT_DATA		0x19
>> +#define TAS2552_MAX_REG			0x20
>> +
>> +/* CFG1 Register Masks */
>> +#define TAS2552_MUTE_MASK		(1 << 2)
>> +#define TAS2552_SWS_MASK		(1 << 1)
>> +#define TAS2552_WCLK_MASK		0x07
>> +#define TAS2552_CLASSD_EN_MASK	(1 << 7)
>> +#define TAS2552_CLASSD_EN		0x80
>> +
>> +#define TAS2552_PLL_ENABLE		(1 << 3)
>> +
>> +/* CFG3 Register Masks */
>> +#define TAS2552_WORD_CLK_MASK		0x80
>> +#define TAS2552_BIT_CLK_MASK		0x40
>> +#define TAS2552_DATA_FORMAT_MASK	0x0c
>> +
>> +#define TAS2552_DAIFMT_DSP			0x04
>> +#define TAS2552_DAIFMT_RIGHT_J		0x08
>> +#define TAS2552_DAIFMT_LEFT_J		0x0c
>> +
>> +/* WCLK Dividers */
>> +#define TAS2552_8KHZ		0x00
>> +#define TAS2552_11_12KHZ	0x01
>> +#define TAS2552_16KHZ		0x02
>> +#define TAS2552_22_24KHZ	0x03
>> +#define TAS2552_32KHZ		0x04
>> +#define TAS2552_44_48KHZ	0x05
>> +#define TAS2552_88_96KHZ	0x06
>> +#define TAS2552_176_192KHZ	0x07
>> +
>> +#endif
>> -- 
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


-- 
------------------
Dan Murphy

