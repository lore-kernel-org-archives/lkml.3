Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab3HBJHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:07:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3HBJHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:07:48 -0400
Date: Fri, 2 Aug 2013 02:07:25 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-8f898fbbe5ee5e20a77c4074472a1fd088dc47d1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, jmario@redhat.com,
        riel@redhat.com, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, jmario@redhat.com,
        riel@redhat.com, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <20130731221421.616d3d20@annuminas.surriel.com>
References: <20130731221421.616d3d20@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/x86: Optimize switch_mm()
  for multi-threaded workloads
Git-Commit-ID: 8f898fbbe5ee5e20a77c4074472a1fd088dc47d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 02 Aug 2013 02:07:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f898fbbe5ee5e20a77c4074472a1fd088dc47d1
Gitweb:     http://git.kernel.org/tip/8f898fbbe5ee5e20a77c4074472a1fd088dc47d1
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Wed, 31 Jul 2013 22:14:21 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 1 Aug 2013 09:10:26 +0200

sched/x86: Optimize switch_mm() for multi-threaded workloads

Dick Fowles, Don Zickus and Joe Mario have been working on
improvements to perf, and noticed heavy cache line contention
on the mm_cpumask, running linpack on a 60 core / 120 thread
system.

The cause turned out to be unnecessary atomic accesses to the
mm_cpumask. When in lazy TLB mode, the CPU is only removed from
the mm_cpumask if there is a TLB flush event.

Most of the time, no such TLB flush happens, and the kernel
skips the TLB reload. It can also skip the atomic memory
set & test.

Here is a summary of Joe's test results:

 * The __schedule function dropped from 24% of all program cycles down
   to 5.5%.

 * The cacheline contention/hotness for accesses to that bitmask went
   from being the 1st/2nd hottest - down to the 84th hottest (0.3% of
   all shared misses which is now quite cold)

 * The average load latency for the bit-test-n-set instruction in
   __schedule dropped from 10k-15k cycles down to an average of 600 cycles.

 * The linpack program results improved from 133 GFlops to 144 GFlops.
   Peak GFlops rose from 133 to 153.

Reported-by: Don Zickus <dzickus@redhat.com>
Reported-by: Joe Mario <jmario@redhat.com>
Tested-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Paul Turner <pjt@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130731221421.616d3d20@annuminas.surriel.com
[ Made the comments consistent around the modified code. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/mmu_context.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index cdbf367..be12c53 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -45,22 +45,28 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
-		/* stop flush ipis for the previous mm */
+		/* Stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 
-		/*
-		 * load the LDT, if the LDT is different:
-		 */
+		/* Load the LDT, if the LDT is different: */
 		if (unlikely(prev->context.ldt != next->context.ldt))
 			load_LDT_nolock(&next->context);
 	}
 #ifdef CONFIG_SMP
-	else {
+	  else {
 		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		BUG_ON(this_cpu_read(cpu_tlbstate.active_mm) != next);
 
-		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
-			/* We were in lazy tlb mode and leave_mm disabled
+		if (!cpumask_test_cpu(cpu, mm_cpumask(next))) {
+			/*
+			 * On established mms, the mm_cpumask is only changed
+			 * from irq context, from ptep_clear_flush() while in
+			 * lazy tlb mode, and here. Irqs are blocked during
+			 * schedule, protecting us from simultaneous changes.
+			 */
+			cpumask_set_cpu(cpu, mm_cpumask(next));
+			/*
+			 * We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
 			 */
