Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3LMWcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:32:45 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57102 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3LMW2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:06 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 076/115] ion: replace userspace handle cookies with idr
Date: Fri, 13 Dec 2013 14:24:50 -0800
Message-Id: <1386973529-4884-77-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Userspace handles should not leak kernel virtual addresses to
userspace.  They have to be validated by looking them up in an
rbtree anyways, so replace them with an idr and validate them
by using idr_find to convert the id number to the struct
ion_handle pointer.

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 107 +++++++++++++++++++++++++-------------
 1 file changed, 71 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 54a00fe..ece1a4c 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -34,6 +34,7 @@
 #include <linux/vmalloc.h>
 #include <linux/debugfs.h>
 #include <linux/dma-buf.h>
+#include <linux/idr.h>
 
 #include "ion.h"
 #include "ion_priv.h"
@@ -64,6 +65,7 @@ struct ion_device {
  * @node:		node in the tree of all clients
  * @dev:		backpointer to ion device
  * @handles:		an rb tree of all the handles in this client
+ * @idr:		an idr space for allocating handle ids
  * @lock:		lock protecting the tree of handles
  * @name:		used for debugging
  * @task:		used for debugging
@@ -76,6 +78,7 @@ struct ion_client {
 	struct rb_node node;
 	struct ion_device *dev;
 	struct rb_root handles;
+	struct idr idr;
 	struct mutex lock;
 	const char *name;
 	struct task_struct *task;
@@ -90,7 +93,7 @@ struct ion_client {
  * @buffer:		pointer to the buffer
  * @node:		node in the client's handle rbtree
  * @kmap_cnt:		count of times this client has mapped to kernel
- * @dmap_cnt:		count of times this client has mapped for dma
+ * @id:			client-unique id allocated by client->idr
  *
  * Modifications to node, map_cnt or mapping should be protected by the
  * lock in the client.  Other fields are never changed after initialization.
@@ -101,6 +104,7 @@ struct ion_handle {
 	struct ion_buffer *buffer;
 	struct rb_node node;
 	unsigned int kmap_cnt;
+	int id;
 };
 
 bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer)
@@ -356,6 +360,7 @@ static void ion_handle_destroy(struct kref *kref)
 		ion_handle_kmap_put(handle);
 	mutex_unlock(&buffer->lock);
 
+	idr_remove(&client->idr, handle->id);
 	if (!RB_EMPTY_NODE(&handle->node))
 		rb_erase(&handle->node, &client->handles);
 
@@ -387,36 +392,42 @@ static struct ion_handle *ion_handle_lookup(struct ion_client *client,
 
 	for (n = rb_first(&client->handles); n; n = rb_next(n)) {
 		struct ion_handle *handle = rb_entry(n, struct ion_handle,
-						     node);
+						   node);
 		if (handle->buffer == buffer)
 			return handle;
 	}
 	return ERR_PTR(-EINVAL);
 }
 
-static bool ion_handle_validate(struct ion_client *client, struct ion_handle *handle)
+static struct ion_handle *ion_uhandle_get(struct ion_client *client, int id)
 {
-	struct rb_node *n = client->handles.rb_node;
+	return idr_find(&client->idr, id);
+}
 
-	while (n) {
-		struct ion_handle *handle_node = rb_entry(n, struct ion_handle,
-							  node);
-		if (handle < handle_node)
-			n = n->rb_left;
-		else if (handle > handle_node)
-			n = n->rb_right;
-		else
-			return true;
-	}
-	return false;
+static bool ion_handle_validate(struct ion_client *client, struct ion_handle *handle)
+{
+	return (ion_uhandle_get(client, handle->id) == handle);
 }
 
-static void ion_handle_add(struct ion_client *client, struct ion_handle *handle)
+static int ion_handle_add(struct ion_client *client, struct ion_handle *handle)
 {
+	int rc;
 	struct rb_node **p = &client->handles.rb_node;
 	struct rb_node *parent = NULL;
 	struct ion_handle *entry;
 
+	do {
+		int id;
+		rc = idr_pre_get(&client->idr, GFP_KERNEL);
+		if (!rc)
+			return -ENOMEM;
+		rc = idr_get_new(&client->idr, handle, &id);
+		handle->id = id;
+	} while (rc == -EAGAIN);
+
+	if (rc < 0)
+		return rc;
+
 	while (*p) {
 		parent = *p;
 		entry = rb_entry(parent, struct ion_handle, node);
@@ -431,6 +442,8 @@ static void ion_handle_add(struct ion_client *client, struct ion_handle *handle)
 
 	rb_link_node(&handle->node, parent, p);
 	rb_insert_color(&handle->node, &client->handles);
+
+	return 0;
 }
 
 struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
@@ -441,6 +454,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 	struct ion_device *dev = client->dev;
 	struct ion_buffer *buffer = NULL;
 	struct ion_heap *heap;
+	int ret;
 
 	pr_debug("%s: len %d align %d heap_id_mask %u flags %x\n", __func__,
 		 len, align, heap_id_mask, flags);
@@ -480,12 +494,16 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 	 */
 	ion_buffer_put(buffer);
 
-	if (!IS_ERR(handle)) {
-		mutex_lock(&client->lock);
-		ion_handle_add(client, handle);
-		mutex_unlock(&client->lock);
-	}
+	if (IS_ERR(handle))
+		return handle;
 
+	mutex_lock(&client->lock);
+	ret = ion_handle_add(client, handle);
+	if (ret) {
+		ion_handle_put(handle);
+		handle = ERR_PTR(ret);
+	}
+	mutex_unlock(&client->lock);
 
 	return handle;
 }
@@ -705,6 +723,7 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 
 	client->dev = dev;
 	client->handles = RB_ROOT;
+	idr_init(&client->idr);
 	mutex_init(&client->lock);
 	client->name = name;
 	client->task = task;
@@ -745,6 +764,10 @@ void ion_client_destroy(struct ion_client *client)
 						     node);
 		ion_handle_destroy(&handle->ref);
 	}
