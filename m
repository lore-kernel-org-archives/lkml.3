Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3CQI06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:26:58 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:46815 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3CQI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:26:47 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/5] f2fs: reorganize f2fs_setxattr
Date: Sun, 17 Mar 2013 17:26:39 +0900
Message-Id: <1363508799-2852-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

make use of F2FS_NAME_LEN for name length checking,
change return conditions at few places, by assigning
storing the errorvalue in 'error' and making a common
exit path.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/xattr.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 8038c04..f6f4c05 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -310,12 +310,13 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 
 	if (name == NULL)
 		return -EINVAL;
-	name_len = strlen(name);
 
 	if (value == NULL)
 		value_len = 0;
+
+	name_len = strlen(name);
 
-	if (name_len > 255 || value_len > MAX_VALUE_LEN)
+	if (name_len > F2FS_NAME_LEN || value_len > MAX_VALUE_LEN)
 		return -ERANGE;
 
 	f2fs_balance_fs(sbi);
@@ -326,8 +327,8 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 		struct dnode_of_data dn;
 
 		if (!alloc_nid(sbi, &fi->i_xattr_nid)) {
-			mutex_unlock_op(sbi, NODE_NEW);
-			return -ENOSPC;
+			error = -ENOSPC;
+			goto exit;
 		}
 		set_new_dnode(&dn, inode, NULL, NULL, fi->i_xattr_nid);
 		mark_inode_dirty(inode);
@@ -336,8 +337,8 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 		if (IS_ERR(page)) {
 			alloc_nid_failed(sbi, fi->i_xattr_nid);
 			fi->i_xattr_nid = 0;
-			mutex_unlock_op(sbi, NODE_NEW);
-			return PTR_ERR(page);
+			error = PTR_ERR(page);
+			goto exit;
 		}
 
 		alloc_nid_done(sbi, fi->i_xattr_nid);
@@ -349,8 +350,8 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 		/* The inode already has an extended attribute block. */
 		page = get_node_page(sbi, fi->i_xattr_nid);
 		if (IS_ERR(page)) {
-			mutex_unlock_op(sbi, NODE_NEW);
-			return PTR_ERR(page);
+			error = PTR_ERR(page);
+			goto exit;
 		}
 
 		base_addr = page_address(page);
@@ -438,6 +439,7 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 	return 0;
 cleanup:
 	f2fs_put_page(page, 1);
+exit:
 	mutex_unlock_op(sbi, NODE_NEW);
 	return error;
 }
-- 
1.7.9.5

