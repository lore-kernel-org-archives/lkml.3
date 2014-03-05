Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaCECzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:55:09 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:64833 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbaCECzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:55:06 -0500
Message-ID: <531691AF.2010604@huawei.com>
Date: Wed, 5 Mar 2014 10:53:35 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH v2] IOMMU: enhance dmar to support device hotplug
References: <1385022116-228-1-git-send-email-wangyijing@huawei.com> <1385022116-228-2-git-send-email-wangyijing@huawei.com> <20140304143158.GC2799@8bytes.org>
In-Reply-To: <20140304143158.GC2799@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/4 22:31, Joerg Roedel wrote:
> On Thu, Nov 21, 2013 at 04:21:56PM +0800, Yijing Wang wrote:
>> @@ -3641,21 +3681,42 @@ static int device_notifier(struct notifier_block *nb,
>>  	struct device *dev = data;
>>  	struct pci_dev *pdev = to_pci_dev(dev);
>>  	struct dmar_domain *domain;
>> +	struct dmar_device *dmar_dev;
>> +	struct dmar_drhd_unit *drhd;
>>  
>> -	if (iommu_no_mapping(dev))
>> -		return 0;
>> -
>> -	domain = find_domain(pdev);
>> -	if (!domain)
>> -		return 0;
>> +	switch (action) {
>> +	case BUS_NOTIFY_ADD_DEVICE:
>> +		for_each_drhd_unit(drhd)
>> +			list_for_each_entry(dmar_dev, &drhd->devices, list)
>> +				if (dmar_dev->segment == pci_domain_nr(pdev->bus)
>> +					&& dmar_dev->bus == pdev->bus->number
>> +					&& dmar_dev->devfn == pdev->devfn)
>> +					dmar_dev->pdev = pci_dev_get(pdev);
>> +		break;
>> +	case BUS_NOTIFY_DEL_DEVICE:
>> +		for_each_drhd_unit(drhd)
>> +			list_for_each_entry(dmar_dev, &drhd->devices, list)
>> +				if (dmar_dev->pdev == pdev) {
>> +					pci_dev_put(pdev);
>> +					dmar_dev->pdev = NULL;
>> +				}
> 
> How is that synchronized with other users of this dmar_dev structure.
> Could it happen that you drop the device reference while other parts of
> the driver still use it?

Hi Joerg,
   Thanks for your review and comments!
We use original struct dmar_drhd_unit->devices to attach the pci device to specific DMAR,
eg. use dmar_find_matched_drhd_unit() to find the attached DMAR by pci_dev * pointer.
So if the related pci_dev was removed, I think we can safely set dmar_dev->pdev = NULL;
No pci device will use it again until the new pci device hot add.

One problem in this solution is PCI bus number maybe changed after device hotplug,
so use the bus,device,function id to update the dmar device scope maybe unreliable.

Jiang Liu also provide a solution to fix this problem by save device scope pathes,
I think that's a good idea.

link:http://lkml.org/lkml/2014/1/7/108

Thanks!
Yijing.


> 
> 
> 	Joerg
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


-- 
Thanks!
Yijing

