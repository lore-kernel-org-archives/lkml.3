Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaL2BOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:14:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33186 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbaL2BMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:16 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.140775847@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 07/27] udf: Avoid infinite loop when processing
 indirect ICBs
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/inode.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1176,13 +1176,22 @@ update_time:
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
@@ -1219,28 +1228,26 @@ static void __udf_read_inode(struct inod
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

