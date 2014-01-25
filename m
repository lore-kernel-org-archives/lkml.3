Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaAYOZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:25:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52545 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaAYOZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:25:44 -0500
Date: Sat, 25 Jan 2014 06:24:48 -0800
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-ec65993443736a5091b68e80ff1734548944a4b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, hughd@google.com,
        alex.shi@linaro.org, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, hughd@google.com,
        alex.shi@linaro.org, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, davidlohr@hp.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] mm, x86:
  Account for TLB flushes only when debugging
Git-Commit-ID: ec65993443736a5091b68e80ff1734548944a4b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:24:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec65993443736a5091b68e80ff1734548944a4b8
Gitweb:     http://git.kernel.org/tip/ec65993443736a5091b68e80ff1734548944a4b8
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Tue, 21 Jan 2014 14:33:16 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 09:10:41 +0100

mm, x86: Account for TLB flushes only when debugging

Bisection between 3.11 and 3.12 fingered commit 9824cf97 ("mm:
vmstats: tlb flush counters") to cause overhead problems.

The counters are undeniably useful but how often do we really
need to debug TLB flush related issues?  It does not justify
taking the penalty everywhere so make it a debugging option.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-XzxjntugxuwpxXhcrxqqh53b@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/tlbflush.h    |  6 +++---
 arch/x86/kernel/cpu/mtrr/generic.c |  4 ++--
 arch/x86/mm/tlb.c                  | 14 +++++++-------
 include/linux/vm_event_item.h      |  4 +++-
 include/linux/vmstat.h             |  8 ++++++++
 mm/vmstat.c                        |  4 +++-
 6 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index e6d90ba..04905bf 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -62,7 +62,7 @@ static inline void __flush_tlb_all(void)
 
 static inline void __flush_tlb_one(unsigned long addr)
 {
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ONE);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
 	__flush_tlb_single(addr);
 }
 
@@ -93,13 +93,13 @@ static inline void __flush_tlb_one(unsigned long addr)
  */
 static inline void __flush_tlb_up(void)
 {
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb();
 }
 
 static inline void flush_tlb_all(void)
 {
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb_all();
 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index ce2d0a2..0e25a1b 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -683,7 +683,7 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 	}
 
 	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb();
 
 	/* Save MTRR state */
@@ -697,7 +697,7 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 static void post_set(void) __releases(set_atomicity_lock)
 {
 	/* Flush TLBs (no need to flush caches - they are disabled) */
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb();
 
 	/* Intel (P6) standard MTRRs */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index ae699b3..05446c1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -103,7 +103,7 @@ static void flush_tlb_func(void *info)
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
 
-	count_vm_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 		if (f->flush_end == TLB_FLUSH_ALL)
 			local_flush_tlb();
@@ -131,7 +131,7 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	info.flush_start = start;
 	info.flush_end = end;
 
-	count_vm_event(NR_TLB_REMOTE_FLUSH);
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
 	if (is_uv_system()) {
 		unsigned int cpu;
 
@@ -151,7 +151,7 @@ void flush_tlb_current_task(void)
 
 	preempt_disable();
 
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	local_flush_tlb();
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
@@ -215,7 +215,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 
 	/* tlb_flushall_shift is on balance point, details in commit log */
 	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift) {
-		count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
 		if (has_large_page(mm, start, end)) {
@@ -224,7 +224,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 		}
 		/* flush range by one by one 'invlpg' */
 		for (addr = start; addr < end;	addr += PAGE_SIZE) {
-			count_vm_event(NR_TLB_LOCAL_FLUSH_ONE);
+			count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
 			__flush_tlb_single(addr);
 		}
 
@@ -262,7 +262,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long start)
 
 static void do_flush_tlb_all(void *info)
 {
-	count_vm_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	__flush_tlb_all();
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(smp_processor_id());
@@ -270,7 +270,7 @@ static void do_flush_tlb_all(void *info)
 
 void flush_tlb_all(void)
 {
-	count_vm_event(NR_TLB_REMOTE_FLUSH);
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index c557c6d..3a712e2 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -71,12 +71,14 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
+#ifdef CONFIG_DEBUG_TLBFLUSH
 #ifdef CONFIG_SMP
 		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
 		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
-#endif
+#endif /* CONFIG_SMP */
 		NR_TLB_LOCAL_FLUSH_ALL,
 		NR_TLB_LOCAL_FLUSH_ONE,
+#endif /* CONFIG_DEBUG_TLBFLUSH */
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index e4b9480..80ebba9 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -83,6 +83,14 @@ static inline void vm_events_fold_cpu(int cpu)
 #define count_vm_numa_events(x, y) do { (void)(y); } while (0)
 #endif /* CONFIG_NUMA_BALANCING */
 
+#ifdef CONFIG_DEBUG_TLBFLUSH
+#define count_vm_tlb_event(x)	   count_vm_event(x)
+#define count_vm_tlb_events(x, y)  count_vm_events(x, y)
+#else
+#define count_vm_tlb_event(x)     do {} while (0)
+#define count_vm_tlb_events(x, y) do { (void)(y); } while (0)
+#endif
+
 #define __count_zone_vm_events(item, zone, delta) \
 		__count_vm_events(item##_NORMAL - ZONE_NORMAL + \
 		zone_idx(zone), delta)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 7249614..def5dd2 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -851,12 +851,14 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 #endif
+#ifdef CONFIG_DEBUG_TLBFLUSH
 #ifdef CONFIG_SMP
 	"nr_tlb_remote_flush",
 	"nr_tlb_remote_flush_received",
-#endif
+#endif /* CONFIG_SMP */
 	"nr_tlb_local_flush_all",
 	"nr_tlb_local_flush_one",
+#endif /* CONFIG_DEBUG_TLBFLUSH */
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
