Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3LMW0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:54 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:41194 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3LMW0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:52 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 029/115] gpu: ion: Add debug information for orphaned handles
Date: Fri, 13 Dec 2013 14:24:03 -0800
Message-Id: <1386973529-4884-30-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

It is possible for a buffer to exist only as a dma_buf file
descriptor without it being held in any handles.  When this
occurs it is impossible to track where the buffer is in the
system (without traversing every process in the system and
inspecting its file table).  When buffers are orphaned like
this, copy the task comm and pid of the last client to hold
them into the buffer so we have a debugging hint as to where
this buffer came from.  In practice this will probalby be
the process that allocated the buffer.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c      | 58 ++++++++++++++++++++++++++++++++++
 drivers/staging/android/ion/ion_priv.h | 14 ++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index e52522c..6ba2c39 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -228,6 +228,37 @@ static int ion_buffer_put(struct ion_buffer *buffer)
 	return kref_put(&buffer->ref, ion_buffer_destroy);
 }
 
+static void ion_buffer_add_to_handle(struct ion_buffer *buffer)
+{
+	mutex_lock(&buffer->dev->lock);
+	buffer->handle_count++;
+	mutex_unlock(&buffer->dev->lock);
+}
+
+static void ion_buffer_remove_from_handle(struct ion_buffer *buffer)
+{
+	/*
+	 * when a buffer is removed from a handle, if it is not in
+	 * any other handles, copy the taskcomm and the pid of the
+	 * process it's being removed from into the buffer.  At this
+	 * point there will be no way to track what processes this buffer is
+	 * being used by, it only exists as a dma_buf file descriptor.
+	 * The taskcomm and pid can provide a debug hint as to where this fd
+	 * is in the system
+	 */
+	mutex_lock(&buffer->dev->lock);
+	buffer->handle_count--;
+	BUG_ON(buffer->handle_count < 0);
+	if (!buffer->handle_count) {
+		struct task_struct *task;
+
+		task = current->group_leader;
+		get_task_comm(buffer->task_comm, task);
+		buffer->pid = task_pid_nr(task);
+	}
+	mutex_unlock(&buffer->dev->lock);
+}
+
 static struct ion_handle *ion_handle_create(struct ion_client *client,
 				     struct ion_buffer *buffer)
 {
@@ -240,6 +271,7 @@ static struct ion_handle *ion_handle_create(struct ion_client *client,
 	RB_CLEAR_NODE(&handle->node);
 	handle->client = client;
 	ion_buffer_get(buffer);
+	ion_buffer_add_to_handle(buffer);
 	handle->buffer = buffer;
 
 	return handle;
@@ -261,7 +293,9 @@ static void ion_handle_destroy(struct kref *kref)
 	if (!RB_EMPTY_NODE(&handle->node))
 		rb_erase(&handle->node, &client->handles);
 
+	ion_buffer_remove_from_handle(buffer);
 	ion_buffer_put(buffer);
+
 	kfree(handle);
 }
 
@@ -1141,8 +1175,11 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 	struct ion_heap *heap = s->private;
 	struct ion_device *dev = heap->dev;
 	struct rb_node *n;
+	size_t total_size = 0;
+	size_t total_orphaned_size = 0;
 
 	seq_printf(s, "%16.s %16.s %16.s\n", "client", "pid", "size");
+	seq_printf(s, "----------------------------------------------------\n");
 
 	for (n = rb_first(&dev->clients); n; n = rb_next(n)) {
 		struct ion_client *client = rb_entry(n, struct ion_client,
@@ -1161,6 +1198,27 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 				   client->pid, size);
 		}
 	}
+	seq_printf(s, "----------------------------------------------------\n");
+	seq_printf(s, "orphaned allocations (info is from last known client):"
+		   "\n");
+	mutex_lock(&dev->lock);
+	for (n = rb_first(&dev->buffers); n; n = rb_next(n)) {
+		struct ion_buffer *buffer = rb_entry(n, struct ion_buffer,
+						     node);
+		if (buffer->heap->type == heap->type)
+			total_size += buffer->size;
+		if (!buffer->handle_count) {
+			seq_printf(s, "%16.s %16u %16u\n", buffer->task_comm,
+				   buffer->pid, buffer->size);
+			total_orphaned_size += buffer->size;
+		}
+	}
+	mutex_unlock(&dev->lock);
+	seq_printf(s, "----------------------------------------------------\n");
+	seq_printf(s, "%16.s %16u\n", "total orphaned",
+		   total_orphaned_size);
+	seq_printf(s, "%16.s %16u\n", "total ", total_size);
+
 	return 0;
 }
 
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 406d1f4..dabe1e8 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -21,6 +21,7 @@
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
+#include <linux/sched.h>
 
 #include "ion.h"
 
@@ -43,6 +44,15 @@ struct ion_buffer *ion_handle_buffer(struct ion_handle *handle);
  * @vaddr:		the kenrel mapping if kmap_cnt is not zero
  * @dmap_cnt:		number of times the buffer is mapped for dma
  * @sg_table:		the sg table for the buffer if dmap_cnt is not zero
+ * @dirty:		bitmask representing which pages of this buffer have
+ *			been dirtied by the cpu and need cache maintenance
+ *			before dma
+ * @vmas:		list of vma's mapping this buffer
+ * @handle_count:	count of handles referencing this buffer
+ * @task_comm:		taskcomm of last client to reference this buffer in a
+ *			handle, used for debugging
+ * @pid:		pid of last client to reference this buffer in a
+ *			handle, used for debugging
 */
 struct ion_buffer {
 	struct kref ref;
@@ -62,6 +72,10 @@ struct ion_buffer {
 	struct sg_table *sg_table;
 	unsigned long *dirty;
 	struct list_head vmas;
+	/* used to track orphaned buffers */
+	int handle_count;
+	char task_comm[TASK_COMM_LEN];
+	pid_t pid;
 };
 
 /**
-- 
1.8.3.2

