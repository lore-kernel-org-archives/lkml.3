Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaJWGkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 02:40:00 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:33886 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaJWGj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 02:39:58 -0400
Message-ID: <5448A2A7.9090407@huawei.com>
Date: Thu, 23 Oct 2014 14:39:35 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>, <Bharat.Bhushan@freescale.com>,
        <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Tony Luck" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
        Liviu Dudau <liviu@dudau.co.uk>
Subject: Re: [PATCH v3 09/27] arm/PCI: Clean unused pcibios_add_bus() and
 pcibios_remove_bus()
References: <1413342435-7876-1-git-send-email-wangyijing@huawei.com> <1413342435-7876-10-git-send-email-wangyijing@huawei.com> <20141023053858.GD11770@google.com>
In-Reply-To: <20141023053858.GD11770@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  /*
>>   * Swizzle the device pin each time we cross a bridge.  If a platform does
>>   * not provide a swizzle function, we perform the standard PCI swizzling.
>> @@ -478,8 +464,6 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
>>  		sys->swizzle = hw->swizzle;
>>  		sys->map_irq = hw->map_irq;
>>  		sys->align_resource = hw->align_resource;
>> -		sys->add_bus = hw->add_bus;
>> -		sys->remove_bus = hw->remove_bus;
>>  		INIT_LIST_HEAD(&sys->resources);
>>  
>>  		if (hw->private_data)
> 
> What do the core changes below have to do with the ARM changes above?
> They should be a separate patch unless they can't be separated.

Hm, it's not the thing have to do, because the changes below is only used by arm arch, so I put it here
together. It's ok to split the core changes out to another one.

> 
>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index f11108c..56e54ad 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -32,12 +32,10 @@ int pci_msi_ignore_mask;
>>  
>>  int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
>>  {
>> -	struct msi_chip *chip = dev->bus->msi;
>> +	struct msi_chip *chip;
>>  	int err;
>>  
>> -	if (!chip)
>> -		chip = pci_msi_chip(dev->bus);
>> -
>> +	chip = pci_msi_chip(dev->bus);
>>  	if (!chip || !chip->setup_irq)
>>  		return -EINVAL;
>>  
>> @@ -51,10 +49,7 @@ int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
>>  void __weak arch_teardown_msi_irq(unsigned int irq)
>>  {
>>  	struct msi_desc *entry = irq_get_msi_desc(irq);
>> -	struct msi_chip *chip = entry->dev->bus->msi;
>> -
>> -	if (!chip)
>> -		chip = pci_msi_chip(entry->dev->bus);
>> +	struct msi_chip *chip = pci_msi_chip(entry->dev->bus);
>>  
>>  	if (!chip || !chip->teardown_irq)
>>  		return;
>> -- 
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


-- 
Thanks!
Yijing

