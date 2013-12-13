Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3LMWjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:39:39 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62793 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3LMW12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:28 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 051/115] gpu: ion: Switch heap rbtree to a prio list
Date: Fri, 13 Dec 2013 14:24:25 -0800
Message-Id: <1386973529-4884-52-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Switches the rbtree tree of heaps for a plist.  This significantly
simplifies the code and the list is small and is modified only at
first boot so the rbtree is unnecessary.  This also switches
the traversal of the heap list to traverse from highest to lowest
id's.  This allows allocations to pass a heap mask that falls
back on the system heap -- typically id 0, which is the common case.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c      | 35 ++++++++--------------------------
 drivers/staging/android/ion/ion_priv.h |  4 ++--
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 3f22f88..8cc0489 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -49,7 +49,7 @@ struct ion_device {
 	struct rb_root buffers;
 	struct mutex buffer_lock;
 	struct rw_semaphore lock;
-	struct rb_root heaps;
+	struct plist_head heaps;
 	long (*custom_ioctl) (struct ion_client *client, unsigned int cmd,
 			      unsigned long arg);
 	struct rb_root clients;
@@ -389,10 +389,10 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 			     size_t align, unsigned int heap_mask,
 			     unsigned int flags)
 {
-	struct rb_node *n;
 	struct ion_handle *handle;
 	struct ion_device *dev = client->dev;
 	struct ion_buffer *buffer = NULL;
+	struct ion_heap *heap;
 
 	pr_debug("%s: len %d align %d heap_mask %u flags %x\n", __func__, len,
 		 align, heap_mask, flags);
@@ -408,8 +408,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 	len = PAGE_ALIGN(len);
 
 	down_read(&dev->lock);
-	for (n = rb_first(&dev->heaps); n != NULL; n = rb_next(n)) {
-		struct ion_heap *heap = rb_entry(n, struct ion_heap, node);
+	plist_for_each_entry(heap, &dev->heaps, node) {
 		/* if the client doesn't support this heap type */
 		if (!((1 << heap->type) & client->heap_mask))
 			continue;
@@ -1266,10 +1265,6 @@ static const struct file_operations debug_heap_fops = {
 
 void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 {
-	struct rb_node **p = &dev->heaps.rb_node;
-	struct rb_node *parent = NULL;
-	struct ion_heap *entry;
-
 	if (!heap->ops->allocate || !heap->ops->free || !heap->ops->map_dma ||
 	    !heap->ops->unmap_dma)
 		pr_err("%s: can not add heap with invalid ops struct.\n",
@@ -1277,26 +1272,12 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 
 	heap->dev = dev;
 	down_write(&dev->lock);
-	while (*p) {
-		parent = *p;
-		entry = rb_entry(parent, struct ion_heap, node);
-
-		if (heap->id < entry->id) {
-			p = &(*p)->rb_left;
-		} else if (heap->id > entry->id ) {
-			p = &(*p)->rb_right;
-		} else {
-			pr_err("%s: can not insert multiple heaps with "
-				"id %d\n", __func__, heap->id);
-			goto end;
-		}
-	}
-
-	rb_link_node(&heap->node, parent, p);
-	rb_insert_color(&heap->node, &dev->heaps);
+	/* use negative heap->id to reverse the priority -- when traversing
+	   the list later attempt higher id numbers first */
+	plist_node_init(&heap->node, -heap->id);
+	plist_add(&heap->node, &dev->heaps);
 	debugfs_create_file(heap->name, 0664, dev->debug_root, heap,
 			    &debug_heap_fops);
-end:
 	up_write(&dev->lock);
 }
 
@@ -1330,7 +1311,7 @@ struct ion_device *ion_device_create(long (*custom_ioctl)
 	idev->buffers = RB_ROOT;
 	mutex_init(&idev->buffer_lock);
 	init_rwsem(&idev->lock);
-	idev->heaps = RB_ROOT;
+	plist_head_init(&idev->heaps);
 	idev->clients = RB_ROOT;
 	return idev;
 }
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 77e2ac0..57dbf6a 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -127,11 +127,11 @@ struct ion_heap_ops {
  * that are allocated from a specially reserved heap.
  */
 struct ion_heap {
-	struct rb_node node;
+	struct plist_node node;
 	struct ion_device *dev;
 	enum ion_heap_type type;
 	struct ion_heap_ops *ops;
-	int id;
+	unsigned int id;
 	const char *name;
 	int (*debug_show)(struct ion_heap *heap, struct seq_file *, void *);
 };
-- 
1.8.3.2

