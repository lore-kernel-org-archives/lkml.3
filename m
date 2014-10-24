Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaJXVZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:25:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:44375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbaJXVVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:21:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,782,1406617200"; 
   d="scan'208";a="595527330"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v12 13/20] ext2: Remove ext2_use_xip
Date: Fri, 24 Oct 2014 17:20:45 -0400
Message-Id: <1414185652-28663-14-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ext2_use_xip() with test_opt(XIP) which expands to the same code

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 fs/ext2/ext2.h  | 4 ++++
 fs/ext2/inode.c | 2 +-
 fs/ext2/namei.c | 4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index d9a17d0..5ecf570 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -380,7 +380,11 @@ struct ext2_inode {
 #define EXT2_MOUNT_NO_UID32		0x000200  /* Disable 32-bit UIDs */
 #define EXT2_MOUNT_XATTR_USER		0x004000  /* Extended user attributes */
 #define EXT2_MOUNT_POSIX_ACL		0x008000  /* POSIX Access Control Lists */
+#ifdef CONFIG_FS_XIP
 #define EXT2_MOUNT_XIP			0x010000  /* Execute in place */
+#else
+#define EXT2_MOUNT_XIP			0
+#endif
 #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
 #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
 #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 59d6c7d..cba3833 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1394,7 +1394,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext2_file_inode_operations;
-		if (ext2_use_xip(inode->i_sb)) {
+		if (test_opt(inode->i_sb, XIP)) {
 			inode->i_mapping->a_ops = &ext2_aops_xip;
 			inode->i_fop = &ext2_xip_file_operations;
 		} else if (test_opt(inode->i_sb, NOBH)) {
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index c268d0a..846c356 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -105,7 +105,7 @@ static int ext2_create (struct inode * dir, struct dentry * dentry, umode_t mode
 		return PTR_ERR(inode);
 
 	inode->i_op = &ext2_file_inode_operations;
-	if (ext2_use_xip(inode->i_sb)) {
+	if (test_opt(inode->i_sb, XIP)) {
 		inode->i_mapping->a_ops = &ext2_aops_xip;
 		inode->i_fop = &ext2_xip_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
@@ -126,7 +126,7 @@ static int ext2_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 		return PTR_ERR(inode);
 
 	inode->i_op = &ext2_file_inode_operations;
-	if (ext2_use_xip(inode->i_sb)) {
+	if (test_opt(inode->i_sb, XIP)) {
 		inode->i_mapping->a_ops = &ext2_aops_xip;
 		inode->i_fop = &ext2_xip_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
-- 
2.1.1

