Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaLIMs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:48:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:9313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbaLIMs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:48:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,544,1413270000"; 
   d="scan'208";a="650901231"
Message-ID: <5486EF4E.5020704@linux.intel.com>
Date: Tue, 09 Dec 2014 20:47:10 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Yijing Wang <wangyijing@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 2/6] PCI/MSI: add hooks to populate the msi_domain field
References: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com> <1418069543-21969-3-git-send-email-marc.zyngier@arm.com> <5486585B.40000@huawei.com> <5486C8BA.8030608@arm.com> <5486E3BF.70703@huawei.com> <5486E747.4010804@arm.com>
In-Reply-To: <5486E747.4010804@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/9 20:12, Marc Zyngier wrote:
> Yijing,
> 
> On 09/12/14 11:57, Yijing Wang wrote:
>>>>> +void __weak pcibios_set_phb_msi_domain(struct pci_bus *bus)
>>>>> +{
>>>>> +}
>>>>> +
>>>>> +static void pci_set_bus_msi_domain(struct pci_bus *bus)
>>>>> +{
>>>>> +	struct pci_dev *bridge = bus->self;
>>>>> +
>>>>> +	if (!bridge)
>>>>> +		pcibios_set_phb_msi_domain(bus);
>>>>> +	else
>>>>> +		dev_set_msi_domain(&bus->dev, dev_get_msi_domain(&bridge->dev));
>>>>> +}
>>>>
>>>>
>>>> Hi Marc, we can not assume pci devices under same phb share the same msi irq domain,
>>>> now in x86, pci devices under the same phb may associate different msi irq domain.
>>
>> Hi Marc,
>>
>>>
>>> Well, this is not supposed to be a perfect solution yet, but instead a
>>> basis for discussion. What I'd like to find out is:
>>>
>>> - What is the minimum granularity for associating a device with its MSI
>>> domain in existing platforms?
>>
>> PCI device, after Gerry's msi irq domain patchset which now in linux-next,
>> in x86, we will find msi irq domain by pci_dev.
> 
> Are you *really* associating the MSI domain on a per pci-device basis?
> That is, you have devices on the same PCI bus talking to different MSI hw?
Hi Marc,
	This is a little wild:(
	On x86 platform with Intel VT-d(not the case for AMD-v),
interrupt remapping is tight to DMA remapping (IOMMU) unit.
For most common cases, IOMMU unit manages PCI bus and its sub-hierarchy.
But it may also manage a specific PCI device. This is typically used to
provide QoS for audio device by using dedicated IOMMU unit to avoid
resource contention on DMA remapping tables. BIOS uses ACPI table to
report PCI bus/device to IOMMU unit mapping relationship. (To be honest,
I have no really experience with such a hardware platform yet, just for
theoretical analysis)
	On the other hand, we now support hierarchy irqdomain. So to
support per-PCI IOMMU unit case, we need maintain irqdomain at PCI
device level.
	This piece of code from your [4/6] is flexible enough, which
retrieves msi_domain from PCI device, then fallback to PCI bus,
then fallback to platform specific method.
	domain = dev_get_msi_domain(&dev->dev);
	if (!domain && dev->bus->msi)
 		domain = dev->bus->msi->domain;
 	if (!domain)
 		domain = arch_get_pci_msi_domain(dev);
Thanks!
Gerry
> 
>> I generally agree your first patch which associate basic device with msi irq domain.
>>
>>> - What topology data structures do you use to find out what MSI
>>> controller a device should be matched with?
>>
>> Now only arm and arm64 use msi controller to setup/teardown msi irqs,
>> in arm, now msi controller saved in pci_sys_data, and for arm64, it seems
>> to be saved in pci_bus. For a more common method to find msi controller/irq domain,
>> I prefer pci_dev/device.
> 
> Forget about msi_controller, the whole goal of this series is to make it
> obsolete. On your x86 platform, what how do you identify which MSI
> domain should be associated with a given PCI device? Surely you must
> have a set of data structures or ACPI tables which give you that
> information.
> 
>>> - What in-tree platform already has this requirements?
>>
>> As mentioned above, x86 does.
> 
> Let me rephrase that in a non-ambiguous manner: can you point me to a
> file implementing this in mainline?
> 
> Thanks,
> 
> 	M.
> 
