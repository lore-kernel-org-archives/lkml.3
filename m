Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaLWRmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:42:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36159 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbaLWRmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:42:42 -0500
Message-ID: <5499A96D.4010704@ti.com>
Date: Tue, 23 Dec 2014 12:42:05 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <will.deacon@arm.com>
Subject: Re: [RFC v1 PATCH 1/2] of/pci: add of_pci_dma_configure() update
 dma configuration
References: <1418940425-2017-1-git-send-email-m-karicheri2@ti.com> <54989DDE.3060409@ti.com> <1723662.JYr5muIJha@wuerfel> <5090769.jqAkiDgYu7@wuerfel>
In-Reply-To: <5090769.jqAkiDgYu7@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 06:07 PM, Arnd Bergmann wrote:
> On Monday 22 December 2014 23:44:52 Arnd Bergmann wrote:
>> On Monday 22 December 2014 17:40:30 Murali Karicheri wrote:
>>> On 12/22/2014 05:24 PM, Arnd Bergmann wrote:
>>>> On Monday 22 December 2014 16:40:43 Murali Karicheri wrote:
>>>>>>> +++ b/arch/arm/mm/dma-mapping.c
>>>>>>> @@ -2052,9 +2052,10 @@ void arch_setup_dma_ops(struct device *dev, u64
>>>>>>> dma_base, u64 size,
>>>>>>>                             struct iommu_ops *iommu, bool coherent)
>>>>>>>      {
>>>>>>>             struct dma_map_ops *dma_ops;
>>>>>>> +       u64 temp_size = min((*(dev->dma_mask) + 1), size);
>>>>>>>
>>>>>>>             dev->archdata.dma_coherent = coherent;
>>>>>>> -       if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
>>>>>>> +       if (arm_setup_iommu_dma_ops(dev, dma_base, temp_size, iommu))
>>>>>>>
>>>>>>> If you agree, I will post v1 of the patch with these updates. Let me
>>>>>>> know. I did some basic tests on Keystone with these changes and it works
>>>>>>> fine.
>>>>>>
>>>>>> It's not exactly what I meant. My main point was that we need to limit
>>>>>> dev->dma_mask to (size-1) here, but you are not touching that.
>>>>>
>>>>> if you mean overriding the dev->dma_mask to min((*dev->dma_mask),
>>>>> size-1), then I am getting the error "Coherent DMA mask 0x7fffffff (pfn
>>>>> 0x780000-0x800000) covers a smaller range of system memory than the DMA
>>>>> zone pfn 0x0-0x880000) when the devices on Keystone tries to set the dma
>>>>> mask. Something wrong and I need to look into the code.
>>>>
>>>> Right, it sounds like the offset was applied incorrectly at some point.
>>>>
>>>> What are the DMA zone size and the phys-offset?
>>> 2G and 0x8_0000_0000. This limit the usable DMA size to 2G on Keystone,
>>> I believe you shouldn't be limiting the dma mask to size-1 in this case,
>>> right? The DT setup the dma-range to have a size of 2G (0x80000000).
>>
>> No, the problem is something else: the pfn range that we calculate for the
>> coherent DMA mask should have been 0x800000-0x880000, not 0x780000-0x800000,
>> so we would exactly match the ZONE_DMA.
>
> I gave it some more thought, and concluded that the size that gets passed
> down is not really the right value to be compared to a mask if the dma-capable
> area starts at a nonzero bus address.
>
> In your case, bus addresses 0x80000000-0xffffffff are valid for DMA, so
> the mask must be 0xffffffff to forbid any DMA to addresses larger than
> 0x100000000, not 0x7fffffff which would not be enough to cover any RAM.
>
> I guess the dma_mask should be 'min((*dev->dma_mask), dma_base + size - 1)'
> here.

Arnd,

I guess so. Besides we need to keep the default coherent dma mask to 
32bit 0xffffffffull as well to work on Keystone and also in sync with 
current defaults used in pci_device_add() so that we don't break this 
behavior.

Here is the summary of changes need to make on top of my existing patch.

1. of_dma_configure() - change size = dev->coherent_dma_mask to size = 
dev->coherent_dma_mask + 1. This is a new patch to fix existing code.

2. Do the above change to of_pci_dma_configure() as well.

3. in arch_setup_dma_ops() update the DMA mask to min((*dev->dma_mask), 
dma_base + size - 1) as


diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index c17f6a9..88b4769 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -2053,8 +2053,13 @@ void arch_setup_dma_ops(struct device *dev, u64 
dma_base, u64 size,
  {
         struct dma_map_ops *dma_ops;

+
+       *dev->dma_mask = min((*dev->dma_mask), (dma_base + size - 1));

I have tested this on keystone and it works fine with rootfs on PCI SATA 
harddisk. I will be doing more tests with this change. If you are in 
agreement with the above changes, I will re-spin the patch to accomodate 
them and send v1 of the same.

Regards,

Murali

>
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
