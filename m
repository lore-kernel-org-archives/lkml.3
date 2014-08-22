Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbaHVQzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:55:08 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:54589 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853AbaHVQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:47 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/15] percpu: make sure chunk->map array has available space
Date: Fri, 22 Aug 2014 12:53:16 -0400
Message-Id: <1408726399-4436-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An allocation attempt may require extending chunk->map array which
requires GFP_KERNEL context which isn't available for atomic
allocations.  This patch ensures that chunk->map array usually keeps
some amount of available space by directly allocating buffer space
during GFP_KERNEL allocations and scheduling async extension during
atomic ones.  This should make atomic allocation failures from map
space exhaustion rare.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c | 53 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index e2a8089..d6b36e7 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -76,6 +76,8 @@
 
 #define PCPU_SLOT_BASE_SHIFT		5	/* 1-31 shares the same slot */
 #define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */
+#define PCPU_ATOMIC_MAP_MARGIN_LOW	32
+#define PCPU_ATOMIC_MAP_MARGIN_HIGH	64
 
 #ifdef CONFIG_SMP
 /* default addr <-> pcpu_ptr mapping, override in asm/percpu.h if necessary */
@@ -102,9 +104,12 @@ struct pcpu_chunk {
 	int			free_size;	/* free bytes in the chunk */
 	int			contig_hint;	/* max contiguous size hint */
 	void			*base_addr;	/* base address of this chunk */
+
 	int			map_used;	/* # of map entries used before the sentry */
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
+	struct work_struct	map_extend_work;/* async ->map[] extension */
+
 	void			*data;		/* chunk data */
 	int			first_free;	/* no free below this */
 	bool			immutable;	/* no [de]population allowed */
@@ -318,9 +323,14 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
 /**
  * pcpu_need_to_extend - determine whether chunk area map needs to be extended
  * @chunk: chunk of interest
+ * @is_atomic: the allocation context
  *
- * Determine whether area map of @chunk needs to be extended to
- * accommodate a new allocation.
+ * Determine whether area map of @chunk needs to be extended.  If
+ * @is_atomic, only the amount necessary for a new allocation is
+ * considered; however, async extension is scheduled if the left amount is
+ * low.  If !@is_atomic, it aims for more empty space.  Combined, this
+ * ensures that the map is likely to have enough available space to
+ * accomodate atomic allocations which can't extend maps directly.
  *
  * CONTEXT:
  * pcpu_lock.
@@ -329,15 +339,25 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
  * New target map allocation length if extension is necessary, 0
  * otherwise.
  */
-static int pcpu_need_to_extend(struct pcpu_chunk *chunk)
+static int pcpu_need_to_extend(struct pcpu_chunk *chunk, bool is_atomic)
 {
-	int new_alloc;
+	int margin, new_alloc;
+
+	if (is_atomic) {
+		margin = 3;
 
-	if (chunk->map_alloc >= chunk->map_used + 3)
+		if (chunk->map_alloc <
+		    chunk->map_used + PCPU_ATOMIC_MAP_MARGIN_LOW)
+			schedule_work(&chunk->map_extend_work);
+	} else {
+		margin = PCPU_ATOMIC_MAP_MARGIN_HIGH;
+	}
+
+	if (chunk->map_alloc >= chunk->map_used + margin)
 		return 0;
 
 	new_alloc = PCPU_DFL_MAP_ALLOC;
-	while (new_alloc < chunk->map_used + 3)
+	while (new_alloc < chunk->map_used + margin)
 		new_alloc *= 2;
 
 	return new_alloc;
@@ -394,6 +414,20 @@ out_unlock:
 	return 0;
 }
 
+static void pcpu_map_extend_workfn(struct work_struct *work)
+{
+	struct pcpu_chunk *chunk = container_of(work, struct pcpu_chunk,
+						map_extend_work);
+	int new_alloc;
+
+	spin_lock_irq(&pcpu_lock);
+	new_alloc = pcpu_need_to_extend(chunk, false);
+	spin_unlock_irq(&pcpu_lock);
+
+	if (new_alloc)
+		pcpu_extend_area_map(chunk, new_alloc);
+}
+
 /**
  * pcpu_fit_in_area - try to fit the requested allocation in a candidate area
  * @chunk: chunk the candidate area belongs to
@@ -647,6 +681,7 @@ static struct pcpu_chunk *pcpu_alloc_chunk(void)
 	chunk->map_used = 1;
 
 	INIT_LIST_HEAD(&chunk->list);
+	INIT_WORK(&chunk->map_extend_work, pcpu_map_extend_workfn);
 	chunk->free_size = pcpu_unit_size;
 	chunk->contig_hint = pcpu_unit_size;
 
@@ -767,7 +802,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 			goto fail_unlock;
 		}
 
-		while ((new_alloc = pcpu_need_to_extend(chunk))) {
+		while ((new_alloc = pcpu_need_to_extend(chunk, is_atomic))) {
 			spin_unlock_irqrestore(&pcpu_lock, flags);
 			if (is_atomic ||
 			    pcpu_extend_area_map(chunk, new_alloc) < 0) {
@@ -792,7 +827,7 @@ restart:
 			if (size > chunk->contig_hint)
 				continue;
 
-			new_alloc = pcpu_need_to_extend(chunk);
+			new_alloc = pcpu_need_to_extend(chunk, is_atomic);
 			if (new_alloc) {
 				if (is_atomic)
 					continue;
@@ -1418,6 +1453,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	 */
 	schunk = memblock_virt_alloc(pcpu_chunk_struct_size, 0);
 	INIT_LIST_HEAD(&schunk->list);
+	INIT_WORK(&schunk->map_extend_work, pcpu_map_extend_workfn);
 	schunk->base_addr = base_addr;
 	schunk->map = smap;
 	schunk->map_alloc = ARRAY_SIZE(smap);
@@ -1446,6 +1482,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	if (dyn_size) {
 		dchunk = memblock_virt_alloc(pcpu_chunk_struct_size, 0);
 		INIT_LIST_HEAD(&dchunk->list);
+		INIT_WORK(&dchunk->map_extend_work, pcpu_map_extend_workfn);
 		dchunk->base_addr = base_addr;
 		dchunk->map = dmap;
 		dchunk->map_alloc = ARRAY_SIZE(dmap);
-- 
1.9.3

