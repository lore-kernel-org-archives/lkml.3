Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbaHVQy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:54:29 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43651 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaHVQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:51 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/15] percpu: implement asynchronous chunk population
Date: Fri, 22 Aug 2014 12:53:19 -0400
Message-Id: <1408726399-4436-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu allocator now supports atomic allocations by only
allocating from already populated areas but the mechanism to ensure
that there's adequate amount of populated areas was missing.

This patch expands pcpu_balance_work so that in addition to freeing
excess free chunks it also populates chunks to maintain an adequate
level of populated areas.  pcpu_alloc() schedules pcpu_balance_work if
the amount of free populated areas is too low or after an atomic
allocation failure.

* PERPCU_DYNAMIC_RESERVE is increased by two pages to account for
  PCPU_EMPTY_POP_PAGES_LOW.

* pcpu_async_enabled is added to gate both async jobs -
  chunk->map_extend_work and pcpu_balance_work - so that we don't end
  up scheduling them while the needed subsystems aren't up yet.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h |   4 +-
 mm/percpu.c            | 117 +++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index d1b416d..a3aa63e 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -48,9 +48,9 @@
  * intelligent way to determine this would be nice.
  */
 #if BITS_PER_LONG > 32
-#define PERCPU_DYNAMIC_RESERVE		(20 << 10)
+#define PERCPU_DYNAMIC_RESERVE		(28 << 10)
 #else
-#define PERCPU_DYNAMIC_RESERVE		(12 << 10)
+#define PERCPU_DYNAMIC_RESERVE		(20 << 10)
 #endif
 
 extern void *pcpu_base_addr;
diff --git a/mm/percpu.c b/mm/percpu.c
index ddb8f58..176bf04 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -78,6 +78,8 @@
 #define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */
 #define PCPU_ATOMIC_MAP_MARGIN_LOW	32
 #define PCPU_ATOMIC_MAP_MARGIN_HIGH	64
+#define PCPU_EMPTY_POP_PAGES_LOW	2
+#define PCPU_EMPTY_POP_PAGES_HIGH	4
 
 #ifdef CONFIG_SMP
 /* default addr <-> pcpu_ptr mapping, override in asm/percpu.h if necessary */
@@ -168,9 +170,22 @@ static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
  */
 static int pcpu_nr_empty_pop_pages;
 
-/* balance work is used to populate or destroy chunks asynchronously */
+/*
+ * Balance work is used to populate or destroy chunks asynchronously.  We
+ * try to keep the number of populated free pages between
+ * PCPU_EMPTY_POP_PAGES_LOW and HIGH for atomic allocations and at most one
+ * empty chunk.
+ */
 static void pcpu_balance_workfn(struct work_struct *work);
 static DECLARE_WORK(pcpu_balance_work, pcpu_balance_workfn);
+static bool pcpu_async_enabled __read_mostly;
+static bool pcpu_atomic_alloc_failed;
+
+static void pcpu_schedule_balance_work(void)
+{
+	if (pcpu_async_enabled)
+		schedule_work(&pcpu_balance_work);
+}
 
 static bool pcpu_addr_in_first_chunk(void *addr)
 {
@@ -386,7 +401,8 @@ static int pcpu_need_to_extend(struct pcpu_chunk *chunk, bool is_atomic)
 		margin = 3;
 
 		if (chunk->map_alloc <
-		    chunk->map_used + PCPU_ATOMIC_MAP_MARGIN_LOW)
+		    chunk->map_used + PCPU_ATOMIC_MAP_MARGIN_LOW &&
+		    pcpu_async_enabled)
 			schedule_work(&chunk->map_extend_work);
 	} else {
 		margin = PCPU_ATOMIC_MAP_MARGIN_HIGH;
@@ -1005,6 +1021,9 @@ area_found:
 	if (chunk != pcpu_reserved_chunk)
 		pcpu_nr_empty_pop_pages -= occ_pages;
 
+	if (pcpu_nr_empty_pop_pages < PCPU_EMPTY_POP_PAGES_LOW)
+		pcpu_schedule_balance_work();
+
 	/* clear the areas and return address relative to base address */
 	for_each_possible_cpu(cpu)
 		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
@@ -1023,6 +1042,11 @@ fail:
 		if (!--warn_limit)
 			pr_info("PERCPU: limit reached, disable warning\n");
 	}
+	if (is_atomic) {
+		/* see the flag handling in pcpu_blance_workfn() */
+		pcpu_atomic_alloc_failed = true;
+		pcpu_schedule_balance_work();
+	}
 	return NULL;
 }
 
