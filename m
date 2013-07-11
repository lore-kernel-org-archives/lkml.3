Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3GKFiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 01:38:23 -0400
Received: from www.sr71.net ([198.145.64.142]:33342 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab3GKFiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 01:38:22 -0400
Message-ID: <51DE44CC.2070700@sr71.net>
Date: Wed, 10 Jul 2013 22:38:20 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] mm, page_alloc: support multiple pages allocation
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com> <1372840460-5571-2-git-send-email-iamjoonsoo.kim@lge.com> <51DDE5BA.9020800@intel.com> <20130711010248.GB7756@lge.com>
In-Reply-To: <20130711010248.GB7756@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 06:02 PM, Joonsoo Kim wrote:
> On Wed, Jul 10, 2013 at 03:52:42PM -0700, Dave Hansen wrote:
>> On 07/03/2013 01:34 AM, Joonsoo Kim wrote:
>>> -		if (page)
>>> +		do {
>>> +			page = buffered_rmqueue(preferred_zone, zone, order,
>>> +							gfp_mask, migratetype);
>>> +			if (!page)
>>> +				break;
>>> +
>>> +			if (!nr_pages) {
>>> +				count++;
>>> +				break;
>>> +			}
>>> +
>>> +			pages[count++] = page;
>>> +			if (count >= *nr_pages)
>>> +				break;
>>> +
>>> +			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
>>> +			if (!zone_watermark_ok(zone, order, mark,
>>> +					classzone_idx, alloc_flags))
>>> +				break;
>>> +		} while (1);
>>
>> I'm really surprised this works as well as it does.  Calling
>> buffered_rmqueue() a bunch of times enables/disables interrupts a bunch
>> of times, and mucks with the percpu pages lists a whole bunch.
>> buffered_rmqueue() is really meant for _single_ pages, not to be called
>> a bunch of times in a row.
>>
>> Why not just do a single rmqueue_bulk() call?
> 
> rmqueue_bulk() needs a zone lock. If we allocate not so many pages,
> for example, 2 or 3 pages, it can have much more overhead rather than
> allocationg 1 page multiple times. So, IMHO, it is better that
> multiple pages allocation is supported on top of percpu pages list.

It makes _zero_ sense to be doing a number of buffered_rmqueue() calls
that are approaching the size of the percpu pages batches.  If you end
up doing that, you pay both the overhead in manipulating both the percpu
page data _and_ the buddy lists.

You're probably right for small numbers of pages.  But, if we're talking
about things that are more than, say, 100 pages (isn't the pcp batch
size clamped to 128 4k pages?) you surely don't want to be doing
buffered_rmqueue().

I'd also like to see some scalability numbers on this.  How do your
tests look when all the CPUs on the system are hammering away?

> And I think that enables/disables interrupts a bunch of times help
> to avoid a latency problem. If we disable interrupts until the whole works
> is finished, interrupts can be handled too lately.
> free_hot_cold_page_list() already do enables/disalbed interrupts a bunch of
> times.

I don't think interrupt latency is going to be a problem on the scale
we're talking about here.  There are much, much, much worse offenders in
the kernel.

