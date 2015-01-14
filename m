Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbbANCEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:04:30 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:2766 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbANCE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:04:28 -0500
Message-ID: <54B5CE9E.4030801@huawei.com>
Date: Wed, 14 Jan 2015 10:04:14 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v2 2/8] PCI/MSI: Add hooks to populate the msi_domain
 field
References: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com> <1420736772-11088-3-git-send-email-marc.zyngier@arm.com> <54B510BA.7030202@huawei.com> <54B52168.3080600@arm.com>
In-Reply-To: <54B52168.3080600@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +static void pci_set_msi_domain(struct pci_dev *dev)
>>> +{
>>> +	/*
>>> +	 * If no domain has been set through the pcibios callback,
>>> +	 * inherit the default from the bus device.
>>> +	 */
>>> +	if (!dev_get_msi_domain(&dev->dev))
>>> +		dev_set_msi_domain(&dev->dev,
>>> +				   dev_get_msi_domain(&dev->bus->dev));
>>> +}
>>
>> Hi Marc, now we have two ways to associate the pci_dev and msi_domain, right ?
>>
>> 1. associate pci_dev and msi_domain in pcibios_add_device() like x86.
>>
>> 2. Inherit msi_domain from pci_dev->bus.
>>
>> My question is if all pci devices inherit msi_domain from the pci_bus,
>> so all pci devices under same pci host bridge have the same msi_domain assigned by
>> weak pcibios_set_phb_msi_domain(). So why not save the pci host bridge specific
>> msi_domain in pci_host_bridge. Then pci devices could inherit the msi_domain from
>> its pci host bridge directly, no need to involve pci bus in the assignment.
> 
> But then, you would end-up maintaining another msi_domain field inside
> the pci_host bridge structure. What do you gain by doing so?

My original thought is holding msi_domain field inside the pci_host_bridge is
more simple than every bus maintaining the msi_domain, but this proposal has a
disadvantage that sometimes we must setup for every device. I checked x86 DMAR code,
and found most DMAR would report PCIe root port device associating the msi_domain, not the EP device.
So pcibios_add_device could only associate these bridge device msi_domain, and its children
devices will propagate from their parent bus(get msi_domain from its bridge).

So now I agree your idea, please forgive my nagging :)

Thanks!
Yijing.

> 
> With this series, msi_domain has the nice property of always being tied
> to a device (and struct pci_bus always has a device). We always have
> phb->bus->dev.msi_domain within reach, and architecture code can decide
> to override it on a per-device basis.
> 
> What else do you need? What am I missing from your proposal?
> 
> Thanks,
> 
> 	M.
> 


-- 
Thanks!
Yijing

