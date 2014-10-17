Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaJQPpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:45:38 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:64916 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaJQPpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:45:36 -0400
From: =?UTF-8?q?J=C3=A9r=C3=A9mie=20Galarneau?= 
	<jeremie.galarneau@efficios.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?J=C3=A9r=C3=A9mie=20Galarneau?= 
	<jeremie.galarneau@efficios.com>,
        Chris Mason <clm@fb.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] btrfs: fix tracepoint namespacing
Date: Fri, 17 Oct 2014 11:45:09 -0400
Message-Id: <1413560709-18704-1-git-send-email-jeremie.galarneau@efficios.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some btrfs tracepoints are not properly namespaced. The
tracepoint names should be prefixed with the subsystem's name
as suggested in tracepoint.h

Cc: Chris Mason <clm@fb.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jérémie Galarneau <jeremie.galarneau@efficios.com>
---
 fs/btrfs/delayed-ref.c       |  6 +++---
 fs/btrfs/extent-tree.c       |  8 ++++----
 fs/btrfs/extent_io.c         |  6 +++---
 include/trace/events/btrfs.h | 20 ++++++++++----------
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 6d16bea..e075ba9 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -609,7 +609,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	spin_lock_init(&head_ref->lock);
 	mutex_init(&head_ref->mutex);
 
-	trace_add_delayed_ref_head(ref, head_ref, action);
+	trace_btrfs_add_delayed_ref_head(ref, head_ref, action);
 
 	existing = htree_insert(&delayed_refs->href_root,
 				&head_ref->href_node);
@@ -673,7 +673,7 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		ref->type = BTRFS_TREE_BLOCK_REF_KEY;
 	full_ref->level = level;
 
-	trace_add_delayed_tree_ref(ref, full_ref, action);
+	trace_btrfs_add_delayed_tree_ref(ref, full_ref, action);
 
 	spin_lock(&head_ref->lock);
 	existing = tree_insert(&head_ref->ref_root, &ref->rb_node);
@@ -738,7 +738,7 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	full_ref->objectid = owner;
 	full_ref->offset = offset;
 
-	trace_add_delayed_data_ref(ref, full_ref, action);
+	trace_btrfs_add_delayed_data_ref(ref, full_ref, action);
 
 	spin_lock(&head_ref->lock);
 	existing = tree_insert(&head_ref->ref_root, &ref->rb_node);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d565895..8ca6e75 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2086,7 +2086,7 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
 
 	ref = btrfs_delayed_node_to_data_ref(node);
-	trace_run_delayed_data_ref(node, ref, node->action);
+	trace_btrfs_run_delayed_data_ref(node, ref, node->action);
 
 	if (node->type == BTRFS_SHARED_DATA_REF_KEY)
 		parent = ref->parent;
@@ -2243,7 +2243,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 						 SKINNY_METADATA);
 
 	ref = btrfs_delayed_node_to_tree_ref(node);
-	trace_run_delayed_tree_ref(node, ref, node->action);
+	trace_btrfs_run_delayed_tree_ref(node, ref, node->action);
 
 	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
 		parent = ref->parent;
@@ -2309,7 +2309,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		 */
 		BUG_ON(extent_op);
 		head = btrfs_delayed_node_to_head(node);
-		trace_run_delayed_ref_head(node, head, node->action);
+		trace_btrfs_run_delayed_ref_head(node, head, node->action);
 
 		if (insert_reserved) {
 			btrfs_pin_extent(root, node->bytenr,
@@ -6490,7 +6490,7 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 	ins->objectid = 0;
 	ins->offset = 0;
 
-	trace_find_free_extent(orig_root, num_bytes, empty_size, flags);
+	trace_btrfs_find_free_extent(orig_root, num_bytes, empty_size, flags);
 
 	space_info = __find_space_info(root->fs_info, flags);
 	if (!space_info) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bf3f424..16d82c6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -218,7 +218,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 	btrfs_leak_debug_add(&state->leak_list, &states);
 	atomic_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
-	trace_alloc_extent_state(state, mask, _RET_IP_);
+	trace_btrfs_alloc_extent_state(state, mask, _RET_IP_);
 	return state;
 }
 
@@ -229,7 +229,7 @@ void free_extent_state(struct extent_state *state)
 	if (atomic_dec_and_test(&state->refs)) {
 		WARN_ON(extent_state_in_tree(state));
 		btrfs_leak_debug_del(&state->leak_list);
-		trace_free_extent_state(state, _RET_IP_);
+		trace_btrfs_free_extent_state(state, _RET_IP_);
 		kmem_cache_free(extent_state_cache, state);
 	}
 }
@@ -3461,7 +3461,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	else
 		write_flags = WRITE;
 
