Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3LPVdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:33:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45971 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3LPVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:33:10 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [RFC][PATCH 3/3] staging: ion: Avoid using rt_mutexes directly.
Date: Mon, 16 Dec 2013 13:32:44 -0800
Message-Id: <1387229564-19517-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>
References: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RT_MUTEXES can be configured out of the kernel, causing compile
problems with ION.

Since there is no documentation as to why directly using rt_mutexes
is necessary (and very few drivers directly use rt_mutexes), simply
convert the ion_heap lock to a normal mutex.

Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_heap.c | 20 ++++++++++----------
 drivers/staging/android/ion/ion_priv.h |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 9cf5622..88685da 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -160,10 +160,10 @@ int ion_heap_pages_zero(struct page *page, size_t size, pgprot_t pgprot)
 
 void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer *buffer)
 {
-	rt_mutex_lock(&heap->lock);
+	mutex_lock(&heap->lock);
 	list_add(&buffer->list, &heap->free_list);
 	heap->free_list_size += buffer->size;
-	rt_mutex_unlock(&heap->lock);
+	mutex_unlock(&heap->lock);
 	wake_up(&heap->waitqueue);
 }
 
@@ -171,9 +171,9 @@ size_t ion_heap_freelist_size(struct ion_heap *heap)
 {
 	size_t size;
 
-	rt_mutex_lock(&heap->lock);
+	mutex_lock(&heap->lock);
 	size = heap->free_list_size;
-	rt_mutex_unlock(&heap->lock);
+	mutex_unlock(&heap->lock);
 
 	return size;
 }
@@ -186,7 +186,7 @@ size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
 	if (ion_heap_freelist_size(heap) == 0)
 		return 0;
 
-	rt_mutex_lock(&heap->lock);
+	mutex_lock(&heap->lock);
 	if (size == 0)
 		size = heap->free_list_size;
 
@@ -198,7 +198,7 @@ size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
 		total_drained += buffer->size;
 		ion_buffer_destroy(buffer);
 	}
-	rt_mutex_unlock(&heap->lock);
+	mutex_unlock(&heap->lock);
 
 	return total_drained;
 }
@@ -213,16 +213,16 @@ static int ion_heap_deferred_free(void *data)
 		wait_event_freezable(heap->waitqueue,
 				     ion_heap_freelist_size(heap) > 0);
 
-		rt_mutex_lock(&heap->lock);
+		mutex_lock(&heap->lock);
 		if (list_empty(&heap->free_list)) {
-			rt_mutex_unlock(&heap->lock);
+			mutex_unlock(&heap->lock);
 			continue;
 		}
 		buffer = list_first_entry(&heap->free_list, struct ion_buffer,
 					  list);
 		list_del(&buffer->list);
 		heap->free_list_size -= buffer->size;
-		rt_mutex_unlock(&heap->lock);
+		mutex_unlock(&heap->lock);
 		ion_buffer_destroy(buffer);
 	}
 
@@ -235,7 +235,7 @@ int ion_heap_init_deferred_free(struct ion_heap *heap)
 
 	INIT_LIST_HEAD(&heap->free_list);
 	heap->free_list_size = 0;
-	rt_mutex_init(&heap->lock);
+	mutex_init(&heap->lock);
 	init_waitqueue_head(&heap->waitqueue);
 	heap->task = kthread_run(ion_heap_deferred_free, heap,
 				 "%s", heap->name);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index fc8a4c3..df81ce1 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -159,7 +159,7 @@ struct ion_heap {
 	struct shrinker shrinker;
 	struct list_head free_list;
 	size_t free_list_size;
-	struct rt_mutex lock;
+	struct mutex lock;
 	wait_queue_head_t waitqueue;
 	struct task_struct *task;
 	int (*debug_show)(struct ion_heap *heap, struct seq_file *, void *);
-- 
1.8.3.2

