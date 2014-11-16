Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaKPWDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:03:52 -0500
Received: from 1wt.eu ([62.212.114.60]:47981 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbaKPWBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:24 -0500
Message-Id: <20141116215330.652422050@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:54:16 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Willy Tarreau <w@1wt.eu>
Subject: [ 48/48] isofs: Fix unbounded recursion when processing
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 relocated directories

From: Jan Kara <jack@suse.cz>

We did not check relocated directory in any way when processing Rock
Ridge 'CL' tag. Thus a corrupted isofs image can possibly have a CL
entry pointing to another CL entry leading to possibly unbounded
recursion in kernel code and thus stack overflow or deadlocks (if there
is a loop created from CL entries).

Fix the problem by not allowing CL entry to point to a directory entry
with CL entry (such use makes no good sense anyway) and by checking
whether CL entry doesn't point to itself.

CC: stable@vger.kernel.org
Reported-by: Chris Evans <cevans@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
(cherry picked from commit 410dd3cf4c9b36f27ed4542ee18b1af5e68645a4)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/isofs/inode.c | 15 ++++++++-------
 fs/isofs/isofs.h | 23 +++++++++++++++++++----
 fs/isofs/rock.c  | 39 ++++++++++++++++++++++++++++-----------
 3 files changed, 55 insertions(+), 22 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 6b4dcd4..f080dd7 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -56,7 +56,7 @@ static void isofs_put_super(struct super_block *sb)
 	return;
 }
 
-static int isofs_read_inode(struct inode *);
+static int isofs_read_inode(struct inode *, int relocated);
 static int isofs_statfs (struct dentry *, struct kstatfs *);
 
 static struct kmem_cache *isofs_inode_cachep;
@@ -1210,7 +1210,7 @@ out_toomany:
 	goto out;
 }
 
