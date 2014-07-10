Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaGJMGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:06:20 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52926 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaGJMGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:06:19 -0400
Date: Thu, 10 Jul 2014 08:06:15 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm: Rearrange zone fields into read-only, page
 alloc, statistics and page reclaim lines
Message-ID: <20140710120615.GJ29639@cmpxchg.org>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
 <1404893588-21371-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404893588-21371-3-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:13:04AM +0100, Mel Gorman wrote:
> The arrangement of struct zone has changed over time and now it has reached the
> point where there is some inappropriate sharing going on. On x86-64 for example
> 
> o The zone->node field is shared with the zone lock and zone->node is accessed
>   frequently from the page allocator due to the fair zone allocation policy.
> o span_seqlock is almost never used by shares a line with free_area
> o Some zone statistics share a cache line with the LRU lock so reclaim-intensive
>   and allocator-intensive workloads can bounce the cache line on a stat update
> 
> This patch rearranges struct zone to put read-only and read-mostly fields
> together and then splits the page allocator intensive fields, the zone
> statistics and the page reclaim intensive fields into their own cache
> lines. Note that the type of lowmem_reserve changes due to the watermark
> calculations being signed and avoiding a signed/unsigned conversion there.
> 
> On the test configuration I used the overall size of struct zone shrunk
> by one cache line. On smaller machines, this is not likely to be noticable.
> However, on a 4-node NUMA machine running tiobench the system CPU overhead
> is reduced by this patch.
> 
>           3.16.0-rc3  3.16.0-rc3
>              vanillarearrange-v5r9
> User          746.94      759.78
> System      65336.22    58350.98
> Elapsed     27553.52    27282.02
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
