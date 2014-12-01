Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaLAHrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:47:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43267 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaLAHrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:47:06 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <547C1CC9.7080100@jp.fujitsu.com>
Date: Mon, 1 Dec 2014 16:46:17 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: unmapped page migration avoid unmap+remap overhead
References: <alpine.LSU.2.11.1411302046420.5335@eggly.anvils> <547C0E4E.4020605@jp.fujitsu.com> <alpine.LSU.2.11.1411302302280.6613@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1411302302280.6613@eggly.anvils>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/01 16:28), Hugh Dickins wrote:
> On Mon, 1 Dec 2014, Yasuaki Ishimatsu wrote:
>> (2014/12/01 13:52), Hugh Dickins wrote:
>>> @@ -798,7 +798,7 @@ static int __unmap_and_move(struct page
>>>    				int force, enum migrate_mode mode)
>>>    {
>>>    	int rc = -EAGAIN;
>>> -	int remap_swapcache = 1;
>>> +	int page_was_mapped = 0;
>>>    	struct anon_vma *anon_vma = NULL;
>>>
>>>    	if (!trylock_page(page)) {
>>> @@ -870,7 +870,6 @@ static int __unmap_and_move(struct page
>>>    			 * migrated but are not remapped when migration
>>>    			 * completes
>>>    			 */
>>> -			remap_swapcache = 0;
>>>    		} else {
>>>    			goto out_unlock;
>>>    		}
>>> @@ -910,13 +909,17 @@ static int __unmap_and_move(struct page
>>>    	}
>>>
>>>    	/* Establish migration ptes or remove ptes */
>>
>>> -	try_to_unmap(page, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
>>> +	if (page_mapped(page)) {
>>> +		try_to_unmap(page,
>>> +			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
>>> +		page_was_mapped = 1;
>>> +	}
>>
>> Is there no possibility that page is swap cache? If page is swap cache,
>> this code changes behavior of move_to_new_page(). Is it O.K.?
>
> Certainly the page may be swap cache, but I don't see how the behavior
> of move_to_new_page() is changed.
>
> Do you mean how I removed that "remap_swapcache = 0;" line above, so that
> it now looks as if move_to_new_page() may be called with page_was_mapped
> 1, where before it was called with remap_swapcache 0?

Yes. I pointed it.

>
> No: although it cannot be seen from the patch context, that reset
> of remap_swapcache was in a block where we have a PageAnon page, but
> page_get_anon_vma() failed to "get" the anon_vma for it: that means
> that the page was not mapped, so page_was_mapped will be 0 too.
>
> (I was going to add that the page might be faulted back in again by
> the time we reach the page_mapped() test above try_to_unmap(), and
> that yes I'd would be making a change in that case, but it does not
> matter at all to diverge in racy cases.  But actually even that cannot
> happen, since faulting back swap needs page lock which we hold here.)
>
> There is an argument that move_to_new_page() behavior should be
> changed in the case of swap cache: since try_to_unmap() then uses
> the ordinary swap instead of a migration entry, there's not much
> point in going to remove swap entries afterwards; though it would
> be good to make those pages present again.  But I didn't try to
> change that in this patch: this was just a lock contention thing.

Thank you for the explanation.
I understood it.

Thanks,
Yasuaki Ishimatsu


>
> Hugh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


