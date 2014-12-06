Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaLFT4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 14:56:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:37342 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbaLFTzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 14:55:48 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4/5] f2fs: release inmemory pages when the file was closed
Date: Sat,  6 Dec 2014 11:55:38 -0800
Message-Id: <1417895739-15251-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
References: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If file is closed, let's drop inmemory pages.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 146e58a..b6f3fbf 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -901,6 +901,14 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 	return f2fs_convert_inline_inode(inode);
 }
 
+static int f2fs_release_file(struct inode *inode, struct file *filp)
+{
+	/* some remained atomic pages should discarded */
+	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode))
+		commit_inmem_pages(inode, true);
+	return 0;
+}
+
 static int f2fs_ioc_commit_atomic_write(struct file *filp)
 {
 	struct inode *inode = file_inode(filp);
@@ -1010,6 +1018,7 @@ const struct file_operations f2fs_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.open		= generic_file_open,
+	.release	= f2fs_release_file,
 	.mmap		= f2fs_file_mmap,
 	.fsync		= f2fs_sync_file,
 	.fallocate	= f2fs_fallocate,
-- 
2.1.1

