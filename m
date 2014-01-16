Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaAPMOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:14:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35532 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPMOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:14:46 -0500
Date: Thu, 16 Jan 2014 13:14:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140116121415.GP31570@twins.programming.kicks-ass.net>
References: <20140114142627.537a702607e703c6eff63640@canb.auug.org.au>
 <20140114141406.GD7572@laptop.programming.kicks-ass.net>
 <alpine.LRH.2.02.1401141400030.19206@file01.intranet.prod.int.rdu2.redhat.com>
 <20140114200547.GM7572@laptop.programming.kicks-ass.net>
 <alpine.LRH.2.02.1401141629520.19206@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401141629520.19206@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:43:43PM -0500, Mikulas Patocka wrote:
> > @@ -200,7 +201,9 @@ static void speedstep_set_state(unsigned int state)
> >  		if (retry) {
> >  			pr_debug("retry %u, previous result %u, waiting...\n",
> >  					retry, result);
> > +			local_irq_restore(flags);
> 
> ^^^ this is wrong, because the function speedstep_set_state may already be 
> called with interrupts disabled from speedstep_get_freqs. So, you need to 
> enable interrupts unconditionally, even if they were disabled at the 
> beginning of the function speedstep_set_state.
> 
> I know it's dirty to enable interrupts in a function that was called with 
> disabled interrupts, but here it must be so (you could rewrite 
> speedstep_get_freqs to not disable interrupts if you want to avoid this 
> dirtiness).

Egads; I think you had better, this is vile beyond reason.

> >  			mdelay(retry * 50);
> > +			local_irq_save(flags);
> >  		}
> >  		retry++;
> >  		__asm__ __volatile__(
> > @@ -217,6 +220,7 @@ static void speedstep_set_state(unsigned int state)
> >  
> >  	/* enable IRQs */
> >  	local_irq_restore(flags);
> > +	preempt_enable();
> >  
> >  	if (new_state == state)
> >  		pr_debug("change to %u MHz succeeded after %u tries "
> 
> You need also preempt_disable/enable in speedstep_get_freqs.

Argh I see, this is really horrid.


Anyway, its Rafael's call, its his subsystem he gets to fix it when it
explodes.

/me shudders
