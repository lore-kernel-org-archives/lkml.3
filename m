Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaAPPwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:52:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbaAPPwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:52:30 -0500
Date: Thu, 16 Jan 2014 16:52:26 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] printk: Hand over printing to console if printing
 too long
Message-ID: <20140116155226.GB2662@quack.suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-10-git-send-email-jack@suse.cz>
 <20140115142347.34a3239184a989df141154f2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115142347.34a3239184a989df141154f2@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-01-14 14:23:47, Andrew Morton wrote:
> On Mon, 23 Dec 2013 21:39:30 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > Currently, console_unlock() prints messages from kernel printk buffer to
> > console while the buffer is non-empty. When serial console is attached,
> > printing is slow and thus other CPUs in the system have plenty of time
> > to append new messages to the buffer while one CPU is printing. Thus the
> > CPU can spend unbounded amount of time doing printing in console_unlock().
> > This is especially serious problem if the printk() calling
> > console_unlock() was called with interrupts disabled.
> > 
> > In practice users have observed a CPU can spend tens of seconds printing
> > in console_unlock() (usually during boot when hundreds of SCSI devices
> > are discovered) resulting in RCU stalls (CPU doing printing doesn't
> > reach quiescent state for a long time), softlockup reports (IPIs for the
> > printing CPU don't get served and thus other CPUs are spinning waiting
> > for the printing CPU to process IPIs), and eventually a machine death
> > (as messages from stalls and lockups append to printk buffer faster than
> > we are able to print). So these machines are unable to boot with serial
> > console attached. Also during artificial stress testing SATA disk
> > disappears from the system because its interrupts aren't served for too
> > long.
> > 
> > This patch implements a mechanism where after printing specified number
> > of characters (tunable as a kernel parameter printk.offload_chars), CPU
> > doing printing asks for help by setting a 'hand over' state. The CPU
> > still keeps printing until another CPU running printk() or a CPU being
> > pinged by an IPI comes and takes over printing.  This way no CPU should
> > spend printing too long if there is heavy printk traffic.
> > 
> > ...
> >
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -84,6 +84,45 @@ static DEFINE_SEMAPHORE(console_sem);
> >  struct console *console_drivers;
> >  EXPORT_SYMBOL_GPL(console_drivers);
> >  
> > +/*
> > + * State of printing to console.
> > + * 0 - noone is printing
> > + * 1 - the CPU doing printing is happy doing so
> > + * 2 - the printing CPU wants some other CPU to take over
> > + * 3 - some CPU is waiting to take over printing
> > + *
> > + * Allowed state transitions are:
> > + * 0 -> 1, 1 -> 0, 1 -> 2, 2 -> 0, 2 -> 3, 3 -> 0
> > + * All state transitions except for 2 -> 3 are done by the holder of
> > + * console_sem. Transition 2 -> 3 happens using cmpxchg from a task not owning
> > + * console_sem. Thus it can race with other state transitions from state 2.
> > + * However these races are harmless since the only transition we can race with
> > + * is 2 -> 0. If cmpxchg comes after we have moved from state 2, it does
> > + * nothing and we end in state 0. If cmpxchg comes before, we end in state 0 as
> > + * desired.
> > + */
> 
> This comment is great, but would be much better if "0"-"3" were
> replaced with their PS_foo representations.
  Sure, will do.

> The locking issue is regrettable.  What's the problem with getting full
> console_sem coverage?
>
> The mixture of cmpxchg with non-atomic reads and writes makes things
> significantly more difficult.
  Yes, I understand. The thing is you need a way for a CPU to say "I'm here
to help you, please release console_sem". Clearly this cannot happen under
console_sem. But now when I look at it from distance, there are two ways how
we can make the protocol more standard:
1) protect printing_state by a dedicated spinlock. That makes everything
rather standard although more heavy weight.
2) use a separate bool variable to indicate someone is spinning on
   console_sem. I guess I'll go for this.

> > +static enum {
> > +	PS_NONE,
> > +	PS_PRINTING,
> > +	PS_HANDOVER,
> > +	PS_WAITING
> > +} printing_state;
> > +/* CPU which is handing over printing */
> > +static unsigned int hand_over_cpu;
> > +/*
> > + * Structure for IPI to hand printing to another CPU. We have actually two
> > + * structures for the case we need to send IPI from an IPI handler...
> > + */
> > +static void printk_take_over(void *info);
> > +static struct call_single_data hand_over_csd[2] = {
> > +	{ .func = printk_take_over, },
> > +	{ .func = printk_take_over, }
> > +};
> > +/* Index of csd to use for sending IPI now */
> > +static int current_csd;
> 
> Locking for this?
  console_sem.

