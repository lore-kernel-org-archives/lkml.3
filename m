Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbaCTWMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:12:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932AbaCTWMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:12:00 -0400
Date: Thu, 20 Mar 2014 15:11:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: page_alloc: spill to remote nodes before waking
 kswapd
Message-Id: <20140320151158.e5cec93960cd0cd00f5b3790@linux-foundation.org>
In-Reply-To: <1395348816-4733-1-git-send-email-hannes@cmpxchg.org>
References: <1395348816-4733-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 16:53:36 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

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

I queued this for 3.15-rc1 so it should get backported into 3.14.1 and
earlier.

It doesn't come close to applying to 3.13 or 3.12 so please check into
what needs doing when Greg comes calling.

