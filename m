Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3KUQka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:40:30 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:38733 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KUQk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:40:28 -0500
Date: Thu, 21 Nov 2013 11:40:19 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, vmscan: abort futile reclaim if we've been oom killed
Message-ID: <20131121164019.GK3556@cmpxchg.org>
References: <alpine.DEB.2.02.1311121801200.18803@chino.kir.corp.google.com>
 <20131113152412.GH707@cmpxchg.org>
 <alpine.DEB.2.02.1311131400300.23211@chino.kir.corp.google.com>
 <20131114000043.GK707@cmpxchg.org>
 <alpine.DEB.2.02.1311131639010.6735@chino.kir.corp.google.com>
 <20131118164107.GC3556@cmpxchg.org>
 <alpine.DEB.2.02.1311181712080.4292@chino.kir.corp.google.com>
 <20131120160712.GF3556@cmpxchg.org>
 <alpine.DEB.2.02.1311201803000.30862@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311201803000.30862@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 07:08:50PM -0800, David Rientjes wrote:
> My patch is not in a fastpath, it has extremely minimal overhead, and it 
> allows an oom killed victim to exit much quicker instead of incurring 
> O(seconds) stalls because of 700 other allocators grabbing the cpu in a 
> futile effort to reclaim memory themselves.
> 
> Andrew, this fixes a real-world issue that exists and I'm asking that it 
> be merged so that oom killed processes can quickly allocate and exit to 
> free its memory.  If a more invasive future patch causes it to no longer 
> be necessary, that's what we call kernel development.  Thanks.

All I'm trying to do is find the broader root cause for the problem
you are experiencing and find a solution that will leave us with
maintainable code.  It does not matter how few instructions your fix
adds, it changes the outcome of the algorithm and makes every
developer trying to grasp the complexity of page reclaim think about
yet another special condition.

The more specific the code is, the harder it will be to understand in
the future.  Yes, it's a one-liner, but we've had death by a thousand
cuts before, many times.  A few cycles ago, kswapd was blowing up left
and right simply because it was trying to meet too many specific
objectives from facilitating order-0 allocators, maintaining zone
health, enabling compaction for higher order allocation, writing back
dirty pages.  Ultimately, it just got stuck in endless loops because
of conflicting conditionals.  We've had similar problems in the scan
count calculation etc where all the checks and special cases left us
with code that was impossible to reason about.  There really is a
history of "low overhead one-liner fixes" eating us alive in the VM.

The solution was always to take a step back and integrate all
requirements properly.  Not only did this fix the problems, the code
ended up being much more robust and easier to understand and modify as
well.

If shortening the direct reclaim cycle is an adequate solution to your
problem, it would be much preferable.  Because

  "checking at a reasonable interval if the work I'm doing is still
   necessary"

is a much more approachable, generic, and intuitive concept than

  "the OOM killer has gone off, direct reclaim is futile, I should
   exit quickly to release memory so that not more tasks get caught
   doing direct reclaim".

and the fix would benefit a much wider audience.

Lastly, as far as I know, you are the only reporter that noticed an
issue with this loooooong-standing behavior, and you don't even run
upstream kernels.  There really is no excuse to put up with a quick &
dirty fix.
