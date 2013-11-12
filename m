Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3KLG4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:56:39 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62144 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3KLG4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:56:30 -0500
In-Reply-To: <alpine.DEB.2.02.1311112052360.30673@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com> <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de> <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg> <alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de> <CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com> <alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de> <ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de> <CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com> <alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1311112031220.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1311112052360.30673@ionos.tec.linutronix.de>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <55642d365fc4272c4f43a88ea435e360@biophys.uni-duesseldorf.de>
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
Date: Tue, 12 Nov 2013 19:56:19 +1300
To: Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

>> Finally found the issue. The patch below fixes the problem here. The
>> little missing detail is, that I zapped GET_CURRENT() assuming blindly
>> that this is only needed for the preempt_count hackery. But in fact
>> the world and some more depends on it which leads to interesting
>> explosions.

Thanks for debugging this - I won't speculate on why we attempt to 
handle softirqs explicitly, as I have only a passing acquaintance with 
this code, many years back.

>
> Some more thoughts on this.
>
> The whole nesting check in the exisiting low level entry code and what
> I tried to resemble with the irq_exit_nested() is pretty pointless.
>
> Let's look at auto_inthandler and ret_from_exception
>
> ENTRY(auto_inthandler)
> 	SAVE_ALL_INT
> 	GET_CURRENT(%d0)
> 	movel	%d0,%a1
> 	addqb	#1,%a1@(TINFO_PREEMPT+1)
> 					|  put exception # in d0
> 	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
> 	subw	#VEC_SPUR,%d0
>
> 	movel	%sp,%sp@-
> 	movel	%d0,%sp@-		|  put vector # on stack
> auto_irqhandler_fixup = . + 2
> 	jsr	do_IRQ			|  process the IRQ
> 	addql	#8,%sp			|  pop parameters off stack
>
> ret_from_interrupt:
> 	movel	%curptr@(TASK_STACK),%a1
> 	subqb	#1,%a1@(TINFO_PREEMPT+1)
> 	jeq	ret_from_last_interrupt
> 2:	RESTORE_ALL
>
> 	ALIGN
> ret_from_last_interrupt:
> 	moveq	#(~ALLOWINT>>8)&0xff,%d0
> 	andb	%sp@(PT_OFF_SR),%d0
> 	jne	2b
>
> 	/* check if we need to do software interrupts */
> 	tstl	irq_stat+CPUSTAT_SOFTIRQ_PENDING
> 	jeq	.Lret_from_exception
> 	pea	ret_from_exception
> 	jra	do_softirq
>
>
> ENTRY(ret_from_exception)
> .Lret_from_exception:
> 	btst	#5,%sp@(PT_OFF_SR)	| check if returning to kernel
> 	bnes	1f			| if so, skip resched, signals
> 	....
> 1:	RESTORE_ALL
>
> So in every interrupt exit path we check:
>
>    1) Whether the hardirq part of preempt_count is zero
>
>    2) Whether the interrupt prio mask of SR on stack is zero
>
> and if we finally reach ret_from_exception we have the final check:
>
>    3) whether we return to kernel or user space.
>
> And this final check is the only one which matters, really.
>
> If you look at the probability of the first two checks catching
> anything, then it's pretty low. Most interrupts returns go through
> ret_from_exception. Yes, I added counters which prove that at least on
> the aranym, but I doubt that it will make a real difference if you run
> this on real hardware.

I'm happy to try that (indeed, verify your patch works on Atari 
hardware first) - I trust the patch is relative to m68k git, not your 
previous patches?

Cheers,


	Michael


