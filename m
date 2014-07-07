Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaGGIKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:10:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50782 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGGIKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:10:02 -0400
Date: Mon, 7 Jul 2014 10:08:36 +0200
From: Mark Brown <broonie@kernel.org>
To: Dan Murphy <dmurphy@ti.com>
Cc: linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org
Message-ID: <20140707080836.GD30458@sirena.org.uk>
References: <1404404675-5948-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/unnNtmY43mpUSKx"
Content-Disposition: inline
In-Reply-To: <1404404675-5948-1-git-send-email-dmurphy@ti.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5] ASoC: tas2552: Support TI TAS2552 Amplifier
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2014 at 11:24:35AM -0500, Dan Murphy wrote:

> +static int tas2552_power(struct tas2552_data *data, u8 power)
> +{
> +	int	ret = 0;
> +
> +	mutex_lock(&data->mutex);
> +
> +	if (power) {
> +		if (data->enable_gpio)
> +			gpiod_set_value(data->enable_gpio, 1);
> +
> +		data->power_state = 1;
> +	} else {
> +		if (data->enable_gpio)
> +			gpiod_set_value(data->enable_gpio, 0);
> +
> +		data->power_state = 0;
> +	}
> +
> +	mutex_unlock(&data->mutex);
> +	return ret;
> +}

I don't understand this function.  It appears to be the only place where
either power_state or mutex is used so it's just adding some wrapping
around setting the GPIO value which doesn't seem like it's doing much.
Why are we tracking power_state?

> +static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
> +{
> +	u8 cfg1_reg = 0x0;
> +
> +	if (sw_shutdown)
> +		cfg1_reg |= TAS2552_SWS_MASK;
> +	else
> +		cfg1_reg &= ~TAS2552_SWS_MASK;
> +
> +	snd_soc_update_bits(tas_data->codec, TAS2552_CFG_1,
> +						 TAS2552_SWS_MASK, cfg1_reg);

Given that you're using _update_bits() clearing the bits in a register
that was just initialised to zero doesn't make a huge amount of sense.

> +	default:
> +		dev_vdbg(codec->dev, "Substream sample rate is not found\n");
> +		return -EINVAL;
> +	}

Better to print the rate.

> +	pm_runtime_get_sync(codec->dev);
> +
> +	snd_soc_update_bits(codec, TAS2552_CFG_3, TAS2552_WCLK_MASK, wclk_reg);
> +
> +	pm_runtime_put(codec->dev);

This seems really strange - why is the device being powered up to just
set a bit and then potentially powered down immediately?  I'd expect to
just update the cache if the device is not active.  You're also not
checking that the power up worked.

> +
> +static int tas2552_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
> +{
> +	u8 serial_format;
> +	u8 serial_control_mask = 0x00;

> +	if (fmt & SND_SOC_DAIFMT_FORMAT_MASK)
> +		serial_control_mask |= TAS2552_DATA_FORMAT_MASK;

> +	if (serial_control_mask) {
> +		pm_runtime_get_sync(codec->dev);
> +
> +		snd_soc_update_bits(codec, TAS2552_SER_CTRL_1, serial_control_mask,
> +							serial_format);
> +
> +		pm_runtime_put(codec->dev);
> +	}

This seems broken - if the format mask ever gets set then it won't be
cleared since we only do an update_bits() if the bit is being set.  Why
isn't the driver just doing an _update_bits()?

The comments about runtime PM also apply, they applies throughout the
driver.

> +static int tas2552_set_dai_sysclk(struct snd_soc_dai *dai, int clk_id,
> +				  unsigned int freq, int dir)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +
> +	/* Fill in the PLL control registers for J & D
> +	 * PLL_CLK = (.5 * freq * J.D) / 2^p
> +	 * Need to fill in J and D here based on incoming freq
> +	 */
> +	pm_runtime_get_sync(codec->dev);
> +
> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE, 0);
> +
> +	snd_soc_write(codec, TAS2552_PLL_CTRL_1, 0x10);
> +	snd_soc_write(codec, TAS2552_PLL_CTRL_2, 0x00);
> +	snd_soc_write(codec, TAS2552_PLL_CTRL_3, 0x00);
> +
> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE,
> +						TAS2552_PLL_ENABLE);
> +
> +	pm_runtime_put(codec->dev);

