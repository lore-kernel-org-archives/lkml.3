Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbbA0Xcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:32:31 -0500
Received: from mail.kernel.org ([198.145.29.136]:53637 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758964AbbA0XcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:32:02 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4/5] f2fs: should fail mount when trying to recover data on read-only dev
Date: Tue, 27 Jan 2015 15:31:42 -0800
Message-Id: <1422401503-4769-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
References: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device is read-only, we should not proceed data recovery.
But, if the previous checkpoint was done by normal clean shutdown, it's safe to
proceed the recovery, since there will be no data to be recovered.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 0ca1fb2..7039969 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1149,6 +1149,15 @@ try_onemore:
 
 	/* recover fsynced data */
 	if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
+		/*
+		 * mount should be failed, when device has readonly mode, and
+		 * previous checkpoint was not done by clean system shutdown.
+		 */
+		if (bdev_read_only(sb->s_bdev) &&
+				!is_set_ckpt_flags(sbi->ckpt, CP_UMOUNT_FLAG)) {
+			err = -EROFS;
+			goto free_kobj;
+		}
 		err = recover_fsync_data(sbi);
 		if (err) {
 			f2fs_msg(sb, KERN_ERR,
-- 
2.1.1

