Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3KSKKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:10:02 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16457 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab3KSKJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:09:59 -0500
X-IronPort-AV: E=Sophos;i="4.93,728,1378828800"; 
   d="scan'208";a="9074463"
Message-ID: <528B377A.8060602@cn.fujitsu.com>
Date: Tue, 19 Nov 2013 18:03:38 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] f2fs: convert inc/dec_valid_node_count to inc/dec one
 count
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:08:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:08:04,
	Serialize complete at 2013/11/19 18:08:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/f2fs.h |   32 +++++++++++++++-----------------
 fs/f2fs/node.c |    6 +++---
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d0c6738..125bef0 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -685,50 +685,48 @@ static inline block_t __start_sum_addr(struct f2fs_sb_info *sbi)
 }
 
 static inline bool inc_valid_node_count(struct f2fs_sb_info *sbi,
-						struct inode *inode,
-						unsigned int count)
+						struct inode *inode)
 {
 	block_t	valid_block_count;
 	unsigned int valid_node_count;
 
 	spin_lock(&sbi->stat_lock);
 
-	valid_block_count = sbi->total_valid_block_count + (block_t)count;
-	sbi->alloc_valid_block_count += (block_t)count;
-	valid_node_count = sbi->total_valid_node_count + count;
-
+	valid_block_count = sbi->total_valid_block_count + 1;
 	if (valid_block_count > sbi->user_block_count) {
 		spin_unlock(&sbi->stat_lock);
 		return false;
 	}
 
+	valid_node_count = sbi->total_valid_node_count + 1;
 	if (valid_node_count > sbi->total_node_count) {
 		spin_unlock(&sbi->stat_lock);
 		return false;
 	}
 
 	if (inode)
-		inode->i_blocks += count;
-	sbi->total_valid_node_count = valid_node_count;
-	sbi->total_valid_block_count = valid_block_count;
+		inode->i_blocks++;
+
+	sbi->alloc_valid_block_count++;
+	sbi->total_valid_node_count++;
+	sbi->total_valid_block_count++;
 	spin_unlock(&sbi->stat_lock);
 
 	return true;
 }
 
 static inline void dec_valid_node_count(struct f2fs_sb_info *sbi,
-						struct inode *inode,
-						unsigned int count)
+						struct inode *inode)
 {
 	spin_lock(&sbi->stat_lock);
 
-	f2fs_bug_on(sbi->total_valid_block_count < count);
-	f2fs_bug_on(sbi->total_valid_node_count < count);
-	f2fs_bug_on(inode->i_blocks < count);
+	f2fs_bug_on(!sbi->total_valid_block_count);
+	f2fs_bug_on(!sbi->total_valid_node_count);
+	f2fs_bug_on(!inode->i_blocks);
 
-	inode->i_blocks -= count;
-	sbi->total_valid_node_count -= count;
-	sbi->total_valid_block_count -= (block_t)count;
+	inode->i_blocks--;
+	sbi->total_valid_node_count--;
+	sbi->total_valid_block_count--;
 
 	spin_unlock(&sbi->stat_lock);
 }
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e7b6826..b843a5b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -502,7 +502,7 @@ static void truncate_node(struct dnode_of_data *dn)
 
 	/* Deallocate node address */
 	invalidate_blocks(sbi, ni.blk_addr);
-	dec_valid_node_count(sbi, dn->inode, 1);
+	dec_valid_node_count(sbi, dn->inode);
 	set_node_addr(sbi, &ni, NULL_ADDR);
 
 	if (dn->nid == dn->inode->i_ino) {
@@ -851,7 +851,7 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	if (!inc_valid_node_count(sbi, dn->inode, 1)) {
+	if (!inc_valid_node_count(sbi, dn->inode)) {
 		err = -ENOSPC;
 		goto fail;
 	}
@@ -1560,7 +1560,7 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 	new_ni = old_ni;
 	new_ni.ino = ino;
 
-	if (!inc_valid_node_count(sbi, NULL, 1))
+	if (!inc_valid_node_count(sbi, NULL))
 		WARN_ON(1);
 	set_node_addr(sbi, &new_ni, NEW_ADDR);
 	inc_valid_inode_count(sbi);
-- 
1.7.7

