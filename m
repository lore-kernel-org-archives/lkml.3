Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3BDLKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:10:07 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44987 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3BDLKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:10:05 -0500
Date: Mon, 4 Feb 2013 12:09:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
Message-ID: <20130204110959.GE24173@gmail.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
 <510F1064.1060302@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510F1064.1060302@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> On 01/24/2013 11:06 AM, Alex Shi wrote:
> > Since the runnable info needs 345ms to accumulate, balancing
> > doesn't do well for many tasks burst waking. After talking with Mike
> > Galbraith, we are agree to just use runnable avg in power friendly 
> > scheduling and keep current instant load in performance scheduling for 
> > low latency.
> > 
> > So the biggest change in this version is removing runnable load avg in
> > balance and just using runnable data in power balance.
> > 
> > The patchset bases on Linus' tree, includes 3 parts,
> > ** 1, bug fix and fork/wake balancing clean up. patch 1~5,
> > ----------------------
> > the first patch remove one domain level. patch 2~5 simplified fork/wake
> > balancing, it can increase 10+% hackbench performance on our 4 sockets
> > SNB EP machine.
> > 
> > V3 change:
> > a, added the first patch to remove one domain level on x86 platform.
> > b, some small changes according to Namhyung Kim's comments, thanks!
> > 
> > ** 2, bug fix of load avg and remove the CONFIG_FAIR_GROUP_SCHED limit
> > ----------------------
> > patch 6~8, That using runnable avg in load balancing, with
> > two initial runnable variables fix.
> > 
> > V4 change:
> > a, remove runnable log avg using in balancing.
> > 
> > V3 change:
> > a, use rq->cfs.runnable_load_avg as cpu load not
> > rq->avg.load_avg_contrib, since the latter need much time to accumulate
> > for new forked task,
> > b, a build issue fixed with Namhyung Kim's reminder.
> > 
> > ** 3, power awareness scheduling, patch 9~18.
> > ----------------------
> > The subset implement/consummate the rough power aware scheduling
> > proposal: https://lkml.org/lkml/2012/8/13/139.
> > It defines 2 new power aware policy 'balance' and 'powersaving' and then
> > try to spread or pack tasks on each sched groups level according the
> > different scheduler policy. That can save much power when task number in
> > system is no more then LCPU number.
> > 
> > As mentioned in the power aware scheduler proposal, Power aware
> > scheduling has 2 assumptions:
> > 1, race to idle is helpful for power saving
> > 2, pack tasks on less sched_groups will reduce power consumption
> > 
> > The first assumption make performance policy take over scheduling when
> > system busy.
> > The second assumption make power aware scheduling try to move
> > disperse tasks into fewer groups until that groups are full of tasks.
> > 
> > Some power testing data is in the last 2 patches.
> > 
> > V4 change:
> > a, fix few bugs and clean up code according to Morten Rasmussen, Mike
> > Galbraith and Namhyung Kim. Thanks!
> > b, take Morten's suggestion to set different criteria for different
> > policy in small task packing.
> > c, shorter latency in power aware scheduling.
> > 
> > V3 change:
> > a, engaged nr_running in max potential utils consideration in periodic
> > power balancing.
> > b, try exec/wake small tasks on running cpu not idle cpu.
> > 
> > V2 change:
> > a, add lazy power scheduling to deal with kbuild like benchmark.
> > 
> > 
> > Thanks Fengguang Wu for the build testing of this patchset!
> 
> 
> Add some testing report summary that were posted:
> Alex Shi tested the benchmarks: kbuild, specjbb2005, oltp, tbench, aim9, hackbench, fileio-cfq of sysbench, dbench, aiostress, multhreads
> loopback netperf. on core2, nhm, wsm, snb, platforms: 
> 	a, no clear performance change on performance balance
> 	b, specjbb2005 drop 5~7% on balance/powersaving policy on SNB/NHM platforms; hackbench drop 30~70% SNB EP4S machine.
> 	c, no other peformance change on balance/powersaving machine.
> 
> test result from Mike Galbraith:
> ---------
> With aim7 compute on 4 node 40 core box, I see stable throughput
> improvement at tasks = nr_cores and below w. balance and powersaving. 
> 
>          3.8.0-performance                  3.8.0-balance          3.8.0-powersaving
> Tasks    jobs/min/task       cpu   jobs/min/task       cpu    jobs/min/task         cpu
>     1         432.8571      3.99        433.4764      3.97         433.1665        3.98
>     5         480.1902     12.49        510.9612      7.55         497.5369        8.22
>    10         429.1785     40.14        533.4507     11.13         518.3918       12.15
>    20         424.3697     63.14        529.7203     23.72         528.7958       22.08
>    40         419.0871    171.42        500.8264     51.44         517.0648       42.45
> 
> No deltas after that.  There were also no deltas between patched kernel
> using performance policy and virgin source.
> ----------
> 
> Ingo, I appreciate for any comments from you. :)

Have you tried to quantify the actual real or expected power 
savings with the knob enabled?

I'd also love to have an automatic policy here, with a knob that 
has 3 values:

   0: always disabled
   1: automatic
   2: always enabled

here enabled/disabled is your current knob's functionality, and 
those can also be used by user-space policy daemons/handlers.

The interesting thing would be '1' which should be the default: 
on laptops that are on battery it should result in a power 
saving policy, on laptops that are on AC or on battery-less 
systems it should mean 'performance' policy.

It should generally default to 'performance', switching to 
'power saving on' only if there's positive, reliable information 
somewhere in the kernel that we are operating on battery power. 
A callback or two would have to go into the ACPI battery driver 
I suspect.

So I'd like this feature to be a tangible improvement for laptop 
users (as long as the laptop hardware is passing us battery/AC 
events reliably).

Or something like that - with .config switches to influence 
these values as well.

Thanks,

	Ingo
