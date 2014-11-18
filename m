Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaKRLpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:45:03 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:19742 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaKRLpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:45:00 -0500
Message-ID: <546B3124.7070206@huawei.com>
Date: Tue, 18 Nov 2014 19:44:36 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linuxppc-dev@lists.ozlabs.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        "Russell King" <linux@arm.linux.org.uk>, <linux-pci@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        <Suravee.Suthikulpanit@amd.com>, <linux-ia64@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 07/16] PCI: Separate pci_host_bridge creation out
 of pci_create_root_bus()
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <2507218.mHliopJb05@wuerfel> <546B041A.4060403@huawei.com> <1936415.emTbbPeHqx@wuerfel>
In-Reply-To: <1936415.emTbbPeHqx@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.546B3132.0054,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 6c30e06b394fa6177a7b802026ca246b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 17:30, Arnd Bergmann wrote:
> On Tuesday 18 November 2014 16:32:26 Yijing Wang wrote:
> 
>>>> +static struct resource busn_resource = {
>>>> +	.name	= "PCI busn",
>>>> +	.start	= 0,
>>>> +	.end	= 255,
>>>> +	.flags	= IORESOURCE_BUS,
>>>> +};
>>>
>>> I think it would be better to require callers to pass the bus resource
>>> down to the function.
>>
>> Hmm, I think most of caller will provide the bus resource, but some others
>> will not give any bus resource, extremely, no any resources :(. But we still
>> need properly configure their resources for compatibility.
> 
> I think that is what the conversion to pci_scan_bus_parented() is about:
> The idea is that we add the correct bus resource to callers of
> pci_scan_bus_parented or pci_scan_bus and then change them to call
> pci_scan_root_bus instead.

It looks good to me, but for simplification, or I will try to use a wrapper to
process the drivers don't pass the busnr resources, and make sure the generic
pci_create_host_bridge() always get the valid resources.

> 
>>>> +struct pci_host_bridge *pci_create_host_bridge(
>>>> +		struct device *parent, u32 db, 
>>>> +		struct pci_ops *ops, void *sysdata, 
>>>> +		struct list_head *resources)
>>>> +{
>>>
>>> Do we still need to pass the 'sysdata' in here? If we are guaranteed to
>>> have a device pointer, we should always be able to get the driver
>>> private data from dev_get_drvdata(host->dev->parent).
>>
>> We need, some platforms pass NULL pointer as host bridge parent.
> 
> But those don't have to use the new pci_create_host_bridge() function,
> right?

As I mentioned in another reply, I hope all pci host drivers could use
pci_create_host_bridge(), keep different PCI scan interfaces in PCI core
make things become complex.


> 
>>>> +	host = kzalloc(sizeof(*host), GFP_KERNEL);
>>>> +	if (!host)
>>>> +		return NULL;
>>>
>>> devm_kzalloc maybe?
>>
>> I don't know much detail about devm_kzalloc(), but we have no pci host driver
>> here, and I found no devm_kzalloc() uses in core PCI code before.
> 
> It also depends on having a valid device pointer. The idea is that the memory
> is automatically freed if the probe() function returns with an error, or
> the device driver gets unloaded. For the classic PCI hosts that are not
> connected to a device, that wouldn't work of course.
> 
> 	Arnd
> 
> .
> 


-- 
Thanks!
Yijing

