Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbbA1WDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:03:47 -0500
Received: from mailrelay113.isp.belgacom.be ([195.238.20.140]:62897 "EHLO
	mailrelay113.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753645AbbA1UXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:23:08 -0500
X-Belgacom-Dynamic: yes
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=r3/LV5qEOeRNqOlObU3fPeZ+G8vFrxRTI9UozocECbw= c=1 sm=2
 a=Z4Rwk6OoAAAA:8 a=KFU0DpkgyvVFIAF4aCMA:9
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: A2CaFgCsIclU/1YVQ1dagwaBK7IFBQEBAQEBAQUBd5c6gRxEAQEBAQF9hDovI4EaN4gwAcZGj3iGBIl0HYQTBYVDiQqJQoogiBwigUUBgik9MYJCAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] FS/AFFS: use inode writecount instead of local i_opencnt
Date: Wed, 28 Jan 2015 18:52:03 +0100
Message-Id: <1422467523-22051-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_t i_opencnt was used to free allocation in case there were no
more opens. This patch replaces affs_file_open by generic_file_open
and uses FMODE_WRITE/i_writecount==1 for the task like other FS.

Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/affs.h  |  1 -
 fs/affs/file.c  | 17 ++++-------------
 fs/affs/inode.c |  2 --
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index ff44ff3..c50815f 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -39,7 +39,6 @@ struct affs_ext_key {
  * affs fs inode data in memory
  */
 struct affs_inode_info {
-	atomic_t i_opencnt;
 	struct semaphore i_link_lock;		/* Protects internal inode access. */
 	struct semaphore i_ext_lock;		/* Protects internal inode access. */
 #define i_hash_lock i_ext_lock
diff --git a/fs/affs/file.c b/fs/affs/file.c
index d2468bf..77e30e8 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -18,21 +18,12 @@
 static struct buffer_head *affs_get_extblock_slow(struct inode *inode, u32 ext);
 
 static int
-affs_file_open(struct inode *inode, struct file *filp)
-{
-	pr_debug("open(%lu,%d)\n",
-		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
-	atomic_inc(&AFFS_I(inode)->i_opencnt);
-	return 0;
-}
-
-static int
 affs_file_release(struct inode *inode, struct file *filp)
 {
-	pr_debug("release(%lu, %d)\n",
-		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
+	pr_debug("release(%lu)\n", inode->i_ino);
 
-	if (atomic_dec_and_test(&AFFS_I(inode)->i_opencnt)) {
+	if ((filp->f_mode & FMODE_WRITE) &&
+	    (atomic_read(&inode->i_writecount) == 1)) {
 		mutex_lock(&inode->i_mutex);
 		if (inode->i_size != AFFS_I(inode)->mmu_private)
 			affs_truncate(inode);
@@ -969,7 +960,7 @@ const struct file_operations affs_file_operations = {
 	.write		= new_sync_write,
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
-	.open		= affs_file_open,
+	.open		= generic_file_open,
 	.release	= affs_file_release,
 	.fsync		= affs_file_fsync,
 	.splice_read	= generic_file_splice_read,
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 25cb4b4..5c160dd 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -56,7 +56,6 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 	AFFS_I(inode)->i_extcnt = 1;
 	AFFS_I(inode)->i_ext_last = ~1;
 	AFFS_I(inode)->i_protect = prot;
-	atomic_set(&AFFS_I(inode)->i_opencnt, 0);
 	AFFS_I(inode)->i_blkcnt = 0;
 	AFFS_I(inode)->i_lc = NULL;
 	AFFS_I(inode)->i_lc_size = 0;
@@ -307,7 +306,6 @@ affs_new_inode(struct inode *dir)
 	inode->i_ino     = block;
 	set_nlink(inode, 1);
 	inode->i_mtime   = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
-	atomic_set(&AFFS_I(inode)->i_opencnt, 0);
 	AFFS_I(inode)->i_blkcnt = 0;
 	AFFS_I(inode)->i_lc = NULL;
 	AFFS_I(inode)->i_lc_size = 0;
-- 
2.1.0

