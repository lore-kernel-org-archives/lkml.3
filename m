Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaANKeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:34:21 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:54802 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaANKeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:34:18 -0500
Date: Tue, 14 Jan 2014 11:35:09 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Jan Kara <jack@suse.cz>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Message-ID: <20140114103509.GB24171@tucsk.piliscsaba.szeredi.hu>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-12-git-send-email-miklos@szeredi.hu>
 <20140113122517.GA10366@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113122517.GA10366@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 01:25:17PM +0100, Jan Kara wrote:
> On Wed 08-01-14 23:10:15, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Implement RENAME_EXCHANGE flag in renameat2 syscall.
>   Yes, this is much better than last time. Thanks for the work. You can add
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> One nitpick below...

> > @@ -3185,18 +3196,22 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
> >  
> >  	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
> >  				 &new.de, &new.inlined);
> > -	if (new.bh) {
> > -		if (!new.inode) {
> > -			brelse(new.bh);
> > -			new.bh = NULL;
> > +	if (!(flags & RENAME_EXCHANGE)) {
> > +		if (new.bh) {
> > +			if (!new.inode) {
> > +				brelse(new.bh);
> > +				new.bh = NULL;
> > +			}
> >  		}
> > +		if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
> > +			ext4_alloc_da_blocks(old.inode);
> > +	} else if (!new.bh || le32_to_cpu(new.de->inode) != new.inode->i_ino) {
> > +		goto end_rename;
> >  	}
>   I think this deserves a comment that RENAME_EXCHANGE expects both source
> and target to exist... I'm always pondering about this condition before I
> realize that.

Okay, added.

Updated patch follows.

Thanks,
Miklos
----

Subject: ext4: add cross rename support
From: Miklos Szeredi <mszeredi@suse.cz>

Implement RENAME_EXCHANGE flag in renameat2 syscall.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c |  122 ++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 88 insertions(+), 34 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3005,6 +3005,8 @@ struct ext4_renament {
 	struct inode *dir;
 	struct dentry *dentry;
 	struct inode *inode;
+	bool is_dir;
+	int dir_nlink_delta;
 
 	/* entry for "dentry" */
 	struct buffer_head *bh;
@@ -3136,6 +3138,14 @@ static void ext4_rename_delete(handle_t
 	}
 }
 
+static void ext4_update_dir_count(handle_t *handle, struct ext4_renament *ent)
+{
+	if (ent->dir_nlink_delta == -1)
+		ext4_dec_count(handle, ent->dir);
+	else if (ent->dir_nlink_delta == 1)
+		ext4_inc_count(handle, ent->dir);
+}
+
 /*
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
@@ -3161,7 +3171,7 @@ static int ext4_rename(struct inode *old
 	};
 	int retval;
 
-	if (flags & ~RENAME_NOREPLACE)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EOPNOTSUPP;
 
 	dquot_initialize(old.dir);
@@ -3169,10 +3179,11 @@ static int ext4_rename(struct inode *old
 
 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
-	if (new.inode)
+	if (!(flags & RENAME_EXCHANGE) && new.inode)
 		dquot_initialize(new.inode);
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name,
+				 &old.de, &old.inlined);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -3185,18 +3196,23 @@ static int ext4_rename(struct inode *old
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
 				 &new.de, &new.inlined);
-	if (new.bh) {
-		if (!new.inode) {
-			brelse(new.bh);
-			new.bh = NULL;
+	if (!(flags & RENAME_EXCHANGE)) {
+		if (new.bh) {
+			if (!new.inode) {
+				brelse(new.bh);
+				new.bh = NULL;
+			}
 		}
+		if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
+			ext4_alloc_da_blocks(old.inode);
+	} else if (!new.bh || le32_to_cpu(new.de->inode) != new.inode->i_ino) {
+		/* RENAME_EXCHANGE case: old *and* new must both exist */
+		goto end_rename;
 	}
-	if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
-		ext4_alloc_da_blocks(old.inode);
 
 	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
 		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
-		 EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
+		 2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -3204,28 +3220,61 @@ static int ext4_rename(struct inode *old
 		ext4_handle_sync(handle);
 
 	if (S_ISDIR(old.inode->i_mode)) {
-		if (new.inode) {
+		old.is_dir = true;
+		if (!(flags & RENAME_EXCHANGE) && new.inode) {
 			retval = -ENOTEMPTY;
 			if (!empty_dir(new.inode))
 				goto end_rename;
-		} else {
-			retval = -EMLINK;
-			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
-				goto end_rename;
+
+			/*
+			 * Overwriting a directory needs to decrement nlink of
+			 * old parent (even if not cross directory rename).
+			 */
+			old.dir_nlink_delta = -1;
 		}
 		retval = ext4_rename_dir_prepare(handle, &old);
 		if (retval)
 			goto end_rename;
 	}
+	if (new.inode && S_ISDIR(new.inode->i_mode)) {
+		new.is_dir = true;
+		if (flags & RENAME_EXCHANGE) {
+			retval = ext4_rename_dir_prepare(handle, &new);
+			if (retval)
+				goto end_rename;
+		}
+	}
+
+	/*
+	 * Other than the special case of overwring a directory, parents' nlink
+	 * only needs to be modified if this is a cross directory rename.
+	 */
+	if (old.dir != new.dir && old.is_dir != new.is_dir) {
+		old.dir_nlink_delta = old.is_dir ? -1 : 1;
+		new.dir_nlink_delta = -old.dir_nlink_delta;
+		retval = -EMLINK;
+		if ((old.dir_nlink_delta > 0 && EXT4_DIR_LINK_MAX(old.dir)) ||
+		    (new.dir_nlink_delta > 0 && EXT4_DIR_LINK_MAX(new.dir)))
+			goto end_rename;
+	}
+
 	if (!new.bh) {
 		retval = ext4_add_entry(handle, new.dentry, old.inode);
 		if (retval)
 			goto end_rename;
 	} else {
+		u8 new_file_type = new.de->file_type;
 		retval = ext4_setent(handle, &new,
 				     old.inode->i_ino, old.de->file_type);
 		if (retval)
 			goto end_rename;
+
+		if (flags & RENAME_EXCHANGE) {
+			retval = ext4_setent(handle, &old,
+					     new.inode->i_ino, new_file_type);
+			if (retval)
+				goto end_rename;
+		}
 	}
 
 	/*
@@ -3235,35 +3284,40 @@ static int ext4_rename(struct inode *old
 	old.inode->i_ctime = ext4_current_time(old.inode);
 	ext4_mark_inode_dirty(handle, old.inode);
 
-	/*
-	 * ok, that's it
-	 */
-	ext4_rename_delete(handle, &old);
+	if (!(flags & RENAME_EXCHANGE)) {
+		/*
+		 * ok, that's it
+		 */
+		ext4_rename_delete(handle, &old);
 
-	if (new.inode) {
-		ext4_dec_count(handle, new.inode);
-		new.inode->i_ctime = ext4_current_time(new.inode);
+		old.dir->i_ctime = old.dir->i_mtime = ext4_current_time(old.dir);
+		ext4_update_dx_flag(old.dir);
 	}
-	old.dir->i_ctime = old.dir->i_mtime = ext4_current_time(old.dir);
-	ext4_update_dx_flag(old.dir);
 	if (old.dir_bh) {
 		retval = ext4_rename_dir_finish(handle, &old, new.dir->i_ino);
 		if (retval)
 			goto end_rename;
-
-		ext4_dec_count(handle, old.dir);
-		if (new.inode) {
+	}
+	if (new.dir_bh) {
+		retval = ext4_rename_dir_finish(handle, &new, old.dir->i_ino);
+		if (retval)
+			goto end_rename;
+	}
+	ext4_update_dir_count(handle, &old);
+	ext4_update_dir_count(handle, &new);
+	if (!new.inode)
+		ext4_update_dx_flag(new.dir);
+	if (new.dir_nlink_delta || !new.inode)
+		ext4_mark_inode_dirty(handle, new.dir);
+	ext4_mark_inode_dirty(handle, old.dir);
+	if (!(flags & RENAME_EXCHANGE) && new.inode) {
+		ext4_dec_count(handle, new.inode);
+		new.inode->i_ctime = ext4_current_time(new.inode);
+		if (S_ISDIR(old.inode->i_mode)) {
 			/* checked empty_dir above, can't have another parent,
 			 * ext4_dec_count() won't work for many-linked dirs */
 			clear_nlink(new.inode);
-		} else {
-			ext4_inc_count(handle, new.dir);
-			ext4_update_dx_flag(new.dir);
-			ext4_mark_inode_dirty(handle, new.dir);
 		}
-	}
-	ext4_mark_inode_dirty(handle, old.dir);
-	if (new.inode) {
 		ext4_mark_inode_dirty(handle, new.inode);
 		if (!new.inode->i_nlink)
 			ext4_orphan_add(handle, new.inode);
