Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaHFM7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:59:35 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:48074 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaHFM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:59:29 -0400
Date: Wed, 6 Aug 2014 18:29:25 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] fs/befs/btree.c: Remove typedef befs_btree_node
Message-ID: <20140806125925.GA8113@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for
befs_btree_node.

The following Coccinelle semantic patch detects the case.

@tn1@
type td;
@@

typedef struct { ... } td;

@script:python tf@
td << tn1.td;
tdres;
@@

coccinelle.tdres = td;

@@
type tn1.td;
identifier tf.tdres;
@@

-typedef
 struct
+  tdres
   { ... }
-td
 ;

@@
type tn1.td;
identifier tf.tdres;
@@

-td
+ struct tdres

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 fs/befs/btree.c | 53 +++++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index 9c7faa8..0826e91 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -78,11 +78,11 @@
 /*
  * In memory structure of each btree node
  */
-typedef struct {
+struct befs_btree_node {
 	befs_host_btree_nodehead head;	/* head of node converted to cpu byteorder */
 	struct buffer_head *bh;
 	befs_btree_nodehead *od_node;	/* on disk node */
-} befs_btree_node;
+};
 
 /* local constants */
 static const befs_off_t befs_bt_inval = 0xffffffffffffffffULL;
@@ -90,27 +90,30 @@ static const befs_off_t befs_bt_inval = 0xffffffffffffffffULL;
 /* local functions */
 static int befs_btree_seekleaf(struct super_block *sb, befs_data_stream * ds,
 			       befs_btree_super * bt_super,
-			       befs_btree_node * this_node,
+			       struct befs_btree_node *this_node,
 			       befs_off_t * node_off);
 
 static int befs_bt_read_super(struct super_block *sb, befs_data_stream * ds,
 			      befs_btree_super * sup);
 
 static int befs_bt_read_node(struct super_block *sb, befs_data_stream * ds,
-			     befs_btree_node * node, befs_off_t node_off);
+			     struct befs_btree_node *node,
+			     befs_off_t node_off);
 
-static int befs_leafnode(befs_btree_node * node);
+static int befs_leafnode(struct befs_btree_node *node);
 
-static fs16 *befs_bt_keylen_index(befs_btree_node * node);
+static fs16 *befs_bt_keylen_index(struct befs_btree_node *node);
 
-static fs64 *befs_bt_valarray(befs_btree_node * node);
+static fs64 *befs_bt_valarray(struct befs_btree_node *node);
 
-static char *befs_bt_keydata(befs_btree_node * node);
+static char *befs_bt_keydata(struct befs_btree_node *node);
 
