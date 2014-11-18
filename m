Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaKRIc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:32:56 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:14235 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaKRIcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:32:54 -0500
Message-ID: <546B041A.4060403@huawei.com>
Date: Tue, 18 Nov 2014 16:32:26 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linuxppc-dev@lists.ozlabs.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <liviu@dudau.co.uk>,
        Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-pci@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        <Suravee.Suthikulpanit@amd.com>, <linux-ia64@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 07/16] PCI: Separate pci_host_bridge creation out
 of pci_create_root_bus()
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <1416219710-26088-8-git-send-email-wangyijing@huawei.com> <2507218.mHliopJb05@wuerfel>
In-Reply-To: <2507218.mHliopJb05@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +LIST_HEAD(pci_host_bridge_list);
>> +DECLARE_RWSEM(pci_host_bridge_sem);
> 
> Unless the pci_host_bridge_sem is accessed thousands of times per second,
> it's normally better to use a simple mutex instead.

OK, I will use simple mutex instead.

> 
>> +static struct resource busn_resource = {
>> +	.name	= "PCI busn",
>> +	.start	= 0,
>> +	.end	= 255,
>> +	.flags	= IORESOURCE_BUS,
>> +};
> 
> I think it would be better to require callers to pass the bus resource
> down to the function.

Hmm, I think most of caller will provide the bus resource, but some others
will not give any bus resource, extremely, no any resources :(. But we still
need properly configure their resources for compatibility.

> 
>> +struct pci_host_bridge *pci_create_host_bridge(
>> +		struct device *parent, u32 db, 
>> +		struct pci_ops *ops, void *sysdata, 
>> +		struct list_head *resources)
>> +{
> 
> Do we still need to pass the 'sysdata' in here? If we are guaranteed to
> have a device pointer, we should always be able to get the driver
> private data from dev_get_drvdata(host->dev->parent).

We need, some platforms pass NULL pointer as host bridge parent.

> 
>> +	host = kzalloc(sizeof(*host), GFP_KERNEL);
>> +	if (!host)
>> +		return NULL;
> 
> devm_kzalloc maybe?

I don't know much detail about devm_kzalloc(), but we have no pci host driver
here, and I found no devm_kzalloc() uses in core PCI code before.

> 
>> +	if (!resources) {
>> +		/* Use default IO/MEM/BUS resources*/
>> +		pci_add_resource(&host->windows, &ioport_resource);
>> +		pci_add_resource(&host->windows, &iomem_resource);
>> +		pci_add_resource(&host->windows, &busn_resource);
>> +	} else {
>> +		list_for_each_entry_safe(window, n, resources, list)
>> +			list_move_tail(&window->list, &host->windows);
>> +	}
> 
> I think we should assume that the correct resources are passed. You
> could add a wrapper around this function to convert old platforms
> though.

OK, I will move these code out of pci_create_host_bridge, and add a wrapper
to setup the default resources.

> 
>> +EXPORT_SYMBOL(pci_create_host_bridge);
> 
> EXPORT_SYMBOL_GPL() maybe?

OK, will update it.

> 
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 8b11b38..daa7f40 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -402,7 +402,12 @@ struct pci_host_bridge_window {
>>  struct pci_host_bridge {
>>  	struct device dev;
>>  	struct pci_bus *bus;		/* root bus */
>> +	struct list_head list;
>>  	struct list_head windows;	/* pci_host_bridge_windows */
>> +	int busnum;
> 
> The busnum should already be implied through the bus resource.

Yes, I will consider remove it and introduce a helper function to get the root bus number, thanks!

Thanks!
Yijing.

> 
> 	Arnd
> 
> .
> 


-- 
Thanks!
Yijing

