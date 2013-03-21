Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab3CUP6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:58:05 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:41717 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab3CUP6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:58:03 -0400
Date: Thu, 21 Mar 2013 11:57:05 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        dormando <dormando@rydia.net>, Satoru Moriya <satoru.moriya@hds.com>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd
 reclaims at each priority
Message-ID: <20130321155705.GA27848@cmpxchg.org>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363525456-10448-2-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 01:04:07PM +0000, Mel Gorman wrote:
> The number of pages kswapd can reclaim is bound by the number of pages it
> scans which is related to the size of the zone and the scanning priority. In
> many cases the priority remains low because it's reset every SWAP_CLUSTER_MAX
> reclaimed pages but in the event kswapd scans a large number of pages it
> cannot reclaim, it will raise the priority and potentially discard a large
> percentage of the zone as sc->nr_to_reclaim is ULONG_MAX. The user-visible
> effect is a reclaim "spike" where a large percentage of memory is suddenly
> freed. It would be bad enough if this was just unused memory but because
> of how anon/file pages are balanced it is possible that applications get
> pushed to swap unnecessarily.
> 
> This patch limits the number of pages kswapd will reclaim to the high
> watermark. Reclaim will will overshoot due to it not being a hard limit as

will -> still?

> shrink_lruvec() will ignore the sc.nr_to_reclaim at DEF_PRIORITY but it
> prevents kswapd reclaiming the world at higher priorities. The number of
> pages it reclaims is not adjusted for high-order allocations as kswapd will
> reclaim excessively if it is to balance zones for high-order allocations.

I don't really understand this last sentence.  Is the excessive
reclaim a result of the patch, a description of what's happening
now...?

> Signed-off-by: Mel Gorman <mgorman@suse.de>

Nice, thank you.  Using the high watermark for larger zones is more
reasonable than my hack that just always went with SWAP_CLUSTER_MAX,
what with inter-zone LRU cycle time balancing and all.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
