Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3CQI1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:27:34 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55664 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3CQI11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:27:27 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 5/5] f2fs: avoid BUG_ON from check_nid_range and update return path in do_read_inode
Date: Sun, 17 Mar 2013 17:27:20 +0900
Message-Id: <1363508840-2954-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In function check_nid_range, there is no need to trigger BUG_ON and make kernel stop.
Instead it could just check and indicate the inode number to be EINVAL.
Update the return path in do_read_inode to use the return from check_nid_range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/f2fs.h  |    6 ++++--
 fs/f2fs/inode.c |    6 +++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index be7ae70..1dae921 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -515,9 +515,11 @@ static inline void mutex_unlock_op(struct f2fs_sb_info *sbi, enum lock_type t)
 /*
  * Check whether the given nid is within node id range.
  */
-static inline void check_nid_range(struct f2fs_sb_info *sbi, nid_t nid)
+static inline int check_nid_range(struct f2fs_sb_info *sbi, nid_t nid)
 {
-	BUG_ON((nid >= NM_I(sbi)->max_nid));
+	if (nid >= NM_I(sbi)->max_nid)
+		return -EINVAL;
+	return 0;
 }
 
 #define F2FS_DEFAULT_ALLOCATED_BLOCKS	1
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index ddae412..6d82020 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -44,7 +44,11 @@ static int do_read_inode(struct inode *inode)
 	struct f2fs_inode *ri;
 
 	/* Check if ino is within scope */
-	check_nid_range(sbi, inode->i_ino);
+	if (check_nid_range(sbi, inode->i_ino)) {
+		f2fs_msg(inode->i_sb, KERN_ERR, "bad inode number: %lu",
+			 (unsigned long) inode->i_ino);
+		return -EINVAL;
+	}
 
 	node_page = get_node_page(sbi, inode->i_ino);
 	if (IS_ERR(node_page))
-- 
1.7.9.5