>
> So what's the point of having these checks in the hotpath? The patch
> below against 3.12 vanilla works nicely on the aranym and I don't see
> a reason why this extra hackery is necessary at all. It's just code
> bloat in a hotpath.
>
> Now the only valid concern might be do_softirq itself, but that's
> pointless as well. If the softirq is interrupted, then we do not
> invoke it again. If the nested interrupt happens before irq_exit()
> actually disables interrupts, then we won't invoke it either as the
> hardirq part of preempt_count is still not zero.
>
> As a side note: The do_softirq calls in the platform/68xxx entry
> pathes are just copied leftovers as well. Both entry code pathes are
> not fiddling with the preempt count and both call do_IRQ() which will
> call irq_exit() at the end which will invoke do_softirq(), so the
> check for more softirqs in the irq return path is just pointless.
>
> Thanks,
>
> 	tglx
> ---
>  kernel/entry.S         |   40 ++++------------------------------------
>  kernel/ints.c          |    6 ------
>  platform/68000/entry.S |   33 ++++++++-------------------------
>  platform/68360/entry.S |   24 +++---------------------
>  4 files changed, 15 insertions(+), 88 deletions(-)
>
>
> Index: linux-2.6/arch/m68k/kernel/entry.S
> ===================================================================
> --- linux-2.6.orig/arch/m68k/kernel/entry.S
> +++ linux-2.6/arch/m68k/kernel/entry.S
> @@ -45,7 +45,7 @@
>  .globl system_call, buserr, trap, resume
>  .globl sys_call_table
>  .globl __sys_fork, __sys_clone, __sys_vfork
> -.globl ret_from_interrupt, bad_interrupt
> +.globl bad_interrupt
>  .globl auto_irqhandler_fixup
>  .globl user_irqvec_fixup
>
> @@ -275,8 +275,6 @@ do_delayed_trace:
>  ENTRY(auto_inthandler)
>  	SAVE_ALL_INT
>  	GET_CURRENT(%d0)
> -	movel	%d0,%a1
> -	addqb	#1,%a1@(TINFO_PREEMPT+1)
>  					|  put exception # in d0
>  	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
>  	subw	#VEC_SPUR,%d0
> @@ -286,32 +284,13 @@ ENTRY(auto_inthandler)
>  auto_irqhandler_fixup = . + 2
>  	jsr	do_IRQ			|  process the IRQ
>  	addql	#8,%sp			|  pop parameters off stack
> -
> -ret_from_interrupt:
> -	movel	%curptr@(TASK_STACK),%a1
> -	subqb	#1,%a1@(TINFO_PREEMPT+1)
> -	jeq	ret_from_last_interrupt
> -2:	RESTORE_ALL
> -
> -	ALIGN
> -ret_from_last_interrupt:
> -	moveq	#(~ALLOWINT>>8)&0xff,%d0
> -	andb	%sp@(PT_OFF_SR),%d0
> -	jne	2b
> -
> -	/* check if we need to do software interrupts */
> -	tstl	irq_stat+CPUSTAT_SOFTIRQ_PENDING
> -	jeq	.Lret_from_exception
> -	pea	ret_from_exception
> -	jra	do_softirq
> +	jra	ret_from_exception
>
>  /* Handler for user defined interrupt vectors */
>
>  ENTRY(user_inthandler)
>  	SAVE_ALL_INT
>  	GET_CURRENT(%d0)
> -	movel	%d0,%a1
> -	addqb	#1,%a1@(TINFO_PREEMPT+1)
>  					|  put exception # in d0
>  	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
>  user_irqvec_fixup = . + 2
> @@ -321,29 +300,18 @@ user_irqvec_fixup = . + 2
>  	movel	%d0,%sp@-		|  put vector # on stack
>  	jsr	do_IRQ			|  process the IRQ
>  	addql	#8,%sp			|  pop parameters off stack
> -
> -	movel	%curptr@(TASK_STACK),%a1
> -	subqb	#1,%a1@(TINFO_PREEMPT+1)
> -	jeq	ret_from_last_interrupt
> -	RESTORE_ALL
> +	jra	ret_from_exception
>
>  /* Handler for uninitialized and spurious interrupts */
>
>  ENTRY(bad_inthandler)
>  	SAVE_ALL_INT
>  	GET_CURRENT(%d0)
> -	movel	%d0,%a1
> -	addqb	#1,%a1@(TINFO_PREEMPT+1)
>
>  	movel	%sp,%sp@-
>  	jsr	handle_badint
>  	addql	#4,%sp
> -
> -	movel	%curptr@(TASK_STACK),%a1
> -	subqb	#1,%a1@(TINFO_PREEMPT+1)
> -	jeq	ret_from_last_interrupt
> -	RESTORE_ALL
> -
> +	jra	ret_from_exception
>
>  resume:
>  	/*
> Index: linux-2.6/arch/m68k/kernel/ints.c
> ===================================================================
> --- linux-2.6.orig/arch/m68k/kernel/ints.c
> +++ linux-2.6/arch/m68k/kernel/ints.c
> @@ -58,12 +58,6 @@ void __init init_IRQ(void)
>  {
>  	int i;
>
> -	/* assembly irq entry code relies on this... */
> -	if (HARDIRQ_MASK != 0x00ff0000) {
> -		extern void hardirq_mask_is_broken(void);
> -		hardirq_mask_is_broken();
> -	}
> -
>  	for (i = IRQ_AUTO_1; i <= IRQ_AUTO_7; i++)
>  		irq_set_chip_and_handler(i, &auto_irq_chip, handle_simple_irq);
>
> Index: linux-2.6/arch/m68k/platform/68000/entry.S
> ===================================================================
> --- linux-2.6.orig/arch/m68k/platform/68000/entry.S
> +++ linux-2.6/arch/m68k/platform/68000/entry.S
> @@ -27,7 +27,6 @@
>  .globl ret_from_exception
>  .globl ret_from_signal
>  .globl sys_call_table
> -.globl ret_from_interrupt
>  .globl bad_interrupt
>  .globl inthandler1
>  .globl inthandler2
> @@ -137,7 +136,7 @@ inthandler1:
>  	movel	#65,%sp@- 		/*  put vector # on stack*/
>  	jbsr	process_int		/*  process the IRQ*/
>  3:     	addql	#8,%sp			/*  pop parameters off stack*/
> -	bra	ret_from_interrupt
> +	bra	ret_from_exception
>
>  inthandler2:
>  	SAVE_ALL_INT
> @@ -148,7 +147,7 @@ inthandler2:
>  	movel	#66,%sp@- 		/*  put vector # on stack*/
>  	jbsr	process_int		/*  process the IRQ*/
>  3:     	addql	#8,%sp			/*  pop parameters off stack*/
> -	bra	ret_from_interrupt
> +	bra	ret_from_exception
>
>  inthandler3:
>  	SAVE_ALL_INT
> @@ -159,7 +158,7 @@ inthandler3:
>  	movel	#67,%sp@- 		/*  put vector # on stack*/
>  	jbsr	process_int		/*  process the IRQ*/
>  3:     	addql	#8,%sp			/*  pop parameters off stack*/
> -	bra	ret_from_interrupt
> +	bra	ret_from_exception
>
>  inthandler4:
>  	SAVE_ALL_INT
> @@ -170,7 +169,7 @@ inthandler4:
>  	movel	#68,%sp@- 		/*  put vector # on stack*/
>  	jbsr	process_int		/*  process the IRQ*/
>  3:     	addql	#8,%sp			/*  pop parameters off stack*/
> -	bra	ret_from_interrupt
> +	bra	ret_from_exception
>
>  inthandler5:
>  	SAVE_ALL_INT
> @@ -181,7 +180,7 @@ inthandler5:
>  	movel	#69,%sp@- 		/*  put vector # on stack*/
>  	jbsr	process_int		/*  process the IRQ*/
>  3:     	addql	#8,%sp			/*  pop parameters off stack*/
> -	bra	ret_from_interrupt
> +	bra	ret_from_exception
>
>  inthandler6:
>  	SAVE_ALL_INT
> @@ -192,7 +191,7 @@ inthandler6:
>  	movel	#70,%sp@- 		/*  put vector # on stack*/
>  	jbsr	process_int		/*  process the IRQ*/
>  3:     	addql	#8,%sp			/*  pop parameters off stack*/
> -	bra	ret_from_interrupt
> +	bra	ret_from_exception
>
>  inthandler7:
>  	SAVE_ALL_INT
> @@ -203,7 +202,7 @@ inthandler7:
>  	movel	#71,%sp@- 		/*  put vector # on stack*/
>  	jbsr	process_int		/*  process the IRQ*/
>  3:     	addql	#8,%sp			/*  pop parameters off stack*/
> -	bra	ret_from_interrupt
> +	bra	ret_from_exception
>
>  inthandler:
>  	SAVE_ALL_INT
> @@ -214,23 +213,7 @@ inthandler:
>  	movel	%d0,%sp@- 		/*  put vector # on stack*/
>  	jbsr	process_int		/*  process the IRQ*/
>  3:     	addql	#8,%sp			/*  pop parameters off stack*/
> -	bra	ret_from_interrupt
> -
> -ret_from_interrupt:
> -	jeq	1f
> -2:
> -	RESTORE_ALL
> -1:
> -	moveb	%sp@(PT_OFF_SR), %d0
> -	and	#7, %d0
> -	jhi	2b
> -
> -	/* check if we need to do software interrupts */
> -	jeq	ret_from_exception
> -
> -	pea	ret_from_exception
> -	jra	do_softirq
> -
> +	bra	ret_from_exception
>
>  /*
>   * Handler for uninitialized and spurious interrupts.
> Index: linux-2.6/arch/m68k/platform/68360/entry.S
> ===================================================================
> --- linux-2.6.orig/arch/m68k/platform/68360/entry.S
> +++ linux-2.6/arch/m68k/platform/68360/entry.S
> @@ -29,7 +29,6 @@
>  .globl ret_from_exception
>  .globl ret_from_signal
>  .globl sys_call_table
> -.globl ret_from_interrupt
>  .globl bad_interrupt
>  .globl inthandler
>
> @@ -132,26 +131,9 @@ inthandler:
>
>  	movel	%sp,%sp@-
>  	movel	%d0,%sp@- 		/*  put vector # on stack*/
> -	jbsr	do_IRQ			/*  process the IRQ*/
> -3:     	addql	#8,%sp			/*  pop parameters off stack*/
> -	bra	ret_from_interrupt
> -
> -ret_from_interrupt:
> -	jeq	1f
> -2:
> -	RESTORE_ALL
> -1:
> -	moveb	%sp@(PT_OFF_SR), %d0
> -	and	#7, %d0
> -	jhi	2b
> -	/* check if we need to do software interrupts */
> -
> -	movel	irq_stat+CPUSTAT_SOFTIRQ_PENDING,%d0
> -	jeq	ret_from_exception
> -
> -	pea	ret_from_exception
> -	jra	do_softirq
> -
> +	jbsr	do_IRQ			/*  process the IRQ */
> +	addql	#8,%sp			/*  pop parameters off stack*/
> +	jra	ret_from_exception
>
>  /*
>   * Handler for uninitialized and spurious interrupts.
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

