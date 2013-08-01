Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab3HAEG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 00:06:28 -0400
Received: from imap.thunk.org ([74.207.234.97]:37656 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab3HAEG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 00:06:26 -0400
Date: Thu, 1 Aug 2013 00:06:05 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca, bpm@sgi.com,
        elder@kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801040605.GA20351@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca,
	bpm@sgi.com, elder@kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
	Namjae Jeon <namjae.jeon@samsung.com>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
 <20130731220154.GA11378@thunk.org>
 <20130801002341.GI7118@dastard>
 <20130801004645.GC11378@thunk.org>
 <20130801005447.GS13468@dastard>
 <20130801010751.GD11378@thunk.org>
 <20130801025914.GL7118@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801025914.GL7118@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 12:59:14PM +1000, Dave Chinner wrote:
> 
> This funtionality is not introducing any new problems w.r.t. mmap().
> In terms of truncating a mmap'd file, that can already occur and
> the behaviour is well known.

That's not race I'm worried about.  Consider the following scenario.
We have a 10 meg file, and the first five megs are mapped read/write.
We do a collapse range of one meg starting at the one meg boundary.
Menwhile another process is constantly modifying the pages between the
3 meg and 4 meg mark, via a mmap'ed region of memory.

You can have the code which does the collapse range call
filemap_fdatawrite_range() to flush out to disk all of the inode's
dirty pages in the page cache, but between the call to
filemap_fdatawrite_range() and truncate_page_cache_range(), more pages
could have gotten dirtied, and those changes will get lost.

The difference between punch_hole and collapse_range is that
previously, we only needed to call truncate_page_cache_range() on the
pages that were going to be disappearing from the page cache, so it
didn't matter if you had someone dirtying the pages racing with the
punch_hole operation.  But in the collapse_range case, we need to call
truncate_page_cache_range() on data that is not going to disappear,
but rather be _renumbered_.

I'll also note that depending on the use case, doing the renumbering
of the pages by throwing all of the pages from the page cache and
forcing them to be read back in from disk might not all be friendly to
a performance sensitive application.

In the case where the page size == the fs block size, instead of
throwing away all of the pages, we could also have VM code which
remaps the pages in the page cache (including potentially editing the
page tables for any mmap'ed pages).  This of course gets _much_ more
complicated, and we still have to deal with the case where the
collapse_range call is aligned with the fs block size, but which is
not aligned or is not a muliple of the page size.

						- Ted
