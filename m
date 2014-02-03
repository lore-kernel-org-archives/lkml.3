Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaBCV7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:59:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42625 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCV7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:59:16 -0500
Date: Mon, 3 Feb 2014 21:59:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
Message-ID: <20140203215908.GD10323@ZenIV.linux.org.uk>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
 <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
 <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
 <20140130075421.GA10050@infradead.org>
 <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
 <20140203102943.GF11829@infradead.org>
 <CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 01:03:32PM -0800, Linus Torvalds wrote:

> -	err = vfs_mkdir(path.dentry->d_inode, dentry, mode);
> +	err = vfs_mkdir(path.dentry, dentry, mode);

Pointless - path.dentry == dentry->d_parent anyway.
 
> -	err = vfs_mknod(path.dentry->d_inode, dentry, mode, dev->devt);
> +	err = vfs_mknod(path.dentry, dentry, mode, dev->devt);

Ditto.

> @@ -237,7 +237,7 @@ static int dev_rmdir(const char *name)
>  		return PTR_ERR(dentry);
>  	if (dentry->d_inode) {
>  		if (dentry->d_inode->i_private == &thread)
> -			err = vfs_rmdir(parent.dentry->d_inode, dentry);
> +			err = vfs_rmdir(parent.dentry, dentry);
 
 Ditto, with s/path/parent/
> @@ -324,7 +324,7 @@ static int handle_remove(const char *nodename, struct device *dev)
>  			mutex_lock(&dentry->d_inode->i_mutex);
>  			notify_change(dentry, &newattrs, NULL);
>  			mutex_unlock(&dentry->d_inode->i_mutex);
> -			err = vfs_unlink(parent.dentry->d_inode, dentry, NULL);
> +			err = vfs_unlink(parent.dentry, dentry, NULL);
>  			if (!err || err == -ENOENT)
>  				deleted = 1;
>  		}
 
And here as well.
 
> +++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
> @@ -222,8 +222,8 @@ int lustre_rename(struct dentry *dir, struct vfsmount *mnt,
>  	if (IS_ERR(dchild_new))
>  		GOTO(put_old, err = PTR_ERR(dchild_new));
>  
> -	err = ll_vfs_rename(dir->d_inode, dchild_old, mnt,
> -			    dir->d_inode, dchild_new, mnt, NULL);
> +	err = ll_vfs_rename(dir, dchild_old, mnt,
> +			    dir, dchild_new, mnt, NULL);


... and again, that's completely pointless.

> -int afs_permission(struct inode *inode, int mask)
> +int afs_permission(struct dentry *dentry, struct inode *inode, int mask)

Oh, _lovely_.  So not only do we pass dentry, the arguments are redundant
as well.

> -static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
> +static inline int btrfs_may_create(struct dentry *parent, struct dentry *child)

I'm fairly sure that it's also pointless, because parent is going to be, well,
the parent.  Of child.

> +static int gfs2_vfs_permission(struct dentry *dentry, struct inode *inode, int mask)
> +{
> +	return gfs2_permission(inode, mask);
> +}

Er...  You do realize that callers of gfs2_permission() tend to have
the dentry in question, either directly or as ->d_parent of something
they have?


I really hate the whole thing... ;-/