> > +/* Set if there is IPI pending to take over printing */
> > +static bool printk_ipi_sent;
> 
> And this?
  Good question, this deserves documentation if nothing else. Since the
variable is bool, reads & writes of it are atomic. So it's really only
about the value of the variable matching the fact whether we sent IPI
asking for help or not. And that is achieved by:
  * setting printk_ipi_sent to true only if is is currently false and doing
    that under console_sem
  * setting printk_ipi_sent to false only from IPI handler of that IPI.
    Since we always send the IPI to at most one CPU, this setting cannot
    race.

> >  #ifdef CONFIG_LOCKDEP
> >  static struct lockdep_map console_lock_dep_map = {
> >  	.name = "console_lock"
> > 
> > ...
> >
> > @@ -1342,8 +1393,40 @@ static int console_trylock_for_printk(void)
> >  {
> >  	unsigned int cpu = smp_processor_id();
> >  
> > -	if (!console_trylock())
> > -		return 0;
> > +	if (!console_trylock()) {
> > +		int state;
> > +
> > +		if (printing_state != PS_HANDOVER || console_suspended)
> > +			return 0;
> > +		smp_rmb();	/* Paired with smp_wmb() in cpu_stop_printing */
> > +		/*
> > +		 * Avoid deadlocks when CPU holding console_sem takes an
> > +		 * interrupt which does printk.
> > +		 */
> > +		if (hand_over_cpu == cpu)
> > +			return 0;
> > +
> > +		state = cmpxchg(&printing_state, PS_HANDOVER, PS_WAITING);
> > +		if (state != PS_HANDOVER)
> > +			return 0;
> > +
> > +		/*
> > +		 * Since PS_HANDOVER state is set only in console_unlock()
> > +		 * we shouldn't spin for long here.
> 
> "shouldn't" is ambiguous here.  Suggest replacing it with "won't".
  OK.

> >		    And we cannot sleep because
> > +		 * the printk() might be called from atomic context.
> > +		 */
> 
> console_trylock_for_printk() is called under logbuf_lock, isn't it? 
> We're atomic here regardless of the printk() caller's state.  That's
> why smp_processor_id() was OK.
  Preceding patches in this series changed vprintk_emit() to unlock
logbuf_lock and enable interrupts (well, local_irq_restore()) before
calling into console_trylock_for_printk() and console_unlock(). So we
should run in the same locking context in which printk() was called.

Sadly that isn't a solution to lockup problems (tested - most notably
because the system dies if RCU period doesn't happen often enough on every
CPU) but it should help to significantly reduce irq latencies on average.

> > +		while (!console_trylock()) {
> > +			if (console_suspended)
> > +				return 0;
> > +			/*
> > +			 * Someone else took console_sem? Exit as we don't want
> > +			 * to spin for a long time here.
> > +			 */
> > +			if (ACCESS_ONCE(printing_state) == PS_PRINTING)
> 
> Is this appropriate use of ACCESS_ONCE?  What is the ACCESS_ONCE()
> trying to achieve?
  I wanted to force compiler to reload printing_state variable on each loop
iteration. But maybe I'm completely wrong and it isn't needed here. Or
maybe something else should be here? It just seemed to me that without
anything, compiler could "optimize" the loop to do the check just during
the first iteration.

> > +				return 0;
> > +			__delay(1);
> > +		}
> > +	}
> >  	/*
> >  	 * If we can't use the console, we need to release the console
> >  	 * semaphore by hand to avoid flushing the buffer. We need to hold the
> > 
> > ...
> >
> > @@ -2005,15 +2091,77 @@ out:
> >  	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
> >  }
> >  
> > +/* Handler for IPI to take over printing from another CPU */
> > +static void printk_take_over(void *info)
> > +{
> > +	/*
> > +	 * We have to clear printk_ipi_sent only after we succeed / fail the
> > +	 * trylock. That way we make sure there is at most one IPI spinning
> > +	 * on console_sem and thus we cannot deadlock on csd_lock
> > +	 */
> > +	if (console_trylock_for_printk()) {
> 
> erk, scared.  We're in interrupt and console_trylock_for_printk() can
> loop for arbitrarily long durations.  printk_take_over() is called
> asynchronously and the system could be in any state at all.
  So what mechanism would you prefer to use to ask for help (and as you
noted in your previous mail, we need some mechanism to not rely on luck
that someone calls printk()). The options I see are:
1) raw IPI as in this patch.
   + simple lockless code to send IPI
   - there is a trouble that if your are printing from IPI and want to send
     IPI to another CPU to take over printing, you need a separate CSD
     structure to avoid deadlocking on csd_lock
   - runs in interrupt context
2) irq_work - rather similar to raw IPI although you get slightly less raw
   interface for slightly more complex code so you might need to be more
   careful to avoid trouble.
3) normal work
   + you run in normal context
   - the code isn't lockless anymore so if there is printk() in that code
     (currently there isn't) we have to be *really* careful to avoid
     deadlocks
   - similarly to IPI you will need more work structs to avoid problems
     due to reentering works (possibly deadlocks on pwq->pool->lock,
     certainly you would end up executing the work always on the same CPU).
4) separate kernel threads just for taking over printing
   + you run in normal context
   + you don't need any special locking
   - you have these additional threads lurking on the system mostly doing
     nothing

