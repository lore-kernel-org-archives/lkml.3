Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab3FRQfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:35:07 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:37806 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542Ab3FRQfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:35:01 -0400
Message-ID: <51C08C2D.6080208@gmail.com>
Date: Wed, 19 Jun 2013 00:34:53 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@kernel.org>, Hannes Reinecke <hare@suse.de>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v3, part2 17/20] PCI, iommu: use hotplug-safe iterators
 to walk PCI buses
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com> <1369583597-3801-18-git-send-email-jiang.liu@huawei.com> <20130617202010.GC7877@google.com> <51BF72DA.3050106@redhat.com>
In-Reply-To: <51BF72DA.3050106@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 04:34 AM, Don Dutile wrote:
> On 06/17/2013 04:20 PM, Bjorn Helgaas wrote:
>> On Sun, May 26, 2013 at 11:53:14PM +0800, Jiang Liu wrote:
>>> Enhance iommu drviers to use hotplug-safe iterators to walk
>>> PCI buses.
>>>
>>> Signed-off-by: Jiang Liu<jiang.liu@huawei.com>
>>> Cc: Joerg Roedel<joro@8bytes.org>
>>> Cc: Ingo Molnar<mingo@kernel.org>
>>> Cc: Donald Dutile<ddutile@redhat.com>
>>> Cc: Hannes Reinecke<hare@suse.de>
>>> Cc: "Li, Zhen-Hua"<zhen-hual@hp.com>
>>> Cc: iommu@lists.linux-foundation.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>   drivers/iommu/amd_iommu.c | 4 +++-
>>>   drivers/iommu/dmar.c      | 6 ++++--
>>
>> The AMD and Intel IOMMU drivers are very different, and I would
>> split this into a patch for each.
>>
> +1
Hi Don and Bjorn,

Thanks for review, will split it into two patches.
Regards!
Gerry
> 
>>>   2 files changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
>>> index 21d02b0..eef7a7e 100644
>>> --- a/drivers/iommu/amd_iommu.c
>>> +++ b/drivers/iommu/amd_iommu.c
>>> @@ -352,6 +352,7 @@ static int init_iommu_group(struct device *dev)
>>>       struct iommu_dev_data *dev_data;
>>>       struct iommu_group *group;
>>>       struct pci_dev *dma_pdev;
>>> +    struct pci_bus *b = NULL;
>>>       int ret;
>>>
>>>       group = iommu_group_get(dev);
>>> @@ -388,7 +389,7 @@ static int init_iommu_group(struct device *dev)
>>>            * the alias.  Be careful to also test the parent device if
>>>            * we think the alias is the root of the group.
>>>            */
>>> -        bus = pci_find_bus(0, alias>>  8);
>>> +        b = bus = pci_get_bus(0, alias>>  8);
>>>           if (!bus)
>>>               goto use_group;
>>>
>>> @@ -408,6 +409,7 @@ static int init_iommu_group(struct device *dev)
>>>       dma_pdev = get_isolation_root(pci_dev_get(to_pci_dev(dev)));
>>>   use_pdev:
>>>       ret = use_pdev_iommu_group(dma_pdev, dev);
>>> +    pci_bus_put(b);
>>>       pci_dev_put(dma_pdev);
>>>       return ret;
>>>   use_group:
>>> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
>>> index a7967ce..7162787 100644
>>> --- a/drivers/iommu/dmar.c
>>> +++ b/drivers/iommu/dmar.c
>>> @@ -67,12 +67,12 @@ static void __init dmar_register_drhd_unit(struct
>>> dmar_drhd_unit *drhd)
>>>   static int __init dmar_parse_one_dev_scope(struct
>>> acpi_dmar_device_scope *scope,
>>>                          struct pci_dev **dev, u16 segment)
>>>   {
>>> -    struct pci_bus *bus;
>>> +    struct pci_bus *b, *bus;
>>>       struct pci_dev *pdev = NULL;
>>>       struct acpi_dmar_pci_path *path;
>>>       int count;
>>>
>>> -    bus = pci_find_bus(segment, scope->bus);
>>> +    b = bus = pci_get_bus(segment, scope->bus);
>>>       path = (struct acpi_dmar_pci_path *)(scope + 1);
>>>       count = (scope->length - sizeof(struct acpi_dmar_device_scope))
>>>           / sizeof(struct acpi_dmar_pci_path);
>>> @@ -97,6 +97,8 @@ static int __init dmar_parse_one_dev_scope(struct
>>> acpi_dmar_device_scope *scope,
>>>           count --;
>>>           bus = pdev->subordinate;
>>>       }
>>> +    pci_bus_put(b);
>>> +
>>>       if (!pdev) {
>>>           pr_warn("Device scope device [%04x:%02x:%02x.%02x] not
>>> found\n",
>>>               segment, scope->bus, path->dev, path->fn);
>>> -- 
>>> 1.8.1.2
>>>
> 

