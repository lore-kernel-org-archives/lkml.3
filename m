Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaHKLe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:34:28 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50876 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaHKLe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:34:27 -0400
Subject: [RFC PATCH V2 04/19] sched: add sched balance policies in kernel
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:04:07 +0530
Message-ID: <20140811113354.31956.76259.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-9332-0000-0000-000001A6A0F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

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
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c  |    5 +++++
 kernel/sched/sched.h |    7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86..77da534 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7800,6 +7800,11 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	return rr_interval;
 }
 
+#ifdef CONFIG_SCHED_POWER
+/* The default scheduler policy is 'performance'. */
+int __read_mostly sched_balance_policy = SCHED_POLICY_PERFORMANCE;
+#endif
+
 /*
  * All the scheduling class methods:
  */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 579712f..95fc013 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -23,6 +23,13 @@ extern atomic_long_t calc_load_tasks;
 extern long calc_load_fold_active(struct rq *this_rq);
 extern void update_cpu_load_active(struct rq *this_rq);
 
+#ifdef CONFIG_SCHED_POWER
+#define SCHED_POLICY_PERFORMANCE	(0x1)
+#define SCHED_POLICY_POWERSAVING	(0x2)
+
+extern int __read_mostly sched_balance_policy;
+#endif
+
 /*
  * Helpers for converting nanosecond timing to jiffy resolution
  */

