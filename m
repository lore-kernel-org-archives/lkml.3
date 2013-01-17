Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3AQO6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 09:58:51 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56096 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3AQO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 09:58:49 -0500
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="scan'208";a="20666541"
Message-ID: <50F811A1.5050707@codeaurora.org>
Date: Thu, 17 Jan 2013 20:28:41 +0530
From: Subhash Jadavani <subhashj@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        asias@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with non-contiguous
 descriptors
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org> <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com> <50F64AC1.3040304@codeaurora.org> <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com> <20130116231857.GU2668@htj.dyndns.org> <1358413880.2394.7.camel@dabdike.int.hansenpartnership.com> <20130117103742.GX23505@n2100.arm.linux.org.uk> <20130117104741.GY23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130117104741.GY23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2013 4:17 PM, Russell King - ARM Linux wrote:
> On Thu, Jan 17, 2013 at 10:37:42AM +0000, Russell King - ARM Linux wrote:
>> On Thu, Jan 17, 2013 at 09:11:20AM +0000, James Bottomley wrote:
>>> I'd actually prefer page = pfn_to_page(page_to_pfn(page) + 1); because
>>> it makes the code look like the hack it is.  The preferred form for all
>>> iterators like this should be to iterate over the pfn instead of a
>>> pointer into the page arrays, because that will always work correctly no
>>> matter how many weird and wonderful memory schemes we come up with.
>> So, why don't we update the code to do that then?
> Also, couldn't the addition of the scatterlist offset to the page also
> be buggy too?
>
> So, what about this patch which addresses both additions by keeping our
> iterator as a pfn as you suggest.  It also simplifies some of the code
> in the loop too.
>
> Can the original folk with the problem test this patch?

Yes, this patch also fixes the issue.  You may add: Tested-by: Subhash 
Jadavani <subhashj@codeaurora.org> .

Regards,
Subhash

>
>   arch/arm/mm/dma-mapping.c |   18 ++++++++++--------
>   1 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 6b2fb87..076c26d 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -774,25 +774,27 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
>   	size_t size, enum dma_data_direction dir,
>   	void (*op)(const void *, size_t, int))
>   {
> +	unsigned long pfn;
> +	size_t left = size;
> +
> +	pfn = page_to_pfn(page) + offset / PAGE_SIZE;
> +	offset %= PAGE_SIZE;
> +
>   	/*
>   	 * A single sg entry may refer to multiple physically contiguous
>   	 * pages.  But we still need to process highmem pages individually.
>   	 * If highmem is not configured then the bulk of this loop gets
>   	 * optimized out.
>   	 */
> -	size_t left = size;
>   	do {
>   		size_t len = left;
>   		void *vaddr;
>   
> +		page = pfn_to_page(pfn);
> +
>   		if (PageHighMem(page)) {
> -			if (len + offset > PAGE_SIZE) {
> -				if (offset >= PAGE_SIZE) {
> -					page += offset / PAGE_SIZE;
> -					offset %= PAGE_SIZE;
> -				}
> +			if (len + offset > PAGE_SIZE)
>   				len = PAGE_SIZE - offset;
> -			}
>   			vaddr = kmap_high_get(page);
>   			if (vaddr) {
>   				vaddr += offset;
> @@ -809,7 +811,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
>   			op(vaddr, len, dir);
>   		}
>   		offset = 0;
> -		page++;
> +		pfn++;
>   		left -= len;
>   	} while (left);
>   }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

