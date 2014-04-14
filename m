Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaDNMmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:42:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37286 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbaDNMmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:42:22 -0400
Message-ID: <534BD788.3050406@ti.com>
Date: Mon, 14 Apr 2014 15:41:44 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, Vinod Koul <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <joelf@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>,
        Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH v2 05/14] arm: common: edma: Select event queue 1 as default
 when booted with DT
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com> <5347A4FD.1030803@ti.com> <5347ACDE.7040407@ti.com> <5347AE49.5020109@ti.com> <5347B7F8.2000508@ti.com> <20140411094217.GA32284@intel.com> <5347D2CC.4030407@ti.com> <20140411113154.GB32284@intel.com> <5347DEDA.2060008@ti.com> <20140411124641.GC32284@intel.com> <534BCCD3.9060805@ti.com> <534BD0B5.5000004@ti.com>
In-Reply-To: <534BD0B5.5000004@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 03:12 PM, Sekhar Nori wrote:
> On Monday 14 April 2014 05:26 PM, Peter Ujfalusi wrote:
>> Hi Vinod,
>>
>> On 04/11/2014 03:46 PM, Vinod Koul wrote:
>>> I think the number shouldn't be viewed in absolute terms. If we decide that (lets
>>> say) 0-7, then any controller should map 0 to lowest and 7 to highest.
>>>
>>> For your case you can do this and then intermediate numbers would be medium
>>> priority. Such a system might work well...
>>>
>>> Also how would a client driver know which priority to use? Would it come from
>>> DT?
>>
>> I think DT would be the best place.
> 
> In the strict sense of what DT is supposed to represent, DT is not the
> best place for this. Priority is usecase driven rather that hardware
> description driven.

While this is true, the DMA priority - if supported by the DMA engine - is a
HW feature as well. If it is supported by the HW it can be used to tune and
partition the system for the anticipated load or purpose.

> So on a reasonably less loaded system, I am sure you
> could run audio even with a lower priority DMA queue.

Yes, you can. But as soon as you have other devices using the same priority
(with eDMA3 at least) and asks for a 'long' transfer it can ruin the audio.
During audio playback/capture you execute a long MMC read for example can
introduce a glitch.

> Moreover, IMHO, encoding it in DT now will make it an ABI. Without a
> wide variety of example use cases, I think it is too early to commit to
> an ABI.

True, but we need to start from somewhere?

I'm fine if we handle this right now as I did in this series (to put only
cyclic on high priority) for now. With some forward looking changes in the
implementation of course.

>> Not sure if we should set the range for this either. What I was thinking is to
>> add an optional new property to be set by the client nodes, using DMA:
>>
>> mcasp0: mcasp@48038000 {
>> 	compatible = "ti,am33xx-mcasp-audio";
>> 	...
>> 	dmas =	<&edma 8>,
>> 		<&edma 9>;
>> 	dma-names = "tx", "rx";
>> 	dma-priorities = <2>, <2>;
>> };
>>
>> We could agree that lower number means lower priority, higher is - well -
>> higher priority.
>> If the dma-priority is missing we should assume lowest priority (0).
>> The highest priority depends on the platform. For eDMA3 in AM335x it is three
>> level. For designware controller you might have the range 0-8 as valid.
>>
>> The question is how to get this information into use?
>> We can take the priority number in the core when the dma channel is requested
>> and add field to "struct dma_chan" in order to store it and the DMA drivers
>> could have access to it.
>> In this way we only need to update the nodes which needs non default priority
>> for DMA.
>>
>> What do you think?
> 
> If we are using dma_slave_config, I think it will be easiest to define
> two levels of priority (HIGH and LOW, as thats all we see a need for
> right now), and have the audio driver select the HIGH priority. If
> nothing is set, EDMA can default to LOW.

But the information on which channel should be high priority should be coming
form somewhere... We can wire it in the audio stack, but I don't think it is a
good idea to start with.
And if we have high/low priority we could as well have an integer to specify
the desired level.

-- 
Péter
