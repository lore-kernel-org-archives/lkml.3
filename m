Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaKZVlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:41:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaKZVlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:41:21 -0500
Date: Wed, 26 Nov 2014 13:41:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: vmscan: invoke slab shrinkers from shrink_zone()
Message-Id: <20141126134120.7d25e5d062f423a9c082e557@linux-foundation.org>
In-Reply-To: <1416939830-20289-1-git-send-email-hannes@cmpxchg.org>
References: <1416939830-20289-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 13:23:50 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> The slab shrinkers are currently invoked from the zonelist walkers in
> kswapd, direct reclaim, and zone reclaim, all of which roughly gauge
> the eligible LRU pages and assemble a nodemask to pass to NUMA-aware
> shrinkers, which then again have to walk over the nodemask.  This is
> redundant code, extra runtime work, and fairly inaccurate when it
> comes to the estimation of actually scannable LRU pages.  The code
> duplication will only get worse when making the shrinkers cgroup-aware
> and requiring them to have out-of-band cgroup hierarchy walks as well.
> 
> Instead, invoke the shrinkers from shrink_zone(), which is where all
> reclaimers end up, to avoid this duplication.
> 
> Take the count for eligible LRU pages out of get_scan_count(), which
> considers many more factors than just the availability of swap space,
> like zone_reclaimable_pages() currently does.  Accumulate the number
> over all visited lruvecs to get the per-zone value.
> 
> Some nodes have multiple zones due to memory addressing restrictions.
> To avoid putting too much pressure on the shrinkers, only invoke them
> once for each such node, using the class zone of the allocation as the
> pivot zone.
> 
> For now, this integrates the slab shrinking better into the reclaim
> logic and gets rid of duplicative invocations from kswapd, direct
> reclaim, and zone reclaim.  It also prepares for cgroup-awareness,
> allowing memcg-capable shrinkers to be added at the lruvec level
> without much duplication of both code and runtime work.
> 
> This changes kswapd behavior, which used to invoke the shrinkers for
> each zone, but with scan ratios gathered from the entire node,
> resulting in meaningless pressure quantities on multi-zone nodes.

It's a troublesome patch - we've been poking at this code for years and
now it gets significantly upended.  It all *seems* sensible, but any
warts will take time to identify.

> Zone reclaim behavior also changes.  It used to shrink slabs until the
> same amount of pages were shrunk as were reclaimed from the LRUs.  Now
> it merely invokes the shrinkers once with the zone's scan ratio, which
> makes the shrinkers go easier on caches that implement aging and would
> prefer feeding back pressure from recently used slab objects to unused
> LRU pages.

hm, "go easier on caches" means it changes reclaim balancing.  Is the
result better or worse?


