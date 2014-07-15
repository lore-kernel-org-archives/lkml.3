Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbaGOUfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:35:41 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:42769 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932797AbaGOUfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:35:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokRAC2PxVNbsm9N/2dsb2JhbABZgw6BKaw8CwUBbpwAgRAXdYQxLyOBGjeIRgHKOReFe4lQhEoFmxiLWYhMg0Y7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, hch@infradead.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/3] FS/SYSV: Convert printk to pr_foo()
Date: Tue, 15 Jul 2014 22:36:47 +0200
Message-Id: <1405456607-1946-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Convert nolevel printk to pr_err
-Coalesce formats

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/sysv/balloc.c | 22 +++++++++++-----------
 fs/sysv/ialloc.c | 11 +++++------
 fs/sysv/inode.c  | 12 ++++++------
 fs/sysv/itree.c  |  2 +-
 fs/sysv/super.c  | 26 ++++++++++++--------------
 5 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/fs/sysv/balloc.c b/fs/sysv/balloc.c
index 921c053..bebaae2 100644
--- a/fs/sysv/balloc.c
+++ b/fs/sysv/balloc.c
@@ -56,7 +56,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 		return;
 
 	if (block < sbi->s_firstdatazone || block >= sbi->s_nzones) {
-		printk("sysv_free_block: trying to free block not in datazone\n");
+		pr_err("sysv_free_block: trying to free block not in datazone\n");
 		return;
 	}
 
@@ -64,7 +64,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 	count = fs16_to_cpu(sbi, *sbi->s_bcache_count);
 
 	if (count > sbi->s_flc_size) {
-		printk("sysv_free_block: flc_count > flc_size\n");
+		pr_err("sysv_free_block: flc_count > flc_size\n");
 		mutex_unlock(&sbi->s_lock);
 		return;
 	}
@@ -76,7 +76,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 		block += sbi->s_block_base;
 		bh = sb_getblk(sb, block);
 		if (!bh) {
-			printk("sysv_free_block: getblk() failed\n");
+			pr_err("sysv_free_block: getblk() failed\n");
 			mutex_unlock(&sbi->s_lock);
 			return;
 		}
