Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaEVJYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:24:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbaEVJY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:24:27 -0400
Message-ID: <537DC247.5020801@suse.cz>
Date: Thu, 22 May 2014 11:24:23 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 09/19] mm: page_alloc: Use word-based accesses for get/set
 pageblock bitmaps
References: <1399974350-11089-1-git-send-email-mgorman@suse.de> <1399974350-11089-10-git-send-email-mgorman@suse.de>
In-Reply-To: <1399974350-11089-10-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 11:45 AM, Mel Gorman wrote:
> The test_bit operations in get/set pageblock flags are expensive. This patch
> reads the bitmap on a word basis and use shifts and masks to isolate the bits
> of interest. Similarly masks are used to set a local copy of the bitmap and then
> use cmpxchg to update the bitmap if there have been no other changes made in
> parallel.
> 
> In a test running dd onto tmpfs the overhead of the pageblock-related
> functions went from 1.27% in profiles to 0.5%.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Hi, I've tested if this closes the race I've been previously trying to fix
with the series in http://marc.info/?l=linux-mm&m=139359694028925&w=2
And indeed with this patch I wasn't able to reproduce it in my stress test
(which adds lots of memory isolation calls) anymore. So thanks to Mel I can
dump my series in the trashcan :P

Therefore I believe something like below should be added to the changelog,
and put to stable as well.

Thanks,
Vlastimil

-----8<-----
In addition to the performance benefits, this patch closes races that are
possible between:

a) get_ and set_pageblock_migratetype(), where get_pageblock_migratetype()
   reads part of the bits before and other part of the bits after
   set_pageblock_migratetype() has updated them.

b) set_pageblock_migratetype() and set_pageblock_skip(), where the non-atomic
   read-modify-update set bit operation in set_pageblock_skip() will cause
   lost updates to some bits changed in the set_pageblock_migratetype().

Joonsoo Kim first reported the case a) via code inspection. Vlastimil Babka's
testing with a debug patch showed that either a) or b) occurs roughly once per
mmtests' stress-highalloc benchmark (although not necessarily in the same
pageblock). Furthermore during development of unrelated compaction patches,
it was observed that frequent calls to {start,undo}_isolate_page_range() the
race occurs several thousands of times and has resulted in NULL pointer
dereferences in move_freepages() and free_one_page() in places where
free_list[migratetype] is manipulated by e.g. list_move(). Further debugging
confirmed that migratetype had invalid value of 6, causing out of bounds access
to the free_list array. 

That confirmed that the race exist, although it may be extremely rare, and
currently only fatal where page isolation is performed due to memory hot remove.
Races on pageblocks being updated by set_pageblock_migratetype(), where both
old and new migratetype are lower MIGRATE_RESERVE, currently cannot result in an
invalid value being observed, although theoretically they may still lead to
unexpected creation or destruction of MIGRATE_RESERVE pageblocks. Furthermore,
things could get suddenly worse when memory isolation is used more, or when new
migratetypes are added.

After this patch, the race has no longer been observed in testing.

Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-and-tested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>

