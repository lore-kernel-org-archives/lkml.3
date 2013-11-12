Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3KLQw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:52:57 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:41756 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab3KLQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:52:55 -0500
Date: Tue, 12 Nov 2013 17:52:51 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Subject: Re: [PATCH 05/11] fuse: Trust kernel i_mtime only -v2
Message-ID: <20131112165251.GA10813@tucsk.piliscsaba.szeredi.hu>
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
 <20131010131051.10089.62357.stgit@dhcp-10-30-17-2.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010131051.10089.62357.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 05:10:56PM +0400, Maxim Patlasov wrote:
> Let the kernel maintain i_mtime locally:
>  - clear S_NOCMTIME
>  - implement i_op->update_time()
>  - flush mtime on fsync and last close
>  - update i_mtime explicitly on truncate and fallocate
> 
> Fuse inode flag FUSE_I_MTIME_DIRTY serves as indication that local i_mtime
> should be flushed to the server eventually.
> 
> Changed in v2 (thanks to Brian):
>  - renamed FUSE_I_MTIME_UPDATED to FUSE_I_MTIME_DIRTY
>  - simplified fuse_set_mtime_local()
>  - abandoned optimizations: clearing the flag on some operations (like
>    direct write) is doable, but may lead to unexpected changes of
>    user-visible mtime.
> 
> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
> ---
>  fs/fuse/dir.c    |  109 ++++++++++++++++++++++++++++++++++++++++++++++++------
>  fs/fuse/file.c   |   30 +++++++++++++--
>  fs/fuse/fuse_i.h |    6 ++-
>  fs/fuse/inode.c  |   13 +++++-
>  4 files changed, 138 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index f022968..eda248b 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -857,8 +857,11 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  
>  	/* see the comment in fuse_change_attributes() */
> -	if (fc->writeback_cache && S_ISREG(inode->i_mode))
> +	if (fc->writeback_cache && S_ISREG(inode->i_mode)) {
>  		attr->size = i_size_read(inode);
> +		attr->mtime = inode->i_mtime.tv_sec;
> +		attr->mtimensec = inode->i_mtime.tv_nsec;
> +	}
>  
>  	stat->dev = inode->i_sb->s_dev;
>  	stat->ino = attr->ino;
> @@ -1582,6 +1585,82 @@ void fuse_release_nowrite(struct inode *inode)
>  	spin_unlock(&fc->lock);
>  }
>  
> +static void fuse_setattr_fill(struct fuse_conn *fc, struct fuse_req *req,
> +			      struct inode *inode,
> +			      struct fuse_setattr_in *inarg_p,
> +			      struct fuse_attr_out *outarg_p)
> +{
> +	req->in.h.opcode = FUSE_SETATTR;
> +	req->in.h.nodeid = get_node_id(inode);
> +	req->in.numargs = 1;
> +	req->in.args[0].size = sizeof(*inarg_p);
> +	req->in.args[0].value = inarg_p;
> +	req->out.numargs = 1;
> +	if (fc->minor < 9)
> +		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
> +	else
> +		req->out.args[0].size = sizeof(*outarg_p);
> +	req->out.args[0].value = outarg_p;
> +}
> +
> +/*
> + * Flush inode->i_mtime to the server
> + */
> +int fuse_flush_mtime(struct file *file, bool nofail)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +	struct fuse_inode *fi = get_fuse_inode(inode);
> +	struct fuse_conn *fc = get_fuse_conn(inode);
> +	struct fuse_req *req = NULL;
> +	struct fuse_setattr_in inarg;
> +	struct fuse_attr_out outarg;
> +	int err;
> +
> +	if (nofail) {
> +		req = fuse_get_req_nofail_nopages(fc, file);
> +	} else {
> +		req = fuse_get_req_nopages(fc);
> +		if (IS_ERR(req))
> +			return PTR_ERR(req);
> +	}
> +
> +	memset(&inarg, 0, sizeof(inarg));
> +	memset(&outarg, 0, sizeof(outarg));
> +
> +	inarg.valid |= FATTR_MTIME;
> +	inarg.mtime = inode->i_mtime.tv_sec;
> +	inarg.mtimensec = inode->i_mtime.tv_nsec;
> +
> +	fuse_setattr_fill(fc, req, inode, &inarg, &outarg);
> +	fuse_request_send(fc, req);
> +	err = req->out.h.error;
> +	fuse_put_request(fc, req);
> +
> +	if (!err)
> +		clear_bit(FUSE_I_MTIME_DIRTY, &fi->state);

Doing the test and the clear separately opens a huge race window when i_mtime
modifications are bound to get lost.

