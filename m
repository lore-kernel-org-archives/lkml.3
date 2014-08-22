Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbaHVQxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:53:44 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:49928 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbaHVQxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:41 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/15] percpu: restructure locking
Date: Fri, 22 Aug 2014 12:53:12 -0400
Message-Id: <1408726399-4436-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At first, the percpu allocator required a sleepable context for both
alloc and free paths and used pcpu_alloc_mutex to protect everything.
Later, pcpu_lock was introduced to protect the index data structure so
that the free path can be invoked from atomic contexts.  The
conversion only updated what's necessary and left most of the
allocation path under pcpu_alloc_mutex.

The percpu allocator is planned to add support for atomic allocation
and this patch restructures locking so that the coverage of
pcpu_alloc_mutex is further reduced.

* pcpu_alloc() now grab pcpu_alloc_mutex only while creating a new
  chunk and populating the allocated area.  Everything else is now
  protected soley by pcpu_lock.

  After this change, multiple instances of pcpu_extend_area_map() may
  race but the function already implements sufficient synchronization
  using pcpu_lock.

  This also allows multiple allocators to arrive at new chunk
  creation.  To avoid creating multiple empty chunks back-to-back, a
  new chunk is created iff there is no other empty chunk after
  grabbing pcpu_alloc_mutex.

* pcpu_lock is now held while modifying chunk->populated bitmap.
  After this, all data structures are protected by pcpu_lock.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu-km.c |  2 ++
 mm/percpu.c    | 75 +++++++++++++++++++++++++++-------------------------------
 2 files changed, 37 insertions(+), 40 deletions(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index 67a971b..e662b49 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -68,7 +68,9 @@ static struct pcpu_chunk *pcpu_create_chunk(void)
 	chunk->data = pages;
 	chunk->base_addr = page_address(pages) - pcpu_group_offsets[0];
 
+	spin_lock_irq(&pcpu_lock);
 	bitmap_fill(chunk->populated, nr_pages);
+	spin_unlock_irq(&pcpu_lock);
 
 	return chunk;
 }
diff --git a/mm/percpu.c b/mm/percpu.c
index c8fe482..507afc0 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -152,31 +152,12 @@ static struct pcpu_chunk *pcpu_reserved_chunk;
 static int pcpu_reserved_chunk_limit;
 
 /*
- * Synchronization rules.
- *
- * There are two locks - pcpu_alloc_mutex and pcpu_lock.  The former
- * protects allocation/reclaim paths, chunks, populated bitmap and
- * vmalloc mapping.  The latter is a spinlock and protects the index
- * data structures - chunk slots, chunks and area maps in chunks.
- *
- * During allocation, pcpu_alloc_mutex is kept locked all the time and
- * pcpu_lock is grabbed and released as necessary.  All actual memory
- * allocations are done using GFP_KERNEL with pcpu_lock released.  In
- * general, percpu memory can't be allocated with irq off but
- * irqsave/restore are still used in alloc path so that it can be used
- * from early init path - sched_init() specifically.
- *
- * Free path accesses and alters only the index data structures, so it
- * can be safely called from atomic context.  When memory needs to be
- * returned to the system, free path schedules reclaim_work which
- * grabs both pcpu_alloc_mutex and pcpu_lock, unlinks chunks to be
- * reclaimed, release both locks and frees the chunks.  Note that it's
- * necessary to grab both locks to remove a chunk from circulation as
- * allocation path might be referencing the chunk with only
- * pcpu_alloc_mutex locked.
+ * Free path accesses and alters only the index data structures and can be
+ * safely called from atomic context.  When memory needs to be returned to
+ * the system, free path schedules reclaim_work.
  */
-static DEFINE_MUTEX(pcpu_alloc_mutex);	/* protects whole alloc and reclaim */
-static DEFINE_SPINLOCK(pcpu_lock);	/* protects index data structures */
+static DEFINE_SPINLOCK(pcpu_lock);	/* all internal data structures */
+static DEFINE_MUTEX(pcpu_alloc_mutex);	/* chunk create/destroy, [de]pop */
 
 static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
 
