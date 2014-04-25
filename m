Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaDYWhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:37:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:53912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaDYWho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,929,1389772800"; 
   d="scan'208";a="499974367"
Subject: [PATCH 1/8] x86: mm: clean up tlb flushing code
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 25 Apr 2014 15:37:43 -0700
References: <20140425223742.0A27E42E@viggo.jf.intel.com>
In-Reply-To: <20140425223742.0A27E42E@viggo.jf.intel.com>
Message-Id: <20140425223743.B5C795B1@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The

	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)

line of code is not exactly the easiest to audit, especially when
it ends up at two different indentation levels.  This eliminates
one of the the copy-n-paste versions.  It also gives us a unified
exit point for each path through this function.  We need this in
a minute for our tracepoint.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
---

 b/arch/x86/mm/tlb.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN arch/x86/mm/tlb.c~simplify-tlb-code arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~simplify-tlb-code	2014-04-25 15:33:12.268021305 -0700
+++ b/arch/x86/mm/tlb.c	2014-04-25 15:33:12.271021440 -0700
@@ -161,23 +161,24 @@ void flush_tlb_current_task(void)
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
 {
+	bool need_flush_others_all = true;
 	unsigned long addr;
 	unsigned act_entries, tlb_entries = 0;
 	unsigned long nr_base_pages;
 
 	preempt_disable();
 	if (current->active_mm != mm)
-		goto flush_all;
+		goto out;
 
 	if (!current->mm) {
 		leave_mm(smp_processor_id());
-		goto flush_all;
+		goto out;
 	}
 
 	if (end == TLB_FLUSH_ALL || tlb_flushall_shift == -1
 					|| vmflag & VM_HUGETLB) {
 		local_flush_tlb();
-		goto flush_all;
+		goto out;
 	}
 
 	/* In modern CPU, last level tlb used for both data/ins */
@@ -196,22 +197,20 @@ void flush_tlb_mm_range(struct mm_struct
 		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
+		need_flush_others_all = false;
 		/* flush range by one by one 'invlpg' */
 		for (addr = start; addr < end;	addr += PAGE_SIZE) {
 			count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
 			__flush_tlb_single(addr);
 		}
-
-		if (cpumask_any_but(mm_cpumask(mm),
-				smp_processor_id()) < nr_cpu_ids)
-			flush_tlb_others(mm_cpumask(mm), mm, start, end);
-		preempt_enable();
-		return;
 	}
-
-flush_all:
+out:
+	if (need_flush_others_all) {
+		start = 0UL;
+		end = TLB_FLUSH_ALL;
+	}
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
+		flush_tlb_others(mm_cpumask(mm), mm, start, end);
 	preempt_enable();
 }
 
_
