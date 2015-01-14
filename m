Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbbANAd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:33:29 -0500
Received: from mail.kernel.org ([198.145.29.136]:55487 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbANAd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:33:28 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] f2fs: avoid infinite loop on cp_error
Date: Tue, 13 Jan 2015 16:33:23 -0800
Message-Id: <1421195604-5256-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cp_error is set, we should avoid all the infinite loop.
In f2fs_sync_file, there is a hole, and this patch fixes that.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index a7114858..0d88a28 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -247,6 +247,10 @@ go_write:
 sync_nodes:
 	sync_node_pages(sbi, ino, &wbc);
 
+	/* if cp_error was enabled, we should avoid infinite loop */
+	if (unlikely(f2fs_cp_error(sbi)))
+		goto out;
+
 	if (need_inode_block_update(sbi, ino)) {
 		mark_inode_dirty_sync(inode);
 		f2fs_write_inode(inode, NULL);
-- 
2.1.1

