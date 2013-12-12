Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3LLBIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:08:01 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14901 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab3LLBIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:08:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtAHAIULqVJ5LHyk/2dsb2JhbABZgweDOrBhhi+BGxd0giUBAQU6HCMQCAMOCgklDwUlAyETiAHCOxcWjnIHgyGBEwSYE4pMh0iDPSg
Date: Thu, 12 Dec 2013 12:07:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, page_alloc: make __GFP_NOFAIL really not fail
Message-ID: <20131212010754.GE31386@dastard>
References: <alpine.DEB.2.02.1312091355360.11026@chino.kir.corp.google.com>
 <20131209152202.df3d4051d7dc61ada7c420a9@linux-foundation.org>
 <alpine.DEB.2.02.1312101504120.22701@chino.kir.corp.google.com>
 <20131210153909.8b4bfa1d643e5f8582eff7c9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210153909.8b4bfa1d643e5f8582eff7c9@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:39:09PM -0800, Andrew Morton wrote:
> On Tue, 10 Dec 2013 15:20:17 -0800 (PST) David Rientjes <rientjes@google.com> wrote:
> 
> > On Mon, 9 Dec 2013, Andrew Morton wrote:
> > 
> > > > __GFP_NOFAIL specifies that the page allocator cannot fail to return
> > > > memory.  Allocators that call it may not even check for NULL upon
> > > > returning.
> > > > 
> > > > It turns out GFP_NOWAIT | __GFP_NOFAIL or GFP_ATOMIC | __GFP_NOFAIL can
> > > > actually return NULL.  More interestingly, processes that are doing
> > > > direct reclaim and have PF_MEMALLOC set may also return NULL for any
> > > > __GFP_NOFAIL allocation.
> > > 
> > > __GFP_NOFAIL is a nasty thing and making it pretend to work even better
> > > is heading in the wrong direction, surely?  It would be saner to just
> > > disallow these even-sillier combinations.  Can we fix up the current
> > > callers then stick a WARN_ON() in there?
> > > 
> > 
> > Heh, it's difficult to remove __GFP_NOFAIL when new users get added: 
> > 84235de394d9 ("fs: buffer: move allocation failure loop into the 
> > allocator") added a new user
> 
> That wasn't reeeeealy a new user - it was "convert an existing
> open-coded retry-for-ever loop".  Which is what __GFP_NOFAIL is for.
> 
> I don't think I've ever seen anyone actually fix one of these things
> (by teaching the caller to handle ENOMEM), so it obviously isn't
> working...

Right, because most of the loops are deep within filesystem
transaction code where the only thing to do with a memory allocation
failure is to abort the transaction, shutdown the filesystem and
deny user access (i.e. DOS the system) because the filesystem is
inconsistent in memory and the only way it can be recovered is
toosing everything in memory away and recovering the last valid
on disk state from the journal. i.e. umount, mount.

IOWs, the "fix" is far worse than current behaviour and so there is
absolutely no motivation for the people who own these __GFP_NOFAIL
allocations to fix them. Indeed, when you consider that the amount of
work to fix the filesystems to robustly handle ENOMEM is a *massive*
undertaking that adds significant overhead and complexity to each
filesystem, the cost/benefit analysis comes down so far on the side
of "just use __GFP_NOFAIL" that doing anything else is sheer lunacy.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
