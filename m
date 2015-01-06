Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbbAFVLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:11:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbbAFVLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:11:00 -0500
Message-ID: <54AC4F5F.90306@suse.cz>
Date: Tue, 06 Jan 2015 22:10:55 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH V4 1/4] mm: set page->pfmemalloc in prep_new_page()
References: <1420478263-25207-1-git-send-email-vbabka@suse.cz> <1420478263-25207-2-git-send-email-vbabka@suse.cz> <20150106143008.GA20860@dhcp22.suse.cz>
In-Reply-To: <20150106143008.GA20860@dhcp22.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 03:30 PM, Michal Hocko wrote:
> On Mon 05-01-15 18:17:40, Vlastimil Babka wrote:
>> The function prep_new_page() sets almost everything in the struct page of the
>> page being allocated, except page->pfmemalloc. This is not obvious and has at
>> least once led to a bug where page->pfmemalloc was forgotten to be set
>> correctly, see commit 8fb74b9fb2b1 ("mm: compaction: partially revert capture
>> of suitable high-order page").
>> 
>> This patch moves the pfmemalloc setting to prep_new_page(), which means it
>> needs to gain alloc_flags parameter. The call to prep_new_page is moved from
>> buffered_rmqueue() to get_page_from_freelist(), which also leads to simpler
>> code. An obsolete comment for buffered_rmqueue() is replaced.
>> 
>> In addition to better maintainability there is a small reduction of code and
>> stack usage for get_page_from_freelist(), which inlines the other functions
>> involved.
>> 
>> add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-145 (-145)
>> function                                     old     new   delta
>> get_page_from_freelist                      2670    2525    -145
>> 
>> Stack usage is reduced from 184 to 168 bytes.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Cc: Michal Hocko <mhocko@suse.cz>
> 
> get_page_from_freelist has grown too hairy. I agree that it is tiny less
> confusing now because we are not breaking out of the loop in the
> successful case.

Well, we are returning instead. So there's no more code to follow by anyone
reading the function.

> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> [...]
>> @@ -2177,25 +2181,16 @@ zonelist_scan:
>>  try_this_zone:
>>  		page = buffered_rmqueue(preferred_zone, zone, order,
>>  						gfp_mask, migratetype);
>> -		if (page)
>> -			break;
>> +		if (page) {
>> +			if (prep_new_page(page, order, gfp_mask, alloc_flags))
>> +				goto try_this_zone;
>> +			return page;
>> +		}
> 
> I would probably liked `do {} while ()' more because it wouldn't use the
> goto, but this is up to you:
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1bb65e6f48dd..1682d766cb8e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2175,10 +2175,11 @@ zonelist_scan:
>  		}
>  
>  try_this_zone:
> -		page = buffered_rmqueue(preferred_zone, zone, order,
> +		do {
> +			page = buffered_rmqueue(preferred_zone, zone, order,
>  						gfp_mask, migratetype);
> -		if (page)
> -			break;
> +		} while (page && prep_new_page(page, order, gfp_mask,
> +					       alloc_flags));

Hm but here we wouldn't return page on success. I wonder if you overlooked the
return, hence your "not breaking out of the loop" remark?

>  this_zone_full:
>  		if (IS_ENABLED(CONFIG_NUMA) && zlc_active)
>  			zlc_mark_zone_full(zonelist, z);
> 
> [...]
> 

