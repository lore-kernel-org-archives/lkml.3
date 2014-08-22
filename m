Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaHVQ5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:57:18 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60501 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783AbaHVQxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:37 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/15] percpu: move common parts out of pcpu_[de]populate_chunk()
Date: Fri, 22 Aug 2014 12:53:09 -0400
Message-Id: <1408726399-4436-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu-vm and percpu-km implement separate versions of
pcpu_[de]populate_chunk() and some part which is or should be common
are currently in the specific implementations.  Make the following
changes.

* Allocate area clearing is moved from the pcpu_populate_chunk()
  implementations to pcpu_alloc().  This makes percpu-km's version
  noop.

* Quick exit tests in pcpu_[de]populate_chunk() of percpu-vm are moved
  to their respective callers so that they are applied to percpu-km
  too.  This doesn't make any meaningful difference as both functions
  are noop for percpu-km; however, this is more consistent and will
  help implementing atomic allocation support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu-km.c |  5 -----
 mm/percpu-vm.c | 27 +--------------------------
 mm/percpu.c    | 39 ++++++++++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index 89633fe..9a9096f 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -35,11 +35,6 @@
 
 static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 {
-	unsigned int cpu;
-
-	for_each_possible_cpu(cpu)
-		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
-
 	return 0;
 }
 
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index d9e0b61..edf7097 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -265,7 +265,7 @@ static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
  * @size: size of the area to populate in bytes
  *
  * For each cpu, populate and map pages [@page_start,@page_end) into
- * @chunk.  The area is cleared on return.
+ * @chunk.
  *
  * CONTEXT:
  * pcpu_alloc_mutex, does GFP_KERNEL allocation.
@@ -276,18 +276,8 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	int page_end = PFN_UP(off + size);
 	int free_end = page_start, unmap_end = page_start;
 	struct page **pages;
-	unsigned int cpu;
 	int rs, re, rc;
 
-	/* quick path, check whether all pages are already there */
-	rs = page_start;
-	pcpu_next_pop(chunk, &rs, &re, page_end);
-	if (rs == page_start && re == page_end)
-		goto clear;
-
-	/* need to allocate and map pages, this chunk can't be immutable */
-	WARN_ON(chunk->immutable);
-
 	pages = pcpu_get_pages(chunk);
 	if (!pages)
 		return -ENOMEM;
@@ -308,10 +298,6 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	}
 	pcpu_post_map_flush(chunk, page_start, page_end);
 
-	bitmap_set(chunk->populated, page_start, page_end - page_start);
-clear:
-	for_each_possible_cpu(cpu)
-		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
 	return 0;
 
 err_unmap:
@@ -345,15 +331,6 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	struct page **pages;
 	int rs, re;
 
-	/* quick path, check whether it's empty already */
-	rs = page_start;
-	pcpu_next_unpop(chunk, &rs, &re, page_end);
-	if (rs == page_start && re == page_end)
-		return;
-
-	/* immutable chunks can't be depopulated */
-	WARN_ON(chunk->immutable);
-
 	/*
 	 * If control reaches here, there must have been at least one
 	 * successful population attempt so the temp pages array must
@@ -372,8 +349,6 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 
 	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
 		pcpu_free_pages(chunk, pages, rs, re);
-
-	bitmap_clear(chunk->populated, page_start, page_end - page_start);
 }
 
 static struct pcpu_chunk *pcpu_create_chunk(void)
diff --git a/mm/percpu.c b/mm/percpu.c
index 2139e30..12b0049 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -709,7 +709,8 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	static int warn_limit = 10;
 	struct pcpu_chunk *chunk;
 	const char *err;
-	int slot, off, new_alloc;
+	int slot, off, new_alloc, cpu;
+	int page_start, page_end, rs, re;
 	unsigned long flags;
 	void __percpu *ptr;
 
@@ -802,17 +803,32 @@ restart:
 area_found:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
-	/* populate, map and clear the area */
-	if (pcpu_populate_chunk(chunk, off, size)) {
-		spin_lock_irqsave(&pcpu_lock, flags);
-		pcpu_free_area(chunk, off);
-		err = "failed to populate";
-		goto fail_unlock;
+	/* populate if not all pages are already there */
+	page_start = PFN_DOWN(off);
+	page_end = PFN_UP(off + size);
+
+	rs = page_start;
+	pcpu_next_pop(chunk, &rs, &re, page_end);
+
+	if (rs != page_start || re != page_end) {
+		WARN_ON(chunk->immutable);
+
+		if (pcpu_populate_chunk(chunk, off, size)) {
+			spin_lock_irqsave(&pcpu_lock, flags);
+			pcpu_free_area(chunk, off);
+			err = "failed to populate";
+			goto fail_unlock;
+		}
+
+		bitmap_set(chunk->populated, page_start, page_end - page_start);
 	}
 
 	mutex_unlock(&pcpu_alloc_mutex);
 
-	/* return address relative to base address */
+	/* clear the areas and return address relative to base address */
+	for_each_possible_cpu(cpu)
+		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
+
 	ptr = __addr_to_pcpu_ptr(chunk->base_addr + off);
 	kmemleak_alloc_percpu(ptr, size);
 	return ptr;
@@ -903,7 +919,12 @@ static void pcpu_reclaim(struct work_struct *work)
 	spin_unlock_irq(&pcpu_lock);
 
 	list_for_each_entry_safe(chunk, next, &todo, list) {
-		pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size);
+		int rs = 0, re;
+
+		pcpu_next_unpop(chunk, &rs, &re, PFN_UP(pcpu_unit_size));
+		if (rs || re != PFN_UP(pcpu_unit_size))
+			pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size);
+
 		pcpu_destroy_chunk(chunk);
 	}
 
-- 
1.9.3

