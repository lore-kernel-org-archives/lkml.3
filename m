Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaB1IP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:15:26 -0500
Received: from smtp-out-128.synserver.de ([212.40.185.128]:1093 "EHLO
	smtp-out-167.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751240AbaB1IPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:15:25 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14877
Message-ID: <531045A9.3010502@metafoo.de>
Date: Fri, 28 Feb 2014 09:15:37 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: core: Set the default I/O up try
 regmap.
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com> <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com> <20140228035244.GJ9383@sirena.org.uk> <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com> <20140228052904.GP9383@sirena.org.uk> <1b89016263c84e0297655034a648032f@BY2PR03MB505.namprd03.prod.outlook.com> <53102EE4.80702@metafoo.de> <d872d0fd60eb4c01b38af98014c802aa@BY2PR03MB505.namprd03.prod.outlook.com> <531030C7.2060703@metafoo.de> <5d534c2ac77040d9bc373db9e43dde7c@BY2PR03MB505.namprd03.prod.outlook.com> <53103787.2020702@metafoo.de> <049024c359df495fb8acedd96e574ce2@BY2PR03MB505.namprd03.prod.outlook.com>
In-Reply-To: <049024c359df495fb8acedd96e574ce2@BY2PR03MB505.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 08:50 AM, Li.Xiubo@freescale.com wrote:
>
>>
>> A quick grep reveals:
>> mc13783.c:	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
>> si476x.c:	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
>> wm5102.c:	codec->control_data = priv->core.arizona->regmap;
>> wm5110.c:	codec->control_data = priv->core.arizona->regmap;
>> wm8997.c:	codec->control_data = priv->core.arizona->regmap;
>>
>> But there might be more.
>>
>
> I have found the following ones, who are using MFD & set_cache_io.
>
>     1    143  sound/soc/codecs/cq93vc.c <<cq93vc_probe>>
>               snd_soc_codec_set_cache_io(codec, 32, 32, SND_SOC_REGMAP);
>     2    618  sound/soc/codecs/mc13783.c <<mc13783_probe>>
>               ret = snd_soc_codec_set_cache_io(codec, 8, 24, SND_SOC_REGMAP);
>     3   1765  sound/soc/codecs/wm5102.c <<wm5102_codec_probe>>
>               ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
>     4   1593  sound/soc/codecs/wm5110.c <<wm5110_codec_probe>>
>               ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
>     5   1510  sound/soc/codecs/wm8350.c <<wm8350_codec_probe>>
>               snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
>     6   1322  sound/soc/codecs/wm8400.c <<wm8400_codec_probe>>
>               snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
>     7   4004  sound/soc/codecs/wm8994.c <<wm8994_codec_probe>>
>               snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
>     8   1058  sound/soc/codecs/wm8997.c <<wm8997_codec_probe>>
>               ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);

Yes, I think that's almost all of them. si476x is missing, but I think that 
one is currently broken, as it doesn't call snd_soc_codec_set_cache_io() at all.

As to how to handle those, I think there was a plan to add the possibility 
to assign a regmap to a device, so that dev_get_regmap() returns the regmap 
struct that should be used, even though the device itself did not allocate 
the regmap. But I can't find the details. Mark may know more about this.

- Lars
