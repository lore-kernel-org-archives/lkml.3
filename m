Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbaJUQR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:17:58 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:1067 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaJUQR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:17:57 -0400
X-IronPort-AV: E=Sophos;i="5.04,763,1406617200"; 
   d="scan'208";a="49005707"
Message-ID: <54468733.6080802@broadcom.com>
Date: Tue, 21 Oct 2014 09:17:55 -0700
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, Lars-Peter Clausen <lars@metafoo.de>
CC: Dan Williams <dan.j.williams@intel.com>,
        Scott Branden <sbranden@broadcom.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: pl330: use subsys_initcall
References: <rjui@broadcom.com> <1413506896-4536-1-git-send-email-rjui@broadcom.com> <5440C929.9050906@metafoo.de> <20141017073535.GN1638@intel.com> <5440FA6B.6040303@metafoo.de> <54414153.70804@broadcom.com> <5441464D.8040303@metafoo.de> <20141021104540.GL28745@intel.com>
In-Reply-To: <20141021104540.GL28745@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/21/2014 3:45 AM, Vinod Koul wrote:
> On Fri, Oct 17, 2014 at 06:39:41PM +0200, Lars-Peter Clausen wrote:
>> On 10/17/2014 06:18 PM, Ray Jui wrote:
>>> On 10/17/2014 4:15 AM, Lars-Peter Clausen wrote:
>>>> On 10/17/2014 09:35 AM, Vinod Koul wrote:
>>>>> On Fri, Oct 17, 2014 at 09:45:45AM +0200, Lars-Peter Clausen wrote:
>>>>>> On 10/17/2014 02:48 AM, Ray Jui wrote:
>>>>>>> As part of subsystem that many slave drivers depend on, it's more
>>>>>>> appropriate for the pl330 DMA driver to be initialized at
>>>>>>> subsys_initcall than device_initcall
>>>>>>
>>>>>> Well, we do have -EPROBE_DEFER these days to handle these kinds of
>>>>>> dependencies so we no longer have to these kinds of manual init
>>>>>> reordering tricks.
>>>>> How ould that work?
>>>>>
>>>>> Consider for example SPI and dmanegine. SPI driver got probed, then to
>>>>> start
>>>>> a transaction requested a channel... while dmaengine driver is still
>>>>> getting
>>>>> probed/not probed yet. So SPI driver didnt get a channel.
>>>>>
>>>>
>>>> Ideally the SPI driver requests the channel in probe function and if the
>>>> DMA controller is not yet probed returns EPROBE_DEFER. If the SPI driver
>>>> requests the channel in the transfer handler it needs to deal with being
>>>> able to fall back to non DMA transfers anyway so this shouldn't be a
>>>> problem.
>>> So in the case of the spi-pl022 driver. It requests the channel in probe
>>> function. And obviously DMA is not mandatory, so when the channel request
>>> fails the probe won't fail and instead it falls back to PIO. In this case,
>>> can you recommend a different way to solve this problem without having the
>>> DMA driver probed earlier than its slaves?
>>
>>
>> dma_request_slave_channel() has the problem that we can't
>> differentiate between no channel provided and channel provided but
>> the dma driver hasn't probed yet. The function will return NULL in
>> both cases. But Stephen Warren added
>> dma_request_slave_channel_reason() a while ago to solve this
>> problem. This function returns a ERR_PTR. If it returns
>> ERR_PTR(-EPROBE_DEFER) it means that a channel has been provided but
>> the DMA driver hasn't probed yet. In this case the SPI driver should
>> return -EPROBE_DEFER to try again later. If the function returns a
>> different error code that means that it was not possible to get the
>> DMA channel and it should fall back to PIO.
> So when should the SPI here check, if dmaengine is available. The client
> doesn't grab channel in its probe, so the client cannot return
> -EPROBE_DEFER.
>
Currently the spi-pl022 driver requests its DMA channel in 
pl022_dma_autoprobe, called during driver probe. Lars suggested changing 
the dma_request_slave_channel call to dma_request_slave_channel_reason. 
 From my understanding, dma_request_slave_channel_reason should return 
-EPROBE_DEFER if the DMA controller (pl330) device node and its channels 
are declared in device tree but the driver hasn't been probed. The SPI 
driver can then return -EPROBE_DEFER, which will cause its probe to be 
done again, at a later time. By then the pl330 driver will be ready.

This will solve our problem, because we don't care when SPI is probed, 
but we want to use DMA instead of PIO. But for the original problem that 
Linus tried to solve by moving spi probe to subsys_initcall in 25c8e03b, 
if one wants spi probe to be done that early, it will not be able to use 
DMA with the currently proposed change.
