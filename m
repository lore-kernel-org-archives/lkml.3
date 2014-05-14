Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbaENNvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:51:24 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53535 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaENNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:51:23 -0400
Date: Wed, 14 May 2014 15:51:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] irq_work: Implement remote queueing
Message-ID: <20140514135116.GD1278@localhost.localdomain>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-2-git-send-email-fweisbec@gmail.com>
 <20140514090629.GC30445@twins.programming.kicks-ass.net>
 <20140514113808.GA1278@localhost.localdomain>
 <20140514115406.GA11096@twins.programming.kicks-ass.net>
 <20140514121122.GC1278@localhost.localdomain>
 <20140514124150.GB11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514124150.GB11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 02:41:50PM +0200, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 02:11:25PM +0200, Frederic Weisbecker wrote:
> > > I don't think it is, most apic calls do apic_wait_icr_idle() then the
> > > apic op, if an NMI happens in between and writes to the APIC, the return
> > > context will see a !idle icr and fail.
> > > 
> > > This is why arch_irq_work_raise() again idles the icr after sending the
> > > IPI.
> > > 
> > > Also, I think, seeing what benh said earlier, its unsafe for other archs
> > > too.
> > 
> > Ah I don't know much these archs details, so I concede it.
> 
> Yeah, I didn't either, had to figure it out when someone asked WTH there
> was an wait_icr_idle call in there.
> 
> > > Then do the remote irq_work_raised thing. But it really stinks you broke
> > > this very nice and simple thing.
> > 
> > I tried not to break boot with printk overhead. That said I've considered having
> > a very simple "tick work" that can rely on irq work when the tick is stopped
> > and use it for printk. That would restore the initial simplicity.
> 
> But but but.. did you even try without the lazy thing?
> 
> Don't fix what ain't broken, keep it simple, etc..

The problem is that I may well see no significant issues in my small and common hardware
but the problem may hit on boxes with specific configs or big numbers of CPUs.

"Don't fix what ain't broken" here clashes with "lets stay conservative/paranoid"
to avoid bringing new bugs. Before printk used irq_work we had printk_tick(),
I simply kept the old behaviour to avoid breaking boot time on other boxes.

> 
> Anyway, if it turns out to really be needed, the split list doesn't
> sound bad.

Either that or we can remove LAZY stuff and wait to see if people complain :)

> 
> > > > Also note that nohz is the only user for now and irq_work_claim() thus
> > > > prevents from double IPI. Of course if more users come up the issue arise
> > > > again.
> > > 
> > > DANGER, half arsed engineering at work, seriously? Just write proper
> > > code already.
> > > 
> > > There's no fucking way the next user will check the implementation to
> > > make sure its 'sane'.
> > 
> > Are you competing with tglx on grumpiness? You guys are free to treat us
> > like shit but don't be surprised if one day you'll be alone in kernel/*
> 
> There's really only so much nonsense one can take on any one day before
> getting seriously grumpy.
> 
> And arguing that because there's only one user so we can skimp a core
> function really tops the day.
> 
> So maybe I need a holiday, but shees.


