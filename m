Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaBXRLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:11:25 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33041 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaBXRLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:11:20 -0500
Date: Mon, 24 Feb 2014 18:12:38 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: [PATCH 00/13] cross rename v4
Message-ID: <20140224171238.GG4026@tucsk.piliscsaba.szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <19258.1392306854@warthog.procyon.org.uk>
 <20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu>
 <20106.1392309770@warthog.procyon.org.uk>
 <CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com>
 <CA+55aFxE+v-RpHd1zNdw4COrkXmdT5btuE6Xei4oyeWSzeGHLw@mail.gmail.com>
 <16729.1392318161@warthog.procyon.org.uk>
 <CA+55aFyT9_XSFQwv82Qwv5US7QMOvW8RhbsxOa8B2mm3MChWLA@mail.gmail.com>
 <CAJfpegsDG-NoqvYog5PWqR=XOQgT0dSOTsjDwhd8v11T0kiEVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsDG-NoqvYog5PWqR=XOQgT0dSOTsjDwhd8v11T0kiEVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 09:28:50PM +0100, Miklos Szeredi wrote:
> On Thu, Feb 13, 2014 at 8:32 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:

> > (I do think we should allow creation - but for root only - for
> > management and testing purposes, but I really think it's a secondary
> > issue, and I do think we should literally use "mknod()" - either with
> > a new S_IFWHT or even just making use of existing S_IFCHR just so you
> > could use the user-space "mknod" to create it with some magic
> > major/minor combination.
> 
> And IMO the magic S_IFCHR is a lot better in many respects than a new
> filetype, since now all backup tools automatically work.  And I think
> that's a lot more important than looking like a nice new design.
> Sure, if S_IFWHT was there from the start, it would be wonderful.  But
> as it stands, it's a lot more difficult to add support for such a
> thing to userspace than adding a hack, using the existing intefaces,
> to the kernel.

And here's a patch to actually implement the "rename and whiteout source"
operation.

Jan, I suspect that the "credits" calculation for the number of journal blocks
is excessive, since here we don't actually need to create the directory entry,
only create the inode and populate an already existing entry.  But I don't
undestand the logic of ext4 enough to see what's the right number to use here.

And another ext4 specific question: I added ext4_setent(old, whiteout) before
ext4_add_entry(new, old.inode) because I suspect from the comment in
ext4_rename_delete() that ext4_add_entry() invalidates the looked up entry.  Is
that correct?  Are there any other traps in this area to look out for?

Thanks,
Miklos

----
Subject: vfs: add RENAME_WHITEOUT
From: Miklos Szeredi <mszeredi@suse.cz>

This adds a new RENAME_WHITEOUT flag.  This flag makes rename() create a
whiteout of source.  The whiteout creation is atomic relative to the
rename.

As Linus' suggestion, a whiteout is represented as a dummy char device.
This patch uses the 0/0 device number, but the actual number doesn't matter
as long as it doesn't conflict with a real device.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ext4/namei.c         |   69 ++++++++++++++++++++++++++++++++++++++----------
 fs/namei.c              |    8 ++++-
 include/linux/fs.h      |    7 ++++
 include/uapi/linux/fs.h |    1 
 4 files changed, 70 insertions(+), 15 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3157,7 +3157,8 @@ static void ext4_update_dir_count(handle
  * This comes from rename(const char *oldpath, const char *newpath)
  */
 static int ext4_plain_rename(struct inode *old_dir, struct dentry *old_dentry,
-			     struct inode *new_dir, struct dentry *new_dentry)
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     unsigned int flags)
 {
 	handle_t *handle = NULL;
 	struct ext4_renament old = {
@@ -3171,6 +3172,9 @@ static int ext4_plain_rename(struct inod
 		.inode = new_dentry->d_inode,
 	};
 	int retval;
+	struct inode *whiteout = NULL;
+	int credits;
+	u8 old_file_type;
 
 	dquot_initialize(old.dir);
 	dquot_initialize(new.dir);
@@ -3202,11 +3206,33 @@ static int ext4_plain_rename(struct inod
 	if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
 		ext4_alloc_da_blocks(old.inode);
 
-	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
-		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
-		 EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	credits = (2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
+		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
+	if (!(flags & RENAME_WHITEOUT)) {
+		handle = ext4_journal_start(old.dir, EXT4_HT_DIR, credits);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+	} else {
+		int retries = 0;
+
+		credits += (EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
+			    EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3);
+retry:
+		whiteout = ext4_new_inode_start_handle(old.dir, S_IFCHR | WHITEOUT_MODE, &old.dentry->d_name, 0, NULL, EXT4_HT_DIR, credits);
+		handle = ext4_journal_current_handle();
+		if (IS_ERR(whiteout)) {
+			if (handle)
+				ext4_journal_stop(handle);
+			retval = PTR_ERR(whiteout);
+			if (retval == -ENOSPC &&
+			    ext4_should_retry_alloc(old.dir->i_sb, &retries))
+				goto retry;
+
+			return retval;
+		}
+		init_special_inode(whiteout, whiteout->i_mode, WHITEOUT_DEV);
+		whiteout->i_op = &ext4_special_inode_operations;
+	}
 
 	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
 		ext4_handle_sync(handle);
@@ -3225,13 +3251,21 @@ static int ext4_plain_rename(struct inod
 		if (retval)
 			goto end_rename;
 	}
+	old_file_type = old.de->file_type;
+	if (whiteout) {
+		retval = ext4_setent(handle, &old, whiteout->i_ino,
+				     EXT4_FT_CHRDEV);
+		if (retval)
+			goto end_rename;
+		ext4_mark_inode_dirty(handle, whiteout);
+	}
 	if (!new.bh) {
 		retval = ext4_add_entry(handle, new.dentry, old.inode);
 		if (retval)
 			goto end_rename;
 	} else {
 		retval = ext4_setent(handle, &new,
-				     old.inode->i_ino, old.de->file_type);
+				     old.inode->i_ino, old_file_type);
 		if (retval)
 			goto end_rename;
 	}
@@ -3243,10 +3277,12 @@ static int ext4_plain_rename(struct inod
 	old.inode->i_ctime = ext4_current_time(old.inode);
 	ext4_mark_inode_dirty(handle, old.inode);
 
-	/*
-	 * ok, that's it
-	 */
-	ext4_rename_delete(handle, &old);
+	if (!whiteout) {
+		/*
+		 * ok, that's it
+		 */
+		ext4_rename_delete(handle, &old);
+	}
 
 	if (new.inode) {
 		ext4_dec_count(handle, new.inode);
@@ -3282,6 +3318,12 @@ static int ext4_plain_rename(struct inod
 	brelse(old.dir_bh);
 	brelse(old.bh);
 	brelse(new.bh);
+	if (whiteout) {
+		if (retval)
+			drop_nlink(whiteout);
+		unlock_new_inode(whiteout);
+		iput(whiteout);
+	}
 	if (handle)
 		ext4_journal_stop(handle);
 	return retval;
@@ -3407,7 +3449,7 @@ static int ext4_rename(struct inode *old
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
 {
-	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
 	if (flags & RENAME_EXCHANGE) {
@@ -3418,7 +3460,8 @@ static int ext4_rename(struct inode *old
 	 * Existence checking was done by the VFS, otherwise "RENAME_NOREPLACE"
 	 * is equivalent to regular rename.
 	 */
-	return ext4_plain_rename(old_dir, old_dentry, new_dir, new_dentry);
+	return ext4_plain_rename(old_dir, old_dentry, new_dir, new_dentry,
+				 flags);
 }
 
 /*
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4165,12 +4165,16 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
 	bool should_retry = false;
 	int error;
 
-	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
-	if ((flags & RENAME_NOREPLACE) && (flags & RENAME_EXCHANGE))
+	if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
+	    (flags & RENAME_EXCHANGE))
 		return -EINVAL;
 
+	if ((flags & RENAME_WHITEOUT) && !capable(CAP_MKNOD))
+		return -EPERM;
+
 retry:
 	from = user_path_parent(olddfd, oldname, &oldnd, lookup_flags);
 	if (IS_ERR(from)) {
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -37,6 +37,7 @@
 
 #define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
 #define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
+#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
 
 struct fstrim_range {
 	__u64 start;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -215,6 +215,13 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_TIMES_SET	(1 << 16)
 
 /*
+ * Whiteout is represented by a char device.  The following constants define the
+ * mode and device number to use.
+ */
+#define WHITEOUT_MODE 0
+#define WHITEOUT_DEV 0
+
+/*
  * This is the Inode Attributes structure, used for notify_change().  It
  * uses the above definitions as flags, to know which values have changed.
  * Also, in this manner, a Filesystem can look at only the values it cares
