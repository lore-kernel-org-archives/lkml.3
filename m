Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaEHWSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:18:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:59171 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaEHWSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:18:31 -0400
Date: Fri, 9 May 2014 00:18:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org
Subject: Re: vmstat: On demand vmstat workers V4
In-Reply-To: <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1405090003120.6261@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1405081033090.23786@gentwo.org> <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Andrew Morton wrote:
> On Thu, 8 May 2014 10:35:15 -0500 (CDT) Christoph Lameter <cl@linux.com> wrote:
> > --- linux.orig/kernel/time/tick-common.c	2014-05-06 10:51:19.711239813 -0500
> > +++ linux/kernel/time/tick-common.c	2014-05-06 10:51:19.711239813 -0500
> > @@ -222,6 +222,24 @@
> >  		tick_setup_oneshot(newdev, handler, next_event);
> >  }
> > 
> > +/*
> > + * Return a cpu number that may be used to run housekeeping
> > + * tasks. This is usually the timekeeping cpu unless that
> > + * is not available. Then we simply fall back to the current
> > + * cpu.
> > + */
> 
> This comment is unusably vague.  What the heck is a "housekeeping
> task"?  Why would anyone call this and what is special about the CPU
> number it returns?
> 
> 
> > +int tick_get_housekeeping_cpu(void)
> > +{
> > +	int cpu;
> > +
> > +	if (system_state < SYSTEM_RUNNING || tick_do_timer_cpu < 0)
> > +		cpu = raw_smp_processor_id();

That's completely bogus. The system state check is pointless and
tick_do_timer_cpu even more so because if you call that code from a
worker thread tick_do_timer_cpu should be assigned to some cpu.

Aside of that I'm having a hard time to understand why this stuff
wants to move around at all.

I think we agreed long ago, that for the whole HPC FULL_NOHZ stuff you
have to sacrify at least one CPU for housekeeping purposes of all
kinds, timekeeping, statistics and whatever.

So if you have a housekeeper, then it makes absolutely no sense at all
to move it around in circles.

Can you please enlighten me why we need this at all?

Thanks,

	tglx
