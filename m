Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaLCXeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:34:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:56143 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLCXeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:34:11 -0500
Date: Thu, 4 Dec 2014 00:34:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Thorlton <athorlton@sgi.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Fabian Frederick <fabf@skynet.be>, Ingo Molnar <mingo@kernel.org>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [BUG] Possible locking issues in stop_machine code on 6k core
 machine
In-Reply-To: <20141203204048.GJ4720@sgi.com>
Message-ID: <alpine.DEB.2.11.1412032330510.16275@nanos>
References: <20141203204048.GJ4720@sgi.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

first of all, could you please format your mail so it is actually
readable and can be replied to? This looks like copy and paste from a
office app with about 5 gazillion spaces at the end of each line. I
have no idea how you tricked mutt to do that.

On Wed, 3 Dec 2014, Alex Thorlton wrote:

> While working to get our newly upgraded 6k core machine online,
> we've discovered a few possible locking issues in the stop_machine
> code that we're trying to get sorted out.  (We think) the problems
> we're seeing stem from possible interaction between stop_cpus and
> stop_one_cpu.  The issue presents as a deadlock, and seems to only
> show itself intermittently.

> After quite a bit of debugging we think we've narrowed the issue
> down to the fact that stop_one_cpu does not respect many of the
> locks that are taken in the stop_cpus code path.  For reference the
> stop_cpus code path takes the stop_cpus_mutex, then stop_cpus_lock,
> and then takes each cpu's stopper->lock.  stop_one_cpu seems to rely
> solely on the stopper->lock.

And what's actually wrong with that?

stop_cpus()
  mutex_lock(&stop_cpus_mutex);
  __stop_cpus()
    cpu_stop_init_done(); <-- works on a stack variable
    queue_stop_cpus_work()
      for_each_cpu()
        per_cpu(stop_cpus_work, cpu)
	        ^^^^ is a static per cpu work struct protected by
		     stop_cpus_mutex

      /* Now we have to queue that work for real */
      lg_global_lock(&stop_cpus_lock);
      for_each_cpu(cpu, cpumask)
      	cpu_stop_queue_work(cpu ...)
	  lock(per_cpu(stopper_lock, cpu);
	  list_add_tail(work, per_cpu(worklist, cpu);
	  unlock(per_cpu(stopper_lock, cpu);
      lg_global_unlock(&stop_cpus_lock);
	    
stop_one_cpu()
  cpu_stop_init_done(&done, 1); <-- works on a stack variable
  cpu_stop_queue_work(cpu, &work); <-- work is on stack
  wait_for_completion(&done.completion);

So stop_cpus() operates on static allocated per cpu cpu_stop_work. The
work->done of each per cpu work points to cpu_stop_done which is on
the stack of the caller. Nothing can stomp on the per_cpu work as long
as stop_cpus_mutex is held. Nothing can stomp on the done struct which
is on the stack of the caller and only referenced by the cpu work.

stop_one_cpu() has both the work and the done on the callers stack. So
it does neither need to take the stop_cpus_mutex nor the
stop_cpus_lock lglock. All it requires is the per cpu stopper->lock to
add the work to the per cpu list of the target cpu.

> What appears to be happening to cause our deadlock is, stop_cpus
> works its way down to queue_stop_cpus_work, which tells each cpu's
> stopper task to wake up, take its lock, and do its work.  As the
> loop that does this progresses, the lowest numbered cpus complete
> their work, and are allowed to go on about their business.  The
> problem occurs when one of these lower numbered cpus calls
> stop_one_cpu, targeting one of the higher numbered cpus, which the
> stop_cpus loop has not yet reached.  If this happens, that higher
> numbered cpu's completion variable will get stomped on, and the
> wait_for_completion in the stop_cpus code path will never return.

That's complete nonsense. It CANNOT stomp on the completion variable
of a higher numbered cpu, because there is no such variable.

Lets look at a single CPU:

     The per cpu struct cpu_stopper has work A (from
     stop_cpus) queued.

     A looks like this:

     A->fn   = stop_cpus(fn);
     A->arg  = stop_cpus(arg);
     A->done = struct cpu_stop_done on the stack of the stop_cpus() caller

     Now B gets queued:

     B looks like this:

     B->fn   = stop_one_cpu(fn);
     B->arg  = stop_one_cpu(arg);
     B->done = struct cpu_stop_done on the stack of the stop_one_cpu() caller

     The only connection between A and B is that they are enqueued on
     the same list, i.e. the er cpu struct cpu_stopper::works list.

So now explain, how the enqueueing of B stomps on A->done. There is no
way that the list_add_tail(B) can modify A->done.

Again. This are the protection scopes:

 stop_cpus_mutex protects stop_cpus_work

   It is held across the stop_cpus() call until the
   wait__for_completion() returns. So nothing can stomp on
   stop_cpus_work and the done pointer of any cpu until
   stop_cpus_mutex is released.
 
 stop_cpus_lock serializes multi_cpu_stop invocations

   You have not provided any indication that multi_cpu_stop is
   involved, so that's irrelevant.

 stopper->lock protects the per cpu work list

> Again, much of this is semi-educated guesswork, put together based

I'd say semi-educated guesswork is a euphemism.

> on information gathered from examining lots of debug output, in an
> attempt to spot the problem. 

Of course you completely missed to provide the actual call chains and
callback functions involved. Instead of that you provide your
interpretation of the problem, which seems to be a bit off.

> We're fairly certain that we've pinned down our issue,

I'm very certain that your interpretation of lots of debug output is
pretty much in line with your creative description of the problem.

> but we'd like to ask those who are more knowledgeable of these code
> paths to weigh in their opinions here.

Done. 

> We'd really appreciate any help that anyone can offer.  Thanks!

If you would provide real data instead of half baken assumptions
we might actually be able to help you.

There might be some hidden issue in the stomp machine crap, but surely
not the one you described.

Thanks,

	tglx
