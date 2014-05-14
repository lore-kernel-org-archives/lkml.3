Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaENWgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:36:53 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:50309 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaENWgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:36:52 -0400
Date: Wed, 14 May 2014 18:36:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Juri Lelli <juri.lelli@gmail.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140514223648.GH15690@htj.dyndns.org>
References: <20140509160455.GA4486@htj.dyndns.org>
 <20140514140034.GM30445@twins.programming.kicks-ass.net>
 <20140514170238.GB15690@htj.dyndns.org>
 <20140514171051.GX30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514171051.GX30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 07:10:51PM +0200, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 01:02:38PM -0400, Tejun Heo wrote:
> > On Wed, May 14, 2014 at 04:00:34PM +0200, Peter Zijlstra wrote:
> > > Does something like the below help any? I noticed those things (cpudl
> > > and cpupri) had [NR_CPUS] arrays, which is always 'fun'.
> > > 
> > > The below is a mostly no thought involved conversion of cpudl which
> > > boots, I'll also do cpupri and then actually stare at the algorithms to
> > > see if I didn't make any obvious fails.
> > 
> > Yeah, should avoid large allocation on reasonably sized machines and I
> > don't think 2k CPU machines suspend regularly.  Prolly good / safe
> > enough for -stable port?  
> 
> Yeah, its certainly -stable material. Esp. if this cures the immediate
> problem.

The patches are URL encoded.  Tried to reproduce the problem but
haven't succeeded but I'm quite confident about the analysis, so
verifying that the high order allocation goes away should be enough.

I instrumented the allocator and it looks like we also have other
sources of high order allocation during resume before GFP_IOFS is
cleared.  Some kthread creations (order 2, probably okay) and on my
test setup a series of order 3 allocations from e1000.

Cc'ing Bruce for e1000.  Is it necessary to free and re-allocate
buffers across suspend/resume?  The driver ends up allocating multiple
order-3 regions during resume where mm doesn't have access to backing
devices and thus can't compact or reclaim and it's not too unlikely
for those allocations to fail.

I wonder whether we need some generic solution to address the issue.
Unfortunately, I don't think it'd be possible to order device
initialization to bring up backing devices earlier.  We don't really
have that kind of knowledge easily accessible.  Also, I don't think
it's realistic to require drivers to avoid high order allocations
during resume.

Maybe we should pre-reclaim and set aside some amount of memory to be
used during resume?  It's a mushy solution but could be good enough.
Rafael, Johannes, what do you guys think?

Thanks.

-- 
tejun
