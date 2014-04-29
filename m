Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbaD2N3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:29:14 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38220 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbaD2N3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:29:11 -0400
MIME-Version: 1.0
X-Originating-IP: [82.67.68.96]
In-Reply-To: <1398706042.24318.287.camel@ul30vt.home>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
 <1398700371-20096-9-git-send-email-a.motakis@virtualopensystems.com> <1398706042.24318.287.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Tue, 29 Apr 2014 15:28:43 +0200
Message-ID: <CAG8rG2zvEVEAM0XH_Ow81yNBExKRKM9u0tO5ochK0ZYuipXynA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 08/11] VFIO_PLATFORM: Support MMAP of MMIO regions
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        alvise rigo <a.rigo@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 7:27 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-04-28 at 17:52 +0200, Antonios Motakis wrote:
>> Allow to memory map the MMIO regions of the device so userspace can
>> directly access them.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/vfio_platform.c | 40 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 39 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
>> index 7c01ced..37beff3 100644
>> --- a/drivers/vfio/platform/vfio_platform.c
>> +++ b/drivers/vfio/platform/vfio_platform.c
>> @@ -58,6 +58,11 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>>               region.flags = VFIO_REGION_INFO_FLAG_READ
>>                               | VFIO_REGION_INFO_FLAG_WRITE;
>>
>> +             /* Only regions addressed with PAGE granularity can be MMAPed
>> +              * securely. */
>> +             if (!(region.addr & ~PAGE_MASK) && !(region.size & ~PAGE_MASK))
>> +                     region.flags |= VFIO_REGION_INFO_FLAG_MMAP;
>> +
>
> Ok, so the security is only that we need page alignment.  Maybe that
> could be made more clear in the previous patch.  PCI has regions like
> the MSI-X table that we need to protect from userspace access beyond
> page alignment requirements.  Thanks,

Ack, I will make the previous description more clear.

>
> Alex
>
>>               vdev->region[i] = region;
>>       }
>>
>> @@ -268,7 +273,40 @@ err:
>>
>>  static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
>>  {
>> -     return -EINVAL;
>> +     struct vfio_platform_device *vdev = device_data;
>> +     unsigned int index;
>> +     u64 req_len, pgoff, req_start;
>> +     struct vfio_platform_region region;
>> +
>> +     index = vma->vm_pgoff >> (VFIO_PLATFORM_OFFSET_SHIFT - PAGE_SHIFT);
>> +
>> +     if (vma->vm_end < vma->vm_start)
>> +             return -EINVAL;
>> +     if ((vma->vm_flags & VM_SHARED) == 0)
>> +             return -EINVAL;
>> +     if (index >= vdev->num_regions)
>> +             return -EINVAL;
>> +     if (vma->vm_start & ~PAGE_MASK)
>> +             return -EINVAL;
>> +     if (vma->vm_end & ~PAGE_MASK)
>> +             return -EINVAL;
>> +
>> +     region = vdev->region[index];
>> +
>> +     req_len = vma->vm_end - vma->vm_start;
>> +     pgoff = vma->vm_pgoff &
>> +             ((1U << (VFIO_PLATFORM_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>> +     req_start = pgoff << PAGE_SHIFT;
>> +
>> +     if (region.size < PAGE_SIZE || req_start + req_len > region.size)
>> +             return -EINVAL;
>> +
>> +     vma->vm_private_data = vdev;
>> +     vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> +     vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
>> +
>> +     return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>> +                            req_len, vma->vm_page_prot);
>>  }
>>
>>  static const struct vfio_device_ops vfio_platform_ops = {
>
>
>



-- 
Antonios Motakis
Virtual Open Systems
