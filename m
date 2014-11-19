Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbaKSWfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:35:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:54125 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862AbaKSWfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:35:19 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/3] f2fs: submit bio for node blocks in the reclaim path
Date: Wed, 19 Nov 2014 14:35:09 -0800
Message-Id: <1416436510-6251-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
References: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a node page is request to be written during the reclaiming path, we should
submit the bio to avoid pending to recliam it.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 478ce1e..dbf49cc 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1326,6 +1326,10 @@ static int f2fs_write_node_page(struct page *page,
 	dec_page_count(sbi, F2FS_DIRTY_NODES);
 	up_read(&sbi->node_write);
 	unlock_page(page);
+
+	if (wbc->for_reclaim)
+		f2fs_submit_merged_bio(sbi, NODE, WRITE);
+
 	return 0;
 
 redirty_out:
-- 
2.1.1

