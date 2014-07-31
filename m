Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaGaQKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:10:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaGaQKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:10:10 -0400
Date: Thu, 31 Jul 2014 09:09:37 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-4995ab9cf512e9a6cc07dfd6b1d4e2fc48ce7fef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        riel@redhat.com, mgorman@suse.de, tglx@linutronix.de,
        dave.hansen@linux.intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        riel@redhat.com, mgorman@suse.de, tglx@linutronix.de,
        dave.hansen@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <20140731154054.44F1CDDC@viggo.jf.intel.com>
References: <20140731154054.44F1CDDC@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Clean up the TLB flushing code
Git-Commit-ID: 4995ab9cf512e9a6cc07dfd6b1d4e2fc48ce7fef
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

Commit-ID:  4995ab9cf512e9a6cc07dfd6b1d4e2fc48ce7fef
Gitweb:     http://git.kernel.org/tip/4995ab9cf512e9a6cc07dfd6b1d4e2fc48ce7fef
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 31 Jul 2014 08:40:54 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jul 2014 08:48:50 -0700

x86/mm: Clean up the TLB flushing code

The

	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)

line of code is not exactly the easiest to audit, especially when
it ends up at two different indentation levels.  This eliminates
one of the the copy-n-paste versions.  It also gives us a unified
exit point for each path through this function.  We need this in
a minute for our tracepoint.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://lkml.kernel.org/r/20140731154054.44F1CDDC@viggo.jf.intel.com
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/tlb.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index dd8dda1..378fbef 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
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
@@ -196,22 +197,20 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
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
 
