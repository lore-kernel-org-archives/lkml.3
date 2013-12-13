Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3LMW1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:35 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45538 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3LMW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:32 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 054/115] gpu: ion: Clarify variable names and comments around heap ids v types
Date: Fri, 13 Dec 2013 14:24:28 -0800
Message-Id: <1386973529-4884-55-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

There is some confusion between when to use the heap type and when
the id.  This patch clarifies this by using clearer variable names
and describing the intention in the comments.  Also fixes the client
debug code to print heaps by id instead of type.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 37 ++++++++++++++--------------
 drivers/staging/android/ion/ion.h | 51 +++++++++++++++++++++------------------
 2 files changed, 47 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 8cc0489..c775e4f 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1,4 +1,5 @@
 /*
+
  * drivers/staging/android/ion/ion.c
  *
  * Copyright (C) 2011 Google, Inc.
@@ -62,7 +63,7 @@ struct ion_device {
  * @dev:		backpointer to ion device
  * @handles:		an rb tree of all the handles in this client
  * @lock:		lock protecting the tree of handles
- * @heap_mask:		mask of all supported heaps
+ * @heap_type_mask:	mask of all supported heap types
  * @name:		used for debugging
  * @task:		used for debugging
  *
@@ -75,7 +76,7 @@ struct ion_client {
 	struct ion_device *dev;
 	struct rb_root handles;
 	struct mutex lock;
-	unsigned int heap_mask;
+	unsigned int heap_type_mask;
 	const char *name;
 	struct task_struct *task;
 	pid_t pid;
@@ -386,7 +387,7 @@ static void ion_handle_add(struct ion_client *client, struct ion_handle *handle)
 }
 
 struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
-			     size_t align, unsigned int heap_mask,
+			     size_t align, unsigned int heap_id_mask,
 			     unsigned int flags)
 {
 	struct ion_handle *handle;
@@ -394,8 +395,8 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 	struct ion_buffer *buffer = NULL;
 	struct ion_heap *heap;
 
-	pr_debug("%s: len %d align %d heap_mask %u flags %x\n", __func__, len,
-		 align, heap_mask, flags);
+	pr_debug("%s: len %d align %d heap_id_mask %u flags %x\n", __func__,
+		 len, align, heap_id_mask, flags);
 	/*
 	 * traverse the list of heaps available in this system in priority
 	 * order.  If the heap type is supported by the client, and matches the
@@ -410,10 +411,10 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 	down_read(&dev->lock);
 	plist_for_each_entry(heap, &dev->heaps, node) {
 		/* if the client doesn't support this heap type */
-		if (!((1 << heap->type) & client->heap_mask))
+		if (!((1 << heap->type) & client->heap_type_mask))
 			continue;
-		/* if the caller didn't specify this heap type */
-		if (!((1 << heap->id) & heap_mask))
+		/* if the caller didn't specify this heap id */
+		if (!((1 << heap->id) & heap_id_mask))
 			continue;
 		buffer = ion_buffer_create(heap, dev, len, align, flags);
 		if (!IS_ERR_OR_NULL(buffer))
