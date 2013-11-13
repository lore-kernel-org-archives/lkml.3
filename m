Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab3KMQRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:17:00 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57778 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3KMQQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:16:56 -0500
MIME-Version: 1.0
In-Reply-To: <1384330574-18418-3-git-send-email-schwidefsky@de.ibm.com>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com> <1384330574-18418-3-git-send-email-schwidefsky@de.ibm.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 13 Nov 2013 16:16:35 +0000
X-Google-Sender-Auth: WIIaa53i3ua0LBJa-tlG6KBvvVA
Message-ID: <CAHkRjk6LAmQpkioBdFxH5htYHi75bR2xhfXzfvmQL5Br0kMgvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] s390/mm,tlb: race of lazy TLB flush vs. recreation of
 TLB entries
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2013 08:16, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
> index 5d1f950..e91afeb 100644
> --- a/arch/s390/include/asm/mmu_context.h
> +++ b/arch/s390/include/asm/mmu_context.h
> @@ -48,13 +48,38 @@ static inline void update_mm(struct mm_struct *mm, struct task_struct *tsk)
>  static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
>                              struct task_struct *tsk)
>  {
> -       cpumask_set_cpu(smp_processor_id(), mm_cpumask(next));
> -       update_mm(next, tsk);
> +       int cpu = smp_processor_id();
> +
> +       if (prev == next)
> +               return;
> +       if (atomic_inc_return(&next->context.attach_count) >> 16) {
> +               /* Delay update_mm until all TLB flushes are done. */
> +               set_tsk_thread_flag(tsk, TIF_TLB_WAIT);
> +       } else {
> +               cpumask_set_cpu(cpu, mm_cpumask(next));
> +               update_mm(next, tsk);
> +               if (next->context.flush_mm)
> +                       /* Flush pending TLBs */
> +                       __tlb_flush_mm(next);
> +       }
>         atomic_dec(&prev->context.attach_count);
>         WARN_ON(atomic_read(&prev->context.attach_count) < 0);
> -       atomic_inc(&next->context.attach_count);
> -       /* Check for TLBs not flushed yet */
> -       __tlb_flush_mm_lazy(next);
> +}
> +
> +#define finish_switch_mm finish_switch_mm
> +static inline void finish_switch_mm(struct mm_struct *mm,
> +                                   struct task_struct *tsk)
> +{
> +       if (!test_and_clear_tsk_thread_flag(tsk, TIF_TLB_WAIT))
> +               return;
> +
> +       while (atomic_read(&mm->context.attach_count) >> 16)
> +               cpu_relax();
> +
> +       cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
> +       update_mm(mm, tsk);
> +       if (mm->context.flush_mm)
> +               __tlb_flush_mm(mm);
>  }

Some care is needed here with preemption (we had this on arm and I
think we need a fix on arm64 as well). Basically you set TIF_TLB_WAIT
on a thread but you get preempted just before finish_switch_mm(). The
new thread has the same mm as the preempted on and switch_mm() exits
early without setting another flag. So finish_switch_mm() wouldn't do
anything but you still switched to the new mm. The fix is to make the
flag per mm rather than thread (see commit bdae73cd374e).

-- 
Catalin
