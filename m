Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaDKJim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:38:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55830 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaDKJii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:38:38 -0400
Message-ID: <5347B7F8.2000508@ti.com>
Date: Fri, 11 Apr 2014 12:38:00 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH v2 05/14] arm: common: edma: Select event queue 1 as default
 when booted with DT
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com> <5347A4FD.1030803@ti.com> <5347ACDE.7040407@ti.com> <5347AE49.5020109@ti.com>
In-Reply-To: <5347AE49.5020109@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 11:56 AM, Sekhar Nori wrote:
> On Friday 11 April 2014 02:20 PM, Peter Ujfalusi wrote:
>> On 04/11/2014 11:17 AM, Sekhar Nori wrote:
>>> On Tuesday 01 April 2014 06:36 PM, Peter Ujfalusi wrote:
>>>> Use the EVENTQ_1 for default and leave the EVENTQ_0 to be used by high
>>>> priority channels, like audio.
>>>>
>>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>>
>>> Acked-by: Sekhar Nori <nsekhar@ti.com>
>>>
>>>> ---
>>>>  arch/arm/common/edma.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
>>>> index 86a8b263278f..19520e2519d9 100644
>>>> --- a/arch/arm/common/edma.c
>>>> +++ b/arch/arm/common/edma.c
>>>> @@ -1546,7 +1546,8 @@ static int edma_of_parse_dt(struct device *dev,
>>>>  
>>>>  	pdata->queue_priority_mapping = queue_priority_map;
>>>>  
>>>> -	pdata->default_queue = 0;
>>>> +	/* select queue 1 as default */
>>>
>>> It will be nice to expand the comment with explanation of why this is
>>> being chosen as default (lower priority queue by default for typical
>>> bulk data transfer).
>>
>> Yes, extended comment is a good idea.
>>
>> For the next version I think I'm going to change the code around default
>> TC/Queue and the non default queue selection, mostly based on Joel's comment:
>>
>> EVENTQ_1 as default queue.
>> Set the EVENTQ_1 priority to 7
>> EVENTQ_0 priority is going to stay 0 and EVENTQ_2 as 2
>>
>> Add new member to struct edma, like high_pri_queue.
>> When we set the queue priorities in edma_probe() we look for the highest
>> priority queue and save the number in high_pri_queue.
>>
>> I will rename the edma_request_non_default_queue() to
>> edma_request_high_pri_queue() and it will assign the channel to the high
>> priority queue.
>>
>> I think this way it is going to be more explicit and IMHO a bit more safer in
>> a sense the we are going to get high priority when we ask for it.
> 
> Sounds much better. I had posted some ideas about adding support for
> channel priority in the core code but we can leave that for Vinod and
> Dan to say if they really see a need for that.

If we do it via the dmaengine core I think it would be better to have a new
flag to be passed to dmaengine_prep_dma_*().
We could have for example:
DMA_PREP_HIGH_PRI as flag to indicate that we need high priority DMA if it is
possible.
We can watch for this flag in the edma driver and act accordingly.
ALSA's dmaengine_pcm_prepare_and_submit() could set this flag unconditionally
since audio should be treated in this way if the DMA IP can do this.

Not sure what to do with eDMA's 8 priority level. With that we could have high
priority; low priority; low, but not the lowest priority; about in the middle
priority; etc.

We could have also new callback in the dma_device struct with needed wrappers
to set priority level, but where to draw the range? High, Mid and Low? Range
of 0 - 10?

-- 
Péter
