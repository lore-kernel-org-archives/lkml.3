Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaFMKRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:17:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:55038 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaFMKRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:17:49 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/3] f2fs: fix not to allocate unnecessary blocks during fallocate
Date: Fri, 13 Jun 2014 19:17:46 +0900
Message-Id: <1402654666-81383-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1402654666-81383-1-git-send-email-jaegeuk@kernel.org>
References: <1402654666-81383-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the fallocate bug like below. (See xfstests/255)

In fallocate(fd, 0, 20480),
expand_inode_data processes
	for (index = pg_start; index <= pg_end; index++) {
		f2fs_reserve_block();
		...
	}

So, even though fallocate requests 20480, 5 blocks, f2fs allocates 6 blocks
including pg_end.
So, this patch adds one condition to avoid block allocation.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 623df73..d621ddb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -664,11 +664,14 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 	for (index = pg_start; index <= pg_end; index++) {
 		struct dnode_of_data dn;
 
+		if (index == pg_end && !off_end)
+			goto noalloc;
+
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		ret = f2fs_reserve_block(&dn, index);
 		if (ret)
 			break;
-
+noalloc:
 		if (pg_start == pg_end)
 			new_size = offset + len;
 		else if (index == pg_start && off_start)
-- 
1.8.5.2 (Apple Git-48)

