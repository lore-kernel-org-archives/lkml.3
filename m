Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbaEMLIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:08:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53824 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760181AbaEMLIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:08:17 -0400
Date: Tue, 13 May 2014 12:08:12 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Ben Myers <bpm@sgi.com>
Subject: Re: [ 137/143] xfs: underflow bug in xfs_attrlist_by_handle()
Message-ID: <20140513110812.GA4006@hercules>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
 <20140512003206.396224510@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140512003206.396224510@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:34:17AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> If we allocate less than sizeof(struct attrlist) then we end up
> corrupting memory or doing a ZERO_PTR_SIZE dereference.
> 
> This can only be triggered with CAP_SYS_ADMIN.
> 
> Reported-by: Nico Golde <nico@ngolde.de>
> Reported-by: Fabian Yamaguchi <fabs@goesec.de>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> (cherry picked from commit 071c529eb672648ee8ca3f90944bcbcc730b4c06)
> [dannf: backported to Debian's 2.6.32]
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  fs/xfs/linux-2.6/xfs_ioctl.c   | 3 ++-
>  fs/xfs/linux-2.6/xfs_ioctl32.c | 4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
> index 942362f..5663351 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -410,7 +410,8 @@ xfs_attrlist_by_handle(
>  		return -XFS_ERROR(EPERM);
>  	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
>  		return -XFS_ERROR(EFAULT);
> -	if (al_hreq.buflen > XATTR_LIST_MAX)
> +	if (al_hreq.buflen < sizeof(struct attrlist) ||
> +	    al_hreq.buflen > XATTR_LIST_MAX)
>  		return -XFS_ERROR(EINVAL);
>  
>  	/*
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
> index bad485a..782d03d 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl32.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
> @@ -361,8 +361,8 @@ xfs_compat_attrlist_by_handle(
>  	if (copy_from_user(&al_hreq, arg,
>  			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
>  		return -XFS_ERROR(EFAULT);
> -	if (al_hreq.buflen > XATTR_LIST_MAX)
> -		return -XFS_ERROR(EINVAL);

Am I missing something or was the above return statement deleted by
mistake?

Cheers,
--
Luís

> +	if (al_hreq.buflen < sizeof(struct attrlist) ||
> +	    al_hreq.buflen > XATTR_LIST_MAX)
>  
>  	/*
>  	 * Reject flags, only allow namespaces.
> -- 
> 1.7.12.2.21.g234cd45.dirty
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
