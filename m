Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbaKUB0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:26:09 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:35718 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbaKUB0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:26:06 -0500
Message-ID: <546E948E.2090502@huawei.com>
Date: Fri, 21 Nov 2014 09:25:34 +0800
From: leizhen <thunder.leizhen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: KVM <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        Tianhong Ding <dingtianhong@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH 1/1] vfio: put off the allocation of "minor" in vfio_create_group
References: <1416482702-10820-1-git-send-email-thunder.leizhen@huawei.com> <1416497837.27937.362.camel@ul30vt.home>
In-Reply-To: <1416497837.27937.362.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.142]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/20 23:37, Alex Williamson wrote:
> On Thu, 2014-11-20 at 19:25 +0800, Zhen Lei wrote:
>> The next code fragment "list_for_each_entry" is not depend on "minor". With this
>> patch, the free of "minor" in "list_for_each_entry" can be reduced, and there is
>> no functional change.
> 
> A reasonable micro-optimization, but I'm curious if you're actually
> seeing some measurable overhead from this.  It seems like we'd need to

Oh, I just found this by code review. It's good to put pure check first and
resource allocation later, if they are order independent. Isn't it?
I think it will not improve performance but only save a little code space
and looks feel better.

> have multiple devices, all within the same IOMMU group, all probed by
> vfio-pci at the same time to exercise the race condition.  Thanks,

I think vfio_create_group can not be invoked frequently. So, the performance of this function
is not a major consideration, we don't care slightly performance change.

> 
> Alex
> 
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>> ---
>>  drivers/vfio/vfio.c | 13 ++++++-------
>>  1 file changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index f018d8d..737eb468 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -225,22 +225,21 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
>>
>>  	mutex_lock(&vfio.group_lock);
>>
>> -	minor = vfio_alloc_group_minor(group);
>> -	if (minor < 0) {
>> -		vfio_group_unlock_and_free(group);
>> -		return ERR_PTR(minor);
>> -	}
>> -
>>  	/* Did we race creating this group? */
>>  	list_for_each_entry(tmp, &vfio.group_list, vfio_next) {
>>  		if (tmp->iommu_group == iommu_group) {
>>  			vfio_group_get(tmp);
>> -			vfio_free_group_minor(minor);
>>  			vfio_group_unlock_and_free(group);
>>  			return tmp;
>>  		}
>>  	}
>>
>> +	minor = vfio_alloc_group_minor(group);
>> +	if (minor < 0) {
>> +		vfio_group_unlock_and_free(group);
>> +		return ERR_PTR(minor);
>> +	}
>> +
>>  	dev = device_create(vfio.class, NULL,
>>  			    MKDEV(MAJOR(vfio.group_devt), minor),
>>  			    group, "%d", iommu_group_id(iommu_group));
>> --
>> 1.8.0
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> 
> .
> 


