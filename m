Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3A1TWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:22:02 -0500
Received: from smtp.ini-tech.com ([213.239.202.151]:32993 "EHLO
	smtp.ini-tech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3A1TWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:22:00 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2013 14:21:59 EST
From: David Goulet <dgoulet@efficios.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] Btrfs: fix missing prefix on four TRACE_EVENTs
Date: Mon, 28 Jan 2013 14:15:34 -0500
Message-Id: <1359400534-31109-1-git-send-email-dgoulet@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Four trace events were not namespaced with the btrfs_ prefix:
	* free_extent_state
	* alloc_extent_state
	* find_free_extent
	* __extent_writepage

Without this prefix, it is harder to associate the event to a btrfs
context in a trace. It's recommended in the tracepoint.h documentation
when defining TRACE_EVENT(...).

include/linux/tracepoint.h:

"Firstly, name your tracepoint via TRACE_EVENT(name : the
'subsystem_event' notation is fine."

Signed-off-by: David Goulet <dgoulet@efficios.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Chris Mason <chris.mason@fusionio.com>
CC: Josef Bacik <jbacik@fusionio.com>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 fs/btrfs/extent-tree.c       |    2 +-
 fs/btrfs/extent_io.c         |    6 +++---
 include/trace/events/btrfs.h |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a8b8adc..622b723 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5574,7 +5574,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	ins->objectid = 0;
 	ins->offset = 0;
 
-	trace_find_free_extent(orig_root, num_bytes, empty_size, data);
+	trace_btrfs_find_free_extent(orig_root, num_bytes, empty_size, data);
 
 	space_info = __find_space_info(root->fs_info, data);
 	if (!space_info) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1b319df..1520aeb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -152,7 +152,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 #endif
 	atomic_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
-	trace_alloc_extent_state(state, mask, _RET_IP_);
+	trace_btrfs_alloc_extent_state(state, mask, _RET_IP_);
 	return state;
 }
 
@@ -170,7 +170,7 @@ void free_extent_state(struct extent_state *state)
 		list_del(&state->leak_list);
 		spin_unlock_irqrestore(&leak_lock, flags);
 #endif
-		trace_free_extent_state(state, _RET_IP_);
+		trace_btrfs_free_extent_state(state, _RET_IP_);
 		kmem_cache_free(extent_state_cache, state);
 	}
 }
@@ -2838,7 +2838,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	else
 		write_flags = WRITE;
 
-	trace___extent_writepage(page, inode, wbc);
+	trace_btrfs__extent_writepage(page, inode, wbc);
 
 	WARN_ON(!PageLocked(page));
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index ea546a4..aad5f78 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -334,7 +334,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		  (unsigned long)__entry->writeback_index)
 );
 
-DEFINE_EVENT(btrfs__writepage, __extent_writepage,
+DEFINE_EVENT(btrfs__writepage, btrfs__extent_writepage,
 
 	TP_PROTO(struct page *page, struct inode *inode,
 		 struct writeback_control *wbc),
@@ -708,7 +708,7 @@ DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_free,
 	TP_ARGS(root, start, len)
 );
 
-TRACE_EVENT(find_free_extent,
+TRACE_EVENT(btrfs_find_free_extent,
 
 	TP_PROTO(struct btrfs_root *root, u64 num_bytes, u64 empty_size,
 		 u64 data),
@@ -871,7 +871,7 @@ TRACE_EVENT(btrfs_setup_cluster,
 );
 
 struct extent_state;
-TRACE_EVENT(alloc_extent_state,
+TRACE_EVENT(btrfs_alloc_extent_state,
 
 	TP_PROTO(struct extent_state *state, gfp_t mask, unsigned long IP),
 
@@ -893,7 +893,7 @@ TRACE_EVENT(alloc_extent_state,
 		  show_gfp_flags(__entry->mask), (void *)__entry->ip)
 );
 
-TRACE_EVENT(free_extent_state,
+TRACE_EVENT(btrfs_free_extent_state,
 
 	TP_PROTO(struct extent_state *state, unsigned long IP),
 
-- 
1.7.9.5

