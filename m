Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbaGOUgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:36:01 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:15120 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932797AbaGOUf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:35:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokRAMqPxVNbsm9N/2dsb2JhbABZgw6BKaw8CwUBbpwAgRAXdYQxLyOBGjeIRgHKPReFe4lQhEoFmxiLWYhMg0Y7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, hch@infradead.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/3] FS/SYSV: use __func__ in logging
Date: Tue, 15 Jul 2014 22:37:18 +0200
Message-Id: <1405456638-2040-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace function names in pr_err calls.
This also fixes unexisting reference to sysv_block_map.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/sysv/balloc.c | 26 +++++++++++++-------------
 fs/sysv/ialloc.c | 12 ++++++------
 fs/sysv/itree.c  |  2 +-
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/sysv/balloc.c b/fs/sysv/balloc.c
index bebaae2..3528609 100644
--- a/fs/sysv/balloc.c
+++ b/fs/sysv/balloc.c
@@ -56,7 +56,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 		return;
 
 	if (block < sbi->s_firstdatazone || block >= sbi->s_nzones) {
-		pr_err("sysv_free_block: trying to free block not in datazone\n");
+		pr_err("%s: trying to free block not in datazone\n", __func__);
 		return;
 	}
 
@@ -64,7 +64,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 	count = fs16_to_cpu(sbi, *sbi->s_bcache_count);
 
 	if (count > sbi->s_flc_size) {
-		pr_err("sysv_free_block: flc_count > flc_size\n");
+		pr_err("%s: flc_count > flc_size\n", __func__);
 		mutex_unlock(&sbi->s_lock);
 		return;
 	}
@@ -76,7 +76,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 		block += sbi->s_block_base;
 		bh = sb_getblk(sb, block);
 		if (!bh) {
-			pr_err("sysv_free_block: getblk() failed\n");
+			pr_err("%s: getblk() failed\n", __func__);
 			mutex_unlock(&sbi->s_lock);
 			return;
 		}
@@ -118,8 +118,8 @@ sysv_zone_t sysv_new_block(struct super_block * sb)
 	*sbi->s_bcache_count = cpu_to_fs16(sbi, count);
 
 	if (block < sbi->s_firstdatazone || block >= sbi->s_nzones) {
-		pr_err("sysv_new_block: new block %d is not in data zone\n",
-			block);
+		pr_err("%s: new block %d is not in data zone\n",
+		       __func__, block);
 		goto Enospc;
 	}
 
@@ -128,14 +128,15 @@ sysv_zone_t sysv_new_block(struct super_block * sb)
 
 		block += sbi->s_block_base;
 		if (!(bh = sb_bread(sb, block))) {
-			pr_err("sysv_new_block: cannot read free-list block\n");
+			pr_err("%s: cannot read free-list block\n", __func__);
 			/* retry this same block next time */
 			*sbi->s_bcache_count = cpu_to_fs16(sbi, 1);
 			goto Enospc;
 		}
 		count = fs16_to_cpu(sbi, *(__fs16*)bh->b_data);
 		if (count > sbi->s_flc_size) {
-			pr_err("sysv_new_block: free-list block with >flc_size entries\n");
+			pr_err("%s: free-list block with >flc_size entries\n",
+			       __func__);
 			brelse(bh);
 			goto Enospc;
 		}
@@ -215,22 +216,21 @@ done:
 	return count;
 
 Einval:
-	pr_err("sysv_count_free_blocks: new block %d is not in data zone\n",
-		block);
+	pr_err("%s: new block %d is not in data zone\n", __func__, block);
 	goto trust_sb;
 Eio:
-	pr_err("sysv_count_free_blocks: cannot read free-list block\n");
+	pr_err("%s: cannot read free-list block\n", __func__);
 	goto trust_sb;
 E2big:
-	pr_err("sysv_count_free_blocks: >flc_size entries in free-list block\n");
+	pr_err("%s: >flc_size entries in free-list block\n", __func__);
 	if (bh)
 		brelse(bh);
 trust_sb:
 	count = sb_count;
 	goto done;
 Ecount:
-	pr_err("sysv_count_free_blocks: free block count was %d, correcting to %d\n",
-	       sb_count, count);
+	pr_err("%s: free block count was %d, correcting to %d\n",
+	       __func__, sb_count, count);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		*sbi->s_free_blocks = cpu_to_fs32(sbi, count);
 		dirty_sb(sb);
diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
index a4aae6c..59b70f6 100644
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -109,13 +109,13 @@ void sysv_free_inode(struct inode * inode)
 	sb = inode->i_sb;
 	ino = inode->i_ino;
 	if (ino <= SYSV_ROOT_INO || ino > sbi->s_ninodes) {
-		pr_err("sysv_free_inode: inode 0,1,2 or nonexistent inode\n");
+		pr_err("%s: inode 0,1,2 or nonexistent inode\n", __func__);
 		return;
 	}
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
-		pr_err("sysv_free_inode: unable to read inode block on device "
-		       "%s\n", inode->i_sb->s_id);
+		pr_err("%s: unable to read inode block on device %s\n",
+		       __func__, inode->i_sb->s_id);
 		return;
 	}
 	mutex_lock(&sbi->s_lock);
@@ -217,8 +217,8 @@ out:
 	return count;
 
 Einval:
-	pr_err("sysv_count_free_inodes: free inode count was %d, correcting to %d\n",
-	       sb_count, count);
+	pr_err("%s: free inode count was %d, correcting to %d\n",
+	       __func__, sb_count, count);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		*sbi->s_sb_total_free_inodes = cpu_to_fs16(SYSV_SB(sb), count);
 		dirty_sb(sb);
@@ -226,7 +226,7 @@ Einval:
 	goto out;
 
 Eio:
-	pr_err("sysv_count_free_inodes: unable to read inode table\n");
+	pr_err("%s: unable to read inode table\n", __func__);
 trust_sb:
 	count = sb_count;
 	goto out;
diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 909416e..4a66296 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -29,7 +29,7 @@ static int block_to_path(struct inode *inode, long block, int offsets[DEPTH])
 	int n = 0;
 
 	if (block < 0) {
-		pr_err("sysv_block_map: block < 0\n");
+		pr_err("%s: block < 0\n", __func__);
 	} else if (block < DIRECT) {
 		offsets[n++] = block;
 	} else if ( (block -= DIRECT) < indirect_blocks) {
-- 
1.8.4.5

