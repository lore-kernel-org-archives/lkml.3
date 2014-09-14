Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaINWP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:15:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:32871 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbaINWOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:14:31 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 06/10] f2fs: do not skip latest inode information
Date: Sun, 14 Sep 2014 15:14:20 -0700
Message-Id: <1410732864-53069-6-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In f2fs_sync_file, if there is no written appended writes, it skips
to write its node blocks.
But, if there is up-to-date inode page, we should write it to update
its metadata during the roll-forward recovery.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c814cd2..fb96256 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -169,12 +169,21 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	if (!is_inode_flag_set(fi, FI_APPEND_WRITE) &&
 			!exist_written_data(sbi, ino, APPEND_INO)) {
+		struct page *i = find_get_page(NODE_MAPPING(sbi), ino);
+
+		/* But we need to avoid that there are some inode updates */
+		if ((i && PageDirty(i)) || !fsync_mark_done(sbi, ino)) {
+			f2fs_put_page(i, 0);
+			goto go_write;
+		}
+		f2fs_put_page(i, 0);
+
 		if (is_inode_flag_set(fi, FI_UPDATE_WRITE) ||
 				exist_written_data(sbi, ino, UPDATE_INO))
 			goto flush_out;
 		goto out;
 	}
-
+go_write:
 	/* guarantee free sections for fsync */
 	f2fs_balance_fs(sbi);
 
-- 
1.8.5.2 (Apple Git-48)