@@ -1080,7 +1104,7 @@ void __percpu *__alloc_reserved_percpu(size_t size, size_t align)
 }
 
 /**
- * pcpu_balance_workfn - reclaim fully free chunks, workqueue function
+ * pcpu_balance_workfn - manage the amount of free chunks and populated pages
  * @work: unused
  *
  * Reclaim all fully free chunks except for the first one.
@@ -1090,7 +1114,12 @@ static void pcpu_balance_workfn(struct work_struct *work)
 	LIST_HEAD(to_free);
 	struct list_head *free_head = &pcpu_slot[pcpu_nr_slots - 1];
 	struct pcpu_chunk *chunk, *next;
+	int slot, nr_to_pop, ret;
 
+	/*
+	 * There's no reason to keep around multiple unused chunks and VM
+	 * areas can be scarce.  Destroy all free chunks except for one.
+	 */
 	mutex_lock(&pcpu_alloc_mutex);
 	spin_lock_irq(&pcpu_lock);
 
@@ -1118,6 +1147,74 @@ static void pcpu_balance_workfn(struct work_struct *work)
 		pcpu_destroy_chunk(chunk);
 	}
 
+	/*
+	 * Ensure there are certain number of free populated pages for
+	 * atomic allocs.  Fill up from the most packed so that atomic
+	 * allocs don't increase fragmentation.  If atomic allocation
+	 * failed previously, always populate the maximum amount.  This
+	 * should prevent atomic allocs larger than PAGE_SIZE from keeping
+	 * failing indefinitely; however, large atomic allocs are not
+	 * something we support properly and can be highly unreliable and
+	 * inefficient.
+	 */
+retry_pop:
+	if (pcpu_atomic_alloc_failed) {
+		nr_to_pop = PCPU_EMPTY_POP_PAGES_HIGH;
+		/* best effort anyway, don't worry about synchronization */
+		pcpu_atomic_alloc_failed = false;
+	} else {
+		nr_to_pop = clamp(PCPU_EMPTY_POP_PAGES_HIGH -
+				  pcpu_nr_empty_pop_pages,
+				  0, PCPU_EMPTY_POP_PAGES_HIGH);
+	}
+
+	for (slot = pcpu_size_to_slot(PAGE_SIZE); slot < pcpu_nr_slots; slot++) {
+		int nr_unpop = 0, rs, re;
+
+		if (!nr_to_pop)
+			break;
+
+		spin_lock_irq(&pcpu_lock);
+		list_for_each_entry(chunk, &pcpu_slot[slot], list) {
+			nr_unpop = pcpu_unit_pages - chunk->nr_populated;
+			if (nr_unpop)
+				break;
+		}
+		spin_unlock_irq(&pcpu_lock);
+
+		if (!nr_unpop)
+			continue;
+
+		/* @chunk can't go away while pcpu_alloc_mutex is held */
+		pcpu_for_each_unpop_region(chunk, rs, re, 0, pcpu_unit_pages) {
+			int nr = min(re - rs, nr_to_pop);
+
+			ret = pcpu_populate_chunk(chunk, rs, rs + nr);
+			if (!ret) {
+				nr_to_pop -= nr;
+				spin_lock_irq(&pcpu_lock);
+				pcpu_chunk_populated(chunk, rs, rs + nr);
+				spin_unlock_irq(&pcpu_lock);
+			} else {
+				nr_to_pop = 0;
+			}
+
+			if (!nr_to_pop)
+				break;
+		}
+	}
+
+	if (nr_to_pop) {
+		/* ran out of chunks to populate, create a new one and retry */
+		chunk = pcpu_create_chunk();
+		if (chunk) {
+			spin_lock_irq(&pcpu_lock);
+			pcpu_chunk_relocate(chunk, -1);
+			spin_unlock_irq(&pcpu_lock);
+			goto retry_pop;
+		}
+	}
+
 	mutex_unlock(&pcpu_alloc_mutex);
 }
 
@@ -1160,7 +1257,7 @@ void free_percpu(void __percpu *ptr)
 
 		list_for_each_entry(pos, &pcpu_slot[pcpu_nr_slots - 1], list)
 			if (pos != chunk) {
-				schedule_work(&pcpu_balance_work);
+				pcpu_schedule_balance_work();
 				break;
 			}
 	}
@@ -2185,3 +2282,15 @@ void __init percpu_init_late(void)
 		spin_unlock_irqrestore(&pcpu_lock, flags);
 	}
 }
+
+/*
+ * Percpu allocator is initialized early during boot when neither slab or
+ * workqueue is available.  Plug async management until everything is up
+ * and running.
+ */
+static int __init percpu_enable_async(void)
+{
+	pcpu_async_enabled = true;
+	return 0;
+}
+subsys_initcall(percpu_enable_async);
-- 
1.9.3

