Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaGGRev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:34:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36440 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaGGRes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:34:48 -0400
Message-ID: <53BADA30.1000808@ti.com>
Date: Mon, 7 Jul 2014 12:34:40 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <linux-sound@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5] ASoC: tas2552: Support TI TAS2552 Amplifier
References: <1404404675-5948-1-git-send-email-dmurphy@ti.com> <20140707080836.GD30458@sirena.org.uk>
In-Reply-To: <20140707080836.GD30458@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark
Thanks for the review

On 07/07/2014 03:08 AM, Mark Brown wrote:
> On Thu, Jul 03, 2014 at 11:24:35AM -0500, Dan Murphy wrote:
>
>> +static int tas2552_power(struct tas2552_data *data, u8 power)
>> +{
>> +	int	ret = 0;
>> +
>> +	mutex_lock(&data->mutex);
>> +
>> +	if (power) {
>> +		if (data->enable_gpio)
>> +			gpiod_set_value(data->enable_gpio, 1);
>> +
>> +		data->power_state = 1;
>> +	} else {
>> +		if (data->enable_gpio)
>> +			gpiod_set_value(data->enable_gpio, 0);
>> +
>> +		data->power_state = 0;
>> +	}
>> +
>> +	mutex_unlock(&data->mutex);
>> +	return ret;
>> +}
> I don't understand this function.  It appears to be the only place where
> either power_state or mutex is used so it's just adding some wrapping
> around setting the GPIO value which doesn't seem like it's doing much.
> Why are we tracking power_state?

This function and mutex are artifacts from the development and probably can be consolidated
into the runtime PM calls. 

>
>> +static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
>> +{
>> +	u8 cfg1_reg = 0x0;
>> +
>> +	if (sw_shutdown)
>> +		cfg1_reg |= TAS2552_SWS_MASK;
>> +	else
>> +		cfg1_reg &= ~TAS2552_SWS_MASK;
>> +
>> +	snd_soc_update_bits(tas_data->codec, TAS2552_CFG_1,
>> +						 TAS2552_SWS_MASK, cfg1_reg);
> Given that you're using _update_bits() clearing the bits in a register
> that was just initialised to zero doesn't make a huge amount of sense.

This was an artifact from RFC in which I was not using the snd_soc functions.
I can remove the initialization of the variable.

>
>> +	default:
>> +		dev_vdbg(codec->dev, "Substream sample rate is not found\n");
>> +		return -EINVAL;
>> +	}
> Better to print the rate.

OK

>
>> +	pm_runtime_get_sync(codec->dev);
>> +
>> +	snd_soc_update_bits(codec, TAS2552_CFG_3, TAS2552_WCLK_MASK, wclk_reg);
>> +
>> +	pm_runtime_put(codec->dev);
> This seems really strange - why is the device being powered up to just
> set a bit and then potentially powered down immediately?  I'd expect to
> just update the cache if the device is not active.  You're also not
> checking that the power up worked.

I wanted to make sure that the device was on.  I totally forgot that
the device was using regmap and the values are cached when the device
is not on.

I can remove the get/put around the update calls.

