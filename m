Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaKCWTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:19:39 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52209 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbaKCWTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:19:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQuACP/V1R5LbBU/2dsb2JhbABcgw6BLII2uBoGlSiFagQCAoEnFwEBAQEBfYQDAQEEOhwjEAgDDgoJJQ8FJQMhE4hAyw0BAQEHAgEfGIYfilkHgy2BHgWeAIEyi0iFToQJhAwpL4JLAQEB
Date: Tue, 4 Nov 2014 09:18:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: your patch "mm: Remove false WARN_ON from
 pagecache_isize_extended()"
Message-ID: <20141103221849.GB23575@dastard>
References: <5457BE390200007800044838@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5457BE390200007800044838@mail.emea.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:41:13PM +0000, Jan Beulich wrote:
> Jan,
> 
> having run into that warning too, I looked into it a little, and now
> having found that patch am pretty uncertain: Both truncate_setsize()
> and pagecache_isize_extended() document that they want to be
> called with i_mutex held, so removing the WARN_ON() alone seems
> either incomplete or wrong. What I found to work without violating
> this documented requirement is the patch below.

Or, just perhaps, the comments are wrong....

Some filesystems have stronger, more robust internal serialisation
than the VFS provides with i_mutex....

> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -797,7 +797,7 @@ xfs_file_fallocate(
>  		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
>  		return -EOPNOTSUPP;
>  
> -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +	xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
>  		error = xfs_free_file_space(ip, offset, len);
>  		if (error)

The i_mutex is completely redundant here. Not to mention there are
multiple callers of these xfs_*_file_space() functions used to
implement fallocate(), and we're not about to change the locking
model for them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