-static int isofs_read_inode(struct inode *inode)
+static int isofs_read_inode(struct inode *inode, int relocated)
 {
 	struct super_block *sb = inode->i_sb;
 	struct isofs_sb_info *sbi = ISOFS_SB(sb);
@@ -1355,7 +1355,7 @@ static int isofs_read_inode(struct inode *inode)
 	 */
 
 	if (!high_sierra) {
-		parse_rock_ridge_inode(de, inode);
+		parse_rock_ridge_inode(de, inode, relocated);
 		/* if we want uid/gid set, override the rock ridge setting */
 		if (sbi->s_uid_set)
 			inode->i_uid = sbi->s_uid;
@@ -1434,9 +1434,10 @@ static int isofs_iget5_set(struct inode *ino, void *data)
  * offset that point to the underlying meta-data for the inode.  The
  * code below is otherwise similar to the iget() code in
  * include/linux/fs.h */
-struct inode *isofs_iget(struct super_block *sb,
-			 unsigned long block,
-			 unsigned long offset)
+struct inode *__isofs_iget(struct super_block *sb,
+			   unsigned long block,
+			   unsigned long offset,
+			   int relocated)
 {
 	unsigned long hashval;
 	struct inode *inode;
@@ -1458,7 +1459,7 @@ struct inode *isofs_iget(struct super_block *sb,
 		return ERR_PTR(-ENOMEM);
 
 	if (inode->i_state & I_NEW) {
-		ret = isofs_read_inode(inode);
+		ret = isofs_read_inode(inode, relocated);
 		if (ret < 0) {
 			iget_failed(inode);
 			inode = ERR_PTR(ret);
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 7d33de8..f9c9793 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -107,7 +107,7 @@ extern int iso_date(char *, int);
 
 struct inode;		/* To make gcc happy */
 
-extern int parse_rock_ridge_inode(struct iso_directory_record *, struct inode *);
+extern int parse_rock_ridge_inode(struct iso_directory_record *, struct inode *, int relocated);
 extern int get_rock_ridge_filename(struct iso_directory_record *, char *, struct inode *);
 extern int isofs_name_translate(struct iso_directory_record *, char *, struct inode *);
 
@@ -118,9 +118,24 @@ extern struct dentry *isofs_lookup(struct inode *, struct dentry *, struct namei
 extern struct buffer_head *isofs_bread(struct inode *, sector_t);
 extern int isofs_get_blocks(struct inode *, sector_t, struct buffer_head **, unsigned long);
 
-extern struct inode *isofs_iget(struct super_block *sb,
-                                unsigned long block,
-                                unsigned long offset);
+struct inode *__isofs_iget(struct super_block *sb,
+			   unsigned long block,
+			   unsigned long offset,
+			   int relocated);
+
+static inline struct inode *isofs_iget(struct super_block *sb,
+				       unsigned long block,
+				       unsigned long offset)
+{
+	return __isofs_iget(sb, block, offset, 0);
+}
+
+static inline struct inode *isofs_iget_reloc(struct super_block *sb,
+					     unsigned long block,
+					     unsigned long offset)
+{
+	return __isofs_iget(sb, block, offset, 1);
+}
 
 /* Because the inode number is no longer relevant to finding the
  * underlying meta-data for an inode, we are free to choose a more
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index c2fb2dd..6fa4a86 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -289,12 +289,16 @@ eio:
 	goto out;
 }
 
+#define RR_REGARD_XA 1
+#define RR_RELOC_DE 2
+
 static int
 parse_rock_ridge_inode_internal(struct iso_directory_record *de,
-				struct inode *inode, int regard_xa)
+				struct inode *inode, int flags)
 {
 	int symlink_len = 0;
 	int cnt, sig;
+	unsigned int reloc_block;
 	struct inode *reloc;
 	struct rock_ridge *rr;
 	int rootflag;
@@ -306,7 +310,7 @@ parse_rock_ridge_inode_internal(struct iso_directory_record *de,
 
 	init_rock_state(&rs, inode);
 	setup_rock_ridge(de, inode, &rs);
-	if (regard_xa) {
+	if (flags & RR_REGARD_XA) {
 		rs.chr += 14;
 		rs.len -= 14;
 		if (rs.len < 0)
@@ -486,12 +490,22 @@ repeat:
 					"relocated directory\n");
 			goto out;
 		case SIG('C', 'L'):
-			ISOFS_I(inode)->i_first_extent =
-			    isonum_733(rr->u.CL.location);
-			reloc =
-			    isofs_iget(inode->i_sb,
-				       ISOFS_I(inode)->i_first_extent,
-				       0);
+			if (flags & RR_RELOC_DE) {
+				printk(KERN_ERR
+				       "ISOFS: Recursive directory relocation "
+				       "is not supported\n");
+				goto eio;
+			}
+			reloc_block = isonum_733(rr->u.CL.location);
+			if (reloc_block == ISOFS_I(inode)->i_iget5_block &&
+			    ISOFS_I(inode)->i_iget5_offset == 0) {
+				printk(KERN_ERR
+				       "ISOFS: Directory relocation points to "
+				       "itself\n");
+				goto eio;
+			}
+			ISOFS_I(inode)->i_first_extent = reloc_block;
+			reloc = isofs_iget_reloc(inode->i_sb, reloc_block, 0);
 			if (IS_ERR(reloc)) {
 				ret = PTR_ERR(reloc);
 				goto out;
@@ -639,9 +653,11 @@ static char *get_symlink_chunk(char *rpnt, struct rock_ridge *rr, char *plimit)
 	return rpnt;
 }
 
-int parse_rock_ridge_inode(struct iso_directory_record *de, struct inode *inode)
+int parse_rock_ridge_inode(struct iso_directory_record *de, struct inode *inode,
+			   int relocated)
 {
-	int result = parse_rock_ridge_inode_internal(de, inode, 0);
+	int flags = relocated ? RR_RELOC_DE : 0;
+	int result = parse_rock_ridge_inode_internal(de, inode, flags);
 
 	/*
 	 * if rockridge flag was reset and we didn't look for attributes
@@ -649,7 +665,8 @@ int parse_rock_ridge_inode(struct iso_directory_record *de, struct inode *inode)
 	 */
 	if ((ISOFS_SB(inode->i_sb)->s_rock_offset == -1)
 	    && (ISOFS_SB(inode->i_sb)->s_rock == 2)) {
-		result = parse_rock_ridge_inode_internal(de, inode, 14);
+		result = parse_rock_ridge_inode_internal(de, inode,
+							 flags | RR_REGARD_XA);
 	}
 	return result;
 }
-- 
1.7.12.2.21.g234cd45.dirty



