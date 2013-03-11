Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3CKTla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:41:30 -0400
Received: from vpn.mirsal.fr ([178.79.141.108]:47708 "EHLO
	mirsal-laptop1.mirsal.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754223Ab3CKTlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:41:24 -0400
From: Mirsal Ennaime <mirsal@mirsal.fr>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mirsal Ennaime <mirsal@mirsal.fr>
Subject: [PATCH 1/4] drivers: android: binder: Move the node release code to a separate function
Date: Mon, 11 Mar 2013 20:31:52 +0100
Message-Id: <1363030315-10229-2-git-send-email-mirsal@mirsal.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binder_deferred_release() function has many levels of indentation
which makes it difficult to read. This patch moves the code which deals
with disposing of a binder node to a separate binder_node_deferred_release()
function, thus removing one level of indentation and allowing the code to
fit in 80 columns.

Signed-off-by: Mirsal Ennaime <mirsal@mirsal.fr>
---
 drivers/staging/android/binder.c |   80 +++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 24456a0..11b3f7b 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2878,11 +2878,57 @@ static int binder_release(struct inode *nodp, struct file *filp)
 	return 0;
 }
 
+static int binder_node_deferred_release(struct binder_node *node, int refs)
+{
+	struct binder_ref *ref;
+	int death = 0;
+
+	list_del_init(&node->work.entry);
+	binder_release_work(&node->async_todo);
+
+	if (hlist_empty(&node->refs)) {
+		kfree(node);
+		binder_stats_deleted(BINDER_STAT_NODE);
+
+		return refs;
+	}
+
+	node->proc = NULL;
+	node->local_strong_refs = 0;
+	node->local_weak_refs = 0;
+	hlist_add_head(&node->dead_node, &binder_dead_nodes);
+
+	hlist_for_each_entry(ref, &node->refs, node_entry) {
+		refs++;
+
+		if (!ref->death)
+			goto out;
+
+		death++;
+
+		if (list_empty(&ref->death->work.entry)) {
+			ref->death->work.type = BINDER_WORK_DEAD_BINDER;
+			list_add_tail(&ref->death->work.entry,
+				&ref->proc->todo);
+			wake_up_interruptible(&ref->proc->wait);
+		} else
+			BUG();
+	}
+
+out:
+	binder_debug(BINDER_DEBUG_DEAD_BINDER,
+		"node %d now dead, refs %d, death %d\n",
+		node->debug_id, refs, death);
+
+	return refs;
+}
+
 static void binder_deferred_release(struct binder_proc *proc)
 {
 	struct binder_transaction *t;
 	struct rb_node *n;
-	int threads, nodes, incoming_refs, outgoing_refs, buffers, active_transactions, page_count;
+	int threads, nodes, incoming_refs, outgoing_refs, nd_refs,
+		buffers, active_transactions, page_count;
 
 	BUG_ON(proc->vma);
 	BUG_ON(proc->files);
@@ -2909,36 +2955,8 @@ static void binder_deferred_release(struct binder_proc *proc)
 
 		nodes++;
 		rb_erase(&node->rb_node, &proc->nodes);
-		list_del_init(&node->work.entry);
-		binder_release_work(&node->async_todo);
-		if (hlist_empty(&node->refs)) {
-			kfree(node);
-			binder_stats_deleted(BINDER_STAT_NODE);
-		} else {
-			struct binder_ref *ref;
-			int death = 0;
-
-			node->proc = NULL;
-			node->local_strong_refs = 0;
-			node->local_weak_refs = 0;
-			hlist_add_head(&node->dead_node, &binder_dead_nodes);
-
-			hlist_for_each_entry(ref, &node->refs, node_entry) {
-				incoming_refs++;
-				if (ref->death) {
-					death++;
-					if (list_empty(&ref->death->work.entry)) {
-						ref->death->work.type = BINDER_WORK_DEAD_BINDER;
-						list_add_tail(&ref->death->work.entry, &ref->proc->todo);
-						wake_up_interruptible(&ref->proc->wait);
-					} else
-						BUG();
-				}
-			}
-			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "node %d now dead, refs %d, death %d\n",
-				      node->debug_id, incoming_refs, death);
-		}
+		nd_refs = binder_node_deferred_release(node, incoming_refs);
+		incoming_refs = nd_refs;
 	}
 	outgoing_refs = 0;
 	while ((n = rb_first(&proc->refs_by_desc))) {
-- 
1.7.10.4

