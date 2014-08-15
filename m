Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaHOWC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:02:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:54433 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaHOWC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:02:57 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/4] f2fs: prevent checkpoint during roll-forward
Date: Fri, 15 Aug 2014 15:03:47 -0700
Message-Id: <1408140229-54949-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1408140229-54949-1-git-send-email-jaegeuk@kernel.org>
References: <1408140229-54949-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any checkpoint should not be done during the core roll-forward procedure.
Especially, it includes error cases too.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/recovery.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 7ca7aad..d36ef35 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -459,6 +459,9 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	/* step #1: find fsynced inode numbers */
 	sbi->por_doing = true;
 
+	/* prevent checkpoint */
+	mutex_lock(&sbi->cp_mutex);
+
 	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
 
 	err = find_fsync_dnodes(sbi, &inode_list);
@@ -490,8 +493,13 @@ out:
 		/* Flush all the NAT/SIT pages */
 		while (get_pages(sbi, F2FS_DIRTY_META))
 			sync_meta_pages(sbi, META, LONG_MAX);
+		set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
+		mutex_unlock(&sbi->cp_mutex);
 	} else if (need_writecp) {
+		mutex_unlock(&sbi->cp_mutex);
 		write_checkpoint(sbi, false);
+	} else {
+		mutex_unlock(&sbi->cp_mutex);
 	}
 	return err;
 }
-- 
1.8.5.2 (Apple Git-48)

