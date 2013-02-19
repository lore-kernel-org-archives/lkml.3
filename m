Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab3BSKoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:44:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:60368 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3BSKog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:44:36 -0500
Date: Tue, 19 Feb 2013 11:44:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>, linux-arch@vger.kernel.org
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
In-Reply-To: <CAFTL4hxaOKvNSWkHgw80Cp1JTNEGXREWHtyQJEzeNgUZHMyTyQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302191141480.22263@ionos>
References: <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com> <20130215011503.GA11914@redhat.com> <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com> <20130215174435.GA2792@linux.vnet.ibm.com>
 <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com> <CAFTL4hyTfwAZWz=gMokk5oG3HO8iGh7=FtoNv89CMg_Lm-TPNg@mail.gmail.com> <CA+55aFz4vO-JGv+A7h=uxwfyWEMcK=Q3gntwHfr=a4OUVs-f+g@mail.gmail.com> <CAFTL4hx7iX8vZFu7pO5wLSPpEzfMD8K7n0bUsY-wK-uCsDAsEw@mail.gmail.com>
 <CAFTL4hzUy+2qDaCDK3jCUs+6Fe48-uU9KSB+Ssk+-i=zYhqaRg@mail.gmail.com> <20130218155324.GA5816@somewhere.redhat.com> <alpine.LFD.2.02.1302182055040.22263@ionos> <CAFTL4hxaOKvNSWkHgw80Cp1JTNEGXREWHtyQJEzeNgUZHMyTyQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing linux-arch, so the arch folks can scream murder if they have
any objections.

On Tue, 19 Feb 2013, Frederic Weisbecker wrote:
> 2013/2/18 Thomas Gleixner <tglx@linutronix.de>:
> > On Mon, 18 Feb 2013, Frederic Weisbecker wrote:
> >> diff --git a/kernel/softirq.c b/kernel/softirq.c
> >> index ed567ba..69fbefd 100644
> >> --- a/kernel/softirq.c
> >> +++ b/kernel/softirq.c
> >> @@ -277,6 +277,17 @@ restart:
> >>       tsk_restore_flags(current, old_flags, PF_MEMALLOC);
> >>  }
> >>
> >> +#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
> >
> > We really should get rid of that and make irqs disabled on irq exit
> > mandatory.
> 
> Until now I even thought that having irqs disabled in irq_exit() was
> mandatory. I need to have a second look at tick_nohz_irq_exit() as I
> modified it with this requirement in mind...

Duh.
 
> Also with this patch, if a nesting interrupt happens right after
> tick_nohz_irq_exit(), this new irq will call tick_nohz_stop_idle() but
> not tick_nohz_start_idle() on the end. Leaving that unbalanced. I
> could work that around but I don't want to spaghettize further around
> that ifdef.
> 
> So this patch actually does depend on __ARCH_IRQ_EXIT_IRQS_DISABLED. I
> need to convert all archs to force this first. Then think about the
> softirq.c cleanup once its done.
> 
> I wonder what's the right path to this, may be loop over archs until
> they all have __ARCH_IRQ_EXIT_IRQS_DISABLED, then remove that? Sounds
> like non-sense but the safest way at the same time.

Yeah.
 
> >>  static inline void invoke_softirq(void)
> >>  {
> >> -     if (!force_irqthreads) {
> >> +     /* Can we run softirq's at all? We migth be nesting interrupts */
> >> +     if (in_nesting_interrupt())
> >> +             return;
> >
> > We might also be in a softirq disabled region where it makes no sense
> > to continue. So this should be
> >
> >    in_nesting_interrupt() || in_softirq()
> 
> in_nesting_interrupt() takes care of that as well.
 
Gah, misread the macro maze :(

Thanks,

	tglx
