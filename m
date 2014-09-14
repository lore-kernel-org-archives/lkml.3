Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaINWO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:14:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:32802 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbaINWOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:14:24 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 01/10] f2fs: fix negative value for lseek offset
Date: Sun, 14 Sep 2014 15:14:15 -0700
Message-Id: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If application throws negative value of lseek with SEEK_DATA|SEEK_HOLE,
previous f2fs went into BUG_ON in get_dnode_of_data, which was reported
by Tommi Rantala.

He could make a simple code to detect this having:
	lseek(fd, -17595150933902LL, SEEK_DATA);

This patch should resolve that bug.

Reported-by: Tommi Rentala <tt.rantala@gmail.com>
[Jaegeuk Kim: relocate the condition as suggested by Chao]
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9f0ea3d..5cde363 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -353,6 +353,8 @@ static loff_t f2fs_llseek(struct file *file, loff_t offset, int whence)
 						maxbytes, i_size_read(inode));
 	case SEEK_DATA:
 	case SEEK_HOLE:
+		if (offset < 0)
+			return -ENXIO;
 		return f2fs_seek_block(file, offset, whence);
 	}
 
-- 
1.8.5.2 (Apple Git-48)

