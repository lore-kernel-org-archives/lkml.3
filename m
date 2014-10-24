Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbaJXC7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:59:06 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55965 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJXC7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:59:03 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 24 Oct 2014 12:00:07 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cl@linux.com,
        mgorman@suse.de, mina86@mina86.com, minchan@kernel.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com,
        zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org
Subject: Re: +
 mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
 added to -mm tree
Message-ID: <20141024030006.GC15243@js1304-P5Q-DELUXE>
References: <543d8d58.g9K7YpzF5ZOXeQqj%akpm@linux-foundation.org>
 <20141023081543.GB7598@js1304-P5Q-DELUXE>
 <5448BED1.40909@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5448BED1.40909@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:39:45AM +0200, Vlastimil Babka wrote:
> On 10/23/2014 10:15 AM, Joonsoo Kim wrote:
> > On Tue, Oct 14, 2014 at 01:53:44PM -0700, akpm@linux-foundation.org wrote:
> >>
> >> The patch titled
> >>      Subject: mm/compaction.c: avoid premature range skip in isolate_migratepages_range
> >> has been added to the -mm tree.  Its filename is
> >>      mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
> >>
> >> This patch should soon appear at
> >>     http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
> >> and later at
> >>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
> >>
> >> Before you just go and hit "reply", please:
> >>    a) Consider who else should be cc'ed
> >>    b) Prefer to cc a suitable mailing list as well
> >>    c) Ideally: find the original patch on the mailing list and do a
> >>       reply-to-all to that, adding suitable additional cc's
> >>
> >> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> >>
> >> The -mm tree is included into linux-next and is updated
> >> there every 3-4 working days
> >>
> >> ------------------------------------------------------
> >> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >> Subject: mm/compaction.c: avoid premature range skip in isolate_migratepages_range
> >>
> >> commit edc2ca612496 ("mm, compaction: move pageblock checks up from
> >> isolate_migratepages_range()") commonizes isolate_migratepages variants
> >> and make them use isolate_migratepages_block().
> >>
> >> isolate_migratepages_block() could stop the execution when enough pages
> >> are isolated, but, there is no code in isolate_migratepages_range() to
> >> handle this case.  In the result, even if isolate_migratepages_block()
> >> returns prematurely without checking all pages in the range,
> >>
> >> isolate_migratepages_block() is called repeately on the following
> >> pageblock and some pages in the previous range are skipped to check.
> >> Then, CMA is failed frequently due to this fact.
> >>
> >> To fix this problem, this patch let isolate_migratepages_range() know the
> >> situation that enough pages are isolated and stop the isolation in that
> >> case.
> >>
> >> Note that isolate_migratepages() has no such problem, because, it always
> >> stops the isolation after just one call of isolate_migratepages_block().
> >>
> >> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: David Rientjes <rientjes@google.com>
> >> Cc: Minchan Kim <minchan@kernel.org>
> >> Cc: Michal Nazarewicz <mina86@mina86.com>
> >> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> >> Cc: Christoph Lameter <cl@linux.com>
> >> Cc: Rik van Riel <riel@redhat.com>
> >> Cc: Mel Gorman <mgorman@suse.de>
> >> Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Sorry for the trouble. But I think a more robust and future-proof fix
> would be a check such as: if (pfn < block_end_pfn) break;
> This should catch any reason where isolate_migratepages_block() did not
> finish whole pageblock, and which was not fatal enough to return pfn==0.
> However currently this seems to happen only due to isolating too much,
> so your patch should work.
> So it's up to you if you want to make the check more generic now, or
> later after this bug is fixed for 3.18.

'if (pfn < block_end_pfn) break;' has one problem.
If we have enough isolated pages and reach at block_end_pfn,
we can't stop with above check.

More proper check may be as following.
'if (pfn < block_end_pfn ||
cc->nr_migratepages == COMPACT_CLUSTER_MAX) break;'
But, as you mentioned, there is no case where 'pfn < block_end_pfn'
now, so I'd like to remain the patch as is.

Thanks.
