Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3ITJEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:04:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3ITJEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:04:53 -0400
Message-ID: <523C0FAF.10401@suse.cz>
Date: Fri, 20 Sep 2013 11:04:47 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bob Liu <bob.liu@oracle.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC PATCH RESEND] mm: munlock: Prevent walking off the end of
 a pagetable in no-pmd configuration
References: <52385A59.2080304@suse.cz> <1379427739-31451-1-git-send-email-vbabka@suse.cz> <5238FF3A.2070500@oracle.com>
In-Reply-To: <5238FF3A.2070500@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 03:17 AM, Bob Liu wrote:
> On 09/17/2013 10:22 PM, Vlastimil Babka wrote:

>> --- a/mm/mlock.c
>> +++ b/mm/mlock.c
>> @@ -379,10 +379,14 @@ static unsigned long __munlock_pagevec_fill(struct pagevec *pvec,
>>  
>>  	/*
>>  	 * Initialize pte walk starting at the already pinned page where we
>> -	 * are sure that there is a pte.
>> +	 * are sure that there is a pte, as it was pinned under the same
>> +	 * mmap_sem write op.
>>  	 */
>>  	pte = get_locked_pte(vma->vm_mm, start,	&ptl);
>> -	end = min(end, pmd_addr_end(start, end));
>> +	/* Make sure we do not cross the page table boundary */
>> +	end = pgd_addr_end(start, end);
>> +	end = pud_addr_end(start, end);
>> +	end = pmd_addr_end(start, end);
>>  
> 
> Nitpick, how about unfolding pmd_addr_end(start, end) directly? Like:
> 
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -376,13 +376,14 @@ static unsigned long __munlock_pagevec_fill(struct
> pagevec *pvec,
>  {
>         pte_t *pte;
>         spinlock_t *ptl;
> +       unsigned long pmd_end = (start + PMD_SIZE) & PMD_MASK;
> +       end = (pmd_end - 1 < end - 1) ? pmd_end : end;
> 
>         /*
>          * Initialize pte walk starting at the already pinned page where we
>          * are sure that there is a pte.
>          */
>         pte = get_locked_pte(vma->vm_mm, start, &ptl);
> -       end = min(end, pmd_addr_end(start, end));
> 
>         /* The page next to the pinned page is the first we will try to
> get */
>         start += PAGE_SIZE;
> 

That should also work but for maintainability reasons I wouldn't like to
special case it like this, instead of using standard functions as they
would be used in a full pagewalk.

> Anyway,
> Reviewed-by: Bob Liu <bob.liu@oracle.com>

Thanks.

Vlastimil


