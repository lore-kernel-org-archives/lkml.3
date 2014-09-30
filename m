Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaI3WGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:06:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60756 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaI3VcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 002/103] udf: Fold udf_fill_inode() into __udf_read_inode()
Date: Tue, 30 Sep 2014 14:30:07 -0700
Message-Id: <1412112708-27356-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit bb7720a0b4a8ca3269fd86fbb45a78d2e0d3deaf upstream.

There's no good reason to separate these since udf_fill_inode() is
called only from __udf_read_inode() and both do part of the same thing.

Signed-off-by: Jan Kara <jack@suse.cz>
[ kamal: 3.13 stable prereq for
  c03aa9f "udf: Avoid infinite loop when processing indirect ICBs" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/udf/inode.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 062b792..ba59939 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -51,7 +51,6 @@ MODULE_LICENSE("GPL");
 
 static umode_t udf_convert_permissions(struct fileEntry *);
 static int udf_update_inode(struct inode *, int);
-static void udf_fill_inode(struct inode *, struct buffer_head *);
 static int udf_sync_inode(struct inode *inode);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static sector_t inode_getblk(struct inode *, sector_t, int *, int *);
@@ -1274,8 +1273,11 @@ static void __udf_read_inode(struct inode *inode)
 {
 	struct buffer_head *bh = NULL;
 	struct fileEntry *fe;
+	struct extendedFileEntry *efe;
 	uint16_t ident;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
+	unsigned int link_count;
 
 	/*
 	 * Set defaults, but the inode is still incomplete!
@@ -1306,6 +1308,7 @@ static void __udf_read_inode(struct inode *inode)
 	}
 
 	fe = (struct fileEntry *)bh->b_data;
+	efe = (struct extendedFileEntry *)bh->b_data;
 
 	if (fe->icbTag.strategyType == cpu_to_le16(4096)) {
 		struct buffer_head *ibh;
@@ -1345,22 +1348,6 @@ static void __udf_read_inode(struct inode *inode)
 		make_bad_inode(inode);
 		return;
 	}
-	udf_fill_inode(inode, bh);
-
-	brelse(bh);
-}
-
-static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
-{
-	struct fileEntry *fe;
-	struct extendedFileEntry *efe;
-	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
-	struct udf_inode_info *iinfo = UDF_I(inode);
-	unsigned int link_count;
-
-	fe = (struct fileEntry *)bh->b_data;
-	efe = (struct extendedFileEntry *)bh->b_data;
-
 	if (fe->icbTag.strategyType == cpu_to_le16(4))
 		iinfo->i_strat4096 = 0;
 	else /* if (fe->icbTag.strategyType == cpu_to_le16(4096)) */
@@ -1550,6 +1537,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		} else
 			make_bad_inode(inode);
 	}
+	brelse(bh);
 }
 
 static int udf_alloc_i_data(struct inode *inode, size_t size)
-- 
1.9.1

