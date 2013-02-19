Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab3BSMJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:09:04 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52318 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564Ab3BSMJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:09:02 -0500
MIME-Version: 1.0
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 20 Feb 2013 01:08:30 +1300
Message-ID: <CAPM31R+Z3Br9Qwg8ObTPV-4aiCdNzAF7Y31FvsHk+GY=ArBPBQ@mail.gmail.com>
Subject: Re: [patch v5 0/15] power aware scheduling
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI I'm currently out of the country in New Zealand and won't be able
to take a proper look at this until the beginning of March.

On Mon, Feb 18, 2013 at 6:07 PM, Alex Shi <alex.shi@intel.com> wrote:
> Since the simplification of fork/exec/wake balancing has much arguments,
> I removed that part in the patch set.
>
> This patch set implement/consummate the rough power aware scheduling
> proposal: https://lkml.org/lkml/2012/8/13/139.
> It defines 2 new power aware policy 'balance' and 'powersaving', then
> try to pack tasks on each sched groups level according the different
> scheduler policy. That can save much power when task number in system
> is no more than LCPU number.
>
> As mentioned in the power aware scheduling proposal, Power aware
> scheduling has 2 assumptions:
> 1, race to idle is helpful for power saving
> 2, less active sched groups will reduce cpu power consumption
>
> The first assumption make performance policy take over scheduling when
> any group is busy.
> The second assumption make power aware scheduling try to pack disperse
> tasks into fewer groups.
>
> Like sched numa, power aware scheduling is also a kind of cpu locality
> oriented scheduling, so it is natural compatible with sched numa.
>
> Since the patch can perfect pack tasks into fewer groups, I just show
> some performance/power testing data here:
> =========================================
> $for ((i = 0; i < I; i++)) ; do while true; do :; done  &   done
>
> On my SNB laptop with 4core* HT: the data is avg Watts
>         powersaving     balance         performance
> i = 2   40              54              54
> i = 4   57              64*             68
> i = 8   68              68              68
>
> Note:
> When i = 4 with balance policy, the power may change in 57~68Watt,
> since the HT capacity and core capacity are both 1.
>
> on SNB EP machine with 2 sockets * 8 cores * HT:
>         powersaving     balance         performance
> i = 4   190             201             238
> i = 8   205             241             268
> i = 16  271             348             376
>
> bltk-game with openarena, the data is avg Watts
>             powersaving     balance         performance
> wsm laptop  22.9             23.8           24.4
> snb laptop  20.2             20.5           20.7
>
> tasks number keep waving benchmark, 'make -j x vmlinux'
> on my SNB EP 2 sockets machine with 8 cores * HT:
>
>          powersaving              balance                performance
> x = 1    175.603 /417 13          175.220 /416 13        176.073 /407 13
> x = 2    192.215 /218 23          194.522 /202 25        217.393 /200 23
> x = 4    205.226 /124 39          208.823 /114 42        230.425 /105 41
> x = 8    236.369 /71 59           249.005 /65 61         257.661 /62 62
> x = 16   283.842 /48 73           307.465 /40 81         309.336 /39 82
> x = 32   325.197 /32 96           333.503 /32 93         336.138 /32 92
>
> data explains: 175.603 /417 13
>         175.603: average Watts
>         417: seconds(compile time)
>         13:  scaled performance/power = 1000000 / seconds / watts
>
> Another testing of parallel compress with pigz on Linus' git tree.
> results show we get much better performance/power with powersaving and
> balance policy:
>
> testing command:
> #pigz -k -c  -p$x -r linux* &> /dev/null
>
> On a NHM EP box
>          powersaving               balance               performance
> x = 4    166.516 /88 68           170.515 /82 71         165.283 /103 58
> x = 8    173.654 /61 94           177.693 /60 93         172.31 /76 76
>
> On a 2 sockets SNB EP box.
>          powersaving               balance               performance
> x = 4    190.995 /149 35          200.6 /129 38          208.561 /135 35
> x = 8    197.969 /108 46          208.885 /103 46        213.96 /108 43
> x = 16   205.163 /76 64           212.144 /91 51         229.287 /97 44
>
> data format is: 166.516 /88 68
>         166.516: average Watts
>         88: seconds(compress time)
>         68:  scaled performance/power = 1000000 / time / power
>
> Some performance testing results:
> ---------------------------------
>
> Tested benchmarks: kbuild, specjbb2005, oltp, tbench, aim9,
> hackbench, fileio-cfq of sysbench, dbench, aiostress, multhreads
> loopback netperf. on my core2, nhm, wsm, snb, platforms. no clear
> performance change found on 'performance' policy.
>
> Tested balance/powersaving policy with above benchmarks,
> a, specjbb2005 drop 5~7% on both of policy whenever with openjdk or jrockit.
> b, hackbench drops 30+% with powersaving policy on snb 4 sockets platforms.
> Others has no clear change.
>
> test result from Mike Galbraith:
> --------------------------------
> With aim7 compute on 4 node 40 core box, I see stable throughput
> improvement at tasks = nr_cores and below w. balance and powersaving.
>
>          3.8.0-performance   3.8.0-balance      3.8.0-powersaving
> Tasks    jobs/min/task       jobs/min/task      jobs/min/task
>     1         432.8571       433.4764           433.1665
>     5         480.1902       510.9612           497.5369
>    10         429.1785       533.4507           518.3918
>    20         424.3697       529.7203           528.7958
>    40         419.0871       500.8264           517.0648
>
> No deltas after that.  There were also no deltas between patched kernel
> using performance policy and virgin source.
>
>
> Changelog:
> V5 change:
> a, change sched_policy to sched_balance_policy
> b, split fork/exec/wake power balancing into 3 patches and refresh
> commit logs
> c, others minors clean up
>
> V4 change:
> a, fix few bugs and clean up code according to Morten Rasmussen, Mike
> Galbraith and Namhyung Kim. Thanks!
> b, take Morten Rasmussen's suggestion to use different criteria for
> different policy in transitory task packing.
> c, shorter latency in power aware scheduling.
>
> V3 change:
> a, engaged nr_running and utils in periodic power balancing.
> b, try packing small exec/wake tasks on running cpu not idle cpu.
>
> V2 change:
> a, add lazy power scheduling to deal with kbuild like benchmark.
>
>
> Thanks comments/suggestions from PeterZ, Linus Torvalds, Andrew Morton,
> Ingo, Arjan van de Ven, Borislav Petkov, PJT, Namhyung Kim, Mike
> Galbraith, Greg, Preeti, Morten Rasmussen etc.
>
> Thanks fengguang's 0-day kbuild system for testing this patchset.
>
> Any more comments are appreciated!
>
> -- Thanks Alex
>
>
> [patch v5 01/15] sched: set initial value for runnable avg of sched
> [patch v5 02/15] sched: set initial load avg of new forked task
> [patch v5 03/15] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
> [patch v5 04/15] sched: add sched balance policies in kernel
> [patch v5 05/15] sched: add sysfs interface for sched_balance_policy
> [patch v5 06/15] sched: log the cpu utilization at rq
> [patch v5 07/15] sched: add new sg/sd_lb_stats fields for incoming
> [patch v5 08/15] sched: move sg/sd_lb_stats struct ahead
> [patch v5 09/15] sched: add power aware scheduling in fork/exec/wake
> [patch v5 10/15] sched: packing transitory tasks in wake/exec power
> [patch v5 11/15] sched: add power/performance balance allow flag
> [patch v5 12/15] sched: pull all tasks from source group
> [patch v5 13/15] sched: no balance for prefer_sibling in power
> [patch v5 14/15] sched: power aware load balance
> [patch v5 15/15] sched: lazy power balance
