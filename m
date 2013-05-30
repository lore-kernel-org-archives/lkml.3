Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967702Ab3E3HDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:03:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:55254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967563Ab3E3HC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,769,1363158000"; 
   d="scan'208";a="345550288"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>
Subject: [patch v7 0/8] sched: using runnable load avg in balance
Date: Thu, 30 May 2013 15:01:56 +0800
Message-Id: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks comments from Peter, Paul, Morten, Michael and Preeti.

The most important change of this version is rebasing on latest
tip/sched/core tree.

I tested on Intel core2, NHM, SNB, IVB, 2 and 4 sockets machines with
benchmark kbuild, aim7, dbench, tbench, hackbench, oltp, and netperf
loopback etc. 

On SNB EP 4 sockets machine, the hackbench increased about 50%, and
result become stable. on other machines, hackbench increased about
2~10%. oltp increased about 30% in NHM EX box. netperf loopback also
increased on SNB EP 4 sockets box. no clear changes on other
benchmarks.

Michael Wang gotten better performance on pgbench on his box with this
patchset. https://lkml.org/lkml/2013/5/16/82

And Morten tested previous version with better power consumption.
http://comments.gmane.org/gmane.linux.kernel/1463371

Changlong found ltp cgroup stress testing get faster on SNB EP
machine.  https://lkml.org/lkml/2013/5/23/65
---
3.10-rc1          patch1-7         patch1-8
duration=764   duration=754   duration=750
duration=764   duration=754   duration=751
duration=763   duration=755   duration=751

duration means the seconds of testing cost.
---

Jason also found java server load benefited on his 8 sockets machine:
https://lkml.org/lkml/2013/5/29/673
---
When using a 3.10-rc2 tip kernel with patches 1-8, there was about a 40%
improvement in performance of the workload compared to when using the
vanilla 3.10-rc2 tip kernel with no patches. When using a 3.10-rc2 tip
kernel with just patches 1-7, the performance improvement of the
workload over the vanilla 3.10-rc2 tip kernel was about 25%.
---

We also tried to include blocked load avg in balance. but find many
benchmark performance drop a lot! So, seems accumulating current
blocked_load_avg into cpu load isn't a good idea.  
The blocked_load_avg is decayed same as runnable load, sometime is far
bigger than runnable load, that drive tasks to other idle or slight
load cpu, than cause both performance and power issue. But if the
blocked load is decayed too fast, it lose its effect. 
Another issue of blocked load is that when waking up task, we can not 
know blocked load proportion of the task on cpu. So, the blocked load is
meaningless in wake affine decision.  

According to above problem, I can not figure out some way to use 
blocked_load_avg in balance now.

Anyway, since using runnable load avg in balance brings much benefit on
performance and power. and this patch was reviewed for long time. 
So maybe it's time to let it clobbered in some sub-maintain tree, like tip 
or linux-next.  Any comments?

Regards
Alex
[patch v7 1/8] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
[patch v7 2/8] sched: move few runnable tg variables into CONFIG_SMP
[patch v7 3/8] sched: set initial value of runnable avg for new
[patch v7 4/8] sched: fix slept time double counting in enqueue
[patch v7 5/8] sched: update cpu load after task_tick.
[patch v7 6/8] sched: compute runnable load avg in cpu_load and
[patch v7 7/8] sched: consider runnable load average in move_tasks
[patch v7 8/8] sched: remove blocked_load_avg in tg
