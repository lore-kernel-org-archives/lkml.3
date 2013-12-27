Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3L0Gqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:46:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:22270 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3L0Gqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:46:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,559,1384329600"; 
   d="scan'208";a="458267576"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Huajun Li <huajun.li@intel.com>
Subject: [PATCH] f2fs: fix build warning for f2fs_has_inline_data()
Date: Fri, 27 Dec 2013 14:45:08 +0800
Message-Id: <1388126708-27839-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix the issue reported by Fengguang Wu:
> Note: the f2fs/linux-3.4 HEAD 22a48d188024830d61365ce97a0a8a0bedd494a9 builds fine.
>       It only hurts bisectibility.
>
> All error/warnings:
>
>    In file included from fs/f2fs/data.c:22:0:
>    fs/f2fs/data.c: In function 'f2fs_direct_IO':
> >> fs/f2fs/f2fs.h:1302:12: error: inlining failed in call to
> >> always_inline 'f2fs_has_inline_data': function body not available
>     inline int f2fs_has_inline_data(struct inode *);
..snip..

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Huajun Li <huajun.li@intel.com>
---
 fs/f2fs/f2fs.h   |    5 ++++-
 fs/f2fs/inline.c |    5 -----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6991a28..e143ca1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1314,7 +1314,10 @@ extern const struct inode_operations f2fs_special_inode_operations;
 /*
  * inline.c
  */
-inline int f2fs_has_inline_data(struct inode *);
+static inline int f2fs_has_inline_data(struct inode *inode)
+{
+	return is_inode_flag_set(F2FS_I(inode), FI_INLINE_DATA);
+}
 bool f2fs_may_inline(struct inode *);
 int f2fs_read_inline_data(struct inode *, struct page *);
 int f2fs_convert_inline_data(struct inode *, pgoff_t);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 0e940ce..bcc6f65 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -13,11 +13,6 @@
 
 #include "f2fs.h"
 
-inline int f2fs_has_inline_data(struct inode *inode)
-{
-	return is_inode_flag_set(F2FS_I(inode), FI_INLINE_DATA);
-}
-
 bool f2fs_may_inline(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-- 
1.7.9.5

