Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaAOC6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:58:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31743 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOC6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:58:39 -0500
Message-ID: <52D5F911.1090507@oracle.com>
Date: Wed, 15 Jan 2014 10:57:21 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/9] mm: thrash detection-based file cache sizing
References: <1389377443-11755-1-git-send-email-hannes@cmpxchg.org> <1389377443-11755-8-git-send-email-hannes@cmpxchg.org> <52D48C55.3020200@oracle.com> <20140114191619.GI6963@cmpxchg.org>
In-Reply-To: <20140114191619.GI6963@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/15/2014 03:16 AM, Johannes Weiner wrote:
> On Tue, Jan 14, 2014 at 09:01:09AM +0800, Bob Liu wrote:
>> Hi Johannes,
>>
>> On 01/11/2014 02:10 AM, Johannes Weiner wrote:
>>> The VM maintains cached filesystem pages on two types of lists.  One
>>> list holds the pages recently faulted into the cache, the other list
>>> holds pages that have been referenced repeatedly on that first list.
>>> The idea is to prefer reclaiming young pages over those that have
>>> shown to benefit from caching in the past.  We call the recently used
>>> list "inactive list" and the frequently used list "active list".
>>>
>>> Currently, the VM aims for a 1:1 ratio between the lists, which is the
>>> "perfect" trade-off between the ability to *protect* frequently used
>>> pages and the ability to *detect* frequently used pages.  This means
>>> that working set changes bigger than half of cache memory go
>>> undetected and thrash indefinitely, whereas working sets bigger than
>>> half of cache memory are unprotected against used-once streams that
>>> don't even need caching.
>>>
>>
>> Good job! This patch looks good to me and with nice descriptions.
>> But it seems that this patch only fix the issue "working set changes
>> bigger than half of cache memory go undetected and thrash indefinitely".
>> My concern is could it be extended easily to address all other issues
>> based on this patch set?
>>
>> The other possible way is something like Peter has implemented the CART
>> and Clock-Pro which I think may be better because of using advanced
>> algorithms and consider the problem as a whole from the beginning.(Sorry
>> I haven't get enough time to read the source code, so I'm not 100% sure.)
>> http://linux-mm.org/PeterZClockPro2
> 
> My patches are moving the VM towards something that is comparable to
> how Peter implemented Clock-Pro.  However, the current VM has evolved
> over time in small increments based on real life performance
> observations.  Rewriting everything in one go would be incredibly
> disruptive and I doubt very much we would merge any such proposal in
> the first place.  So it's not like I don't see the big picture, it's
> just divide and conquer:
> 
> Peter's Clock-Pro implementation was basically a double clock with an
> intricate system to classify hotness, augmented by eviction
> information to work with reuse distances independent of memory size.
> 
> What we have right now is a double clock with a very rudimentary
> system to classify whether a page is hot: it has been accessed twice
> while on the inactive clock.  My patches now add eviction information
> to this, and improve the classification so that it can work with reuse
> distances up to memory size and is no longer dependent on the inactive
> clock size.
> 
> This is the smallest imaginable step that is still useful, and even
> then we had a lot of discussions about scalability of the data
> structures and confusion about how the new data point should be
> interpreted.  It also took a long time until somebody read the series
> and went, "Ok, this actually makes sense to me."  Now, maybe I suck at
> documenting, but maybe this is just complicated stuff.  Either way, we
> have to get there collectively, so that the code is maintainable in
> the long term.
> 
> Once we have these new concepts established, we can further improve
> the hotness detector so that it can classify and order pages with
> reuse distances beyond memory size.  But this will come with its own
> set of problems.  For example, some time ago we stopped regularly
> scanning and rotating active pages because of scalability issues, but
> we'll most likely need an uptodate estimate of the reuse distances on
> the active list in order to classify refaults properly.
> 

Thank you for your kindly explanation. It make sense to me please feel
free to add my review.

>>> + * Approximating inactive page access frequency - Observations:
>>> + *
>>> + * 1. When a page is accessed for the first time, it is added to the
>>> + *    head of the inactive list, slides every existing inactive page
>>> + *    towards the tail by one slot, and pushes the current tail page
>>> + *    out of memory.
>>> + *
>>> + * 2. When a page is accessed for the second time, it is promoted to
>>> + *    the active list, shrinking the inactive list by one slot.  This
>>> + *    also slides all inactive pages that were faulted into the cache
>>> + *    more recently than the activated page towards the tail of the
>>> + *    inactive list.
>>> + *
>>
>> Nitpick, how about the reference bit?
> 
> What do you mean?
> 

Sorry, I mean the PG_referenced flag. I thought when a page is accessed
for the second time only PG_referenced flag  will be set instead of be
promoted to active list.

-- 
Regards,
-Bob
