Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3AXDHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:07:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:6332 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab3AXDHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:07:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="277724958"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v4 0/18] sched: simplified fork, release load avg and power awareness scheduling
Date: Thu, 24 Jan 2013 11:06:42 +0800
Message-Id: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the runnable info needs 345ms to accumulate, balancing
doesn't do well for many tasks burst waking. After talking with Mike
Galbraith, we are agree to just use runnable avg in power friendly 
scheduling and keep current instant load in performance scheduling for 
low latency.

So the biggest change in this version is removing runnable load avg in
balance and just using runnable data in power balance.

The patchset bases on Linus' tree, includes 3 parts,
** 1, bug fix and fork/wake balancing clean up. patch 1~5,
----------------------
the first patch remove one domain level. patch 2~5 simplified fork/wake
balancing, it can increase 10+% hackbench performance on our 4 sockets
SNB EP machine.

V3 change:
a, added the first patch to remove one domain level on x86 platform.
b, some small changes according to Namhyung Kim's comments, thanks!

** 2, bug fix of load avg and remove the CONFIG_FAIR_GROUP_SCHED limit
----------------------
patch 6~8, That using runnable avg in load balancing, with
two initial runnable variables fix.

V4 change:
a, remove runnable log avg using in balancing.

V3 change:
a, use rq->cfs.runnable_load_avg as cpu load not
rq->avg.load_avg_contrib, since the latter need much time to accumulate
for new forked task,
b, a build issue fixed with Namhyung Kim's reminder.

** 3, power awareness scheduling, patch 9~18.
----------------------
The subset implement/consummate the rough power aware scheduling
proposal: https://lkml.org/lkml/2012/8/13/139.
It defines 2 new power aware policy 'balance' and 'powersaving' and then
try to spread or pack tasks on each sched groups level according the
different scheduler policy. That can save much power when task number in
system is no more then LCPU number.

As mentioned in the power aware scheduler proposal, Power aware
scheduling has 2 assumptions:
1, race to idle is helpful for power saving
2, pack tasks on less sched_groups will reduce power consumption

The first assumption make performance policy take over scheduling when
system busy.
The second assumption make power aware scheduling try to move
disperse tasks into fewer groups until that groups are full of tasks.

Some power testing data is in the last 2 patches.

V4 change:
a, fix few bugs and clean up code according to Morten Rasmussen, Mike
Galbraith and Namhyung Kim. Thanks!
b, take Morten's suggestion to set different criteria for different
policy in small task packing.
c, shorter latency in power aware scheduling.

V3 change:
a, engaged nr_running in max potential utils consideration in periodic
power balancing.
b, try exec/wake small tasks on running cpu not idle cpu.

V2 change:
a, add lazy power scheduling to deal with kbuild like benchmark.


Thanks Fengguang Wu for the build testing of this patchset!

Any comments are appreciated!

-- Thanks Alex

[patch v4 01/18] sched: set SD_PREFER_SIBLING on MC domain to reduce
[patch v4 02/18] sched: select_task_rq_fair clean up
[patch v4 03/18] sched: fix find_idlest_group mess logical
[patch v4 04/18] sched: don't need go to smaller sched domain
[patch v4 05/18] sched: quicker balancing on fork/exec/wake
[patch v4 06/18] sched: give initial value for runnable avg of sched
[patch v4 07/18] sched: set initial load avg of new forked task
[patch v4 08/18] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
[patch v4 09/18] sched: add sched_policies in kernel
[patch v4 10/18] sched: add sysfs interface for sched_policy
[patch v4 11/18] sched: log the cpu utilization at rq
[patch v4 12/18] sched: add power aware scheduling in fork/exec/wake
[patch v4 13/18] sched: packing small tasks in wake/exec balancing
[patch v4 14/18] sched: add power/performance balance allowed flag
[patch v4 15/18] sched: pull all tasks from source group
[patch v4 16/18] sched: don't care if the local group has capacity
[patch v4 17/18] sched: power aware load balance,
[patch v4 18/18] sched: lazy power balance
