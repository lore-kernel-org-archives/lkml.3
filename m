Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbaJINcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:32:50 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:35041 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbaJINcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:32:41 -0400
Date: Thu, 9 Oct 2014 09:32:37 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] sysfs/kernfs: allow attributes to request write
 buffer be pre-allocated.
Message-ID: <20141009133237.GC14387@htj.dyndns.org>
References: <20141008234119.19126.4182.stgit@notabene.brown>
 <20141008235706.19126.68493.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008235706.19126.68493.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 10:57:06AM +1100, NeilBrown wrote:
> md/raid allows metadata management to be performed in user-space.
> A various times, particularly on device failure, the metadata needs
> to be updated before further writes can be permitted.
> This means that the user-space program which updates metadata much
> not block on writeout, and so must not allocate memory.
> 
> mlockall(MCL_CURRENT|MCL_FUTURE) and pre-allocation can avoid all
> memory allocation issues for user-memory, but that does not help
> kernel memory.
> Several kernel objects can be pre-allocated.  e.g. files opened before
> any writes to the array are permitted.
> However some kernel allocation happens in places that cannot be
> pre-allocated.
> In particular, writes to sysfs files (to tell md that it can now
> allow writes to the array) allocate a buffer using GFP_KERNEL.
> 
> This patch allows attributes to be marked as "PREALLOC".  In that case
> the maximal buffer is allocated when the file is opened, and then used
> on each write instead of allocating a new buffer.
> 
> As the same buffer is now shared for all writes on the same file
> description, the mutex is extended to cover full use of the buffer
> including the copy_from_user().
> 
> The new __ATTR_PREALLOC() 'or's a new flag in to the 'mode', which is
> inspected by sysfs_add_file_mode_ns() to determine if the file should be
> marked as requiring prealloc.
> 
> Signed-off-by: NeilBrown  <neilb@suse.de>

Reviewed-by: Tejun Heo <tj@kernel.org>

A trivial nitpick follows.

> @@ -685,6 +690,13 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
>  	 */
>  	of->atomic_write_len = ops->atomic_write_len;
>  
> +	if (ops->prealloc) {
> +		int len = of->atomic_write_len ?: PAGE_SIZE;
> +		of->prealloc_buf = kmalloc(len + 1, GFP_KERNEL);
> +		error = -ENOMEM;
> +		if (!of->prealloc_buf)
> +			goto err_free;
> +	}

We prolly want a new line here for style consistency?

>  	/*
>  	 * Always instantiate seq_file even if read access doesn't use
>  	 * seq_file or is not requested.  This unifies private data access

Thanks.

-- 
tejun
