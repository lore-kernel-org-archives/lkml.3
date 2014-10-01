Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaJAOhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:37:03 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44368 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbaJAOhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:37:00 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 11/11] perf/x86/intel: Perform rotation on Intel CQM RMIDs
Date: Wed,  1 Oct 2014 15:36:32 +0100
Message-Id: <1412174192-7010-12-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

There are many use cases where people will want to monitor more tasks
than there exist RMIDs in the hardware, meaning that we have to perform
some kind of multiplexing.

We do this by "rotating" the RMIDs in a workqueue, and assigning an RMID
to a waiting event when the RMID becomes unused.

This scheme reserves one RMID at all times for rotation. When we need to
schedule a new event we give it the reserved RMID, pick a victim event
from the front of the global CQM list and wait for the victim's RMID to
drop to zero occupancy, before it becomes the new reserved RMID.

The comments above __intel_cqm_rmid_rotate() have more details.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_cqm.c | 475 +++++++++++++++++++++++++++--
 1 file changed, 447 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_cqm.c b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
index d1b11d2dc3cc..abbbba605b61 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_cqm.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
@@ -25,9 +25,13 @@ struct intel_cqm_state {
 static DEFINE_PER_CPU(struct intel_cqm_state, cqm_state);
 
 /*
- * Protects cache_cgroups and cqm_rmid_lru.
+ * Protects cache_cgroups and cqm_rmid_free_lru and cqm_rmid_limbo_lru.
+ * Also protects event->hw.cqm_rmid
+ *
+ * Hold either for stability, both for modification.
  */
 static DEFINE_MUTEX(cache_mutex);
+static DEFINE_RAW_SPINLOCK(cache_lock);
 
 /*
  * Groups of events that have the same target(s), one RMID per group.
@@ -46,7 +50,34 @@ static cpumask_t cqm_cpumask;
 
 #define QOS_EVENT_MASK	QOS_L3_OCCUP_EVENT_ID
 
-static u64 __rmid_read(unsigned long rmid)
+/*
+ * This is central to the rotation algorithm in __intel_cqm_rmid_rotate().
+ *
+ * This rmid is always free and is guaranteed to have an associated
+ * near-zero occupancy value, i.e. no cachelines are tagged with this
+ * RMID, once __intel_cqm_rmid_rotate() returns.
+ */
+static unsigned int intel_cqm_rotation_rmid;
+
+#define INVALID_RMID		(-1)
+
+/*
+ * Is @rmid valid for programming the hardware?
+ *
+ * rmid 0 is reserved by the hardware for all non-monitored tasks, which
+ * means that we should never come across an rmid with that value.
+ * Likewise, an rmid value of -1 is used to indicate "no rmid currently
+ * assigned" and is used as part of the rotation code.
+ */
+static inline bool __rmid_valid(unsigned int rmid)
+{
+	if (!rmid || rmid == INVALID_RMID)
+		return false;
+
+	return true;
+}
+
+static u64 __rmid_read(unsigned int rmid)
 {
 	u64 val;
 
@@ -65,12 +96,12 @@ static u64 __rmid_read(unsigned long rmid)
 }
 
 struct cqm_rmid_entry {
-	u64 rmid;
+	unsigned int rmid;
 	struct list_head list;
 };
 
 /*
- * A least recently used list of RMIDs.
+ * cqm_rmid_free_lru - A least recently used list of RMIDs.
  *
  * Oldest entry at the head, newest (most recently used) entry at the
  * tail. This list is never traversed, it's only used to keep track of
@@ -81,9 +112,18 @@ struct cqm_rmid_entry {
  * in use. To mark an RMID as in use, remove its entry from the lru
  * list.
  *
- * This list is protected by cache_mutex.
+ *
+ * cqm_rmid_limbo_lru - list of currently unused but (potentially) dirty RMIDs.
+ *
+ * This list is contains RMIDs that no one is currently using but that
+ * may have a non-zero occupancy value associated with them. The
+ * rotation worker moves RMIDs from the limbo list to the free list once
+ * the occupancy value drops below __intel_cqm_threshold.
+ *
+ * Both lists are protected by cache_mutex.
  */
-static LIST_HEAD(cqm_rmid_lru);
+static LIST_HEAD(cqm_rmid_free_lru);
+static LIST_HEAD(cqm_rmid_limbo_lru);
 
 /*
  * We use a simple array of pointers so that we can lookup a struct
@@ -120,24 +160,25 @@ static int __get_rmid(void)
 
 	lockdep_assert_held(&cache_mutex);
 
-	if (list_empty(&cqm_rmid_lru))
-		return -EAGAIN;
+	if (list_empty(&cqm_rmid_free_lru))
+		return INVALID_RMID;
 
-	entry = list_first_entry(&cqm_rmid_lru, struct cqm_rmid_entry, list);
+	entry = list_first_entry(&cqm_rmid_free_lru, struct cqm_rmid_entry, list);
 	list_del(&entry->list);
 
 	return entry->rmid;
 }
 
-static void __put_rmid(int rmid)
+static void __put_rmid(unsigned int rmid)
 {
 	struct cqm_rmid_entry *entry;
 
 	lockdep_assert_held(&cache_mutex);
 
+	WARN_ON(!__rmid_valid(rmid));
 	entry = __rmid_entry(rmid);
 
-	list_add_tail(&entry->list, &cqm_rmid_lru);
+	list_add_tail(&entry->list, &cqm_rmid_limbo_lru);
 }
 
 static int intel_cqm_setup_rmid_cache(void)
@@ -161,7 +202,7 @@ static int intel_cqm_setup_rmid_cache(void)
 		entry->rmid = r;
 		cqm_rmid_ptrs[r] = entry;
 
-		list_add_tail(&entry->list, &cqm_rmid_lru);
+		list_add_tail(&entry->list, &cqm_rmid_free_lru);
 	}
 
 	/*
@@ -171,6 +212,10 @@ static int intel_cqm_setup_rmid_cache(void)
 	entry = __rmid_entry(0);
 	list_del(&entry->list);
 
+	mutex_lock(&cache_mutex);
+	intel_cqm_rotation_rmid = __get_rmid();
+	mutex_unlock(&cache_mutex);
+
 	return 0;
 fail:
 	while (r--)
@@ -314,6 +359,345 @@ static bool __conflict_event(struct perf_event *a, struct perf_event *b)
 }
 
 /*
+ * Exchange the RMID of a group of events.
+ */
+static unsigned int
+intel_cqm_xchg_rmid(struct perf_event *group, unsigned int rmid)
+{
+	struct perf_event *event;
+	unsigned int old_rmid = group->hw.cqm_rmid;
+	struct list_head *head = &group->hw.cqm_group_entry;
+
+	lockdep_assert_held(&cache_mutex);
+	lockdep_assert_held(&cache_lock);
+
+	group->hw.cqm_rmid = rmid;
+	list_for_each_entry(event, head, hw.cqm_group_entry)
+		event->hw.cqm_rmid = rmid;
+
+	return old_rmid;
+}
+
+/*
+ * If we fail to assign a new RMID for intel_cqm_rotation_rmid because
+ * cachelines are still tagged with RMIDs in limbo, we progressively
+ * increment the threshold until we find an RMID in limbo with <=
+ * __intel_cqm_threshold lines tagged. This is designed to mitigate the
+ * problem where cachelines tagged with an RMID are not steadily being
+ * evicted.
+ *
+ * On successful rotations we decrease the threshold back towards zero.
+ */
+static unsigned int __intel_cqm_threshold;
+
+struct intel_cqm_smp_info {
+	unsigned long *bitmap;	/* index by cpu num */
+	unsigned int nr_bits;
+};
+
+/*
+ * Test whether an RMID has a zero occupancy value on this cpu.
+ */
+static void intel_cqm_stable(void *arg)
+{
+	struct intel_cqm_smp_info *info = arg;
+	unsigned long *bitmap;
+	unsigned int nr_bits;
+	unsigned int cpu;
+	int i = -1;
+
+	nr_bits = info->nr_bits;
+	cpu = smp_processor_id();
+	bitmap = &info->bitmap[cpu * BITS_TO_LONGS(nr_bits)];
+
+	for (; i = find_next_bit(bitmap, nr_bits, i+1), i < nr_bits;) {
+		if (__rmid_read(i) > __intel_cqm_threshold)
+			clear_bit(i, bitmap);
+	}
+}
+
+/*
+ * Quiescent state; wait for all 'freed' RMIDs to become unused, i.e. no
+ * cachelines are tagged with those RMIDs. After this we can reuse them
+ * and know that the current set of active RMIDs is stable.
+ *
+ * Return %true or %false depending on whether we were able to stabilize
+ * an RMID for intel_cqm_rotation_rmid.
+ */
+static bool intel_cqm_rmid_stabilize(void)
+{
+	struct cqm_rmid_entry *entry;
+	struct intel_cqm_smp_info info;
+	unsigned long *limbo_bitmap;
+	unsigned long *free_bitmap;
+	unsigned int nr_bits, cpu;
+	struct perf_event *event;
+	unsigned long timeout;
+
+	lockdep_assert_held(&cache_mutex);
+
+	timeout = jiffies + msecs_to_jiffies(50);
+
+	nr_bits = cqm_max_rmid + 1;
+	limbo_bitmap = kmalloc(sizeof(long) * BITS_TO_LONGS(nr_bits) *
+			       nr_cpumask_bits, GFP_KERNEL);
+	if (!limbo_bitmap)
+		return false;
+
+	free_bitmap = kmalloc(sizeof(long) * BITS_TO_LONGS(nr_bits), GFP_KERNEL);
+	if (!free_bitmap) {
+		kfree(limbo_bitmap);
+		return false;
+	}
+
+	info.nr_bits = nr_bits;
+	info.bitmap = limbo_bitmap;
+
+retry:
+	bitmap_zero(limbo_bitmap, nr_bits * nr_cpumask_bits);
+
+	preempt_disable();
+	list_for_each_entry(entry, &cqm_rmid_limbo_lru, list) {
+		for_each_cpu(cpu, &cqm_cpumask) {
+			unsigned long *map;
+
+			map = &limbo_bitmap[cpu * BITS_TO_LONGS(nr_bits)];
+			set_bit(entry->rmid, map);
+		}
+	}
+
+	/*
+	 * Test whether an RMID is free for each package.
+	 */
+	smp_call_function_many(&cqm_cpumask, intel_cqm_stable, &info, true);
+
+	/*
+	 * Convert all cpu bitmaps into a single bitmap by ANDing all of
+	 * them together. If we've still got any bits set that indicates
+	 * an RMID is now unused on all cpus.
+	 */
+	bitmap_fill(free_bitmap, nr_bits);
+	for_each_cpu(cpu, &cqm_cpumask) {
+		unsigned long *map;
+
+		map = &limbo_bitmap[cpu * BITS_TO_LONGS(nr_bits)];
+		bitmap_and(free_bitmap, free_bitmap, map, nr_bits);
+	}
+
+	if (!bitmap_empty(free_bitmap, nr_bits)) {
+		int i = -1;
+
+		for (; i = find_next_bit(free_bitmap, nr_bits, i+1),
+			i < nr_bits;) {
+			entry = __rmid_entry(i);
+
+			list_del(&entry->list);	/* remove from limbo */
+
+			/*
+			 * The rotation RMID gets priority if it's
+			 * currently invalid. In which case, skip adding
+			 * the RMID to the the free lru.
+			 */
+			if (!__rmid_valid(intel_cqm_rotation_rmid)) {
+				intel_cqm_rotation_rmid = i;
+				continue;
+			}
+
+			/*
+			 * If we have groups waiting for RMIDs, hand
+			 * them one now.
+			 */
+			raw_spin_lock_irq(&cache_lock);
+			list_for_each_entry(event, &cache_groups,
+					    hw.cqm_groups_entry) {
+				if (__rmid_valid(event->hw.cqm_rmid))
+					continue;
+
+				intel_cqm_xchg_rmid(event, i);
+				entry = NULL;
+				break;
+			}
+			raw_spin_unlock_irq(&cache_lock);
+
+			if (!entry)
+				continue;
+
+			/*
+			 * Otherwise place it onto the free list.
+			 */
+			list_add_tail(&entry->list, &cqm_rmid_free_lru);
+		}
+	}
+
+	preempt_enable();
+
+	if (!__rmid_valid(intel_cqm_rotation_rmid)) {
+		schedule_timeout_interruptible(1);
+
+		if (time_before(jiffies, timeout))
+			goto retry;
+	}
+
+	kfree(free_bitmap);
+	kfree(limbo_bitmap);
+
+	return __rmid_valid(intel_cqm_rotation_rmid);
+}
+
+/*
+ * Pick a victim group and move it to the tail of the group list.
+ */
+static struct perf_event *
+__intel_cqm_pick_and_rotate(void)
+{
+	struct perf_event *rotor;
+
+	lockdep_assert_held(&cache_mutex);
+	lockdep_assert_held(&cache_lock);
+
+	rotor = list_first_entry(&cache_groups, struct perf_event,
+				 hw.cqm_groups_entry);
+	list_rotate_left(&cache_groups);
+
+	return rotor;
+}
+
+/*
+ * Attempt to rotate the groups and assign new RMIDs.
+ *
+ * Rotating RMIDs is complicated because the hardware doesn't give us
+ * any clues.
+ *
+ * There's problems with the hardware interface; when you change the
+ * task:RMID map cachelines retain their 'old' tags, giving a skewed
+ * picture. In order to work around this, we must always keep one free
+ * RMID - intel_cqm_rotation_rmid.
+ *
+ * Rotation works by taking away an RMID from a group (the old RMID),
+ * and assigning the free RMID to another group (the new RMID). We must
+ * then wait for the old RMID to not be used (no cachelines tagged).
+ * This ensure that all cachelines are tagged with 'active' RMIDs. At
+ * this point we can start reading values for the new RMID and treat the
+ * old RMID as the free RMID for the next rotation.
+ *
+ * Return %true or %false depending on whether we did any rotating.
+ */
+static bool __intel_cqm_rmid_rotate(void)
+{
+	struct perf_event *group, *rotor, *start = NULL;
+	struct cqm_rmid_entry *entry;
+	unsigned int nr_needed = 0;
+	unsigned int rmid;
+	bool rotated = false;
+
+	mutex_lock(&cache_mutex);
+
+again:
+	/*
+	 * Fast path through this function if there are no groups and no
+	 * RMIDs that need cleaning.
+	 */
+	if (list_empty(&cache_groups) && list_empty(&cqm_rmid_limbo_lru))
+		goto out;
+
+	list_for_each_entry(group, &cache_groups, hw.cqm_groups_entry) {
+		if (!__rmid_valid(group->hw.cqm_rmid)) {
+			if (!start)
+				start = group;
+			nr_needed++;
+		}
+	}
+
+	/*
+	 * We have some event groups, but they all have RMIDs assigned
+	 * and no RMIDs need cleaning.
+	 */
+	if (!nr_needed && list_empty(&cqm_rmid_limbo_lru))
+		goto out;
+
+	if (!nr_needed)
+		goto stabilize;
+
+	/*
+	 * We have more event groups without RMIDs than available RMIDs.
+	 *
+	 * We force deallocate the rmid of the group at the head of
+	 * cache_groups. The first event group without an RMID then gets
+	 * assigned intel_cqm_rotation_rmid. This ensures we always make
+	 * forward progress.
+	 *
+	 * Rotate the cache_groups list so the previous head is now the
+	 * tail.
+	 */
+	raw_spin_lock_irq(&cache_lock);
+
+	rotor = __intel_cqm_pick_and_rotate();
+	rmid = intel_cqm_xchg_rmid(rotor, INVALID_RMID);
+
+	/*
+	 * The group at the front of the list should always have a valid
+	 * RMID. If it doesn't then no groups have RMIDs assigned.
+	 */
+	if (!__rmid_valid(rmid)) {
+		raw_spin_unlock_irq(&cache_lock);
+		goto stabilize;
+	}
+
+	/*
+	 * If the rotation is going to succeed, reduce the threshold so
+	 * that we don't needlessly reuse dirty RMIDs.
+	 */
+	if (__rmid_valid(intel_cqm_rotation_rmid)) {
+		intel_cqm_xchg_rmid(start, intel_cqm_rotation_rmid);
+		intel_cqm_rotation_rmid = INVALID_RMID;
+
+		if (__intel_cqm_threshold)
+			__intel_cqm_threshold--;
+	}
+
+	entry = __rmid_entry(rmid);
+	list_add_tail(&entry->list, &cqm_rmid_limbo_lru);
+
+	raw_spin_unlock_irq(&cache_lock);
+
+	rotated = true;
+
+stabilize:
+	/*
+	 * We now need to stablize the RMID we freed above (if any) to
+	 * ensure that the next time we rotate we have an RMID with zero
+	 * occupancy value.
+	 *
+	 * Alternatively, if we didn't need to perform any rotation,
+	 * we'll have a bunch of RMIDs in limbo that need stabilizing.
+	 */
+	if (!intel_cqm_rmid_stabilize()) {
+		__intel_cqm_threshold++;
+		goto again;
+	}
+
+	WARN_ON(!__rmid_valid(intel_cqm_rotation_rmid));
+
+out:
+	mutex_unlock(&cache_mutex);
+	return rotated;
+}
+
+static void intel_cqm_rmid_rotate(struct work_struct *work);
+
+static DECLARE_DELAYED_WORK(intel_cqm_rmid_work, intel_cqm_rmid_rotate);
+
+static unsigned int __rotation_period = 250; /* ms */
+
+static void intel_cqm_rmid_rotate(struct work_struct *work)
+{
+	__intel_cqm_rmid_rotate();
+
+	schedule_delayed_work(&intel_cqm_rmid_work,
+			      msecs_to_jiffies(__rotation_period));
+}
+
+/*
  * Find a group and setup RMID.
  *
  * If we're part of a group, we use the group's RMID.
@@ -322,7 +706,6 @@ static int intel_cqm_setup_event(struct perf_event *event,
 				 struct perf_event **group, int cpu)
 {
 	struct perf_event *iter;
-	int rmid;
 
 	list_for_each_entry(iter, &cache_groups, hw.cqm_groups_entry) {
 		if (__match_event(iter, event)) {
@@ -336,17 +719,14 @@ static int intel_cqm_setup_event(struct perf_event *event,
 			return -EBUSY;
 	}
 
-	rmid = __get_rmid();
-	if (rmid < 0)
-		return rmid;
-
-	event->hw.cqm_rmid = rmid;
+	event->hw.cqm_rmid = __get_rmid();
 	return 0;
 }
 
 static void intel_cqm_event_read(struct perf_event *event)
 {
-	unsigned long rmid;
+	unsigned long flags;
+	unsigned int rmid;
 	u64 val;
 
 	/*
@@ -355,14 +735,19 @@ static void intel_cqm_event_read(struct perf_event *event)
 	if (event->cpu == -1)
 		return;
 
+	raw_spin_lock_irqsave(&cache_lock, flags);
 	rmid = event->hw.cqm_rmid;
+
+	if (!__rmid_valid(rmid))
+		goto out;
+
 	val = __rmid_read(rmid);
 
 	/*
 	 * Ignore this reading on error states and do not update the value.
 	 */
 	if (val & (RMID_VAL_ERROR | RMID_VAL_UNAVAIL))
-		return;
+		goto out;
 
 	val *= cqm_l3_scale; /* cachelines -> bytes */
 
@@ -371,21 +756,34 @@ static void intel_cqm_event_read(struct perf_event *event)
 	 * aggregation in the kernel, it's all done in userland.
 	 */
 	local64_set(&event->count, val);
+out:
+	raw_spin_unlock_irqrestore(&cache_lock, flags);
 }
 
 static void __intel_cqm_event_count(void *info)
 {
 	struct perf_event *event = info;
+	unsigned long flags;
+	unsigned int rmid;
 	u64 val;
 
-	val = __rmid_read(event->hw.cqm_rmid);
+	raw_spin_lock_irqsave(&cache_lock, flags);
+
+	rmid = event->hw.cqm_rmid;
+	if (!__rmid_valid(rmid))
+		goto unlock;
+
+	val = __rmid_read(rmid);
 
 	if (val & (RMID_VAL_ERROR | RMID_VAL_UNAVAIL))
-		return;
+		goto unlock;
 
 	val *= cqm_l3_scale; /* cachelines -> bytes */
 
 	local64_add(val, &event->count);
+
+unlock:
+	raw_spin_unlock_irqrestore(&cache_lock, flags);
 }
 
 static inline bool cqm_group_leader(struct perf_event *event)
