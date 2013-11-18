Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3KRTds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:33:48 -0500
Received: from a9-111.smtp-out.amazonses.com ([54.240.9.111]:58125 "EHLO
	a9-111.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424Ab3KRTdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:33:45 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Nov 2013 14:33:45 EST
Date: Mon, 18 Nov 2013 19:28:41 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: vmstat: On demand vmstat workers V3
In-Reply-To: <20131116154224.GC18855@localhost.localdomain>
Message-ID: <000001426cafac3e-0ff96cdc-7ecb-43e7-9f26-79a80f469473-000000@email.amazonses.com>
References: <000001417f6834f1-32b83f22-8bde-4b9e-b591-bc31329660e4-000000@email.amazonses.com> <20131116154224.GC18855@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.11.18-54.240.9.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Nov 2013, Frederic Weisbecker wrote:

> Not really. Thomas suggested an infrastructure to move CPU-local periodic
> jobs handling to be offlined to set of remote housekeeping CPU.

As I said in my reply to that proposal this is not possible since the cpu
local jobs rely on cpu local operations in order to reduce the impact of
statistics keeping on vm operations.

> Now the problem is that vmstats updates use pure local lockless
> operations. It may be possible to offline this update to remote CPUs
> but then we need to convert vmstats updates to use locks. Which is
> potentially costly. Unless we can find some clever lockless update
> scheme. Do you think this can be possible?

We got to these per cpu operations for vm statistics because they
can have an significant influence on kernel performance. Experiments in
in this area have usually led to significant performance degradations.
We have code in the VM that fine tunes the limits of when global data is
updated due to the performance impact that these limits have.

> > +	schedule_delayed_work_on(s, d,
> > +		__round_jiffies_relative(sysctl_stat_interval, s));
>
> Note that on dynticks idle (CONFIG_NO_HZ_IDLE=y), the timekeeper CPU can change quickly and often.
>
> I can imagine a nasty race there: CPU 0 is the timekeeper. It schedules the
> vmstat sherpherd work in 2 seconds. But CPU 0 goes to sleep for a big while
> and some other CPU takes the timekeeping duty. The shepherd timer won't be
> processed until CPU 0 wakes up although we may have CPUs to monitor.
>
> CONFIG_NO_HZ_FULL may work incidentally because CPU 0 is the only timekeeper there
> but this is a temporary limitation. Expect the timekeeper to be dynamic in the future
> under that config.

Could we stabilize the timekeeper? Its not really productive to move time
and other processing  between different cores. Low latency configurations
mean that processes are bound to certain processores. Moving
processing between cores causes cache disturbances and therefore more
latencies. Also timekeeping tunes its clock depending on the performance
of a core. Timekeeping could be thrown off.

I could make this depend on CONFIG_NO_HZ_FULL or we can introduce another
config option that keeps the timekeeper constant.

> So such a system that dynamically schedules timers on demand is enough if we
> want to _minimize_ timers. But what we want is a strong guarantee that the
> CPU won't be disturbed at least while it runs in userland, right?

Sure if we could have then we'd want it.

> I mean, we are not only interested in optimizations but also in guarantees if
> we have an extreme workload that strongly depends on the CPU not beeing disturbed
> at all. I know that some people in realtime want that. And I thought it's also
> what your want, may be I misunderstood your usecase?

Sure I want that too if its possible. I do know of any design that would
be acceptable performance wise that would allow us to do that. Failing
that I think that what I proposed is the best way to get rid of as much OS
noise as possible.

Also if a process invokes a system call then there are numerous reasons
for the OS to enable the tick. F.e any network actions may require softirq
processing, block operations may need something else. So this is not the
only reason that the OS would have to interrupt the appliation. The
lesson here is that a low latency application should avoid using system calls
that require deferred processing.

I can refine this approach if we have an agreement with going forward with
the basic idea here of switching folding of differentials on an off.
