Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaGGFqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:46:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:10878 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaGGFqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:46:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="558162193"
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: f2fs: Add f2fs_balance_fs for direct IO
Date: Mon,  7 Jul 2014 13:46:28 +0800
Message-Id: <1404711988-18264-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, if a large amount of direct IO writes were done, the
segment allocation may be failed because no enough segments are gced.

Signed-off-by: Huang, Ying <ying.huang@intel.com>
---
 fs/f2fs/data.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1038,6 +1038,7 @@ static ssize_t f2fs_direct_IO(int rw, st
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
 	/* Let buffer I/O handle the inline data case. */
 	if (f2fs_has_inline_data(inode))
@@ -1046,8 +1047,11 @@ static ssize_t f2fs_direct_IO(int rw, st
 	if (check_direct_IO(inode, rw, iter, offset))
 		return 0;
 
+	if (rw == WRITE)
+		f2fs_balance_fs(sbi);
+
 	/* clear fsync mark to recover these blocks */
-	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
+	fsync_mark_clear(sbi, inode->i_ino);
 
 	return blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				  get_data_block);
