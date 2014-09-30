Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaI3WGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:06:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60736 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaI3VcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 003/103] udf: Avoid infinite loop when processing indirect ICBs
Date: Tue, 30 Sep 2014 14:30:08 -0700
Message-Id: <1412112708-27356-4-git-send-email-kamal@canonical.com>
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

commit c03aa9f6e1f938618e6db2e23afef0574efeeb65 upstream.

We did not implement any bound on number of indirect ICBs we follow when
loading inode. Thus corrupted medium could cause kernel to go into an
infinite loop, possibly causing a stack overflow.

Fix the possible stack overflow by removing recursion from
__udf_read_inode() and limit number of indirect ICBs we follow to avoid
infinite loops.

Signed-off-by: Jan Kara <jack@suse.cz>
Reference: CVE-2014-6410
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/udf/inode.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index ba59939..55ce50d 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1269,6 +1269,13 @@ update_time:
 	return 0;
 }
 
+/*
+ * Maximum length of linked list formed by ICB hierarchy. The chosen number is
+ * arbitrary - just that we hopefully don't limit any real use of rewritten
+ * inode on write-once media but avoid looping for too long on corrupted media.
+ */
+#define UDF_MAX_ICB_NESTING 1024
+
 static void __udf_read_inode(struct inode *inode)
 {
 	struct buffer_head *bh = NULL;
@@ -1278,7 +1285,9 @@ static void __udf_read_inode(struct inode *inode)
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 	unsigned int link_count;
+	unsigned int indirections = 0;
 
+reread:
 	/*
 	 * Set defaults, but the inode is still incomplete!
 	 * Note: get_new_inode() sets the following on a new inode:
@@ -1316,28 +1325,26 @@ static void __udf_read_inode(struct inode *inode)
 		ibh = udf_read_ptagged(inode->i_sb, &iinfo->i_location, 1,
 					&ident);
 		if (ident == TAG_IDENT_IE && ibh) {
-			struct buffer_head *nbh = NULL;
 			struct kernel_lb_addr loc;
 			struct indirectEntry *ie;
 
 			ie = (struct indirectEntry *)ibh->b_data;
 			loc = lelb_to_cpu(ie->indirectICB.extLocation);
 
-			if (ie->indirectICB.extLength &&
-				(nbh = udf_read_ptagged(inode->i_sb, &loc, 0,
-							&ident))) {
-				if (ident == TAG_IDENT_FE ||
-					ident == TAG_IDENT_EFE) {
-					memcpy(&iinfo->i_location,
-						&loc,
-						sizeof(struct kernel_lb_addr));
-					brelse(bh);
-					brelse(ibh);
-					brelse(nbh);
-					__udf_read_inode(inode);
+			if (ie->indirectICB.extLength) {
+				brelse(bh);
+				brelse(ibh);
+				memcpy(&iinfo->i_location, &loc,
+				       sizeof(struct kernel_lb_addr));
+				if (++indirections > UDF_MAX_ICB_NESTING) {
+					udf_err(inode->i_sb,
+						"too many ICBs in ICB hierarchy"
+						" (max %d supported)\n",
+						UDF_MAX_ICB_NESTING);
+					make_bad_inode(inode);
 					return;
 				}
-				brelse(nbh);
+				goto reread;
 			}
 		}
 		brelse(ibh);
-- 
1.9.1

