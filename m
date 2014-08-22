Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbaHVQzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:55:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57023 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbaHVQxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:45 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/15] percpu: implement [__]alloc_percpu_gfp()
Date: Fri, 22 Aug 2014 12:53:15 -0400
Message-Id: <1408726399-4436-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that pcpu_alloc_area() can allocate only from populated areas,
it's easy to add atomic allocation support to [__]alloc_percpu().
Update pcpu_alloc() so that it accepts @gfp and skips all the blocking
operations and allocates only from the populated areas if @gfp doesn't
contain GFP_KERNEL.  New interface functions [__]alloc_percpu_gfp()
are added.

While this means that atomic allocations are possible, this isn't
complete yet as there's no mechanism to ensure that certain amount of
populated areas is kept available and atomic allocations may keep
failing under certain conditions.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h |  9 +++++--
 mm/percpu.c            | 64 ++++++++++++++++++++++++++++++--------------------
 2 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 6f61b61..d1b416d 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -122,11 +122,16 @@ extern void __init setup_per_cpu_areas(void);
 #endif
 extern void __init percpu_init_late(void);
 
+extern void __percpu *__alloc_percpu_gfp(size_t size, size_t align, gfp_t gfp);
 extern void __percpu *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void __percpu *__pdata);
 extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 
-#define alloc_percpu(type)	\
-	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
+#define alloc_percpu_gfp(type, gfp)					\
+	(typeof(type) __percpu *)__alloc_percpu_gfp(sizeof(type),	\
+						__alignof__(type), gfp)
+#define alloc_percpu(type)						\
+	(typeof(type) __percpu *)__alloc_percpu(sizeof(type),		\
+						__alignof__(type))
 
 #endif /* __LINUX_PERCPU_H */
diff --git a/mm/percpu.c b/mm/percpu.c
index 7a012d4..e2a8089 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -151,11 +151,6 @@ static struct pcpu_chunk *pcpu_first_chunk;
 static struct pcpu_chunk *pcpu_reserved_chunk;
 static int pcpu_reserved_chunk_limit;
 
-/*
- * Free path accesses and alters only the index data structures and can be
- * safely called from atomic context.  When memory needs to be returned to
- * the system, free path schedules reclaim_work.
- */
 static DEFINE_SPINLOCK(pcpu_lock);	/* all internal data structures */
 static DEFINE_MUTEX(pcpu_alloc_mutex);	/* chunk create/destroy, [de]pop */
 
@@ -727,20 +722,21 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
  * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
  * @reserved: allocate from the reserved chunk if available
+ * @gfp: allocation flags
  *
- * Allocate percpu area of @size bytes aligned at @align.
- *
- * CONTEXT:
- * Does GFP_KERNEL allocation.
+ * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
+ * contain %GFP_KERNEL, the allocation is atomic.
  *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
  */
-static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
+static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
+				 gfp_t gfp)
 {
 	static int warn_limit = 10;
 	struct pcpu_chunk *chunk;
 	const char *err;
+	bool is_atomic = !(gfp & GFP_KERNEL);
 	int slot, off, new_alloc, cpu, ret;
 	unsigned long flags;
 	void __percpu *ptr;
@@ -773,14 +769,15 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 
 		while ((new_alloc = pcpu_need_to_extend(chunk))) {
 			spin_unlock_irqrestore(&pcpu_lock, flags);
-			if (pcpu_extend_area_map(chunk, new_alloc) < 0) {
+			if (is_atomic ||
+			    pcpu_extend_area_map(chunk, new_alloc) < 0) {
 				err = "failed to extend area map of reserved chunk";
 				goto fail;
 			}
 			spin_lock_irqsave(&pcpu_lock, flags);
 		}
 
-		off = pcpu_alloc_area(chunk, size, align, false);
+		off = pcpu_alloc_area(chunk, size, align, is_atomic);
 		if (off >= 0)
 			goto area_found;
 
@@ -797,6 +794,8 @@ restart:
 
 			new_alloc = pcpu_need_to_extend(chunk);
 			if (new_alloc) {
+				if (is_atomic)
+					continue;
 				spin_unlock_irqrestore(&pcpu_lock, flags);
 				if (pcpu_extend_area_map(chunk,
 							 new_alloc) < 0) {
@@ -811,7 +810,7 @@ restart:
 				goto restart;
 			}
 
-			off = pcpu_alloc_area(chunk, size, align, false);
+			off = pcpu_alloc_area(chunk, size, align, is_atomic);
 			if (off >= 0)
 				goto area_found;
 		}
@@ -824,6 +823,9 @@ restart:
 	 * tasks to create chunks simultaneously.  Serialize and create iff
 	 * there's still no empty chunk after grabbing the mutex.
 	 */
+	if (is_atomic)
+		goto fail;
+
 	mutex_lock(&pcpu_alloc_mutex);
 
 	if (list_empty(&pcpu_slot[pcpu_nr_slots - 1])) {
@@ -846,7 +848,7 @@ area_found:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	/* populate if not all pages are already there */
-	if (true) {
+	if (!is_atomic) {
 		int page_start, page_end, rs, re;
 
 		mutex_lock(&pcpu_alloc_mutex);
@@ -884,9 +886,9 @@ area_found:
 fail_unlock:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 fail:
-	if (warn_limit) {
-		pr_warning("PERCPU: allocation failed, size=%zu align=%zu, "
-			   "%s\n", size, align, err);
+	if (!is_atomic && warn_limit) {
+		pr_warning("PERCPU: allocation failed, size=%zu align=%zu atomic=%d, %s\n",
+			   size, align, is_atomic, err);
 		dump_stack();
 		if (!--warn_limit)
 			pr_info("PERCPU: limit reached, disable warning\n");
@@ -895,22 +897,34 @@ fail:
 }
 
 /**
- * __alloc_percpu - allocate dynamic percpu area
+ * __alloc_percpu_gfp - allocate dynamic percpu area
  * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
+ * @gfp: allocation flags
  *
- * Allocate zero-filled percpu area of @size bytes aligned at @align.
- * Might sleep.  Might trigger writeouts.
- *
- * CONTEXT:
- * Does GFP_KERNEL allocation.
+ * Allocate zero-filled percpu area of @size bytes aligned at @align.  If
+ * @gfp doesn't contain %GFP_KERNEL, the allocation doesn't block and can
+ * be called from any context but is a lot more likely to fail.
  *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
  */
+void __percpu *__alloc_percpu_gfp(size_t size, size_t align, gfp_t gfp)
+{
+	return pcpu_alloc(size, align, false, gfp);
+}
+EXPORT_SYMBOL_GPL(__alloc_percpu_gfp);
+
+/**
+ * __alloc_percpu - allocate dynamic percpu area
+ * @size: size of area to allocate in bytes
+ * @align: alignment of area (max PAGE_SIZE)
+ *
+ * Equivalent to __alloc_percpu_gfp(size, align, %GFP_KERNEL).
+ */
 void __percpu *__alloc_percpu(size_t size, size_t align)
 {
-	return pcpu_alloc(size, align, false);
+	return pcpu_alloc(size, align, false, GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(__alloc_percpu);
 
@@ -932,7 +946,7 @@ EXPORT_SYMBOL_GPL(__alloc_percpu);
  */
 void __percpu *__alloc_reserved_percpu(size_t size, size_t align)
 {
-	return pcpu_alloc(size, align, true);
+	return pcpu_alloc(size, align, true, GFP_KERNEL);
 }
 
 /**
-- 
1.9.3

