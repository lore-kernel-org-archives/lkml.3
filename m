Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBLIAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:00:06 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:57665 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaBLIAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:00:04 -0500
Message-ID: <52FB29F2.2060302@huawei.com>
Date: Wed, 12 Feb 2014 15:59:46 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH part1 v6 5/7] PCI: Add pci_dummy_ops to isolate pci device
 temporarily
References: <1392173573-59844-1-git-send-email-wangyijing@huawei.com> <1392173573-59844-6-git-send-email-wangyijing@huawei.com> <52FB26DC.1050804@cn.fujitsu.com>
In-Reply-To: <52FB26DC.1050804@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +void pci_bus_unfreeze_device(struct pci_bus *bus)
>> +{
>> +	unsigned long flags;
>> +
>> +	BUG_ON(!bus->save_ops);
>> +	spin_lock_irqsave(&pci_freeze_lock, flags);
>> +	if (!bus->is_frozen)
>> +		goto out;
> 
> It seems that the BUG_ON() should placed here, otherwise it will be
> triggered if we try to unfreeze the same bus multiply.
> 

Oh, right, I should move it down, thanks for the good catch.


> 
>> +	pci_bus_set_ops(bus, bus->save_ops);
>> +	bus->save_ops = NULL;
>> +	bus->is_frozen = 0;
>> +out:
>> +	spin_unlock_irqrestore(&pci_freeze_lock, flags);
>> +}
>> +
>>  /**
>>   * pci_configure_ari - enable or disable ARI forwarding
>>   * @dev: the PCI device
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index d60c0b6..e3dd4ea 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -442,6 +442,7 @@ struct pci_bus {
>>  	struct resource busn_res;	/* bus numbers routed to this bus */
>>  
>>  	struct pci_ops	*ops;		/* configuration access functions */
>> +	struct pci_ops	*save_ops; /* save configuration access functions */
>>  	struct msi_chip	*msi;		/* MSI controller */
>>  	void		*sysdata;	/* hook for sys-specific extension */
>>  	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/pci */
>> @@ -460,6 +461,7 @@ struct pci_bus {
>>  	struct bin_attribute	*legacy_io; /* legacy I/O for this bus */
>>  	struct bin_attribute	*legacy_mem; /* legacy mem */
>>  	unsigned int		is_added:1;
>> +	unsigned int		is_frozen:1;
>>  };
>>  
>>  #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
>> @@ -1026,6 +1028,8 @@ ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
>>  ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
>>  
>>  bool pci_serial_number_changed(struct pci_dev *pdev);
>> +void pci_bus_freeze_device(struct pci_bus *bus);
>> +void pci_bus_unfreeze_device(struct pci_bus *bus);
>>  
>>  /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
>>  resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
> 
> 
> 
> .
> 


-- 
Thanks!
Yijing

