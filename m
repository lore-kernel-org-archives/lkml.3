Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaLSGsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 01:48:25 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50369 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaLSGsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 01:48:24 -0500
Date: Thu, 18 Dec 2014 22:48:20 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Trond Myklebust <trond.myklebust@primarydata.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nfs: prevent truncate on active swapfile
Message-ID: <20141219064820.GA12864@mew>
References: <13e8abe52a18c4e46ce497ff299774700cd7e1d0.1418970310.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13e8abe52a18c4e46ce497ff299774700cd7e1d0.1418970310.git.osandov@osandov.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 10:29:18PM -0800, Omar Sandoval wrote:
> Most filesystems prevent truncation of an active swapfile by way of
> inode_newsize_ok, called from inode_change_ok. NFS doesn't call either
> from nfs_setattr, presumably because most of these checks are expected
> to be done server-side. However, the IS_SWAPFILE check can only be done
> client-side, and not doing so is dangerous.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>  fs/nfs/inode.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 4bffe63..9205513 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -506,10 +506,15 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
>  		attr->ia_valid &= ~ATTR_MODE;
>  
>  	if (attr->ia_valid & ATTR_SIZE) {
> +		loff_t i_size;
> +
>  		BUG_ON(!S_ISREG(inode->i_mode));
>  
> -		if (attr->ia_size == i_size_read(inode))
> +		i_size = i_size_read(inode);
> +		if (attr->ia_size == i_size)
>  			attr->ia_valid &= ~ATTR_SIZE;
> +		else if (attr->ia_size < i_size && IS_SWAPFILE(inode))
> +			return -ETXTBSY;
>  	}
>  
>  	/* Optimization: if the end result is no change, don't RPC */
> -- 
> 2.2.0
> 
Sorry, forgot to mention that this applies to Linus' tree as of today.

-- 
Omar
