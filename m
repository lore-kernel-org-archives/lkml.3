Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077AbaD2TdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:33:12 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:33497 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933447AbaD2TdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:33:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4WAAj+X1NbsnvL/2dsb2JhbABZgwasMQUBAQEEAZlzAgKBJRd0glMTHCMYPkQkE4hFAclvhVWIeoRAAQOPAIoPAYp3h2uBcoFBO4EsBA
Date: Tue, 29 Apr 2014 21:35:12 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] Revert
 "affs: use ->kill_sb() to simplify ->put_super() and failure exits of ->mount()"
Message-Id: <20140429213512.7b9a783a970a193728ab4335@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 842a859db26b70 due to permanent crash issues.

Sample scenario:

dd if=/dev/zero of=f1 bs=1M count=1
losetup -f f1
mount -t affs -o unknownoption /dev/loop0 mnt1
-> crash

With patch revert:
"mount: wrong fs type, bad option, bad superblock on /dev/loop0"

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/super.c | 57 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 6d589f2..d617b2a 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -49,6 +49,11 @@ affs_put_super(struct super_block *sb)
 	pr_debug("AFFS: put_super()\n");
 
 	cancel_delayed_work_sync(&sbi->sb_work);
+	kfree(sbi->s_prefix);
+	affs_free_bitmap(sb);
+	affs_brelse(sbi->s_root_bh);
+	kfree(sbi);
+	sb->s_fs_info = NULL;
 }
 
 static int
@@ -315,7 +320,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long		 mount_flags;
 	int			 tmp_flags;	/* fix remount prototype... */
 	u8			 sig[4];
-	int			 ret;
+	int			 ret = -EINVAL;
 
 	save_mount_options(sb, data);
 
@@ -411,19 +416,17 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!silent)
 		printk(KERN_ERR "AFFS: No valid root block on device %s\n",
 			sb->s_id);
-	return -EINVAL;
+	goto out_error;
 
 	/* N.B. after this point bh must be released */
 got_root:
-	/* Keep super block in cache */
-	sbi->s_root_bh = root_bh;
 	root_block = sbi->s_root_block;
 
 	/* Find out which kind of FS we have */
 	boot_bh = sb_bread(sb, 0);
 	if (!boot_bh) {
 		printk(KERN_ERR "AFFS: Cannot read boot block\n");
-		return -EINVAL;
+		goto out_error;
 	}
 	memcpy(sig, boot_bh->b_data, 4);
 	brelse(boot_bh);
@@ -472,7 +475,7 @@ got_root:
 		default:
 			printk(KERN_ERR "AFFS: Unknown filesystem on device %s: %08X\n",
 				sb->s_id, chksum);
-			return -EINVAL;
+			goto out_error;
 	}
 
 	if (mount_flags & SF_VERBOSE) {
@@ -489,17 +492,22 @@ got_root:
 	if (sbi->s_flags & SF_OFS)
 		sbi->s_data_blksize -= 24;
 
+	/* Keep super block in cache */
+	sbi->s_root_bh = root_bh;
+	/* N.B. after this point s_root_bh must be released */
+
 	tmp_flags = sb->s_flags;
-	ret = affs_init_bitmap(sb, &tmp_flags);
-	if (ret)
-		return ret;
+	if (affs_init_bitmap(sb, &tmp_flags))
+		goto out_error;
 	sb->s_flags = tmp_flags;
 
 	/* set up enough so that it can read an inode */
 
 	root_inode = affs_iget(sb, root_block);
-	if (IS_ERR(root_inode))
-		return PTR_ERR(root_inode);
+	if (IS_ERR(root_inode)) {
+		ret = PTR_ERR(root_inode);
+		goto out_error;
+	}
 
 	if (AFFS_SB(sb)->s_flags & SF_INTL)
 		sb->s_d_op = &affs_intl_dentry_operations;
@@ -509,11 +517,22 @@ got_root:
 	sb->s_root = d_make_root(root_inode);
 	if (!sb->s_root) {
 		printk(KERN_ERR "AFFS: Get root inode failed\n");
-		return -ENOMEM;
+		goto out_error;
 	}
 
 	pr_debug("AFFS: s_flags=%lX\n",sb->s_flags);
 	return 0;
+
+	/*
+	 * Begin the cascaded cleanup ...
+	 */
+out_error:
+	kfree(sbi->s_bitmap);
+	affs_brelse(root_bh);
+	kfree(sbi->s_prefix);
+	kfree(sbi);
+	sb->s_fs_info = NULL;
+	return ret;
 }
 
 static int
@@ -601,23 +620,11 @@ static struct dentry *affs_mount(struct file_system_type *fs_type,
 	return mount_bdev(fs_type, flags, dev_name, data, affs_fill_super);
 }
 
-static void affs_kill_sb(struct super_block *sb)
-{
-	struct affs_sb_info *sbi = AFFS_SB(sb);
-	kill_block_super(sb);
-	if (sbi) {
-		affs_free_bitmap(sb);
-		affs_brelse(sbi->s_root_bh);
-		kfree(sbi->s_prefix);
-		kfree(sbi);
-	}
-}
-
 static struct file_system_type affs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "affs",
 	.mount		= affs_mount,
-	.kill_sb	= affs_kill_sb,
+	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("affs");
-- 
1.8.4.5

