Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839Ab3IFEDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:03:19 -0400
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:47137 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757Ab3IFEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:03:14 -0400
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 3/5] Squashfs: fix corruption checks in squashfs_readdir()
Date: Fri,  6 Sep 2013 04:54:39 +0100
Message-Id: <1378439682-12830-4-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
References: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
X-MDF-HostID: 19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dir_count and size fields when read from disk are sanity
checked for correctness.  However, the sanity checks only check the
values are not greater than expected.  As dir_count and size were
incorrectly defined as signed ints, this can lead to corrupted values
appearing as negative which are not trapped.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/dir.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index f7f527b..1192084 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -105,9 +105,8 @@ static int squashfs_readdir(struct file *file, struct dir_context *ctx)
 	struct inode *inode = file_inode(file);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	u64 block = squashfs_i(inode)->start + msblk->directory_table;
-	int offset = squashfs_i(inode)->offset, length, dir_count, size,
-				type, err;
-	unsigned int inode_number;
+	int offset = squashfs_i(inode)->offset, length, type, err;
+	unsigned int inode_number, dir_count, size;
 	struct squashfs_dir_header dirh;
 	struct squashfs_dir_entry *dire;
 
-- 
1.8.3.2

