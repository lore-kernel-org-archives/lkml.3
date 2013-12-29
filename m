Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3L2TNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 14:13:33 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:55963 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987Ab3L2TNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 14:13:31 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsRAIBzwFJXQzhL/2dsb2JhbABQCCiCY4M6tykCAoETF3SCUxMcIxiBAjcbh20ByHMXjkdWhD0EiUGOVQGKS4dJgzov
Date: Sun, 29 Dec 2013 19:14:27 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org, viro@zeniv.linux.org.uk,
        dushistov@mail.ru
Subject: [PATCH 1/1] ufs: sb mutex merge + mutex_destroy
Message-Id: <20131229191427.4ac53f6c8a5bf2d55a08de61@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 788257d6101d986ac8f2741aaa35974af47f574c
replaced BKL with mutex protection
using functions lock_ufs, unlock_ufs and
struct mutex 'mutex' in sb_info.

commit b6963327e0521e682c2fffd018574251d3c22b41
removed lock/unlock super and added
struct mutex 's_lock' in sb_info.

Those 2 mutexes are generally locked/unlocked
at the same time except in allocation (balloc, ialloc).

This patch merges the 2 mutexes and propagates
first commit solution.
It also adds mutex destruction before kfree during ufs_fill_super
failure and ufs_put_super.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/balloc.c | 30 +++++++++++++++---------------
 fs/ufs/ialloc.c | 17 ++++++++---------
 fs/ufs/super.c  | 13 ++-----------
 fs/ufs/ufs.h    |  1 -
 4 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index a7ea492..59aa24d 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -54,7 +54,7 @@ void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned count)
 	if (ufs_fragnum(fragment) + count > uspi->s_fpg)
 		ufs_error (sb, "ufs_free_fragments", "internal error");
 	
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 	
 	cgno = ufs_dtog(uspi, fragment);
 	bit = ufs_dtogd(uspi, fragment);
@@ -118,12 +118,12 @@ void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned count)
 		ubh_sync_block(UCPI_UBH(ucpi));
 	ufs_mark_sb_dirty(sb);
 	
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT\n");
 	return;
 
 failed:
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT (FAILED)\n");
 	return;
 }
@@ -155,7 +155,7 @@ void ufs_free_blocks(struct inode *inode, u64 fragment, unsigned count)
 		goto failed;
 	}
 
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 	
 do_more:
 	overflow = 0;
@@ -215,12 +215,12 @@ do_more:
 	}
 
 	ufs_mark_sb_dirty(sb);
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT\n");
 	return;
 
 failed_unlock:
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 failed:
 	UFSD("EXIT (FAILED)\n");
 	return;
@@ -361,7 +361,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 	usb1 = ubh_get_usb_first(uspi);
 	*err = -ENOSPC;
 
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 	tmp = ufs_data_ptr_to_cpu(sb, p);
 
 	if (count + ufs_fragnum(fragment) > uspi->s_fpb) {
@@ -382,19 +382,19 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 				  "fragment %llu, tmp %llu\n",
 				  (unsigned long long)fragment,
 				  (unsigned long long)tmp);
-			mutex_unlock(&UFS_SB(sb)->s_lock);
+			unlock_ufs(sb);
 			return INVBLOCK;
 		}
 		if (fragment < UFS_I(inode)->i_lastfrag) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
-			mutex_unlock(&UFS_SB(sb)->s_lock);
+			unlock_ufs(sb);
 			return 0;
 		}
 	}
 	else {
 		if (tmp) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
-			mutex_unlock(&UFS_SB(sb)->s_lock);
+			unlock_ufs(sb);
 			return 0;
 		}
 	}
@@ -403,7 +403,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 	 * There is not enough space for user on the device
 	 */
 	if (!capable(CAP_SYS_RESOURCE) && ufs_freespace(uspi, UFS_MINFREE) <= 0) {
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		UFSD("EXIT (FAILED)\n");
 		return 0;
 	}
@@ -428,7 +428,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 			ufs_clear_frags(inode, result + oldcount,
 					newcount - oldcount, locked_page != NULL);
 		}
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -443,7 +443,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 						fragment + count);
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -481,7 +481,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
 						fragment + count);
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
 		ufs_free_fragments (inode, tmp, oldcount);
@@ -489,7 +489,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 		return result;
 	}
 
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT (FAILED)\n");
 	return 0;
 }		
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index d0426d7..da5e525 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -71,11 +71,11 @@ void ufs_free_inode (struct inode * inode)
 	
 	ino = inode->i_ino;
 
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 
 	if (!((ino > 1) && (ino < (uspi->s_ncg * uspi->s_ipg )))) {
 		ufs_warning(sb, "ufs_free_inode", "reserved inode or nonexistent inode %u\n", ino);
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		return;
 	}
 	
