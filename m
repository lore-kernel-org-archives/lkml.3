Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3HACOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:14:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3HACOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:14:31 -0400
Date: Wed, 31 Jul 2013 22:14:21 -0400
From: Rik van Riel <riel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Turner <pjt@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH -v2] sched,x86: optimize switch_mm for multi-threaded
 workloads
Message-ID: <20130731221421.616d3d20@annuminas.surriel.com>
In-Reply-To: <CA+55aFwTNQFFJbeP4bYuMBREq=n6GU2vV71ftr_7OnE6SK5OSw@mail.gmail.com>
References: <20130731174335.006a58f9@annuminas.surriel.com>
	<CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
	<51F98CAB.80100@redhat.com>
	<CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com>
	<51F99218.4060104@redhat.com>
	<CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com>
	<51F999DE.7080200@redhat.com>
	<CAPM31R+BiTiLbNrD+33q31z8Ww7dpm7t1vcLak-hZ-z5L2PY-g@mail.gmail.com>
	<CA+55aFwTNQFFJbeP4bYuMBREq=n6GU2vV71ftr_7OnE6SK5OSw@mail.gmail.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013 17:41:39 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> However, as Rik points out, activate_mm() is different in that we
> shouldn't have any preexisting MMU state anyway. And besides, that
> should never trigger the "prev == next" case.
> 
> But it does look a bit messy, and even your comment is a bit
> misleading (it might make somebody think that all of switch_mm() is
> protected from interrupts)

Is this better?  Not that I really care which version gets applied :)

---8<---

Subject: sched,x86: optimize switch_mm for multi-threaded workloads

Dick Fowles, Don Zickus and Joe Mario have been working on improvements 
to perf, and noticed heavy cache line contention on the mm_cpumask,
running linpack on a 60 core / 120 thread system.

The cause turned out to be unnecessary atomic accesses to the
mm_cpumask. When in lazy TLB mode, the CPU is only removed from
the mm_cpumask if there is a TLB flush event.

Most of the time, no such TLB flush happens, and the kernel
skips the TLB reload.  It can also skip the atomic memory
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

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/mmu_context.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index cdbf367..3ac6089 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -59,7 +59,13 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		BUG_ON(this_cpu_read(cpu_tlbstate.active_mm) != next);
 
-		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
+		if (!cpumask_test_cpu(cpu, mm_cpumask(next))) {
+			/* On established mms, the mm_cpumask is only changed
+			 * from irq context, from ptep_clear_flush while in
+			 * lazy tlb mode, and here. Irqs are blocked during
+			 * schedule, protecting us from simultaneous changes.
+			 */
+			cpumask_set_cpu(cpu, mm_cpumask(next));
 			/* We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
