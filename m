Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaG3OTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:19:16 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:52631 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaG3OTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <53D8C16B.7070206@suse.cz>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
	<1406553101-29326-15-git-send-email-vbabka@suse.cz>
	<20140729073456.GC1610@js1304-P5Q-DELUXE>
	<53D7BF0D.5050404@suse.cz>
	<20140730083920.GA24427@js1304-P5Q-DELUXE>
	<53D8C16B.7070206@suse.cz>
Date: Wed, 30 Jul 2014 23:19:10 +0900
Message-ID: <CAAmzW4N28-6W1-K5xHHGOzYEFtFkXOzeP35iC-VdQCP-EOtANA@mail.gmail.com>
Subject: Re: [PATCH v5 14/14] mm, compaction: try to capture the just-created
 high-order freepage
From: Joonsoo Kim <js1304@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops... resend because of omitting everyone on CC.

2014-07-30 18:56 GMT+09:00 Vlastimil Babka <vbabka@suse.cz>:
> On 07/30/2014 10:39 AM, Joonsoo Kim wrote:
>>
>> On Tue, Jul 29, 2014 at 05:34:37PM +0200, Vlastimil Babka wrote:
>>>
>>> Could do it in isolate_migratepages() for whole pageblocks only (as
>>> David's patch did), but that restricts the usefulness. Or maybe do
>>> it fine grained by calling isolate_migratepages_block() multiple
>>> times. But the overhead of multiple calls would probably suck even
>>> more for lower-order compactions. For CMA the added overhead is
>>> basically only checks for next_capture_pfn that will be always
>>> false, so predictable. And mostly just in branches where isolation
>>> is failing, which is not the CMA's "fast path" I guess?
>>
>>
>> You can do it find grained with compact_control's migratepages list
>> or new private list. If some pages are isolated and added to this list,
>> you can check pfn of page on this list and determine appropriate capture
>> candidate page. This approach can give us more flexibility for
>> choosing capture candidate without adding more complexity to
>> common function. For example, you can choose capture candidate if
>> there are XX isolated pages in certain range.
>
>
> Hm I see. But the logic added by page capture was also a prerequisity for
> the "[RFC PATCH V4 15/15] mm, compaction: do not migrate pages when that
> cannot satisfy page fault allocation"
> http://marc.info/?l=linux-mm&m=140551859423716&w=2
>
> And that could be hardly done by a post-isolation inspection of the
> migratepages list. And I haven't given up on that idea yet :)

Okay. I didn't look at that patch yet. I will try later :)

>
>>>> In __isolate_free_page(), we check zone_watermark_ok() with order 0.
>>>> But normal allocation logic would check zone_watermark_ok() with
>>>> requested
>>>> order. Your capture logic uses __isolate_free_page() and it would
>>>> affect compaction success rate significantly. And it means that
>>>> capture logic allocates high order page on page allocator
>>>> too aggressively compared to other component such as normal high order
>>>
>>>
>>> It's either that, or the extra lru drain that makes the different.
>>> But the "aggressiveness" would in fact mean better accuracy.
>>> Watermark checking may be inaccurate. Especially when memory is
>>> close to the watermark and there is only a single high-order page
>>> that would satisfy the allocation.
>>
>>
>> If this "aggressiveness" means better accuracy, fixing general
>> function, watermark_ok() is better than adding capture logic.
>
>
> That's if fixing the function wouldn't add significant overhead to all the
> callers. And making it non-racy and not prone to per-cpu counter drifts
> would certainly do that :(
>
>
>> But, I guess that there is a reason that watermark_ok() is so
>> conservative. If page allocator aggressively provides high order page,
>> future atomic high order page request cannot succeed easily. For
>> preventing this situation, watermark_ok() should be conservative.
>
>
> I don't think it's intentionally conservative, just unreliable. It tests two
> things together:
>
> 1) are there enough free pages for the allocation wrt watermarks?
> 2) does it look like that there is a free page of the requested order?

I don't think that watermark_ok()'s intention is checking if there is a free
page of the requested order. If we want to know it, we could use more
easy way something like below.

X = number of total freepage - number of freepage lower than requested order
If X is positive, we can conclude that there is at least one freepage
of requested order and this equation is easy to compute.

But, watermark_ok() doesn't do that. Instead, it uses mark value to determine
if we can go further. I guess that this means that allocation/reclaim logic want
to preserve certain level of high order freepages according to system memory
size, although I don't know what the reason is exactly. So
the "aggressiveness" on capture logic here could break what
allocation/reclaim want.

Thanks.
