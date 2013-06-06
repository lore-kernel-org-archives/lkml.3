Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3FFBfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:35:05 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46829 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab3FFBfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:35:01 -0400
Message-ID: <1370482492.24311.308.camel@edumazet-glaptop>
Subject: Re: stop_machine lockup issue in 3.9.y.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Date: Wed, 05 Jun 2013 18:34:52 -0700
In-Reply-To: <20130605211157.GK10693@mtj.dyndns.org>
References: <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com>
	 <51AE1B81.20900@candelatech.com> <51AE27D5.7050202@candelatech.com>
	 <87sj0xry1k.fsf@rustcorp.com.au> <20130605071539.GA3429@mtj.dyndns.org>
	 <51AF6E54.3050108@candelatech.com> <20130605184807.GD10693@mtj.dyndns.org>
	 <51AF8D4B.4090407@candelatech.com> <51AF91F5.6090801@candelatech.com>
	 <51AFA677.9010605@candelatech.com> <20130605211157.GK10693@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 14:11 -0700, Tejun Heo wrote:
> (cc'ing wireless crowd, tglx and Ingo.  The original thread is at
>  http://thread.gmane.org/gmane.linux.kernel/1500158/focus=55005 )
> 
> Hello, Ben.
> 
> On Wed, Jun 05, 2013 at 01:58:31PM -0700, Ben Greear wrote:
> > Hmm, wonder if I found it.  I previously saw times where it appears
> > jiffies does not increment.  __do_softirq has a break-out based on
> > jiffies timeout.  Maybe that is failing to get us out of __do_softirq
> > in my lockup case because for whatever reason the system cannot update
> > jiffies in this case?
> > 
> > I added this (probably whitespace damaged) hack and now I have not been
> > able to reproduce the problem.
> 
> Ah, nice catch. :)
> 
> > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > index 14d7758..621ea3b 100644
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> > @@ -212,6 +212,7 @@ asmlinkage void __do_softirq(void)
> >         unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
> >         int cpu;
> >         unsigned long old_flags = current->flags;
> > +       unsigned long loops = 0;
> > 
> >         /*
> >          * Mask out PF_MEMALLOC s current task context is borrowed for the
> > @@ -241,6 +242,7 @@ restart:
> >                         unsigned int vec_nr = h - softirq_vec;
> >                         int prev_count = preempt_count();
> > 
> > +                       loops++;
> >                         kstat_incr_softirqs_this_cpu(vec_nr);
> > 
> >                         trace_softirq_entry(vec_nr);
> > @@ -265,7 +267,7 @@ restart:
> > 
> >         pending = local_softirq_pending();
> >         if (pending) {
> > -               if (time_before(jiffies, end) && !need_resched())
> > +               if (time_before(jiffies, end) && !need_resched() && (loops < 500))
> >                         goto restart;
> 
> So, softirq most likely kicked off from ath9k is rescheduling itself
> to the extent where it ends up locking out the CPU completely.  The
> problem is usually okay because the processing would break out in 2ms
> but as jiffies is stopped in this case with all other CPUs trapped in
> stop_machine, the loop never breaks and the machine hangs.  While
> adding the counter limit probably isn't a bad idea, softirq requeueing
> itself indefinitely sounds pretty buggy.
> 
> ath9k people, do you guys have any idea what's going on?  Why would
> softirq repeat itself indefinitely?
> 
> Ingo, Thomas, we're seeing a stop_machine hanging because
> 
> * All other CPUs entered IRQ disabled stage.  Jiffies is not being
>   updated.
> 
> * The last CPU get caught up executing softirq indefinitely.  As
>   jiffies doesn't get updated, it never breaks out of softirq
>   handling.  This is a deadlock.  This CPU won't break out of softirq
>   handling unless jiffies is updated and other CPUs can't do anything
>   until this CPU enters the same stop_machine stage.
> 
> Ben found out that breaking out of softirq handling after certain
> number of repetitions makes the issue go away, which isn't a proper
> fix but we might want anyway.  What do you guys think?
> 

Interesting....

Before 3.9 and commit c10d73671ad30f5469
("softirq: reduce latencies") we used to limit the __do_softirq() loop
to 10.



