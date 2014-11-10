Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaKJVtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:49:40 -0500
Received: from smtp-out-111.synserver.de ([212.40.185.111]:1088 "EHLO
	smtp-out-111.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKJVti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:49:38 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31869
Message-ID: <546132EF.7070008@metafoo.de>
Date: Mon, 10 Nov 2014 22:49:35 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        GTA04 owners <gta04-owner@goldelico.com>, alsa-devel@alsa-project.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: twl4030: don't report EBUSY if
 no change requested.
References: <20141108002637.6561.19002.stgit@notabene.brown>	<20141108003803.6561.42934.stgit@notabene.brown>	<20141108092242.GB2722@sirena.org.uk>	<20141110114518.715dcd4e@notabene.brown>	<54606446.7030907@metafoo.de> <20141111084537.1b4e726c@notabene.brown>
In-Reply-To: <20141111084537.1b4e726c@notabene.brown>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 10:45 PM, NeilBrown wrote:
> On Mon, 10 Nov 2014 08:07:50 +0100 Lars-Peter Clausen <lars@metafoo.de> wrote:
>
>> On 11/10/2014 01:45 AM, NeilBrown wrote:
>>> diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
>>> index b6b0cb399599..613b61cee081 100644
>>> --- a/sound/soc/codecs/twl4030.c
>>> +++ b/sound/soc/codecs/twl4030.c
>>> @@ -957,6 +957,16 @@ static int snd_soc_put_twl4030_opmode_enum_double(struct snd_kcontrol *kcontrol,
>>>    {
>>>    	struct snd_soc_codec *codec = snd_soc_kcontrol_codec(kcontrol);
>>>    	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
>>> +	struct snd_ctl_elem_value currentval;
>>>
>>
>> snd_ctl_elem_value is a bit to big to be put onto the kernel stack. Just
>> using twl4030_read() should be fine.
>
> That's a shame, it looked so neat....
>
> Using twl4030_read forces i2c access and misses out on the regmap caching.
>
> What do you think of this?

That looks good, but either snd_soc_kcontrol_component() instead of 
snd_kcontrol_chip() or just snd_soc_read(codec, ...

>
> Thanks,
> NeilBrown
>
> diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
> index b6b0cb399599..bdb47a045aa5 100644
> --- a/sound/soc/codecs/twl4030.c
> +++ b/sound/soc/codecs/twl4030.c
> @@ -957,6 +957,18 @@ static int snd_soc_put_twl4030_opmode_enum_double(struct snd_kcontrol *kcontrol,
>   {
>   	struct snd_soc_codec *codec = snd_soc_kcontrol_codec(kcontrol);
>   	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
> +	const struct soc_enum *e = &twl4030_op_modes_enum;
> +	unsigned int reg_val;
> +	int ret;
> +
> +	ret = snd_soc_component_read(snd_kcontrol_chip(kcontrol),
> +				     e->reg, &reg_val);
> +	if (ret)
> +		return ret;
> +	if (ucontrol->value.enumerated.item[0] ==
> +	    ((reg_val >> e->shift_l) & e->mask))
> +		/* no change requested, so do nothing */
> +		return 0;
>
>   	if (twl4030->configured) {
>   		dev_err(codec->dev,
>

