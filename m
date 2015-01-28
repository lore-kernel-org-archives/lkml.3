Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbbA1UYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:24:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036AbbA1UYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:24:08 -0500
Message-ID: <54C8A850.1000205@suse.cz>
Date: Wed, 28 Jan 2015 10:13:52 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>
CC: linux-mm@kvack.org, akpm@linux-foundation.org, kirill@shutemov.name,
        mhocko@suse.cz, mgorman@suse.de, rientjes@google.com,
        sasha.levin@oracle.com, hughd@google.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        zhangyanfei.linux@aliyun.com
Subject: Re: [PATCH v3] mm: incorporate read-only pages into transparent huge
 pages
References: <1422380353-4407-1-git-send-email-ebru.akagunduz@gmail.com> <20150128002711.GY11755@redhat.com>
In-Reply-To: <20150128002711.GY11755@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 01:27 AM, Andrea Arcangeli wrote:
> On Tue, Jan 27, 2015 at 07:39:13PM +0200, Ebru Akagunduz wrote:
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 817a875..17d6e59 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2148,17 +2148,18 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   {
>>   	struct page *page;
>>   	pte_t *_pte;
>> -	int referenced = 0, none = 0;
>> +	int referenced = 0, none = 0, ro = 0, writable = 0;
>
> So your "writable" addition is enough and simpler/better than "ro"
> counting. Once "ro" is removed "writable" can actually start to make a
> difference (at the moment it does not).
>
> I'd suggest to remove "ro".
>
> The sysctl was there only to reduce the memory footprint but
> collapsing readonly swapcache won't reduce the memory footprint. So it
> may have been handy before but this new "writable" looks better now
> and keeping both doesn't help (keeping "ro" around prevents "writable"
> to make a difference).

Agree.

>> @@ -2179,6 +2177,34 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   		 */
>>   		if (!trylock_page(page))
>>   			goto out;
>> +
>> +		/*
>> +		 * cannot use mapcount: can't collapse if there's a gup pin.
>> +		 * The page must only be referenced by the scanned process
>> +		 * and page swap cache.
>> +		 */
>> +		if (page_count(page) != 1 + !!PageSwapCache(page)) {
>> +			unlock_page(page);
>> +			goto out;
>> +		}
>> +		if (!pte_write(pteval)) {
>> +			if (++ro > khugepaged_max_ptes_none) {
>> +				unlock_page(page);
>> +				goto out;
>> +			}
>> +			if (PageSwapCache(page) && !reuse_swap_page(page)) {
>> +				unlock_page(page);
>> +				goto out;
>> +			}
>> +			/*
>> +			 * Page is not in the swap cache, and page count is
>> +			 * one (see above). It can be collapsed into a THP.
>> +			 */
>> +			VM_BUG_ON(page_count(page) != 1);
>
> In an earlier email I commented on this suggestion you received during
> previous code review: the VM_BUG_ON is not ok because it can generate
> false positives.
>
> It's perfectly ok if page_count is not 1 if the page is isolated by
> another CPU (another cpu calling isolate_lru_page).
>
> The page_count check there is to ensure there are no gup-pins, and
> that is achieved during the check. The VM may still mangle the
> page_count and it's ok (the page count taken by the VM running in
> another CPU doesn't need to be transferred to the collapsed THP).
>
> In short, the check "page_count(page) != 1 + !!PageSwapCache(page)"
> doesn't imply that the page_count cannot change. It only means at any
> given time there was no gup-pin at the very time of the check. It also
> means there were no other VM pin, but what we care about is only the
> gup-pin. The VM LRU pin can still be taken after the check and it's
> ok. The GUP pin cannot be taken because we stopped all gup so we're
> safe if the check passes.
>
> So you can simply delete the VM_BUG_ON, the earlier code there, was fine.

There's still the comment that's IMHO misleading in light of your 
explanation:

/*
  * Page is not in the swap cache, and page count is
  * one (see above). It can be collapsed into a THP.
  */

Maybe just delete it too.

>
>> +		} else {
>> +			writable = 1;
>> +		}
>> +
>
> I suggest to make writable a bool and use writable = false to init,
> and writable = true above.
>
> When a value can only be 0|1 bool is better (it can be casted and
> takes the same memory as an int, it just allows the compiler to be
> more strict and the fact it makes the code more self explanatory).

While at it, "referenced" is also used only as a bool, so convert it to 
bool as well?

>> +			if (++ro > khugepaged_max_ptes_none)
>> +				goto out_unmap;
>
> As mentioned above the ro counting can go, and we can keep only
> your new writable addition, as mentioned above.
>
> Thanks,
> Andrea
>

