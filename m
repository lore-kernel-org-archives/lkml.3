Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab3CYPjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:39:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49220 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab3CYPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:39:21 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, pjt@google.com,
        vincent.guittot@linaro.org
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, corbet@lwn.net, amit.kucheria@linaro.org,
        robin.randhawa@arm.com, morten.rasmussen@arm.com
Subject: [RFC PATCH 0/2] sched: Task placement on mixed cpu_power systems
Date: Mon, 25 Mar 2013 15:40:04 +0000
Message-Id: <1364226006-21419-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 25 Mar 2013 15:39:19.0885 (UTC) FILETIME=[EA9137D0:01CE296E]
X-MC-Unique: 113032515392003201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PFdkDi028455

In multiprocessor systems with cpus with different compute capabilities it is
essential for performance that heavy tasks are scheduled on the most capable
cpus. The current scheduler does not handle such performance heterogeneous
systems optimally. This patch set proposes a small set of changes that
significantly improves performance on these systems.

Looking at the current scheduler design the most obvious way to represent the
compute capability of each individual cpu is to use cpu_power as this is
already used for load-balancing. The recently included entity load-tracking
adds the infrastructure to distinguish between heavy and light tasks.

The proposed changes moves heavy tasks to cpus with higher cpu_power to get
better performance and fixes load-balancing issues for caused by the cpu_power
difference when having one heavy task per cpu.

The patches requires load-balancing to be based on entity load-tracking and
there uses Alex Shi's patch set as the starting point:

https://lkml.org/lkml/2013/1/25/767

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

Note:
The cpu_power setup code is already present in 3.9-rc2, but the device
tree provided for ARM vexpress TC2 is missing frequency information. Adding
this will give the cpu_powers listed above.

Morten

Morten Rasmussen (1):
  sched: Pull tasks from cpus with multiple tasks when idle

Vincent Guittot (1):
  sched: Force migration on a better cpu

 kernel/sched/fair.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 4 deletions(-)

-- 
1.7.9.5


