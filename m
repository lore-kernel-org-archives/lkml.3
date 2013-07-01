Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3GAMds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:33:48 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:45871 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab3GAMdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:33:47 -0400
Message-ID: <51D177F5.2040805@metafoo.de>
Date: Mon, 01 Jul 2013 14:37:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Marek Belisko <marek.belisko@gmail.com>
CC: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        lgirdwood@gmail.com, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>, broonie@kernel.org,
        rob@landley.net, grant.likely@linaro.org, zonque@gmail.com
Subject: Re: [alsa-devel] [PATCH] ASoC: Add PCM1681 codec driver.
References: <1372251928-15706-1-git-send-email-marek.belisko@streamunlimited.com>
In-Reply-To: <1372251928-15706-1-git-send-email-marek.belisko@streamunlimited.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 03:05 PM, Marek Belisko wrote:
[...]
> +static int pcm1681_deemph[] = { 44100, 48000, 32000 };

const

> +
> +static int pcm1681_set_deemph(struct snd_soc_codec *codec)
> +{
> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
> +	int i = 0, val = -1, ret;
> +
> +	if (priv->deemph)
> +		for (i = 0; i < ARRAY_SIZE(pcm1681_deemph); i++)
> +			if (pcm1681_deemph[i] == priv->rate)
> +				val = i;
> +
> +	/* enable choosen frequency */
> +	if (val != -1)
> +		regmap_update_bits(priv->regmap, PCM1681_DEEMPH_CONTROL,
> +					PCM1681_DEEMPH_RATE_MASK, val);

So if the current sample rate doesn't match any of the available deempth rates
the current setting is kept. This doesn't seem right.

> +
> +	/* enable/disable deemphasis functionality */
> +	ret = regmap_update_bits(priv->regmap, PCM1681_DEEMPH_CONTROL,
> +				PCM1681_DEEMPH_MASK, priv->deemph);
> +
> +	return ret;
> +}
> +
[...]
> +
> +static int pcm1681_digital_mute(struct snd_soc_dai *dai, int mute)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
> +	int ret, val = 0;
> +
> +	if (mute)
> +		val = PCM1681_SOFT_MUTE_ALL;
> +
> +	ret = regmap_write(priv->regmap, PCM1681_SOFT_MUTE, val);

How about just

return regmap_write(...)

> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
[...]
> +static const DECLARE_TLV_DB_SCALE(pcm1681_dac_tlv, -6350, 50, 1);
> +
> +static const struct snd_kcontrol_new pcm1681_controls[] = {
> +	SOC_DOUBLE_R_TLV("PCM1681 Channel 1/2 Playback Volume",
> +			PCM1681_ATT_CONTROL(1), PCM1681_ATT_CONTROL(2), 0,
> +			0x7f, 0, pcm1681_dac_tlv),
> +	SOC_DOUBLE_R_TLV("PCM1681 Channel 3/4 Playback Volume",
> +			PCM1681_ATT_CONTROL(3), PCM1681_ATT_CONTROL(4), 0,
> +			0x7f, 0, pcm1681_dac_tlv),
> +	SOC_DOUBLE_R_TLV("PCM1681 Channel 5/6 Playback Volume",
> +			PCM1681_ATT_CONTROL(5), PCM1681_ATT_CONTROL(6), 0,
> +			0x7f, 0, pcm1681_dac_tlv),
> +	SOC_DOUBLE_R_TLV("PCM1681 Channel 7/8 Playback Volume",
> +			PCM1681_ATT_CONTROL(7), PCM1681_ATT_CONTROL(8), 0,
> +			0x7f, 0, pcm1681_dac_tlv),
> +	SOC_SINGLE_BOOL_EXT("PCM1681 De-emphasis Switch", 0,
> +			    pcm1681_get_deemph, pcm1681_put_deemph),
> +};

The name of the codec should probably not be in the control names.

[...]
> +#ifdef CONFIG_OF
> +static const struct of_device_id pcm1681_dt_ids[] = {
> +	{ .compatible = "ti,pcm1681", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, pcm1681_dt_ids);
> +#endif
> +
> +static const struct regmap_config pcm1681_regmap = {
> +	.reg_bits		= 8,
> +	.val_bits		= 8,
> +	.max_register		= ARRAY_SIZE(pcm1681_reg_defaults),

max_register is the last register in the register map, so usually this would be
ARRAY_SIZE(...) + 1

> +	.reg_defaults		= pcm1681_reg_defaults,
> +	.num_reg_defaults	= ARRAY_SIZE(pcm1681_reg_defaults),
> +	.writeable_reg		= pcm1681_writeable_reg,
> +	.readable_reg		= pcm1681_accessible_reg,
> +};
[...]
> +
> +static struct snd_soc_codec_driver soc_codec_dev_pcm1681 = {
> +	.probe			= pcm1681_probe,
> +	.remove			= pcm1681_remove,
> +	.controls		= pcm1681_controls,
> +	.num_controls		= ARRAY_SIZE(pcm1681_controls),
> +};
> +
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)

Since the driver only supports I2C there is no need for this ifdef
[...]

