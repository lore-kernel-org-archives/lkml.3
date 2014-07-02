Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaGBPaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:30:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56677 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbaGBPag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:30:36 -0400
Message-ID: <53B42591.5080608@ti.com>
Date: Wed, 2 Jul 2014 10:30:25 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-sound@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <broonie@kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3] ASoC: tas2552: Support TI TAS2552 Amplifier
References: <1404307852-10456-1-git-send-email-dmurphy@ti.com> <20140702141001.GA5541@saruman.home> <53B41CD6.8090403@ti.com> <20140702150259.GC5541@saruman.home>
In-Reply-To: <20140702150259.GC5541@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 10:03 AM, Felipe Balbi wrote:
> Hi,
>
> On Wed, Jul 02, 2014 at 09:53:10AM -0500, Dan Murphy wrote:
>> Felipe
>> Thanks for the review
>>
>> On 07/02/2014 09:10 AM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Wed, Jul 02, 2014 at 08:30:52AM -0500, Dan Murphy wrote:
>>>> Support the TI TAS2552 Class D amplifier.
>>>>
>>>> The TAS2552 is a high efficiency Class-D audio
>>>> power amplifier with advanced battery current
>>>> management and an integrated Class-G boost
>>>> The device constantly measures the
>>>> current and voltage across the load and provides a
>>>> digital stream of this information.
>>>>
>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>> ---
>>>>
>>>> v3 - Updated bindings doc per comments, rearranged probe pdata vs 
>>>> np check - https://patchwork.kernel.org/patch/4453481/
>>>>
>>>>  .../devicetree/bindings/sound/tas2552.txt          |   22 +
>>>>  include/sound/tas2552-plat.h                       |   25 ++
>>>>  sound/soc/codecs/Kconfig                           |    5 +
>>>>  sound/soc/codecs/Makefile                          |    2 +
>>>>  sound/soc/codecs/tas2552.c                         |  463 ++++++++++++++++++++
>>>>  sound/soc/codecs/tas2552.h                         |   75 ++++
>>>>  6 files changed, 592 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/sound/tas2552.txt
>>>>  create mode 100644 include/sound/tas2552-plat.h
>>>>  create mode 100644 sound/soc/codecs/tas2552.c
>>>>  create mode 100644 sound/soc/codecs/tas2552.h
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/sound/tas2552.txt b/Documentation/devicetree/bindings/sound/tas2552.txt
>>>> new file mode 100644
>>>> index 0000000..ada8fd4
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/sound/tas2552.txt
>>>> @@ -0,0 +1,22 @@
>>>> +Texas Instruments - tas2552 Codec module
>>>> +
>>>> +The tas2552 serial control bus communicates through I2C protocols
>>>> +
>>>> +Required properties:
>>>> +
>>>> +- compatible - One of:
>>>> +    "ti,tas2552" - TAS2552
>>>> +
>>>> +- reg -  I2C slave address
>>>> +
>>>> +Optional properties:
>>>> +
>>>> +- power-gpio - gpio pin to enable/disable the device
>>>> +
>>>> +Example:
>>>> +
>>>> +tas2552: tas2552@41 {
>>>> +	compatible = "ti,tas2552";
>>>> +	reg = <0x41>;
>>>> +	enable-gpio = <&gpio4 2 GPIO_ACTIVE_HIGH>;
>>> you probably want to add:
>>>
>>> 	pvdd-supply = <&pvdd>;
>>> 	vbat-supply = <&vbat>;
>>> 	avdd-supply = <&avdd>;
>>> 	iovdd-supply = <&iovdd>;
>>>
>>> that way you can make sure to switch your regulators on from the driver.
>>> Since they must be all on, you can just grab them all with
>>> regulator_bulk_get() and enable them all with regulator_bulk_enable().
>> I could add this but I don't have a use case for this so I did not add
>> the code.
> actually, you do. Right now you have a device which is powered by
> several different sources (fixed or not).

Does the regulator_enable *gaurantee* that the supplies will be turned on in
the following order?

1. VBAT,
2. IOVDD,
3. AVDD.

>
>> The supplies I used were always-on so adding the regulators was not
>> testable in this patchset.
> it _is_ testable. regulator_get()/regulator_enable() still works on
> fixed regulators.

I did not say i used fixed regulators.  I indicated that the regulators
were always-on.  So regulator_enable/disable would have no affect.  right?

I mean you cannot turn off vbat right?

>
>>>> @@ -325,3 +326,4 @@ obj-$(CONFIG_SND_SOC_WM_HUBS)	+= snd-soc-wm-hubs.o
>>>>  # Amp
>>>>  obj-$(CONFIG_SND_SOC_MAX9877)	+= snd-soc-max9877.o
>>>>  obj-$(CONFIG_SND_SOC_TPA6130A2)	+= snd-soc-tpa6130a2.o
>>>> +obj-$(CONFIG_SND_SOC_TAS2552)	+= snd-soc-tas2552.o
>>>> diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
>>>> new file mode 100644
>>>> index 0000000..79b8212
>>>> --- /dev/null
>>>> +++ b/sound/soc/codecs/tas2552.c
>>>> @@ -0,0 +1,463 @@
>>>> +/*
>>>> + * ALSA SoC Texas Instruments TAS2552 Mono Audio Amplifier
>>>> + *
>>>> + * Copyright (C) 2014 Texas Instruments Inc.
>>>> + *
>>>> + * Author: Dan Murphy <dmurphy@ti.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or
>>>> + * modify it under the terms of the GNU General Public License
>>>> + * version 2 as published by the Free Software Foundation.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful, but
>>>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>>> + * General Public License for more details.
>>>> + */
>>>> +
>>>> +#include <linux/module.h>
>>>> +#include <linux/errno.h>
>>>> +#include <linux/device.h>
>>>> +#include <linux/i2c.h>
>>>> +#include <linux/gpio.h>
>>>> +#include <linux/of_gpio.h>
>>>> +#include <linux/regmap.h>
>>>> +#include <linux/slab.h>
>>>> +
>>>> +#include <sound/pcm.h>
>>>> +#include <sound/pcm_params.h>
>>>> +#include <sound/soc.h>
>>>> +#include <sound/soc-dapm.h>
>>>> +#include <sound/tlv.h>
>>>> +#include <sound/tas2552-plat.h>
>>>> +
>>>> +#include "tas2552.h"
>>>> +
>>>> +static struct reg_default tas2552_reg_defs[] = {
>>>> +	{TAS2552_CFG_1, 0x16},
>>>> +	{TAS2552_CFG_3, 0x5E},
>>>> +	{TAS2552_DOUT, 0x00},
>>>> +	{TAS2552_OUTPUT_DATA, 0xC8},
>>>> +	{TAS2552_PDM_CFG, 0x02},
>>>> +	{TAS2552_PGA_GAIN, 0x10},
>>>> +	{TAS2552_BOOST_PT_CTRL, 0x0F},
>>>> +	{TAS2552_LIMIT_LVL_CTRL, 0x0C},
>>>> +	{TAS2552_LIMIT_RATE_HYS, 0x20},
>>>> +	{TAS2552_CFG_2, 0xEA},
>>>> +	{TAS2552_SER_CTRL_1, 0x00},
>>>> +	{TAS2552_SER_CTRL_2, 0x00},
>>>> +	{TAS2552_PLL_CTRL_1, 0x10},
>>>> +	{TAS2552_PLL_CTRL_2, 0x00},
>>>> +	{TAS2552_PLL_CTRL_3, 0x00},
>>>> +	{TAS2552_BTIP, 0x8f},
>>>> +	{TAS2552_BTS_CTRL, 0x80},
>>>> +	{TAS2552_LIMIT_RELEASE, 0x05},
>>>> +	{TAS2552_LIMIT_INT_COUNT, 0x00},
>>>> +	{TAS2552_EDGE_RATE_CTRL, 0x40},
>>>> +	{TAS2552_VBAT_DATA, 0x00},
>>>> +};
>>>> +
>>>> +struct tas2552_data {
>>>> +	struct mutex mutex;
>>>> +	struct snd_soc_codec *codec;
>>>> +	struct regmap *regmap;
>>>> +	struct i2c_client *tas2552_client;
>>>> +	unsigned char regs[TAS2552_VBAT_DATA];
>>>> +	int power_gpio;
>>>> +	u8 power_state:1;
>>>> +};
>>>> +
>>>> +static int tas2552_power(struct tas2552_data *data, u8 power)
>>>> +{
>>>> +	int	ret = 0;
>>>> +
>>>> +	BUG_ON(data->tas2552_client == NULL);
>>> don't hang the entire machine because of a bug on the amplifier driver,
>>> WARN() should be enough, followed by the return of an error code.
>>>
>>> In fact, is this really necessary ? It would be a simple bug on the
>>> driver to fix.
>> Yeah I can remove this.  I was following an older example.
>>
>>>> +
>>>> +	mutex_lock(&data->mutex);
>>>> +	if (power == data->power_state)
>>> Same here. Is this really necessary ? It's simple to guarantee this case
>>> won't happen in code.
>> Yes this LOC is necessary.  It is checking the current state of the tas2552.
> heh, the point is that all your calls to this function can be balanced
> easily, so this check becomes pointless, as it will never be true.

I will remove it.

>>>> +		goto exit;
>>>> +
>>>> +	if (power) {
>>>> +		if (data->power_gpio >= 0)
>>>> +			gpio_set_value(data->power_gpio, 1);
>>>> +
>>>> +		data->power_state = 1;
>>>> +	} else {
>>>> +		if (data->power_gpio >= 0)
>>>> +			gpio_set_value(data->power_gpio, 0);
>>>> +
>>>> +		data->power_state = 0;
>>>> +	}
>>>> +
>>>> +exit:
>>>> +	mutex_unlock(&data->mutex);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
>>>> +{
>>>> +	u8 cfg1_reg = 0x0;
>>>> +
>>>> +	if (sw_shutdown)
>>>> +		cfg1_reg |= (sw_shutdown << 1);
>>> this line is dangerous. You're using a 32-bit variable to write a single
>>> bit on cfg1 register. What if user passes 0xff on sw_shutdown ?
>>>
>>> I think a better approach would be to:
>>>
>>> a) first of all, move this sw_shutdown function to
>>> runtime_suspend/runtime_resume.
>> Yeah that is not the intent of this API.  This API is called when the ALSA layer
>> opens/closes the device.  It is not governed by pm calls.
> and PM calls are exactly for that. You start with a powered off device,
> then when user wants to use it, you power it up. This is exactly what's
> you're doing here.

I will look into it.

But I am not convinced I need these calls yet.

>>> b) to the check as below:
>>>
>>> 	if (shutdown)
>>> 		cfg1_reg |= TAS2552_SWS;
>>> 	else
>>> 		cfg1_reg &= ~TAS2552_SWS;
>>>
>>> then, of course #define TAS2552_SWS (1 << 1) (or BIT(1), even)
>> But I will make this change.
>>
>>>> +	else
>>>> +		cfg1_reg &= ~TAS2552_SWS_MASK;
>>>> +
>>>> +	snd_soc_update_bits(tas_data->codec, TAS2552_CFG_1,
>>>> +						 TAS2552_SWS_MASK, cfg1_reg);
>>>> +}
>>>> +
>>>> +static void tas2552_init(struct snd_soc_codec *codec)
>>>> +{
>>>> +	snd_soc_write(codec, TAS2552_CFG_1, 0x16);
>>>> +	snd_soc_write(codec, TAS2552_CFG_3, 0x5E);
>>>> +	snd_soc_write(codec, TAS2552_DOUT, 0x00);
>>>> +	snd_soc_write(codec, TAS2552_OUTPUT_DATA, 0xC8);
>>>> +	snd_soc_write(codec, TAS2552_PDM_CFG, 0x02);
>>>> +	snd_soc_write(codec, TAS2552_PGA_GAIN, 0x10);
>>>> +	snd_soc_write(codec, TAS2552_BOOST_PT_CTRL, 0x0F);
>>>> +	snd_soc_write(codec, TAS2552_LIMIT_LVL_CTRL, 0x0C);
>>>> +	snd_soc_write(codec, TAS2552_LIMIT_RATE_HYS, 0x20);
>>>> +	snd_soc_write(codec, TAS2552_CFG_2, 0xEA);
>>> what do all these magic constants mean ? Also, lower case hex numbers
>>> are usually preferred.
>> I will add comments to what the numbers mean and change to lower case
> I would rather see proper bit macros and the driver using them.

Yeah I started doing that in my initial driver but the bit macros were getting
a little obsessive.

>
>>> No battery tracking ?  Any plans to add that at a later date ? It's
>>> probably not needed to have functional audio, but might have some use
>>> cases where you want it.
>> The battery tracking was not the scope of the driver.  We just need to
>> get the basic driver in place with audio functional and add the
>> battery tracking later.
> it's a single bit

I will flip the bit for the default.

I looked back in my emails and it was the IVsense code I could not develop not
the battery checking.

>
>> I also did not have a device that had the battery tracking enabled so
>> I could not develop that level of code anyway.
> device will track your constant VBAT and, ideally, since voltage would
> never drop on VBAT, it shouldn't have to adjust gain.
>
>>> /* goes re-read datasheet */
>>>
>>> Actually, I strongly believe you want to enable battery tracking (LIM_EN
>>> on cfg2).
>>>
>>>> +}
>>>> +
>>>> +static int tas2552_hw_params(struct snd_pcm_substream *substream,
>>>> +			     struct snd_pcm_hw_params *params,
>>>> +			     struct snd_soc_dai *dai)
>>>> +{
>>>> +	u8 wclk_reg;
>>>> +	struct snd_soc_codec *codec = dai->codec;
>>>> +
>>>> +	/* Setting DAC clock dividers based on substream sample rate. */
>>>> +	switch (params_rate(params)) {
>>>> +	case 8000:
>>>> +		wclk_reg = TAS2552_8KHZ;
>>>> +		break;
>>>> +	case 11025:
>>>> +		wclk_reg = TAS2552_11_12KHZ;
>>>> +		break;
>>>> +	case 16000:
>>>> +		wclk_reg = TAS2552_16KHZ;
>>>> +		break;
>>>> +	case 32000:
>>>> +		wclk_reg = TAS2552_32KHZ;
>>>> +		break;
>>>> +	case 22050:
>>>> +	case 24000:
>>>> +		wclk_reg = TAS2552_22_24KHZ;
>>>> +		break;
>>>> +	case 44100:
>>>> +	case 48000:
>>>> +		wclk_reg = TAS2552_44_48KHZ;
>>>> +		break;
>>>> +	case 96000:
>>>> +		wclk_reg = TAS2552_88_96KHZ;
>>>> +		break;
>>>> +	default:
>>> might be worth adding a dev_vdbg() here.
>> I could, but trying to not add a lot of logging in the code.
> dev_vdbg() is only built when CONFIG_VERBOSE_DEBUG is set. Otherwise
> it's a no-op and optimized away.

OK will add but still I did not want to add a lot of logging in the code.

>
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	snd_soc_update_bits(codec, TAS2552_CFG_3, TAS2552_WCLK_MASK, wclk_reg);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int tas2552_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
>>>> +{
>>>> +	u8 serial_format;
>>>> +	struct snd_soc_codec *codec = dai->codec;
>>>> +
>>>> +	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
>>>> +	case SND_SOC_DAIFMT_CBS_CFS:
>>>> +		serial_format = 0x00;
>>>> +		break;
>>>> +	case SND_SOC_DAIFMT_CBS_CFM:
>>>> +		serial_format = TAS2552_WORD_CLK_MASK;
>>>> +		break;
>>>> +	case SND_SOC_DAIFMT_CBM_CFS:
>>>> +		serial_format = TAS2552_BIT_CLK_MASK;
>>>> +		break;
>>>> +	case SND_SOC_DAIFMT_CBM_CFM:
>>>> +		serial_format = (TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK);
>>>> +		break;
>>>> +	default:
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	snd_soc_update_bits(codec, TAS2552_SER_CTRL_1,
>>>> +			    (TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK),
>>>> +			    serial_format);
>>>> +
>>>> +	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
>>>> +	case SND_SOC_DAIFMT_I2S:
>>>> +		serial_format = 0x0;
>>>> +		break;
>>>> +	case SND_SOC_DAIFMT_DSP_A:
>>>> +		serial_format = TAS2552_DAIFMT_DSP;
>>>> +		break;
>>>> +	case SND_SOC_DAIFMT_RIGHT_J:
>>>> +		serial_format = TAS2552_DAIFMT_RIGHT_J;
>>>> +		break;
>>>> +	case SND_SOC_DAIFMT_LEFT_J:
>>>> +		serial_format = TAS2552_DAIFMT_LEFT_J;
>>>> +		break;
>>>> +
>>>> +	default:
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	snd_soc_update_bits(codec, TAS2552_SER_CTRL_1, TAS2552_DATA_FORMAT_MASK,
>>>> +						serial_format);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int tas2552_set_dai_sysclk(struct snd_soc_dai *dai, int clk_id,
>>>> +				  unsigned int freq, int dir)
>>>> +{
>>>> +	struct snd_soc_codec *codec = dai->codec;
>>>> +	struct tas2552_data *data = dev_get_drvdata(dai->dev);
>>>> +
>>>> +	/* Fill in the PLL control registers for J & D
>>>> +	 * PLL_CLK = (.5 * freq * J.D) / 2^p
>>>> +	 * Need to fill in J and D here based on incoming freq
>>>> +	 */
>>>> +
>>>> +	tas2552_sw_shutdown(data, 1);
>>> if you move sw_shutdown to runtime_suspend/resume, you could implement
>>> this as follows:
>>>
>>> 	ret = pm_runtime_get_sync(data->dev);
>>> 	if (ret)
>>> 		return ret;
>> See above comment about these APIs not being related to power management
> shutdown is not related to PM ? interesting...
>


-- 
------------------
Dan Murphy

