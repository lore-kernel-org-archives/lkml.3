Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbbAGCDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:03:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbbAGCB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:01:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Carl Henrik Lunde <chlunde@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.10 34/38] udf: Verify symlink size before loading it
Date: Tue,  6 Jan 2015 17:50:46 -0800
Message-Id: <20150107014957.861909783@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014952.440109372@linuxfoundation.org>
References: <20150107014952.440109372@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a1d47b262952a45aae62bd49cfaf33dd76c11a2c upstream.

UDF specification allows arbitrarily large symlinks. However we support
only symlinks at most one block large. Check the length of the symlink
so that we don't access memory beyond end of the symlink block.

Reported-by: Carl Henrik Lunde <chlunde@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/symlink.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -80,11 +80,17 @@ static int udf_symlink_filler(struct fil
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
 
@@ -94,8 +100,10 @@ static int udf_symlink_filler(struct fil
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
@@ -109,9 +117,10 @@ static int udf_symlink_filler(struct fil
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


