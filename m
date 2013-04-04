Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763191Ab3DDCE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:04:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:29715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785Ab3DDCCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534496"
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
Subject: [patch v7 14/21] sched: add power/performance balance allow flag
Date: Thu,  4 Apr 2013 10:00:55 +0800
Message-Id: <1365040862-8390-15-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
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
index 6145ed2..f861427 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4013,6 +4013,8 @@ static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 #define LBF_ALL_PINNED	0x01
 #define LBF_NEED_BREAK	0x02
 #define LBF_SOME_PINNED 0x04
+#define LBF_POWER_BAL	0x08	/* if power balance allowed */
+#define LBF_PERF_BAL	0x10	/* if performance balance allowed */
 
 struct lb_env {
 	struct sched_domain	*sd;
@@ -5175,6 +5177,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
+		.flags		= LBF_PERF_BAL,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
-- 
1.7.12

