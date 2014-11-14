Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934839AbaKNA7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:59:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:42355 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbaKNA7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:59:43 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/3] f2fs: fix deadlock to grab 0'th data page
Date: Thu, 13 Nov 2014 16:59:33 -0800
Message-Id: <1415926774-49230-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415926774-49230-1-git-send-email-jaegeuk@kernel.org>
References: <1415926774-49230-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scenario is like this.

One trhead triggers:
  f2fs_write_data_pages
    lock_page
    f2fs_write_data_page
      f2fs_lock_op  <- wait

The other thread triggers:
  f2fs_truncate
    truncate_blocks
      f2fs_lock_op
        truncate_partial_data_page
          lock_page  <- wait for locking the page

This patch resolves this bug by relocating truncate_partial_data_page.
This function is just to truncate user data page and not related to FS
consistency as well.
And, we don't need to call truncate_inline_data. Rather than that,
f2fs_write_data_page will finally update inline_data later.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 54722a0..edc3ce8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -477,8 +477,6 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 	}
 
 	if (f2fs_has_inline_data(inode)) {
-		truncate_inline_data(ipage, from);
-		update_inode(inode, ipage);
 		f2fs_put_page(ipage, 1);
 		goto out;
 	}
@@ -504,13 +502,13 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 	f2fs_put_dnode(&dn);
 free_next:
 	err = truncate_inode_blocks(inode, free_from);
+out:
+	if (lock)
+		f2fs_unlock_op(sbi);
 
 	/* lastly zero out the first data page */
 	if (!err)
 		err = truncate_partial_data_page(inode, from);
-out:
-	if (lock)
-		f2fs_unlock_op(sbi);
 
 	trace_f2fs_truncate_blocks_exit(inode, err);
 	return err;
-- 
2.1.1

