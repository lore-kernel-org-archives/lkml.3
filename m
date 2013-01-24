Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3AXDJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:09:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:37140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab3AXDHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:07:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="277725072"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v4 14/18] sched: add power/performance balance allowed flag
Date: Thu, 24 Jan 2013 11:06:56 +0800
Message-Id: <1358996820-23036-15-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a sched domain is idle enough for power balance, power_lb
will be set, perf_lb will be clean. If a sched domain is busy,
their value will be set oppositely.

If the domain is suitable for power balance, but balance should not
be down by this cpu, both of perf_lb and power_lb are cleared to wait a
suitable cpu to do power balance. That mean no any balance, neither
power balance nor performance balance will be done on the balance cpu.

Above logical will be implemented by following patches.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eede065..19624f4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4039,6 +4039,8 @@ struct lb_env {
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+	int			power_lb;  /* if power balance needed */
+	int			perf_lb;   /* if performance balance needed */
 };
 
 /*
@@ -5180,6 +5182,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
+		.power_lb	= 0,
+		.perf_lb	= 1,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
-- 
1.7.12