+
+	idr_remove_all(&client->idr);
+	idr_destroy(&client->idr);
+
 	down_write(&dev->lock);
 	if (client->task)
 		put_task_struct(client->task);
@@ -1034,6 +1057,7 @@ struct ion_handle *ion_import_dma_buf(struct ion_client *client, int fd)
 	struct dma_buf *dmabuf;
 	struct ion_buffer *buffer;
 	struct ion_handle *handle;
+	int ret;
 
 	dmabuf = dma_buf_get(fd);
 	if (IS_ERR(dmabuf))
@@ -1058,7 +1082,11 @@ struct ion_handle *ion_import_dma_buf(struct ion_client *client, int fd)
 	handle = ion_handle_create(client, buffer);
 	if (IS_ERR(handle))
 		goto end;
-	ion_handle_add(client, handle);
+	ret = ion_handle_add(client, handle);
+	if (ret) {
+		ion_handle_put(handle);
+		handle = ERR_PTR(ret);
+	}
 end:
 	mutex_unlock(&client->lock);
 	dma_buf_put(dmabuf);
@@ -1098,17 +1126,20 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case ION_IOC_ALLOC:
 	{
 		struct ion_allocation_data data;
+		struct ion_handle *handle;
 
 		if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
 			return -EFAULT;
-		data.handle = ion_alloc(client, data.len, data.align,
+		handle = ion_alloc(client, data.len, data.align,
 					     data.heap_id_mask, data.flags);
 
-		if (IS_ERR(data.handle))
-			return PTR_ERR(data.handle);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		data.handle = (struct ion_handle *)handle->id;
 
 		if (copy_to_user((void __user *)arg, &data, sizeof(data))) {
-			ion_free(client, data.handle);
+			ion_free(client, handle);
 			return -EFAULT;
 		}
 		break;
@@ -1116,27 +1147,29 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case ION_IOC_FREE:
 	{
 		struct ion_handle_data data;
-		bool valid;
+		struct ion_handle *handle;
 
 		if (copy_from_user(&data, (void __user *)arg,
 				   sizeof(struct ion_handle_data)))
 			return -EFAULT;
 		mutex_lock(&client->lock);
-		valid = ion_handle_validate(client, data.handle);
+		handle = ion_uhandle_get(client, (int)data.handle);
 		mutex_unlock(&client->lock);
-		if (!valid)
+		if (!handle)
 			return -EINVAL;
-		ion_free(client, data.handle);
+		ion_free(client, handle);
 		break;
 	}
 	case ION_IOC_SHARE:
 	case ION_IOC_MAP:
 	{
 		struct ion_fd_data data;
+		struct ion_handle *handle;
 
 		if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
 			return -EFAULT;
-		data.fd = ion_share_dma_buf_fd(client, data.handle);
+		handle = ion_uhandle_get(client, (int)data.handle);
+		data.fd = ion_share_dma_buf_fd(client, handle);
 		if (copy_to_user((void __user *)arg, &data, sizeof(data)))
 			return -EFAULT;
 		if (data.fd < 0)
@@ -1146,15 +1179,17 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case ION_IOC_IMPORT:
 	{
 		struct ion_fd_data data;
+		struct ion_handle *handle;
 		int ret = 0;
 		if (copy_from_user(&data, (void __user *)arg,
 				   sizeof(struct ion_fd_data)))
 			return -EFAULT;
-		data.handle = ion_import_dma_buf(client, data.fd);
-		if (IS_ERR(data.handle)) {
-			ret = PTR_ERR(data.handle);
-			data.handle = NULL;
-		}
+		handle = ion_import_dma_buf(client, data.fd);
+		if (IS_ERR(handle))
+			ret = PTR_ERR(handle);
+		else
+			data.handle = (struct ion_handle *)handle->id;
+
 		if (copy_to_user((void __user *)arg, &data,
 				 sizeof(struct ion_fd_data)))
 			return -EFAULT;
-- 
1.8.3.2

