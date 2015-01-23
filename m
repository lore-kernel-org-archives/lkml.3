Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbbAWSqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:46:08 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54134 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbbAWSqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:46:05 -0500
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/9] perf/x86/intel: Implement LRU monitoring ID allocation for CQM
Date: Fri, 23 Jan 2015 18:45:45 +0000
Message-Id: <1422038748-21397-7-git-send-email-matt@codeblueprint.co.uk>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
References: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

It's possible to run into issues with re-using unused monitoring IDs
because there may be stale cachelines associated with that ID from a
previous allocation. This can cause the LLC occupancy values to be
inaccurate.

To attempt to mitigate this problem we place the IDs on a least recently
used list, essentially a FIFO. The basic idea is that the longer the
time period between ID re-use the lower the probability that stale
cachelines exist in the cache.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_cqm.c | 100 ++++++++++++++++++++++++++---
 1 file changed, 92 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_cqm.c b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
index ff00db9e7d20..6a1e0a0c1076 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_cqm.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
@@ -25,7 +25,7 @@ struct intel_cqm_state {
 static DEFINE_PER_CPU(struct intel_cqm_state, cqm_state);
 
 /*
- * Protects cache_cgroups.
+ * Protects cache_cgroups and cqm_rmid_lru.
  */
 static DEFINE_MUTEX(cache_mutex);
 
@@ -64,36 +64,120 @@ static u64 __rmid_read(unsigned long rmid)
 	return val;
 }
 
-static unsigned long *cqm_rmid_bitmap;
+struct cqm_rmid_entry {
+	u64 rmid;
+	struct list_head list;
+};
+
+/*
+ * A least recently used list of RMIDs.
+ *
+ * Oldest entry at the head, newest (most recently used) entry at the
+ * tail. This list is never traversed, it's only used to keep track of
+ * the lru order. That is, we only pick entries of the head or insert
+ * them on the tail.
+ *
+ * All entries on the list are 'free', and their RMIDs are not currently
+ * in use. To mark an RMID as in use, remove its entry from the lru
+ * list.
+ *
+ * This list is protected by cache_mutex.
+ */
+static LIST_HEAD(cqm_rmid_lru);
+
+/*
+ * We use a simple array of pointers so that we can lookup a struct
+ * cqm_rmid_entry in O(1). This alleviates the callers of __get_rmid()
+ * and __put_rmid() from having to worry about dealing with struct
+ * cqm_rmid_entry - they just deal with rmids, i.e. integers.
+ *
+ * Once this array is initialized it is read-only. No locks are required
+ * to access it.
+ *
+ * All entries for all RMIDs can be looked up in the this array at all
+ * times.
+ */
+static struct cqm_rmid_entry **cqm_rmid_ptrs;
+
+static inline struct cqm_rmid_entry *__rmid_entry(int rmid)
+{
+	struct cqm_rmid_entry *entry;
+
+	entry = cqm_rmid_ptrs[rmid];
+	WARN_ON(entry->rmid != rmid);
+
+	return entry;
+}
 
 /*
  * Returns < 0 on fail.
+ *
+ * We expect to be called with cache_mutex held.
  */
 static int __get_rmid(void)
 {
-	return bitmap_find_free_region(cqm_rmid_bitmap, cqm_max_rmid, 0);
+	struct cqm_rmid_entry *entry;
+
+	lockdep_assert_held(&cache_mutex);
+
+	if (list_empty(&cqm_rmid_lru))
+		return -EAGAIN;
+
+	entry = list_first_entry(&cqm_rmid_lru, struct cqm_rmid_entry, list);
+	list_del(&entry->list);
+
+	return entry->rmid;
 }
 
 static void __put_rmid(int rmid)
 {
-	bitmap_release_region(cqm_rmid_bitmap, rmid, 0);
+	struct cqm_rmid_entry *entry;
+
+	lockdep_assert_held(&cache_mutex);
+
+	entry = __rmid_entry(rmid);
+
+	list_add_tail(&entry->list, &cqm_rmid_lru);
 }
 
 static int intel_cqm_setup_rmid_cache(void)
 {
-	cqm_rmid_bitmap = kmalloc(sizeof(long) * BITS_TO_LONGS(cqm_max_rmid), GFP_KERNEL);
-	if (!cqm_rmid_bitmap)
+	struct cqm_rmid_entry *entry;
+	int r;
+
+	cqm_rmid_ptrs = kmalloc(sizeof(struct cqm_rmid_entry *) *
+				(cqm_max_rmid + 1), GFP_KERNEL);
+	if (!cqm_rmid_ptrs)
 		return -ENOMEM;
 
-	bitmap_zero(cqm_rmid_bitmap, cqm_max_rmid);
+	for (r = 0; r <= cqm_max_rmid; r++) {
+		struct cqm_rmid_entry *entry;
+
+		entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry)
+			goto fail;
+
+		INIT_LIST_HEAD(&entry->list);
+		entry->rmid = r;
+		cqm_rmid_ptrs[r] = entry;
+
+		list_add_tail(&entry->list, &cqm_rmid_lru);
+	}
 
 	/*
 	 * RMID 0 is special and is always allocated. It's used for all
 	 * tasks that are not monitored.
 	 */
-	bitmap_allocate_region(cqm_rmid_bitmap, 0, 0);
+	entry = __rmid_entry(0);
+	list_del(&entry->list);
 
 	return 0;
+fail:
+	while (r--)
+		kfree(cqm_rmid_ptrs[r]);
+
+	kfree(cqm_rmid_ptrs);
+	return -ENOMEM;
 }
 
 /*
-- 
1.9.3

