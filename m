Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab3GPXoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:44:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:10890 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573Ab3GPXox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:44:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,680,1367996400"; 
   d="scan'208";a="346700299"
Subject: [RESEND][PATCH] mm: vmstats: tlb flush counters
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-mm@kvack.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 16 Jul 2013 16:44:38 -0700
Message-Id: <20130716234438.C792C316@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was investigating some TLB flush scaling issues and realized
that we do not have any good methods for figuring out how many
TLB flushes we are doing.

It would be nice to be able to do these in generic code, but the
arch-independent calls don't explicitly specify whether we
actually need to do remote flushes or not.  In the end, we really
need to know if we actually _did_ global vs. local invalidations,
so that leaves us with few options other than to muck with the
counters from arch-specific code.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/mm/tlb.c             |   18 ++++++++++++++----
 linux.git-davehans/include/linux/vm_event_item.h |    5 +++++
 linux.git-davehans/mm/vmstat.c                   |    5 +++++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/tlb.c~tlb-vmstats arch/x86/mm/tlb.c
--- linux.git/arch/x86/mm/tlb.c~tlb-vmstats	2013-07-16 16:41:56.476280350 -0700
+++ linux.git-davehans/arch/x86/mm/tlb.c	2013-07-16 16:41:56.483280658 -0700
@@ -103,6 +103,7 @@ static void flush_tlb_func(void *info)
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
 
+	count_vm_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 		if (f->flush_end == TLB_FLUSH_ALL)
 			local_flush_tlb();
@@ -130,6 +131,7 @@ void native_flush_tlb_others(const struc
 	info.flush_start = start;
 	info.flush_end = end;
 
+	count_vm_event(NR_TLB_REMOTE_FLUSH);
 	if (is_uv_system()) {
 		unsigned int cpu;
 
@@ -149,6 +151,7 @@ void flush_tlb_current_task(void)
 
 	preempt_disable();
 
+	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
 	local_flush_tlb();
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
@@ -211,16 +214,19 @@ void flush_tlb_mm_range(struct mm_struct
 	act_entries = mm->total_vm > tlb_entries ? tlb_entries : mm->total_vm;
 
 	/* tlb_flushall_shift is on balance point, details in commit log */
-	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift)
+	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift) {
+		count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
-	else {
+	} else {
 		if (has_large_page(mm, start, end)) {
 			local_flush_tlb();
 			goto flush_all;
 		}
 		/* flush range by one by one 'invlpg' */
-		for (addr = start; addr < end;	addr += PAGE_SIZE)
+		for (addr = start; addr < end;	addr += PAGE_SIZE) {
+			count_vm_event(NR_TLB_LOCAL_FLUSH_ONE);
 			__flush_tlb_single(addr);
+		}
 
 		if (cpumask_any_but(mm_cpumask(mm),
 				smp_processor_id()) < nr_cpu_ids)
@@ -256,6 +262,7 @@ void flush_tlb_page(struct vm_area_struc
 
 static void do_flush_tlb_all(void *info)
 {
+	count_vm_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	__flush_tlb_all();
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(smp_processor_id());
@@ -263,6 +270,7 @@ static void do_flush_tlb_all(void *info)
 
 void flush_tlb_all(void)
 {
+	count_vm_event(NR_TLB_REMOTE_FLUSH);
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
@@ -272,8 +280,10 @@ static void do_kernel_range_flush(void *
 	unsigned long addr;
 
 	/* flush range by one by one 'invlpg' */
-	for (addr = f->flush_start; addr < f->flush_end; addr += PAGE_SIZE)
+	for (addr = f->flush_start; addr < f->flush_end; addr += PAGE_SIZE) {
+		count_vm_event(NR_TLB_LOCAL_FLUSH_ONE_KERNEL);
 		__flush_tlb_single(addr);
+	}
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
diff -puN include/linux/vm_event_item.h~tlb-vmstats include/linux/vm_event_item.h
--- linux.git/include/linux/vm_event_item.h~tlb-vmstats	2013-07-16 16:41:56.478280438 -0700
+++ linux.git-davehans/include/linux/vm_event_item.h	2013-07-16 16:41:56.483280658 -0700
@@ -70,6 +70,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
+		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
+		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
+		NR_TLB_LOCAL_FLUSH_ALL,
+		NR_TLB_LOCAL_FLUSH_ONE,
+		NR_TLB_LOCAL_FLUSH_ONE_KERNEL,
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/vmstat.c~tlb-vmstats mm/vmstat.c
--- linux.git/mm/vmstat.c~tlb-vmstats	2013-07-16 16:41:56.480280525 -0700
+++ linux.git-davehans/mm/vmstat.c	2013-07-16 16:41:56.484280703 -0700
@@ -817,6 +817,11 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 #endif
+	"nr_tlb_remote_flush",
+	"nr_tlb_remote_flush_received",
+	"nr_tlb_local_flush_all",
+	"nr_tlb_local_flush_one",
+	"nr_tlb_local_flush_one_kernel",
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
_
