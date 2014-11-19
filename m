Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbaKSWgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:36:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:54140 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923AbaKSWfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:35:21 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/3] f2fs: write SSA pages under memory pressure
Date: Wed, 19 Nov 2014 14:35:10 -0800
Message-Id: <1416436510-6251-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
References: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under memory pressure, we don't need to skip SSA page writes.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 838e8ed..20a917b 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -178,7 +178,7 @@ static int f2fs_write_meta_page(struct page *page,
 
 	if (unlikely(sbi->por_doing))
 		goto redirty_out;
-	if (wbc->for_reclaim)
+	if (wbc->for_reclaim && page->index < GET_SUM_BLOCK(sbi, 0))
 		goto redirty_out;
 	if (unlikely(f2fs_cp_error(sbi)))
 		goto redirty_out;
@@ -187,6 +187,9 @@ static int f2fs_write_meta_page(struct page *page,
 	write_meta_page(sbi, page);
 	dec_page_count(sbi, F2FS_DIRTY_META);
 	unlock_page(page);
+
+	if (wbc->for_reclaim)
+		f2fs_submit_merged_bio(sbi, META, WRITE);
 	return 0;
 
 redirty_out:
-- 
2.1.1

