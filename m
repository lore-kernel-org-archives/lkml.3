Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaANVxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:53:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaANVxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:53:09 -0500
Date: Tue, 14 Jan 2014 16:52:20 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
In-Reply-To: <1742600.ID61iX8uKd@vostro.rjw.lan>
Message-ID: <alpine.LRH.2.02.1401141651490.19206@file01.intranet.prod.int.rdu2.redhat.com>
References: <20140114142627.537a702607e703c6eff63640@canb.auug.org.au> <20140114200547.GM7572@laptop.programming.kicks-ass.net> <alpine.LRH.2.02.1401141629520.19206@file01.intranet.prod.int.rdu2.redhat.com> <1742600.ID61iX8uKd@vostro.rjw.lan>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Jan 2014, Rafael J. Wysocki wrote:

> On Tuesday, January 14, 2014 04:43:43 PM Mikulas Patocka wrote:
> > 
> > On Tue, 14 Jan 2014, Peter Zijlstra wrote:
> > 
> > > On Tue, Jan 14, 2014 at 02:06:57PM -0500, Mikulas Patocka wrote:
> > > > On Tue, 14 Jan 2014, Peter Zijlstra wrote:
> > > > > > Caused by commit 62b94a08da1b ("sched/preempt: Take away
> > > > > > preempt_enable_no_resched() from modules")
> > > 
> > > Read these two lines, then note that:
> > > 
> > > > Try adding #include <linux/preempt.h> to speedstep-lib.c. Does it help?
> > > 
> > > this obviously will not work as preempt_check_resched() and
> > > preempt_enable_no_resched() are no longer available to modules.
> > 
> > I see, you added commit 62b94a08da1bae9d187d49dfcd6665af393750f8 to 
> > linux-next, that broke my patch.
> > 
> > > > > I think that pm commit is a very good example of why the sched/preempt
> > > > > patch is a very good idea.
> > > > > 
> > > > > Also that Changelog fails to explain why enabling interrupts helps. What
> > > > > interrupt is required for progress, and how does it make the progress
> > > > > happen.
> > > > 
> > > > There is no explanation. It's hardware issue and I have no documentation 
> > > > for the hardware.
> > > 
> > > Rafael works for Intel, he ought to be able to figure out wtf the
> > > hardware does/needs.
> > > 
> > > > The general problem is that if there are bus-master transfers running (or 
> > > > possibly for other hardware reasons), the CPU refuses to change frequency. 
> > > > You can wait a little bit and retry and maybe you succeed changing the 
> > > > frequency next time.
> > > > 
> > > > If you enable interrupts, wait, disable interrupts and retry, you may 
> > > > succeed. If you keep interrupts disabled and retry, you never succeed, no 
> > > > matter how long do you wait. I found it experimentally, I don't know 
> > > > reason for that.
> > > 
> > > Sounds like magic goo..
> > > 
> > > In any case, try the below, it does the same but is far less horrid.
> > > 
> > > ---
> > >  drivers/cpufreq/speedstep-smi.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
> > > index 0f5326d6f79f..57d31538c248 100644
> > > --- a/drivers/cpufreq/speedstep-smi.c
> > > +++ b/drivers/cpufreq/speedstep-smi.c
> > > @@ -188,6 +188,7 @@ static void speedstep_set_state(unsigned int state)
> > >  		return;
> > >  
> > >  	/* Disable IRQs */
> > > +	preempt_disable();
> > >  	local_irq_save(flags);
> > >  
> > >  	command = (smi_sig & 0xffffff00) | (smi_cmd & 0xff);
> > > @@ -200,7 +201,9 @@ static void speedstep_set_state(unsigned int state)
> > >  		if (retry) {
> > >  			pr_debug("retry %u, previous result %u, waiting...\n",
> > >  					retry, result);
> > > +			local_irq_restore(flags);
> > 
> > ^^^ this is wrong, because the function speedstep_set_state may already be 
> > called with interrupts disabled from speedstep_get_freqs. So, you need to 
> > enable interrupts unconditionally, even if they were disabled at the 
> > beginning of the function speedstep_set_state.
> > 
> > I know it's dirty to enable interrupts in a function that was called with 
> > disabled interrupts, but here it must be so (you could rewrite 
> > speedstep_get_freqs to not disable interrupts if you want to avoid this 
> > dirtiness).
> > 
> > >  			mdelay(retry * 50);
> > > +			local_irq_save(flags);
> > >  		}
> > >  		retry++;
> > >  		__asm__ __volatile__(
> > > @@ -217,6 +220,7 @@ static void speedstep_set_state(unsigned int state)
> > >  
> > >  	/* enable IRQs */
> > >  	local_irq_restore(flags);
> > > +	preempt_enable();
> > >  
> > >  	if (new_state == state)
> > >  		pr_debug("change to %u MHz succeeded after %u tries "
> > 
> > You need also preempt_disable/enable in speedstep_get_freqs.
> > 
> > 
> > Here I'm resending the patch, to account for 
> > 62b94a08da1bae9d187d49dfcd6665af393750f8.
> 
> Do I think correctly that this should work regardless of whether or not
> 62b94a08da1bae9d187d49dfcd6665af393750f8 is applied?

Yes.

Mikulas
