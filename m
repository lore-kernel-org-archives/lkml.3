Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbaKTCye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 21:54:34 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:56082 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbaKTCyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 21:54:32 -0500
Message-ID: <546D57D8.4060708@huawei.com>
Date: Thu, 20 Nov 2014 10:54:16 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "huxinwei@huawei.com" <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Liviu Dudau <liviu@dudau.co.uk>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Yijing Wang <wangyijing0307@gmail.com>
Subject: Re: [RFC PATCH 08/16] PCI: Introduce pci_scan_host_bridge() and pci_host_info
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <1416219710-26088-9-git-send-email-wangyijing@huawei.com> <20141118154243.GM12037@e106497-lin.cambridge.arm.com> <546BFBC8.4030104@huawei.com> <20141119164128.GX12037@e106497-lin.cambridge.arm.com>
In-Reply-To: <20141119164128.GX12037@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.546D57E6.009B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 88645b21f2c877bba071886c8363a408
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> No, in this patch, host drivers pass a pci host bridge resources init hook
>> in pci_host_info *info, and we call this info->init_res() in pci_create_host_bridge().
>>
>> +struct pci_host_info {
>> +	u8 res_type;
>> +	void *arg;
>> +	struct list_head *resources; /*just for build, will clean up later */
>> +	int (*init_res)(struct pci_host_bridge *host,
>> +			struct pci_host_info *info);
>> +};
>> +
> 
> That's not what I've asked! Your code does:
> 
> 	if (info->res_type != PCI_HOST_RES_DEFAULT)
> 		....
> 	else /* info->res_type == PCI_HOST_RES_DEFAULT)
> 		info->res_type = PCI_HOST_RES_DEFAULT;
> 
> info->res_type is already == PCI_HOST_RES_DEFAULT in the else side, assignment is a NOP?

Hmmm, I wanted pci_create_host_bridge() to process the default res later(add default res),
It's ugly code, I will rework it.

> 
> 
>>
>>>
>>>> +
>>>> +	return 0;
>>>> +}
>> ...
>>>> @@ -2038,8 +2057,13 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, u32 db,
>>>>  	bool found = false;
>>>>  	struct pci_host_bridge *host;
>>>>  	int max;
>>>> +	struct pci_host_info info;
>>>> +	
>>>> +	info.arg = sysdata;
>>>> +	info.resources = resources;
>>>> +	info.init_res = pci_default_init_res;
>>>
>>> I have mixed feelings about this patch. While it is heading in the right direction
>>> of moving pci_host_bridge relevant information towards the right user, I don't think
>>> you picked up the right set to move. The resource list is going to be copied into
>>> internal pci_host_bridge list anyway, keeping another copy is not helpful *and*
>>> you have increased the code size.
>>>
>>> I think for now we should aim to get the *missing* data into pci_host_bridge: MSI
>>> controllers and PCI domain/segment. Then we can do more cleanup.
>>
>> Hi Liviu, I agree with you here, the changes to resources stuff seems not a perfect
>> solution. In my patch 6, we could pass pci domain nr by u32 PCI_DOMBUS(domain, bus) argument,
>> and store it in pci_host_bridge. For msi controller, we couldn't save the msi_controller
>> in pci_host_bridge. Before we assume one pci host bridge only had one msi_controller,
>> but now something changes, Jiang introduce hierarchy irq domain in x86, and now
>> one pci host bridge may has more than one msi_controller. So I prefer to add a
>> function to pci_host_bridge something like
>>
>> struct msi_controller *pci_get_msi_controller(struct pci_dev *dev)
> 
> Yes, good idea.
> 
>>
>>>
>>>>  
>>>> -	host = pci_create_host_bridge(parent, db, ops, sysdata, resources);
>>>> +	host = pci_create_host_bridge(parent, db, ops, &info);
>>>>  	if (!host)
>>>>  		return NULL;
>>>>  
>>>> @@ -2070,6 +2094,47 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, u32 db,
>>>>  }
>>>>  EXPORT_SYMBOL(pci_scan_root_bus);
>>>>  
>>>> +struct pci_host_bridge *pci_scan_host_bridge(
>>>> +		struct device *parent, u32 db, struct pci_ops *ops,
>>>> +		struct pci_host_info *info)
>>>> +{
>>>> +	struct pci_host_bridge_window *window;
>>>> +	bool found = false;
>>>> +	struct pci_host_bridge *host;
>>>> +	int max;
>>>> +
>>>> +	host = pci_create_host_bridge(parent, db, ops, info);
>>>> +	if (!host)
>>>> +		return NULL;
>>>> +
>>>> +	list_for_each_entry(window, &host->windows, list)
>>>> +		if (window->res->flags & IORESOURCE_BUS) {
>>>> +			found = true;
>>>> +			break;
>>>> +		}
>>>> +
>>>> +	host->bus = __pci_create_root_bus(host);
>>>> +	if (!host->bus) {
>>>> +		pci_free_host_bridge(host);
>>>> +		return NULL;
>>>> +	}
>>>> +
>>>> +	if (!found) {
>>>> +		dev_info(&host->bus->dev,
>>>> +		 "No busn resource found for root bus, will use [bus %02x-ff]\n",
>>>> +			host->busnum);
>>>> +		pci_bus_insert_busn_res(host->bus, host->busnum, 255);
>>>> +	}
>>>> +
>>>> +	max = pci_scan_child_bus(host->bus);
>>>> +	if (!found)
>>>> +		pci_bus_update_busn_res_end(host->bus, max);
>>>> +
>>>> +	return host;
>>>> +
>>>> +}
>>>> +EXPORT_SYMBOL(pci_scan_host_bridge);
>>>> +
>>>>  /**
>>>>   * pci_rescan_bus_bridge_resize - scan a PCI bus for devices.
>>>>   * @bridge: PCI bridge for the bus to scan
>>>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>>>> index daa7f40..a51f5f5 100644
>>>> --- a/include/linux/pci.h
>>>> +++ b/include/linux/pci.h
>>>> @@ -412,6 +412,21 @@ struct pci_host_bridge {
>>>>  	void *release_data;
>>>>  };
>>>>  
>>>> +struct pci_host_info {
>>>> +	u8 res_type;
>>>> +	void *arg;
>>>> +	struct list_head *resources; /*just for build, will clean up later */
>>>> +	int (*init_res)(struct pci_host_bridge *host, 
>>>> +			struct pci_host_info *info);
>>>> +};
>>>> +
>>>> +static inline void init_pci_host_info(struct pci_host_info *info)
>>>> +{
>>>> +	memset(info, 0 , sizeof(*info));
>>>> +}
>>>
>>> Where is this used?
>>
>> Host driver uses it to init pci_host_info.
> 
> Might be worth adding it that patch rather than here.

