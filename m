Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaCEC0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:26:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48817 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbaCEC0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:26:45 -0500
Message-ID: <53168B39.8080906@ti.com>
Date: Wed, 5 Mar 2014 10:26:01 +0800
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <dmaengine@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Sandeep Nair <sandeep_n@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] dma: Add Keystone Packet DMA Engine driver
References: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com> <21183060.JRdahJE8pQ@wuerfel> <53111F5E.9080609@ti.com>
In-Reply-To: <53111F5E.9080609@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2014 07:44 AM, Santosh Shilimkar wrote:
> On Friday 28 February 2014 06:14 PM, Arnd Bergmann wrote:
>> On Friday 28 February 2014 17:56:40 Santosh Shilimkar wrote:
>>> The Packet DMA driver sets up the dma channels and flows for the
>>> QMSS(Queue Manager SubSystem) who triggers the actual data movements
>>> across clients using destination queues. Every client modules like
>>> NETCP(Network Coprocessor), SRIO(Serial Rapid IO) and CRYPTO
>>> Engines has its own instance of packet dma hardware. QMSS has also
>>> an internal packet DMA module which is used as an infrastructure
>>> DMA with zero copy.
>>>
>>> Patch adds DMAEngine driver for Keystone Packet DMA hardware.
>>> The specifics on the device tree bindings for Packet DMA can be
>>> found in:
>>>         Documentation/devicetree/bindings/dma/keystone-pktdma.txt
>>>
>>> The driver implements the configuration functions using standard DMAEngine
>>> apis. The data movement is managed by QMSS device driver.
>>
>> The description of this sounds a bit like the x-gene queue manager/tag
>> manager, rather than a traditional DMA engine. For that driver, we
>> decided to use the mailbox subsystem instead of the DMA subsystem.
>>
>> Can you explain what kind of data is actually getting transferred
>> in by your hardware here? You say the DMA is performed by the QMSS,
>> so do you use the pktdma driver to drive the data transfers of the
>> QMSS or do you just use it for flow control by passing short (a few
>> bytes) messages and also have to program the pktdma?
>>
> I don't know what x-gene stuff is, but the keystone packet dma
> is hardware DMA controller(per client subystem) which has all
> the traditional DMA controller properties. The packet DMA needs
> to be setup just like any slave dma configuration. The actual
> data transfers are triggered by operations on Queue Manager
> SubSystem.
>  
> I just posted the QMSS driver as well which explains how the system
> work. 
>
Updating the thread for record since me and Arnd had some more chat
at the Linaro Connect to extend the above description. Will try to
add some more information with updated patchset after aligning with
DMAEngine folks.
 
>>> +
>>> +bool dma_keystone_filter_fn(struct dma_chan *chan, void *param)
>>> +{
>>> +       if (chan->device->dev->driver == &keystone_dma_driver.driver) {
>>> +               struct keystone_dma_chan *kdma_chan = from_achan(chan);
>>> +               unsigned chan_id = *(u32 *)param & KEYSTONE_DMA_CHAN_ID_MASK;
>>> +               unsigned chan_type = *(u32 *)param >> KEYSTONE_DMA_TYPE_SHIFT;
>>> +
>>> +               if (chan_type == KEYSTONE_DMA_TX_CHAN_TYPE &&
>>> +                   kdma_chan->direction == DMA_MEM_TO_DEV)
>>> +                       return chan_id  == kdma_chan->channel;
>>> +
>>> +               if (chan_type == KEYSTONE_DMA_RX_FLOW_TYPE &&
>>> +                   kdma_chan->direction == DMA_DEV_TO_MEM)
>>> +                       return chan_id  == kdma_chan->flow;
>>> +       }
>>> +       return false;
>>> +}
>>> +EXPORT_SYMBOL_GPL(dma_keystone_filter_fn);
>>
>> The filter function should be removed here and replaced with a simpler
>> custom xlate function calling dma_get_slave_chan() on the matching
>> channel.
>>
> Can you please expand your comment please ? I though the filter function
> is the one should implement for specific channel allocations.
>
I got this clarified thanks to Arnd. We can get rid of the filter function
and use the xlate funtion.

 
>>> diff --git a/include/linux/keystone-pktdma.h b/include/linux/keystone-pktdma.h
>>> new file mode 100644
>>> index 0000000..e6a66c8
>>> --- /dev/null
>>> +++ b/include/linux/keystone-pktdma.h
>>> @@ -0,0 +1,168 @@
>>
>> A DMA engine driver should not have a public API. Please move all the
>> contents of the two header files into the driver itself to ensure none
>> of this is visible to slave drivers. If it turns out that you use
>> declarations from this header in slave drivers at the moment, please
>> explain what they are so we can discuss alternative solutions.
>>
> Yes the slave drivers make use of these. The dt-binding header is created
> because some the macro's are shared between DTS and code.
> 
> keystone-pktdma.h carriers information about the packet dma config
> which is done by slave drivers. It also contains the dma descriptor
> format and its associate macro's used by slave drivers. Since
> the hardware perspective, the descriptor represent the packet
> format dma expects and hence its left in the dma header header.
> 
Also i will remove the descriptor related fields in next version.

Regards,
Santosh

