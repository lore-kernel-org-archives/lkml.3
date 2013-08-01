Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3HAC7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:59:33 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:33798 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040Ab3HAC7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:59:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgFAInO+VF5LPxHgWdsb2JhbABbDr0BhS6BIBcOAQEWJiiCJAEBBAE6HCgLCAMYCSUPBSUDIQESiAoFuUMWj3iECwOUCINWiiKKAlAq
Date: Thu, 1 Aug 2013 12:59:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>,
        adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801025914.GL7118@dastard>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
 <20130731220154.GA11378@thunk.org>
 <20130801002341.GI7118@dastard>
 <20130801004645.GC11378@thunk.org>
 <20130801005447.GS13468@dastard>
 <20130801010751.GD11378@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801010751.GD11378@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 09:07:52PM -0400, Theodore Ts'o wrote:
> On Thu, Aug 01, 2013 at 10:54:47AM +1000, Dave Chinner wrote:
> > > It's not just the range that it's operating on, but also the region
> > > beyond the range that's been collapsed out.
> > 
> > Yes, that's part of "the range that it is operating over".
> > 
> > > A quick eyeball of the patch didn't seem to show any code that handled
> > > this, which is why I asked the question.
> > 
> > Right, but really it's the least of the problems I've noticed - the
> > XFS code is fundamentally broken in many ways - once I've finished
> > commenting on it, I'll have a quick look to see if the ext4 code has
> > the same fundamental flaws....
> 
> Well, the fundamental flaw of potential races if the file being
> collapsed has been mmap'ed and there is another process making changes
> beyond the range that is being collapsed is I suspect one that is
> going to be very hard to solve, short of not allowing the collapse
> while there are any read/write mmap's for the file in question.

This funtionality is not introducing any new problems w.r.t. mmap().
In terms of truncating a mmap'd file, that can already occur and
the behaviour is well known. The current patches don't do the
operations in the correct order to ensure this is handled correctly
(i.e. the inode size has to be changed before the page cache
invalidation, not after), but otherwise there is no new issues
introduced here.

The real problem is that it has the same problem as hole punching
w.r.t. not being able to serialise page faults against the extent
manipulations after the page cache invalidation has occurred.
That's what Jan Kara's range locking patches we talked about at
LSFMM will address, and so is beyond the scope of this patchset.

> And I would think these sorts of VM issues should be handled with some
> generic library functions, instead of reimplementing them from scratch
> in each file system.

Well, yes, we have one - truncate_page_cache_range(), and it's used
correctly in the ext4 patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