@@ -118,7 +118,7 @@ sysv_zone_t sysv_new_block(struct super_block * sb)
 	*sbi->s_bcache_count = cpu_to_fs16(sbi, count);
 
 	if (block < sbi->s_firstdatazone || block >= sbi->s_nzones) {
-		printk("sysv_new_block: new block %d is not in data zone\n",
+		pr_err("sysv_new_block: new block %d is not in data zone\n",
 			block);
 		goto Enospc;
 	}
@@ -128,14 +128,14 @@ sysv_zone_t sysv_new_block(struct super_block * sb)
 
 		block += sbi->s_block_base;
 		if (!(bh = sb_bread(sb, block))) {
-			printk("sysv_new_block: cannot read free-list block\n");
+			pr_err("sysv_new_block: cannot read free-list block\n");
 			/* retry this same block next time */
 			*sbi->s_bcache_count = cpu_to_fs16(sbi, 1);
 			goto Enospc;
 		}
 		count = fs16_to_cpu(sbi, *(__fs16*)bh->b_data);
 		if (count > sbi->s_flc_size) {
-			printk("sysv_new_block: free-list block with >flc_size entries\n");
+			pr_err("sysv_new_block: free-list block with >flc_size entries\n");
 			brelse(bh);
 			goto Enospc;
 		}
@@ -215,22 +215,22 @@ done:
 	return count;
 
 Einval:
-	printk("sysv_count_free_blocks: new block %d is not in data zone\n",
+	pr_err("sysv_count_free_blocks: new block %d is not in data zone\n",
 		block);
 	goto trust_sb;
 Eio:
-	printk("sysv_count_free_blocks: cannot read free-list block\n");
+	pr_err("sysv_count_free_blocks: cannot read free-list block\n");
 	goto trust_sb;
 E2big:
-	printk("sysv_count_free_blocks: >flc_size entries in free-list block\n");
+	pr_err("sysv_count_free_blocks: >flc_size entries in free-list block\n");
 	if (bh)
 		brelse(bh);
 trust_sb:
 	count = sb_count;
 	goto done;
 Ecount:
-	printk("sysv_count_free_blocks: free block count was %d, "
-		"correcting to %d\n", sb_count, count);
+	pr_err("sysv_count_free_blocks: free block count was %d, correcting to %d\n",
+	       sb_count, count);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		*sbi->s_free_blocks = cpu_to_fs32(sbi, count);
 		dirty_sb(sb);
diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
index f9db4eb..a4aae6c 100644
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -109,12 +109,12 @@ void sysv_free_inode(struct inode * inode)
 	sb = inode->i_sb;
 	ino = inode->i_ino;
 	if (ino <= SYSV_ROOT_INO || ino > sbi->s_ninodes) {
-		printk("sysv_free_inode: inode 0,1,2 or nonexistent inode\n");
+		pr_err("sysv_free_inode: inode 0,1,2 or nonexistent inode\n");
 		return;
 	}
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
-		printk("sysv_free_inode: unable to read inode block on device "
+		pr_err("sysv_free_inode: unable to read inode block on device "
 		       "%s\n", inode->i_sb->s_id);
 		return;
 	}
@@ -217,9 +217,8 @@ out:
 	return count;
 
 Einval:
-	printk("sysv_count_free_inodes: "
-		"free inode count was %d, correcting to %d\n",
-		sb_count, count);
+	pr_err("sysv_count_free_inodes: free inode count was %d, correcting to %d\n",
+	       sb_count, count);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		*sbi->s_sb_total_free_inodes = cpu_to_fs16(SYSV_SB(sb), count);
 		dirty_sb(sb);
@@ -227,7 +226,7 @@ Einval:
 	goto out;
 
 Eio:
-	printk("sysv_count_free_inodes: unable to read inode table\n");
+	pr_err("sysv_count_free_inodes: unable to read inode table\n");
 trust_sb:
 	count = sb_count;
 	goto out;
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 8895630..3914599 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -184,7 +184,7 @@ struct inode *sysv_iget(struct super_block *sb, unsigned int ino)
 	unsigned int block;
 
 	if (!ino || ino > sbi->s_ninodes) {
-		printk("Bad inode number on dev %s: %d is out of range\n",
+		pr_err("Bad inode number on dev %s: %d is out of range\n",
 		       sb->s_id, ino);
 		return ERR_PTR(-EIO);
 	}
@@ -197,7 +197,7 @@ struct inode *sysv_iget(struct super_block *sb, unsigned int ino)
 
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
-		printk("Major problem: unable to read inode from dev %s\n",
+		pr_err("Major problem: unable to read inode from dev %s\n",
 		       inode->i_sb->s_id);
 		goto bad_inode;
 	}
@@ -246,13 +246,13 @@ static int __sysv_write_inode(struct inode *inode, int wait)
 
 	ino = inode->i_ino;
 	if (!ino || ino > sbi->s_ninodes) {
-		printk("Bad inode number on dev %s: %d is out of range\n",
+		pr_err("Bad inode number on dev %s: %d is out of range\n",
 		       inode->i_sb->s_id, ino);
 		return -EIO;
 	}
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
-		printk("unable to read i-node block\n");
+		pr_err("unable to read i-node block\n");
 		return -EIO;
 	}
 
@@ -275,8 +275,8 @@ static int __sysv_write_inode(struct inode *inode, int wait)
 	if (wait) {
                 sync_dirty_buffer(bh);
                 if (buffer_req(bh) && !buffer_uptodate(bh)) {
-                        printk ("IO error syncing sysv inode [%s:%08x]\n",
-                                sb->s_id, ino);
+			pr_err("IO error syncing sysv inode [%s:%08x]\n",
+			       sb->s_id, ino);
                         err = -EIO;
                 }
         }
diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 66bc316..909416e 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -29,7 +29,7 @@ static int block_to_path(struct inode *inode, long block, int offsets[DEPTH])
 	int n = 0;
 
 	if (block < 0) {
-		printk("sysv_block_map: block < 0\n");
+		pr_err("sysv_block_map: block < 0\n");
 	} else if (block < DIRECT) {
 		offsets[n++] = block;
 	} else if ( (block -= DIRECT) < indirect_blocks) {
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index eda1095..ef3141e 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -217,9 +217,8 @@ static int detect_sysv(struct sysv_sb_info *sbi, struct buffer_head *bh)
  		sbi->s_type = FSTYPE_AFS;
 		sbi->s_forced_ro = 1;
  		if (!(sb->s_flags & MS_RDONLY)) {
- 			printk("SysV FS: SCO EAFS on %s detected, " 
- 				"forcing read-only mode.\n", 
- 				sb->s_id);
+			pr_err("SysV FS: SCO EAFS on %s detected, forcing read-only mode.\n",
+			       sb->s_id);
  		}
  		return type;
  	}
@@ -240,8 +239,8 @@ static int detect_sysv(struct sysv_sb_info *sbi, struct buffer_head *bh)
            feature read-only mode seems to be a reasonable approach... -KGB */
 
 	if (type >= 0x10) {
-		printk("SysV FS: can't handle long file names on %s, "
-		       "forcing read-only mode.\n", sb->s_id);
+		pr_err("SysV FS: can't handle long file names on %s, forcing read-only mode.\n",
+		       sb->s_id);
 		sbi->s_forced_ro = 1;
 	}
 
@@ -326,7 +325,7 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		<< sbi->s_inodes_per_block_bits;
 
 	if (!silent)
-		printk("VFS: Found a %s FS (block size = %ld) on device %s\n",
+		pr_err("VFS: Found a %s FS (block size = %ld) on device %s\n",
 		       found, sb->s_blocksize, sb->s_id);
 
 	sb->s_magic = SYSV_MAGIC_BASE + sbi->s_type;
@@ -338,12 +337,12 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		sb->s_d_op = &sysv_dentry_operations;
 	root_inode = sysv_iget(sb, SYSV_ROOT_INO);
 	if (IS_ERR(root_inode)) {
-		printk("SysV FS: get root inode failed\n");
+		pr_err("SysV FS: get root inode failed\n");
 		return 0;
 	}
 	sb->s_root = d_make_root(root_inode);
 	if (!sb->s_root) {
-		printk("SysV FS: get root dentry failed\n");
+		pr_err("SysV FS: get root dentry failed\n");
 		return 0;
 	}
 	return 1;
@@ -415,7 +414,7 @@ static int sysv_fill_super(struct super_block *sb, void *data, int silent)
 	brelse(bh1);
 	brelse(bh);
 	sb_set_blocksize(sb, BLOCK_SIZE);
-	printk("oldfs: cannot read superblock\n");
+	pr_err("oldfs: cannot read superblock\n");
 failed:
 	kfree(sbi);
 	return -EINVAL;
@@ -423,13 +422,13 @@ failed:
 Eunknown:
 	brelse(bh);
 	if (!silent)
-		printk("VFS: unable to find oldfs superblock on device %s\n",
+		pr_err("VFS: unable to find oldfs superblock on device %s\n",
 			sb->s_id);
 	goto failed;
 Ebadsize:
 	brelse(bh);
 	if (!silent)
-		printk("VFS: oldfs: unsupported block size (%dKb)\n",
+		pr_err("VFS: oldfs: unsupported block size (%dKb)\n",
 			1<<(size-2));
 	goto failed;
 }
@@ -494,7 +493,7 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 
 	if ((bh = sb_bread(sb, 1)) == NULL) {
 		if (!silent)
-			printk("VFS: unable to read V7 FS superblock on "
+			pr_err("VFS: unable to read V7 FS superblock on "
 			       "device %s.\n", sb->s_id);
 		goto failed;
 	}
@@ -518,8 +517,7 @@ detected:
 		return 0;
 
 failed:
-	printk(KERN_ERR "VFS: could not find a valid V7 on %s.\n",
-		sb->s_id);
+	pr_err("VFS: could not find a valid V7 on %s.\n", sb->s_id);
 	brelse(bh);
 	kfree(sbi);
 	return -EINVAL;
-- 
1.8.4.5

