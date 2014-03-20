Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939AbaCTVQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933436AbaCTVQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:16:24 -0400
Message-ID: <532B5A39.7050309@redhat.com>
Date: Thu, 20 Mar 2014 17:14:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: page_alloc: spill to remote nodes before waking kswapd
References: <1395348816-4733-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1395348816-4733-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 04:53 PM, Johannes Weiner wrote:
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

Acked-by: Rik van Riel <riel@redhat.com>

