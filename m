Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3D0F0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 01:26:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:2129 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab3D0F0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 01:26:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,562,1363158000"; 
   d="scan'208";a="328478821"
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
Subject: [PATCH v4 0/6] sched: use runnable load based balance
Date: Sat, 27 Apr 2013 13:25:38 +0800
Message-Id: <1367040344-14485-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset bases on tip/sched/core.

The patchset remove the burst wakeup detection which had worked fine on 3.8
kernel, since the aim7 is very imbalance. But rwsem write lock stealing 
enabled in 3.9 kernel. aim7 imbalance disappeared. So the burst wakeup
care doesn't needed. 

It was tested on Intel core2, NHM, SNB, IVB, 2 and 4 sockets machines with
benchmark kbuild, aim7, dbench, tbench, hackbench, fileio-cfq(sysbench)

On SNB EP 4 sockets machine, the hackbench increased about 50%, and result
become stable. on other machines, hackbench increased about 2~5%.
no clear performance change on other benchmarks.

and Michael Wang had tested the pgbench on his box:
https://lkml.org/lkml/2013/4/2/1022
---
Done, here the results of pgbench without the last patch on my box:

| db_size | clients |  tps  |   |  tps  |
+---------+---------+-------+   +-------+
| 22 MB   |       1 | 10662 |   | 10679 |
| 22 MB   |       2 | 21483 |   | 21471 |
| 22 MB   |       4 | 42046 |   | 41957 |
| 22 MB   |       8 | 55807 |   | 55684 |
| 22 MB   |      12 | 50768 |   | 52074 |
| 22 MB   |      16 | 49880 |   | 52879 |
| 22 MB   |      24 | 45904 |   | 53406 |
| 22 MB   |      32 | 43420 |   | 54088 |	+24.57%
| 7484 MB |       1 |  7965 |   |  7725 |
| 7484 MB |       2 | 19354 |   | 19405 |
| 7484 MB |       4 | 37552 |   | 37246 |
| 7484 MB |       8 | 48655 |   | 50613 |
| 7484 MB |      12 | 45778 |   | 47639 |
| 7484 MB |      16 | 45659 |   | 48707 |
| 7484 MB |      24 | 42192 |   | 46469 |
| 7484 MB |      32 | 36385 |   | 46346 |	+27.38%
| 15 GB   |       1 |  7677 |   |  7727 |
| 15 GB   |       2 | 19227 |   | 19199 |
| 15 GB   |       4 | 37335 |   | 37372 |
| 15 GB   |       8 | 48130 |   | 50333 |
| 15 GB   |      12 | 45393 |   | 47590 |
| 15 GB   |      16 | 45110 |   | 48091 |
| 15 GB   |      24 | 41415 |   | 47415 |
| 15 GB   |      32 | 35988 |   | 45749 |	+27.12%
---

and also tested by morten.rasmussen@arm.com
http://comments.gmane.org/gmane.linux.kernel/1463371
---
The patches are based in 3.9-rc2 and have been tested on an ARM vexpress TC2
big.LITTLE testchip containing five cpus: 2xCortex-A15 + 3xCortex-A7.
Additional testing and refinements might be needed later as more sophisticated
platforms become available.

cpu_power A15: 1441
cpu_power A7:   606

Benchmarks:
cyclictest:	cyclictest -a -t 2 -n -D 10
hackbench:	hackbench (default settings)
sysbench_1t:	sysbench --test=cpu --num-threads=1 --max-requests=1000 run
sysbench_2t:	sysbench --test=cpu --num-threads=2 --max-requests=1000 run
sysbench_5t:	sysbench --test=cpu --num-threads=5 --max-requests=1000 run 


Mixed cpu_power:
Average times over 20 runs normalized to 3.9-rc2 (lower is better):
		3.9-rc2		+shi		+shi+patches	Improvement
cyclictest
	AVG	74.9		74.5		75.75		-1.13%
	MIN	69		69		69
	MAX	88		88		94	
hackbench
	AVG	2.17		2.09		2.09		3.90%
	MIN	2.10		1.95		2.02
	MAX	2.25		2.48		2.17
sysbench_1t
	AVG	25.13*		16.47'		16.48		34.43%
	MIN	16.47		16.47		16.47		
	MAX	33.78		16.48		16.54
sysbench_2t
	AVG	19.32		18.19		16.51		14.55%
	MIN	16.48		16.47		16.47
	MAX	22.15		22.19		16.61
sysbench_5t
	AVG	27.22		27.71		24.14		11.31%
	MIN	25.42		27.66		24.04
	MAX	27.75		27.86		24.31

* The unpatched 3.9-rc2 scheduler gives inconsistent performance as tasks may
randomly be placed on either A7 or A15 cores. The max/min values reflects this
behaviour. A15 and A7 performance are ~16.5 and ~33.5 respectively.

' While Alex Shi's patches appear to solve the performance inconsistency for
sysbench_1t, it is not the true picture for all workloads. This can be seen for
sysbench_2t.

To ensure that the proposed changes does not affect normal SMP systems, the
same benchmarks have been run on a 2xCortex-A15 configuration as well:

SMP:
Average times over 20 runs normalized to 3.9-rc2 (lower is better):
		3.9-rc2		+shi		+shi+patches	Improvement
cyclictest
	AVG	78.6		75.3		77.6		1.34%
	MIN	69		69		69
	MAX	135		98		125
hackbench
	AVG	3.55		3.54		3.55		0.06%
	MIN	3.51		3.48		3.49
	MAX	3.66		3.65		3.67
sysbench_1t
	AVG	16.48		16.48		16.48		-0.03%
	MIN	16.47		16.48		16.48
	MAX	16.49		16.48		16.48
sysbench_2t
	AVG	16.53		16.53		16.54		-0.05%
	MIN	16.47		16.47		16.48
	MAX	16.59		16.57		16.59
sysbench_5t
	AVG	41.16		41.15		41.15		0.04%
	MIN	41.14		41.13		41.11
	MAX	41.35		41.19		41.17
---

Peter, 
Would you like to consider pick up the patchset? or give some comments? :)

Best regards
Alex

[PATCH v4 1/6] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
[PATCH v4 2/6] sched: set initial value of runnable avg for new
[PATCH v4 3/6] sched: update cpu load after task_tick.
[PATCH v4 4/6] sched: compute runnable load avg in cpu_load and
[PATCH v4 5/6] sched: consider runnable load average in move_tasks
[PATCH v4 6/6] sched: consider runnable load average in
