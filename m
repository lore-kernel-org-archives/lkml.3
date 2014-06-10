Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaFJIFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:05:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:1864 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaFJIFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:05:32 -0400
Message-ID: <5396BC25.7040500@huawei.com>
Date: Tue, 10 Jun 2014 16:04:53 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 3.4 47/88] mm: add kmap_to_page()
References: <20140610002424.500996570@linuxfoundation.org> <20140610002426.089246636@linuxfoundation.org> <alpine.LSU.2.11.1406091806230.8481@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1406091806230.8481@eggly.anvils>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +struct page *kmap_to_page(void *vaddr)
>> +{
>> +	unsigned long addr = (unsigned long)vaddr;
>> +
>> +	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
>> +		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
>> +		return pte_page(pkmap_page_table[i]);
>> +	}
>> +
>> +	return virt_to_page(addr);
>> +}
>> +
>>  static void flush_all_zero_pkmaps(void)
>>  {
>>  	int i;
> 
> I think this needs the following on top:
> 
> commit 498c2280212327858e521e9d21345d4cc2637f54
> Author: Will Deacon <will.deacon@arm.com>
> Date:   Fri Nov 16 14:15:00 2012 -0800
> 

Thanks Hugh. Hi Greg, please pick up this fix patch, Thanks a lot!

Yijing.


>     mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address
>     
>     kmap_to_page returns the corresponding struct page for a virtual address
>     of an arbitrary mapping.  This works by checking whether the address
>     falls in the pkmap region and using the pkmap page tables instead of the
>     linear mapping if appropriate.
>     
>     Unfortunately, the bounds checking means that PKMAP_ADDR(LAST_PKMAP) is
>     incorrectly treated as a highmem address and we can end up walking off
>     the end of pkmap_page_table and subsequently passing junk to pte_page.
>     
>     This patch fixes the bound check to stay within the pkmap tables.
>     
>     Signed-off-by: Will Deacon <will.deacon@arm.com>
>     Cc: Mel Gorman <mgorman@suse.de>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/mm/highmem.c b/mm/highmem.c
> index d517cd16a6eb..2da13a5c50e2 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -98,7 +98,7 @@ struct page *kmap_to_page(void *vaddr)
>  {
>  	unsigned long addr = (unsigned long)vaddr;
>  
> -	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
> +	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
>  		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
>  		return pte_page(pkmap_page_table[i]);
>  	}
> 
> 
> .
> 


-- 
Thanks!
Yijing

