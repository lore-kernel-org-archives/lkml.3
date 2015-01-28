Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbbA1WX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:23:59 -0500
Received: from service88.mimecast.com ([195.130.217.12]:55796 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbbA1ULm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:11:42 -0500
Message-ID: <54C8FC07.2050003@arm.com>
Date: Wed, 28 Jan 2015 15:11:03 +0000
From: Robin Murphy <robin.murphy@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "jroedel@suse.de" <jroedel@suse.de>
Subject: Re: [PATCH 2/5] iommu: Allocate a default domain for iommu groups
References: <1422317339-22620-1-git-send-email-joro@8bytes.org> <1422317339-22620-3-git-send-email-joro@8bytes.org> <20150128143006.GQ1569@arm.com>
In-Reply-To: <20150128143006.GQ1569@arm.com>
X-OriginalArrivalTime: 28 Jan 2015 15:11:04.0015 (UTC) FILETIME=[A22B7DF0:01D03B0C]
X-MC-Unique: 115012815110500201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 14:30, Will Deacon wrote:
> On Tue, Jan 27, 2015 at 12:08:56AM +0000, Joerg Roedel wrote:
>> From: Joerg Roedel <jroedel@suse.de>
>>
>> The default domain will be used (if supported by the iommu
>> driver) when the devices in the iommu group are not attached
>> to any other domain.
>>
>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>> ---
>>   drivers/iommu/iommu.c | 26 +++++++++++++++++++++++---
>>   1 file changed, 23 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 34636eb..8f33ddd3 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -76,6 +76,9 @@ struct iommu_group_attribute iommu_group_attr_##_name =		\
>>   #define to_iommu_group(_kobj)		\
>>   	container_of(_kobj, struct iommu_group, kobj)
>>
>> +static struct iommu_domain *__iommu_domain_alloc(struct bus_type *bus,
>> +						 enum iommu_domain_type type);
>> +
>>   static ssize_t iommu_group_attr_show(struct kobject *kobj,
>>   				     struct attribute *__attr, char *buf)
>>   {
>> @@ -362,6 +365,17 @@ rename:
>>
>>   	kobject_get(group->devices_kobj);
>>
>> +	/*
>> +	 * Try to allocate a default domain for the group, if this
>> +	 * hasn't happened yet. This is not the best place to do that,
>> +	 * it should happen in iommu_group_alloc(). But we have no
>> +	 * iommu_ops there yet, so the allocation has to happen here for
>> +	 * now.
>> +	 */
>> +	if (group->default_domain == NULL)
>> +		group->default_domain = __iommu_domain_alloc(dev->bus,
>> +							     IOMMU_DOMAIN_DMA);
>
> Having a per-group domain is wasteful for IOMMUs that only support a modest
> number of concurrent domains, so in reality I think we need to have one
> domain per IOMMU instance. Is that possible?

Strictly speaking, it is, provided you can identify instances (I've 
hacked up such a thing controlled from the DMA mapping side), but 
there's a question of how to handle devices with differing DMA ranges. 
The Intel IOVA allocator could actually handle them sharing one address 
space, since you can perform individual allocations with different 
constraints, but I'm not sure if that really makes sense. Perhaps one 
domain per dma-ranges variation per instance?

> One problem with the current per-bus approach is that __iommu_domain_alloc
> can't figure out which IOMMU instance corresponds to the group.

Indeed - I think it might make sense to pass devices around instead of 
buses, and for now stick in an abstraction like:

static const struct iommu_ops *get_iommu_for_dev(struct device *dev)
{
	return dev->bus->iommu_ops;
}

in which we can then later hook up some sort of of_iommu_get_ops-based 
lookup for non-PCI devices. Which ends up more or less looking like 
Thierry's original idea, but kept private to the IOMMU API internals.

Robin.

