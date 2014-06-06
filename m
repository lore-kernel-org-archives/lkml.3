Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaFFBDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 21:03:45 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:54811 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaFFBDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 21:03:44 -0400
Message-ID: <5391136C.3010809@gmail.com>
Date: Thu, 05 Jun 2014 21:03:40 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Pranith Kumar <pranith@gatech.edu>, dwmw2@infradead.org,
        joro@8bytes.org
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] use documented cmpxchg api
References: <5390ED07.2070009@gatech.edu> <53910C95.7000808@hurleysoftware.com>
In-Reply-To: <53910C95.7000808@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 08:34 PM, Peter Hurley wrote:
> On 06/05/2014 06:19 PM, Pranith Kumar wrote:
>> use the documented atomic_cmpxchg instead of __cmpxchg64
>>
>> This kills the last user of said API in drivers code.
>>
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> ---
>>   drivers/iommu/intel-iommu.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index 6bb3277..270113f 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -293,7 +293,7 @@ static inline u64 dma_pte_addr(struct dma_pte *pte)
>>       return pte->val & VTD_PAGE_MASK;
>>   #else
>>       /* Must have a full atomic 64-bit read */
>> -    return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
>> +    return  atomic_cmpxchg(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
> 
> This is not equivalent.
> 
> The __cmpxchg64() is specifically being used in this case
> when !CONFIG_64BIT for a full 64-bit RMW, whereas atomic_cmpxchg()
> uses ints which would be 32-bit RMW.
> 


You are right! The previous patch is wrong in that atomic_cmpxchg needs an atomic_t argument.
cmpxchg() handles the size internally using typeof() to figure out the width of RMW.
There is also an explicit cmpxchg64() which does the same thing.

Fixed with the following v2:

use the documented cmpxchg instead of __cmpxchg64

This kills the last user of said API in drivers code.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6bb3277..270113f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -293,7 +293,7 @@ static inline u64 dma_pte_addr(struct dma_pte *pte)
 	return pte->val & VTD_PAGE_MASK;
 #else
 	/* Must have a full atomic 64-bit read */
-	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
+	return  cmpxchg(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
 #endif
 }
 
-- 
1.7.9.5

