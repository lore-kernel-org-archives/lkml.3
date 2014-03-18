Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaCROmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbaCROmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:42:21 -0400
Date: Tue, 18 Mar 2014 10:42:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Aaron Tomlin <atomlin@redhat.com>
Subject: Re: [PATCH] watchdog: Printing traces for all cpus on lockup
 detection
Message-ID: <20140318144212.GS25953@redhat.com>
References: <1395083405-3091-1-git-send-email-dzickus@redhat.com>
 <20140317143207.a9a0ed19e8fb4bc567667675@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317143207.a9a0ed19e8fb4bc567667675@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 02:32:07PM -0700, Andrew Morton wrote:
> On Mon, 17 Mar 2014 15:10:05 -0400 Don Zickus <dzickus@redhat.com> wrote:
> 
> > From: Aaron Tomlin <atomlin@redhat.com>
> > 
> > A 'softlockup' is defined as a bug that causes the kernel to
> > loop in kernel mode for more than a predefined period to
> > time, without giving other tasks a chance to run.
> > 
> > Currently, upon detection of this condition by the per-cpu
> > watchdog task, debug information (including a stack trace)
> > is sent to the system log.
> > 
> > On some occasions, we have observed that the "victim" rather
> > than the actual "culprit" (i.e. the owner/holder of the
> > contended resource) is reported to the user.
> > Often this information has proven to be insufficient to
> > assist debugging efforts.
> > 
> > To avoid loss of useful debug information, for architectures
> > which support NMI, this patch makes it possible to improve
> > soft lockup reporting. This is accomplished by issuing an
> > NMI to each cpu to obtain a stack trace.
> > 
> > If NMI is not supported we just revert back to the old method.
> > A sysctl and boot-time parameter is available to toggle this
> > feature.
> > 
> > [updated kernel-parameters.txt too]
> 
> Is a bit like
> http://ozlabs.org/~akpm/mmots/broken-out/watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch.
> Please compare and comment.  I've been sitting on that patch for over
> a year because I thought it would cause double-traces on uniprocessor
> and nothing happened about that.

The patch is similar.  The difference is Aaron's patch is focused on
all softlockups, whereas your 'queued' patch focuses on both hardlockup
and softlockup for the panic case only.

There are a lot of folks that do not want to panic on a softlockup as they
tend to be 'false' positives (virt especially).  So your 'queued' patch
won't help there, but Aaron's will.

I was debating about just enabling it for all cases but wasn't sure if
that is to much splat (then again rcu does this and has been oddly helpful
in debugging softlockups/hardlockups).


As for the double traces, I would assume the double-trace would not be
limited to uniprocessor but to smp machines too.  I can double check that.

> 
> >  Documentation/kernel-parameters.txt |    5 +++++
> >  Documentation/sysctl/kernel.txt     |   17 +++++++++++++++++
> >  include/linux/nmi.h                 |    1 +
> >  kernel/sysctl.c                     |    9 +++++++++
> >  kernel/watchdog.c                   |   35 +++++++++++++++++++++++++++++++++++
> 
> Patch adds a whole bunch of useless stuff to uniprocessor builds.
> 
> > +int __read_mostly softlockup_all_cpu_backtrace = 0;
> 
> "= 0" is implicit.
> 
> There's a poorly-followed convention of prefixing things like this with
> "sysctl_", to make it clear that this is a userspace-controlled option.
> It's quite a useful thing.

Ok.

> 
> >  static int __read_mostly watchdog_running;
> >  static u64 __read_mostly sample_period;
> >  
> > @@ -47,6 +48,7 @@ static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
> >  static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
> >  static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
> >  #endif
> > +static unsigned long soft_lockup_nmi_warn;
> 
> This could be local to watchdog_timer_fn()
> 
> What does it do, anyway?  The name is unilluminating.  A comment would
> be nice.

Ah, yes.  Good point.  It is just a way to prevent multiple softlockup
BUG_ONs from happening while the backtrace code is dumping.

Perhaps leveraging trigger_all_cpu_backtrace, I can remove some of the
current stack dumping and this variable.

> 
> >  /* boot commands */
> >  /*
> > @@ -95,6 +97,20 @@ static int __init nosoftlockup_setup(char *str)
> >  }
> >  __setup("nosoftlockup", nosoftlockup_setup);
> >  /*  */
> > +static int __init softlockup_all_cpu_backtrace_setup(char *str)
> > +{
> > +	if (!str)
> > +		return -EINVAL;
> > +
> > +	softlockup_all_cpu_backtrace = simple_strtoul(str, NULL, 0);
> > +
> > +	if (softlockup_all_cpu_backtrace < 0 ||
> > +		softlockup_all_cpu_backtrace > 1)
> > +		return -EINVAL;
> 
> We've just successfully modified `softlockup_all_cpu_backtrace'!  It's
> too late to check for errors.

Let me convert that to a boolean then.  Easier to be just an on/off
switch.

> 
> > +	return 1;
> > +}
> > +__setup("softlockup_all_cpu_backtrace=", softlockup_all_cpu_backtrace_setup);
> >  
> >  /*
> >   * Hard-lockup warnings should be triggered after just a few seconds. Soft-
> > @@ -313,6 +329,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
> >  		if (__this_cpu_read(soft_watchdog_warn) == true)
> >  			return HRTIMER_RESTART;
> >  
> > +		if (softlockup_all_cpu_backtrace) {
> > +			if (test_and_set_bit(0, &soft_lockup_nmi_warn)) {
> > +				/* Someone else will report us. Let's give up */
> > +				__this_cpu_write(soft_watchdog_warn, true);
> > +				return HRTIMER_RESTART;
> > +			}
> > +		}
> > +
> >  		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
> >  			smp_processor_id(), duration,
> >  			current->comm, task_pid_nr(current));
> > @@ -323,6 +347,17 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
> >  		else
> >  			dump_stack();
> >  
> > +		if (softlockup_all_cpu_backtrace) {
> > +			/* Inject an NMI to gather a stack trace for
> > +			 * each cpu in the hope to obtain further
> > +			 * debug information
> > +			 */
> 
> That's pretty poor comment, sorry.  It tells us "what", not "why".  And
> what it's saying was very obvious anyway.
> 
> > +			trigger_all_cpu_backtrace();
> > +
> > +			clear_bit(0, &soft_lockup_nmi_warn);
> > +			smp_mb__after_clear_bit();
> > +		}
> 
> I'm surely having a stupid day, but it's taking far too long for me to
> work out what this code does.  What's with this flag in
> soft_lockup_nmi_warn?  What's it doing?
> 
> And why is that barrier there?  What's it barriering against?  Barriers
> should always be commented, please.

The 'soft_lockup_nmi_warn' flag was supposed to block multiple cpus from
BUG_ON at the similar times while dump cpu backtraces.  The
smp_mb__after_clear_bit() was supposedly the recommend way of flushing a
clear_bit.  I can add a comment.

> 
> >  		if (softlockup_panic)
> >  			panic("softlockup: hung tasks");
> >  		__this_cpu_write(soft_watchdog_warn, true);
> 
> We forgot to document arch_trigger_all_cpu_backtrace().  It's
> actually arch_trigger_all_other_cpus_backtrace, yes?  So we don't
> generate two backtraces for the current cpu?

Hmm, reading arch/x86/kernel/apic/hw_nmi.c seems to imply that it is sent
to all cpus, so yes two backtraces would be seen.  Let me go verify
everything.

Thanks for the review.  Sorry for the noise.

Cheers,
Don

> 
