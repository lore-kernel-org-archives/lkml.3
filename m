Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbbAIKsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:48:13 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44545 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757437AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 71/78] udf: Verify symlink size before loading it
Date: Fri,  9 Jan 2015 11:32:20 +0100
Message-Id: <2bf2e3b94225c76d7990acc7579fecd6306d0a3a.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a1d47b262952a45aae62bd49cfaf33dd76c11a2c upstream.

UDF specification allows arbitrarily large symlinks. However we support
only symlinks at most one block large. Check the length of the symlink
so that we don't access memory beyond end of the symlink block.

Reported-by: Carl Henrik Lunde <chlunde@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/udf/symlink.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index d7c6dbe4194b..d89f324bc387 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -80,11 +80,17 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	struct inode *inode = page->mapping->host;
 	struct buffer_head *bh = NULL;
 	unsigned char *symlink;
-	int err = -EIO;
+	int err;
 	unsigned char *p = kmap(page);
 	struct udf_inode_info *iinfo;
 	uint32_t pos;
 
+	/* We don't support symlinks longer than one block */
+	if (inode->i_size > inode->i_sb->s_blocksize) {
+		err = -ENAMETOOLONG;
+		goto out_unmap;
+	}
+
 	iinfo = UDF_I(inode);
 	pos = udf_block_map(inode, 0);
 
@@ -94,8 +100,10 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	} else {
 		bh = sb_bread(inode->i_sb, pos);
 
-		if (!bh)
-			goto out;
+		if (!bh) {
+			err = -EIO;
+			goto out_unlock_inode;
+		}
 
 		symlink = bh->b_data;
 	}
@@ -109,9 +117,10 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	unlock_page(page);
 	return 0;
 
-out:
+out_unlock_inode:
 	up_read(&iinfo->i_data_sem);
 	SetPageError(page);
+out_unmap:
 	kunmap(page);
 	unlock_page(page);
 	return err;
-- 
2.2.1

