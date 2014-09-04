Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaIDHvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:51:32 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47717 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbaIDHvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:51:14 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: gioh.kim@lge.com, akpm@linux-foundation.org, jack@suse.cz, tytso@mit.edu,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org,
        adilger.kernel@dilger.ca
Cc: minchan@kernel.org, js1304@gmail.com, gunho.lee@lge.com
Subject: [PATCHv4 2/3] ext4: use non-movable memory for the ext4 superblock
Date: Thu,  4 Sep 2014 16:29:40 +0900
Message-Id: <1409815781-28011-3-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A buffer-cache for superblock is disturbing page migration,
because the buffer-cache is not released until unmount.
The buffer-cache must be allocated from non-movable area.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32b43ad..e4b62b3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3435,7 +3435,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		logical_sb_block = sb_block;
 	}
 
-	if (!(bh = sb_bread(sb, logical_sb_block))) {
+	if (!(bh = sb_bread_unmovable(sb, logical_sb_block))) {
 		ext4_msg(sb, KERN_ERR, "unable to read superblock");
 		goto out_fail;
 	}
@@ -3645,7 +3645,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		brelse(bh);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
-		bh = sb_bread(sb, logical_sb_block);
+		bh = sb_bread_unmovable(sb, logical_sb_block);
 		if (!bh) {
 			ext4_msg(sb, KERN_ERR,
 			       "Can't read superblock on 2nd try");
@@ -3867,7 +3867,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
-		sbi->s_group_desc[i] = sb_bread(sb, block);
+		sbi->s_group_desc[i] = sb_bread_unmovable(sb, block);
 		if (!sbi->s_group_desc[i]) {
 			ext4_msg(sb, KERN_ERR,
 			       "can't read group descriptor %d", i);
-- 
1.7.9.5

