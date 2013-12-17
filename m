Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3LQFIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:08:41 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62278 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3LQFIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:08:04 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 3/3] staging: ion: Avoid using rt_mutexes directly.
Date: Mon, 16 Dec 2013 21:07:53 -0800
Message-Id: <1387256873-21350-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
References: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RT_MUTEXES can be configured out of the kernel, causing compile
problems with ION.

To quote Colin:
"rt_mutexes were added with the deferred freeing feature.  Heaps need
to return zeroed memory to userspace, but zeroing the memory on every
allocation was causing performance issues.  We added a SCHED_IDLE
thread to zero memory in the background after freeing, but locking the
heap from the SCHED_IDLE thread might block a high priority allocation
thread for a long time.

The lock is only used to protect the heap's free_list and
free_list_size members, and is not held for any long or sleeping
operations.  Converting to a spinlock should prevent priority
inversion without using the rt_mutex.  I'd also rename it to free_lock
to so it doesn't get used as a general heap lock."

Thus this patch converts the rt_mutex usage to a spinlock and
renames the lock free_lock to be more clear as to its use.

I also had to change a bit of logic in ion_heap_freelist_drain()
despite the for loop being a for_each_entry_safe(), I was still
seeing list corruption or buffer sg table corruption if I dropped
the lock before calling ion_buffer_destroy().

Not being able to sort out exactly why, I borrowed the loop structure
from ion_heap_deferred_free() and that works in my testing w/o issue.

Not sure if its the mixing of list traversal methods causing the issue?
Thoughts would be appreciated.

Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_heap.c | 31 +++++++++++++++++++------------
 drivers/staging/android/ion/ion_priv.h |  2 +-
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 9cf5622..72fe74b 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -160,10 +160,10 @@ int ion_heap_pages_zero(struct page *page, size_t size, pgprot_t pgprot)
 
 void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer *buffer)
 {
-	rt_mutex_lock(&heap->lock);
+	spin_lock(&heap->free_lock);
 	list_add(&buffer->list, &heap->free_list);
 	heap->free_list_size += buffer->size;
-	rt_mutex_unlock(&heap->lock);
+	spin_unlock(&heap->free_lock);
 	wake_up(&heap->waitqueue);
 }
 
@@ -171,34 +171,41 @@ size_t ion_heap_freelist_size(struct ion_heap *heap)
 {
 	size_t size;
 
-	rt_mutex_lock(&heap->lock);
+	spin_lock(&heap->free_lock);
 	size = heap->free_list_size;
-	rt_mutex_unlock(&heap->lock);
+	spin_unlock(&heap->free_lock);
 
 	return size;
 }
 
 size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
 {
-	struct ion_buffer *buffer, *tmp;
+	struct ion_buffer *buffer;
 	size_t total_drained = 0;
 
 	if (ion_heap_freelist_size(heap) == 0)
 		return 0;
 
-	rt_mutex_lock(&heap->lock);
+	spin_lock(&heap->free_lock);
 	if (size == 0)
 		size = heap->free_list_size;
 
-	list_for_each_entry_safe(buffer, tmp, &heap->free_list, list) {
+	while (true) {
 		if (total_drained >= size)
 			break;
+		if (list_empty(&heap->free_list))
+			break;
+
+		buffer = list_first_entry(&heap->free_list, struct ion_buffer,
+					  list);
 		list_del(&buffer->list);
 		heap->free_list_size -= buffer->size;
 		total_drained += buffer->size;
+		spin_unlock(&heap->free_lock);
 		ion_buffer_destroy(buffer);
+		spin_lock(&heap->free_lock);
 	}
-	rt_mutex_unlock(&heap->lock);
+	spin_unlock(&heap->free_lock);
 
 	return total_drained;
 }
@@ -213,16 +220,16 @@ static int ion_heap_deferred_free(void *data)
 		wait_event_freezable(heap->waitqueue,
 				     ion_heap_freelist_size(heap) > 0);
 
-		rt_mutex_lock(&heap->lock);
+		spin_lock(&heap->free_lock);
 		if (list_empty(&heap->free_list)) {
-			rt_mutex_unlock(&heap->lock);
+			spin_unlock(&heap->free_lock);
 			continue;
 		}
 		buffer = list_first_entry(&heap->free_list, struct ion_buffer,
 					  list);
 		list_del(&buffer->list);
 		heap->free_list_size -= buffer->size;
-		rt_mutex_unlock(&heap->lock);
+		spin_unlock(&heap->free_lock);
 		ion_buffer_destroy(buffer);
 	}
 
@@ -235,7 +242,7 @@ int ion_heap_init_deferred_free(struct ion_heap *heap)
 
 	INIT_LIST_HEAD(&heap->free_list);
 	heap->free_list_size = 0;
-	rt_mutex_init(&heap->lock);
+	spin_lock_init(&heap->free_lock);
 	init_waitqueue_head(&heap->waitqueue);
 	heap->task = kthread_run(ion_heap_deferred_free, heap,
 				 "%s", heap->name);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index fc8a4c3..d986739 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -159,7 +159,7 @@ struct ion_heap {
 	struct shrinker shrinker;
 	struct list_head free_list;
 	size_t free_list_size;
-	struct rt_mutex lock;
+	spinlock_t free_lock;
 	wait_queue_head_t waitqueue;
 	struct task_struct *task;
 	int (*debug_show)(struct ion_heap *heap, struct seq_file *, void *);
-- 
1.8.3.2

