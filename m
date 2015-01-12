Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbbALSee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:34:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbbALSbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 206/216] udf: Verify symlink size before loading it
Date: Mon, 12 Jan 2015 18:29:44 +0000
Message-Id: <1421087394-2712-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a1d47b262952a45aae62bd49cfaf33dd76c11a2c upstream.

UDF specification allows arbitrarily large symlinks. However we support
only symlinks at most one block large. Check the length of the symlink
so that we don't access memory beyond end of the symlink block.

Reported-by: Carl Henrik Lunde <chlunde@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/udf/symlink.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index ab94e6671849..2d0c3720e9af 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -99,11 +99,17 @@ static int udf_symlink_filler(struct file *file, struct page *page)
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
 
@@ -113,8 +119,10 @@ static int udf_symlink_filler(struct file *file, struct page *page)
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
@@ -130,9 +138,10 @@ static int udf_symlink_filler(struct file *file, struct page *page)
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
2.1.4