OK

> 
> Best regards,
> Liviu
> 
>>
>>>
>>>> +
>>>> +#define PCI_HOST_RES_DEFAULT	0x2
>>>> +
>>>
>>> Magic number?
>>
>> Hmmm, I will rework pci host bridge resources stuff.
>>
>>>
>>> Best regards,
>>> Liviu
>>>
>>>>  #define	to_pci_host_bridge(n) container_of(n, struct pci_host_bridge, dev)
>>>>  void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
>>>>  		     void (*release_fn)(struct pci_host_bridge *),
>>>> @@ -420,7 +435,7 @@ void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
>>>>  int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge);
>>>>  struct pci_host_bridge *pci_create_host_bridge(
>>>>  		struct device *parent, u32 db, struct pci_ops *ops, 
>>>> -		void *sys, struct list_head *resources);
>>>> +		struct pci_host_info *info);
>>>>  /*
>>>>   * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond
>>>>   * to P2P or CardBus bridge windows) go in a table.  Additional ones (for
>>>> @@ -785,6 +800,9 @@ void pci_bus_release_busn_res(struct pci_bus *b);
>>>>  struct pci_bus *pci_scan_root_bus(struct device *parent, u32 bus,
>>>>  					     struct pci_ops *ops, void *sysdata,
>>>>  					     struct list_head *resources);
>>>> +struct pci_host_bridge *pci_scan_host_bridge(struct device *parent,
>>>> +		u32 db, struct pci_ops *ops,
>>>> +		struct pci_host_info *info);
>>>>  struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
>>>>  				int busnr);
>>>>  void pcie_update_link_speed(struct pci_bus *bus, u16 link_status);
>>>> -- 
>>>> 1.7.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>
>>
>> -- 
>> Thanks!
>> Yijing
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 


-- 
Thanks!
Yijing

