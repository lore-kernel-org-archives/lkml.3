Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaBKVXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:23:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbaBKVXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:23:48 -0500
Date: Tue, 11 Feb 2014 22:23:46 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: Re: [PATCH 12/13] ext4: add cross rename support
Message-ID: <20140211212346.GF22835@quack.suse.cz>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <1391791751-2533-13-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391791751-2533-13-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-02-14 17:49:10, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Implement RENAME_EXCHANGE flag in renameat2 syscall.
  Hum, I guess the nice symmetry of ext4_cross_rename() outweights the code
duplication. So you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/ext4/namei.c | 139 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 138 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 75f1bde43dcc..1cb84f78909e 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3004,6 +3004,8 @@ struct ext4_renament {
>  	struct inode *dir;
>  	struct dentry *dentry;
>  	struct inode *inode;
> +	bool is_dir;
> +	int dir_nlink_delta;
>  
>  	/* entry for "dentry" */
>  	struct buffer_head *bh;
> @@ -3135,6 +3137,17 @@ static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent)
>  	}
>  }
>  
> +static void ext4_update_dir_count(handle_t *handle, struct ext4_renament *ent)
> +{
> +	if (ent->dir_nlink_delta) {
> +		if (ent->dir_nlink_delta == -1)
> +			ext4_dec_count(handle, ent->dir);
> +		else
> +			ext4_inc_count(handle, ent->dir);
> +		ext4_mark_inode_dirty(handle, ent->dir);
> +	}
> +}
> +
>  /*
>   * Anybody can rename anything with this: the permission checks are left to the
>   * higher-level routines.
> @@ -3274,13 +3287,137 @@ end_rename:
>  	return retval;
>  }
>  
> +static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
> +			     struct inode *new_dir, struct dentry *new_dentry)
> +{
> +	handle_t *handle = NULL;
> +	struct ext4_renament old = {
> +		.dir = old_dir,
> +		.dentry = old_dentry,
> +		.inode = old_dentry->d_inode,
> +	};
> +	struct ext4_renament new = {
> +		.dir = new_dir,
> +		.dentry = new_dentry,
> +		.inode = new_dentry->d_inode,
> +	};
> +	u8 new_file_type;
> +	int retval;
> +
> +	dquot_initialize(old.dir);
> +	dquot_initialize(new.dir);
> +
> +	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name,
> +				 &old.de, &old.inlined);
> +	/*
> +	 *  Check for inode number is _not_ due to possible IO errors.
> +	 *  We might rmdir the source, keep it as pwd of some process
> +	 *  and merrily kill the link to whatever was created under the
> +	 *  same name. Goodbye sticky bit ;-<
> +	 */
> +	retval = -ENOENT;
> +	if (!old.bh || le32_to_cpu(old.de->inode) != old.inode->i_ino)
> +		goto end_rename;
> +
> +	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
> +				 &new.de, &new.inlined);
> +
> +	/* RENAME_EXCHANGE case: old *and* new must both exist */
> +	if (!new.bh || le32_to_cpu(new.de->inode) != new.inode->i_ino)
> +		goto end_rename;
> +
> +	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
> +		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
> +		 2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
> +		ext4_handle_sync(handle);
> +
> +	if (S_ISDIR(old.inode->i_mode)) {
> +		old.is_dir = true;
> +		retval = ext4_rename_dir_prepare(handle, &old);
> +		if (retval)
> +			goto end_rename;
> +	}
> +	if (S_ISDIR(new.inode->i_mode)) {
> +		new.is_dir = true;
> +		retval = ext4_rename_dir_prepare(handle, &new);
> +		if (retval)
> +			goto end_rename;
> +	}
> +
> +	/*
> +	 * Other than the special case of overwriting a directory, parents'
> +	 * nlink only needs to be modified if this is a cross directory rename.
> +	 */
> +	if (old.dir != new.dir && old.is_dir != new.is_dir) {
> +		old.dir_nlink_delta = old.is_dir ? -1 : 1;
> +		new.dir_nlink_delta = -old.dir_nlink_delta;
> +		retval = -EMLINK;
> +		if ((old.dir_nlink_delta > 0 && EXT4_DIR_LINK_MAX(old.dir)) ||
> +		    (new.dir_nlink_delta > 0 && EXT4_DIR_LINK_MAX(new.dir)))
> +			goto end_rename;
> +	}
> +
> +	new_file_type = new.de->file_type;
> +	retval = ext4_setent(handle, &new, old.inode->i_ino, old.de->file_type);
> +	if (retval)
> +		goto end_rename;
> +
> +	retval = ext4_setent(handle, &old, new.inode->i_ino, new_file_type);
> +	if (retval)
> +		goto end_rename;
> +
> +	/*
> +	 * Like most other Unix systems, set the ctime for inodes on a
> +	 * rename.
> +	 */
> +	old.inode->i_ctime = ext4_current_time(old.inode);
> +	new.inode->i_ctime = ext4_current_time(new.inode);
> +	ext4_mark_inode_dirty(handle, old.inode);
> +	ext4_mark_inode_dirty(handle, new.inode);
> +
> +	if (old.dir_bh) {
> +		retval = ext4_rename_dir_finish(handle, &old, new.dir->i_ino);
> +		if (retval)
> +			goto end_rename;
> +	}
> +	if (new.dir_bh) {
> +		retval = ext4_rename_dir_finish(handle, &new, old.dir->i_ino);
> +		if (retval)
> +			goto end_rename;
> +	}
> +	ext4_update_dir_count(handle, &old);
> +	ext4_update_dir_count(handle, &new);
> +	retval = 0;
> +
> +end_rename:
> +	brelse(old.dir_bh);
> +	brelse(new.dir_bh);
> +	brelse(old.bh);
> +	brelse(new.bh);
> +	if (handle)
> +		ext4_journal_stop(handle);
> +	return retval;
> +}
> +
>  static int ext4_rename2(struct inode *old_dir, struct dentry *old_dentry,
>  			struct inode *new_dir, struct dentry *new_dentry,
>  			unsigned int flags)
>  {
> -	if (flags & ~RENAME_NOREPLACE)
> +	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
>  		return -EINVAL;
>  
> +	if (flags & RENAME_EXCHANGE) {
> +		return ext4_cross_rename(old_dir, old_dentry,
> +					 new_dir, new_dentry);
> +	}
> +	/*
> +	 * Existence checking was done by the VFS, otherwise "RENAME_NOREPLACE"
> +	 * is equivalent to regular rename.
> +	 */
>  	return ext4_rename(old_dir, old_dentry, new_dir, new_dentry);
>  }
>  
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