>
>> +
>> +static int tas2552_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
>> +{
>> +	u8 serial_format;
>> +	u8 serial_control_mask = 0x00;
>> +	if (fmt & SND_SOC_DAIFMT_FORMAT_MASK)
>> +		serial_control_mask |= TAS2552_DATA_FORMAT_MASK;
>> +	if (serial_control_mask) {
>> +		pm_runtime_get_sync(codec->dev);
>> +
>> +		snd_soc_update_bits(codec, TAS2552_SER_CTRL_1, serial_control_mask,
>> +							serial_format);
>> +
>> +		pm_runtime_put(codec->dev);
>> +	}
> This seems broken - if the format mask ever gets set then it won't be
> cleared since we only do an update_bits() if the bit is being set.  Why
> isn't the driver just doing an _update_bits()?

I do not understand what this statement means.

Are you saying snd_soc_update_bits will not clear the bit if the bit mask
is set appropriately?

>
> The comments about runtime PM also apply, they applies throughout the
> driver.
>
>> +static int tas2552_set_dai_sysclk(struct snd_soc_dai *dai, int clk_id,
>> +				  unsigned int freq, int dir)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +
>> +	/* Fill in the PLL control registers for J & D
>> +	 * PLL_CLK = (.5 * freq * J.D) / 2^p
>> +	 * Need to fill in J and D here based on incoming freq
>> +	 */
>> +	pm_runtime_get_sync(codec->dev);
>> +
>> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE, 0);
>> +
>> +	snd_soc_write(codec, TAS2552_PLL_CTRL_1, 0x10);
>> +	snd_soc_write(codec, TAS2552_PLL_CTRL_2, 0x00);
>> +	snd_soc_write(codec, TAS2552_PLL_CTRL_3, 0x00);
>> +
>> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE,
>> +						TAS2552_PLL_ENABLE);
>> +
>> +	pm_runtime_put(codec->dev);
> This makes no sense at all - please look at what other drivers are doing
> with set_sysclk().  It should be used to get information about how the
> device is clocked.
>
>> +static int tas2552_startup(struct snd_pcm_substream *substream,
>> +			   struct snd_soc_dai *dai)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +
>> +	pm_runtime_get_sync(codec->dev);
>> +
>> +	/* Turn on Class D amplifier */
>> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN_MASK,
>> +						TAS2552_CLASSD_EN);
> This should be done using DAPM.

You mentioned this before.  Isn't the startup part of the DAPM calls?

>
>> +static int tas2552_codec_probe(struct snd_soc_codec *codec)
>> +{
>> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
>> +	int ret;
>> +
>> +	tas2552_power(tas2552, 1);
>> +	tas2552_sw_shutdown(tas2552, 0);
>> +
>> +	pm_runtime_set_active(codec->dev);
>> +	pm_runtime_set_autosuspend_delay(codec->dev, 1000);
>> +	pm_runtime_use_autosuspend(codec->dev);
>> +	pm_runtime_enable(codec->dev);
>> +	pm_runtime_mark_last_busy(codec->dev);
>> +	pm_runtime_put_sync_autosuspend(codec->dev);
> This should all be done at the device level probe.

I went back and forth on this in my head whether this should be in the
device probe of the codec probe.   I can move them to device probe.

>
>> +	/* 0dB gain */
>> +	snd_soc_write(codec, TAS2552_PGA_GAIN, 0x10);
> Use the hardware default, your default might not be sensible for some
> other user.

So would other users just patch their own code?
I can leave it to the default value.  This is just what the hardware
was tested with.

>
>> +	/**
>> +	 * Data sheet indicates to write 0x0c to 0x0d during init but no
>> +	 * additional information is given to what it means.
>> +	 */
>> +	snd_soc_write(codec, TAS2552_LIMIT_LVL_CTRL, 0x0c);
>> +	/**
>> +	 * Data sheet indicates to write 0x20 to 0x0e during init but no
>> +	 * additional information is given to what it means.
>> +	 */
>> +
>> +	snd_soc_write(codec, TAS2552_LIMIT_RATE_HYS, 0x20);
> Use a regmap patch for these.

OK.  I see that can be used for undocumented registers.

>
>> +static int tas2552_suspend(struct snd_soc_codec *codec)
>> +{
>> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
>> +	int ret;
>> +
>> +	pm_runtime_put(codec->dev);
> This won't work.  Let the frameworks worry about this, or check if the
> device is already runtime suspended and then call your runtime suspend
> operation directly.

OK will fix

>> +static const struct i2c_device_id tas2552_id[] = {
>> +	{ "tas2552-codec", 0 },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, tas2552_id);
> No -codec, look at what other drivers do.

OK will remove.

-- 
------------------
Dan Murphy

