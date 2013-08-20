Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3HTCgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:36:44 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5397 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401Ab3HTCgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:36:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMHAOfVElJ5LJ62/2dsb2JhbABagwWDN7dHhTuBJBd0giQBAQUnExwjEAgDDgoJJQ8FJQMhE4gPqzIWkEYHgxt3A5djkVaBYYFNKg
Date: Tue, 20 Aug 2013 12:36:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/5] mm: Notify filesystems when it's time to apply a
 deferred cmtime update
Message-ID: <20130820023615.GE6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
 <ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 04:22:10PM -0700, Andy Lutomirski wrote:
> Filesystems that defer cmtime updates should update cmtime when any
> of these events happen after a write via a mapping:
> 
>  - The mapping is written back to disk.  This happens from all kinds
>    of places, all of which eventually call ->writepages.
> 
>  - munmap is called or the mapping is removed when the process exits
> 
>  - msync(MS_ASYNC) is called.  Linux currently does nothing for
>    msync(MS_ASYNC), but POSIX says that cmtime should be updated some
>    time between an mmaped write and the subsequent msync call.
>    MS_SYNC calls ->writepages, but MS_ASYNC needs special handling.
> 
> Filesystmes that defer cmtime updates should flush them on munmap or
> exit.  Finding out that this happened through vm_ops is messy, so
> add a new address space op for this.
> 
> It's not strictly necessary to call ->flush_cmtime after ->writepages,
> but it simplifies the fs code.  As an optional optimization,
> filesystems can call mapping_test_clear_cmtime themselves in
> ->writepages (as long as they're careful to scan all the pages first
> -- the cmtime bit may not be set when ->writepages is entered).

.flush_cmtime is effectively a duplicate method.  We already have
.update_time to notify filesystems that they need to update the
timestamp in the inode transactionally.

Indeed:

> +	/*
> +	 * Userspace expects certain system calls to update cmtime if
> +	 * a file has been recently written using a shared vma.  In
> +	 * cases where cmtime may need to be updated but writepages is
> +	 * not called, this is called instead.  (Implementations
> +	 * should call mapping_test_clear_cmtime.)
> +	 */
> +	void (*flush_cmtime)(struct address_space *);

You say it can be implemented in the ->writepage(s) method, and all
filesystems provide ->writepage(s) in some form. Therefore I would
have thought it be best to simply require filesystems to check that
mapping flag during those methods and update the inode directly when
that is set?

Indeed, the way you've set up the infrastructure, we'll have to
rewrite the cmtime update code to enable writepages to update this
within some other transaction. Perhaps you should just implement it
that way first?

> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1928,6 +1928,18 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  		ret = mapping->a_ops->writepages(mapping, wbc);
>  	else
>  		ret = generic_writepages(mapping, wbc);
> +
> +	/*
> +	 * ->writepages will call clear_page_dirty_for_io, which may, in turn,
> +	 * mark the mapping for deferred cmtime update.  As an optimization,
> +	 * a filesystem can flush the update at the end of ->writepages
> +	 * (possibly avoiding a journal transaction, for example), but,
> +	 * for simplicity, let filesystems skip that part and just implement
> +	 * ->flush_cmtime.
> +	 */
> +	if (mapping->a_ops->flush_cmtime)
> +		mapping->a_ops->flush_cmtime(mapping);

And that's where you cannot call sb_pagefault_start/end....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
