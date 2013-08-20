Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3HTC23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:28:29 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35062 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab3HTC22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:28:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMHAIrTElJ5LJ62/2dsb2JhbABagwWDN7dGhTuBJBd0giQBAQUnExwjEAgDDgoJJQ8FJQMhE4gPqzIWkEYHgxt3A5djiimHLYMuKg
Date: Tue, 20 Aug 2013 12:28:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/5] fs: Add inode_update_time_writable
Message-ID: <20130820022822.GD6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
 <a27accc2d9460b7ef194a203f305a18dafe926e8.1376679411.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a27accc2d9460b7ef194a203f305a18dafe926e8.1376679411.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 04:22:09PM -0700, Andy Lutomirski wrote:
> This is like file_update_time, except that it acts on a struct inode *
> instead of a struct file *.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  fs/inode.c         | 72 ++++++++++++++++++++++++++++++++++++++++++------------
>  include/linux/fs.h |  1 +
>  2 files changed, 58 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index d6dfb09..bc90c12 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1637,6 +1637,34 @@ int file_remove_suid(struct file *file)
>  }
>  EXPORT_SYMBOL(file_remove_suid);
>  
> +/*
> + * This does the work that's common to file_update_time and
> + * inode_update_time.
> + */
> +static int prepare_update_cmtime(struct inode *inode, struct timespec *now)
> +{
> +	int sync_it;
> +
> +	/* First try to exhaust all avenues to not sync */
> +	if (IS_NOCMTIME(inode))
> +		return 0;
> +
> +	*now = current_fs_time(inode->i_sb);
> +	if (!timespec_equal(&inode->i_mtime, now))
> +		sync_it = S_MTIME;
> +
> +	if (!timespec_equal(&inode->i_ctime, now))
> +		sync_it |= S_CTIME;
> +
> +	if (IS_I_VERSION(inode))
> +		sync_it |= S_VERSION;
> +
> +	if (!sync_it)
> +		return 0;
> +
> +	return sync_it;
> +}
> +
>  /**
>   *	file_update_time	-	update mtime and ctime time
>   *	@file: file accessed
> @@ -1654,23 +1682,9 @@ int file_update_time(struct file *file)
>  {
>  	struct inode *inode = file_inode(file);
>  	struct timespec now;
> -	int sync_it = 0;
> +	int sync_it = prepare_update_cmtime(inode, &now);
>  	int ret;
>  
> -	/* First try to exhaust all avenues to not sync */
> -	if (IS_NOCMTIME(inode))
> -		return 0;
> -
> -	now = current_fs_time(inode->i_sb);
> -	if (!timespec_equal(&inode->i_mtime, &now))
> -		sync_it = S_MTIME;
> -
> -	if (!timespec_equal(&inode->i_ctime, &now))
> -		sync_it |= S_CTIME;
> -
> -	if (IS_I_VERSION(inode))
> -		sync_it |= S_VERSION;
> -
>  	if (!sync_it)
>  		return 0;
>  
> @@ -1685,6 +1699,34 @@ int file_update_time(struct file *file)
>  }
>  EXPORT_SYMBOL(file_update_time);
>  
> +/**
> + *	inode_update_time_writable	-	update mtime and ctime time
> + *	@inode: inode accessed
> + *
> + *	This is like file_update_time, but it assumes the mnt is writable
> + *	and takes an inode parameter instead.  (We need to assume the mnt
> + *	was writable because inodes aren't associated with any particular
> + *	mnt.
> + */
> +
> +int inode_update_time_writable(struct inode *inode)
> +{
> +	struct timespec now;
> +	int sync_it = prepare_update_cmtime(inode, &now);
> +	int ret;
> +
> +	if (!sync_it)
> +		return 0;
> +
> +	/* sb_start_pagefault and update_time can both sleep. */
> +	sb_start_pagefault(inode->i_sb);
> +	ret = update_time(inode, &now, sync_it);
> +	sb_end_pagefault(inode->i_sb);

This gets called from the writeback path - you can't use
sb_start_pagefault/sb_end_pagefault in that path.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
