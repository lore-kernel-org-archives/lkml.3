Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbaDKJvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:51:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:55333 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbaDKJvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:51:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,841,1389772800"; 
   d="scan'208";a="518852524"
Date: Fri, 11 Apr 2014 15:12:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, joelf@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, mporter@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH v2 05/14] arm: common: edma: Select event queue 1 as
 default when booted with DT
Message-ID: <20140411094217.GA32284@intel.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
 <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com>
 <5347A4FD.1030803@ti.com>
 <5347ACDE.7040407@ti.com>
 <5347AE49.5020109@ti.com>
 <5347B7F8.2000508@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5347B7F8.2000508@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 12:38:00PM +0300, Peter Ujfalusi wrote:
> On 04/11/2014 11:56 AM, Sekhar Nori wrote:
> > On Friday 11 April 2014 02:20 PM, Peter Ujfalusi wrote:
> >> On 04/11/2014 11:17 AM, Sekhar Nori wrote:
> >>> On Tuesday 01 April 2014 06:36 PM, Peter Ujfalusi wrote:
> >>>> Use the EVENTQ_1 for default and leave the EVENTQ_0 to be used by high
> >>>> priority channels, like audio.
> >>>>
> >>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >>>
> >>> Acked-by: Sekhar Nori <nsekhar@ti.com>
> >>>
> >>>> ---
> >>>>  arch/arm/common/edma.c | 3 ++-
> >>>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> >>>> index 86a8b263278f..19520e2519d9 100644
> >>>> --- a/arch/arm/common/edma.c
> >>>> +++ b/arch/arm/common/edma.c
> >>>> @@ -1546,7 +1546,8 @@ static int edma_of_parse_dt(struct device *dev,
> >>>>  
> >>>>  	pdata->queue_priority_mapping = queue_priority_map;
> >>>>  
> >>>> -	pdata->default_queue = 0;
> >>>> +	/* select queue 1 as default */
> >>>
> >>> It will be nice to expand the comment with explanation of why this is
> >>> being chosen as default (lower priority queue by default for typical
> >>> bulk data transfer).
> >>
> >> Yes, extended comment is a good idea.
> >>
> >> For the next version I think I'm going to change the code around default
> >> TC/Queue and the non default queue selection, mostly based on Joel's comment:
> >>
> >> EVENTQ_1 as default queue.
> >> Set the EVENTQ_1 priority to 7
> >> EVENTQ_0 priority is going to stay 0 and EVENTQ_2 as 2
> >>
> >> Add new member to struct edma, like high_pri_queue.
> >> When we set the queue priorities in edma_probe() we look for the highest
> >> priority queue and save the number in high_pri_queue.
> >>
> >> I will rename the edma_request_non_default_queue() to
> >> edma_request_high_pri_queue() and it will assign the channel to the high
> >> priority queue.
> >>
> >> I think this way it is going to be more explicit and IMHO a bit more safer in
> >> a sense the we are going to get high priority when we ask for it.
> > 
> > Sounds much better. I had posted some ideas about adding support for
> > channel priority in the core code but we can leave that for Vinod and
> > Dan to say if they really see a need for that.
Is it part of this series?

> If we do it via the dmaengine core I think it would be better to have a new
> flag to be passed to dmaengine_prep_dma_*().
> We could have for example:
> DMA_PREP_HIGH_PRI as flag to indicate that we need high priority DMA if it is
> possible.
> We can watch for this flag in the edma driver and act accordingly.
> ALSA's dmaengine_pcm_prepare_and_submit() could set this flag unconditionally
> since audio should be treated in this way if the DMA IP can do this.
Will the priority be different for each descriptor or would be based on channel
usage. If not then we can add this in dma_slave_config ?

I can forsee its usage on slave controllers, so yes its useful :)

-- 
~Vinod

> 
> Not sure what to do with eDMA's 8 priority level. With that we could have high
> priority; low priority; low, but not the lowest priority; about in the middle
> priority; etc.
> 
> We could have also new callback in the dma_device struct with needed wrappers
> to set priority level, but where to draw the range? High, Mid and Low? Range
> of 0 - 10?
> 
> -- 
> Péter

-- 
