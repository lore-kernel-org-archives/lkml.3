Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab3H2UFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:05:40 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:10725 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab3H2UFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:05:39 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, pjt@google.com,
        preeti@linux.vnet.ibm.com, akpm@linux-foundation.org, mgorman@suse.de,
        riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: [PATCH v4 0/3] sched: Limiting idle balance
Date: Thu, 29 Aug 2013 13:05:33 -0700
Message-Id: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches modify and add to the way we limit idle balancing. The first
patch reduces the chance we overestimate the avg_idle guestimator. The second
patch makes idle balance compare the avg_idle with the max cost we ever spend
on a new idle load balance per sched domain to limit idle balance. 

The third is an RFC patch which periodically decays each domain's max
newidle balance costs and compares avg_idle sd with max newidle balance +
sched_migration_cost to determine if we should skip balancing.

These changes further reduce the chance we attempt idle balancing when the time
a CPU remains idle is short and is not more than the cost to do the balancing.

The first 2 patches provide good performance boosts of many AIM7 workloads on an
8 socket (80 core) machine. The table below compares the average jobs per minute
at 10-100, 200-1000, and 1100-2000 users between the vanilla 3.11-rc7 kernel and
the 3.11-rc7 kernel with the first 2 patches with Hyperthreading enabled.

----------------------------------------------------------------
workload     | % improvement   | % improvement  | % improvement
             | with patch      | with patch     | with patch
             | 1100-2000 users | 200-1000 users | 10-100 users
----------------------------------------------------------------
alltests     | +12.2%          |  +7.5%         |  +1.0%
----------------------------------------------------------------
compute      |  -0.6%          |  -0.8%         |  +0.1%
----------------------------------------------------------------
custom       | +24.0%          | +25.03         | +16.4%
----------------------------------------------------------------
disk         | +11.6%          | +21.3%         |  +0.1%
----------------------------------------------------------------
fserver      | +74.7%          | +34.7%         |  -2.7%
----------------------------------------------------------------
high_systime | +21.2%          | +10.5%         |  +0.6%
----------------------------------------------------------------
new_fserver  | +59.8%          | +23.7%         |  -1.2%
----------------------------------------------------------------
shared       |  +9.0%          | +13.0%         |  +6.5%
----------------------------------------------------------------

Jason Low (3):
  sched: Reduce overestimating rq->avg_idle
  sched: Consider max cost of idle balance per sched domain
  sched: Periodically decay max cost of idle balance

 arch/metag/include/asm/topology.h |    2 +
 include/linux/sched.h             |    4 +++
 include/linux/topology.h          |    6 ++++
 kernel/sched/core.c               |   10 ++++---
 kernel/sched/fair.c               |   48 ++++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h              |    3 ++
 6 files changed, 68 insertions(+), 5 deletions(-)

