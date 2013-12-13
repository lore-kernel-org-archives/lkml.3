Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3LMQjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:39:22 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3LMQjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:39:18 -0500
Date: Fri, 13 Dec 2013 08:39:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: add a new method xfs_vn_tmpfile()
Message-ID: <20131213163916.GG20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
 <1386944873-16796-5-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386944873-16796-5-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 10:27:52PM +0800, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Add a new O_TMPFILE method to VFS inteface.
> For more info, please refer to:
>   http://oss.sgi.com/archives/xfs/2013-08/msg00336.html
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  fs/xfs/xfs_iops.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index eb55be5..b57cd89 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -39,6 +39,7 @@
>  #include "xfs_da_btree.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_dinode.h"
> +#include "xfs_trans_space.h"
>  
>  #include <linux/capability.h>
>  #include <linux/xattr.h>
> @@ -1051,6 +1052,25 @@ xfs_vn_fiemap(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_vn_tmpfile(
> +	struct inode	*dir,
> +	struct dentry	*dentry,
> +	umode_t		mode)
> +{
> +	struct xfs_inode *ip = NULL;
> +	int		error;
> +
> +	error = xfs_create_tmpfile(XFS_I(dir), XFS_I(dir)->i_mount,

No need to pass in the mount point here, the client can get it easily.

> +				mode, 0, &ip);

Also no need for an always-zero argument.

> +	if (error)
> +		return -error;
> +
> +	d_instantiate(dentry, VFS_I(ip));

Shouldn't this be a call to d_tmpfile() instead?

Also I'd suggest mergin this into the previous patch, so that we have
one that actually adds O_TMPFILE support, and once place to write a nice
good changelog.
