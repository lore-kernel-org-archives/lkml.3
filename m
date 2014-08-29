Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaH2NJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:09:42 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59678 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbaH2NJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:09:40 -0400
Date: Fri, 29 Aug 2014 09:09:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Mel Gorman'" <mgorman@suse.de>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Rik van Riel'" <riel@redhat.com>, rientjes@google.com,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: page_alloc: avoid wakeup kswapd on the unintended
 node
Message-ID: <20140829130925.GA9900@cmpxchg.org>
References: <000001cfc357$74db64a0$5e922de0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cfc357$74db64a0$5e922de0$%yang@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 03:03:19PM +0800, Weijie Yang wrote:
> When enter page_alloc slowpath, we wakeup kswapd on every pgdat
> according to the zonelist and high_zoneidx. However, this doesn't
> take nodemask into account, and could prematurely wakeup kswapd on
> some unintended nodes.
> 
> This patch uses for_each_zone_zonelist_nodemask() instead of
> for_each_zone_zonelist() in wake_all_kswapds() to avoid the above situation.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Wow, we have never respected nodemask when waking kswapd, but your
change does make sense to me.

As far as impact go, this has the chance of reducing reclaim/swapping
for certain configurations.  Higher-order wakeups on an ineligible
zone are more obviously undesirable, but even order-0 rebalancing is
not necessarily a future investment for other allocations on that
node, as other allocations may have access to the free pages of a
third node and overall demand might drop before these are exhausted.
This reminds me of the issue fixed in 3a025760fc15 ("mm: page_alloc:
spill to remote nodes before waking kswapd"), where accidental eager
order-0 rebalancing turned out to be a true waste.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
