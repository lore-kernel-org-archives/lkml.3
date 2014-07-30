Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaG3J5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:57:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaG3J5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:57:01 -0400
Message-ID: <53D8C16B.7070206@suse.cz>
Date: Wed, 30 Jul 2014 11:56:59 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 14/14] mm, compaction: try to capture the just-created
 high-order freepage
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-15-git-send-email-vbabka@suse.cz> <20140729073456.GC1610@js1304-P5Q-DELUXE> <53D7BF0D.5050404@suse.cz> <20140730083920.GA24427@js1304-P5Q-DELUXE>
In-Reply-To: <20140730083920.GA24427@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 10:39 AM, Joonsoo Kim wrote:
> On Tue, Jul 29, 2014 at 05:34:37PM +0200, Vlastimil Babka wrote:
>> Could do it in isolate_migratepages() for whole pageblocks only (as
>> David's patch did), but that restricts the usefulness. Or maybe do
>> it fine grained by calling isolate_migratepages_block() multiple
>> times. But the overhead of multiple calls would probably suck even
>> more for lower-order compactions. For CMA the added overhead is
>> basically only checks for next_capture_pfn that will be always
>> false, so predictable. And mostly just in branches where isolation
>> is failing, which is not the CMA's "fast path" I guess?
>
> You can do it find grained with compact_control's migratepages list
> or new private list. If some pages are isolated and added to this list,
> you can check pfn of page on this list and determine appropriate capture
> candidate page. This approach can give us more flexibility for
> choosing capture candidate without adding more complexity to
> common function. For example, you can choose capture candidate if
> there are XX isolated pages in certain range.

Hm I see. But the logic added by page capture was also a prerequisity 
for the "[RFC PATCH V4 15/15] mm, compaction: do not migrate pages when 
that cannot satisfy page fault allocation"
http://marc.info/?l=linux-mm&m=140551859423716&w=2

And that could be hardly done by a post-isolation inspection of the 
migratepages list. And I haven't given up on that idea yet :)

>>> In __isolate_free_page(), we check zone_watermark_ok() with order 0.
>>> But normal allocation logic would check zone_watermark_ok() with requested
>>> order. Your capture logic uses __isolate_free_page() and it would
>>> affect compaction success rate significantly. And it means that
>>> capture logic allocates high order page on page allocator
>>> too aggressively compared to other component such as normal high order
>>
>> It's either that, or the extra lru drain that makes the different.
>> But the "aggressiveness" would in fact mean better accuracy.
>> Watermark checking may be inaccurate. Especially when memory is
>> close to the watermark and there is only a single high-order page
>> that would satisfy the allocation.
>
> If this "aggressiveness" means better accuracy, fixing general
> function, watermark_ok() is better than adding capture logic.

That's if fixing the function wouldn't add significant overhead to all 
the callers. And making it non-racy and not prone to per-cpu counter 
drifts would certainly do that :(

> But, I guess that there is a reason that watermark_ok() is so
> conservative. If page allocator aggressively provides high order page,
> future atomic high order page request cannot succeed easily. For
> preventing this situation, watermark_ok() should be conservative.

I don't think it's intentionally conservative, just unreliable. It tests 
two things together:

1) are there enough free pages for the allocation wrt watermarks?
2) does it look like that there is a free page of the requested order?

The 1) works fine and my patch won't change that by passing a order=0. 
The problem is with 2) which is unreliable, especially when close to the 
watermarks. Note that it's not trying to keep some reserves for atomic 
requests. That's what MIGRATE_RESERVE is for. It's just unreliable to 
decide if there is the high-order page available. Even though its 
allocation would preserve the watermarks, so there is no good reason to 
prevent the allocation. So it will often pass when deciding to stop 
compaction, and then fail when allocating.

> Thanks.
>