@@ -588,24 +589,24 @@ static int ion_debug_client_show(struct seq_file *s, void *unused)
 {
 	struct ion_client *client = s->private;
 	struct rb_node *n;
-	size_t sizes[ION_NUM_HEAPS] = {0};
-	const char *names[ION_NUM_HEAPS] = {0};
+	size_t sizes[ION_NUM_HEAP_IDS] = {0};
+	const char *names[ION_NUM_HEAP_IDS] = {0};
 	int i;
 
 	mutex_lock(&client->lock);
 	for (n = rb_first(&client->handles); n; n = rb_next(n)) {
 		struct ion_handle *handle = rb_entry(n, struct ion_handle,
 						     node);
-		enum ion_heap_type type = handle->buffer->heap->type;
+		unsigned int id = handle->buffer->heap->id;
 
-		if (!names[type])
-			names[type] = handle->buffer->heap->name;
-		sizes[type] += handle->buffer->size;
+		if (!names[id])
+			names[id] = handle->buffer->heap->name;
+		sizes[id] += handle->buffer->size;
 	}
 	mutex_unlock(&client->lock);
 
 	seq_printf(s, "%16.16s: %16.16s\n", "heap_name", "size_in_bytes");
-	for (i = 0; i < ION_NUM_HEAPS; i++) {
+	for (i = 0; i < ION_NUM_HEAP_IDS; i++) {
 		if (!names[i])
 			continue;
 		seq_printf(s, "%16.16s: %16u\n", names[i], sizes[i]);
@@ -626,7 +627,7 @@ static const struct file_operations debug_client_fops = {
 };
 
 struct ion_client *ion_client_create(struct ion_device *dev,
-				     unsigned int heap_mask,
+				     unsigned int heap_type_mask,
 				     const char *name)
 {
 	struct ion_client *client;
@@ -661,7 +662,7 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	client->handles = RB_ROOT;
 	mutex_init(&client->lock);
 	client->name = name;
-	client->heap_mask = heap_mask;
+	client->heap_type_mask = heap_type_mask;
 	client->task = task;
 	client->pid = pid;
 
@@ -1057,7 +1058,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
 			return -EFAULT;
 		data.handle = ion_alloc(client, data.len, data.align,
-					     data.heap_mask, data.flags);
+					     data.heap_id_mask, data.flags);
 
 		if (IS_ERR(data.handle))
 			return PTR_ERR(data.handle);
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index e5f679f..a315858 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -43,6 +43,8 @@ enum ion_heap_type {
 #define ION_HEAP_SYSTEM_CONTIG_MASK	(1 << ION_HEAP_TYPE_SYSTEM_CONTIG)
 #define ION_HEAP_CARVEOUT_MASK		(1 << ION_HEAP_TYPE_CARVEOUT)
 
+#define ION_NUM_HEAP_IDS		sizeof(unsigned int) * 8
+
 /**
  * heap flags - the lower 16 bits are used by core ion, the upper 16
  * bits are reserved for use by the heaps themselves.
@@ -71,8 +73,9 @@ struct ion_buffer;
 /**
  * struct ion_platform_heap - defines a heap in the given platform
  * @type:	type of the heap from ion_heap_type enum
- * @id:		unique identifier for heap.  When allocating (lower numbers 
- * 		will be allocated from first)
+ * @id:		unique identifier for heap.  When allocating higher numbers
+ * 		will be allocated from first.  At allocation these are passed
+ *		as a bit mask and therefore can not exceed ION_NUM_HEAP_IDS.
  * @name:	used for debug purposes
  * @base:	base address of heap in physical memory if applicable
  * @size:	size of the heap in bytes if applicable
@@ -116,12 +119,13 @@ void ion_reserve(struct ion_platform_data *data);
 
 /**
  * ion_client_create() -  allocate a client and returns it
- * @dev:	the global ion device
- * @heap_mask:	mask of heaps this client can allocate from
- * @name:	used for debugging
+ * @dev:		the global ion device
+ * @heap_type_mask:	mask of heaps this client can allocate from
+ * @name:		used for debugging
  */
 struct ion_client *ion_client_create(struct ion_device *dev,
-				     unsigned int heap_mask, const char *name);
+				     unsigned int heap_type_mask,
+				     const char *name);
 
 /**
  * ion_client_destroy() -  free's a client and all it's handles
@@ -134,21 +138,22 @@ void ion_client_destroy(struct ion_client *client);
 
 /**
  * ion_alloc - allocate ion memory
- * @client:	the client
- * @len:	size of the allocation
- * @align:	requested allocation alignment, lots of hardware blocks have
- *		alignment requirements of some kind
- * @heap_mask:	mask of heaps to allocate from, if multiple bits are set
- *		heaps will be tried in order from lowest to highest order bit
- * @flags:	heap flags, the low 16 bits are consumed by ion, the high 16
- *		bits are passed on to the respective heap and can be heap
- * 		custom
+ * @client:		the client
+ * @len:		size of the allocation
+ * @align:		requested allocation alignment, lots of hardware blocks
+ *			have alignment requirements of some kind
+ * @heap_id_mask:	mask of heaps to allocate from, if multiple bits are set
+ *			heaps will be tried in order from highest to lowest
+ *			id
+ * @flags:		heap flags, the low 16 bits are consumed by ion, the
+ *			high 16 bits are passed on to the respective heap and
+ *			can be heap custom
  *
  * Allocate memory in one of the heaps provided in heap mask and return
  * an opaque handle to it.
  */
 struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
-			     size_t align, unsigned int heap_mask,
+			     size_t align, unsigned int heap_id_mask,
 			     unsigned int flags);
 
 /**
@@ -237,19 +242,19 @@ struct ion_handle *ion_import_dma_buf(struct ion_client *client, int fd);
 
 /**
  * struct ion_allocation_data - metadata passed from userspace for allocations
- * @len:	size of the allocation
- * @align:	required alignment of the allocation
- * @heap_mask:	mask of heaps to allocate from
- * @flags:	flags passed to heap
- * @handle:	pointer that will be populated with a cookie to use to refer
- *		to this allocation
+ * @len:		size of the allocation
+ * @align:		required alignment of the allocation
+ * @heap_id_mask:	mask of heap ids to allocate from
+ * @flags:		flags passed to heap
+ * @handle:		pointer that will be populated with a cookie to use to 
+ *			refer to this allocation
  *
  * Provided by userspace as an argument to the ioctl
  */
 struct ion_allocation_data {
 	size_t len;
 	size_t align;
-	unsigned int heap_mask;
+	unsigned int heap_id_mask;
 	unsigned int flags;
 	struct ion_handle *handle;
 };
-- 
1.8.3.2