Pick your poison... Thoughts?

> > +		printk_ipi_sent = false;
> > +		/* Switch csd as the current one is locked until we finish */
> > +		current_csd ^= 1;
> 
> So current_csd is protected by console_sem?  As is printk_ipi_sent?
  Answered above.

> > +		console_unlock();
> 
> So it's via this console_unlock() that the current CPU starts printing?
> Within IPI context?  It's worth documenting this a bit.
  Yes, I will add documentation.

> > +	} else
> > +		printk_ipi_sent = false;
> > +}
> > +
> > +/*
> > + * Returns true iff there is other cpu waiting to take over printing. This
> > + * function also takes are of changing printing_state if we want to hand over
> 
> "care"
> 
> > + * printing to some other cpu.
> > + */
> > +static bool cpu_stop_printing(int printed_chars)
> > +{
> > +	cpumask_var_t mask;
> > +
> > +	/* Oops? Print everything now to maximize chances user will see it */
> > +	if (oops_in_progress)
> > +		return false;
> > +	/* Someone is waiting. Stop printing. */
> > +	if (printing_state == PS_WAITING)
> > +		return true;
> > +	if (!printk_offload_chars || printed_chars <= printk_offload_chars)
> 
> Off-by-one?  Should that be "<"?
  Doesn't really matter... but yes.

> > +		return false;
> > +	if (printing_state == PS_PRINTING) {
> > +		hand_over_cpu = smp_processor_id();
> > +		/* Paired with smp_rmb() in console_trylock_for_printk() */
> > +		smp_wmb();
> > +		printing_state = PS_HANDOVER;
> 
> So console_sem must be held by the caller?  Worth documenting this.
  OK.

> Again, the race with cmpxchg is worrisome.  Perhaps document its
> (non-)effects here?
  I'll see if using separate bool (and thus avoiding cmpxchg) will make
things more obvious. And add some documentation here.

> > +		return false;
> > +	}
> > +	/*
> > +	 * We ping another CPU with IPI only if noone took over printing for a
> > +	 * long time - we prefer other printk() to take over printing since it
> > +	 * has chances to happen from a better context than IPI handler.
> > +	 */
> > +	if (!printk_ipi_sent && printed_chars > 2 * printk_offload_chars) {
> 
> What is the "2 *" doing?  I don't recall seeing a description of this.
  Yeah, I should describe this somewhere more highlevel than in this
comment. As the comment describes, IPI isn't really a good context to do
printing from (unknown locks held, interrupts disabled on the cpu) so we
want to use it only as a last resort. If we send IPI immediately after
printing printk_offload_chars, there is really low chance another printk()
will take over printing - IPI will be almost always faster. So we have an
interval between printing printk_offload_chars and 2 * printk_offload_chars
where we ask for help but don't send the IPI yet.

> > +		struct call_single_data *csd = &hand_over_csd[current_csd];
> 
> I didn't really understand why we need two call_single_data's.
  The thing is: while IPI is executing, call_single_data structure is
locked. So if we are printing from the IPI and want to ask for help, we
cannot really use the call_single_data structure which was used to send IPI
we are running. That's why we have to have at least two...

> > +
> > +		/* Ping another cpu to take printing from us */
> > +		cpumask_copy(mask, cpu_online_mask);
> > +		cpumask_clear_cpu(hand_over_cpu, mask);
> > +		if (!cpumask_empty(mask)) {
> 
> So what happens if this was the only online CPU?  We blow a chunk of
> CPU time in cpu_stop_printing() for each printed char?  Not a problem I
> guess.
  For every printed line, yes. But the thing is that on single CPU system
you do not really accumulate large backlog in the printk buffer (I presume
interrupts are the only way to accumulate any backlog) so you never get
here. Well, sysrq-t is one special case and cpu hotplug another but these are
cornercases I'm willing to dismiss.

> > +			printk_ipi_sent = true;
> > +			__smp_call_function_any(mask, csd, 0);
> 
> The IPI is sent to all other online CPUs.  I wonder if that was overkill.
  No, it is sent to 'any other online CPU' - we pick one and send IPI
there.

Thanks for review!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
