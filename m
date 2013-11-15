Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3KOLRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:17:54 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:40159 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3KOLRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:17:46 -0500
Date: Fri, 15 Nov 2013 12:17:36 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] s390/mm,tlb: race of lazy TLB flush vs. recreation
 of TLB entries
Message-ID: <20131115121736.72170c36@mschwide>
In-Reply-To: <20131115121000.69219fa4@mschwide>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
	<1384330574-18418-3-git-send-email-schwidefsky@de.ibm.com>
	<CAHkRjk6LAmQpkioBdFxH5htYHi75bR2xhfXzfvmQL5Br0kMgvg@mail.gmail.com>
	<20131114091007.0b15dde2@mschwide>
	<20131114132223.GG20261@arm.com>
	<20131114173359.2e3cbd60@mschwide>
	<20131115104437.GA573@darko.cambridge.arm.com>
	<20131115121000.69219fa4@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111511-0542-0000-0000-0000071434E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013 12:10:00 +0100
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Fri, 15 Nov 2013 10:44:37 +0000
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > On Thu, Nov 14, 2013 at 04:33:59PM +0000, Martin Schwidefsky wrote:
> > > On Thu, 14 Nov 2013 13:22:23 +0000
> > > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > 
> > > > On Thu, Nov 14, 2013 at 08:10:07AM +0000, Martin Schwidefsky wrote:
> > > > > On Wed, 13 Nov 2013 16:16:35 +0000
> > > > > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > > 
> > > > > > On 13 November 2013 08:16, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > > > > > > diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
> > > > > > > index 5d1f950..e91afeb 100644
> > > > > > > --- a/arch/s390/include/asm/mmu_context.h
> > > > > > > +++ b/arch/s390/include/asm/mmu_context.h
> > > > > > > @@ -48,13 +48,38 @@ static inline void update_mm(struct mm_struct *mm, struct task_struct *tsk)
> > > > > > >  static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
> > > > > > >                              struct task_struct *tsk)
> > > > > > >  {
> > > > > > > -       cpumask_set_cpu(smp_processor_id(), mm_cpumask(next));
> > > > > > > -       update_mm(next, tsk);
> > > > > > > +       int cpu = smp_processor_id();
> > > > > > > +
> > > > > > > +       if (prev == next)
> > > > > > > +               return;
> > > > > > > +       if (atomic_inc_return(&next->context.attach_count) >> 16) {
> > > > > > > +               /* Delay update_mm until all TLB flushes are done. */
> > > > > > > +               set_tsk_thread_flag(tsk, TIF_TLB_WAIT);
> > > > > > > +       } else {
> > > > > > > +               cpumask_set_cpu(cpu, mm_cpumask(next));
> > > > > > > +               update_mm(next, tsk);
> > > > > > > +               if (next->context.flush_mm)
> > > > > > > +                       /* Flush pending TLBs */
> > > > > > > +                       __tlb_flush_mm(next);
> > > > > > > +       }
> > > > > > >         atomic_dec(&prev->context.attach_count);
> > > > > > >         WARN_ON(atomic_read(&prev->context.attach_count) < 0);
> > > > > > > -       atomic_inc(&next->context.attach_count);
> > > > > > > -       /* Check for TLBs not flushed yet */
> > > > > > > -       __tlb_flush_mm_lazy(next);
> > > > > > > +}
> > > > > > > +
> > > > > > > +#define finish_switch_mm finish_switch_mm
> > > > > > > +static inline void finish_switch_mm(struct mm_struct *mm,
> > > > > > > +                                   struct task_struct *tsk)
> > > > > > > +{
> > > > > > > +       if (!test_and_clear_tsk_thread_flag(tsk, TIF_TLB_WAIT))
> > > > > > > +               return;
> > > > > > > +
> > > > > > > +       while (atomic_read(&mm->context.attach_count) >> 16)
> > > > > > > +               cpu_relax();
> > > > > > > +
> > > > > > > +       cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
> > > > > > > +       update_mm(mm, tsk);
> > > > > > > +       if (mm->context.flush_mm)
> > > > > > > +               __tlb_flush_mm(mm);
> > > > > > >  }
> > > > > > 
> > > > > > Some care is needed here with preemption (we had this on arm and I
> > > > > > think we need a fix on arm64 as well). Basically you set TIF_TLB_WAIT
> > > > > > on a thread but you get preempted just before finish_switch_mm(). The
> > > > > > new thread has the same mm as the preempted on and switch_mm() exits
> > > > > > early without setting another flag. So finish_switch_mm() wouldn't do
> > > > > > anything but you still switched to the new mm. The fix is to make the
> > > > > > flag per mm rather than thread (see commit bdae73cd374e).
> > > > > 
> > > > > Interesting. For s390 I need to make sure that each task attaching an
> > > > > mm waits for the completion of concurrent TLB flush operations. If the
> > > > > scheduler does not switch the mm I don't care, the mm is still attached.
> > > > 
> > > > I assume the actual hardware mm switch happens via update_mm(). If you
> > > > have a context_switch() to a thread which requires an update_mm() but you
> > > > defer this until finish_switch_mm(), you may be preempted before the
> > > > hardware update. If the new context_switch() schedules a thread with the
> > > > same mm as the preempted one, you no longer call update_mm(). So the new
> > > > thread actually uses an old hardware mm.
> > >  
> > > If the code gets preempted between switch_mm() and finish_switch_mm()
> > > the worst that can happen is that finish_switch_mm() is called twice.
> > 
> > Yes, it's called twice, but you only set the TIF_TLB_WAIT the first
> > time. Here's the scenario:
> > 
> > 1. thread-A running with mm-A
> > 2. context_switch() to thread-B1 causing a switch_mm(mm-B)
> > 3. switch_mm(mm-B) sets thread-B1's TIF_TLB_WAIT but does _not_ call
> >    update_mm(mm-B). Hardware still using mm-A
> > 4. scheduler unlocks and is about to call finish_mm_switch(mm-B)
> > 5. interrupt and preemption before finish_mm_switch(mm-B)
> > 6. context_switch() to thread-B2 causing a switch_mm(mm-B) (note here
> >    that thread-B1 and thread-B2 have the same mm-B)
> > 7. switch_mm() as in this patch exits early because prev == next
> > 8. finish_mm_switch(mm-B) is indeed called but TIF_TLB_WAIT is not set
> >    for thread-B2, therefore no call to update_mm(mm-B)
> > 
> > So after point 8, you get thread-B2 running (and possibly returning to
> > user space) with mm-A. Do you see a problem here?
> 
> Oh, now I get it. Thanks for the patience, this is indeed a problem.
> And I concur, a per-mm flag is the 'obvious' solution.

Having said that and looking at the code I find this to be not as obvious
any more. If you have multiple cpus using a per-mm flag can get you into
trouble:

1. cpu #1 calls switch_mm and finds that irqs are disabled.
   mm->context.switch_pending is set
2. cpu #2 calls switch_mm for the same mm and finds that irqs are disabled.
   mm->context.switch_pending is set again
3. cpu #1 reaches finish_arch_post_lock_switch and finds switch_pending == 1
4. cpu #1 zeroes mm->switch_pending and calls cpu_switch_mm
5. cpu #2 reaches finish_arch_post_lock_switch and finds switch_pending == 0
6. cpu #2 continues with the old mm

This is a race, no?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