This makes no sense at all - please look at what other drivers are doing
with set_sysclk().  It should be used to get information about how the
device is clocked.

> +static int tas2552_startup(struct snd_pcm_substream *substream,
> +			   struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +
> +	pm_runtime_get_sync(codec->dev);
> +
> +	/* Turn on Class D amplifier */
> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN_MASK,
> +						TAS2552_CLASSD_EN);

This should be done using DAPM.

> +static int tas2552_codec_probe(struct snd_soc_codec *codec)
> +{
> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
> +	int ret;

> +
> +	tas2552_power(tas2552, 1);
> +	tas2552_sw_shutdown(tas2552, 0);
> +
> +	pm_runtime_set_active(codec->dev);
> +	pm_runtime_set_autosuspend_delay(codec->dev, 1000);
> +	pm_runtime_use_autosuspend(codec->dev);
> +	pm_runtime_enable(codec->dev);
> +	pm_runtime_mark_last_busy(codec->dev);
> +	pm_runtime_put_sync_autosuspend(codec->dev);

This should all be done at the device level probe.

> +	/* 0dB gain */
> +	snd_soc_write(codec, TAS2552_PGA_GAIN, 0x10);

Use the hardware default, your default might not be sensible for some
other user.

> +	/**
> +	 * Data sheet indicates to write 0x0c to 0x0d during init but no
> +	 * additional information is given to what it means.
> +	 */
> +	snd_soc_write(codec, TAS2552_LIMIT_LVL_CTRL, 0x0c);
> +	/**
> +	 * Data sheet indicates to write 0x20 to 0x0e during init but no
> +	 * additional information is given to what it means.
> +	 */
> +
> +	snd_soc_write(codec, TAS2552_LIMIT_RATE_HYS, 0x20);

Use a regmap patch for these.

> +static int tas2552_suspend(struct snd_soc_codec *codec)
> +{
> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
> +	int ret;
> +
> +	pm_runtime_put(codec->dev);

This won't work.  Let the frameworks worry about this, or check if the
device is already runtime suspended and then call your runtime suspend
operation directly.

> +static const struct i2c_device_id tas2552_id[] = {
> +	{ "tas2552-codec", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, tas2552_id);

No -codec, look at what other drivers do.

--/unnNtmY43mpUSKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTulWBAAoJELSic+t+oim9/rcQAI4TREK1Q6jCMPrFIAHM/qYM
I2FlA0RUV9jkOswmv9f5snOTAEnFtdcXXAcErPNRUxJ8VkVvlKNHc+ys8SFnO5Jq
yEFkWz75e4lMS/IJDBBlZsJdYUmAfZJWl6RQSygRAdLsVRxkCIJrxDoxRA8j7eLx
kgDgv16GH0K32zp3wxnAiLnCzGjsKh7osoh6kNiNJUPHVP5wsa/dJhTHr6sohfus
x3JG7kewAgvQFeXb7dBMyNhn4J4CEaFabGz2v4LWcRPGpwMGjwL4BYsMibjAgbmc
8NmcCZP9wsLkaVEdgj9F3pPpQXiXQ6Nnbsm9uShZ4PJLYTy9OP1OGokNtmoXMjy3
a/dEEHuSaEsRVFW5yAhzy/kxoTQxeYTlHt25TCbFiBn98VYtMItfVPbpk9fmmY95
+EIv+c2j1z6Ab+vI9CpbIDc8pgXcFaaLCiyl2Ya1EMZc0sAyOYgFseHrdW+gSTb2
f125c6qbat5Ok97BzfI1Ob3rxyKuZ5LkUBdd5jjS27q4/5cypQGdyxeg1eyEKhJq
pghgApdVm6gZYh2CDJEh1KruTwS48IbF/4moDEYGuXSAeRgSNIhk/DDM3G4SusS2
PV+hz+lRyuHQ3i4tzhnl+W3xW3k6b27dg5qmn+pvbQLWGuXZcqMtYns0DaaJlzNp
vmLfi2Hr6GZ7UWyP0NSc
=XjkJ
-----END PGP SIGNATURE-----

--/unnNtmY43mpUSKx--
