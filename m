Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3FXQnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:43:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28471 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3FXQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:43:39 -0400
Date: Mon, 24 Jun 2013 19:43:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] vfs: check for integer overflows in posix_acl_alloc()
Message-ID: <20130624164329.GG5714@mwanda>
References: <20130624162719.GB32503@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624162719.GB32503@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 07:27:19PM +0300, Dan Carpenter wrote:
> We've seen cases where people passed negative numbers to
> posix_acl_alloc() and we fixed the caller.  For example 093019cf1b "xfs:
> fix acl count validation in xfs_acl_from_disk()".  But there are other
> places which might be affected like ext4_acl_from_disk() which checks
> for negative but doesn't check an upper limit.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index cea4623..cd7fd2f 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -46,7 +46,12 @@ posix_acl_alloc(int count, gfp_t flags)
>  {
>  	const size_t size = sizeof(struct posix_acl) +
>  	                    count * sizeof(struct posix_acl_entry);
> -	struct posix_acl *acl = kmalloc(size, flags);
> +	struct posix_acl *acl;
> +
> +	if (count < 0 || count > (SIZE_MAX - sizeof(struct posix_acl) /
> +					sizeof(struct posix_acl_entry)))

Gar.  I completely screwed that up.  Please ignore this.  I will
send a better patch in a couple days.  I am sorry.

regards,
dan carpenter

> +		return NULL;
> +	acl = kmalloc(size, flags);
>  	if (acl)
>  		posix_acl_init(acl, count);
>  	return acl;
