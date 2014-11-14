Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbaKNA7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:59:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:42377 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbaKNA7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:59:45 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/3] f2fs: convert inline_data when i_size becomes large
Date: Thu, 13 Nov 2014 16:59:34 -0800
Message-Id: <1415926774-49230-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415926774-49230-1-git-send-email-jaegeuk@kernel.org>
References: <1415926774-49230-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If i_size becomes large outside of MAX_INLINE_DATA, we shoud convert the inode.
Otherwise, we can make some dirty pages during the truncation, and those pages
will be written through f2fs_write_data_page.
At that moment, the inode has still inline_data, so that it tries to write non-
zero pages into inline_data area.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c   | 6 ++++++
 fs/f2fs/inline.c | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index edc3ce8..7c2ec3e 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -522,6 +522,12 @@ void f2fs_truncate(struct inode *inode)
 
 	trace_f2fs_truncate(inode);
 
+	/* we should check inline_data size */
+	if (f2fs_has_inline_data(inode) && !f2fs_may_inline(inode)) {
+		if (f2fs_convert_inline_inode(inode))
+			return;
+	}
+
 	if (!truncate_blocks(inode, i_size_read(inode), true)) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		mark_inode_dirty(inode);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 2310670..053d114 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -24,6 +24,9 @@ bool f2fs_may_inline(struct inode *inode)
 	if (!S_ISREG(inode->i_mode))
 		return false;
 
+	if (i_size_read(inode) > MAX_INLINE_DATA)
+		return false;
+
 	return true;
 }
 
-- 
2.1.1

