Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaF1L6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 07:58:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:54049 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbaF1L6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 07:58:48 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: check bdi->dirty_exceeded when trying to skip data writes
Date: Sat, 28 Jun 2014 20:58:38 +0900
Message-Id: <1403956718-17575-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't check the current backing device status, balance_dirty_pages can
fall into infinite pausing routine.

This can be occurred when a lot of directories make a small number of dirty
dentry pages including files.

Reported-by: Brian Chadwick <brianchad@westnet.com.au>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 56907c6..a90f51d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -43,6 +43,8 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >> 12;
 		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
 	} else if (type == DIRTY_DENTS) {
+		if (sbi->sb->s_bdi->dirty_exceeded)
+			return false;
 		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
 		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 1);
 	}
-- 
1.8.5.2 (Apple Git-48)

