Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbaGYSy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:54:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59027 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbaGYSyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:54:25 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 2/2] ASoC: tas2552: Add DAPM calls for amp and PLL
Thread-Topic: [PATCH 2/2] ASoC: tas2552: Add DAPM calls for amp and PLL
Thread-Index: AQHPoq4QINk5svzI2k+LudLZHfn5dA==
Date: Fri, 25 Jul 2014 18:54:19 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DA8D1E@DFLE09.ent.ti.com>
References: <1405704668-8038-1-git-send-email-dmurphy@ti.com>
 <1405704668-8038-2-git-send-email-dmurphy@ti.com>
 <20140721115353.GV17528@sirena.org.uk>
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

On 07/21/2014 06:54 AM, Mark Brown wrote:
> On Fri, Jul 18, 2014 at 12:31:08PM -0500, Dan Murphy wrote:
> 
>> +static int tas2552_class_d_en(struct snd_soc_dapm_widget *w,
>> +			   struct snd_kcontrol *kcontrol, int event)
>> +{
>> +	switch (event) {
>> +	case SND_SOC_DAPM_PRE_PMU:
>> +		snd_soc_update_bits(w->codec, TAS2552_CFG_2,
>> +						 TAS2552_CLASSD_EN_MASK, TAS2552_CLASSD_EN_MASK);
>> +		break;
>> +	case SND_SOC_DAPM_POST_PMD:
>> +		snd_soc_update_bits(w->codec, TAS2552_CFG_2,
>> +						 TAS2552_CLASSD_EN_MASK, 0);
>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct snd_soc_dapm_widget tas2552_dapm_widgets[] =
>> +{
>> +SND_SOC_DAPM_PRE("Class D Enable", tas2552_class_d_en),
>> +SND_SOC_DAPM_POST("Class D Disable", tas2552_class_d_en),
>> +SND_SOC_DAPM_POST("PLL Disable", tas2552_pll_disable),
>> +};
> 
> This seems broken, having to use _PRE or _POST widgets for simple
> register writes (or almost anything really) should never be required and
> error prone - what is this actually trying to do?  I'd expect the class
> D to be a PGA or OUTPUT widget and the PLL to be a SUPPLY widget.
> 

I need a little help here.
I am not seeing the PLL being disabled or Class D being disabled when
I am using the DAPM calls

My implementation is like this.  And I use set these widgets and audio
map in the call back functions in the struct snd_soc_codec_driver.

When I look at the registers after stream playback I see that
the TAS2552_CFG_2 register is untouched

static const struct snd_soc_dapm_widget tas2552_dapm_widgets[] =
{
SND_SOC_DAPM_AIF_IN("DAC IN", NULL, 0, SND_SOC_NOPM, 0, 0),
SND_SOC_DAPM_DAC("DAC", NULL, SND_SOC_NOPM, 0, 0),
SND_SOC_DAPM_OUT_DRV("ClassD Enable", TAS2552_CFG_2, 7, 0, NULL, 0),
SND_SOC_DAPM_OUT_DRV("ClassD Disable", TAS2552_CFG_2, 7, 1, NULL, 0),
SND_SOC_DAPM_SUPPLY("PLL Disable", TAS2552_CFG_2, 3, 1, NULL, 0),
SND_SOC_DAPM_OUTPUT("OUT")
};

static const struct snd_soc_dapm_route tas2552_audio_map[] = {
    {"DAC", NULL, "DAC IN"},
    {"ClassD Enable", NULL, "DAC"},
    {"OUT", NULL, "ClassD Enable"},
    {"ClassD Disable", NULL, "OUT"},
    {"PLL Disable", NULL, "ClassD Disable"}
};

Any information would help here

Thanks in advance

-- 
------------------
Dan Murphy
