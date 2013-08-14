Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200Ab3HNU3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:29:25 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:65528 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab3HNU3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:29:24 -0400
Message-ID: <201308142029.r7EKTMRw023404@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 14 Aug 2013 16:22:18 -0400
In-Reply-To: <20130814200748.GI28628@htj.dyndns.org>
Subject: [PATCH v8] mm: make lru_add_drain_all() selective
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes lru_add_drain_all() only selectively interrupt
the cpus that have per-cpu free pages that can be drained.

This is important in nohz mode where calling mlockall(), for
example, otherwise will interrupt every core unnecessarily.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
v8: Here's an actual git patch after Tejun's review.
Pull everything inline into lru_add_drain_all(), and use
a mutex plus build-time allocated work_structs to avoid allocation.

v7: try a version with callbacks instead of cpu masks.
Either this or v6 seem like reasonable solutions.

v6: add Tejun's Acked-by, and add missing get/put_cpu_online to
lru_add_drain_all().

v5: provide validity checking on the cpumask for schedule_on_cpu_mask.
By providing an all-or-nothing EINVAL check, we impose the requirement
that the calling code actually know clearly what it's trying to do.
(Note: no change to the mm/swap.c commit)

v4: don't lose possible -ENOMEM in schedule_on_each_cpu()
(Note: no change to the mm/swap.c commit)

v3: split commit into two, one for workqueue and one for mm, though both
should probably be taken through -mm.

 include/linux/swap.h |  2 +-
 mm/swap.c            | 44 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index d95cde5..acea8e0 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -247,7 +247,7 @@ extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
-extern int lru_add_drain_all(void);
+extern void lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_page(struct page *page);
 extern void swap_setup(void);
diff --git a/mm/swap.c b/mm/swap.c
index 4a1d0d2..8d19543 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -405,6 +405,11 @@ static void activate_page_drain(int cpu)
 		pagevec_lru_move_fn(pvec, __activate_page, NULL);
 }
 
+static bool need_activate_page_drain(int cpu)
+{
+	return pagevec_count(&per_cpu(activate_page_pvecs, cpu)) != 0;
+}
+
 void activate_page(struct page *page)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
@@ -422,6 +427,11 @@ static inline void activate_page_drain(int cpu)
 {
 }
 
+static bool need_activate_page_drain(int cpu)
+{
+	return false;
+}
+
 void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
@@ -678,12 +688,36 @@ static void lru_add_drain_per_cpu(struct work_struct *dummy)
 	lru_add_drain();
 }
 
-/*
- * Returns 0 for success
- */
-int lru_add_drain_all(void)
+static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
+
+void lru_add_drain_all(void)
 {
-	return schedule_on_each_cpu(lru_add_drain_per_cpu);
+	static DEFINE_MUTEX(lock);
+	static struct cpumask has_work;
+	int cpu;
+
+	mutex_lock(&lock);
+	get_online_cpus();
+	cpumask_clear(&has_work);
+
+	for_each_online_cpu(cpu) {
+		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
+
+		if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
+		    pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
+		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
+		    need_activate_page_drain(cpu)) {
+			INIT_WORK(work, lru_add_drain_per_cpu);
+			schedule_work_on(cpu, work);
+			cpumask_set_cpu(cpu, &has_work);
+		}
+	}
+
+	for_each_cpu(cpu, &has_work)
+		flush_work(&per_cpu(lru_add_drain_work, cpu));
+
+	put_online_cpus();
+	mutex_unlock(&lock);
 }
 
 /*
-- 
1.8.3.1

