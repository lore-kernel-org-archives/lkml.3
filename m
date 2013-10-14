Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3JNPRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:17:53 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47744 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab3JNPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:17:51 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:91ce:e2b8:d002:9a5c]
In-Reply-To: <20131014124837.GD10491@mudshark.cambridge.arm.com>
References: <1381497887-14586-1-git-send-email-a.motakis@virtualopensystems.com>
	<1381497887-14586-2-git-send-email-a.motakis@virtualopensystems.com>
	<20131014124837.GD10491@mudshark.cambridge.arm.com>
Date: Mon, 14 Oct 2013 17:17:51 +0200
Message-ID: <CAG8rG2yE=xWmYP_bOy7=jzWEQKNkbgk-9_Jecnx_XXx=jC9i_Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: SMMU: return NULL on error in arm_smmu_iova_to_phys
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        "B08248@freescale.com" <B08248@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 2:48 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Oct 11, 2013 at 02:24:47PM +0100, Antonios Motakis wrote:
>> The return value of arm_smmu_iova_to_phys is directly passed to the
>> user of the IOMMU API via iommu_iova_to_phys; however the ARM SMMU
>> driver returns -EINVAL on error, which is not consistent with the
>> rest of the drivers implementing the IOMMU API. VFIO also relies on
>> the call returning NULL when a page has not been mapped already.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/iommu/arm-smmu.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
>> index 8b71332..fe81b20 100644
>> --- a/drivers/iommu/arm-smmu.c
>> +++ b/drivers/iommu/arm-smmu.c
>> @@ -1480,10 +1480,7 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
>>
>>  err_unlock:
>>       spin_unlock(&smmu_domain->lock);
>> -     dev_warn(smmu->dev,
>> -              "invalid (corrupt?) page tables detected for iova 0x%llx\n",
>> -              (unsigned long long)iova);
>> -     return -EINVAL;
>> +     return NULL;
>
> Why are you removing the warning message?

VFIO will exercise this code path every time when mapping DMA memory.
This is normal and VFIO *expects* the function to fail - it is only if
the function succeeds that VFIO needs to back down from the DMA
mapping and fail.

This means that there would be a warning every time a VFIO user maps
some memory for DMA use, even though nothing went wrong.

>
> Will
