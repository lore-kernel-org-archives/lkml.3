Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaKIHgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 02:36:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:55369 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaKIHgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 02:36:13 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/5] f2fs: disable roll-forward when active_logs = 2
Date: Sat,  8 Nov 2014 23:36:05 -0800
Message-Id: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The roll-forward mechanism should be activated when the number of active
logs is not 2.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c    | 2 ++
 fs/f2fs/segment.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 46311e7..54722a0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -132,6 +132,8 @@ static inline bool need_do_checkpoint(struct inode *inode)
 		need_cp = true;
 	else if (test_opt(sbi, FASTBOOT))
 		need_cp = true;
+	else if (sbi->active_logs == 2)
+		need_cp = true;
 
 	return need_cp;
 }
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 2fb3d7f..16721b5d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1090,8 +1090,8 @@ static int __get_segment_type_4(struct page *page, enum page_type p_type)
 		else
 			return CURSEG_COLD_DATA;
 	} else {
-		if (IS_DNODE(page) && !is_cold_node(page))
-			return CURSEG_HOT_NODE;
+		if (IS_DNODE(page) && is_cold_node(page))
+			return CURSEG_WARM_NODE;
 		else
 			return CURSEG_COLD_NODE;
 	}
-- 
2.1.1

