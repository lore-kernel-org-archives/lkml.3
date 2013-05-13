Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3EMUBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:01:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab3EMUBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:01:20 -0400
Date: Mon, 13 May 2013 22:01:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
In-Reply-To: <alpine.LFD.2.02.1305132138160.2863@ionos>
Message-ID: <alpine.LNX.2.00.1305132156300.23038@pobox.suse.cz>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130510002930.GB2394@somewhere> <alpine.LNX.2.00.1305101702250.23038@pobox.suse.cz> <20130510152102.GD22942@pd.tnic> <20130510154349.GB9358@somewhere> <20130510162340.GE22942@pd.tnic>
 <20130510213851.GC9358@somewhere> <alpine.LNX.2.00.1305131655390.23038@pobox.suse.cz> <alpine.LFD.2.02.1305132138160.2863@ionos>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, Thomas Gleixner wrote:

> > > --- a/kernel/time/tick-sched.c
> > > +++ b/kernel/time/tick-sched.c
> > > @@ -650,6 +650,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
> > >  
> > >  			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
> > >  			ts->tick_stopped = 1;
> > > +			WARN_ON_ONCE(!cpu_online(cpu));
> 
> So that warning triggers.
> 
> >  WARNING: at kernel/time/tick-sched.c:653 tick_nohz_stop_sched_tick+0x38e/0x3a0()
> 
> The pre full dyntick idle code bailed out when a cpu was offline. The
> new fangled can_stop_idle_tick() function dropped that.
> 
> Does the patch below fix the issue?
> 
> Thanks,
> 
> 	tglx
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index bc67d42..00a9a97 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -717,6 +717,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  	if (unlikely(!cpu_online(cpu))) {
>  		if (cpu == tick_do_timer_cpu)
>  			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> +		return false;
>  	}
>  
>  	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))

The warning is gone, so it definitely looks like you found a culprit, 
Thomas, thanks.

But I am not going to provide my Tested-by: yet, as one of the four 
suspend-resume cycles I have done during testing of this patch ended up 
with segfaults when trying to start any userspace binary after resume 
(i.e. clear memory corruption). The remaining three suspend-resume 
cycles were fine.

Will be looking into this a little bit more.

-- 
Jiri Kosina
SUSE Labs
