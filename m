Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaLRTCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:02:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36720 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaLRTCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:02:53 -0500
Message-ID: <549324B9.2030506@ti.com>
Date: Thu, 18 Dec 2014 14:02:17 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <vinod.koul@intel.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <bhelgaas@google.com>, <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH 1/2] common: dma-mapping: introduce dma_get_parent_cfg()
 helper
References: <1418839344-14393-1-git-send-email-m-karicheri2@ti.com> <1949667.gMcOLHe7Sk@wuerfel> <549210BB.9080603@ti.com> <2935351.ba8Au9y4fE@wuerfel>
In-Reply-To: <2935351.ba8Au9y4fE@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 07:09 PM, Arnd Bergmann wrote:
> On Wednesday 17 December 2014 18:24:43 Murali Karicheri wrote:
>> On 12/17/2014 04:56 PM, Arnd Bergmann wrote:
>>> On Wednesday 17 December 2014 13:02:23 Murali Karicheri wrote:
>>>
>>> What's wrong with using arch_setup_dma_ops() from PCI as suggested
>>> previously?
>>>
>
> +Will Deacon
>
>> I had originally written a code based on that line as below. But
>> dma-ranges property is also used by ppc and other architectures in the
>> pci device DT node. So I wasn't sure how this code impact PCI driver
>> functionality on those platforms. Hence used a simpler change as all
>> that is needed for keystone is to get the dma_pfn_offset rightly set in
>> the pci slave device.
>
> But in your patch, you don't call arch_setup_dma_ops() at all.
>
>> Initially I had a function implemented as below for this in of_pci.c.
>>
>> + * of_pci_dma_configure - Setup DMA configuration for a pci device
>> + * @dev:       pci device to apply DMA configuration
>> + *
>> + * Try to get devices's DMA configuration from DT and update it
>> + * accordingly. This is a similar to of_dma_configure() for platform
>> + * devices.
>> + *
>> + */
>> +void of_pci_dma_configure(struct pci_dev *dev)
>> +{
>> +       struct device *host_bridge, *parent;
>> +       struct pci_bus *bus = dev->bus;
>> +       u64 dma_addr, paddr, size;
>> +       int ret;
>> +
>> +       while (!pci_is_root_bus(bus))
>> +               bus = bus->parent;
>> +       host_bridge = bus->bridge;
>> +
>> +       parent = host_bridge->parent;
>> +       if (parent->of_node) {
>
> so far it looks good, although we may want to introduce
> a helper function to get the of_node.

Will add

>
>> +               /*
>> +                * if dma-coherent property exist, call arch hook to setup
>> +                * dma coherent operations.
>> +                */
>> +               if (of_dma_is_coherent(parent->of_node)) {
>> +                       set_arch_dma_coherent_ops(&dev->dev);
>> +                       dev_info(&dev->dev, "device is dma coherent\n");
>> +               }
>
> set_arch_dma_coherent_ops no longer exists. Just keep the flag in a
> local variable

Ok.

>
>> +               /*
>> +                * if dma-ranges property doesn't exist - just return else
>> +                * setup the dma offset
>> +                */
>> +               ret = of_dma_get_range(parent->of_node,&dma_addr,
>> &paddr,&size);
>> +               if (ret<  0) {
>> +                       dev_info(&dev->dev, "no dma range information to
>> setup\n");
>> +                       printk("no dma range information to setup\n");
>> +                       return;
>> +               }
>> +
>> +               /* DMA ranges found. Calculate and set dma_pfn_offset */
>> +               dev->dev.dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
>> +               dev_info(&dev->dev, "dma_pfn_offset(%#08lx)\n",
>> dev->dev.dma_pfn_offset);
>
> Same for the offset and size here, then pass all of the above into
> arch_setup_dma_ops. This is also where we need to hook up the iommu
> support once we decide how to make that work with the ARM SMMU.

Ok. I will make this similar to of_dma_configure() that can be called 
from pci/probe.c

Murali
>
> Will, I think we may have a problem on ARM64 now, since we only replaced
> set_arch_dma_coherent_ops on ARM32 but not ARM64. Can you send a fix for
> this? Without that, we don't have any coherent operations on ARM64 any
> more, unless I'm missing something.
>
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
