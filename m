Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab3C3OgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:36:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764Ab3C3Ofn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:35:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568190"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 04/21] sched: add sched balance policies in kernel
Date: Sat, 30 Mar 2013 22:34:51 +0800
Message-Id: <1364654108-16307-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current scheduler behavior is just consider for larger performance
of system. So it try to spread tasks on more cpu sockets and cpu cores

To adding the consideration of power awareness, the patchset adds
a powersaving scheduler policy. It will use runnable load util in
scheduler balancing. The current scheduling is taken as performance
policy.

performance: the current scheduling behaviour, try to spread tasks
                on more CPU sockets or cores. performance oriented.
powersaving: will pack tasks into few sched group until all LCPU in the
                group is full, power oriented.

The incoming patches will enable powersaving scheduling in CFS.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c  | 3 +++
 kernel/sched/sched.h | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 026e959..61ee178 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6093,6 +6093,9 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	return rr_interval;
 }
 
+/* The default scheduler policy is 'performance'. */
+int __read_mostly sched_balance_policy = SCHED_POLICY_PERFORMANCE;
+
 /*
  * All the scheduling class methods:
  */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7f36024f..804ee41 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -10,6 +10,11 @@
 
 extern __read_mostly int scheduler_running;
 
+#define SCHED_POLICY_PERFORMANCE	(0x1)
+#define SCHED_POLICY_POWERSAVING	(0x2)
+
+extern int __read_mostly sched_balance_policy;
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
-- 
1.7.12

