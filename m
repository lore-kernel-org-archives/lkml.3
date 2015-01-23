Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbbAWSfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:35:55 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:64704 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbbAWSfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:35:53 -0500
MIME-Version: 1.0
In-Reply-To: <54C2909C.2070705@ti.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
 <3861625.CJ6m15sZMh@wuerfel> <54AED9EC.1020703@ti.com> <2083932.v1GzgAfexK@wuerfel>
 <CAL_JsqLG2OQL2TMMrXi4U0PU1vNzgodUehoZwpds5z8JKsB1jQ@mail.gmail.com> <54C2909C.2070705@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 23 Jan 2015 12:35:31 -0600
Message-ID: <CAL_JsqKi_qThWpRDq48bTnEOAAfvNiNH7R_Aa+O2-f3qLL+ixA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] of: move of_dma_configure() to device,c to help re-use
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 12:19 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> On 01/09/2015 10:34 AM, Rob Herring wrote:
>>
>> On Thu, Jan 8, 2015 at 4:24 PM, Arnd Bergmann<arnd@arndb.de>  wrote:
>>>
>>> On Thursday 08 January 2015 14:26:36 Murali Karicheri wrote:
>>>>
>>>> On 01/08/2015 03:40 AM, Arnd Bergmann wrote:
>>>>>
>>>>> On Wednesday 07 January 2015 17:37:56 Rob Herring wrote:
>>>>>>
>>>>>> On Wed, Jan 7, 2015 at 12:49 PM, Murali Karicheri<m-karicheri2@ti.com>
>>>>>> wrote:
>>>>>>
>>>>>>> +       ret = of_dma_get_range(np,&dma_addr,&paddr,&size);
>>>>>>> +       if (ret<   0) {
>>>>>>> +               dma_addr = offset = 0;
>>>>>>> +               size = dev->coherent_dma_mask + 1;
>>>>>>
>>>>>>
>>>>>> If coherent_dma_mask is DMA_BIT_MASK(64), then you will overflow and
>>>>>> have a size of 0. There may also be a problem when the mask is only
>>>>>> 32-bit type.
>>>>>
>>>>>
>>>>> The mask is always a 64-bit type, it's not optional. But you are right,
>>>>> the 64-bit mask case is broken, so I guess we have to fix it
>>>>> differently
>>>>> by always passing the smaller value into arch_setup_dma_ops and
>>>>> adapting that function instead.
>>>>
>>>> Arnd,
>>>>
>>>> What is the smaller value you are referring to in the below code?
>>>> between *dev->dma_mask and size from DT? But overflow can still happen
>>>> when size is to be calculated in arch_setup_dma_ops() for Non DT case or
>>>> when DT size is configured to be equivalent of DMA_BIT_MASK(64) + 1. Can
>>>> we discuss the code change you have in mind when you get a chance?
>>>
>>>
>>> I meant changing every function that the size values gets passed into
>>> to take a mask like 0xffffffff instead of a size like 0x100000000, so
>>> we can represent a 64-bit capable bus correctly.
>>
>>
>> Or you could special case a size of 0 to mean all/max? I'm not sure if
>> we need to handle size=0 for other reasons beyond just wrong DT data.
>>
>>> This means we also need to adapt the value returned from
>>> of_dma_get_range.
>>> A minor complication here is that the DT properties sometimes already
>>> contain the mask value, in particular when we want to represent a
>>> full mapping like
>>>
>>>          bus {
>>>                  #address-cells =<1>;
>>>                  #size-cells =<1>;
>>>                  dma-ranges =<0 0 0xffffffff>; /* all 4 GB,
>>> DMA_BIT_MASK(32) */
>>
>>
>> This is wrong though, right? The DT should be size. Certainly, this
>> could be a valid size, but that would not make the mask 0xfffffffe. We
>> would still want it to be 0xffffffff.
>>
>> We could do a fixup for these cases adding 1 if bit 0 is set (or not
>> subtracting 1 if we want the mask).
>>
>> Rob
>
> Arnd, Rob, et all,
>
> Do we have preference one way or other for the size format? If we need to
> follow the mask format, all of the calling functions below and the
> arm_iommu_create_mapping() has to change as well to use this changed format.
>
> drivers/gpu/drm/rockchip/rockchip_drm_drv.c:    mapping =
> arm_iommu_create_mapping(&platform_bus_type, 0x00000000,
> drivers/gpu/drm/exynos/exynos_drm_iommu.c:      mapping =
> arm_iommu_create_mapping(&platform_bus_type, priv->da_start,
> drivers/media/platform/omap3isp/isp.c:  mapping =
> arm_iommu_create_mapping(&platform_bus_type, SZ_1G, SZ_2G);
> drivers/iommu/shmobile-iommu.c:         mapping =
> arm_iommu_create_mapping(&platform_bus_type, 0,
> drivers/iommu/ipmmu-vmsa.c:             mapping =
> arm_iommu_create_mapping(&platform_bus_type,
>
> So IMO, keeping current convention of size and taking care of exception in
> DT handling is the right thing to do instead of changing all of the above
> functions. i.e in of_dma_configure(), if DT provide a mask for size (lsb
> set), we  will check that and add 1 to it. Only case in DTS that I can see
> this usage is
>
> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi:           dma-ranges = <0x80
> 0x0 0x80 0x0 0x7f 0xffffffff>;
> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi:                   dma-ranges =
> <0x43000000 0x80 0x0 0x80 0x0 0x7f 0xffffffff>;

This should be fixed regardless. I doubt anyone is worried about 512GB
quite yet.

> This logic should take care of setting the size to ox80_00000000 for these
> cases. if dma_coherent_mask is set to max of u64, then this will result in a
> zero size (both DT case and non DT case). So treat a size of zero as error
> being overflow.

I think this would work, but I really need to see patches.

> Also arm_iommu_create_mapping() currently accept a size of type size_t which
> means, this function expect the size to be max of 0xffffffff. So in
> arm_setup_iommu_dma_ops(), we need to check if size if >0xffffffff and
> return an error. If in future this function support u64 for size, this check
> can be removed.

The aim is to get rid of this function I believe.

Rob
