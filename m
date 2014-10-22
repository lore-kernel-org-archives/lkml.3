Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaJVOAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:00:36 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39398 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaJVN6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:09 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:389c:cfae:9fd8:91b0]
In-Reply-To: <5447742A.8070705@linaro.org>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
 <1413205748-6300-4-git-send-email-a.motakis@virtualopensystems.com> <5447742A.8070705@linaro.org>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 22 Oct 2014 15:57:48 +0200
Message-ID: <CAG8rG2ya5J954orHAPrwXO5AMviz=BSfhCh3R+c99usnmC8reQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] vfio: type1: replace domain wide protection flags
 with supported capabilities
To: Eric Auger <eric.auger@linaro.org>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "open list:VFIO DRIVER <kvm@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:08 AM, Eric Auger <eric.auger@linaro.org> wrote:
> On 10/13/2014 03:09 PM, Antonios Motakis wrote:
>> VFIO_IOMMU_TYPE1 keeps track for each domain it knows a list of protection
>> flags it always applies to all mappings in the domain. This is used for
>> domains that support IOMMU_CAP_CACHE_COHERENCY.
>>
>> Refactor this slightly, by keeping track instead that a given domain
>> supports the capability, and applying the IOMMU_CACHE protection flag when
>> doing the actual DMA mappings.
>>
>> This will allow us to reuse the behavior for IOMMU_CAP_NOEXEC, which we
>> also want to keep track of, but without applying it to all domains that
>> support it unless the user explicitly requests it.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 25 +++++++++++++++++--------
>>  1 file changed, 17 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 562f686..62a8b4d 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -64,7 +64,7 @@ struct vfio_domain {
>>       struct iommu_domain     *domain;
>>       struct list_head        next;
>>       struct list_head        group_list;
>> -     int                     prot;           /* IOMMU_CACHE */
>> +     int                     caps;
>>  };
>>
>>  struct vfio_dma {
>> @@ -485,7 +485,7 @@ static int map_try_harder(struct vfio_domain *domain, dma_addr_t iova,
>>       for (i = 0; i < npage; i++, pfn++, iova += PAGE_SIZE) {
>>               ret = iommu_map(domain->domain, iova,
>>                               (phys_addr_t)pfn << PAGE_SHIFT,
>> -                             PAGE_SIZE, prot | domain->prot);
>> +                             PAGE_SIZE, prot);
>>               if (ret)
>>                       break;
>>       }
>> @@ -503,11 +503,16 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
>>       int ret;
>>
>>       list_for_each_entry(d, &iommu->domain_list, next) {
>> +             int dprot = prot;
>> +
>> +             if (d->caps | IOMMU_CAP_CACHE_COHERENCY)
> should be &
>> +                     dprot |= IOMMU_CACHE;
>> +
>>               ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
>> -                             npage << PAGE_SHIFT, prot | d->prot);
>> +                             npage << PAGE_SHIFT, dprot);
>>               if (ret) {
>>                       if (ret != -EBUSY ||
>> -                         map_try_harder(d, iova, pfn, npage, prot))
>> +                         map_try_harder(d, iova, pfn, npage, dprot))
>>                               goto unwind;
>>               }
>>       }
>> @@ -620,6 +625,10 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>>       struct vfio_domain *d;
>>       struct rb_node *n;
>>       int ret;
>> +     int dprot = 0;
>> +
>> +     if (domain->caps | IOMMU_CAP_CACHE_COHERENCY)
> same to be fixed here.
>
> With the 3 "|" corrections and "num--" fix in get_platform_resource, v8
> is functional with Calxeda xgmac QEMU VFIO device.
>

Ack.

> Best Regards
>
> Eric
>> +             dprot |= IOMMU_CACHE;
>>
>>       /* Arbitrarily pick the first domain in the list for lookups */
>>       d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
>> @@ -653,7 +662,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>>                               size += PAGE_SIZE;
>>
>>                       ret = iommu_map(domain->domain, iova, phys,
>> -                                     size, dma->prot | domain->prot);
>> +                                     size, dma->prot | dprot);
>>                       if (ret)
>>                               return ret;
>>
>> @@ -721,7 +730,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>       }
>>
>>       if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
>> -             domain->prot |= IOMMU_CACHE;
>> +             domain->caps |= IOMMU_CAP_CACHE_COHERENCY;
>>
>>       /*
>>        * Try to match an existing compatible domain.  We don't want to
>> @@ -732,7 +741,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>        */
>>       list_for_each_entry(d, &iommu->domain_list, next) {
>>               if (d->domain->ops == domain->domain->ops &&
>> -                 d->prot == domain->prot) {
>> +                 d->caps == domain->caps) {
>>                       iommu_detach_group(domain->domain, iommu_group);
>>                       if (!iommu_attach_group(d->domain, iommu_group)) {
>>                               list_add(&group->next, &d->group_list);
>> @@ -865,7 +874,7 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
>>
>>       mutex_lock(&iommu->lock);
>>       list_for_each_entry(domain, &iommu->domain_list, next) {
>> -             if (!(domain->prot & IOMMU_CACHE)) {
>> +             if (!(domain->caps & IOMMU_CAP_CACHE_COHERENCY)) {
>>                       ret = 0;
>>                       break;
>>               }
>>
>



-- 
Antonios Motakis
Virtual Open Systems
