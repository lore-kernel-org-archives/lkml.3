Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaHSQxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:53:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:36542 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbaHSQxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:53:49 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: skip if inline_data was converted already
Date: Tue, 19 Aug 2014 09:53:43 -0700
Message-Id: <1408467223-69823-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks inline_data one more time under the inode page lock whether
its inline_data is converted or not.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inline.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 4d1f39f..3e8ecdf 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -68,7 +68,7 @@ out:
 
 static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 {
-	int err;
+	int err = 0;
 	struct page *ipage;
 	struct dnode_of_data dn;
 	void *src_addr, *dst_addr;
@@ -86,6 +86,10 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 		goto out;
 	}
 
+	/* someone else converted inline_data already */
+	if (!f2fs_has_inline_data(inode))
+		goto out;
+
 	/*
 	 * i_addr[0] is not used for inline data,
 	 * so reserving new block will not destroy inline data
-- 
1.8.5.2 (Apple Git-48)

