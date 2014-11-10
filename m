Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaKJU1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:27:13 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33294 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaKJU1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:27:11 -0500
Date: Mon, 10 Nov 2014 21:26:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
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
Message-ID: <20141110202655.GB29741@lerouge>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
 <alpine.DEB.2.11.1411012003390.5308@nanos>
 <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 04:52:13PM -0500, Christoph Lameter wrote:
> On Sat, 1 Nov 2014, Thomas Gleixner wrote:
> 
> > On Fri, 31 Oct 2014, Christoph Lameter wrote:
> > > The reasoning behind this function is not clear to me and removal seems
> >
> > The comment above the function is clear enough.
> 
> I looked around into the functions called by the timer interrupt for
> accounting etc. They have measures to compensate if the HZ is not
> occurring for some time.

Not very well. They handle correctly dynticks idle but not dynticks full.
Checkout update_cpu_load_active() -> __update_cpu_load() for example.

There is a pending_update argument that take care of tickless delta but
decay_load_miss() catch up with the missing cpu load assuming it was all 0 (idle)
all that time.

Generally speaking the scheduler assume dynticks to be idle dynticks. And that
concerns the above example and probably many other accounting.

Now the issue with update_cpu_load_active() is there, whether we keep 1 Hz or not,
any delta of full dynticks workload makes it buggy because it's accounted as idle
load.

But removing the 1 Hz residual tick is dangerous because many accounting in the
scheduler tick assume regular updates. It's mostly ok as long as the accounting
is exclusively updated and read locally. But some accounting is also updated locally
and read remotely. So if CPU 0 is full dynticks and runs for 1 hour in userspace and
CPU 1 reads its stats, those will be buggy because of the missing updates. At best
in this scenarion CPU 1 may consider that CPU 0 has been idle for 1 hour, at worst
the stats can be junk and there can be crashes. Also a lot of the scheduler decisions
is based on these accountings. Load balancing to the least.

So we have two possible solutions:

1) Make the scheduler more full-dynticks aware. Which means that any remote
stat accounting read must handle out of date results. That's going to be tricky: if
you check scheduler_tick() and sched_class::task_tick(), even simply trying to
sort out which stat is updated, can handle busy dynticks load, is read only locally
or can be read remotely, handles overflow, etc... That's enough work for an army of ants.

2) Offload scheduler_tick() to the housekeeping. It looks like many of the updaters
there can easily take a remote rq argument. There doesn't seem to be much local rq
assumption. So that's the easiest solution.

But we can't just remove scheduler_tick_max_deferment() and not fix things behind.
The result will be unpredictably insane and dangerous. The only predictable thing
that's going to happen if we do that is that nobody will ever fix it properly.
