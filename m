Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaHTKho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 06:37:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37578 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaHTKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 06:37:42 -0400
X-AuditID: cbfee61a-f79e46d00000134f-5f-53f47a6706f0
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/3] f2fs: fix incorrect calculation with total/free
 inode num
Date: Wed, 20 Aug 2014 18:36:46 +0800
Message-id: <008001cfbc62$bb9959c0$32cc0d40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+6wLJThgCr64cKSzCbCdwER7Oq8g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAd30qi/BBk8+iVs8WT+L2eLSIneL
	y7vmsDkwe2xa1cnmsXvBZyaPz5vkApijuGxSUnMyy1KL9O0SuDJmLtrGWnBAqGL9sn0sDYxb
	+bsYOTkkBEwkDjR9ZIGwxSQu3FvP1sXIxSEksIhRomf2bRYI5wejxL9tJ9hAqtgEVCSWd/xn
	ArFFgOxDiy6zg9jMAh4SjR3fWUFsYYEoiQ3fJ4LVswioStx8sROsnlfAUmJL4wlGCFtQ4sfk
	eywQvVoSm7c1sULY8hKb17xlhrhIQWLH2deMELv0JJ6s6mODqBGX2HjkFssERoFZSEbNQjJq
	FpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHMDPpHYwrmywOMQowMGoxMOr
	kP05WIg1say4MvcQowQHs5IIr0/ul2Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNIT
	S1KzU1MLUotgskwcnFINjH0exTFSnx+Y/2Seesc8fOnGS8v2atUuWN4090v5J9Hvxn8uRyzh
	Mjb8PG9Dz4t1Mee4TQ8KN3AbS7GnchwuzN+3PkvxxHHbvTqd59bN3cLMbOC04+SrQImW9sku
	U4wZfz65sPJ1doWG1IQd+5fyFU8o7WyXXtKgvySk4bpa/4Rb6y4YKBZ/OabEUpyRaKjFXFSc
	CABcp0SUXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theoretically, our total inodes number is the same as total node number, but
there are three node ids are reserved in f2fs, they are 0, 1 (node nid), and 2
(meta nid), and they should never be used by user, so our total/free inode
number calculated in ->statfs is wrong.

This patch indroduces F2FS_RESERVED_NODE_NUM and then fixes this issue by
recalculating total/free inode number with the macro.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c          | 2 +-
 fs/f2fs/super.c         | 4 ++--
 include/linux/f2fs_fs.h | 3 +++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index d3d90d2..b21a04d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1967,7 +1967,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks;
 
 	/* not used nids: 0, node, meta, (and root counted as valid node) */
-	nm_i->available_nids = nm_i->max_nid - 3;
+	nm_i->available_nids = nm_i->max_nid - F2FS_RESERVED_NODE_NUM;
 	nm_i->fcnt = 0;
 	nm_i->nat_cnt = 0;
 	nm_i->ram_thresh = DEF_RAM_THRESHOLD;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 657582f..85d0ae3 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -505,8 +505,8 @@ static int f2fs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bfree = buf->f_blocks - valid_user_blocks(sbi) - ovp_count;
 	buf->f_bavail = user_block_count - valid_user_blocks(sbi);
 
-	buf->f_files = sbi->total_node_count;
-	buf->f_ffree = sbi->total_node_count - valid_inode_count(sbi);
+	buf->f_files = sbi->total_node_count - F2FS_RESERVED_NODE_NUM;
+	buf->f_ffree = buf->f_files - valid_inode_count(sbi);
 
 	buf->f_namelen = F2FS_NAME_LEN;
 	buf->f_fsid.val[0] = (u32)id;
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 6ff0b0b..0ed77f3 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -24,6 +24,9 @@
 #define NULL_ADDR		((block_t)0)	/* used as block_t addresses */
 #define NEW_ADDR		((block_t)-1)	/* used as block_t addresses */
 
+/* 0, 1(node nid), 2(meta nid) are reserved node id */
+#define F2FS_RESERVED_NODE_NUM		3
+
 #define F2FS_ROOT_INO(sbi)	(sbi->root_ino_num)
 #define F2FS_NODE_INO(sbi)	(sbi->node_ino_num)
 #define F2FS_META_INO(sbi)	(sbi->meta_ino_num)
-- 
2.0.1.474.g72c7794


