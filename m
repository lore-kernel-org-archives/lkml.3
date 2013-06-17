Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3FQDio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:38:44 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:2459 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab3FQDim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:38:42 -0400
Message-ID: <51BE84BD.6050501@hp.com>
Date: Mon, 17 Jun 2013 11:38:37 +0800
From: "Li, Zhen-Hua (USL-China)" <zhen-hual@hp.com>
Organization: USL-China
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: David Woodhouse <dwmw2@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/iommu: fix dma pte address size error
References: <1369355756-1030-1-git-send-email-zhen-hual@hp.com> <51BB7A1E.5000605@redhat.com>
In-Reply-To: <51BB7A1E.5000605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

This patch is not only for the sake of spec interpretation.
Till now I did not see any bugs , but it does not meant no bugs will appear
in the future. The address returned by dma_pte_addr is used in many places.

Thanks
Zhenhua


On 06/15/2013 04:16 AM, Don Dutile wrote:
> On 05/23/2013 08:35 PM, Li, Zhen-Hua wrote:
>> In Intel Vt-D specs, Chapter 9.3 Page-Table Entry,
>> The size of ADDR(address) field is 12:51, but the function dma_pte_addr
>>   treats it as 12:63.
>>
>> Signed-off-by: Li, Zhen-Hua<zhen-hual@hp.com>
>> ---
>>   drivers/iommu/intel-iommu.c   |    4 ++--
>>   include/linux/dma_remapping.h |    2 ++
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>
> Is this patching for the sake of spec interpretation?
> a dma-pte format (consumed by iommu) has 63,61:52 as available for sw, 
> ignored by hw.
> 62 is 'transient mapping' bit, which is a _hint_ for selecting iotlbs 
> to flush sooner.
> finally, the system would have to have a memory map that actually has 
> bit 62 set to
> be affected.
>
> So, for intel-iommu, I don't see a bug occurring.
> Did you actually have one with previous definition, and if so,
> could you provide that information ?
>
> Cheers,
> - Don
>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index b4f0e28..c6d2847 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -311,10 +311,10 @@ static inline void dma_set_pte_prot(struct 
>> dma_pte *pte, unsigned long prot)
>>   static inline u64 dma_pte_addr(struct dma_pte *pte)
>>   {
>>   #ifdef CONFIG_64BIT
>> -    return pte->val&  VTD_PAGE_MASK;
>> +    return pte->val&  DMA_PTE_MASK;
>>   #else
>>       /* Must have a full atomic 64-bit read */
>> -    return  __cmpxchg64(&pte->val, 0ULL, 0ULL)& VTD_PAGE_MASK;
>> +    return  __cmpxchg64(&pte->val, 0ULL, 0ULL)& DMA_PTE_MASK;
>>   #endif
>>   }
>>
>> diff --git a/include/linux/dma_remapping.h 
>> b/include/linux/dma_remapping.h
>> index 57c9a8a..7a1e212 100644
>> --- a/include/linux/dma_remapping.h
>> +++ b/include/linux/dma_remapping.h
>> @@ -16,6 +16,8 @@
>>   #define DMA_PTE_WRITE (2)
>>   #define DMA_PTE_LARGE_PAGE (1<<  7)
>>   #define DMA_PTE_SNP (1<<  11)
>> +#define DMA_PTE_ADD_LENGTH (40)
>> +#define DMA_PTE_MASK    ((((u64)1<<  DMA_PTE_ADD_LENGTH) - 1)<<  
>> VTD_PAGE_SHIFT)
>>
>>   #define CONTEXT_TT_MULTI_LEVEL    0
>>   #define CONTEXT_TT_DEV_IOTLB    1
>
> .
>

