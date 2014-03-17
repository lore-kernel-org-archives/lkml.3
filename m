Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaCQTi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:38:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41129 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaCQTi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:38:26 -0400
Message-ID: <53274F0B.5070201@ti.com>
Date: Mon, 17 Mar 2014 15:37:47 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Sandeep Nair <sandeep_n@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] dma: Add Keystone Packet DMA Engine driver
References: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com> <20140311102357.GR1976@intel.com> <531F6908.4010104@ti.com> <20140312160017.GY1976@intel.com> <5320CEC4.1060306@ti.com> <20140317044223.GA1976@intel.com>
In-Reply-To: <20140317044223.GA1976@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2014 12:42 AM, Vinod Koul wrote:
> On Thu, Mar 13, 2014 at 05:16:52AM +0800, Santosh Shilimkar wrote:
>> On Thursday 13 March 2014 12:00 AM, Vinod Koul wrote:
>>> On Wed, Mar 12, 2014 at 03:50:32AM +0800, Santosh Shilimkar wrote:
>>>> On Tuesday 11 March 2014 06:23 PM, Vinod Koul wrote:
>>>>> On Fri, Feb 28, 2014 at 05:56:40PM -0500, Santosh Shilimkar wrote:
>>>>>> From: Sandeep Nair <sandeep_n@ti.com>
>>>>>>
>>>>>> The Packet DMA driver sets up the dma channels and flows for the
>>>>>> QMSS(Queue Manager SubSystem) who triggers the actual data movements
>>>>>> across clients using destination queues. Every client modules like
>>>>>> NETCP(Network Coprocessor), SRIO(Serial Rapid IO) and CRYPTO
>>>>>> Engines has its own instance of packet dma hardware. QMSS has also
>>>>>> an internal packet DMA module which is used as an infrastructure
>>>>>> DMA with zero copy.
>>>>>>
>>>>>> Patch adds DMAEngine driver for Keystone Packet DMA hardware.
>>>>>> The specifics on the device tree bindings for Packet DMA can be
>>>>>> found in:
>>>>>> 	Documentation/devicetree/bindings/dma/keystone-pktdma.txt
>>>>>>
>>>>>> The driver implements the configuration functions using standard DMAEngine
>>>>>> apis. The data movement is managed by QMSS device driver.
>>>>> Pls use subsystem appropriate name so here would have been dmaengine: ...
>>>>>
>>>>> So i am still missing stuff like prepare calls, irq, descriptor management to
>>>>> call this a dmaengine driver.
>>>>>
>>>>> I guess you need to explain a bit more why the data movement is handled by some
>>>>> other driver and not by this one
>>>>>
>>>> To expand above statement, Packet DMA hardware blocks on Keystone SOCs
>>>> are DMAEngines. QMSS is centralised subsystem manages multiple functionalities
>>>> including triggering dma transfers, descriptor management and completion
>>>> irqs. There are separate instance of packet DMA hardware block per client
>>>> device. We program the DMA hardware to allocate channels and flows. So
>>>> the packet DMA resouces like dma channels and dma flows are configured
>>>> and managed through the DMAEngine driver. Thats why we implement only
>>>> device_alloc_chan_resources, device_free_chan_resources and device_control
>>>> DMAEngine APIs.
>>> Sorry am bit lost. If its a dmaengine then you still need to program the
>>> transfers, how does that part work?
>>>
>> To simplify this bit more, you can think of this as DMA channels, flows
>> are allocated and DMA channels are enabled by DMA engine and they remains
>> enabled always as long as the channel in use. Enablling dma channel
>> actually don't start the DMA transfer but just sets up the connection/pipe
>> with peripheral and memory and vice a versa.
>>
>> All the descriptor management, triggering, sending completion interrupt or
>> hardware signal to DMAEngine all managed by centralised QMSS.
>>
>> Actual copy of data is still done by DMA hardware but its completely
>> transparent to software. DMAEngine hardware takes care of that in the
>> backyard.
> So you will use the dmaengine just for setting up the controller. Not for actual
> transfers. Those would be governed by the QMSS, right?
>
Correct.
 
> This means that someone expecting to use dmaengine API will get confused about
> this and doing part (alloc) thru dmaengine and rest (transfers) using some other
> API. This brings to me the design approach, does it really make sense creating
> dmaengine driver for this when we are not fully complying to the API
> 
Thats fair. The rationale behind usage of DMEngine was that its the closest
available subsystem which can be leveraged for this hardware. We can
pretty much use all the standard DMAEngine device tree parsing as well as
the config API to setup DMAs. 

I think you made your stand clear, just to confirm, you don't prefer this
driver to be a DMAEngine driver considering it doesn't fully complying to
the APIs. We could document the deviation of 'transfer' handling to avoid
any confusion.

Let me know your final thoughts and thanks a lot for the review.

Regards,
Santosh

