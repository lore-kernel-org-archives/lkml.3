Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3CZTSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:18:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38282 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3CZTSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:18:50 -0400
Date: Tue, 26 Mar 2013 19:18:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fs: imgdafs: Add IMG DAFS filesystem for metag
Message-ID: <20130326191848.GW21522@ZenIV.linux.org.uk>
References: <1364311169-3413-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364311169-3413-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 03:19:29PM +0000, James Hogan wrote:

> +struct da_stat {
> +	short st_dev;
> +	unsigned short st_ino;
> +	unsigned st_mode;
> +	unsigned short st_nlink;
> +	unsigned short st_uid;
> +	unsigned short st_gid;
> +	short st_rdev;
> +	int st_size;
> +	int st_atime;
> +	int st_spare1;
> +	int st_mtime;
> +	int st_spare2;
> +	int st_ctime;
> +	int st_spare3;
> +	int st_blksize;
> +	int st_blocks;
> +	int st_spare4[2];
> +};

Please, use explicitly-sized types.

> +struct da_finddata {
> +	unsigned long size;
> +	unsigned long attrib;
> +	char name[260];
> +};

... especially for this - unlike int and short, long really is arch-dependent.
And yes, I realize that this thing is arch-specific, but...

> +struct dafs_inode_info {
> +	int fd;
> +	int mode;

umm... int or fmode_t?

> +	struct inode vfs_inode;
> +};

> +#define DAFS_SUPER_MAGIC 0xdadadaf5

-> linux/magic.h

> +static char *dentry_name(struct dentry *dentry)
> +{
> +	char *name = __getname();
> +	if (!name)
> +		return NULL;
> +
> +	return __dentry_name(dentry, name); /* will unlock */

will unlock what?

> +	hi = kzalloc(sizeof(*hi), GFP_KERNEL);
> +	if (hi == NULL)
> +		return NULL;
> +
> +	hi->fd = -1;
> +	inode_init_once(&hi->vfs_inode);
> +	return &hi->vfs_inode;

Umm...  kzalloc() looks odd, seeing that you proceed to initialize two
fields out of 3 (including the really big one) explicitly...

> +static int open_dir(char *path, struct da_finddata *finddata, int *fserrno)
> +{
> +	int len = strlen(path);
> +	char buf[len + 3];

Bad idea, considering that strlen(path) is user-controlled and can
theoretically go up to 4Kb...

> +static int dafs_readdir(struct file *file, void *ent, filldir_t filldir)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;

minor nit, but... that's file_inode(file)

> +	name = dentry_name(file->f_path.dentry);
> +	if (name == NULL)
> +		return -ENOMEM;
> +	handle = open_dir(name, &finddata, &fserrno);

... and what if the sucker's parent gets renamed between dentry_name() and
open_dir()?  The same goes for the rest of dentry_name() users, actually.

> +static int dafs_rename(struct inode *from_ino, struct dentry *from,
> +		  struct inode *to_ino, struct dentry *to)
> +{
> +	char *from_name, *to_name;
> +	int err;
> +
> +	from_name = dentry_name(from);
> +	if (from_name == NULL)
> +		return -ENOMEM;
> +	to_name = dentry_name(to);
> +	if (to_name == NULL) {
> +		__putname(from_name);
> +		return -ENOMEM;
> +	}
> +	err = -EINVAL;
> +	__putname(from_name);
> +	__putname(to_name);
> +	return err;
> +}

Aha.  No rename(2), IOW.  Is one planned?
