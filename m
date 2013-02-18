Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3BRFHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:07:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:23955 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab3BRFHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:07:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="258209957"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com,
        morten.rasmussen@arm.com
Subject: [patch v5 04/15] sched: add sched balance policies in kernel
Date: Mon, 18 Feb 2013 13:07:31 +0800
Message-Id: <1361164062-20111-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current scheduler behavior is just consider for larger performance
of system. So it try to spread tasks on more cpu sockets and cpu cores

To adding the consideration of power awareness, the patchset adds
2 kinds of scheduler policy: powersaving and balance. They will use
runnable load util in scheduler balancing. The current scheduling is taken
as performance policy.

performance: the current scheduling behaviour, try to spread tasks
                on more CPU sockets or cores. performance oriented.
powersaving: will pack tasks into few sched group until all LCPU in the
                group is full, power oriented.
balance    : will pack tasks into few sched group until group_capacity
                numbers CPU is full, balance between performance and
		powersaving.

The incoming patches will enable powersaving/balance scheduling in CFS.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c  | 3 +++
 kernel/sched/sched.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 350eb8d..2f98ffb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6105,6 +6105,9 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	return rr_interval;
 }
 
+/* The default scheduler policy is 'performance'. */
+int __read_mostly sched_balance_policy = SCHED_POLICY_PERFORMANCE;
+
 /*
  * All the scheduling class methods:
  */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ae3511e..7a19792 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -8,6 +8,12 @@
 
 extern __read_mostly int scheduler_running;
 
+#define SCHED_POLICY_PERFORMANCE	(0x1)
+#define SCHED_POLICY_POWERSAVING	(0x2)
+#define SCHED_POLICY_BALANCE		(0x4)
+
+extern int __read_mostly sched_balance_policy;
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
-- 
1.7.12

