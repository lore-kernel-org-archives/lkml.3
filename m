Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3IMS06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:26:58 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10938 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3IMS05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:26:57 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, pjt@google.com,
        preeti@linux.vnet.ibm.com, akpm@linux-foundation.org, mgorman@suse.de,
        riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com, chegu_vinod@hp.com
Subject: [PATCH v5 0/3] sched: Limiting idle balance
Date: Fri, 13 Sep 2013 11:26:50 -0700
Message-Id: <1379096813-3032-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4->v5
- We don't use the this_rq->avg_idle < this_rq->max_idle_balance_cost check.
  However, we kept the old rq->avg_idle < sysctl_sched_migration_cost since
  I saw some performance benefits with it.
- Substitute smp_processor_id() with this_cpu.
- Increase the decay to 1% per second.

These patches modify and add to the way we limit idle balancing. The first
patch reduces the chance we overestimate the avg_idle guestimator. The second
patch makes idle balance compare the avg_idle with the max cost we ever spend
on a new idle load balance per sched domain to limit idle balance. The third
patch periodically decays each domain's max newidle balance costs.

These changes further reduce the chance we attempt idle balancing when the time
a CPU remains idle is short and is not more than the cost to do the balancing.

The table below compares the average jobs per minute when running AIM7 on
an 8 socket (80 core) machine at 10-100, 200-1000, and 1100-2000 users between
the vanilla 3.11 tip kernel and the 3.11 tip kernel with Hyperthreading enabled.
Out of the AIM7 workloads, fserver benefited most with this change.

Note: The gains weren't as large as with the v4 patch due to not having
the if (this_rq->avg_idle < this_rq->max_idle_balance_cost) check.

----------------------------------------------------------------
workload     | % improvement   | % improvement  | % improvement
             | with patch      | with patch     | with patch
             | 1100-2000 users | 200-1000 users | 10-100 users
----------------------------------------------------------------
alltests     |  +2.5%          |  +2.7%         |  +0.0%
----------------------------------------------------------------
compute      |  +0.2%          |  -0.3%         |  -0.5%
----------------------------------------------------------------
custom       |  +4.7%          |  +1.7%         |  +3.5%
----------------------------------------------------------------
disk         |  +3.0%          |  +1.9%         |  +4.8%
----------------------------------------------------------------
fserver      | +27.0%          |  +7.7%         |  +2.2%
----------------------------------------------------------------
high_systime |  +4.1%          |  +3.0%         |  +0.2%
----------------------------------------------------------------
new_fserver  | +23.1%          |  +5.1%         |  +0.0%
----------------------------------------------------------------
shared       |  +3.0%          |  +4.5%         |  +1.4%
----------------------------------------------------------------

Jason Low (3):
  sched: Reduce overestimating rq->avg_idle
  sched: Consider max cost of idle balance per sched domain
  sched: Periodically decay max cost of idle balance

 arch/metag/include/asm/topology.h |    2 +
 include/linux/sched.h             |    4 +++
 include/linux/topology.h          |    6 ++++
 kernel/sched/core.c               |   10 ++++---
 kernel/sched/fair.c               |   54 ++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h              |    3 ++
 6 files changed, 68 insertions(+), 11 deletions(-)

