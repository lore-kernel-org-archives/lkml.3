Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaGJHqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:46:47 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:52977 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaGJHqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:46:46 -0400
Message-ID: <53BE44DB.8080400@linux.vnet.ibm.com>
Date: Thu, 10 Jul 2014 13:16:35 +0530
From: Madhusudanan Kandasamy <kmadhu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Fail remap_4k_pfn() if PFN doesn't fit inside
 PTE
References: <53BD68FF.7000307@linux.vnet.ibm.com> <20140710084911.22cb58d4@canb.auug.org.au>
In-Reply-To: <20140710084911.22cb58d4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071007-8256-0000-0000-00000E62BF5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for the suggestion, I'll send a new patch.

On Thursday 10 July 2014 04:19 AM, Stephen Rothwell wrote:
> Hi Madhusudanan,
> 
> On Wed, 09 Jul 2014 21:38:31 +0530 Madhusudanan Kandasamy <kmadhu@linux.vnet.ibm.com> wrote:
>>
>> diff --git a/arch/powerpc/include/asm/pte-hash64-64k.h b/arch/powerpc/include/asm/pte-hash64-64k.h
>> index d836d94..10af7f1 100644
>> --- a/arch/powerpc/include/asm/pte-hash64-64k.h
>> +++ b/arch/powerpc/include/asm/pte-hash64-64k.h
>> @@ -74,8 +74,15 @@
>>  #define pte_pagesize_index(mm, addr, pte)	\
>>  	(((pte) & _PAGE_COMBO)? MMU_PAGE_4K: MMU_PAGE_64K)
>>
>> +static inline int bad_4k_pfn(void)
>> +{
>> +	WARN_ON(1);
>> +	return -EINVAL;
>> +}
>> +
>>  #define remap_4k_pfn(vma, addr, pfn, prot)				\
>> -	remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,		\
>> -			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN))
>> +	((pfn >= (1UL << (64 - PTE_RPN_SHIFT))) ? bad_4k_pfn() :	\
>> +		remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,	\
>> +			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN)))
>>
>>  #endif	/* __ASSEMBLY__ */
> 
> WARN_ON() returns the value it is passed, so no helper is needed:
> 
>  #define remap_4k_pfn(vma, addr, pfn, prot)				\
> -	remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,		\
> -			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN))
> +	WARN_ON(((pfn >= (1UL << (64 - PTE_RPN_SHIFT)))) ? -EINVAL :	\
> +		remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,	\
> +			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN)))
> 

