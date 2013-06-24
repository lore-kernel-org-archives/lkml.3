Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3FXRxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:53:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12425 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3FXRxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:53:13 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=jrPFXV8vUeqebAMb8gMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372096391.18733.177.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Mon, 24 Jun 2013 13:53:11 -0400
In-Reply-To: <20130624173510.GA1321@redhat.com>
References: <20130620161652.GA4462@linux.vnet.ibm.com>
	 <20130621151119.GA1596@redhat.com> <20130621195949.GA15519@redhat.com>
	 <20130622013731.GA22918@redhat.com> <20130622173129.GA29375@redhat.com>
	 <20130622215905.GA28238@redhat.com> <20130623143634.GA2000@redhat.com>
	 <20130623150603.GA32313@redhat.com> <20130623160452.GA11740@redhat.com>
	 <20130624155758.GA5993@redhat.com> <20130624173510.GA1321@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 19:35 +0200, Oleg Nesterov wrote:
> On 06/24, Dave Jones wrote:
> >
> > On Sun, Jun 23, 2013 at 06:04:52PM +0200, Oleg Nesterov wrote:
> >  >
> >  > Could you please do the following:
> >  >
> >  > 	1. # cd /sys/kernel/debug/tracing
> >  > 	   # echo 0 >> options/function-trace
> >  > 	   # echo preemptirqsoff >> current_tracer
> >  >
> >  > 	2. reproduce the lockup again
> >  >
> >  > 	3. show the result of
> >  > 	   # cat trace
> >
> > Not sure this is helpful, but..
> 
> This makes me think that something is seriously broken.
> 
> Or I do not understand this stuff at all. Quite possible too.
> Steven, could you please help?
> 
> > # preemptirqsoff latency trace v1.1.5 on 3.10.0-rc7+
> > # --------------------------------------------------------------------
> > # latency: 165015310 us, #4/4, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> 
> OK, 165015310/1000000 = 165, nice.

9600 baud modem serial console?

> 
> > #    -----------------
> > #    | task: trinity-child1-3173 (uid:1000 nice:19 policy:0 rt_prio:0)
> > #    -----------------
> > #  => started at: vprintk_emit
> > #  => ended at:   vprintk_emit
> > #
> > #
> > #                  _------=> CPU#
> > #                 / _-----=> irqs-off
> > #                | / _----=> need-resched
> > #                || / _---=> hardirq/softirq
> > #                ||| / _--=> preempt-depth
> > #                |||| /     delay
> > #  cmd     pid   ||||| time  |   caller
> > #     \   /      |||||  \    |   /
> > trinity--3173    1dNh1    0us!: console_unlock <-vprintk_emit
> > trinity--3173    1dNh1 165015310us : console_unlock <-vprintk_emit
> > trinity--3173    1dNh1 165015311us+: stop_critical_timings <-vprintk_emit
> > trinity--3173    1dNh1 165015315us : <stack trace>
> >  => console_unlock
> >  => vprintk_emit
> >  => printk
> >  => watchdog_timer_fn
> 
> But this is already called in the non-preemtible context, how can
> 'started at' blame vprintk_emit?

Well, it looks to really have started with console_unlock() not
vprintk_emit.

> 
> >  => __run_hrtimer
> >  => hrtimer_interrupt
> >  => smp_apic_timer_interrupt
> >  => apic_timer_interrupt
> >  => _raw_spin_lock
> 
> This is where start_critical_timing() should be called?
> 
> Or by TRACE_IRQS_OFF in apic_timer_interrupt...

Also, what _raw_spin_lock is that. Unless the interrupt triggered at the
start of the completion spin lock (before it disabled interrupts), it
could have happened while spinning on inode_sb_list_lock?

But you are correct, the critical timing should have started with the
entering of smp_apic_timer_interrupt. Did anything re-enable interrupts?


> 
> >  => sync_inodes_sb
> >  => sync_inodes_one_sb
> >  => iterate_supers
> >  => sys_sync
> >  => tracesys
> 
> Also. watchdog_timer_fn() calls printk() only if it detects the
> lockup, so I assume you hit another one?

Probably.

-- Steve


