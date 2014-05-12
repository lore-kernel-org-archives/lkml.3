Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbaELUWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:22:43 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:60265 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaELUWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:22:41 -0400
Date: Tue, 13 May 2014 00:22:35 +0400
From: Andrey Wagin <avagin@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org, libcg-devel@lists.sourceforge.net
Subject: Re: [PATCH driver-core-linus] kernfs, sysfs, cgroup: restrict extra
 perm check on open to sysfs
Message-ID: <20140512202234.GA4484@gmail.com>
References: <CANaxB-xUm3rJ-Cbp72q-rQJO5mZe1qK6qXsQM=vh0U8upJ44+A@mail.gmail.com>
 <20140512151908.GC1421@htj.dyndns.org>
 <20140512175627.GE1421@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20140512175627.GE1421@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 01:56:27PM -0400, Tejun Heo wrote:
> The kernfs open method - kernfs_fop_open() - inherited extra
> permission checks from sysfs.  While the vfs layer allows ignoring the
> read/write permissions checks if the issuer has CAP_DAC_OVERRIDE,
> sysfs explicitly denied open regardless of the cap if the file doesn't
> have any of the UGO perms of the requested access or doesn't implement
> the requested operation.  It can be debated whether this was a good
> idea or not but the behavior is too subtle and dangerous to change at
> this point.
> 
> After cgroup got converted to kernfs, this extra perm check also got
> applied to cgroup breaking libcgroup which opens write-only files with
> O_RDWR as root.  This patch gates the extra open permission check with
> a new flag KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK and enables it for sysfs.
> For sysfs, nothing changes.  For cgroup, root now can perform any
> operation regardless of the permissions as it was before kernfs
> conversion.  Note that kernfs still fails unimplemented operations
> with -EINVAL.
> 
> While at it, add comments explaining KERNFS_ROOT flags.
>

It works for me. Thank you for the quick response.

Tested-by: Andrey Wagin <avagin@gmail.com>

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Andrey Wagin <avagin@gmail.com>
> Cc: Li Zefan <lizefan@huawei.com>
> References: http://lkml.kernel.org/g/CANaxB-xUm3rJ-Cbp72q-rQJO5mZe1qK6qXsQM=vh0U8upJ44+A@mail.gmail.com
> Fixes: 2bd59d48ebfb ("cgroup: convert to kernfs")
> ---
>  fs/kernfs/file.c       |   19 +++++++++++--------
>  fs/sysfs/mount.c       |    3 ++-
>  include/linux/kernfs.h |   19 ++++++++++++++++++-
>  3 files changed, 31 insertions(+), 10 deletions(-)
> 
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -610,6 +610,7 @@ static void kernfs_put_open_node(struct
>  static int kernfs_fop_open(struct inode *inode, struct file *file)
>  {
>  	struct kernfs_node *kn = file->f_path.dentry->d_fsdata;
> +	struct kernfs_root *root = kernfs_root(kn);
>  	const struct kernfs_ops *ops;
>  	struct kernfs_open_file *of;
>  	bool has_read, has_write, has_mmap;
> @@ -624,14 +625,16 @@ static int kernfs_fop_open(struct inode
>  	has_write = ops->write || ops->mmap;
>  	has_mmap = ops->mmap;
>  
> -	/* check perms and supported operations */
> -	if ((file->f_mode & FMODE_WRITE) &&
> -	    (!(inode->i_mode & S_IWUGO) || !has_write))
> -		goto err_out;
> -
> -	if ((file->f_mode & FMODE_READ) &&
> -	    (!(inode->i_mode & S_IRUGO) || !has_read))
> -		goto err_out;
> +	/* see the flag definition for details */
> +	if (root->flags & KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK) {
> +		if ((file->f_mode & FMODE_WRITE) &&
> +		    (!(inode->i_mode & S_IWUGO) || !has_write))
> +			goto err_out;
> +
> +		if ((file->f_mode & FMODE_READ) &&
> +		    (!(inode->i_mode & S_IRUGO) || !has_read))
> +			goto err_out;
> +	}
>  
>  	/* allocate a kernfs_open_file for the file */
>  	error = -ENOMEM;
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -63,7 +63,8 @@ int __init sysfs_init(void)
>  {
>  	int err;
>  
> -	sysfs_root = kernfs_create_root(NULL, 0, NULL);
> +	sysfs_root = kernfs_create_root(NULL, KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK,
> +					NULL);
>  	if (IS_ERR(sysfs_root))
>  		return PTR_ERR(sysfs_root);
>  
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -50,7 +50,24 @@ enum kernfs_node_flag {
>  
>  /* @flags for kernfs_create_root() */
>  enum kernfs_root_flag {
> -	KERNFS_ROOT_CREATE_DEACTIVATED = 0x0001,
> +	/*
> +	 * kernfs_nodes are created in the deactivated state and invisible.
> +	 * They require explicit kernfs_activate() to become visible.  This
> +	 * can be used to make related nodes become visible atomically
> +	 * after all nodes are created successfully.
> +	 */
> +	KERNFS_ROOT_CREATE_DEACTIVATED		= 0x0001,
> +
> +	/*
> +	 * For regular flies, if the opener has CAP_DAC_OVERRIDE, open(2)
> +	 * succeeds regardless of the RW permissions.  sysfs had an extra
> +	 * layer of enforcement where open(2) fails with -EACCES regardless
> +	 * of CAP_DAC_OVERRIDE if the permission doesn't have the
> +	 * respective read or write access at all (none of S_IRUGO or
> +	 * S_IWUGO) or the respective operation isn't implemented.  The
> +	 * following flag enables that behavior.
> +	 */
> +	KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK	= 0x0002,
>  };
>  
>  /* type-specific structures for kernfs_node union members */
