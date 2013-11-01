Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3KAWkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:40:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57489 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab3KAWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:40:10 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] trace/trace_stat: use rbtree postorder iteration helper instead of opencoding
Date: Fri,  1 Nov 2013 15:38:46 -0700
Message-Id: <1383345566-25087-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110122-0928-0000-0000-0000032B5686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 kernel/trace/trace_stat.c | 42 ++++++------------------------------------
 1 file changed, 6 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 847f88a..fa53acc 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -43,46 +43,16 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
 /* The root directory for all stat files */
 static struct dentry		*stat_dir;
 
-/*
- * Iterate through the rbtree using a post order traversal path
- * to release the next node.
- * It won't necessary release one at each iteration
- * but it will at least advance closer to the next one
- * to be released.
- */
-static struct rb_node *release_next(struct tracer_stat *ts,
-				    struct rb_node *node)
+static void __reset_stat_session(struct stat_session *session)
 {
-	struct stat_node *snode;
-	struct rb_node *parent = rb_parent(node);
-
-	if (node->rb_left)
-		return node->rb_left;
-	else if (node->rb_right)
-		return node->rb_right;
-	else {
-		if (!parent)
-			;
-		else if (parent->rb_left == node)
-			parent->rb_left = NULL;
-		else
-			parent->rb_right = NULL;
+	struct stat_node *snode, *n;
 
-		snode = container_of(node, struct stat_node, node);
-		if (ts->stat_release)
-			ts->stat_release(snode->stat);
+	rbtree_postorder_for_each_entry_safe(snode, n, &session->stat_root,
+			node) {
+		if (session->ts->stat_release)
+			session->ts->stat_release(snode->stat);
 		kfree(snode);
-
-		return parent;
 	}
-}
-
-static void __reset_stat_session(struct stat_session *session)
-{
-	struct rb_node *node = session->stat_root.rb_node;
-
-	while (node)
-		node = release_next(session->ts, node);
 
 	session->stat_root = RB_ROOT;
 }
-- 
1.8.4.2

