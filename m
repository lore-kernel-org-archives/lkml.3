Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3KFOzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:55:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:34091 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932210Ab3KFOw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:52:58 -0500
Message-Id: <20131106145257.119314672@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 09:50:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [for-next][PATCH 1/8] trace/trace_stat: use rbtree postorder iteration helper instead of
 opencoding
References: <20131106145041.904349372@goodmis.org>
Content-Disposition: inline; filename=0007-trace-trace_stat-use-rbtree-postorder-iteration-help.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Link: http://lkml.kernel.org/r/1383345566-25087-2-git-send-email-cody@linux.vnet.ibm.com

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stat.c | 41 +++++------------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 847f88a..7af6736 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -43,46 +43,15 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
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
+	rbtree_postorder_for_each_entry_safe(snode, n, &session->stat_root, node) {
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
1.8.4.rc3