-static int befs_find_key(struct super_block *sb, befs_btree_node * node,
+static int befs_find_key(struct super_block *sb,
+			 struct befs_btree_node *node,
 			 const char *findkey, befs_off_t * value);
 
-static char *befs_bt_get_key(struct super_block *sb, befs_btree_node * node,
+static char *befs_bt_get_key(struct super_block *sb,
+			     struct befs_btree_node *node,
 			     int index, u16 * keylen);
 
 static int befs_compare_strings(const void *key1, int keylen1,
@@ -191,7 +194,7 @@ befs_bt_read_super(struct super_block *sb, befs_data_stream * ds,
 
 static int
 befs_bt_read_node(struct super_block *sb, befs_data_stream * ds,
-		  befs_btree_node * node, befs_off_t node_off)
+		  struct befs_btree_node *node, befs_off_t node_off)
 {
 	uint off = 0;
 
@@ -247,7 +250,7 @@ int
 befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 		const char *key, befs_off_t * value)
 {
-	befs_btree_node *this_node = NULL;
+	struct befs_btree_node *this_node = NULL;
 	befs_btree_super bt_super;
 	befs_off_t node_off;
 	int res;
@@ -260,11 +263,11 @@ befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 		goto error;
 	}
 
-	this_node = kmalloc(sizeof (befs_btree_node),
+	this_node = kmalloc(sizeof(struct befs_btree_node),
 						GFP_NOFS);
 	if (!this_node) {
 		befs_error(sb, "befs_btree_find() failed to allocate %zu "
-			   "bytes of memory", sizeof (befs_btree_node));
+			   "bytes of memory", sizeof(struct befs_btree_node));
 		goto error;
 	}
 
@@ -333,7 +336,7 @@ befs_btree_find(struct super_block *sb, befs_data_stream * ds,
  * Use binary search instead of a linear.
  */
 static int
-befs_find_key(struct super_block *sb, befs_btree_node * node,
+befs_find_key(struct super_block *sb, struct befs_btree_node *node,
 	      const char *findkey, befs_off_t * value)
 {
 	int first, last, mid;
@@ -417,7 +420,7 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 		loff_t key_no, size_t bufsize, char *keybuf, size_t * keysize,
 		befs_off_t * value)
 {
-	befs_btree_node *this_node;
+	struct befs_btree_node *this_node;
 	befs_btree_super bt_super;
 	befs_off_t node_off = 0;
 	int cur_key;
@@ -436,9 +439,10 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 		goto error;
 	}
 
-	if ((this_node = kmalloc(sizeof (befs_btree_node), GFP_NOFS)) == NULL) {
+	this_node = kmalloc(sizeof(struct befs_btree_node), GFP_NOFS);
+	if (this_node == NULL) {
 		befs_error(sb, "befs_btree_read() failed to allocate %zu "
-			   "bytes of memory", sizeof (befs_btree_node));
+			   "bytes of memory", sizeof(struct befs_btree_node));
 		goto error;
 	}
 
@@ -545,7 +549,8 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
  */
 static int
 befs_btree_seekleaf(struct super_block *sb, befs_data_stream * ds,
-		    befs_btree_super * bt_super, befs_btree_node * this_node,
+		    befs_btree_super *bt_super,
+		    struct befs_btree_node *this_node,
 		    befs_off_t * node_off)
 {
 
@@ -600,7 +605,7 @@ befs_btree_seekleaf(struct super_block *sb, befs_data_stream * ds,
  * Return 1 if leaf, 0 if interior
  */
 static int
-befs_leafnode(befs_btree_node * node)
+befs_leafnode(struct befs_btree_node *node)
 {
 	/* all interior nodes (and only interior nodes) have an overflow node */
 	if (node->head.overflow == befs_bt_inval)
@@ -623,7 +628,7 @@ befs_leafnode(befs_btree_node * node)
  * Except that rounding up to 8 works, and rounding up to 4 doesn't.
  */
 static fs16 *
-befs_bt_keylen_index(befs_btree_node * node)
+befs_bt_keylen_index(struct befs_btree_node *node)
 {
 	const int keylen_align = 8;
 	unsigned long int off =
@@ -644,7 +649,7 @@ befs_bt_keylen_index(befs_btree_node * node)
  * of the node pointed to by the node header
  */
 static fs64 *
-befs_bt_valarray(befs_btree_node * node)
+befs_bt_valarray(struct befs_btree_node *node)
 {
 	void *keylen_index_start = (void *) befs_bt_keylen_index(node);
 	size_t keylen_index_size = node->head.all_key_count * sizeof (fs16);
@@ -660,7 +665,7 @@ befs_bt_valarray(befs_btree_node * node)
  * of the node pointed to by the node header 
  */
 static char *
-befs_bt_keydata(befs_btree_node * node)
+befs_bt_keydata(struct befs_btree_node *node)
 {
 	return (char *) ((void *) node->od_node + sizeof (befs_btree_nodehead));
 }
@@ -676,7 +681,7 @@ befs_bt_keydata(befs_btree_node * node)
  * Returns NULL on failure (bad input) and sets *@keylen = 0
  */
 static char *
-befs_bt_get_key(struct super_block *sb, befs_btree_node * node,
+befs_bt_get_key(struct super_block *sb, struct befs_btree_node *node,
 		int index, u16 * keylen)
 {
 	int prev_key_end;
-- 
1.9.1

