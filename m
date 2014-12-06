Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaLFRzE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:55:04 -0500
Received: from 1wt.eu ([62.212.114.60]:40708 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbaLFRyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:55 -0500
Message-Id: <20141206174149.370589117@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:42:10 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 22/25] udf: Avoid infinite loop when processing indirect ICBs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 541d302ee5c46336cbad333222bc278b76cc1c42 upstream

We did not implement any bound on number of indirect ICBs we follow when
loading inode. Thus corrupted medium could cause kernel to go into an
infinite loop, possibly causing a stack overflow.

Fix the possible stack overflow by removing recursion from
__udf_read_inode() and limit number of indirect ICBs we follow to avoid
infinite loops.

Signed-off-by: Jan Kara <jack@suse.cz>
(back ported from commit c03aa9f6e1f938618e6db2e23afef0574efeeb65)
[ luis: adjusted context and replaced udf_err() by printk() ]
CVE-2014-6410
BugLink: http://bugs.launchpad.net/bugs/1370042
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/udf/inode.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 3c4ffb2..11c291e 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1062,13 +1062,22 @@ void udf_truncate(struct inode *inode)
 	unlock_kernel();
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
@@ -1106,28 +1115,26 @@ static void __udf_read_inode(struct inode *inode)
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
+					printk(KERN_ERR "udf: "
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
1.7.12.2.21.g234cd45.dirty



