Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbaHLTun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:50:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:58100 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbaHLTtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:49:39 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 11/13] f2fs: unlock_page when node page is redirtied out
Date: Tue, 12 Aug 2014 12:49:25 -0700
Message-Id: <1407872967-26423-11-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes missing unlock_page when a node page is redirtied out.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c80e3d5..9f126f8 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1129,8 +1129,11 @@ continue_unlock:
 				set_fsync_mark(page, 0);
 				set_dentry_mark(page, 0);
 			}
-			NODE_MAPPING(sbi)->a_ops->writepage(page, wbc);
-			wrote++;
+
+			if (NODE_MAPPING(sbi)->a_ops->writepage(page, wbc))
+				unlock_page(page);
+			else
+				wrote++;
 
 			if (--wbc->nr_to_write == 0)
 				break;
-- 
1.8.5.2 (Apple Git-48)

