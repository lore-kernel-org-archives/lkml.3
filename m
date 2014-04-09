Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964772AbaDIPLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:11:22 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:45943 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469AbaDIPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:11:19 -0400
Date: Wed, 9 Apr 2014 17:11:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20140409151108.GA17782@localhost.localdomain>
References: <20131113102153.5f10e6b5@gandalf.local.home>
 <20131113103134.5b8cf02f@gandalf.local.home>
 <20131113105737.3f7a0b1b@gandalf.local.home>
 <alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
 <20131113111257.482c2955@gandalf.local.home>
 <20131113161829.GE4138@linux.vnet.ibm.com>
 <20131113112338.7d303c0f@gandalf.local.home>
 <20131113163552.GF4138@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
 <CAOh2x=koQ4tXdq5_Bi4Vbo_k1a=zosFA3e4zRJGjzysYmC-PEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x=koQ4tXdq5_Bi4Vbo_k1a=zosFA3e4zRJGjzysYmC-PEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 07:21:53PM +0530, Viresh Kumar wrote:
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

Ouch, bad thing.

I'm also disovering this whole thread and patch only today, since nobody Cc'ed me :-(
 
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