@@ -83,7 +83,7 @@ void ufs_free_inode (struct inode * inode)
 	bit = ufs_inotocgoff (ino);
 	ucpi = ufs_load_cylinder (sb, cg);
 	if (!ucpi) {
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		return;
 	}
 	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
@@ -117,7 +117,7 @@ void ufs_free_inode (struct inode * inode)
 		ubh_sync_block(UCPI_UBH(ucpi));
 	
 	ufs_mark_sb_dirty(sb);
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT\n");
 }
 
@@ -197,7 +197,7 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t mode)
 	uspi = sbi->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 
-	mutex_lock(&sbi->s_lock);
+	lock_ufs(sb);
 
 	/*
 	 * Try to place the inode in its parent directory
@@ -332,21 +332,20 @@ cg_found:
 			sync_dirty_buffer(bh);
 		brelse(bh);
 	}
-
-	mutex_unlock(&sbi->s_lock);
+	unlock_ufs(sb);
 
 	UFSD("allocating inode %lu\n", inode->i_ino);
 	UFSD("EXIT\n");
 	return inode;
 
 fail_remove_inode:
-	mutex_unlock(&sbi->s_lock);
+	unlock_ufs(sb);
 	clear_nlink(inode);
 	iput(inode);
 	UFSD("EXIT (FAILED): err %d\n", err);
 	return ERR_PTR(err);
 failed:
-	mutex_unlock(&sbi->s_lock);
+	unlock_ufs(sb);
 	make_bad_inode(inode);
 	iput (inode);
 	UFSD("EXIT (FAILED): err %d\n", err);
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 329f2f5..e5a9934 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -699,7 +699,6 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 	unsigned flags;
 
 	lock_ufs(sb);
-	mutex_lock(&UFS_SB(sb)->s_lock);
 
 	UFSD("ENTER\n");
 
@@ -717,7 +716,6 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 	ufs_put_cstotal(sb);
 
 	UFSD("EXIT\n");
-	mutex_unlock(&UFS_SB(sb)->s_lock);
 	unlock_ufs(sb);
 
 	return 0;
@@ -762,6 +760,7 @@ static void ufs_put_super(struct super_block *sb)
 
 	ubh_brelse_uspi (sbi->s_uspi);
 	kfree (sbi->s_uspi);
+	mutex_destroy(&sbi->mutex);
 	kfree (sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT\n");
@@ -805,7 +804,6 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 #endif
 	mutex_init(&sbi->mutex);
-	mutex_init(&sbi->s_lock);
 	spin_lock_init(&sbi->work_lock);
 	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
 	/*
@@ -1262,6 +1260,7 @@ failed:
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
+	mutex_destroy(&sbi->mutex);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
@@ -1281,7 +1280,6 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	unsigned flags;
 
 	lock_ufs(sb);
-	mutex_lock(&UFS_SB(sb)->s_lock);
 	uspi = UFS_SB(sb)->s_uspi;
 	flags = UFS_SB(sb)->s_flags;
 	usb1 = ubh_get_usb_first(uspi);
@@ -1295,7 +1293,6 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	new_mount_opt = 0;
 	ufs_set_opt (new_mount_opt, ONERROR_LOCK);
 	if (!ufs_parse_options (data, &new_mount_opt)) {
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
@@ -1303,14 +1300,12 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 		new_mount_opt |= ufstype;
 	} else if ((new_mount_opt & UFS_MOUNT_UFSTYPE) != ufstype) {
 		printk("ufstype can't be changed during remount\n");
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
 
 	if ((*mount_flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		UFS_SB(sb)->s_mount_opt = new_mount_opt;
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return 0;
 	}
@@ -1335,7 +1330,6 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 #ifndef CONFIG_UFS_FS_WRITE
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 #else
@@ -1345,13 +1339,11 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86 &&
 		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
 			printk("this ufstype is read-only supported\n");
-			mutex_unlock(&UFS_SB(sb)->s_lock);
 			unlock_ufs(sb);
 			return -EINVAL;
 		}
 		if (!ufs_read_cylinder_structures(sb)) {
 			printk("failed during remounting\n");
-			mutex_unlock(&UFS_SB(sb)->s_lock);
 			unlock_ufs(sb);
 			return -EPERM;
 		}
@@ -1359,7 +1351,6 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 #endif
 	}
 	UFS_SB(sb)->s_mount_opt = new_mount_opt;
-	mutex_unlock(&UFS_SB(sb)->s_lock);
 	unlock_ufs(sb);
 	return 0;
 }
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index ff2c15a..343e6fc 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -24,7 +24,6 @@ struct ufs_sb_info {
 	int work_queued; /* non-zero if the delayed work is queued */
 	struct delayed_work sync_work; /* FS sync delayed work */
 	spinlock_t work_lock; /* protects sync_work and work_queued */
-	struct mutex s_lock;
 };
 
 struct ufs_inode_info {
-- 
1.8.1.4
