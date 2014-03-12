Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaCLVRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:17:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56275 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbaCLVRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:17:46 -0400
Message-ID: <5320CEC4.1060306@ti.com>
Date: Thu, 13 Mar 2014 05:16:52 +0800
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
References: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com> <20140311102357.GR1976@intel.com> <531F6908.4010104@ti.com> <20140312160017.GY1976@intel.com>
In-Reply-To: <20140312160017.GY1976@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2014 12:00 AM, Vinod Koul wrote:
> On Wed, Mar 12, 2014 at 03:50:32AM +0800, Santosh Shilimkar wrote:
>> On Tuesday 11 March 2014 06:23 PM, Vinod Koul wrote:
>>> On Fri, Feb 28, 2014 at 05:56:40PM -0500, Santosh Shilimkar wrote:
>>>> From: Sandeep Nair <sandeep_n@ti.com>
>>>>
>>>> The Packet DMA driver sets up the dma channels and flows for the
>>>> QMSS(Queue Manager SubSystem) who triggers the actual data movements
>>>> across clients using destination queues. Every client modules like
>>>> NETCP(Network Coprocessor), SRIO(Serial Rapid IO) and CRYPTO
>>>> Engines has its own instance of packet dma hardware. QMSS has also
>>>> an internal packet DMA module which is used as an infrastructure
>>>> DMA with zero copy.
>>>>
>>>> Patch adds DMAEngine driver for Keystone Packet DMA hardware.
>>>> The specifics on the device tree bindings for Packet DMA can be
>>>> found in:
>>>> 	Documentation/devicetree/bindings/dma/keystone-pktdma.txt
>>>>
>>>> The driver implements the configuration functions using standard DMAEngine
>>>> apis. The data movement is managed by QMSS device driver.
>>> Pls use subsystem appropriate name so here would have been dmaengine: ...
>>>
>>> So i am still missing stuff like prepare calls, irq, descriptor management to
>>> call this a dmaengine driver.
>>>
>>> I guess you need to explain a bit more why the data movement is handled by some
>>> other driver and not by this one
>>>
>> To expand above statement, Packet DMA hardware blocks on Keystone SOCs
>> are DMAEngines. QMSS is centralised subsystem manages multiple functionalities
>> including triggering dma transfers, descriptor management and completion
>> irqs. There are separate instance of packet DMA hardware block per client
>> device. We program the DMA hardware to allocate channels and flows. So
>> the packet DMA resouces like dma channels and dma flows are configured
>> and managed through the DMAEngine driver. Thats why we implement only
>> device_alloc_chan_resources, device_free_chan_resources and device_control
>> DMAEngine APIs.
> Sorry am bit lost. If its a dmaengine then you still need to program the
> transfers, how does that part work?
>
To simplify this bit more, you can think of this as DMA channels, flows
are allocated and DMA channels are enabled by DMA engine and they remains
enabled always as long as the channel in use. Enablling dma channel
actually don't start the DMA transfer but just sets up the connection/pipe
with peripheral and memory and vice a versa.

All the descriptor management, triggering, sending completion interrupt or
hardware signal to DMAEngine all managed by centralised QMSS.

Actual copy of data is still done by DMA hardware but its completely
transparent to software. DMAEngine hardware takes care of that in the
backyard.


>>>> +#define BITS(x)			(BIT(x) - 1)
>>> this might get confusing, perhaps a better name could be given?
>>>
>> Would "BIT_MASK" be ok with you ?
> something which would imply its x -1, am not really good with name so no
> suggestions :)
> 
me too. BIT_INVERT_MASK() ?

>>>> +
>>>> +#define BUILD_CHECK_REGS()						\
>>>> +	do {								\
>>>> +		BUILD_BUG_ON(sizeof(struct reg_global)   != 32);	\
>>>> +		BUILD_BUG_ON(sizeof(struct reg_chan)     != 32);	\
>>>> +		BUILD_BUG_ON(sizeof(struct reg_rx_flow)  != 32);	\
>>>> +		BUILD_BUG_ON(sizeof(struct reg_tx_sched) !=  4);	\
>>>> +	} while (0)
>>> why is this required, do you want to use __packed__ to ensure right size?
>>>
>> This is just to ensure the register sanity. We should use __packed__ as
>> well. We can take the BUILD_CHECK_REGS() out if you don't prefer it.
> putting packed ensures so no need for this check.
> 
OK
