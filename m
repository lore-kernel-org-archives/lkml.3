Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3C3OgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:36:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab3C3OgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568326"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 15/21] sched: add power/performance balance allow flag
Date: Sat, 30 Mar 2013 22:35:02 +0800
Message-Id: <1364654108-16307-16-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a sched domain is idle enough for regular power balance, LBF_POWER_BAL
will be set, LBF_PERF_BAL will be clean. If a sched domain is busy,
their value will be set oppositely.

If the domain is suitable for power balance, but balance should not
be down by this cpu(this cpu is already idle or full), both of flags
are cleared to wait a suitable cpu to do power balance.
That mean no any balance, neither power balance nor performance balance
will be done on this cpu.

Above logical will be implemented by incoming patches.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0e48e55..adccdb8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4023,6 +4023,8 @@ static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 #define LBF_ALL_PINNED	0x01
 #define LBF_NEED_BREAK	0x02
 #define LBF_SOME_PINNED 0x04
+#define LBF_POWER_BAL	0x08	/* if power balance allowed */
+#define LBF_PERF_BAL	0x10	/* if performance balance allowed */
 
 struct lb_env {
 	struct sched_domain	*sd;
@@ -5185,6 +5187,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
+		.flags		= LBF_PERF_BAL,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
-- 
1.7.12

