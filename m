Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbaDINwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:52:04 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62648 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477AbaDINvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
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
Date: Wed, 9 Apr 2014 19:21:53 +0530
X-Google-Sender-Auth: -GSCf9lMUZHFmLE1nfULFWlwJkg
Message-ID: <CAOh2x=koQ4tXdq5_Bi4Vbo_k1a=zosFA3e4zRJGjzysYmC-PEA@mail.gmail.com>
Subject: Re: nohz problem with idle time on old hardware
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 1:31 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Subject: NOHZ: Check for nohz active instead of nohz enabled
>
> RCU and the fine grained idle time accounting functions check
> tick_nohz_enabled. But that variable is merily telling that NOHZ has
> been enabled in the config and not been disabled on the command line.
>
> But it does not tell anything about nohz being active. That's what all
> this should check for.
>
> Matthew reported, that the idle accounting on his old P1 machine
> showed bogus values, when he enabled NOHZ in the config and did not
> disable it on the kernel command line. The reason is that his machine
> uses (refined) jiffies as a clocksource which explains why the "fine"
> grained accounting went into lala land, because it depends on when the
> system goes and leaves idle relative to the jiffies increment.
>
> Provide a tick_nohz_active indicator and let RCU and the accounting
> code use this instead of tick_nohz_enable.

> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> @@ -973,7 +968,7 @@ static void tick_nohz_switch_to_nohz(void)
>         struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
>         ktime_t next;
>
> -       if (!tick_nohz_enabled)
> +       if (!tick_nohz_active)
>                 return;

Considering the impressive list of Reviewed-by and people involved
in this patch, I am not sure I am reading the code well here.

The above change isn't required as per my understanding. Otherwise
we will never pass that check. tick_nohz_active is initialized as zero
and so we will keep on returning for ever and wouldn't be able to set
it to 1 ever.

I have a patch to fix it up, but wanted to know your opinion before
sending it.

>         local_irq_disable();
> @@ -981,7 +976,7 @@ static void tick_nohz_switch_to_nohz(void)
>                 local_irq_enable();
>                 return;
>         }
> -
> +       tick_nohz_active = 1;
>         ts->nohz_mode = NOHZ_MODE_LOWRES;
>
>         /*
