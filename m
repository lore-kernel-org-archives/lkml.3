Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab3KOJO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:14:58 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:48813 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3KOJOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:14:48 -0500
Date: Fri, 15 Nov 2013 10:13:26 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] s390/mm,tlb: race of lazy TLB flush vs. recreation
 of TLB entries
Message-ID: <20131115101326.722f3407@mschwide>
In-Reply-To: <20131114091007.0b15dde2@mschwide>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
	<1384330574-18418-3-git-send-email-schwidefsky@de.ibm.com>
	<CAHkRjk6LAmQpkioBdFxH5htYHi75bR2xhfXzfvmQL5Br0kMgvg@mail.gmail.com>
	<20131114091007.0b15dde2@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111509-3548-0000-0000-000007278D6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013 09:10:07 +0100
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Wed, 13 Nov 2013 16:16:35 +0000
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > On 13 November 2013 08:16, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > > diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
> > > index 5d1f950..e91afeb 100644
> > > --- a/arch/s390/include/asm/mmu_context.h
> > > +++ b/arch/s390/include/asm/mmu_context.h
> > > @@ -48,13 +48,38 @@ static inline void update_mm(struct mm_struct *mm, struct task_struct *tsk)
> > >  static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
> > >                              struct task_struct *tsk)
> > >  {
> > > -       cpumask_set_cpu(smp_processor_id(), mm_cpumask(next));
> > > -       update_mm(next, tsk);
> > > +       int cpu = smp_processor_id();
> > > +
> > > +       if (prev == next)
> > > +               return;
> > > +       if (atomic_inc_return(&next->context.attach_count) >> 16) {
> > > +               /* Delay update_mm until all TLB flushes are done. */
> > > +               set_tsk_thread_flag(tsk, TIF_TLB_WAIT);
> > > +       } else {
> > > +               cpumask_set_cpu(cpu, mm_cpumask(next));
> > > +               update_mm(next, tsk);
> > > +               if (next->context.flush_mm)
> > > +                       /* Flush pending TLBs */
> > > +                       __tlb_flush_mm(next);
> > > +       }
> > >         atomic_dec(&prev->context.attach_count);
> > >         WARN_ON(atomic_read(&prev->context.attach_count) < 0);
> > > -       atomic_inc(&next->context.attach_count);
> > > -       /* Check for TLBs not flushed yet */
> > > -       __tlb_flush_mm_lazy(next);
> > > +}
> > > +
> > > +#define finish_switch_mm finish_switch_mm
> > > +static inline void finish_switch_mm(struct mm_struct *mm,
> > > +                                   struct task_struct *tsk)
> > > +{
> > > +       if (!test_and_clear_tsk_thread_flag(tsk, TIF_TLB_WAIT))
> > > +               return;
> > > +
> > > +       while (atomic_read(&mm->context.attach_count) >> 16)
> > > +               cpu_relax();
> > > +
> > > +       cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
> > > +       update_mm(mm, tsk);
> > > +       if (mm->context.flush_mm)
> > > +               __tlb_flush_mm(mm);
> > >  }
> > 
> > Some care is needed here with preemption (we had this on arm and I
> > think we need a fix on arm64 as well). Basically you set TIF_TLB_WAIT
> > on a thread but you get preempted just before finish_switch_mm(). The
> > new thread has the same mm as the preempted on and switch_mm() exits
> > early without setting another flag. So finish_switch_mm() wouldn't do
> > anything but you still switched to the new mm. The fix is to make the
> > flag per mm rather than thread (see commit bdae73cd374e).
> 
> Interesting. For s390 I need to make sure that each task attaching an
> mm waits for the completion of concurrent TLB flush operations. If the
> scheduler does not switch the mm I don't care, the mm is still attached.
> For the s390 issue a TIF bit seems appropriate. But I have to add an
> preempt_enable/preempt_disable pair to finish_switch_mm, otherwise the
> task can get hit by preemption after the while loop.
 
I almost committed a patch to add preempt_enable/preempt_disable when I
realized that it is not needed after all. If a preemptive schedule hits
in finish_switch_mm a full switch_mm/finish_switch_mm pair will be done
when the task is picked up again by a CPU. The worst that can happen
is that the update_mm is done a second time which is ok. All good :-)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

