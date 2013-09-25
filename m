Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab3IYBIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:08:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab3IYAQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>, Joe Mario <jmario@redhat.com>,
        Rik van Riel <riel@redhat.com>, Paul Turner <pjt@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 052/110] sched/x86: Optimize switch_mm() for multi-threaded workloads
Date: Tue, 24 Sep 2013 17:14:50 -0700
Message-Id: <20130925001329.046577656@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@redhat.com>

commit 8f898fbbe5ee5e20a77c4074472a1fd088dc47d1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/mmu_context.h |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -45,22 +45,28 @@ static inline void switch_mm(struct mm_s
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