> +
> +	return err;
> +}
> +
> +/*
> + * S_NOCMTIME is clear, so we need to update inode->i_mtime manually.
> + */
> +static void fuse_set_mtime_local(struct iattr *iattr, struct inode *inode)
> +{
> +	unsigned ivalid = iattr->ia_valid;
> +	struct fuse_inode *fi = get_fuse_inode(inode);
> +
> +	if ((ivalid & ATTR_MTIME) && (ivalid & ATTR_MTIME_SET)) {
> +		/* client fs has just set mtime to iattr->ia_mtime */
> +		inode->i_mtime = iattr->ia_mtime;
> +		clear_bit(FUSE_I_MTIME_DIRTY, &fi->state);

This is protected by i_mutex, so it should be safe.

> +	} else if ((ivalid & ATTR_MTIME) || (ivalid & ATTR_SIZE)) {
> +		/* client fs doesn't know that we're updating i_mtime */

If so, why not tell the client fs to update mtime?

> +		inode->i_mtime = current_fs_time(inode->i_sb);
> +		set_bit(FUSE_I_MTIME_DIRTY, &fi->state);
> +	}
> +}
> +
>  /*
>   * Set attributes, and at the same time refresh them.
>   *
> @@ -1641,17 +1720,7 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
>  		inarg.valid |= FATTR_LOCKOWNER;
>  		inarg.lock_owner = fuse_lock_owner_id(fc, current->files);
>  	}
> -	req->in.h.opcode = FUSE_SETATTR;
> -	req->in.h.nodeid = get_node_id(inode);
> -	req->in.numargs = 1;
> -	req->in.args[0].size = sizeof(inarg);
> -	req->in.args[0].value = &inarg;
> -	req->out.numargs = 1;
> -	if (fc->minor < 9)
> -		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
> -	else
> -		req->out.args[0].size = sizeof(outarg);
> -	req->out.args[0].value = &outarg;
> +	fuse_setattr_fill(fc, req, inode, &inarg, &outarg);
>  	fuse_request_send(fc, req);
>  	err = req->out.h.error;
>  	fuse_put_request(fc, req);
> @@ -1668,6 +1737,10 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
>  	}
>  
>  	spin_lock(&fc->lock);
> +	/* the kernel maintains i_mtime locally */
> +	if (fc->writeback_cache && S_ISREG(inode->i_mode))
> +		fuse_set_mtime_local(attr, inode);
> +
>  	fuse_change_attributes_common(inode, &outarg.attr,
>  				      attr_timeout(&outarg));
>  	oldsize = inode->i_size;
> @@ -1898,6 +1971,17 @@ static int fuse_removexattr(struct dentry *entry, const char *name)
>  	return err;
>  }
>  
> +static int fuse_update_time(struct inode *inode, struct timespec *now,
> +			    int flags)
> +{
> +	if (flags & S_MTIME) {
> +		inode->i_mtime = *now;
> +		set_bit(FUSE_I_MTIME_DIRTY, &get_fuse_inode(inode)->state);
> +		BUG_ON(!S_ISREG(inode->i_mode));
> +	}
> +	return 0;
> +}
> +
>  static const struct inode_operations fuse_dir_inode_operations = {
>  	.lookup		= fuse_lookup,
>  	.mkdir		= fuse_mkdir,
> @@ -1937,6 +2021,7 @@ static const struct inode_operations fuse_common_inode_operations = {
>  	.getxattr	= fuse_getxattr,
>  	.listxattr	= fuse_listxattr,
>  	.removexattr	= fuse_removexattr,
> +	.update_time	= fuse_update_time,
>  };
>  
>  static const struct inode_operations fuse_symlink_inode_operations = {
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 333a764..eabe202 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -291,6 +291,9 @@ static int fuse_open(struct inode *inode, struct file *file)
>  
>  static int fuse_release(struct inode *inode, struct file *file)
>  {
> +	if (test_bit(FUSE_I_MTIME_DIRTY, &get_fuse_inode(inode)->state))

So, why not make this test_and_clear_bit()?


> +		fuse_flush_mtime(file, true);
> +
>  	fuse_release_common(file, FUSE_RELEASE);
>  
>  	/* return value is ignored by VFS */
> @@ -458,6 +461,12 @@ int fuse_fsync_common(struct file *file, loff_t start, loff_t end,
>  
>  	fuse_sync_writes(inode);
>  
> +	if (test_bit(FUSE_I_MTIME_DIRTY, &get_fuse_inode(inode)->state)) {

And this too.

> +		int err = fuse_flush_mtime(file, false);
> +		if (err)
> +			goto out;
> +	}
> +
>  	req = fuse_get_req_nopages(fc);
>  	if (IS_ERR(req)) {
>  		err = PTR_ERR(req);
> @@ -948,16 +957,21 @@ static size_t fuse_send_write(struct fuse_req *req, struct fuse_io_priv *io,
>  	return req->misc.write.out.size;
>  }
>  
> -void fuse_write_update_size(struct inode *inode, loff_t pos)
> +bool fuse_write_update_size(struct inode *inode, loff_t pos)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  	struct fuse_inode *fi = get_fuse_inode(inode);
> +	bool ret = false;
>  
>  	spin_lock(&fc->lock);
>  	fi->attr_version = ++fc->attr_version;
> -	if (pos > inode->i_size)
> +	if (pos > inode->i_size) {
>  		i_size_write(inode, pos);
> +		ret = true;
> +	}
>  	spin_unlock(&fc->lock);
> +
> +	return ret;
>  }
>  
>  static size_t fuse_send_write_pages(struct fuse_req *req, struct file *file,
> @@ -2862,8 +2876,16 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
>  		goto out;
>  
>  	/* we could have extended the file */
> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
> -		fuse_write_update_size(inode, offset + length);
> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
> +		bool changed = fuse_write_update_size(inode, offset + length);
> +
> +		if (changed && fc->writeback_cache) {
> +			struct fuse_inode *fi = get_fuse_inode(inode);
> +
> +			inode->i_mtime = current_fs_time(inode->i_sb);
> +			set_bit(FUSE_I_MTIME_DIRTY, &fi->state);
> +		}
> +	}
>  
>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>  		truncate_pagecache_range(inode, offset, offset + length - 1);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index a490ba3..3028b8a 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -117,6 +117,8 @@ enum {
>  	FUSE_I_ADVISE_RDPLUS,
>  	/** An operation changing file size is in progress  */
>  	FUSE_I_SIZE_UNSTABLE,
> +	/** i_mtime has been updated locally; a flush to userspace needed */
> +	FUSE_I_MTIME_DIRTY,
>  };
>  
>  struct fuse_conn;
> @@ -870,7 +872,9 @@ long fuse_ioctl_common(struct file *file, unsigned int cmd,
>  unsigned fuse_file_poll(struct file *file, poll_table *wait);
>  int fuse_dev_release(struct inode *inode, struct file *file);
>  
> -void fuse_write_update_size(struct inode *inode, loff_t pos);
> +bool fuse_write_update_size(struct inode *inode, loff_t pos);
> +
> +int fuse_flush_mtime(struct file *file, bool nofail);
>  
>  int fuse_do_setattr(struct inode *inode, struct iattr *attr,
>  		    struct file *file);
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 63818ab..253701f 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -170,8 +170,11 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
>  	inode->i_blocks  = attr->blocks;
>  	inode->i_atime.tv_sec   = attr->atime;
>  	inode->i_atime.tv_nsec  = attr->atimensec;
> -	inode->i_mtime.tv_sec   = attr->mtime;
> -	inode->i_mtime.tv_nsec  = attr->mtimensec;
> +	/* mtime from server may be stale due to local buffered write */
> +	if (!fc->writeback_cache || !S_ISREG(inode->i_mode)) {
> +		inode->i_mtime.tv_sec   = attr->mtime;
> +		inode->i_mtime.tv_nsec  = attr->mtimensec;
> +	}
>  	inode->i_ctime.tv_sec   = attr->ctime;
>  	inode->i_ctime.tv_nsec  = attr->ctimensec;
>  
> @@ -250,6 +253,8 @@ static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
>  {
>  	inode->i_mode = attr->mode & S_IFMT;
>  	inode->i_size = attr->size;
> +	inode->i_mtime.tv_sec  = attr->mtime;
> +	inode->i_mtime.tv_nsec = attr->mtimensec;
>  	if (S_ISREG(inode->i_mode)) {
>  		fuse_init_common(inode);
>  		fuse_init_file_inode(inode);
> @@ -296,7 +301,9 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
>  		return NULL;
>  
>  	if ((inode->i_state & I_NEW)) {
> -		inode->i_flags |= S_NOATIME|S_NOCMTIME;
> +		inode->i_flags |= S_NOATIME;
> +		if (!fc->writeback_cache)
> +			inode->i_flags |= S_NOCMTIME;
>  		inode->i_generation = generation;
>  		inode->i_data.backing_dev_info = &fc->bdi;
>  		fuse_init_inode(inode, attr);
> 
