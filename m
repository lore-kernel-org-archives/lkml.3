Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaKIHgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 02:36:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:55408 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaKIHgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 02:36:17 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4/5] f2fs: write node pages if checkpoint is not doing
Date: Sat,  8 Nov 2014 23:36:08 -0800
Message-Id: <1415518569-20626-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
References: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It needs to write node pages if checkpoint is not doing in order to avoid
memory pressure.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4ea2c47..6f514fb 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1314,10 +1314,12 @@ static int f2fs_write_node_page(struct page *page,
 		return 0;
 	}
 
-	if (wbc->for_reclaim)
-		goto redirty_out;
-
-	down_read(&sbi->node_write);
+	if (wbc->for_reclaim) {
+		if (!down_read_trylock(&sbi->node_write))
+			goto redirty_out;
+	} else {
+		down_read(&sbi->node_write);
+	}
 	set_page_writeback(page);
 	write_node_page(sbi, page, &fio, nid, ni.blk_addr, &new_addr);
 	set_node_addr(sbi, &ni, new_addr, is_fsync_dnode(page));
-- 
2.1.1

