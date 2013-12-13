Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3LMW1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:21 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50665 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3LMW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:15 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 042/115] gpu: ion: Refactor locking
Date: Fri, 13 Dec 2013 14:24:16 -0800
Message-Id: <1386973529-4884-43-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Removes contention for lock between allocate and free by reducing
the length of time the lock is held for.  Split out a seperate
lock to protect the list of heaps and replace it with a rwsem since
the list will most likely only be updated during initialization.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 45 ++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 0070c9b..ef8f132 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -38,15 +38,17 @@
 /**
  * struct ion_device - the metadata of the ion device node
  * @dev:		the actual misc device
- * @buffers:	an rb tree of all the existing buffers
- * @lock:		lock protecting the buffers & heaps trees
+ * @buffers:		an rb tree of all the existing buffers
+ * @buffer_lock:	lock protecting the tree of buffers
+ * @lock:		rwsem protecting the tree of heaps and clients
  * @heaps:		list of all the heaps in the system
  * @user_clients:	list of all the clients created from userspace
  */
 struct ion_device {
 	struct miscdevice dev;
 	struct rb_root buffers;
-	struct mutex lock;
+	struct mutex buffer_lock;
+	struct rw_semaphore lock;
 	struct rb_root heaps;
 	long (*custom_ioctl) (struct ion_client *client, unsigned int cmd,
 			      unsigned long arg);
@@ -205,7 +207,9 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 	   cached mapping that mapping has been invalidated */
 	for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents, i)
 		sg_dma_address(sg) = sg_phys(sg);
+	mutex_lock(&dev->buffer_lock);
 	ion_buffer_add(dev, buffer);
+	mutex_unlock(&dev->buffer_lock);
 	return buffer;
 
 err:
@@ -224,9 +228,9 @@ static void ion_buffer_destroy(struct kref *kref)
 		buffer->heap->ops->unmap_kernel(buffer->heap, buffer);
 	buffer->heap->ops->unmap_dma(buffer->heap, buffer);
 	buffer->heap->ops->free(buffer);
-	mutex_lock(&dev->lock);
+	mutex_lock(&dev->buffer_lock);
 	rb_erase(&buffer->node, &dev->buffers);
-	mutex_unlock(&dev->lock);
+	mutex_unlock(&dev->buffer_lock);
 	if (buffer->flags & ION_FLAG_CACHED)
 		kfree(buffer->dirty);
 	kfree(buffer);
@@ -244,9 +248,9 @@ static int ion_buffer_put(struct ion_buffer *buffer)
 
 static void ion_buffer_add_to_handle(struct ion_buffer *buffer)
 {
-	mutex_lock(&buffer->dev->lock);
+	mutex_lock(&buffer->lock);
 	buffer->handle_count++;
-	mutex_unlock(&buffer->dev->lock);
+	mutex_unlock(&buffer->lock);
 }
 
 static void ion_buffer_remove_from_handle(struct ion_buffer *buffer)
@@ -260,7 +264,7 @@ static void ion_buffer_remove_from_handle(struct ion_buffer *buffer)
 	 * The taskcomm and pid can provide a debug hint as to where this fd
 	 * is in the system
 	 */
-	mutex_lock(&buffer->dev->lock);
+	mutex_lock(&buffer->lock);
 	buffer->handle_count--;
 	BUG_ON(buffer->handle_count < 0);
 	if (!buffer->handle_count) {
@@ -270,7 +274,7 @@ static void ion_buffer_remove_from_handle(struct ion_buffer *buffer)
 		get_task_comm(buffer->task_comm, task);
 		buffer->pid = task_pid_nr(task);
 	}
-	mutex_unlock(&buffer->dev->lock);
+	mutex_unlock(&buffer->lock);
 }
 
 static struct ion_handle *ion_handle_create(struct ion_client *client,
@@ -403,7 +407,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 
 	len = PAGE_ALIGN(len);
 
-	mutex_lock(&dev->lock);
+	down_read(&dev->lock);
 	for (n = rb_first(&dev->heaps); n != NULL; n = rb_next(n)) {
 		struct ion_heap *heap = rb_entry(n, struct ion_heap, node);
 		/* if the client doesn't support this heap type */
@@ -416,7 +420,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 		if (!IS_ERR_OR_NULL(buffer))
 			break;
 	}
-	mutex_unlock(&dev->lock);
+	up_read(&dev->lock);
 
 	if (buffer == NULL)
 		return ERR_PTR(-ENODEV);
@@ -662,7 +666,7 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	client->task = task;
 	client->pid = pid;
 
-	mutex_lock(&dev->lock);
+	down_write(&dev->lock);
 	p = &dev->clients.rb_node;
 	while (*p) {
 		parent = *p;
@@ -680,7 +684,7 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	client->debug_root = debugfs_create_file(debug_name, 0664,
 						 dev->debug_root, client,
 						 &debug_client_fops);
-	mutex_unlock(&dev->lock);
+	up_write(&dev->lock);
 
 	return client;
 }
@@ -696,12 +700,12 @@ void ion_client_destroy(struct ion_client *client)
 						     node);
 		ion_handle_destroy(&handle->ref);
 	}
-	mutex_lock(&dev->lock);
+	down_write(&dev->lock);
 	if (client->task)
 		put_task_struct(client->task);
 	rb_erase(&client->node, &dev->clients);
 	debugfs_remove_recursive(client->debug_root);
-	mutex_unlock(&dev->lock);
+	up_write(&dev->lock);
 
 	kfree(client);
 }
@@ -1220,7 +1224,7 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 	seq_printf(s, "----------------------------------------------------\n");
 	seq_printf(s, "orphaned allocations (info is from last known client):"
 		   "\n");
-	mutex_lock(&dev->lock);
+	mutex_lock(&dev->buffer_lock);
 	for (n = rb_first(&dev->buffers); n; n = rb_next(n)) {
 		struct ion_buffer *buffer = rb_entry(n, struct ion_buffer,
 						     node);
@@ -1233,7 +1237,7 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 			total_orphaned_size += buffer->size;
 		}
 	}
-	mutex_unlock(&dev->lock);
+	mutex_unlock(&dev->buffer_lock);
 	seq_printf(s, "----------------------------------------------------\n");
 	seq_printf(s, "%16.s %16u\n", "total orphaned",
 		   total_orphaned_size);
@@ -1270,7 +1274,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 		       __func__);
 
 	heap->dev = dev;
-	mutex_lock(&dev->lock);
+	down_write(&dev->lock);
 	while (*p) {
 		parent = *p;
 		entry = rb_entry(parent, struct ion_heap, node);
@@ -1291,7 +1295,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 	debugfs_create_file(heap->name, 0664, dev->debug_root, heap,
 			    &debug_heap_fops);
 end:
-	mutex_unlock(&dev->lock);
+	up_write(&dev->lock);
 }
 
 struct ion_device *ion_device_create(long (*custom_ioctl)
@@ -1322,7 +1326,8 @@ struct ion_device *ion_device_create(long (*custom_ioctl)
 
 	idev->custom_ioctl = custom_ioctl;
 	idev->buffers = RB_ROOT;
-	mutex_init(&idev->lock);
+	mutex_init(&idev->buffer_lock);
+	init_rwsem(&idev->lock);
 	idev->heaps = RB_ROOT;
 	idev->clients = RB_ROOT;
 	return idev;
-- 
1.8.3.2

