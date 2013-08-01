Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab3HAEcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 00:32:33 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:20409 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab3HAEc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 00:32:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgFANfj+VF5LPxHgWdsb2JhbABTCA69AYUugSAXDgEBFiYogiQBAQQBOhwoCwgDGAklDwUlAyEBEogKBbk7Fo41gUOECwOXXooiigJQKg
Date: Thu, 1 Aug 2013 14:32:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>,
        adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801043220.GN7118@dastard>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
 <20130731220154.GA11378@thunk.org>
 <20130801002341.GI7118@dastard>
 <20130801004645.GC11378@thunk.org>
 <20130801005447.GS13468@dastard>
 <20130801010751.GD11378@thunk.org>
 <20130801025914.GL7118@dastard>
 <20130801040605.GA20351@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801040605.GA20351@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 12:06:05AM -0400, Theodore Ts'o wrote:
> On Thu, Aug 01, 2013 at 12:59:14PM +1000, Dave Chinner wrote:
> > 
> > This funtionality is not introducing any new problems w.r.t. mmap().
> > In terms of truncating a mmap'd file, that can already occur and
> > the behaviour is well known.
> 
> That's not race I'm worried about.  Consider the following scenario.
> We have a 10 meg file, and the first five megs are mapped read/write.
> We do a collapse range of one meg starting at the one meg boundary.
> Menwhile another process is constantly modifying the pages between the
> 3 meg and 4 meg mark, via a mmap'ed region of memory.
> 
> You can have the code which does the collapse range call
> filemap_fdatawrite_range() to flush out to disk all of the inode's
> dirty pages in the page cache, but between the call to
> filemap_fdatawrite_range() and truncate_page_cache_range(), more pages
> could have gotten dirtied, and those changes will get lost.

That's one of the many race conditions that Jan's patches are
intended to solve. Locking the range and then unmapping the pages
will then cause the refault to block until the range is unlocked.

While the range is locked, we can then writeback all the dirty
pages, invalidate the page cache and modify the underlying extents
without having to care about user page faults racing with the
operation.

Let's face it, without that we current cannot serialise *any*
multi-page page cache operation against mmap() - direct IO has
exactly the same problems as you are describing, as does hole
punching, and anything else that relies on the i_mutex or other
IO-based locks for serialisation.

> The difference between punch_hole and collapse_range is that
> previously, we only needed to call truncate_page_cache_range() on the
> pages that were going to be disappearing from the page cache, so it
> didn't matter if you had someone dirtying the pages racing with the
> punch_hole operation.  But in the collapse_range case, we need to call
> truncate_page_cache_range() on data that is not going to disappear,
> but rather be _renumbered_.

Sure - as it said up front "the range of the pages being operated
on" need to be invalidating. And, if you look at the ext4 patch, is
actaully does exactly that....

> I'll also note that depending on the use case, doing the renumbering
> of the pages by throwing all of the pages from the page cache and
> forcing them to be read back in from disk might not all be friendly to
> a performance sensitive application.

Application problem.

Besides, this is for accelerating video stream editting (i.e. NLE
workflows). Such applications tend to use direct IO for recording
and playback, and they most certainly won't have concurrent access
to the video stream either by mmap or direct/buferred IO while the
non linear editor is punching the advertisements out of the recorded
video stream......

> In the case where the page size == the fs block size, instead of
> throwing away all of the pages, we could also have VM code which
> remaps the pages in the page cache (including potentially editing the
> page tables for any mmap'ed pages).

That way lies insanity. Not to mention that it's completely
unnecessary for the use case this ioctl is actually accelerating.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
