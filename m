Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828Ab3GEOTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:19:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933816Ab3GEOS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:18:57 -0400
Date: Fri, 5 Jul 2013 15:18:51 +0100
From: Mel Gorman <mgorman@suse.de>
To: Yannick Brosseau <yannick.brosseau@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dave Chinner <david@fromorbit.com>,
        Rob van der Heij <rvdheij@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>
Subject: Re: [-stable 3.8.1 performance regression] madvise
 POSIX_FADV_DONTNEED
Message-ID: <20130705141851.GW1875@suse.de>
References: <20130618092925.GI1875@suse.de>
 <20130618101147.GA7436@suse.de>
 <20130619192508.GA666@Krystal>
 <CAJCc=kijujORhPUmPvzHj-MMdyVbf-iHEK0Jx-VHbTO8q4ESFA@mail.gmail.com>
 <20130620122016.GA12700@Krystal>
 <20130625015648.GO29376@dastard>
 <20130702135858.GA30837@Krystal>
 <20130703005514.GA17149@Krystal>
 <20130703084715.GF1875@suse.de>
 <51D471DE.3020800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <51D471DE.3020800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 02:47:58PM -0400, Yannick Brosseau wrote:
> On 2013-07-03 04:47, Mel Gorman wrote:
> >> Given it is just a hint, we should be allowed to perform page
> >> > deactivation lazily. Is there any fundamental reason to wait for worker
> >> > threads on each CPU to complete their lru drain before returning from
> >> > fadvise() to user-space ?
> >> > 
> > Only to make sure they pages are actually dropped as requested. The reason
> > the wait was introduced in the first place was that page cache was filling
> > up even with the fadvise calls and causing disruption. In 3.11 disruption
> > due to this sort of parallel IO should be reduced but making fadvise work
> > properly is reasonable in itself. Was that patch I posted ever tested or
> > did I manage to miss it?
>
> I did test it. On our test case, we get a worst result with it.
> 

That's useful to know. Please test the following replacement patch
instead.

---8<---
mm: Only drain CPUs whose pagevecs contain pages backed by a given mapping

cha-cha-cha-changelog

Not-signed-off-by David Bowie
---
 include/linux/swap.h      |  1 +
 include/linux/workqueue.h |  1 +
 kernel/workqueue.c        | 29 +++++++++++++++++++++++------
 mm/fadvise.c              |  2 +-
 mm/swap.c                 | 43 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1701ce4..7625d2a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -242,6 +242,7 @@ extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern int lru_add_drain_all(void);
+extern int lru_add_drain_mapping(struct address_space *mapping);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_page(struct page *page);
 extern void swap_setup(void);
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 623488f..89c97e8 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -435,6 +435,7 @@ extern void drain_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
 
 extern int schedule_on_each_cpu(work_func_t func);
+extern int schedule_on_cpumask(work_func_t func, const cpumask_t *mask);
 
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ee8e29a..c359e30 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2949,17 +2949,18 @@ bool cancel_delayed_work_sync(struct delayed_work *dwork)
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
 /**
- * schedule_on_each_cpu - execute a function synchronously on each online CPU
+ * schedule_on_cpumask - execute a function synchronously on each online CPU
  * @func: the function to call
+ * @mask: the cpumask of CPUs to execute the function on
  *
- * schedule_on_each_cpu() executes @func on each online CPU using the
+ * schedule_on_each_cpu() executes @func on each CPU specified in the mask the
  * system workqueue and blocks until all CPUs have completed.
- * schedule_on_each_cpu() is very slow.
+ * schedule_on_cpumask() is potentially very slow.
  *
  * RETURNS:
  * 0 on success, -errno on failure.
  */
-int schedule_on_each_cpu(work_func_t func)
+int schedule_on_cpumask(work_func_t func, const cpumask_t *mask)
 {
 	int cpu;
 	struct work_struct __percpu *works;
@@ -2970,14 +2971,14 @@ int schedule_on_each_cpu(work_func_t func)
 
 	get_online_cpus();
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu_mask(cpu, *mask) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
 		INIT_WORK(work, func);
 		schedule_work_on(cpu, work);
 	}
 
-	for_each_online_cpu(cpu)
+	for_each_cpu_mask(cpu, *mask)
 		flush_work(per_cpu_ptr(works, cpu));
 
 	put_online_cpus();
@@ -2986,6 +2987,22 @@ int schedule_on_each_cpu(work_func_t func)
 }
 
 /**
+ * schedule_on_each_cpu - execute a function synchronously on each online CPU
+ * @func: the function to call
+ *
+ * schedule_on_each_cpu() executes @func on each online CPU using the
+ * system workqueue and blocks until all CPUs have completed.
+ * schedule_on_each_cpu() is very slow.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int schedule_on_each_cpu(work_func_t func)
+{
+	return schedule_on_cpumask(func, cpu_online_mask);
+}
+
+/**
  * flush_scheduled_work - ensure that any scheduled work has run to completion.
  *
  * Forces execution of the kernel-global workqueue and blocks until its
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 3bcfd81..70c4a3d 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -132,7 +132,7 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 			 * pagevecs and try again.
 			 */
 			if (count < (end_index - start_index + 1)) {
-				lru_add_drain_all();
+				lru_add_drain_mapping(mapping);
 				invalidate_mapping_pages(mapping, start_index,
 						end_index);
 			}
diff --git a/mm/swap.c b/mm/swap.c
index dfd7d71..97de395 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -656,6 +656,49 @@ int lru_add_drain_all(void)
 }
 
 /*
+ * Drains LRU of some CPUs but only if the associated CPUs pagevec contain
+ * pages managed by the given mapping. This is racy and there is no guarantee
+ * that when it returns that there will still not be pages belonging to the
+ * mapping on a pagevec.
+ */
+int lru_add_drain_mapping(struct address_space *mapping)
+{
+	static cpumask_t pagevec_cpus;
+	int cpu;
+
+	cpumask_clear(&pagevec_cpus);
+
+	/*
+	 * get_online_cpus unnecessary as pagevecs persist after hotplug.
+	 * Count may change underneath us but at worst some pages are
+	 * missed or there is the occasional false positive.
+	 */
+	for_each_online_cpu(cpu) {
+		struct pagevec *pvecs = per_cpu(lru_add_pvecs, cpu);
+		struct pagevec *pvec;
+		int lru;
+
+		for_each_lru(lru) {
+			int i;
+			pvec = &pvecs[lru - LRU_BASE];
+
+			for (i = 0; i < pagevec_count(pvec); i++) {
+				struct page *page = pvec->pages[i];
+
+				if (page->mapping == mapping) {
+					cpumask_set_cpu(cpu, &pagevec_cpus);
+					goto next_cpu;
+				}
+			}
+		}
+next_cpu:
+		;
+	}
+
+	return schedule_on_cpumask(lru_add_drain_per_cpu, &pagevec_cpus);
+}
+
+/*
  * Batched page_cache_release().  Decrement the reference count on all the
  * passed pages.  If it fell to zero then remove the page from the LRU and
  * free it.
