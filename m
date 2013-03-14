Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934689Ab3CNRwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:52:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:52046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934598Ab3CNRtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:49:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,845,1355126400"; 
   d="scan'208";a="279559796"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2, RFC 20/30] ramfs: enable transparent huge page cache
Date: Thu, 14 Mar 2013 19:50:25 +0200
Message-Id: <1363283435-7666-21-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

ramfs is the most simple fs from page cache point of view. Let's start
transparent huge page cache enabling here.

For now we allocate only non-movable huge page. It's not yet clear if
movable page is safe here and what need to be done to make it safe.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/ramfs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index c24f1e1..da30b4f 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -61,7 +61,11 @@ struct inode *ramfs_get_inode(struct super_block *sb,
 		inode_init_owner(inode, dir, mode);
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
-		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+		/*
+		 * TODO: what should be done to make movable safe?
+		 */
+		mapping_set_gfp_mask(inode->i_mapping,
+				GFP_TRANSHUGE & ~__GFP_MOVABLE);
 		mapping_set_unevictable(inode->i_mapping);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
-- 
1.7.10.4

