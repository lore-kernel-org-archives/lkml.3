Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3ITQOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:14:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40411 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3ITQOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:14:24 -0400
Date: Fri, 20 Sep 2013 17:14:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH][RFC] Fix breakage in ffs_fs_mount()
Message-ID: <20130920161421.GR13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	There's a bunch of failure exits in ffs_fs_mount() with
seriously broken recovery logics.  Most of that appears to stem
from misunderstanding of the ->kill_sb() semantics; unlike
->put_super() it is called for *all* superblocks of given type,
no matter how (in)complete the setup had been.  ->put_super()
is called only if ->s_root is not NULL; any failure prior to
setting ->s_root will have the call of ->put_super() skipped.  
->kill_sb(), OTOH, awaits every superblock that has come from
sget().

Current behaviour of ffs_fs_mount():

We have struct ffs_sb_fill_data data on stack there.  We do
	ffs_dev = functionfs_acquire_dev_callback(dev_name);
and store that in data.private_data.  Then we call mount_nodev(),
passing it ffs_sb_fill() as a callback.  That will either fail
outright, or manage to call ffs_sb_fill().  There we allocate an
instance of struct ffs_data, slap the value of ffs_dev (picked
from data.private_data) into ffs->private_data and overwrite
data.private_data by storing ffs into an overlapping member
(data.ffs_data).  Then we store ffs into sb->s_fs_info and attempt
to set the rest of the things up (root inode, root dentry, then
create /ep0 there).  Any of those might fail.  Should that
happen, we get ffs_fs_kill_sb() called before mount_nodev()
returns.  If mount_nodev() fails for any reason whatsoever,
we proceed to
	functionfs_release_dev_callback(data.ffs_data);
 
That's broken in a lot of ways.  Suppose the thing has failed in
allocation of e.g. root inode or dentry.  We have
	functionfs_release_dev_callback(ffs);
	ffs_data_put(ffs);
done by ffs_fs_kill_sb() (ffs accessed via sb->s_fs_info), followed by
	functionfs_release_dev_callback(ffs);
from ffs_fs_mount() (via data.ffs_data).  Note that the second
functionfs_release_dev_callback() has every chance to be done to freed memory.
 
Suppose we fail *before* root inode allocation.  What happens then?
ffs_fs_kill_sb() doesn't do anything to ffs (it's either not called at all,
or it doesn't have a pointer to ffs stored in sb->s_fs_info).  And
	functionfs_release_dev_callback(data.ffs_data);
is called by ffs_fs_mount(), but here we are in nasal daemon country - we
are reading from a member of union we'd never stored into.  In practice,
we'll get what we used to store into the overlapping field, i.e. ffs_dev.
And then we get screwed, since we treat it (struct gfs_ffs_obj * in
disguise, returned by functionfs_acquire_dev_callback()) as struct
ffs_data *, pick what would've been ffs_data ->private_data from it
(*well* past the actual end of the struct gfs_ffs_obj - struct ffs_data
is much bigger) and poke in whatever it points to.

FWIW, there's a minor leak on top of all that in case if ffs_sb_fill()
fails on kstrdup() - ffs is obviously forgotten.
    
The thing is, there is no point in playing all those games with union.
Just allocate and initialize ffs_data *before* calling mount_nodev() and
pass a pointer to it via data.ffs_data.  And once it's stored in
sb->s_fs_info, clear data.ffs_data, so that ffs_fs_mount() knows that
it doesn't need to kill the sucker manually - from that point on
we'll have it done by ->kill_sb().
 
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
-- 
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 1a66c5b..0658908 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1034,37 +1034,19 @@ struct ffs_sb_fill_data {
 	struct ffs_file_perms perms;
 	umode_t root_mode;
 	const char *dev_name;
-	union {
-		/* set by ffs_fs_mount(), read by ffs_sb_fill() */
-		void *private_data;
-		/* set by ffs_sb_fill(), read by ffs_fs_mount */
-		struct ffs_data *ffs_data;
-	};
+	struct ffs_data *ffs_data;
 };
 
 static int ffs_sb_fill(struct super_block *sb, void *_data, int silent)
 {
 	struct ffs_sb_fill_data *data = _data;
 	struct inode	*inode;
-	struct ffs_data	*ffs;
+	struct ffs_data	*ffs = data->ffs_data;
 
 	ENTER();
 
-	/* Initialise data */
-	ffs = ffs_data_new();
-	if (unlikely(!ffs))
-		goto Enomem;
-
 	ffs->sb              = sb;
-	ffs->dev_name        = kstrdup(data->dev_name, GFP_KERNEL);
-	if (unlikely(!ffs->dev_name))
-		goto Enomem;
-	ffs->file_perms      = data->perms;
-	ffs->private_data    = data->private_data;
-
-	/* used by the caller of this function */
-	data->ffs_data       = ffs;
-
+	data->ffs_data       = NULL;
 	sb->s_fs_info        = ffs;
 	sb->s_blocksize      = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
@@ -1080,17 +1062,14 @@ static int ffs_sb_fill(struct super_block *sb, void *_data, int silent)
 				  &data->perms);
 	sb->s_root = d_make_root(inode);
 	if (unlikely(!sb->s_root))
-		goto Enomem;
+		return -ENOMEM;
 
 	/* EP0 file */
 	if (unlikely(!ffs_sb_create_file(sb, "ep0", ffs,
 					 &ffs_ep0_operations, NULL)))
-		goto Enomem;
+		return -ENOMEM;
 
 	return 0;
-
-Enomem:
-	return -ENOMEM;
 }
 
 static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
@@ -1193,6 +1172,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	struct dentry *rv;
 	int ret;
 	void *ffs_dev;
+	struct ffs_data	*ffs;
 
 	ENTER();
 
@@ -1200,18 +1180,30 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	if (unlikely(ret < 0))
 		return ERR_PTR(ret);
 
+	ffs = ffs_data_new();
+	if (unlikely(!ffs))
+		return ERR_PTR(-ENOMEM);
+	ffs->file_perms = data.perms;
+
+	ffs->dev_name = kstrdup(dev_name, GFP_KERNEL);
+	if (unlikely(!ffs->dev_name)) {
+		ffs_data_put(ffs);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	ffs_dev = functionfs_acquire_dev_callback(dev_name);
-	if (IS_ERR(ffs_dev))
-		return ffs_dev;
+	if (IS_ERR(ffs_dev)) {
+		ffs_data_put(ffs);
+		return ERR_CAST(ffs_dev);
+	}
+	ffs->private_data = ffs_dev;
+	data.ffs_data = ffs;
 
-	data.dev_name = dev_name;
-	data.private_data = ffs_dev;
 	rv = mount_nodev(t, flags, &data, ffs_sb_fill);
-
-	/* data.ffs_data is set by ffs_sb_fill */
-	if (IS_ERR(rv))
+	if (IS_ERR(rv) && data.ffs_data) {
 		functionfs_release_dev_callback(data.ffs_data);
-
+		ffs_data_put(data.ffs_data);
+	}
 	return rv;
 }
 
