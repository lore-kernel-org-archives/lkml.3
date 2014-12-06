Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaLFTzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 14:55:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:37314 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaLFTzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 14:55:46 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/5] f2fs: count inline_xx in do_read_inode
Date: Sat,  6 Dec 2014 11:55:36 -0800
Message-Id: <1417895739-15251-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
References: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In do_read_inode, if we failed __recover_inline_status, the inode has inline
flag without increasing its count.
Later, f2fs_evict_inode will decrease the count, which causes -1.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 9fe110e..196cc78 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -148,6 +148,10 @@ static int do_read_inode(struct inode *inode)
 	__get_inode_rdev(inode, ri);
 
 	f2fs_put_page(node_page, 1);
+
+	stat_inc_inline_inode(inode);
+	stat_inc_inline_dir(inode);
+
 	return err;
 }
 
@@ -199,8 +203,6 @@ make_now:
 		goto bad_inode;
 	}
 	unlock_new_inode(inode);
-	stat_inc_inline_inode(inode);
-	stat_inc_inline_dir(inode);
 	trace_f2fs_iget(inode);
 	return inode;
 
-- 
2.1.1

