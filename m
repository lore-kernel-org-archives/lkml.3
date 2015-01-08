Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbbAHXpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 18:45:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36850 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAHXpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 18:45:22 -0500
Message-ID: <54AF165F.7070909@ti.com>
Date: Thu, 8 Jan 2015 18:44:31 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>, Joerg Roedel <joro@8bytes.org>,
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
Subject: Re: [PATCH v3 2/4] of: move of_dma_configure() to device,c to help
 re-use
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <3861625.CJ6m15sZMh@wuerfel> <54AED9EC.1020703@ti.com> <2083932.v1GzgAfexK@wuerfel>
In-Reply-To: <2083932.v1GzgAfexK@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 05:24 PM, Arnd Bergmann wrote:
> On Thursday 08 January 2015 14:26:36 Murali Karicheri wrote:
>> On 01/08/2015 03:40 AM, Arnd Bergmann wrote:
>>> On Wednesday 07 January 2015 17:37:56 Rob Herring wrote:
>>>> On Wed, Jan 7, 2015 at 12:49 PM, Murali Karicheri<m-karicheri2@ti.com>   wrote:
>>>>
>>>>> +       ret = of_dma_get_range(np,&dma_addr,&paddr,&size);
>>>>> +       if (ret<   0) {
>>>>> +               dma_addr = offset = 0;
>>>>> +               size = dev->coherent_dma_mask + 1;
>>>>
>>>> If coherent_dma_mask is DMA_BIT_MASK(64), then you will overflow and
>>>> have a size of 0. There may also be a problem when the mask is only
>>>> 32-bit type.
>>>
>>> The mask is always a 64-bit type, it's not optional. But you are right,
>>> the 64-bit mask case is broken, so I guess we have to fix it differently
>>> by always passing the smaller value into arch_setup_dma_ops and
>>> adapting that function instead.
>> Arnd,
>>
>> What is the smaller value you are referring to in the below code?
>> between *dev->dma_mask and size from DT? But overflow can still happen
>> when size is to be calculated in arch_setup_dma_ops() for Non DT case or
>> when DT size is configured to be equivalent of DMA_BIT_MASK(64) + 1. Can
>> we discuss the code change you have in mind when you get a chance?
>
> I meant changing every function that the size values gets passed into
> to take a mask like 0xffffffff instead of a size like 0x100000000, so
> we can represent a 64-bit capable bus correctly.

The function here refers to  arch_setup_dma_ops() and anything that is 
called by this API, right?
>
> This means we also need to adapt the value returned from of_dma_get_range.
> A minor complication here is that the DT properties sometimes already
> contain the mask value, in particular when we want to represent a
> full mapping like
>
The grep of dma-ranges for arch/arm shows the size used is mask + 1 as

./boot/dts/keystone.dtsi:		dma-ranges = <0x80000000 0x8 0x00000000 
0x80000000>;
./boot/dts/keystone.dtsi:			dma-ranges;
./boot/dts/keystone.dtsi:			dma-ranges;
./boot/dts/r8a7790.dtsi:		dma-ranges = <0x42000000 0 0x40000000 0 
0x40000000 0 0x80000000
./boot/dts/integratorap.dts:	dma-ranges = <0x80000000 0x0 0x80000000>;
./boot/dts/r8a7791.dtsi:		dma-ranges = <0x42000000 0 0x40000000 0 
0x40000000 0 0x80000000
./boot/dts/.k2hk-evm.dtb.dts.tmp:  dma-ranges = <0x80000000 0x8 
0x00000000 0x80000000>;
./boot/dts/.k2hk-evm.dtb.dts.tmp:   dma-ranges;
./boot/dts/.k2l-evm.dtb.dts.tmp:  dma-ranges = <0x80000000 0x8 
0x00000000 0x80000000>;
./boot/dts/.k2l-evm.dtb.dts.tmp:   dma-ranges;
./boot/dts/.k2e-evm.dtb.dts.tmp:  dma-ranges = <0x80000000 0x8 
0x00000000 0x80000000>;
./boot/dts/.k2e-evm.dtb.dts.tmp:   dma-ranges;
./boot/dts/.k2e-evm.dtb.dts.tmp:   dma-ranges;
./boot/dts/k2e.dtsi:			dma-ranges;
./boot/dts/k2e.dtsi:			dma-ranges;

So for ARM 32 the below case doesn't seem to apply.

> 	bus {
> 		#address-cells =<1>;
> 		#size-cells =<1>;
> 		dma-ranges =<0 0 0xffffffff>; /* all 4 GB, DMA_BIT_MASK(32) */
> 	};
>
> as opposed to
>

A search under arch/arm64 and arch/powerpc showed another format for 
dma-ranges for PCI. Now I am bit nervous on how of_pci_dma_configure() 
behave for these platforms as PCI nodes on these platforms may have 
dma-ranges in a different format than that in platform bus nodes. These 
DT property has additional cell for resource identification (example 
0x42000000 as the first cell). Also one of them, amd-seattle-soc.dtsi 
uses the format of size (0x7fffffffff) similar to what you refered above.

./boot/dts/apm/apm-storm.dtsi:			dma-ranges = <0x42000000 0x80 
0x00000000 0x80 0x00000000 0x00 0x80000000
./boot/dts/apm/apm-storm.dtsi:			dma-ranges = <0x42000000 0x80 
0x00000000 0x80 0x00000000 0x00 0x80000000
./boot/dts/apm/apm-storm.dtsi:			dma-ranges = <0x42000000 0x80 
0x00000000 0x80 0x00000000 0x00 0x80000000
./boot/dts/apm/apm-storm.dtsi:			dma-ranges = <0x42000000 0x80 
0x00000000 0x80 0x00000000 0x00 0x80000000
./boot/dts/apm/apm-storm.dtsi:			dma-ranges = <0x42000000 0x80 
0x00000000 0x80 0x00000000 0x00 0x80000000
./boot/dts/amd/amd-seattle-soc.dtsi:		dma-ranges = <0x80 0x0 0x80 0x0 
0x7f 0xffffffff>;
./boot/dts/amd/amd-seattle-soc.dtsi:			dma-ranges = <0x43000000 0x80 0x0 
0x80 0x0 0x7f 0xffffffff>;

Or I got this wrong. Any comment?

For ARM 32, DT size value can be extracted and size-1 can be passed to 
arch_setup_dma_ops() provided it handles this value properly.

> 	bus {
> 		#address-cells =<1>;
> 		#size-cells =<1>;
> 		dma-ranges =<0 0 0x80000000>; /* only lower 2GB, DMA_BIT_MASK(31) */
> 	};
>
> or
>
> 	bus {
> 		#address-cells =<2>;
> 		#size-cells =<2>;
> 		dma-ranges =<0 0 0x0000000100000000>; /* 4GB of 64-bit address space */
> 	};
>
>
> 	Arnd


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