@@ -709,7 +690,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	static int warn_limit = 10;
 	struct pcpu_chunk *chunk;
 	const char *err;
-	int slot, off, new_alloc, cpu;
+	int slot, off, new_alloc, cpu, ret;
 	int page_start, page_end, rs, re;
 	unsigned long flags;
 	void __percpu *ptr;
@@ -729,7 +710,6 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 		return NULL;
 	}
 
-	mutex_lock(&pcpu_alloc_mutex);
 	spin_lock_irqsave(&pcpu_lock, flags);
 
 	/* serve reserved allocations from the reserved chunk if available */
@@ -745,7 +725,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 			spin_unlock_irqrestore(&pcpu_lock, flags);
 			if (pcpu_extend_area_map(chunk, new_alloc) < 0) {
 				err = "failed to extend area map of reserved chunk";
-				goto fail_unlock_mutex;
+				goto fail;
 			}
 			spin_lock_irqsave(&pcpu_lock, flags);
 		}
@@ -771,7 +751,7 @@ restart:
 				if (pcpu_extend_area_map(chunk,
 							 new_alloc) < 0) {
 					err = "failed to extend area map";
-					goto fail_unlock_mutex;
+					goto fail;
 				}
 				spin_lock_irqsave(&pcpu_lock, flags);
 				/*
@@ -787,37 +767,53 @@ restart:
 		}
 	}
 
-	/* hmmm... no space left, create a new chunk */
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
-	chunk = pcpu_create_chunk();
-	if (!chunk) {
-		err = "failed to allocate new chunk";
-		goto fail_unlock_mutex;
+	/*
+	 * No space left.  Create a new chunk.  We don't want multiple
+	 * tasks to create chunks simultaneously.  Serialize and create iff
+	 * there's still no empty chunk after grabbing the mutex.
+	 */
+	mutex_lock(&pcpu_alloc_mutex);
+
+	if (list_empty(&pcpu_slot[pcpu_nr_slots - 1])) {
+		chunk = pcpu_create_chunk();
+		if (!chunk) {
+			err = "failed to allocate new chunk";
+			goto fail;
+		}
+
+		spin_lock_irqsave(&pcpu_lock, flags);
+		pcpu_chunk_relocate(chunk, -1);
+	} else {
+		spin_lock_irqsave(&pcpu_lock, flags);
 	}
 
-	spin_lock_irqsave(&pcpu_lock, flags);
-	pcpu_chunk_relocate(chunk, -1);
+	mutex_unlock(&pcpu_alloc_mutex);
 	goto restart;
 
 area_found:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	/* populate if not all pages are already there */
+	mutex_lock(&pcpu_alloc_mutex);
 	page_start = PFN_DOWN(off);
 	page_end = PFN_UP(off + size);
 
 	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
 		WARN_ON(chunk->immutable);
 
-		if (pcpu_populate_chunk(chunk, rs, re)) {
-			spin_lock_irqsave(&pcpu_lock, flags);
+		ret = pcpu_populate_chunk(chunk, rs, re);
+
+		spin_lock_irqsave(&pcpu_lock, flags);
+		if (ret) {
+			mutex_unlock(&pcpu_alloc_mutex);
 			pcpu_free_area(chunk, off);
 			err = "failed to populate";
 			goto fail_unlock;
 		}
-
 		bitmap_set(chunk->populated, rs, re - rs);
+		spin_unlock_irqrestore(&pcpu_lock, flags);
 	}
 
 	mutex_unlock(&pcpu_alloc_mutex);
@@ -832,8 +828,7 @@ area_found:
 
 fail_unlock:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
-fail_unlock_mutex:
-	mutex_unlock(&pcpu_alloc_mutex);
+fail:
 	if (warn_limit) {
 		pr_warning("PERCPU: allocation failed, size=%zu align=%zu, "
 			   "%s\n", size, align, err);
-- 
1.9.3

