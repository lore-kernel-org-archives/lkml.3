Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbaLIMNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:13:07 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46912 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbaLIMND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:13:03 -0500
Message-ID: <5486E747.4010804@arm.com>
Date: Tue, 09 Dec 2014 12:12:55 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 2/6] PCI/MSI: add hooks to populate the msi_domain field
References: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com> <1418069543-21969-3-git-send-email-marc.zyngier@arm.com> <5486585B.40000@huawei.com> <5486C8BA.8030608@arm.com> <5486E3BF.70703@huawei.com>
In-Reply-To: <5486E3BF.70703@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yijing,

On 09/12/14 11:57, Yijing Wang wrote:
>>>> +void __weak pcibios_set_phb_msi_domain(struct pci_bus *bus)
>>>> +{
>>>> +}
>>>> +
>>>> +static void pci_set_bus_msi_domain(struct pci_bus *bus)
>>>> +{
>>>> +	struct pci_dev *bridge = bus->self;
>>>> +
>>>> +	if (!bridge)
>>>> +		pcibios_set_phb_msi_domain(bus);
>>>> +	else
>>>> +		dev_set_msi_domain(&bus->dev, dev_get_msi_domain(&bridge->dev));
>>>> +}
>>>
>>>
>>> Hi Marc, we can not assume pci devices under same phb share the same msi irq domain,
>>> now in x86, pci devices under the same phb may associate different msi irq domain.
> 
> Hi Marc,
> 
>>
>> Well, this is not supposed to be a perfect solution yet, but instead a
>> basis for discussion. What I'd like to find out is:
>>
>> - What is the minimum granularity for associating a device with its MSI
>> domain in existing platforms?
> 
> PCI device, after Gerry's msi irq domain patchset which now in linux-next,
> in x86, we will find msi irq domain by pci_dev.

Are you *really* associating the MSI domain on a per pci-device basis?
That is, you have devices on the same PCI bus talking to different MSI hw?

> I generally agree your first patch which associate basic device with msi irq domain.
> 
>> - What topology data structures do you use to find out what MSI
>> controller a device should be matched with?
> 
> Now only arm and arm64 use msi controller to setup/teardown msi irqs,
> in arm, now msi controller saved in pci_sys_data, and for arm64, it seems
> to be saved in pci_bus. For a more common method to find msi controller/irq domain,
> I prefer pci_dev/device.

Forget about msi_controller, the whole goal of this series is to make it
obsolete. On your x86 platform, what how do you identify which MSI
domain should be associated with a given PCI device? Surely you must
have a set of data structures or ACPI tables which give you that
information.

>> - What in-tree platform already has this requirements?
> 
> As mentioned above, x86 does.

Let me rephrase that in a non-ambiguous manner: can you point me to a
file implementing this in mainline?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
