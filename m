Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaJVNzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:55:37 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:54437 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaJVNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:55:32 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:389c:cfae:9fd8:91b0]
In-Reply-To: <1413910307.4202.148.camel@ul30vt.home>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
 <1413205825-6370-10-git-send-email-a.motakis@virtualopensystems.com> <1413910307.4202.148.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 22 Oct 2014 15:55:11 +0200
Message-ID: <CAG8rG2yUmpzzfEYVqA0H+5LcBcLjFY=j43t420Sa7FLnfmG8Ug@mail.gmail.com>
Subject: Re: [PATCH v8 09/18] vfio/platform: support MMAP of MMIO regions
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 6:51 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
>> Allow to memory map the MMIO regions of the device so userspace can
>> directly access them. PIO regions are not being handled at this point.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/vfio_platform_common.c | 57 ++++++++++++++++++++++++++++
>>  1 file changed, 57 insertions(+)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index ac74710..4db7187 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -57,6 +57,16 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>>                       if (!(res->flags & IORESOURCE_READONLY))
>>                               vdev->regions[i].flags |=
>>                                       VFIO_REGION_INFO_FLAG_WRITE;
>> +
>> +                     /*
>> +                      * Only regions addressed with PAGE granularity may be
>> +                      * MMAPed securely.
>> +                      */
>> +                     if (!(vdev->regions[i].addr & ~PAGE_MASK) &&
>> +                                     !(vdev->regions[i].size & ~PAGE_MASK))
>> +                             vdev->regions[i].flags |=
>> +                                     VFIO_REGION_INFO_FLAG_MMAP;
>> +
>
> Should this be included in the above !readonly test?  I don't see that
> we're doing anything below that would prevent writes to the mmap for a
> readonly resource.  I suspect that just like PCI, it's not all that
> useful to provide mmap support for read-only regions.  They're not
> typically performance paths.

Indeed. Alternatively we could just MMAP the region as read only as
well. Even if typically they are not performance critical areas, maybe
it doesn't hurt to allow MMAP when possible.

>
>>                       break;
>>               case IORESOURCE_IO:
>>                       vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
>> @@ -325,8 +335,55 @@ static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
>>       return -EINVAL;
>>  }
>>
>> +static int vfio_platform_mmap_mmio(struct vfio_platform_region region,
>> +                                struct vm_area_struct *vma)
>> +{
>> +     u64 req_len, pgoff, req_start;
>> +
>> +     req_len = vma->vm_end - vma->vm_start;
>> +     pgoff = vma->vm_pgoff &
>> +             ((1U << (VFIO_PLATFORM_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>> +     req_start = pgoff << PAGE_SHIFT;
>> +
>> +     if (region.size < PAGE_SIZE || req_start + req_len > region.size)
>> +             return -EINVAL;
>> +
>> +     vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> +     vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
>> +
>> +     return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>> +                            req_len, vma->vm_page_prot);
>> +}
>> +
>>  static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
>>  {
>> +     struct vfio_platform_device *vdev = device_data;
>> +     unsigned int index;
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
>> +     if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
>> +             return -EINVAL;
>> +
>> +     vma->vm_private_data = vdev;
>> +
>> +     if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_MMIO)
>> +             return vfio_platform_mmap_mmio(vdev->regions[index], vma);
>> +
>> +     else if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_PIO)
>> +             return -EINVAL; /* not implemented */
>> +
>>       return -EINVAL;
>>  }
>>
>
>
>



-- 
Antonios Motakis
Virtual Open Systems
