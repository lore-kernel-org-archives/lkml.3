Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaFZKRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:17:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaFZKRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:17:33 -0400
Date: Thu, 26 Jun 2014 11:17:20 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] mm: vmscan: Do not reclaim from lower zones if they
 are balanced
Message-ID: <20140626101720.GF10819@suse.de>
References: <1403683129-10814-1-git-send-email-mgorman@suse.de>
 <1403683129-10814-4-git-send-email-mgorman@suse.de>
 <20140625163250.354f12cd0fa5ff16e32056bf@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140625163250.354f12cd0fa5ff16e32056bf@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 04:32:50PM -0700, Andrew Morton wrote:
> On Wed, 25 Jun 2014 08:58:46 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > Historically kswapd scanned from DMA->Movable in the opposite direction
> > to the page allocator to avoid allocating behind kswapd direction of
> > progress. The fair zone allocation policy altered this in a non-obvious
> > manner.
> > 
> > Traditionally, the page allocator prefers to use the highest eligible zone
> > until the watermark is depleted, woke kswapd and moved onto the next zone.
> > kswapd scans zones in the opposite direction so the scanning lists on
> > 64-bit look like this;
> > 
> > ...
> >
> > Note that this patch makes a large performance difference for lower
> > numbers of threads and brings performance closer to 3.0 figures. It was
> > also tested against xfs and there are similar gains although I don't have
> > 3.0 figures to compare against. There are still regressions for higher
> > number of threads but this is related to changes in the CFQ IO scheduler.
> > 
> 
> Why did this patch make a difference to sequential read performance? 
> IOW, by what means was/is reclaim interfering with sequential reads?
> 

The fair zone allocator is interleaving between Normal/DMA32. Kswapd is
reclaiming from DMA->Highest where Highest is an unbalanced zone. Kswapd
will reclaim from DMA32 even if it is balanced if Normal is below watermarks.

Let N = high_wmark(Normal) + high_wmark(DMA32)

Of the last N allocations, some percentage will be allocated from Normal
and some from DMA32. The percentage depends on the ratio of the zone sizes
and when their watermarks were hit. If Normal is unbalanced, DMA32 will be
shrunk by kswapd. If DMA32 is unbalanced only DMA32 will be shrunk. This
leads to a difference of ages between DMA32 and Normal. Relatively young
pages are then continually rotated and reclaimed from DMA32 due to the
higher zone being unbalanced.

A debugging patch showed that some PageReadahead pages are reaching the
end of the LRU. The number is not very high but it's there. Monitoring
of nr_free_pages on a per-zone basis show that there is constant reclaim
of the lower zones even when the watermarks should be ok. The iostats
showed that without the page there are more pages being read.

I believe the difference in sequential read performance is because relatively
young pages recently readahead are being reclaimed from the lower zones.

-- 
Mel Gorman
SUSE Labs
