Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3LMW1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:43 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37666 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3LMW1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:36 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 056/115] gpu: ion: Remove heapmask from client
Date: Fri, 13 Dec 2013 14:24:30 -0800
Message-Id: <1386973529-4884-57-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

The heapmask in the client generally wasn't being used.  This
patch removes it.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 17 +++++------------
 drivers/staging/android/ion/ion.h |  1 -
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 7c25d9f..054e672 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -63,7 +63,6 @@ struct ion_device {
  * @dev:		backpointer to ion device
  * @handles:		an rb tree of all the handles in this client
  * @lock:		lock protecting the tree of handles
- * @heap_type_mask:	mask of all supported heap types
  * @name:		used for debugging
  * @task:		used for debugging
  *
@@ -76,7 +75,6 @@ struct ion_client {
 	struct ion_device *dev;
 	struct rb_root handles;
 	struct mutex lock;
-	unsigned int heap_type_mask;
 	const char *name;
 	struct task_struct *task;
 	pid_t pid;
@@ -410,9 +408,6 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 
 	down_read(&dev->lock);
 	plist_for_each_entry(heap, &dev->heaps, node) {
-		/* if the client doesn't support this heap type */
-		if (!((1 << heap->type) & client->heap_type_mask))
-			continue;
 		/* if the caller didn't specify this heap id */
 		if (!((1 << heap->id) & heap_id_mask))
 			continue;
@@ -627,7 +622,6 @@ static const struct file_operations debug_client_fops = {
 };
 
 struct ion_client *ion_client_create(struct ion_device *dev,
-				     unsigned int heap_type_mask,
 				     const char *name)
 {
 	struct ion_client *client;
@@ -662,7 +656,6 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	client->handles = RB_ROOT;
 	mutex_init(&client->lock);
 	client->name = name;
-	client->heap_type_mask = heap_type_mask;
 	client->task = task;
 	client->pid = pid;
 
@@ -1162,7 +1155,7 @@ static int ion_open(struct inode *inode, struct file *file)
 	struct ion_client *client;
 
 	pr_debug("%s: %d\n", __func__, __LINE__);
-	client = ion_client_create(dev, -1, "user");
+	client = ion_client_create(dev, "user");
 	if (IS_ERR_OR_NULL(client))
 		return PTR_ERR(client);
 	file->private_data = client;
@@ -1178,7 +1171,7 @@ static const struct file_operations ion_fops = {
 };
 
 static size_t ion_debug_heap_total(struct ion_client *client,
-				   enum ion_heap_type type)
+				   unsigned int id)
 {
 	size_t size = 0;
 	struct rb_node *n;
@@ -1188,7 +1181,7 @@ static size_t ion_debug_heap_total(struct ion_client *client,
 		struct ion_handle *handle = rb_entry(n,
 						     struct ion_handle,
 						     node);
-		if (handle->buffer->heap->type == type)
+		if (handle->buffer->heap->id == id)
 			size += handle->buffer->size;
 	}
 	mutex_unlock(&client->lock);
@@ -1209,7 +1202,7 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 	for (n = rb_first(&dev->clients); n; n = rb_next(n)) {
 		struct ion_client *client = rb_entry(n, struct ion_client,
 						     node);
-		size_t size = ion_debug_heap_total(client, heap->type);
+		size_t size = ion_debug_heap_total(client, heap->id);
 		if (!size)
 			continue;
 		if (client->task) {
@@ -1230,7 +1223,7 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 	for (n = rb_first(&dev->buffers); n; n = rb_next(n)) {
 		struct ion_buffer *buffer = rb_entry(n, struct ion_buffer,
 						     node);
-		if (buffer->heap->type != heap->type)
+		if (buffer->heap->id != heap->id)
 			continue;
 		total_size += buffer->size;
 		if (!buffer->handle_count) {
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index a315858..0f67014f 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -124,7 +124,6 @@ void ion_reserve(struct ion_platform_data *data);
  * @name:		used for debugging
  */
 struct ion_client *ion_client_create(struct ion_device *dev,
-				     unsigned int heap_type_mask,
 				     const char *name);
 
 /**
-- 
1.8.3.2

