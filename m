Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaKRB6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:58:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:54309 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaKRB6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:58:02 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] f2fs: fix to call put_page at the error handling routine
Date: Mon, 17 Nov 2014 17:57:53 -0800
Message-Id: <1416275874-74186-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The locked page should be released before returning the function.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 053d114..f26fb87 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -141,8 +141,8 @@ int f2fs_convert_inline_inode(struct inode *inode)
 
 	ipage = get_node_page(sbi, inode->i_ino);
 	if (IS_ERR(ipage)) {
-		f2fs_unlock_op(sbi);
-		return PTR_ERR(ipage);
+		err = PTR_ERR(ipage);
+		goto out;
 	}
 
 	set_new_dnode(&dn, inode, ipage, ipage, 0);
@@ -151,7 +151,7 @@ int f2fs_convert_inline_inode(struct inode *inode)
 		err = f2fs_convert_inline_page(&dn, page);
 
 	f2fs_put_dnode(&dn);
-
+out:
 	f2fs_unlock_op(sbi);
 
 	f2fs_put_page(page, 1);
-- 
2.1.1

