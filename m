Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3CRXVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:21:06 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:10349 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3CRXVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:21:04 -0400
Message-ID: <1363648862.1774.18.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 3/3] rbtree_test: add more rbtree integrity checks
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 18 Mar 2013 16:21:02 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking the rbtree, account for more properties:

   - Both children of a red node are black.
   - The tree has at least 2**bh(v)-1 internal nodes.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 lib/rbtree_test.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index 0fea14e..4c84f85 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -106,7 +106,7 @@ static void init(void)
 
 static bool is_red(struct rb_node *rb)
 {
-	return !(rb->__rb_parent_color & 1);
+	return rb ? !(rb->__rb_parent_color & RB_BLACK) : 0;
 }
 
 static int black_path_count(struct rb_node *rb)
@@ -120,24 +120,38 @@ static int black_path_count(struct rb_node *rb)
 static void check(int nr_nodes)
 {
 	struct rb_node *rb;
-	int count = 0;
-	int blacks = 0;
+	int blacks = 0, count = 0;
 	u32 prev_key = 0;
 
 	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
 		struct test_node *node = rb_entry(rb, struct test_node, rb);
+
+		/* sorted keys */
 		WARN_ON_ONCE(node->key < prev_key);
-		WARN_ON_ONCE(is_red(rb) &&
-			     (!rb_parent(rb) || is_red(rb_parent(rb))));
+
+		if (is_red(rb)) {
+			/*
+			 * root must be black and no path contains two
+			 * consecutive red nodes.
+			 */
+			WARN_ON_ONCE(!rb_parent(rb) || is_red(rb_parent(rb)));
+
+			/* both children of a red node are black */
+			WARN_ON_ONCE(is_red(rb->rb_left) || is_red(rb->rb_right));
+		}
+
 		if (!count)
 			blacks = black_path_count(rb);
 		else
 			WARN_ON_ONCE((!rb->rb_left || !rb->rb_right) &&
 				     blacks != black_path_count(rb));
+
 		prev_key = node->key;
 		count++;
 	}
+
 	WARN_ON_ONCE(count != nr_nodes);
+	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
 }
 
 static void check_augmented(int nr_nodes)
-- 
1.7.11.7




