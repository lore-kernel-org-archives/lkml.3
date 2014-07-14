Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaGNTHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:07:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35791 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331AbaGNTHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:07:15 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6] ASoC: tas2552: Support TI TAS2552 Amplifier
Thread-Topic: [PATCH v6] ASoC: tas2552: Support TI TAS2552 Amplifier
Thread-Index: AQHPnR8NkdNoCbyJA0aqgNzAA6CyVQ==
Date: Mon, 14 Jul 2014 19:07:06 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49D80B10@DFLE09.ent.ti.com>
References: <1405093489-11897-1-git-send-email-dmurphy@ti.com>
 <20140714184321.GW6800@sirena.org.uk>
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

On 07/14/2014 01:43 PM, Mark Brown wrote:
> On Fri, Jul 11, 2014 at 10:44:49AM -0500, Dan Murphy wrote:
>
>> @@ -754,4 +755,8 @@ config SND_SOC_TPA6130A2
>>  	tristate "Texas Instruments TPA6130A2 headphone amplifier"
>>  	depends on I2C
>>  
>> +config SND_SOC_TAS2552
>> +	tristate "Texas Instruments TAS2552 Mono Audio amplifier"
>> +	depends on I2C
>> +
>>  endmenu
> Keep this and Makefile sorted - since this is a proper CODEC driver it
> should be in with the CODECs and also sorted in alphabetical order.

OK.  I was trying to stay away from a conflict by adding to the
bottom of the file.

>
>> +static int tas2552_startup(struct snd_pcm_substream *substream,
>> +			   struct snd_soc_dai *dai)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +
>> +	pm_runtime_get_sync(codec->dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static void tas2552_shutdown(struct snd_pcm_substream *substream,
>> +			   struct snd_soc_dai *dai)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +
>> +	pm_runtime_put(codec->dev);
>> +}
> These runtime calls should be redundant, the framework should hold a
> runtime PM reference on devices while they are active.  Does this not
> work for you?

I will verify that the calls get called.

>
>> +	pm_runtime_get_sync(codec->dev);
> Check the return value here.

OK

>
>> +	snd_soc_write(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN |
>> +				  TAS2552_BOOST_EN | TAS2552_APT_EN |
>> +				  TAS2552_PLL_ENABLE | TAS2552_LIM_EN);
> The PLL is enabled all the time not via DAPM or similar (it's never
> disabled)?

Good catch.  I will make sure the PLL Is disabled in the shutdown call.

>
>> +static int tas2552_resume(struct snd_soc_codec *codec)
>> +{
>> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
>> +	int ret;
>> +
>> +	ret = regulator_bulk_enable(ARRAY_SIZE(tas2552->supplies),
>> +				    tas2552->supplies);
>> +
>> +	if (ret != 0) {
>> +		dev_err(codec->dev, "Failed to enable supplies: %d\n",
>> +			ret);
>> +	}
>> +
>> +	pm_runtime_get_sync(codec->dev);
> Remove these runtime PM calls from suspend and resume, they're not doing
> what you think (and will prevent runtime PM from doing anything).  Let
> the frameworks worry about it for now, or explicitly call the runtime
> suspend and resume operators if and only if the device is runtime
> active.

OK

>
>> +	for (i = 0; i < ARRAY_SIZE(data->supplies); i++)
>> +		data->supplies[i].supply = tas2552_supply_names[i];
>> +
>> +	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(data->supplies),
>> +				      data->supplies);
>> +	if (ret != 0)
>> +		dev_err(dev, "Failed to request supplies: %d\n", ret);
> These supplies are mandatory (as they should be) but weren't mentioned
> in the DT binding - please add them there.

Will add

>
>> +static const struct i2c_device_id tas2552_id[] = {
>> +	{ "tas2552-codec", 0 },
>> +	{ }
>> +};
> No -codec.

Missed this one

-- 
------------------
Dan Murphy

