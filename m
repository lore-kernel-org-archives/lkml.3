Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382Ab3GaVrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:47:07 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:43220 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3GaVrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130731174335.006a58f9@annuminas.surriel.com>
References: <20130731174335.006a58f9@annuminas.surriel.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 31 Jul 2013 14:46:31 -0700
Message-ID: <CAPM31RKHZ0CxEzNm4k2RqxO_u4OOX0PPkjAdazoyfEMPyWKP7Q@mail.gmail.com>
Subject: Re: [PATCH] sched,x86: optimize switch_mm for multi-threaded workloads
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, dzickus@redhat.com, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 2:43 PM, Rik van Riel <riel@redhat.com> wrote:
> Don Zickus and Joe Mario have been working on improvements to
> perf, and noticed heavy cache line contention on the mm_cpumask,
> running linpack on a 60 core / 120 thread system.
>
> The cause turned out to be unnecessary atomic accesses to the
> mm_cpumask. When in lazy TLB mode, the CPU is only removed from
> the mm_cpumask if there is a TLB flush event.
>
> Most of the time, no such TLB flush happens, and the kernel
> skips the TLB reload.  It can also skip the atomic memory
> set & test.
>
> Here is a summary of Joe's test results:
>
>  * The __schedule function dropped from 24% of all program cycles down
>    to 5.5%.
>  * The cacheline contention/hotness for accesses to that bitmask went
>    from being the 1st/2nd hottest - down to the 84th hottest (0.3% of
>    all shared misses which is now quite cold)
>  * The average load latency for the bit-test-n-set instruction in
>    __schedule dropped from 10k-15k cycles down to an average of 600 cycles.
>  * The linpack program results improved from 133 GFlops to 144 GFlops.
>    Peak GFlops rose from 133 to 153.
>
> Reported-by: Don Zickus <dzickus@redhat.com>
> Reported-by: Joe Mario <jmario@redhat.com>
> Tested-by: Joe Mario <jmario@redhat.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  arch/x86/include/asm/mmu_context.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
> index cdbf367..987eb3d 100644
> --- a/arch/x86/include/asm/mmu_context.h
> +++ b/arch/x86/include/asm/mmu_context.h
> @@ -59,11 +59,12 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
>                 this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
>                 BUG_ON(this_cpu_read(cpu_tlbstate.active_mm) != next);
>
> -               if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
> +               if (!cpumask_test_cpu(cpu, mm_cpumask(next))) {
>                         /* We were in lazy tlb mode and leave_mm disabled
>                          * tlb flush IPI delivery. We must reload CR3
>                          * to make sure to use no freed page tables.
>                          */
> +                       cpumask_set_cpu(cpu, mm_cpumask(next));
>                         load_cr3(next->pgd);
>                         load_LDT_nolock(&next->context);
>                 }

We're carrying the *exact* same patch for *exact* same reason.  I've
been meaning to send it out but wasn't sure of a good external
workload for this.

Reviewed-by: Paul Turner <pjt@google.com>