-	trace___extent_writepage(page, inode, wbc);
+	trace_btrfs__extent_writepage(page, inode, wbc);
 
 	WARN_ON(!PageLocked(page));
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 1faecea..01c718c 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -351,7 +351,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		  (unsigned long)__entry->writeback_index)
 );
 
-DEFINE_EVENT(btrfs__writepage, __extent_writepage,
+DEFINE_EVENT(btrfs__writepage, btrfs__extent_writepage,
 
 	TP_PROTO(struct page *page, struct inode *inode,
 		 struct writeback_control *wbc),
@@ -489,7 +489,7 @@ DECLARE_EVENT_CLASS(btrfs_delayed_tree_ref,
 		  (unsigned long long)__entry->seq)
 );
 
-DEFINE_EVENT(btrfs_delayed_tree_ref,  add_delayed_tree_ref,
+DEFINE_EVENT(btrfs_delayed_tree_ref,  btrfs_add_delayed_tree_ref,
 
 	TP_PROTO(struct btrfs_delayed_ref_node *ref,
 		 struct btrfs_delayed_tree_ref *full_ref,
@@ -498,7 +498,7 @@ DEFINE_EVENT(btrfs_delayed_tree_ref,  add_delayed_tree_ref,
 	TP_ARGS(ref, full_ref, action)
 );
 
-DEFINE_EVENT(btrfs_delayed_tree_ref,  run_delayed_tree_ref,
+DEFINE_EVENT(btrfs_delayed_tree_ref,  btrfs_run_delayed_tree_ref,
 
 	TP_PROTO(struct btrfs_delayed_ref_node *ref,
 		 struct btrfs_delayed_tree_ref *full_ref,
@@ -553,7 +553,7 @@ DECLARE_EVENT_CLASS(btrfs_delayed_data_ref,
 		  (unsigned long long)__entry->seq)
 );
 
-DEFINE_EVENT(btrfs_delayed_data_ref,  add_delayed_data_ref,
+DEFINE_EVENT(btrfs_delayed_data_ref,  btrfs_add_delayed_data_ref,
 
 	TP_PROTO(struct btrfs_delayed_ref_node *ref,
 		 struct btrfs_delayed_data_ref *full_ref,
@@ -562,7 +562,7 @@ DEFINE_EVENT(btrfs_delayed_data_ref,  add_delayed_data_ref,
 	TP_ARGS(ref, full_ref, action)
 );
 
-DEFINE_EVENT(btrfs_delayed_data_ref,  run_delayed_data_ref,
+DEFINE_EVENT(btrfs_delayed_data_ref,  btrfs_run_delayed_data_ref,
 
 	TP_PROTO(struct btrfs_delayed_ref_node *ref,
 		 struct btrfs_delayed_data_ref *full_ref,
@@ -600,7 +600,7 @@ DECLARE_EVENT_CLASS(btrfs_delayed_ref_head,
 		  __entry->is_data)
 );
 
-DEFINE_EVENT(btrfs_delayed_ref_head,  add_delayed_ref_head,
+DEFINE_EVENT(btrfs_delayed_ref_head,  btrfs_add_delayed_ref_head,
 
 	TP_PROTO(struct btrfs_delayed_ref_node *ref,
 		 struct btrfs_delayed_ref_head *head_ref,
@@ -609,7 +609,7 @@ DEFINE_EVENT(btrfs_delayed_ref_head,  add_delayed_ref_head,
 	TP_ARGS(ref, head_ref, action)
 );
 
-DEFINE_EVENT(btrfs_delayed_ref_head,  run_delayed_ref_head,
+DEFINE_EVENT(btrfs_delayed_ref_head,  btrfs_run_delayed_ref_head,
 
 	TP_PROTO(struct btrfs_delayed_ref_node *ref,
 		 struct btrfs_delayed_ref_head *head_ref,
@@ -781,7 +781,7 @@ DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_free,
 	TP_ARGS(root, start, len)
 );
 
-TRACE_EVENT(find_free_extent,
+TRACE_EVENT(btrfs_find_free_extent,
 
 	TP_PROTO(struct btrfs_root *root, u64 num_bytes, u64 empty_size,
 		 u64 data),
@@ -944,7 +944,7 @@ TRACE_EVENT(btrfs_setup_cluster,
 );
 
 struct extent_state;
-TRACE_EVENT(alloc_extent_state,
+TRACE_EVENT(btrfs_alloc_extent_state,
 
 	TP_PROTO(struct extent_state *state, gfp_t mask, unsigned long IP),
 
@@ -966,7 +966,7 @@ TRACE_EVENT(alloc_extent_state,
 		  show_gfp_flags(__entry->mask), (void *)__entry->ip)
 );
 
-TRACE_EVENT(free_extent_state,
+TRACE_EVENT(btrfs_free_extent_state,
 
 	TP_PROTO(struct extent_state *state, unsigned long IP),
 
-- 
2.1.2

