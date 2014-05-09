Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaEIOxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:53:51 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:60402
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbaEIOxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:53:49 -0400
Date: Fri, 9 May 2014 09:53:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org
Subject: Re: vmstat: On demand vmstat workers V4
In-Reply-To: <alpine.DEB.2.02.1405090003120.6261@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1405090949170.11318@gentwo.org>
References: <alpine.DEB.2.10.1405081033090.23786@gentwo.org> <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org> <alpine.DEB.2.02.1405090003120.6261@ionos.tec.linutronix.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Thomas Gleixner wrote:

> > > +/*
> > > + * Return a cpu number that may be used to run housekeeping
> > > + * tasks. This is usually the timekeeping cpu unless that
> > > + * is not available. Then we simply fall back to the current
> > > + * cpu.
> > > + */
> >
> > This comment is unusably vague.  What the heck is a "housekeeping
> > task"?  Why would anyone call this and what is special about the CPU
> > number it returns?

I just need a processor that keeps watch over the vmstat workers in the
system. The processor that does timekeeping is an obvious choice. I am
open to other suggestions.

Typically our system have processors that are used for OS processing and
processor that are focused on app services. Those need to be as
undisturbed as possible.

 > >
> >
> > > +int tick_get_housekeeping_cpu(void)
> > > +{
> > > +	int cpu;
> > > +
> > > +	if (system_state < SYSTEM_RUNNING || tick_do_timer_cpu < 0)
> > > +		cpu = raw_smp_processor_id();
>
> That's completely bogus. The system state check is pointless and
> tick_do_timer_cpu even more so because if you call that code from a
> worker thread tick_do_timer_cpu should be assigned to some cpu.
>
> Aside of that I'm having a hard time to understand why this stuff
> wants to move around at all.
>
> I think we agreed long ago, that for the whole HPC FULL_NOHZ stuff you
> have to sacrify at least one CPU for housekeeping purposes of all
> kinds, timekeeping, statistics and whatever.

Ok how do I figure out that cpu? I'd rather have a specific cpu that
never changes.

> So if you have a housekeeper, then it makes absolutely no sense at all
> to move it around in circles.
>
> Can you please enlighten me why we need this at all?

The vmstat kworker thread checks every 2 seconds if there are vmstat
updates that need to be folded into the global statistics. This is not
necessary if the application is running and no OS services are being used.
Thus we could switch off vmstat updates and avoid taking the processor
away from the application.

This has also been noted by multiple other people at was brought up at the
mm summit by others who noted the same issues.

