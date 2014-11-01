Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaKAVwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 17:52:22 -0400
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:59735 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873AbaKAVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 17:52:21 -0400
Date: Sat, 1 Nov 2014 16:52:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [NOHZ] Remove scheduler_tick_max_deferment
In-Reply-To: <alpine.DEB.2.11.1411012003390.5308@nanos>
Message-ID: <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org> <alpine.DEB.2.11.1411012003390.5308@nanos>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2014, Thomas Gleixner wrote:

> On Fri, 31 Oct 2014, Christoph Lameter wrote:
> > The reasoning behind this function is not clear to me and removal seems
>
> The comment above the function is clear enough.

I looked around into the functions called by the timer interrupt for
accounting etc. They have measures to compensate if the HZ is not
occurring for some time.

> > to have a limited impact on the system overall. Even without the
> > cap to 1 second the system will be limited by the boundaries on the period
> > of interrupts by various devices (in my case I ended up with a 4 second
> > interval on x86 because of the limitations of periodicy of the underlying
> > interupt source).
>
> And just because it happens to do so on your machine it's not
> guaranteed.

When would it not occur? Where do we lack a measure to cope with missing
timer interrupts now?

> > Moreover this artificial limits the impact the benefit that commit
> > commit 7cc36bbddde5cd0c98f0c06e3304ab833d662565 (on-demand vmstat workers)
> > should be giving us.
> >
> > Without this patch timer interrupts will still occur in 1 second intervals
> > but no vmstat kworker will run. On a processor where all other
>
> And what has this to do with vmstat kworker? Nothing.

This means that the timer interrupt occurs needlessly.

> > events have been redirected to other processors nothing will be
> > going on just timer interrupts that do not do much.
>
> What the timer interrupt does is very clearly explained in the comment
> above the function you want to remove.

Could you be specific?

> > With this patch the maximum deferrability of other items will become
> > evident and work can then proceed on eliminating those
>
> What about eliminating the requirement for this function first? It's
> clear what it does and it's also clear that this can be done remotely
> from a housekeeping cpu when the full nohz cpu is busy looping in user
> space. The function is there because nobody has tackled that problem
> yet.

Where does that requirement exist?


> You don't want to tackle the 4 seconds limit of the underlying
> hardware. What you really want is to eliminate the [hr]timer which is
> preventing the hardware timer to be shutdown completely.

Yes after the 1 second issue here has been avoided we can move on to the 4
second one and so on.

> But we care about that _after_ we solved the scheduler tick
> requirement because that is the most evident one.

Why does the scheduler require that tick? It seems that the processor is
always busy running exactly 1 process when the tick is not
occurring. Anything else will switch on the tick again. So the information
that the scheduler has never becomes outdated.




