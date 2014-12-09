Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbaLIODf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:03:35 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46976 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbaLIODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:03:34 -0500
Message-ID: <5487012B.4040505@arm.com>
Date: Tue, 09 Dec 2014 14:03:23 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 2/6] PCI/MSI: add hooks to populate the msi_domain field
References: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com> <1418069543-21969-3-git-send-email-marc.zyngier@arm.com> <5486585B.40000@huawei.com> <5486C8BA.8030608@arm.com> <5486E3BF.70703@huawei.com> <5486E747.4010804@arm.com> <5486EF4E.5020704@linux.intel.com>
In-Reply-To: <5486EF4E.5020704@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerry,

On 09/12/14 12:47, Jiang Liu wrote:
> On 2014/12/9 20:12, Marc Zyngier wrote:
>> Yijing,
>>
>> On 09/12/14 11:57, Yijing Wang wrote:
>>>>>> +void __weak pcibios_set_phb_msi_domain(struct pci_bus *bus)
>>>>>> +{
>>>>>> +}
>>>>>> +
>>>>>> +static void pci_set_bus_msi_domain(struct pci_bus *bus)
>>>>>> +{
>>>>>> +	struct pci_dev *bridge = bus->self;
>>>>>> +
>>>>>> +	if (!bridge)
>>>>>> +		pcibios_set_phb_msi_domain(bus);
>>>>>> +	else
>>>>>> +		dev_set_msi_domain(&bus->dev, dev_get_msi_domain(&bridge->dev));
>>>>>> +}
>>>>>
>>>>>
>>>>> Hi Marc, we can not assume pci devices under same phb share the same msi irq domain,
>>>>> now in x86, pci devices under the same phb may associate different msi irq domain.
>>>
>>> Hi Marc,
>>>
>>>>
>>>> Well, this is not supposed to be a perfect solution yet, but instead a
>>>> basis for discussion. What I'd like to find out is:
>>>>
>>>> - What is the minimum granularity for associating a device with its MSI
>>>> domain in existing platforms?
>>>
>>> PCI device, after Gerry's msi irq domain patchset which now in linux-next,
>>> in x86, we will find msi irq domain by pci_dev.
>>
>> Are you *really* associating the MSI domain on a per pci-device basis?
>> That is, you have devices on the same PCI bus talking to different MSI hw?
> Hi Marc,
> 	This is a little wild:(
> 	On x86 platform with Intel VT-d(not the case for AMD-v),
> interrupt remapping is tight to DMA remapping (IOMMU) unit.
> For most common cases, IOMMU unit manages PCI bus and its sub-hierarchy.
> But it may also manage a specific PCI device. This is typically used to
> provide QoS for audio device by using dedicated IOMMU unit to avoid
> resource contention on DMA remapping tables. BIOS uses ACPI table to
> report PCI bus/device to IOMMU unit mapping relationship. (To be honest,
> I have no really experience with such a hardware platform yet, just for
> theoretical analysis)
> 	On the other hand, we now support hierarchy irqdomain. So to
> support per-PCI IOMMU unit case, we need maintain irqdomain at PCI
> device level.
> 	This piece of code from your [4/6] is flexible enough, which
> retrieves msi_domain from PCI device, then fallback to PCI bus,
> then fallback to platform specific method.
> 	domain = dev_get_msi_domain(&dev->dev);
> 	if (!domain && dev->bus->msi)
>  		domain = dev->bus->msi->domain;
>  	if (!domain)
>  		domain = arch_get_pci_msi_domain(dev);

OK. But what I'd really like to see is a way to setup the
device<->domain binding as early as possible, without having to use more
conditional code in pci_msi_get_domain.

IOW, can we do something similar to what pci_set_bus_msi_domain and
pci_set_msi_domain do in this patch?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
