Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaHDGpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:45:45 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44022 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaHDGpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:45:42 -0400
Message-ID: <53DF2B7B.4000605@huawei.com>
Date: Mon, 4 Aug 2014 14:43:07 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <Paul.Mundt@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>,
        <linux-pci@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        <virtualization@lists.linux-foundation.org>,
        Xinwei Hu <huxinwei@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Wuyun <wuyun.wu@huawei.com>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <1748052.OMBQJiOLYT@wuerfel> <53D85C2E.3060205@huawei.com> <201408011552.32135.arnd@arndb.de>
In-Reply-To: <201408011552.32135.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/1 21:52, Arnd Bergmann wrote:
> On Wednesday 30 July 2014, Yijing Wang wrote:
>> On 2014/7/29 22:08, Arnd Bergmann wrote:
>>> On Saturday 26 July 2014 11:08:37 Yijing Wang wrote:
>>>>
>>>> The new data struct for generic MSI driver.
>>>> struct msi_irqs {
>>>>         u8 msi_enabled:1; /* Enable flag */
>>>>         u8 msix_enabled:1;
>>>>         struct list_head msi_list; /* MSI desc list */
>>>>         void *data;     /* help to find the MSI device */
>>>>         struct msi_ops *ops; /* MSI device specific hook */
>>>> };
>>>> struct msi_irqs is used to manage MSI related informations. Every device supports
>>>> MSI should contain this data struct and allocate it.
>>>
>>> I think you should have a stronger association with the 'struct
>>> device' here. Can you replace the 'void *data' with 'struct device *dev'?
>>
>> Actually, I used the struct device *dev in my first draft, finally, I replaced
>> it with void *data, because some MSI devices don't have a struct device *dev,
>> like the existing hpet device, dmar msi device, and OF device, like the ARM consolidator.
>>
>> Of course, we can make the MSI devices have their own struct device, and register to
>> device tree, eg, add a class device named MSI_DEV. But I'm not sure whether it is appropriate.
> 
> It doesn't have to be in the (OF) device tree, but I think it absolutely makes
> sense to use the 'struct device' infrastructure here, as almost everything uses
> a device, and the ones that don't do that today can be easily changed.

I will try to use "struct device" infrastructure, thanks for your suggestion. :)

> 
>>> The other part I'm not completely sure about is how you want to
>>> have MSIs map into normal IRQ descriptors. At the moment, all
>>> MSI users are based on IRQ numbers, but this has known scalability problems.
>>
>> Hmmm, I still use the IRQ number to map the MSIs to IRQ description.
>> I'm sorry, I don't understand you meaning.
>> What are the scalability problems you mentioned ?
>> For device drivers, they always process interrupt in two steps.
>> If irq is the legacy interrupt, drivers will first
>> use the irq_of_parse_and_map() or pci_enable_device() to parse and get the IRQ number.
>> Then drivers will call the request_irq() to register the interrupt handler.
>> If irq is MSIs, first call pci_enable_msi/x() to get the IRQ number and then call
>> request_irq() to register interrupt handler.
> 
> The method you describe here makes sense for PCI devices that are required to support
> legacy interrupts and may or may not support MSI on a given system, but not so much
> for platform devices for which we know exactly whether we want to use MSI
> or legacy interrupts.
> 
> In particular if you have a device that can only do MSI, the entire pci_enable_msi
> step is pointless: all we need to do is program the correct MSI target address/message
> pair into the device and register the handler.

Yes, I almost agree if we won't change the existing hundreds of drivers, what
I worried about is some drivers may want to know the IRQ numbers, and use the IRQ
number to process different things, as I mentioned in another reply.
But we can also provide the interface which integrate MSI configuration and request_irq(),
if most drivers don't care the IRQ number.

> 
>>> I wonder if we can do the interface in a way that
>>> hides the interrupt number from generic device drivers and just
>>> passes a 'struct irq_desc'. Note that there are long-term plans to
>>> get rid of IRQ numbers entirely, but those plans have existed for
>>> a long time already without anybody seriously addressing the device
>>> driver interfaces so far, so it might never really happen.
>>>
>>
>> Maybe this is a huge work, now hundreds drivers use the IRQ number, so maybe we can consider
>> this in a separate title.
> 
> Sorry for being unclear here: I did suggest changing all drivers now. What I meant
> is that we use a different API for non-PCI devices that works without IRQ numbers.
> I don't think we should touch the PCI interfaces at this point.

OK, I got it.

>>> What I'd envision as the API from the device driver perspective is something
>>> as simple like this:
>>>
>>> struct msi_desc *msi_request(struct msi_chip *chip, irq_handler_t handler,
>>> 			unsigned long flags, const char *name, struct device *dev);
>>>
>>> which would get an msi descriptor that is valid for this device (dev)
>>> connected to a particular msi_chip, and associate a handler function
>>> with it. The device driver can call that function and retrieve the
>>> address/message pair from the msi_desc in order to store it in its own
>>> device specific registers. The request_irq() can be handled internally
>>> to msi_request().
>>
>> This is a huge change for device drivers, and some device drivers don't know which msi_chip
>> their MSI irq deliver to. I'm reworking the msi_chip, and try to use msi_chip to eliminate
>> all arch_msi_xxx() under every arch in kernel. And the important point is how to create the
>> binding for the MSI device to the target msi_chip.
> 
> Which drivers are you thinking of? Again, I wouldn't expect to change any PCI drivers,
> but only platform drivers that do native MSI, so we only have to change drivers that
> do not support any MSI at all yet and that need to be changed anyway in order to add
> support.

I mean platform device drivers, because we can find the target msi_chip by some platform
interfaces(like the existing of_pci_find_msi_chip_by_node()). So we no need to explicitly provide
the msi_chip as the function argument.

> 
>> For PCI device, some arm platform already bound the msi_chip to the pci hostbridge, then all
>> pci devices under the pci hostbridge deliver their MSI irqs to the target msi_chip.
>> And other platform create the binding in DTS file, then the MSI device can find their msi_chip
>> by device_node.
>> I don't know whether there are other situations, we should provide a generic interface that
>> every MSI device under every platform can use it to find its msi_chip exactly.
> 
> We have introduced the "msi-parent" property to mirror the "interrupt-parent" property.
> For the PCI case, this property is only needed in the PCI host controller, and there
> can be a system-wide default, by putting the "msi-parent" property into the root device
> node or the node of a bus that is parent to all devices supporting MSI.
> 
> For non-PCI devices, it should be possible to override the "msi-parent" property per
> device, but those can also use the global property.
> 
> The main use case that I see are PCI host controllers that have their own MSI catcher
> included, so meaning that any PCI device can either send its MSIs there, or to a
> system-wide GICv3 instance, and we need a way to select which one.

Yes, agree.

> 
> A degenerate case of this would be a system where a PCI device sends its MSI into
> the host controller, that generates a legacy interrupt and that in turn gets 
> sent to an irqchip which turns it back into an MSI for the GICv3. This would of
> course be very inefficient, but I think we should be able to express this with
> both the binding and the in-kernel framework just to be on the safe side.

Yes, the best way to tell the kernel which msi_chip should deliver to is describe
the binding in DTS file. If a real degenerate case found, we can update the platform
interface which is responsible for getting the match msi_chip in future.

> 
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


-- 
Thanks!
Yijing

