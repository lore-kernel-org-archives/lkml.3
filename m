Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab3FVDQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 23:16:55 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45421 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3FVDQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 23:16:53 -0400
Message-ID: <51C5171F.70001@ozlabs.ru>
Date: Sat, 22 Jun 2013 13:16:47 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] vfio: Limit group opens
References: <20130621211144.8237.7370.stgit@bling.home>   <51C4FAF4.5090509@ozlabs.ru> <1371864389.30572.142.camel@ul30vt.home>  <51C50F98.9020301@ozlabs.ru> <1371869848.30572.148.camel@ul30vt.home>
In-Reply-To: <1371869848.30572.148.camel@ul30vt.home>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2013 12:57 PM, Alex Williamson wrote:
> On Sat, 2013-06-22 at 12:44 +1000, Alexey Kardashevskiy wrote:
>> On 06/22/2013 11:26 AM, Alex Williamson wrote:
>>> On Sat, 2013-06-22 at 11:16 +1000, Alexey Kardashevskiy wrote:
>>>> Cool, thanks!
>>>>
>>>> So we will need only this (to be called from KVM), and that will be it, right?
>>>
>>> For what?  This is not the external lock you're looking for.  As I've
>>> mentioned, the file can only hold the group, but that doesn't give you
>>> any guarantee that the group is protected by the IOMMU.  Thanks,
>>
>>
>> I am confused, sorry :) With this patch, a group fd cannot be reopened if
>> already opened, and this is the only way for user space to take control
>> over a group. If it is not an external lock, then what is it? And all I
>> have to do now is to verify that the group fd passed to KVM is correct and
>> I am happy. Who and how can break anything (group? KVM?) now?
> 
> By that logic all a user needs to do is open() a group and they they're
> free to pass the fd to KVM, right?  But the IOMMU protection isn't
> enabled until the user calls SET_CONTAINER and SET_IOMMU, so you'd be
> giving KVM access to the IOMMU that the user hasn't enabled.  The group
> may still have devices attached to host drivers.  Likewise, a user need
> only call UNSET_CONTAINER to teardown the IOMMU protection.  At that
> point a device could be re-bound to host drivers, thus making it unsafe
> for KVM to be directly poking the IOMMU.
> 
> This patch is just a bug fix for inconsistent behavior.  Thanks,

Oh. Thanks for the detailed explanation, I was missing this one.

Yeah. Looks like we need some other brand new lock now... Something like a
notifier from VFIO to KVM to inform KVM that it can or cannot use the group
now (on VFIO_IOMMU_ENABLE/VFIO_IOMMU_DISABLE or some new ioctls) so KVM
would not touch the group in not allowed.

typedef int notifier_fn(bool enable);
int vfio_group_iommu_id_from_file(struct file *filep, notifier_fn fn);

?


> 
> Alex
>  
>>>> int vfio_group_iommu_id_from_file(struct file *filep)
>>>> ...
>>>>
>>>>
>>>>
>>>> On 06/22/2013 07:12 AM, Alex Williamson wrote:
>>>>> vfio_group_fops_open attempts to limit concurrent sessions by
>>>>> disallowing opens once group->container is set.  This really doesn't
>>>>> do what we want and allow for inconsistent behavior, for instance a
>>>>> group can be opened twice, then a container set giving the user two
>>>>> file descriptors to the group.  But then it won't allow more to be
>>>>> opened.  There's not much reason to have the group opened multiple
>>>>> times since most access is through devices or the container, so
>>>>> complete what the original code intended and only allow a single
>>>>> instance.
>>>>>
>>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>>>> ---
>>>>>  drivers/vfio/vfio.c |   14 ++++++++++++++
>>>>>  1 file changed, 14 insertions(+)
>>>>>
>>>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>>>> index 6d78736..d30f44d 100644
>>>>> --- a/drivers/vfio/vfio.c
>>>>> +++ b/drivers/vfio/vfio.c
>>>>> @@ -76,6 +76,7 @@ struct vfio_group {
>>>>>  	struct notifier_block		nb;
>>>>>  	struct list_head		vfio_next;
>>>>>  	struct list_head		container_next;
>>>>> +	atomic_t			opened;
>>>>>  };
>>>>>  
>>>>>  struct vfio_device {
>>>>> @@ -206,6 +207,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
>>>>>  	INIT_LIST_HEAD(&group->device_list);
>>>>>  	mutex_init(&group->device_lock);
>>>>>  	atomic_set(&group->container_users, 0);
>>>>> +	atomic_set(&group->opened, 0);
>>>>>  	group->iommu_group = iommu_group;
>>>>>  
>>>>>  	group->nb.notifier_call = vfio_iommu_group_notifier;
>>>>> @@ -1236,12 +1238,22 @@ static long vfio_group_fops_compat_ioctl(struct file *filep,
>>>>>  static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>>>>>  {
>>>>>  	struct vfio_group *group;
>>>>> +	int opened;
>>>>>  
>>>>>  	group = vfio_group_get_from_minor(iminor(inode));
>>>>>  	if (!group)
>>>>>  		return -ENODEV;
>>>>>  
>>>>> +	/* Do we need multiple instances of the group open?  Seems not. */
>>>>> +	opened = atomic_cmpxchg(&group->opened, 0, 1);
>>>>> +	if (opened) {
>>>>> +		vfio_group_put(group);
>>>>> +		return -EBUSY;
>>>>> +	}
>>>>> +
>>>>> +	/* Is something still in use from a previous open? */
>>>>>  	if (group->container) {
>>>>> +		atomic_dec(&group->opened);
>>>>>  		vfio_group_put(group);
>>>>>  		return -EBUSY;
>>>>>  	}
>>>>> @@ -1259,6 +1271,8 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
>>>>>  
>>>>>  	vfio_group_try_dissolve_container(group);
>>>>>  
>>>>> +	atomic_dec(&group->opened);
>>>>> +
>>>>>  	vfio_group_put(group);
>>>>>  
>>>>>  	return 0;
>>>>>
>>>>
>>>>
>>>
>>>
>>>
>>
>>
> 
> 
> 


-- 
Alexey
