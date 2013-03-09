Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935Ab3CIDyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:54:31 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:59571 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760304Ab3CIDya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:54:30 -0500
Message-ID: <513AB270.1020503@gmail.com>
Date: Sat, 09 Mar 2013 11:54:24 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: page_alloc: remove branch operation in free_pages_prepare()
References: <1362644480-18381-1-git-send-email-iamjoonsoo.kim@lge.com> <alpine.LNX.2.00.1303071050080.6087@eggly.anvils> <20130308004550.GA19010@lge.com> <alpine.LNX.2.00.1303071745001.7553@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1303071745001.7553@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,
On 03/08/2013 10:01 AM, Hugh Dickins wrote:
> On Fri, 8 Mar 2013, Joonsoo Kim wrote:
>> On Thu, Mar 07, 2013 at 10:54:15AM -0800, Hugh Dickins wrote:
>>> On Thu, 7 Mar 2013, Joonsoo Kim wrote:
>>>
>>>> When we found that the flag has a bit of PAGE_FLAGS_CHECK_AT_PREP,
>>>> we reset the flag. If we always reset the flag, we can reduce one
>>>> branch operation. So remove it.
>>>>
>>>> Cc: Hugh Dickins <hughd@google.com>
>>>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>> I don't object to this patch.  But certainly I would have written it
>>> that way in order not to dirty a cacheline unnecessarily.  It may be
>>> obvious to you that the cacheline in question is almost always already
>>> dirty, and the branch almost always more expensive.  But I'll leave that
>>> to you, and to those who know more about these subtle costs than I do.
>> Yes. I already think about that. I thought that even if a cacheline is
>> not dirty at this time, we always touch the 'struct page' in
>> set_freepage_migratetype() a little later, so dirtying is not the problem.
> I expect that a very high proportion of user pages have
> PG_uptodate to be cleared here; and there's also the recently added

When PG_uptodate will be set?

> page_nid_reset_last(), which will dirty the flags or a nearby field
> when CONFIG_NUMA_BALANCING.  Those argue in favour of your patch.
>
>> But, now, I re-think this and decide to drop this patch.
>> The reason is that 'struct page' of 'compound pages' may not be dirty
>> at this time and will not be dirty at later time.
> Actual compound pages would have PG_head or PG_tail or PG_compound
> to be cleared there, I believe (check if I'm right on that).  The
> questionable case is the ordinary order>0 case without __GFP_COMP
> (and page_nid_reset_last() is applied to each subpage of those).
>
>> So this patch is bad idea.
> I'm not so sure.  I doubt your patch will make a giant improvement
> in kernel performance!  But it might make a little - maybe you just
> need to give some numbers from perf to justify it (but I'm easily
> dazzled by numbers - don't expect me to judge the result).
>
> Hugh
>
>> Is there any comments?
>>
>> Thanks.
>>
>>> Hugh
>>>
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index 8fcced7..778f2a9 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -614,8 +614,7 @@ static inline int free_pages_check(struct page *page)
>>>>   		return 1;
>>>>   	}
>>>>   	page_nid_reset_last(page);
>>>> -	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
>>>> -		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
>>>> +	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
>>>>   	return 0;
>>>>   }
>>>>   
>>> --
>>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>> the body to majordomo@kvack.org.  For more info on Linux MM,
>>> see: http://www.linux-mm.org/ .
>>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

