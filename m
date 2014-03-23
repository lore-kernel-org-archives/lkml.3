Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaCWTM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:12:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:29851 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaCWTJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:09:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,715,1389772800"; 
   d="scan'208";a="505944113"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v7 16/22] ext2: Remove ext2_aops_xip
Date: Sun, 23 Mar 2014 15:08:42 -0400
Message-Id: <0b6512aa46a504459f41d3c609fc20c93d4a911a.1395591795.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1395591795.git.matthew.r.wilcox@intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395591795.git.matthew.r.wilcox@intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't need a special address_space_operations any more

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext2/ext2.h  | 1 -
 fs/ext2/inode.c | 7 +------
 fs/ext2/namei.c | 4 ++--
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index b30c3bd..b8b1c11 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -793,7 +793,6 @@ extern const struct file_operations ext2_xip_file_operations;
 
 /* inode.c */
 extern const struct address_space_operations ext2_aops;
-extern const struct address_space_operations ext2_aops_xip;
 extern const struct address_space_operations ext2_nobh_aops;
 
 /* namei.c */
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 67124f0..7ca76da 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -890,11 +890,6 @@ const struct address_space_operations ext2_aops = {
 	.error_remove_page	= generic_error_remove_page,
 };
 
-const struct address_space_operations ext2_aops_xip = {
-	.bmap			= ext2_bmap,
-	.direct_IO		= ext2_direct_IO,
-};
-
 const struct address_space_operations ext2_nobh_aops = {
 	.readpage		= ext2_readpage,
 	.readpages		= ext2_readpages,
@@ -1393,7 +1388,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext2_file_inode_operations;
 		if (test_opt(inode->i_sb, XIP)) {
-			inode->i_mapping->a_ops = &ext2_aops_xip;
+			inode->i_mapping->a_ops = &ext2_aops;
 			inode->i_fop = &ext2_xip_file_operations;
 		} else if (test_opt(inode->i_sb, NOBH)) {
 			inode->i_mapping->a_ops = &ext2_nobh_aops;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 7ca803f..0db888c 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -105,7 +105,7 @@ static int ext2_create (struct inode * dir, struct dentry * dentry, umode_t mode
 
 	inode->i_op = &ext2_file_inode_operations;
 	if (test_opt(inode->i_sb, XIP)) {
-		inode->i_mapping->a_ops = &ext2_aops_xip;
+		inode->i_mapping->a_ops = &ext2_aops;
 		inode->i_fop = &ext2_xip_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
 		inode->i_mapping->a_ops = &ext2_nobh_aops;
@@ -126,7 +126,7 @@ static int ext2_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 	inode->i_op = &ext2_file_inode_operations;
 	if (test_opt(inode->i_sb, XIP)) {
-		inode->i_mapping->a_ops = &ext2_aops_xip;
+		inode->i_mapping->a_ops = &ext2_aops;
 		inode->i_fop = &ext2_xip_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
 		inode->i_mapping->a_ops = &ext2_nobh_aops;
-- 
1.9.0

