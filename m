Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3KFRX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:23:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:46593 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3KFRX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:23:26 -0500
Date: Wed, 6 Nov 2013 18:23:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Andreas Schwab <schwab@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
In-Reply-To: <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com> <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert,

On Mon, 4 Nov 2013, Geert Uytterhoeven wrote:
> But only if you look at "[m68k] IRQ: add handle_polled_irq() for timer
> based soft interrupt" (http://www.spinics.net/lists/linux-m68k/msg05889.html)
> first ;-)

Done. Thanks for the reminder!
 
> Below is a patch with some fixups, on top of your two patches.
> 
> Unfortunately it still hangs somewhere after mounting the root filesystem.
> 
> Using this debug code for do_IRQ():
> 
> diff --git a/arch/m68k/kernel/irq.c b/arch/m68k/kernel/irq.c
> index aaf7b15fad41..da9687803d98 100644
> --- a/arch/m68k/kernel/irq.c
> +++ b/arch/m68k/kernel/irq.c
> @@ -22,11 +22,21 @@ asmlinkage int do_IRQ(int irq, struct pt_regs *regs)
>  	struct pt_regs *oldregs = set_irq_regs(regs);
>  	int nested = regs->sr & ~ALLOWINT;
>  
> +static int nesting;
> +const char prefix[] = "                ";
> +unsigned long flags;
> +local_irq_save(flags);
> +nesting++;
> +printk("# %sirq %d nested %d\n", &prefix[16-2*nesting], irq, nested);
> +local_irq_restore(flags);
>  	irq_enter();
>  	generic_handle_irq(irq);
>  	irq_exit_nested(nested);
>  
>  	set_irq_regs(oldregs);
> +local_irq_save(flags);
> +nesting--;
> +local_irq_restore(flags);
>  	return nested;
>  }
>  
> I get output like
> 
> #   irq 15 nested 0
> #     irq 15 nested 1024
> 
> irq 15 while irq 15 in progress??

Huch, that's odd.
 
> With similar debug code on the old working do_IRQ(), I get
>   - slightly less deep nesting,
>   - do_IRQ() is never re-entered with the same irq number.
> 
> Also note that the value of "nested" doesn't match the indentation level,
> which depends on my own bookkeeping using "nesting".

Well, nested is just an indicator. It's not the nest level.

      nested = pt->sr & ~ALLOWINT;
i.e.:
      nested = pt->sr & 0x0700;

So in the case above nested is 0x400
 
> Anyone with an idea where it's going wrong?

The original code does:

    add_preempt_count(HARDIRQ_OFFSET);

    do_IRQ()
	irq_enter();
	  add_preempt_count(HARDIRQ_OFFSET);

	handle_irq();

	irq_exit();
	    local_irq_disable();
	    sub_preempt_count(HARDIRQ_OFFSET);

    sub_preempt_count(HARDIRQ_OFFSET);
    
    /* Check for nested irq */
    if (in_hardirq())
       reti();

    /* Check for nested irq again */
    if (pt->sr & ~ALLOWINT != 0)
       reti();

    do_softirq();
       ....
    ret_from_exception();

With the patches in place it looks like this:

     do_IRQ()
	nested = pt->sr & ~ALLOWINT;

	irq_enter();
	  add_preempt_count(HARDIRQ_OFFSET);

	handle_irq();

	irq_exit_nested(nested);
	    local_irq_disable();
	    sub_preempt_count(HARDIRQ_OFFSET);
	    if (!nested && !in_hardirq())
	       do_softirq()
		  
	return nested;

      if (nested)
      	 reti();

      ret_from_exception();

So all it does essentially is to move the softirq invocation in the
non nested case a tad earlier. I'm really puzzled as I can't spot the
point where this change makes a real difference.

Thanks,

	tglx
