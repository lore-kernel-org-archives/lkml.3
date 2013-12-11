Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3LKRBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:01:40 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:28953 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750904Ab3LKRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:01:37 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 12:01:36 EST
Message-ID: <1386780980.9524.10.camel@ultrabook>
Subject: [PATCH] hfsplus: Remove hfsplus_file_lookup
From: Sougata Santra <sougata@tuxera.com>
Reply-To: <sougata@tuxera.com>
To: <hch@infradead.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        Szabolcs Szakacsits <szaka@tuxera.com>
Date: Wed, 11 Dec 2013 18:56:20 +0200
Organization: Tuxera
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [194.100.106.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sougata Santra <sougata@tuxera.com>

HFS+ resource fork lookup breaks opendir() library function. Since
opendir first calls open() with O_DIRECTORY flag set. O_DIRECTORY
means "refuse to open if not a directory". The open system call
in the kernel does a check for inode->i_op->lookup and returns
-ENOTDIR. So if hfsplus_file_lookup is set it allows opendir()
for plain files.

Also resource fork lookup in HFS+ does not work. Since it is never
invoked after VFS permission checking. It will always return with
-EACCES.

Signed-off-by: Sougata Santra <sougata@tuxera.com>
---

When we call opendir() on a file, it does not return NULL.
opendir() library call is based on open with O_DIRECTORY flag
passed and then layered on top of getdents() system call.
O_DIRECTORY means "refuse to open if not a directory".

The open() system call in the kernel does a check for:
do_sys_open() -->..--> can_lookup() i.e it only checks
inode->i_op->lookup and returns ENOTDIR if
this function pointer is not set.
"
In OSX, we can open "file/rsrc" to get the resource fork of "file".
This behavior is emulated inside hfsplus on Linux, which means that
to some degree every file acts like a directory. That is the reason
lookup() inode operations is supported for files, and it is possible
to do a lookup on this specific name. As a result of this open succeeds
without returning  ENOTDIR for HFS+
"
Please see the LKML discussion thread on this issue:
http://marc.info/?l=linux-fsdevel&m=122823343730412&w=2 

I tried to test file/rsrc lookup in HFS+ driver and the feature does not work.
>From OSX:
$ touch test
$ echo "1234" > test/..namedfork/rsrc
$ ls -l test..namedfork/rsrc
--rw-r--r-- 1 tuxera staff 5 10 dec 12:59 test/..namedfork/rsrc

[sougata@ultrabook tmp]$ id
uid=1000(sougata) gid=1000(sougata) groups=1000(sougata),5(tty),18(dialout),1001(vboxusers)

[sougata@ultrabook tmp]$ mount
/dev/sdb1 on /mnt/tmp type hfsplus (rw,relatime,umask=0,uid=1000,gid=1000,nls=utf8)

[sougata@ultrabook tmp]$ ls -l test/rsrc
ls: cannot access test/rsrc: Permission denied

According to this LKML thread it is expected behavior.
http://marc.info/?t=121139033800008&r=1&w=4
I guess now that permission checking happens in vfs generic_permission() ?
So it turns out that even though the lookup() inode_operation exists for HFS+ files.
It cannot really get invoked ?. So if we can disable this feature to make opendir()
work for HFS+.

Thanks,
    Sougata

 fs/hfsplus/inode.c | 59 ------------------------------------------------------
 1 file changed, 59 deletions(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 37213d0..3ebda92 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -178,64 +178,6 @@ const struct dentry_operations hfsplus_dentry_operations = {
 	.d_compare    = hfsplus_compare_dentry,
 };
 
-static struct dentry *hfsplus_file_lookup(struct inode *dir,
-		struct dentry *dentry, unsigned int flags)
-{
-	struct hfs_find_data fd;
-	struct super_block *sb = dir->i_sb;
-	struct inode *inode = NULL;
-	struct hfsplus_inode_info *hip;
-	int err;
-
-	if (HFSPLUS_IS_RSRC(dir) || strcmp(dentry->d_name.name, "rsrc"))
-		goto out;
-
-	inode = HFSPLUS_I(dir)->rsrc_inode;
-	if (inode)
-		goto out;
-
-	inode = new_inode(sb);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-
-	hip = HFSPLUS_I(inode);
-	inode->i_ino = dir->i_ino;
-	INIT_LIST_HEAD(&hip->open_dir_list);
-	mutex_init(&hip->extents_lock);
-	hip->extent_state = 0;
-	hip->flags = 0;
-	hip->userflags = 0;
-	set_bit(HFSPLUS_I_RSRC, &hip->flags);
-
-	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
-	if (!err) {
-		err = hfsplus_find_cat(sb, dir->i_ino, &fd);
-		if (!err)
-			err = hfsplus_cat_read_inode(inode, &fd);
-		hfs_find_exit(&fd);
-	}
-	if (err) {
-		iput(inode);
-		return ERR_PTR(err);
-	}
-	hip->rsrc_inode = dir;
-	HFSPLUS_I(dir)->rsrc_inode = inode;
-	igrab(dir);
-
-	/*
-	 * __mark_inode_dirty expects inodes to be hashed.  Since we don't
-	 * want resource fork inodes in the regular inode space, we make them
-	 * appear hashed, but do not put on any lists.  hlist_del()
-	 * will work fine and require no locking.
-	 */
-	hlist_add_fake(&inode->i_hash);
-
-	mark_inode_dirty(inode);
-out:
-	d_add(dentry, inode);
-	return NULL;
-}
-
 static void hfsplus_get_perms(struct inode *inode,
 		struct hfsplus_perm *perms, int dir)
 {
@@ -385,7 +327,6 @@ int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
 }
 
 static const struct inode_operations hfsplus_file_inode_operations = {
-	.lookup		= hfsplus_file_lookup,
 	.setattr	= hfsplus_setattr,
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
-- 
1.8.1.4



