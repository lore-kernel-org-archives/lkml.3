Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3IWKPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:15:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:46828 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab3IWKPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:15:16 -0400
Message-ID: <1379931214.11249.10.camel@pasglop>
Subject: Re: [PATCH] powerpc/irq: Run softirqs off the top of the irq stack
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@au1.ibm.com>
Date: Mon, 23 Sep 2013 20:13:34 +1000
In-Reply-To: <20130923175621.e9bab9ff0e6545457666602f@canb.auug.org.au>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com>
	 <1379824754.24090.11.camel@pasglop> <1379824861.24090.12.camel@pasglop>
	 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
	 <1379887000.24090.19.camel@pasglop>
	 <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
	 <1379889489.24090.34.camel@pasglop> <1379910958.6625.3.camel@pasglop>
	 <20130923175621.e9bab9ff0e6545457666602f@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 17:56 +1000, Stephen Rothwell wrote:
> Hi Ben,
> 
> On Mon, 23 Sep 2013 14:35:58 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> >
> > diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> > index c69440c..0c9646f 100644
> > --- a/arch/powerpc/kernel/irq.c
> > +++ b/arch/powerpc/kernel/irq.c
> > @@ -443,46 +443,7 @@ void migrate_irqs(void)
> >  
> >  static inline void handle_one_irq(unsigned int irq)
> >  {
> > -	struct thread_info *curtp, *irqtp;
> > -	unsigned long saved_sp_limit;
> > -	struct irq_desc *desc;
> > -
> > -	desc = irq_to_desc(irq);
> > -	if (!desc)
> > -		return;
> > -
> > -	/* Switch to the irq stack to handle this */
> > -	curtp = current_thread_info();
> > -	irqtp = hardirq_ctx[smp_processor_id()];
> > -
> > -	if (curtp == irqtp) {
> > -		/* We're already on the irq stack, just handle it */
> > -		desc->handle_irq(irq, desc);
> > -		return;
> > -	}
> > -
> > -	saved_sp_limit = current->thread.ksp_limit;
> > -
> > -	irqtp->task = curtp->task;
> > -	irqtp->flags = 0;
> > -
> > -	/* Copy the softirq bits in preempt_count so that the
> > -	 * softirq checks work in the hardirq context. */
> > -	irqtp->preempt_count = (irqtp->preempt_count & ~SOFTIRQ_MASK) |
> > -			       (curtp->preempt_count & SOFTIRQ_MASK);
> >  
> > -	current->thread.ksp_limit = (unsigned long)irqtp +
> > -		_ALIGN_UP(sizeof(struct thread_info), 16);
> > -
> > -	call_handle_irq(irq, desc, irqtp, desc->handle_irq);
> > -	current->thread.ksp_limit = saved_sp_limit;
> > -	irqtp->task = NULL;
> > -
> > -	/* Set any flag that may have been set on the
> > -	 * alternate stack
> > -	 */
> > -	if (irqtp->flags)
> > -		set_bits(irqtp->flags, &curtp->flags);
> >  }
> 
> This function ends up as a single blank line ...
> 
> > @@ -519,18 +480,64 @@ void do_IRQ(struct pt_regs *regs)
> >  	 */
> >  	irq = ppc_md.get_irq();
> >  
> > -	/* We can hard enable interrupts now */
> > +	/* We can hard enable interrupts now to allow perf interrupts */
> >  	may_hard_irq_enable();
> >  
> >  	/* And finally process it */
> > -	if (irq != NO_IRQ)
> > -		handle_one_irq(irq);
> 
> then you remove the only call, so why not just remove the function
> completely?

Because I'm an idiot ? :-)

I moved bits and pieces to do_IRQ and forgot to remove the remainder
(and gcc didn't warn :-)

Cheers,
Ben.



