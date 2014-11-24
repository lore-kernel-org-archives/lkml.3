Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaKXFxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 00:53:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:47588 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbaKXFwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 00:52:53 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] f2fs: fix livelock calling f2fs_iget during f2fs_evict_inode
Date: Sun, 23 Nov 2014 21:52:53 -0800
Message-Id: <1416808373-24417-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416808373-24417-1-git-send-email-jaegeuk@kernel.org>
References: <1416808373-24417-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In f2fs_evict_inode,
 commit_inmemory_pages
   f2fs_gc
     f2fs_iget
       iget_locked
         -> wait for inode free

Here, if the inode is same as the one to be evicted, f2fs should wait forever.
Actually, we should not call f2fs_balance_fs during f2fs_evict_inode to avoid
this.

But, the commit_inmem_pages calls f2fs_balance_fs by default, even if
f2fs_evict_inode wants to free inmemory pages only.

Hence, this patch adds to trigger f2fs_balance_fs only when there is something
to write.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9de857f..9a33e34 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -230,7 +230,16 @@ void commit_inmem_pages(struct inode *inode, bool abort)
 		.rw = WRITE_SYNC,
 	};
 
-	f2fs_balance_fs(sbi);
+	/*
+	 * The abort is true only when f2fs_evict_inode is called.
+	 * Basically, the f2fs_evict_inode doesn't produce any data writes, so
+	 * that we don't need to call f2fs_balance_fs.
+	 * Otherwise, f2fs_gc in f2fs_balance_fs can wait forever until this
+	 * inode becomes free by iget_locked in f2fs_iget.
+	 */
+	if (!abort)
+		f2fs_balance_fs(sbi);
+
 	f2fs_lock_op(sbi);
 
 	mutex_lock(&fi->inmem_lock);
-- 
2.1.1

