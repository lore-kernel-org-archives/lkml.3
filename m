Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3DDCBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:01:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:45838 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759809Ab3DDCBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:01:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280533920"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v7 0/21] sched: power aware scheduling
Date: Thu,  4 Apr 2013 10:00:41 +0800
Message-Id: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many many thanks for Namhyung, PJT, Vicent and Preeti's comments and suggestion!
This version included the following changes:
a, remove the patch 3th to recover the runnable load avg recording on rt
b, check avg_idle for each cpu wakeup burst not only the waking CPU.
c, fix select_task_rq_fair return -1 bug by Preeti.

--------------

This patch set implement/consummate the rough power aware scheduling
proposal: https://lkml.org/lkml/2012/8/13/139.

The code also on this git tree:
https://github.com/alexshi/power-scheduling.git power-scheduling

The patch defines a new policy 'powersaving', that try to pack tasks on
each sched groups level. Then it can save much power when task number in
system is no more than LCPU number.

As mentioned in the power aware scheduling proposal, Power aware
scheduling has 2 assumptions:
1, race to idle is helpful for power saving
2, less active sched groups will reduce cpu power consumption

The first assumption make performance policy take over scheduling when
any group is busy.
The second assumption make power aware scheduling try to pack disperse
tasks into fewer groups.

This feature will cause more cpu cores idle, the give more chances to have
cpu freq boost on active cores. CPU freq boost gives better performance and 
better power efficient. The following kbuild test result show this point.

Compare to the removed power balance, this power balance has the following
advantages:
1, simpler sys interface
	only 2 sysfs interface VS 2 interface for each of LCPU
2, cover on all cpu topology 
	effect on all domain level VS only work on SMT/MC domain
3, Less task migration 
	mutual exclusive perf/power LB VS balance power on balanced performance
4, considered system load threshing 
	yes VS no
5, transitory task considered       
	yes VS no

BTW, like sched numa, Power aware scheduling is also a kind of cpu
locality oriented scheduling.

Thanks comments/suggestions from PeterZ, Linus Torvalds, Andrew Morton,
Ingo, Len Brown, Arjan, Borislav Petkov, PJT, Namhyung Kim, Mike
Galbraith, Greg, Preeti, Morten Rasmussen, Rafael etc.

Since the patch can perfect pack tasks into fewer groups, I just show
some performance/power testing data here:
=========================================
$for ((i = 0; i < x; i++)) ; do while true; do :; done  &   done

On my SNB laptop with 4 core* HT: the data is avg Watts
         powersaving     performance
x = 8	 72.9482 	 72.6702
x = 4	 61.2737 	 66.7649
x = 2	 44.8491 	 59.0679
x = 1	 43.225 	 43.0638

on SNB EP machine with 2 sockets * 8 cores * HT:
         powersaving     performance
x = 32	 393.062 	 395.134
x = 16	 277.438 	 376.152
x = 8	 209.33 	 272.398
x = 4	 199 	         238.309
x = 2	 175.245 	 210.739
x = 1	 174.264 	 173.603


tasks number keep waving benchmark, 'make -j <x> vmlinux'
on my SNB EP 2 sockets machine with 8 cores * HT:
         powersaving              performance
x = 2    189.416 /228 23          193.355 /209 24
x = 4    215.728 /132 35          219.69 /122 37
x = 8    244.31 /75 54            252.709 /68 58
x = 16   299.915 /43 77           259.127 /58 66
x = 32   341.221 /35 83           323.418 /38 81

data explains: 189.416 /228 23
	189.416: average Watts during compilation
	228: seconds(compile time)
	23:  scaled performance/watts = 1000000 / seconds / watts
The performance value of kbuild is better on threads 16/32, that's due
to lazy power balance reduced the context switch and CPU has more boost 
chance on powersaving balance.

Some performance testing results:
---------------------------------

Tested benchmarks: kbuild, specjbb2005, oltp, tbench, aim9,
hackbench, fileio-cfq of sysbench, dbench, aiostress, multhreads
loopback netperf. on my core2, nhm, wsm, snb, platforms.

results:
A, no clear performance change found on 'performance' policy.
B, specjbb2005 drop 5~7% on both of policy whenever with openjdk or
   jrockit on powersaving polocy
C, hackbench drops 40% with powersaving policy on snb 4 sockets platforms.
Others has no clear change.

===
Changelog:
V7 change:
a, remove the patch 3th to recover the runnable load avg recording on rt
b, check avg_idle for each cpu wakeup burst not only the waking CPU.
c, fix select_task_rq_fair return -1 bug by Preeti.

Changelog:
V6 change:
a, remove 'balance' policy.
b, consider RT task effect in balancing
c, use avg_idle as burst wakeup indicator
d, balance on task utilization in fork/exec/wakeup.
e, no power balancing on SMT domain.

V5 change:
a, change sched_policy to sched_balance_policy
b, split fork/exec/wake power balancing into 3 patches and refresh
commit logs
c, others minors clean up

V4 change:
a, fix few bugs and clean up code according to Morten Rasmussen, Mike
Galbraith and Namhyung Kim. Thanks!
b, take Morten Rasmussen's suggestion to use different criteria for
different policy in transitory task packing.
c, shorter latency in power aware scheduling.

V3 change:
a, engaged nr_running and utilisation in periodic power balancing.
b, try packing small exec/wake tasks on running cpu not idle cpu.

V2 change:
a, add lazy power scheduling to deal with kbuild like benchmark.


-- Thanks Alex
[patch v7 01/21] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
[patch v7 02/21] sched: set initial value of runnable avg for new
[patch v7 03/21] sched: add sched balance policies in kernel
[patch v7 04/21] sched: add sysfs interface for sched_balance_policy
[patch v7 05/21] sched: log the cpu utilization at rq
[patch v7 06/21] sched: add new sg/sd_lb_stats fields for incoming
[patch v7 07/21] sched: move sg/sd_lb_stats struct ahead
[patch v7 08/21] sched: scale_rt_power rename and meaning change
[patch v7 09/21] sched: get rq potential maximum utilization
[patch v7 10/21] sched: add power aware scheduling in fork/exec/wake
[patch v7 11/21] sched: add sched_burst_threshold_ns as wakeup burst
[patch v7 12/21] sched: using avg_idle to detect bursty wakeup
[patch v7 13/21] sched: packing transitory tasks in wakeup power
[patch v7 14/21] sched: add power/performance balance allow flag
[patch v7 15/21] sched: pull all tasks from source group
[patch v7 16/21] sched: no balance for prefer_sibling in power
[patch v7 17/21] sched: add new members of sd_lb_stats
[patch v7 18/21] sched: power aware load balance
[patch v7 19/21] sched: lazy power balance
[patch v7 20/21] sched: don't do power balance on share cpu power
[patch v7 21/21] sched: make sure select_tas_rq_fair get a cpu
