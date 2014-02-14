Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBNLtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:49:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42738 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaBNLtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:49:40 -0500
Date: Fri, 14 Feb 2014 12:49:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140214114926.GB15586@twins.programming.kicks-ass.net>
References: <52FA6D4B.7020709@canonical.com>
 <20140211194553.GZ9987@twins.programming.kicks-ass.net>
 <52FB2EC8.4080602@canonical.com>
 <20140212103713.GE3545@laptop.programming.kicks-ass.net>
 <20140212104017.GA5121@pd.tnic>
 <52FB5669.7090506@canonical.com>
 <20140212115412.GW27965@twins.programming.kicks-ass.net>
 <52FCFA23.4060701@canonical.com>
 <20140213182522.GB14089@laptop.programming.kicks-ass.net>
 <52FDFCFA.906@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FDFCFA.906@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:24:42PM +0100, Stefan Bader wrote:
> Oh and one thing I was wondering. Not sure I do understand it right... When
> initially converting to percpu counts, you changed the 32bit assembly like that:
> 
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -362,12 +362,9 @@ END(ret_from_exception)
>  #ifdef CONFIG_PREEMPT
>  ENTRY(resume_kernel)
>         DISABLE_INTERRUPTS(CLBR_ANY)
> -       cmpl $0,TI_preempt_count(%ebp)  # non-zero preempt_count ?
> -       jnz restore_all
>  need_resched:
> -       movl TI_flags(%ebp), %ecx       # need_resched set ?
> -       testb $_TIF_NEED_RESCHED, %cl
> -       jz restore_all
> +       cmpl $0,PER_CPU_VAR(__preempt_count)
> +       jnz restore_all
>         testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)    # interrupts off (exception path
>         jz restore_all
>         call preempt_schedule_irq
> 
> This seems to say if preempt_count was 0 then then if the thread flag was set
> and interrupts were not off(?) it would do a preempt ipi and then come back to
> re-check the thread flag.

No not an IPI; it would reschedule.

So the old code:

  if preempt_count != 0; continue out
  if !TIF_NEED_RESCHED; continue out
  if IRQs-off in calling context; continue out
  preempt_schedule_irq

The new code:

  if preempt_count != 0; continue out
  if IRQs-off in calling context; continue out
  preempt_schedule_irq

> This would now be if preempt_count is 0 only... and I wonder whether that would
> change from doing that loop...

We can do away with the TIF_NEED_RESCHED test because that state is
folded into the preempt_count by means of PREEMPT_NEED_RESCHED.


