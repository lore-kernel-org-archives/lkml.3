Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3LND1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:44 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58121 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3LND0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:26:47 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 094/115] ion: fix printk warnings
Date: Fri, 13 Dec 2013 19:26:14 -0800
Message-Id: <1386991595-6251-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Use %z for size_t and %pa for dma_addr_t to avoid warnings in printks.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c            | 23 ++++++++++++-----------
 drivers/staging/android/ion/ion_chunk_heap.c |  2 +-
 drivers/staging/android/ion/ion_cma_heap.c   |  4 ++--
 drivers/staging/android/ion/ion_heap.c       |  2 +-
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 199ab9a..57698e6 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -471,7 +471,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 	struct ion_heap *heap;
 	int ret;
 
-	pr_debug("%s: len %d align %d heap_id_mask %u flags %x\n", __func__,
+	pr_debug("%s: len %zu align %zu heap_id_mask %u flags %x\n", __func__,
 		 len, align, heap_id_mask, flags);
 	/*
 	 * traverse the list of heaps available in this system in priority
@@ -688,7 +688,7 @@ static int ion_debug_client_show(struct seq_file *s, void *unused)
 	for (i = 0; i < ION_NUM_HEAP_IDS; i++) {
 		if (!names[i])
 			continue;
-		seq_printf(s, "%16.16s: %16u\n", names[i], sizes[i]);
+		seq_printf(s, "%16.16s: %16zu\n", names[i], sizes[i]);
 	}
 	return 0;
 }
@@ -1336,10 +1336,10 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 			char task_comm[TASK_COMM_LEN];
 
 			get_task_comm(task_comm, client->task);
-			seq_printf(s, "%16.s %16u %16u\n", task_comm,
+			seq_printf(s, "%16.s %16u %16zu\n", task_comm,
 				   client->pid, size);
 		} else {
-			seq_printf(s, "%16.s %16u %16u\n", client->name,
+			seq_printf(s, "%16.s %16u %16zu\n", client->name,
 				   client->pid, size);
 		}
 	}
@@ -1354,19 +1354,20 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 			continue;
 		total_size += buffer->size;
 		if (!buffer->handle_count) {
-			seq_printf(s, "%16.s %16u %16u %d %d\n", buffer->task_comm,
-				   buffer->pid, buffer->size, buffer->kmap_cnt,
+			seq_printf(s, "%16.s %16u %16zu %d %d\n",
+				   buffer->task_comm, buffer->pid,
+				   buffer->size, buffer->kmap_cnt,
 				   atomic_read(&buffer->ref.refcount));
 			total_orphaned_size += buffer->size;
 		}
 	}
 	mutex_unlock(&dev->buffer_lock);
 	seq_printf(s, "----------------------------------------------------\n");
-	seq_printf(s, "%16.s %16u\n", "total orphaned",
+	seq_printf(s, "%16.s %16zu\n", "total orphaned",
 		   total_orphaned_size);
-	seq_printf(s, "%16.s %16u\n", "total ", total_size);
+	seq_printf(s, "%16.s %16zu\n", "total ", total_size);
 	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE)
-		seq_printf(s, "%16.s %16u\n", "deferred free",
+		seq_printf(s, "%16.s %16zu\n", "deferred free",
 				heap->free_list_size);
 	seq_printf(s, "----------------------------------------------------\n");
 
@@ -1522,11 +1523,11 @@ void __init ion_reserve(struct ion_platform_data *data)
 			int ret = memblock_reserve(data->heaps[i].base,
 					       data->heaps[i].size);
 			if (ret)
-				pr_err("memblock reserve of %x@%lx failed\n",
+				pr_err("memblock reserve of %zx@%lx failed\n",
 				       data->heaps[i].size,
 				       data->heaps[i].base);
 		}
-		pr_info("%s: %s reserved base %lx size %d\n", __func__,
+		pr_info("%s: %s reserved base %lx size %zu\n", __func__,
 			data->heaps[i].name,
 			data->heaps[i].base,
 			data->heaps[i].size);
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index fb1a7b9..4eacf52 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -186,7 +186,7 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 	chunk_heap->heap.ops = &chunk_heap_ops;
 	chunk_heap->heap.type = ION_HEAP_TYPE_CHUNK;
 	chunk_heap->heap.flags = ION_HEAP_FLAG_DEFER_FREE;
-	pr_info("%s: base %lu size %u align %ld\n", __func__, chunk_heap->base,
+	pr_info("%s: base %lu size %zu align %ld\n", __func__, chunk_heap->base,
 		heap_data->size, heap_data->align);
 
 	return &chunk_heap->heap;
diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
index 86b6cf5..1e308a0 100644
--- a/drivers/staging/android/ion/ion_cma_heap.c
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -128,8 +128,8 @@ static int ion_cma_phys(struct ion_heap *heap, struct ion_buffer *buffer,
 	struct device *dev = cma_heap->dev;
 	struct ion_cma_buffer_info *info = buffer->priv_virt;
 
-	dev_dbg(dev, "Return buffer %p physical address 0x%x\n", buffer,
-		info->handle);
+	dev_dbg(dev, "Return buffer %p physical address 0x%pa\n", buffer,
+		&info->handle);
 
 	*addr = info->handle;
 	*len = buffer->size;
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index a5a7c572..deaab7c 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -281,7 +281,7 @@ struct ion_heap *ion_heap_create(struct ion_platform_heap *heap_data)
 	}
 
 	if (IS_ERR_OR_NULL(heap)) {
-		pr_err("%s: error creating heap %s type %d base %lu size %u\n",
+		pr_err("%s: error creating heap %s type %d base %lu size %zu\n",
 		       __func__, heap_data->name, heap_data->type,
 		       heap_data->base, heap_data->size);
 		return ERR_PTR(-EINVAL);
-- 
1.8.3.2

