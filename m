Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaJQQSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:18:31 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:48304 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbaJQQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:18:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,740,1406617200"; 
   d="scan'208";a="48709691"
Message-ID: <54414153.70804@broadcom.com>
Date: Fri, 17 Oct 2014 09:18:27 -0700
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>,
        Scott Branden <sbranden@broadcom.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: pl330: use subsys_initcall
References: <rjui@broadcom.com> <1413506896-4536-1-git-send-email-rjui@broadcom.com> <5440C929.9050906@metafoo.de> <20141017073535.GN1638@intel.com> <5440FA6B.6040303@metafoo.de>
In-Reply-To: <5440FA6B.6040303@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 4:15 AM, Lars-Peter Clausen wrote:
> On 10/17/2014 09:35 AM, Vinod Koul wrote:
>> On Fri, Oct 17, 2014 at 09:45:45AM +0200, Lars-Peter Clausen wrote:
>>> On 10/17/2014 02:48 AM, Ray Jui wrote:
>>>> As part of subsystem that many slave drivers depend on, it's more
>>>> appropriate for the pl330 DMA driver to be initialized at
>>>> subsys_initcall than device_initcall
>>>
>>> Well, we do have -EPROBE_DEFER these days to handle these kinds of
>>> dependencies so we no longer have to these kinds of manual init
>>> reordering tricks.
>> How ould that work?
>>
>> Consider for example SPI and dmanegine. SPI driver got probed, then to
>> start
>> a transaction requested a channel... while dmaengine driver is still
>> getting
>> probed/not probed yet. So SPI driver didnt get a channel.
>>
>
> Ideally the SPI driver requests the channel in probe function and if the
> DMA controller is not yet probed returns EPROBE_DEFER. If the SPI driver
> requests the channel in the transfer handler it needs to deal with being
> able to fall back to non DMA transfers anyway so this shouldn't be a
> problem.
So in the case of the spi-pl022 driver. It requests the channel in probe 
function. And obviously DMA is not mandatory, so when the channel 
request fails the probe won't fail and instead it falls back to PIO. In 
this case, can you recommend a different way to solve this problem 
without having the DMA driver probed earlier than its slaves?

>
> But in any case fiddling around with the init sequences is just a quick
> hack and might makes the problem less likely to appear in some cases,
> but there is no guarantee that it works. And I think the proper solution
> at the moment is to use probe deferral.
I think it makes sense to have the DMA driver, as one of the core 
components in various SoCs that a lot of peripheral drivers depend on, 
to be registered at the level of subsys_init or somewhere close. We are 
not changing this just to get SPI to work. We are changing this because 
we think DMA should be ready before a lot of its slaves, which are 
typically done at device_initcall.

I have no problem relying on EPROBE_DEFER for this, provided that it 
works. The issue is, like I mentioned above, for a lot of slave devices 
DMA is not mandatory, when DMA fails at probe they would fall back to 
PIO and never use DMA. Another disadvantage I see with EPROBE_DEFER is 
delayed boot time.

>
> Other subsystems have seen patches which moved drivers from using
> subsys_initcall to device_initcall/module_..._driver/ with the reasoning
> that this is no longer necessary because of EPROBE_DEFER. So I don't
> think we should be doing the exact opposite in DMA framework. Also if
> we'd apply this patch it won't take to long until somebody suggest going
> back to module_platform_driver() instead of subsys_initcall.
>
> - Lars
There are currently 12 DMA drivers under drivers/dma registering 
themselves at subsys_init. I don't see why pl330 cannot do the same. Is 
there any concern that it may not work for some other SoCs when it's 
done at subsys_init? So far I cannot think of any. The only dependency 
of pl330 is the ARM apb_pclk, required during AMBA bus probe. But that's 
usually ready before subsys_init.

Thanks,

Ray
