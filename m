Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3JCCW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 22:22:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41343 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3JCCW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 22:22:57 -0400
Date: Thu, 3 Oct 2013 03:22:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@osdl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: [rfc] rework aio migrate pages to use aio fs
Message-ID: <20131003022251.GB13318@ZenIV.linux.org.uk>
References: <20130913165937.GL2517@kvack.org>
 <20130913184204.GS13318@ZenIV.linux.org.uk>
 <20130917141825.GF11526@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917141825.GF11526@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:18:25AM -0400, Benjamin LaHaise wrote:
> +static int aio_set_page_dirty(struct page *page)
> +{
> +	return 0;
> +};
> +
> +static const struct address_space_operations aio_aops = {
> +	.set_page_dirty = aio_set_page_dirty,
> +};
> +
> +/*
> + * A single inode exists for each aio_inode file.  The inodes are only
> + * used for mapping the event ring buffers in order to make it possible
> + * to provide migration ops to the vm.
> + */
> +static struct inode *aio_inode_mkinode(struct super_block *s)
> +{
> +	struct inode *inode = new_inode_pseudo(s);
> +
> +	if (!inode)
> +		return ERR_PTR(-ENOMEM);
> +
> +	inode->i_ino = get_next_ino();
> +	inode->i_fop = &aio_ring_fops;
> +	inode->i_mapping->a_ops = &aio_aops;
> +
> +	/*
> +	 * Mark the inode dirty from the very beginning,
> +	 * that way it will never be moved to the dirty
> +	 * list because mark_inode_dirty() will think
> +	 * that it already _is_ on the dirty list.
> +	 */
> +	inode->i_state = I_DIRTY;
> +	inode->i_mode = S_IRUSR | S_IWUSR;
> +	inode->i_uid = current_fsuid();
> +	inode->i_gid = current_fsgid();
> +	inode->i_flags |= S_PRIVATE;
> +	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	return inode;
> +}

FWIW, I would've taken that to fs/libfs.c, sans the assignment of ->i_fop.
BTW, are you sure that you want it to be opened via procfs symlink?  Is that
even possible?  IOW, what's that ->i_fop for?

> +struct file *aio_inode_getfile_private(const char *name,
> +				       const struct file_operations *fops,
> +				       void *priv, int flags)

Why is it not static?  And why bother with fops as argument, etc.?

> +	if (fops->owner && !try_module_get(fops->owner))
> +		return ERR_PTR(-ENOENT);

Also pointless, AFAICS.  BTW, you've just open-coded fops_get(fops), not
that it mattered in this case...

> +	inode = aio_inode_mkinode(aio_mnt->mnt_sb);
> +	if (IS_ERR(inode)) {
> +		file = ERR_PTR(-ENOMEM);
> +		goto err_module;
> +	}
> +
> +	/*
> +	 * Link the inode to a directory entry by creating a unique name
> +	 * using the inode sequence number.
> +	 */
> +	file = ERR_PTR(-ENOMEM);
> +	this.name = name;
> +	this.len = strlen(name);
> +	this.hash = 0;

Umm...  ITYM
	struct qstr this = QSTR_INIT("[aio]", 5);
, if not
	path.dentry = d_alloc_pseudo(aio_mnt->mnt_sb,
				     &(struct qstr)QSTR_INIT("[aio]", 5));
> +	if (!path.dentry)
> +		goto err_module;
> +
> +	path.mnt = mntget(aio_mnt);
> +
> +	d_instantiate(path.dentry, inode);
> +
> +	file = alloc_file(&path, OPEN_FMODE(flags), fops);
> +	if (IS_ERR(file))
> +		goto err_dput;

> +	file->f_mapping = inode->i_mapping;

Pointless, BTW - alloc_file() will have already set it that way.

> +	file->f_flags = flags & (O_ACCMODE | O_NONBLOCK);
> +	file->private_data = priv;
> +
> +	return file;
> +
> +err_dput:
> +	path_put(&path);
> +err_module:
> +	module_put(fops->owner);

And that module_put is pointless as well here.
