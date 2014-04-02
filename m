Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbaDBF7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:59:37 -0400
Received: from smtp-out-046.synserver.de ([212.40.185.46]:1060 "EHLO
	smtp-out-019.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756603AbaDBF7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:59:35 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29333
Message-ID: <533BA779.9010005@metafoo.de>
Date: Wed, 02 Apr 2014 08:00:25 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arun Shamanna Lakshmi <aruns@nvidia.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Songhee Baek <sbaek@nvidia.com>
Subject: Re: [PATCH] ASoC: DAPM: Add support for multi register mux
References: <1396333288-19113-1-git-send-email-aruns@nvidia.com> <533A6F4A.2060702@metafoo.de> <781A12BB53C15A4BB37291FDE08C03F3A05CDCD63B@HQMAIL02.nvidia.com> <781A12BB53C15A4BB37291FDE08C03F3A05CDCD659@HQMAIL02.nvidia.com>
In-Reply-To: <781A12BB53C15A4BB37291FDE08C03F3A05CDCD659@HQMAIL02.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 08:26 PM, Arun Shamanna Lakshmi wrote:
[...]
>>> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c index
>>> c8a780d..4d2b35c 100644
>>> --- a/sound/soc/soc-dapm.c
>>> +++ b/sound/soc/soc-dapm.c
>>> @@ -514,9 +514,9 @@ static int dapm_connect_mux(struct
>> snd_soc_dapm_context *dapm,
>>>    	unsigned int val, item;
>>>    	int i;
>>>
>>> -	if (e->reg != SND_SOC_NOPM) {
>>> -		soc_widget_read(dest, e->reg, &val);
>>> -		val = (val >> e->shift_l) & e->mask;
>>> +	if (e->reg[0] != SND_SOC_NOPM) {
>>> +		soc_widget_read(dest, e->reg[0], &val);
>>> +		val = (val >> e->shift_l) & e->mask[0];
>>>    		item = snd_soc_enum_val_to_item(e, val);
>>
>> This probably should handle the new enum type as well. You'll probably
>> need some kind of flag in the struct to distinguish between the two
>> enum types.
>
> Any suggestion on the flag name ?
>

How about 'onehot'?

[...]
>>> +		reg_val = BIT(bit_pos);
>>> +	}
>>> +
>>> +	for (i = 0; i < e->num_regs; i++) {
>>> +		if (i == reg_idx) {
>>> +			change = snd_soc_test_bits(codec, e->reg[i],
>>> +							e->mask[i],
>> reg_val);
>>> +
>>> +		} else {
>>> +			/* accumulate the change to update the DAPM
>> path
>>> +			    when none is selected */
>>> +			change += snd_soc_test_bits(codec, e->reg[i],
>>> +							e->mask[i], 0);
>>
>> change |=
>>
>>> +
>>> +			/* clear the register when not selected */
>>> +			snd_soc_write(codec, e->reg[i], 0);
>>
>> I think this should happen as part of the DAPM update sequence like
>> you had earlier. Some special care should probably be take to make
>> sure that you de-select the previous mux input before selecting the
>> new one if the new one is in a different register than the previous one.
>
> I am not sure I follow this part. We are clearing the 'not selected'
> registers before we set the one we want. Do you want us to loop the
> logic of soc_dapm_mux_update_power for each register ? or do you
> want to change the dapm_update structure so that it takes all the regs,
> masks, and values together ?

The idea with the dapm_update struct is that the register updates are done 
in the middle of the power-down and power-up sequence. So yes, change the 
dapm_update struct to be able to hold all register updates and do all 
register updates in dapm_widget_update. I think an earlier version of your 
patch already had this.

