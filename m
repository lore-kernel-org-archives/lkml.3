Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaJ2FF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:05:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:42395 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaJ2FFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:05:55 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/4] f2fs: call write_checkpoint under disabled gc
Date: Tue, 28 Oct 2014 22:05:50 -0700
Message-Id: <1414559153-92771-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the write_checkpoint, we should avoid f2fs_gc trigger to avoid any
filesystem consistency.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 21ccc48..d391a59 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1046,7 +1046,9 @@ int f2fs_trim_fs(struct f2fs_sb_info *sbi, struct fstrim_range *range)
 	cpc.trim_minlen = range->minlen >> sbi->log_blocksize;
 
 	/* do checkpoint to issue discard commands safely */
+	mutex_lock(&sbi->gc_mutex);
 	write_checkpoint(sbi, &cpc);
+	mutex_unlock(&sbi->gc_mutex);
 out:
 	range->len = cpc.trimmed << sbi->log_blocksize;
 	return 0;
-- 
2.1.1

