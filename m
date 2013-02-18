Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3BRFIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:08:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:23970 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3BRFIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:08:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="258210052"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com,
        morten.rasmussen@arm.com
Subject: [patch v5 11/15] sched: add power/performance balance allow flag
Date: Mon, 18 Feb 2013 13:07:38 +0800
Message-Id: <1361164062-20111-12-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a sched domain is idle enough for regular power balance, power_lb
will be set, perf_lb will be clean. If a sched domain is busy,
their value will be set oppositely.

If the domain is suitable for power balance, but balance should not
be down by this cpu(this cpu is already idle or full), both of perf_lb
 and power_lb are cleared to wait a suitable cpu to do power balance.
That mean no any balance, neither power balance nor performance balance
will be done on this cpu.

Above logical will be implemented by incoming patches.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2e8131d..0047856 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4053,6 +4053,8 @@ struct lb_env {
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+	int			power_lb;  /* if power balance needed */
+	int			perf_lb;   /* if performance balance needed */
 };
 
 /*
@@ -5195,6 +5197,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
+		.power_lb	= 0,
+		.perf_lb	= 1,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
-- 
1.7.12

