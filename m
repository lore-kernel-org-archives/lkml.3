Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbaGCPOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:14:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60333 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758444AbaGCPNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:13:16 -0400
Message-ID: <53B57302.8030100@ti.com>
Date: Thu, 3 Jul 2014 10:13:06 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-sound@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <broonie@kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] ASoC: tas2552: Support TI TAS2552 Amplifier
References: <1404398393-21497-1-git-send-email-dmurphy@ti.com> <20140703145250.GO5814@saruman.home> <53B56F63.8000400@ti.com> <20140703150621.GQ5814@saruman.home>
In-Reply-To: <20140703150621.GQ5814@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 07/03/2014 10:06 AM, Felipe Balbi wrote:
> Hi,
>
> On Thu, Jul 03, 2014 at 09:57:39AM -0500, Dan Murphy wrote:
>> On 07/03/2014 09:52 AM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Thu, Jul 03, 2014 at 09:39:53AM -0500, Dan Murphy wrote:
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
>>>> +	pm_runtime_get_sync(codec->dev);
>>>> +
>>>> +	snd_soc_update_bits(codec, TAS2552_SER_CTRL_1,
>>>> +			    (TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK),
>>>> +			    serial_format);
>>>> +
>>>> +	pm_runtime_put(codec->dev);
>>> I have a feeling it's better to just put at the end of the function.
>>> Remember your pm_runtime_put() will issue i2c transfers which can take a
>>> looooooong time ;-)
>> I thought about that but the next switch case could return if the format
>> mask is invalid which means the runtime calls would not be balanced.
>>
>> So I decided to wrap the snd_soc calls with the pm_runtime calls to keep it
>> balanced.
> it looks like you can do both switch statements outside of the
> pm_runtime region and cache results on serial_format and do a single
> write to CTRL_1 register (?). If not, then just use two local variables.
>

Yeah I could probably consolidate these into a single call.  And throw a debug statement
in the default case to why the format was not set.

Dan

-- 
------------------
Dan Murphy

