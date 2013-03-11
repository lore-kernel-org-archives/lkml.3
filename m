Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3CKX04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:26:56 -0400
Received: from vpn.mirsal.fr ([178.79.141.108]:53868 "EHLO
	mirsal-laptop1.mirsal.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754615Ab3CKX0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:26:52 -0400
From: Mirsal Ennaime <mirsal@mirsal.fr>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>, Mirsal Ennaime <mirsal@mirsal.fr>
Subject: [PATCH v2 2/3] drivers: android: binder: Fix code style
Date: Tue, 12 Mar 2013 00:26:27 +0100
Message-Id: <1363044388-11409-3-git-send-email-mirsal@mirsal.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
 <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Use tabs
 * Remove a few "80-columns" checkpatch warnings
 * Separate code paths with empty lines for readability

Signed-off-by: Mirsal Ennaime <mirsal@mirsal.fr>
---
 drivers/staging/android/binder.c |   42 +++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 43f823d..4652cd8 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2927,57 +2927,69 @@ static void binder_deferred_release(struct binder_proc *proc)
 {
 	struct binder_transaction *t;
 	struct rb_node *n;
-	int threads, nodes, incoming_refs, outgoing_refs, buffers, active_transactions, page_count;
+	int threads, nodes, incoming_refs, outgoing_refs, buffers,
+		active_transactions, page_count;
 
 	BUG_ON(proc->vma);
 	BUG_ON(proc->files);
 
 	hlist_del(&proc->proc_node);
+
 	if (binder_context_mgr_node && binder_context_mgr_node->proc == proc) {
 		binder_debug(BINDER_DEBUG_DEAD_BINDER,
-			     "binder_release: %d context_mgr_node gone\n",
-			     proc->pid);
+			"binder_release: %d context_mgr_node gone\n",
+			proc->pid);
 		binder_context_mgr_node = NULL;
 	}
 
 	threads = 0;
 	active_transactions = 0;
 	while ((n = rb_first(&proc->threads))) {
-		struct binder_thread *thread = rb_entry(n, struct binder_thread, rb_node);
+		struct binder_thread *thread;
+
+		thread = rb_entry(n, struct binder_thread, rb_node);
 		threads++;
 		active_transactions += binder_free_thread(proc, thread);
 	}
+
 	nodes = 0;
 	incoming_refs = 0;
 	while ((n = rb_first(&proc->nodes))) {
-		struct binder_node *node = rb_entry(n, struct binder_node, rb_node);
+		struct binder_node *node;
 
+		node = rb_entry(n, struct binder_node, rb_node);
 		nodes++;
 		rb_erase(&node->rb_node, &proc->nodes);
 		incoming_refs = binder_node_release(node, incoming_refs);
 	}
+
 	outgoing_refs = 0;
 	while ((n = rb_first(&proc->refs_by_desc))) {
-		struct binder_ref *ref = rb_entry(n, struct binder_ref,
-						  rb_node_desc);
+		struct binder_ref *ref;
+
+		ref = rb_entry(n, struct binder_ref, rb_node_desc);
 		outgoing_refs++;
 		binder_delete_ref(ref);
 	}
+
 	binder_release_work(&proc->todo);
 	binder_release_work(&proc->delivered_death);
-	buffers = 0;
 
+	buffers = 0;
 	while ((n = rb_first(&proc->allocated_buffers))) {
-		struct binder_buffer *buffer = rb_entry(n, struct binder_buffer,
-							rb_node);
+		struct binder_buffer *buffer;
+
+		buffer = rb_entry(n, struct binder_buffer, rb_node);
+
 		t = buffer->transaction;
 		if (t) {
 			t->buffer = NULL;
 			buffer->transaction = NULL;
 			pr_err("release proc %d, transaction %d, not freed\n",
-			       proc->pid, t->debug_id);
+				proc->pid, t->debug_id);
 			/*BUG();*/
 		}
+
 		binder_free_buf(proc, buffer);
 		buffers++;
 	}
@@ -2987,19 +2999,21 @@ static void binder_deferred_release(struct binder_proc *proc)
 	page_count = 0;
 	if (proc->pages) {
 		int i;
+
 		for (i = 0; i < proc->buffer_size / PAGE_SIZE; i++) {
 			if (proc->pages[i]) {
 				void *page_addr = proc->buffer + i * PAGE_SIZE;
 				binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-					     "binder_release: %d: page %d at %p not freed\n",
-					     proc->pid, i,
-					     page_addr);
+					"binder_release: %d: page %d at %p not freed\n",
+					proc->pid, i,
+					page_addr);
 				unmap_kernel_range((unsigned long)page_addr,
 					PAGE_SIZE);
 				__free_page(proc->pages[i]);
 				page_count++;
 			}
 		}
+
 		kfree(proc->pages);
 		vfree(proc->buffer);
 	}
-- 
1.7.10.4

