Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaHSQxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:53:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:36512 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbaHSQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:53:03 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] f2fs: don't skip checkpoint if there is no dirty node pages
Date: Tue, 19 Aug 2014 09:52:56 -0700
Message-Id: <1408467177-69746-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the errorneous scenario.
1. write data
2. do checkpoint
3. produce some dirty node pages by the gc thread
4. write back dirty node pages
5. f2fs_put_super will skip the checkpoint, since dirty count for node pages is
  zero.

This patch removes such the wrong condition check.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 633315a..60e3554 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -432,7 +432,7 @@ static void f2fs_put_super(struct super_block *sb)
 	stop_gc_thread(sbi);
 
 	/* We don't need to do checkpoint when it's clean */
-	if (sbi->s_dirty && get_pages(sbi, F2FS_DIRTY_NODES))
+	if (sbi->s_dirty)
 		write_checkpoint(sbi, true);
 
 	iput(sbi->node_inode);
-- 
1.8.5.2 (Apple Git-48)

