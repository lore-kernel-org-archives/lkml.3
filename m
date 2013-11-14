Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3KNLQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:16:24 -0500
Received: from [204.155.152.216] ([204.155.152.216]:45719 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab3KNLQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:16:18 -0500
Date: Thu, 14 Nov 2013 12:19:48 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Axel Lin <axel.lin@ingics.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ramfs: Fix memory leak on ramfs_fill_super error paths
Message-ID: <20131114101948.GA12195@shutemov.name>
References: <1384412359.28992.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384412359.28992.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:59:19PM +0800, Axel Lin wrote:
> The memory leak was introduced by commit 318ceed0884
> "tidy up after d_make_root() conversion".
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  fs/ramfs/inode.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index 39d1465..868a41e 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -221,7 +221,7 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	err = ramfs_parse_options(data, &fsi->mount_opts);
>  	if (err)
> -		return err;
> +		goto fail;
>  
>  	sb->s_maxbytes		= MAX_LFS_FILESIZE;
>  	sb->s_blocksize		= PAGE_CACHE_SIZE;
> @@ -232,10 +232,16 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	inode = ramfs_get_inode(sb, NULL, S_IFDIR | fsi->mount_opts.mode, 0);
>  	sb->s_root = d_make_root(inode);
> -	if (!sb->s_root)
> -		return -ENOMEM;
> +	if (!sb->s_root) {
> +		err = -ENOMEM;
> +		goto fail;
> +	}
>  
>  	return 0;
> +fail:
> +	kfree(fsi);
> +	sb->s_fs_info = NULL;

Why do we need this?
mount_nodev() seems just drop super block if filler fails.

> +	return err;
>  }
>  
>  struct dentry *ramfs_mount(struct file_system_type *fs_type,
-- 
 Kirill A. Shutemov
