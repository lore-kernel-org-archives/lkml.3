Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab3CYB0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:26:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34042 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132Ab3CYBQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:08 -0400
Message-Id: <20130325010529.741350944@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mateusz Guzik <mguzik@redhat.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 055/104] cifs: delay super block destruction until all cifsFileInfo objects
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 are gone
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mguzik@redhat.com>

commit 24261fc23db950951760d00c188ba63cc756b932 upstream.

cifsFileInfo objects hold references to dentries and it is possible that
these will still be around in workqueues when VFS decides to kill super
block during unmount.

This results in panics like this one:
BUG: Dentry ffff88001f5e76c0{i=66b4a,n=1M-2} still in use (1) [unmount of cifs cifs]
------------[ cut here ]------------
kernel BUG at fs/dcache.c:943!
[..]
Process umount (pid: 1781, threadinfo ffff88003d6e8000, task ffff880035eeaec0)
[..]
Call Trace:
 [<ffffffff811b44f3>] shrink_dcache_for_umount+0x33/0x60
 [<ffffffff8119f7fc>] generic_shutdown_super+0x2c/0xe0
 [<ffffffff8119f946>] kill_anon_super+0x16/0x30
 [<ffffffffa036623a>] cifs_kill_sb+0x1a/0x30 [cifs]
 [<ffffffff8119fcc7>] deactivate_locked_super+0x57/0x80
 [<ffffffff811a085e>] deactivate_super+0x4e/0x70
 [<ffffffff811bb417>] mntput_no_expire+0xd7/0x130
 [<ffffffff811bc30c>] sys_umount+0x9c/0x3c0
 [<ffffffff81657c19>] system_call_fastpath+0x16/0x1b

Fix this by making each cifsFileInfo object hold a reference to cifs
super block, which implicitly keeps VFS super block around as well.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Reported-and-Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifsfs.c |   24 ++++++++++++++++++++++++
 fs/cifs/cifsfs.h |    4 ++++
 fs/cifs/file.c   |    6 +++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -90,6 +90,30 @@ extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
 
+/*
+ * Bumps refcount for cifs super block.
+ * Note that it should be only called if a referece to VFS super block is
+ * already held, e.g. in open-type syscalls context. Otherwise it can race with
+ * atomic_dec_and_test in deactivate_locked_super.
+ */
+void
+cifs_sb_active(struct super_block *sb)
+{
+	struct cifs_sb_info *server = CIFS_SB(sb);
+
+	if (atomic_inc_return(&server->active) == 1)
+		atomic_inc(&sb->s_active);
+}
+
+void
+cifs_sb_deactive(struct super_block *sb)
+{
+	struct cifs_sb_info *server = CIFS_SB(sb);
+
+	if (atomic_dec_and_test(&server->active))
+		deactivate_super(sb);
+}
+
 static int
 cifs_read_super(struct super_block *sb)
 {
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -41,6 +41,10 @@ extern struct file_system_type cifs_fs_t
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
+/* Functions related to super block operations */
+extern void cifs_sb_active(struct super_block *sb);
+extern void cifs_sb_deactive(struct super_block *sb);
+
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
 extern struct inode *cifs_root_iget(struct super_block *);
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -265,6 +265,8 @@ cifs_new_fileinfo(__u16 fileHandle, stru
 	mutex_init(&pCifsFile->fh_mutex);
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
+	cifs_sb_active(inode->i_sb);
+
 	spin_lock(&cifs_file_list_lock);
 	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
 	/* if readable file instance put first in list*/
@@ -293,7 +295,8 @@ void cifsFileInfo_put(struct cifsFileInf
 	struct inode *inode = cifs_file->dentry->d_inode;
 	struct cifs_tcon *tcon = tlink_tcon(cifs_file->tlink);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct super_block *sb = inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsLockInfo *li, *tmp;
 
 	spin_lock(&cifs_file_list_lock);
@@ -345,6 +348,7 @@ void cifsFileInfo_put(struct cifsFileInf
 
 	cifs_put_tlink(cifs_file->tlink);
 	dput(cifs_file->dentry);
+	cifs_sb_deactive(sb);
 	kfree(cifs_file);
 }
 


