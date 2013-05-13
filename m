Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3EMTkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:40:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:48996 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3EMTkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:40:31 -0400
Date: Mon, 13 May 2013 21:40:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
In-Reply-To: <alpine.LNX.2.00.1305131655390.23038@pobox.suse.cz>
Message-ID: <alpine.LFD.2.02.1305132138160.2863@ionos>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130510002930.GB2394@somewhere> <alpine.LNX.2.00.1305101702250.23038@pobox.suse.cz> <20130510152102.GD22942@pd.tnic> <20130510154349.GB9358@somewhere> <20130510162340.GE22942@pd.tnic>
 <20130510213851.GC9358@somewhere> <alpine.LNX.2.00.1305131655390.23038@pobox.suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, Jiri Kosina wrote:
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -650,6 +650,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
> >  
> >  			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
> >  			ts->tick_stopped = 1;
> > +			WARN_ON_ONCE(!cpu_online(cpu));

So that warning triggers.

>  WARNING: at kernel/time/tick-sched.c:653 tick_nohz_stop_sched_tick+0x38e/0x3a0()

The pre full dyntick idle code bailed out when a cpu was offline. The
new fangled can_stop_idle_tick() function dropped that.

Does the patch below fix the issue?

Thanks,

	tglx

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index bc67d42..00a9a97 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -717,6 +717,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (unlikely(!cpu_online(cpu))) {
 		if (cpu == tick_do_timer_cpu)
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+		return false;
 	}
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))

