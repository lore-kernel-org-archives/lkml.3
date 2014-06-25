Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbaFYPrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:47:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbaFYPrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:47:14 -0400
Date: Wed, 25 Jun 2014 11:46:50 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/13] mm, compaction: move pageblock checks up from
 isolate_migratepages_range()
Message-ID: <20140625154650.GA21235@nhori.bos.redhat.com>
References: <1403279383-5862-1-git-send-email-vbabka@suse.cz>
 <1403279383-5862-5-git-send-email-vbabka@suse.cz>
 <20140624045252.GA18289@nhori.bos.redhat.com>
 <53A99A88.1040500@suse.cz>
 <20140624165821.GC18289@nhori.bos.redhat.com>
 <53AA8D6B.6090301@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA8D6B.6090301@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:50:51AM +0200, Vlastimil Babka wrote:
> On 06/24/2014 06:58 PM, Naoya Horiguchi wrote:
> >On Tue, Jun 24, 2014 at 05:34:32PM +0200, Vlastimil Babka wrote:
> >>On 06/24/2014 06:52 AM, Naoya Horiguchi wrote:
> >>>>-	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn, false);
> >>>>-	if (!low_pfn || cc->contended)
> >>>>-		return ISOLATE_ABORT;
> >>>>+		/* Do not scan within a memory hole */
> >>>>+		if (!pfn_valid(low_pfn))
> >>>>+			continue;
> >>>>+
> >>>>+		page = pfn_to_page(low_pfn);
> >>>
> >>>Can we move (page_zone != zone) check here as isolate_freepages() does?
> >>
> >>Duplicate perhaps, not sure about move.
> >
> >Sorry for my unclearness.
> >I meant that we had better do this check in per-pageblock loop (as the free
> >scanner does) instead of in per-pfn loop (as we do now.)
> 
> Hm I see, the migration and free scanners really do this differently. Free
> scanned per-pageblock, but migration scanner per-page.
> Can we assume that zones will never overlap within a single pageblock?

Maybe not, we have no such assumption.

> The example dc9086004 seems to be overlapping at even higher alignment so it
> should be safe only to check first page in pageblock.
> And if it wasn't the case, then I guess the freepage scanner would already
> hit some errors on such system?

That's right. Such system might be rare so nobody detected it, I guess.
So I was wrong, and page_zone check should be done in per-pfn loop in
both scanner?

I just think that it might be good if we have an iterator to run over
pfns only on a given zone (not that check page zone on each page,)
but it introduces some more complexity on the scanners, so at this time
we don't have to do it in this series.

> But if that's true, why does page_is_buddy test if pages are in the same
> zone?

Yeah, this is why we think we can't have the above mentioned assumption.

Thanks,
Naoya Horiguchi
