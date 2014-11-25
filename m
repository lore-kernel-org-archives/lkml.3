Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaKYXkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:40:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:42270 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaKYXkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:40:14 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] f2fs: fix deadlock during inline_data conversion
Date: Tue, 25 Nov 2014 15:39:55 -0800
Message-Id: <1416958796-39186-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A deadlock can be occurred:
Thread 1]                             Thread 2]
 - f2fs_write_data_pages              - f2fs_write_begin
   - lock_page(page #0)
                                        - grab_cache_page(page #X)
                                        - get_node_page(inode_page)
                                        - grab_cache_page(page #0)
                                          : to convert inline_data
   - f2fs_write_data_page
     - f2fs_write_inline_data
       - get_node_page(inode_page)

In this case, trying to lock inode_page and page #0 causes deadlock.
In order to avoid this, this patch adds a rule for this locking policy,
which is that page #0 should be locked followed by inode_page lock.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 12dd58a..c7bc626 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -936,6 +936,17 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	trace_f2fs_write_begin(inode, pos, len, flags);
 
 	f2fs_balance_fs(sbi);
+
+	/*
+	 * We should check this at this moment to avoid deadlock on inode page
+	 * and #0 page. The locking rule for inline_data conversion should be:
+	 * lock_page(page #0) -> lock_page(inode_page)
+	 */
+	if (index != 0) {
+		err = f2fs_convert_inline_inode(inode);
+		if (err)
+			goto fail;
+	}
 repeat:
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
@@ -960,21 +971,10 @@ repeat:
 			set_inode_flag(F2FS_I(inode), FI_DATA_EXIST);
 			sync_inode_page(&dn);
 			goto put_next;
-		} else if (page->index == 0) {
-			err = f2fs_convert_inline_page(&dn, page);
-			if (err)
-				goto put_fail;
-		} else {
-			struct page *p = grab_cache_page(inode->i_mapping, 0);
-			if (!p) {
-				err = -ENOMEM;
-				goto put_fail;
-			}
-			err = f2fs_convert_inline_page(&dn, p);
-			f2fs_put_page(p, 1);
-			if (err)
-				goto put_fail;
 		}
+		err = f2fs_convert_inline_page(&dn, page);
+		if (err)
+			goto put_fail;
 	}
 	err = f2fs_reserve_block(&dn, index);
 	if (err)
-- 
2.1.1

