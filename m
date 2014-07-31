Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaGaQL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:11:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaGaQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:10:55 -0400
Date: Thu, 31 Jul 2014 09:10:37 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-d17d8f9dedb9dd76fd540a5c497101529d9eb25a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave@sr71.net, riel@redhat.com, mgorman@suse.de, tglx@linutronix.de,
        dave.hansen@linux.intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@sr71.net, riel@redhat.com, mgorman@suse.de, tglx@linutronix.de,
        dave.hansen@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <20140731154059.4C96CBA5@viggo.jf.intel.com>
References: <20140731154059.4C96CBA5@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Add tracepoints for TLB flushes
Git-Commit-ID: d17d8f9dedb9dd76fd540a5c497101529d9eb25a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d17d8f9dedb9dd76fd540a5c497101529d9eb25a
Gitweb:     http://git.kernel.org/tip/d17d8f9dedb9dd76fd540a5c497101529d9eb25a
Author:     Dave Hansen <dave@sr71.net>
AuthorDate: Thu, 31 Jul 2014 08:40:59 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jul 2014 08:48:51 -0700

x86/mm: Add tracepoints for TLB flushes

We don't have any good way to figure out what kinds of flushes
are being attempted.  Right now, we can try to use the vm
counters, but those only tell us what we actually did with the
hardware (one-by-one vs full) and don't tell us what was actually
_requested_.

This allows us to select out "interesting" TLB flushes that we
might want to optimize (like the ranged ones) and ignore the ones
that we have very little control over (the ones at context
switch).

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://lkml.kernel.org/r/20140731154059.4C96CBA5@viggo.jf.intel.com
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/mmu_context.h |  6 ++++++
 arch/x86/mm/init.c                 |  7 +++++++
 arch/x86/mm/tlb.c                  | 11 +++++++++--
 include/linux/mm_types.h           |  8 ++++++++
 include/trace/events/tlb.h         | 40 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index be12c53..166af2a 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -3,6 +3,10 @@
 
 #include <asm/desc.h>
 #include <linux/atomic.h>
+#include <linux/mm_types.h>
+
+#include <trace/events/tlb.h>
+
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
@@ -44,6 +48,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 
 		/* Re-load page tables */
 		load_cr3(next->pgd);
+		trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
 
 		/* Stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
@@ -71,6 +76,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			 * to make sure to use no freed page tables.
 			 */
 			load_cr3(next->pgd);
+			trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
 			load_LDT_nolock(&next->context);
 		}
 	}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f971306..66dba36 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -18,6 +18,13 @@
 #include <asm/dma.h>		/* for MAX_DMA_PFN */
 #include <asm/microcode.h>
 
+/*
+ * We need to define the tracepoints somewhere, and tlb.c
+ * is only compied when SMP=y.
+ */
+#define CREATE_TRACE_POINTS
+#include <trace/events/tlb.h>
+
 #include "mm_internal.h"
 
 static unsigned long __initdata pgt_buf_start;
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index add5a0f..6f00ecb 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -49,6 +49,7 @@ void leave_mm(int cpu)
 	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
 		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
 		load_cr3(swapper_pg_dir);
+		trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
 	}
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -107,15 +108,19 @@ static void flush_tlb_func(void *info)
 
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-		if (f->flush_end == TLB_FLUSH_ALL)
+		if (f->flush_end == TLB_FLUSH_ALL) {
 			local_flush_tlb();
-		else {
+			trace_tlb_flush(TLB_REMOTE_SHOOTDOWN, TLB_FLUSH_ALL);
+		} else {
 			unsigned long addr;
+			unsigned long nr_pages =
+				f->flush_end - f->flush_start / PAGE_SIZE;
 			addr = f->flush_start;
 			while (addr < f->flush_end) {
 				__flush_tlb_single(addr);
 				addr += PAGE_SIZE;
 			}
+			trace_tlb_flush(TLB_REMOTE_SHOOTDOWN, nr_pages);
 		}
 	} else
 		leave_mm(smp_processor_id());
@@ -153,6 +158,7 @@ void flush_tlb_current_task(void)
 
 	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	local_flush_tlb();
+	trace_tlb_flush(TLB_LOCAL_SHOOTDOWN, TLB_FLUSH_ALL);
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
 	preempt_enable();
@@ -191,6 +197,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 			__flush_tlb_single(addr);
 		}
 	}
+	trace_tlb_flush(TLB_LOCAL_MM_SHOOTDOWN, base_pages_to_flush);
 out:
 	if (base_pages_to_flush == TLB_FLUSH_ALL) {
 		start = 0UL;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 96c5750..796deac 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -516,4 +516,12 @@ struct vm_special_mapping
 	struct page **pages;
 };
 
+enum tlb_flush_reason {
+	TLB_FLUSH_ON_TASK_SWITCH,
+	TLB_REMOTE_SHOOTDOWN,
+	TLB_LOCAL_SHOOTDOWN,
+	TLB_LOCAL_MM_SHOOTDOWN,
+	NR_TLB_FLUSH_REASONS,
+};
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/include/trace/events/tlb.h b/include/trace/events/tlb.h
new file mode 100644
index 0000000..13391d2
--- /dev/null
+++ b/include/trace/events/tlb.h
@@ -0,0 +1,40 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM tlb
+
+#if !defined(_TRACE_TLB_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TLB_H
+
+#include <linux/mm_types.h>
+#include <linux/tracepoint.h>
+
+#define TLB_FLUSH_REASON	\
+	{ TLB_FLUSH_ON_TASK_SWITCH,	"flush on task switch" },	\
+	{ TLB_REMOTE_SHOOTDOWN,		"remote shootdown" },		\
+	{ TLB_LOCAL_SHOOTDOWN,		"local shootdown" },		\
+	{ TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown" }
+
+TRACE_EVENT(tlb_flush,
+
+	TP_PROTO(int reason, unsigned long pages),
+	TP_ARGS(reason, pages),
+
+	TP_STRUCT__entry(
+		__field(	  int, reason)
+		__field(unsigned long,  pages)
+	),
+
+	TP_fast_assign(
+		__entry->reason = reason;
+		__entry->pages  = pages;
+	),
+
+	TP_printk("pages:%ld reason:%s (%d)",
+		__entry->pages,
+		__print_symbolic(__entry->reason, TLB_FLUSH_REASON),
+		__entry->reason)
+);
+
+#endif /* _TRACE_TLB_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
