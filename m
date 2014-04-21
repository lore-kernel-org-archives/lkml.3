Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaDUNBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:01:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaDUNBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:01:41 -0400
Date: Mon, 21 Apr 2014 09:01:14 -0400
From: Brian Foster <bfoster@redhat.com>
To: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Fix wrong error codes being returned
Message-ID: <20140421130113.GA24813@bfoster.bfoster>
References: <1398074687-26548-1-git-send-email-tuomas.tynkkynen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398074687-26548-1-git-send-email-tuomas.tynkkynen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 01:04:47PM +0300, Tuomas Tynkkynen wrote:
> xfs_{compat_,}attrmulti_by_handle could return an errno with incorrect
> sign in some cases. While at it, make sure ENOMEM is returned instead of
> E2BIG if kmalloc fails.
> 
> Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
> ---

The fix looks good to me. There has been talk recently of starting to
fix up our internal positive-to-negative error conversions to be more
consistent with the rest of the kernel. Given that, I wonder if it's
better here to go the other way. E.g., remove the negation in the
out_dput path and convert the positive error codes (and thus we don't
need to add more negative-to-positive-to-negative conversions here).
Thoughts?

Brian

> Compile tested only. For the ERANGE case, I also wonder if it should
> be assigning to ops[i].am_error instead of error, and/or have a break.
> 
>  fs/xfs/xfs_ioctl.c   |    5 +++--
>  fs/xfs/xfs_ioctl32.c |    5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0b18776..2d8f4fd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -543,10 +543,11 @@ xfs_attrmulti_by_handle(
>  
>  	ops = memdup_user(am_hreq.ops, size);
>  	if (IS_ERR(ops)) {
> -		error = PTR_ERR(ops);
> +		error = -PTR_ERR(ops);
>  		goto out_dput;
>  	}
>  
> +	error = ENOMEM;
>  	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
>  	if (!attr_name)
>  		goto out_kfree_ops;
> @@ -556,7 +557,7 @@ xfs_attrmulti_by_handle(
>  		ops[i].am_error = strncpy_from_user((char *)attr_name,
>  				ops[i].am_attrname, MAXNAMELEN);
>  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> +			error = ERANGE;
>  		if (ops[i].am_error < 0)
>  			break;
>  
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index a7992f8..944d5ba 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -424,10 +424,11 @@ xfs_compat_attrmulti_by_handle(
>  
>  	ops = memdup_user(compat_ptr(am_hreq.ops), size);
>  	if (IS_ERR(ops)) {
> -		error = PTR_ERR(ops);
> +		error = -PTR_ERR(ops);
>  		goto out_dput;
>  	}
>  
> +	error = ENOMEM;
>  	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
>  	if (!attr_name)
>  		goto out_kfree_ops;
> @@ -438,7 +439,7 @@ xfs_compat_attrmulti_by_handle(
>  				compat_ptr(ops[i].am_attrname),
>  				MAXNAMELEN);
>  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> +			error = ERANGE;
>  		if (ops[i].am_error < 0)
>  			break;
>  
> -- 
> 1.7.9.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
