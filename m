Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaAMMZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:25:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbaAMMZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:25:21 -0500
Date: Mon, 13 Jan 2014 13:25:17 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Message-ID: <20140113122517.GA10366@quack.suse.cz>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-12-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389219015-10980-12-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-01-14 23:10:15, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Implement RENAME_EXCHANGE flag in renameat2 syscall.
  Yes, this is much better than last time. Thanks for the work. You can add
Reviewed-by: Jan Kara <jack@suse.cz>

One nitpick below...
 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/ext4/namei.c | 121 ++++++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 87 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 7147d08a43a2..e4513ba7ed99 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3005,6 +3005,8 @@ struct ext4_renament {
>  	struct inode *dir;
>  	struct dentry *dentry;
>  	struct inode *inode;
> +	bool is_dir;
> +	int dir_nlink_delta;
>  
>  	/* entry for "dentry" */
>  	struct buffer_head *bh;
> @@ -3136,6 +3138,14 @@ static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent)
>  	}
>  }
>  
> +static void ext4_update_dir_count(handle_t *handle, struct ext4_renament *ent)
> +{
> +	if (ent->dir_nlink_delta == -1)
> +		ext4_dec_count(handle, ent->dir);
> +	else if (ent->dir_nlink_delta == 1)
> +		ext4_inc_count(handle, ent->dir);
> +}
> +
>  /*
>   * Anybody can rename anything with this: the permission checks are left to the
>   * higher-level routines.
> @@ -3161,7 +3171,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	};
>  	int retval;
>  
> -	if (flags & ~RENAME_NOREPLACE)
> +	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
>  		return -EOPNOTSUPP;
>  
>  	dquot_initialize(old.dir);
> @@ -3169,10 +3179,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  
>  	/* Initialize quotas before so that eventual writes go
>  	 * in separate transaction */
> -	if (new.inode)
> +	if (!(flags & RENAME_EXCHANGE) && new.inode)
>  		dquot_initialize(new.inode);
>  
> -	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
> +	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name,
> +				 &old.de, &old.inlined);
>  	/*
>  	 *  Check for inode number is _not_ due to possible IO errors.
>  	 *  We might rmdir the source, keep it as pwd of some process
> @@ -3185,18 +3196,22 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  
>  	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
>  				 &new.de, &new.inlined);
> -	if (new.bh) {
> -		if (!new.inode) {
> -			brelse(new.bh);
> -			new.bh = NULL;
> +	if (!(flags & RENAME_EXCHANGE)) {
> +		if (new.bh) {
> +			if (!new.inode) {
> +				brelse(new.bh);
> +				new.bh = NULL;
> +			}
>  		}
> +		if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
> +			ext4_alloc_da_blocks(old.inode);
> +	} else if (!new.bh || le32_to_cpu(new.de->inode) != new.inode->i_ino) {
> +		goto end_rename;
>  	}
  I think this deserves a comment that RENAME_EXCHANGE expects both source
and target to exist... I'm always pondering about this condition before I
realize that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
