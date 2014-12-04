Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbaLDQys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:54:48 -0500
Received: from smtp-out-053.synserver.de ([212.40.185.53]:1462 "EHLO
	smtp-out-051.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932478AbaLDQyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:54:47 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18506
Message-ID: <548091C7.2060607@metafoo.de>
Date: Thu, 04 Dec 2014 17:54:31 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound/soc/adi/axi-spdif.c: Support programmable master
 clock
References: <1417675940-3754-1-git-send-email-mike.looijmans@topic.nl> <5480577D.4010106@metafoo.de> <54806D4E.8040504@topic.nl>
In-Reply-To: <54806D4E.8040504@topic.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 03:18 PM, Mike Looijmans wrote:
> On 12/04/2014 01:45 PM, Lars-Peter Clausen wrote:
>> On 12/04/2014 07:52 AM, Mike Looijmans wrote:
>>> If the master clock supports programmable rates, program it to generate
>>> the desired frequency. Only apply constraints when the clock is fixed.
>>> This allows proper clock generation for both 44100 and 48000 Hz based
>>> sampling rates if the platform supports it.
>>>
>>> The clock frequency must be set before enabling it. Enabling the clock
>>> was done in "startup", but that occurs before "hw_params" where the rate
>>> is known. Move the clock start to the hw_params routine, and keep track
>>> of whether the clock has been started, because shutdown may be called
>>> without having called hw_params first.
>>
>> Usually that shouldn't be a problem. If your clock chip requires it to be
>> disabled in order to be reprogrammed than the CLK_SET_RATE_GATE flag
>> should be
>> set. This will tell the core to disable the clock before changing it.
>
> The issue here is not the clock's capabilities, but the order in which
> things are being done. If the driver just enables the clock without ever
> having set a rate, the clock will run at whatever happens to be the default.
> That default may have unpredictable results or even be harmful to the
> system. So the driver should first set a valid clock rate before enabling
> the clock. Suggestions on rewording my comments to better reflect that are
> welcome.
>
>>
>> [...]
>>>   static const struct snd_soc_dai_ops axi_spdif_dai_ops = {
>>> @@ -216,14 +227,17 @@ static int axi_spdif_probe(struct platform_device
>>> *pdev)
>>>       spdif->dma_data.addr_width = 4;
>>>       spdif->dma_data.maxburst = 1;
>>>
>>> -    spdif->ratnum.num = clk_get_rate(spdif->clk_ref) / 128;
>>> -    spdif->ratnum.den_step = 1;
>>> -    spdif->ratnum.den_min = 1;
>>> -    spdif->ratnum.den_max = 64;
>>> -
>>> -    spdif->rate_constraints.rats = &spdif->ratnum;
>>> -    spdif->rate_constraints.nrats = 1;
>>> +    /* Determine if the clock rate is fixed. If it cannot change frequency,
>>> +     * it returns an error here. */
>>> +    if (clk_round_rate(spdif->clk_ref, 128 * 44100) < 0) {
>>
>> I don't think this works. For a fixed clock clk_round_rate() will return the
>> fixed rate rather than an error. I tried the patch and even though I have a
>> fixed clock the constraints are no longer set.
>>
>> There is unfortunately no good way to enumerate which frequencies are
>> supported by a clock other than just calling round_rate for all possible
>> rates.
>>
>> I think the best way to implement this for now is to try e.g. 32000 * 128,
>> 44100 * 128, 48000 * 128 and then check if clk_round_rate returns the
>> expected
>> rate and if it does set up a rate constraint for that rate.
>
> For what I could see, ALSA never reported or limited the sample rate
> correctly even before this patch, so maybe the even simpler approach is
> better: Just remove the constraint. I wonder how you concluded that the
> constraint didn't get added?

Newer versions of aplay e.g. support printing the initial constraints:
http://git.alsa-project.org/?p=alsa-utils.git;a=blob;f=aplay/aplay.c;h=e58e1bcbdd7e5c784b85df90f15ef41326d3f6dd;hb=HEAD#l240

And on older versions you can use -v to print the final constraints. E.g. 
without your patch I see "Actual rate: 96000/2 (48000)" and with your patch 
just "Actual rate: 48000".

The application you are using might just simply choose to ignore the 
constraints. But there are definitely applications which honer them which 
will break if the constraints are removed.

>
> Actually, the SPDIF logic wants a clock that is an "integer multiple of
> 128*samplerate in the range of 1..64". Other than just looping through them
> all, there's also no way to request the clock framework for such a requirement.
>
> Your suggestion is quite robust though, but the fixed clock may be set to
> any integer multiple of the desired frequency, so the algorithm would not
> work if the fixed clock is running at 48000*256 (12.8MHz like in the
> reference design). So I guess the best I could do here is just check that:
>
> clk_round_rate(spdif->clk_ref, 128 * 44100) !=
> clk_round_rate(spdif->clk_ref, 128 * 48000)
>

Sounds like a OK compromise.

- Lars

