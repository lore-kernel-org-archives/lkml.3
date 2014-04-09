Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbaDIObo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:31:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:13270 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932761AbaDIObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:31:43 -0400
Date: Wed, 9 Apr 2014 10:31:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20140409103138.29be16b9@gandalf.local.home>
In-Reply-To: <CAOh2x=koQ4tXdq5_Bi4Vbo_k1a=zosFA3e4zRJGjzysYmC-PEA@mail.gmail.com>
References: <20131113113927.GA13875@mwhitehe.csb>
	<alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
	<20131113102153.5f10e6b5@gandalf.local.home>
	<20131113103134.5b8cf02f@gandalf.local.home>
	<20131113105737.3f7a0b1b@gandalf.local.home>
	<alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
	<20131113111257.482c2955@gandalf.local.home>
	<20131113161829.GE4138@linux.vnet.ibm.com>
	<20131113112338.7d303c0f@gandalf.local.home>
	<20131113163552.GF4138@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
	<CAOh2x=koQ4tXdq5_Bi4Vbo_k1a=zosFA3e4zRJGjzysYmC-PEA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014 19:21:53 +0530
Viresh Kumar <viresh.kumar@linaro.org> wrote:

> On Thu, Nov 14, 2013 at 1:31 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Subject: NOHZ: Check for nohz active instead of nohz enabled
> >
> > RCU and the fine grained idle time accounting functions check
> > tick_nohz_enabled. But that variable is merily telling that NOHZ has
> > been enabled in the config and not been disabled on the command line.
> >
> > But it does not tell anything about nohz being active. That's what all
> > this should check for.
> >
> > Matthew reported, that the idle accounting on his old P1 machine
> > showed bogus values, when he enabled NOHZ in the config and did not
> > disable it on the kernel command line. The reason is that his machine
> > uses (refined) jiffies as a clocksource which explains why the "fine"
> > grained accounting went into lala land, because it depends on when the
> > system goes and leaves idle relative to the jiffies increment.
> >
> > Provide a tick_nohz_active indicator and let RCU and the accounting
> > code use this instead of tick_nohz_enable.
> 
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > @@ -973,7 +968,7 @@ static void tick_nohz_switch_to_nohz(void)
> >         struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> >         ktime_t next;
> >
> > -       if (!tick_nohz_enabled)
> > +       if (!tick_nohz_active)
> >                 return;
> 
> Considering the impressive list of Reviewed-by and people involved
> in this patch, I am not sure I am reading the code well here.
> 
> The above change isn't required as per my understanding. Otherwise
> we will never pass that check. tick_nohz_active is initialized as zero
> and so we will keep on returning for ever and wouldn't be able to set
> it to 1 ever.
> 
> I have a patch to fix it up, but wanted to know your opinion before
> sending it.

Ouch! You are correct, this part of the patch makes no sense. That's
what I get for reviewing a patch and not looking at all the code around
the changes. (another kernel developer hangs head in shame :-( )

I think that if statement should be nuked.

-- Steve

> 
> >         local_irq_disable();
> > @@ -981,7 +976,7 @@ static void tick_nohz_switch_to_nohz(void)
> >                 local_irq_enable();
> >                 return;
> >         }
> > -
> > +       tick_nohz_active = 1;
> >         ts->nohz_mode = NOHZ_MODE_LOWRES;
> >
> >         /*

