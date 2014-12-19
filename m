Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaLSP5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:57:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaLSP5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:57:50 -0500
Date: Fri, 19 Dec 2014 16:57:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm, vmscan: prevent kswapd livelock due to
 pfmemalloc-throttled process being killed
Message-ID: <20141219155747.GA31756@dhcp22.suse.cz>
References: <1418994116-23665-1-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418994116-23665-1-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 19-12-14 14:01:55, Vlastimil Babka wrote:
> Charles Shirron and Paul Cassella from Cray Inc have reported kswapd stuck
> in a busy loop with nothing left to balance, but kswapd_try_to_sleep() failing
> to sleep. Their analysis found the cause to be a combination of several
> factors:
> 
> 1. A process is waiting in throttle_direct_reclaim() on pgdat->pfmemalloc_wait
> 
> 2. The process has been killed (by OOM in this case), but has not yet been
>    scheduled to remove itself from the waitqueue and die.

pfmemalloc_wait is used as wait_event and that one uses
autoremove_wake_function for wake ups so the task shouldn't stay on the
queue if it was woken up. Moreover pfmemalloc_wait sleeps are killable
by the OOM killer AFAICS.

$ git grep "wait_event.*pfmemalloc_wait"
mm/vmscan.c:
wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
mm/vmscan.c:    wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,))

So OOM killer would wake it up already and kswapd shouldn't see this
task on the waitqueue anymore.
-- 
Michal Hocko
SUSE Labs
