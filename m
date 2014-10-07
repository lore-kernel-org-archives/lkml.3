Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaJGXTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:19:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbaJGXTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: [PATCH 3.16 01/26] udf: Avoid infinite loop when processing indirect ICBs
Date: Tue,  7 Oct 2014 16:19:17 -0700
Message-Id: <20141007231848.531941472@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/inode.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1271,13 +1271,22 @@ update_time:
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
 	struct fileEntry *fe;
 	uint16_t ident;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	unsigned int indirections = 0;
 
+reread:
 	/*
 	 * Set defaults, but the inode is still incomplete!
 	 * Note: get_new_inode() sets the following on a new inode:
@@ -1314,28 +1323,26 @@ static void __udf_read_inode(struct inod
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


