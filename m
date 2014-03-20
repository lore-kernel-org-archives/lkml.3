Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853AbaCTVeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:34:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328AbaCTVeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:34:07 -0400
Date: Thu, 20 Mar 2014 21:33:58 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: page_alloc: spill to remote nodes before waking
 kswapd
Message-ID: <20140320213358.GO25087@suse.de>
References: <1395348816-4733-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1395348816-4733-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 04:53:36PM -0400, Johannes Weiner wrote:
> On NUMA systems, a node may start thrashing cache or even swap
> anonymous pages while there are still free pages on remote nodes.
> 
> This is a result of 81c0a2bb515f ("mm: page_alloc: fair zone allocator
> policy") and fff4068cba48 ("mm: page_alloc: revert NUMA aspect of fair
> allocation policy").  Before those changes, the allocator would first
> try all allowed zones, including those on remote nodes, before waking
> any kswapds.  But now, the allocator fastpath doubles as the fairness
> pass, which in turn can only consider the local node to prevent remote
> spilling based on exhausted fairness batches alone.  Remote nodes are
> only considered in the slowpath, after the kswapds are woken up.  But
> if remote nodes still have free memory, kswapd should not be woken to
> rebalance the local node or it may thrash cash or swap prematurely.
> 
> Fix this by adding one more unfair pass over the zonelist that is
> allowed to spill to remote nodes after the local fairness pass fails
> but before entering the slowpath and waking the kswapds.
> 
> This also gets rid of the GFP_THISNODE exemption from the fairness
> protocol because the unfair pass is no longer tied to kswapd, which
> GFP_THISNODE is not allowed to wake up.
> 
> However, because remote spills can be more frequent now - we prefer
> them over local kswapd reclaim - the allocation batches on remote
> nodes could underflow more heavily.  When resetting the batches, use
> atomic_long_read() directly instead of zone_page_state() to calculate
> the delta as the latter filters negative counter values.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@kernel.org> [3.12+]

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