@@ -430,7 +828,7 @@ static u64 intel_cqm_event_count(struct perf_event *event)
 static void intel_cqm_event_start(struct perf_event *event, int mode)
 {
 	struct intel_cqm_state *state = &__get_cpu_var(cqm_state);
-	unsigned long rmid = event->hw.cqm_rmid;
+	unsigned int rmid = event->hw.cqm_rmid;
 	unsigned long flags;
 
 	if (!(event->hw.cqm_state & PERF_HES_STOPPED))
@@ -476,15 +874,19 @@ static void intel_cqm_event_stop(struct perf_event *event, int mode)
 
 static int intel_cqm_event_add(struct perf_event *event, int mode)
 {
-	int rmid;
+	unsigned long flags;
+	unsigned int rmid;
+
+	raw_spin_lock_irqsave(&cache_lock, flags);
 
 	event->hw.cqm_state = PERF_HES_STOPPED;
 	rmid = event->hw.cqm_rmid;
-	WARN_ON_ONCE(!rmid);
 
-	if (mode & PERF_EF_START)
+	if (__rmid_valid(rmid) && (mode & PERF_EF_START))
 		intel_cqm_event_start(event, mode);
 
+	raw_spin_unlock_irqrestore(&cache_lock, flags);
+
 	return 0;
 }
 
@@ -521,8 +923,10 @@ static void intel_cqm_event_destroy(struct perf_event *event)
 			list_replace(&event->hw.cqm_groups_entry,
 				     &group_other->hw.cqm_groups_entry);
 		} else {
-			int rmid = event->hw.cqm_rmid;
-			__put_rmid(rmid);
+			unsigned int rmid = event->hw.cqm_rmid;
+
+			if (__rmid_valid(rmid))
+				__put_rmid(rmid);
 			list_del(&event->hw.cqm_groups_entry);
 		}
 	}
@@ -535,6 +939,7 @@ static struct pmu intel_cqm_pmu;
 static int intel_cqm_event_init(struct perf_event *event)
 {
 	struct perf_event *group = NULL;
+	bool rotate = false;
 	int err;
 
 	if (event->attr.type != intel_cqm_pmu.type)
@@ -571,10 +976,24 @@ static int intel_cqm_event_init(struct perf_event *event)
 	} else {
 		list_add_tail(&event->hw.cqm_groups_entry,
 			      &cache_groups);
+
+		/*
+		 * All RMIDs are either in use or have recently been
+		 * used. Kick the rotation worker to clean/free some.
+		 *
+		 * We only do this for the group leader, rather than for
+		 * every event in a group to save on needless work.
+		 */
+		if (!__rmid_valid(event->hw.cqm_rmid))
+			rotate = true;
 	}
 
 out:
 	mutex_unlock(&cache_mutex);
+
+	if (rotate)
+		schedule_delayed_work(&intel_cqm_rmid_work, 0);
+
 	return err;
 }
 
-- 
1.9.3

