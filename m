Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3HDCQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 22:16:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:38715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3HDCOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 22:14:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,810,1367996400"; 
   d="scan'208";a="341280883"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 23/23] ramfs: enable transparent huge page cache
Date: Sun,  4 Aug 2013 05:17:25 +0300
Message-Id: <1375582645-29274-24-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

ramfs is the most simple fs from page cache point of view. Let's start
transparent huge page cache enabling here.

ramfs pages are not movable[1] and switching to transhuge pages doesn't
affect that. We need to fix this eventually.

[1] http://lkml.org/lkml/2013/4/2/720

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/ramfs/file-mmu.c | 3 ++-
 fs/ramfs/inode.c    | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index 4884ac5..3236e41 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -32,7 +32,7 @@
 
 const struct address_space_operations ramfs_aops = {
 	.readpage	= simple_readpage,
-	.write_begin	= simple_write_begin,
+	.write_begin	= simple_thp_write_begin,
 	.write_end	= simple_write_end,
 	.set_page_dirty = __set_page_dirty_no_writeback,
 };
@@ -47,6 +47,7 @@ const struct file_operations ramfs_file_operations = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 	.llseek		= generic_file_llseek,
+	.release	= simple_thp_release,
 };
 
 const struct inode_operations ramfs_file_inode_operations = {
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 39d1465..5dafdfc 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -61,7 +61,11 @@ struct inode *ramfs_get_inode(struct super_block *sb,
 		inode_init_owner(inode, dir, mode);
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
-		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+		/*
+		 * TODO: make ramfs pages movable
+		 */
+		mapping_set_gfp_mask(inode->i_mapping,
+				GFP_TRANSHUGE & ~__GFP_MOVABLE);
 		mapping_set_unevictable(inode->i_mapping);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
-- 
1.8.3.2

