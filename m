Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783AbaFCU3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:29:50 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:51368 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaFCU3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:29:48 -0400
Date: Tue, 3 Jun 2014 22:29:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] irq_work: Implement remote queueing
Message-ID: <20140603202942.GH23860@localhost.localdomain>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
 <1401806420-31018-4-git-send-email-fweisbec@gmail.com>
 <1401812947.3645.231.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140603163745.GC30445@twins.programming.kicks-ass.net>
 <1401825759.3645.233.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401825759.3645.233.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 01:02:39PM -0700, Eric Dumazet wrote:
> On Tue, 2014-06-03 at 18:37 +0200, Peter Zijlstra wrote:
> > On Tue, Jun 03, 2014 at 09:29:07AM -0700, Eric Dumazet wrote:
> > > > +bool irq_work_queue_on(struct irq_work *work, int cpu)
> > > > +{
> > > > +	/* All work should have been flushed before going offline */
> > > > +	WARN_ON_ONCE(cpu_is_offline(cpu));
> > > > +
> > > > +	/* Arch remote IPI send/receive backend aren't NMI safe */
> > > > +	WARN_ON_ONCE(in_nmi());
> > > > +
> > > > +	/* Only queue if not already pending */
> > > > +	if (!irq_work_claim(work))
> > > > +		return false;
> > > > +
> > > > +	if (llist_add(&work->llnode, &per_cpu(raised_list, cpu)))
> > > > +		native_send_call_func_single_ipi(cpu);
> > > > +
> > > > +	return true;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(irq_work_queue_on);
> > > > +
> > > 
> > > I am curious, this should only compile on x86, right ?
> > 
> > Oh, you tease, you forgot to say why you think this.
> > 
> > Are you referring to the in_nmi() usage? that's from
> > include/linux/hardirq.h, hardly x86 specific.
> 
> No, my eyes were attracted by native_send_call_func_single_ipi()

Right, should be arch_send_call_function_single_ipi(). I'm like unable
to get a correct patchset before at least 9 takes...
