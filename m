Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaHKLhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:37:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38152 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaHKLhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:37:19 -0400
Subject: [RFC PATCH V2 09/19] sched: get rq potential maximum utilization
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
Date: Mon, 11 Aug 2014 17:06:58 +0530
Message-ID: <20140811113645.31956.19686.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-8236-0000-0000-00000481EE24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

Since the rt task priority is higher than fair tasks, cfs_rq utilization
is just the left of rt utilization.

When there are some cfs tasks in queue, the potential utilization may
be yielded, so mulitiplying cfs task number to get max potential
utilization of cfs. Then the rq utilization is sum of rt util and cfs
util.

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 031d115..60abaf4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3308,6 +3308,53 @@ static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
 	return cfs_bandwidth_used() && cfs_rq->throttle_count;
 }
 
+#ifdef CONFIG_SCHED_POWER
+static unsigned long scale_rt_util(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u64 total, age_stamp, avg;
+	s64 delta;
+
+	/*
+	 * Since we're reading these variables without serialization make sure
+	 * we read them once before doing sanity checks on them.
+	 */
+	age_stamp = ACCESS_ONCE(rq->age_stamp);
+	avg = ACCESS_ONCE(rq->rt_avg);
+
+	delta = rq_clock(rq) - age_stamp;
+	if (unlikely(delta < 0))
+		delta = 0;
+
+	total = sched_avg_period() + delta;
+
+	if (unlikely(total < avg)) {
+		/* Ensures that capacity won't go beyond full scaled value */
+		return SCHED_CAPACITY_SCALE;
+	}
+
+	if (unlikely((s64)total < SCHED_CAPACITY_SCALE))
+		total = SCHED_CAPACITY_SCALE;
+
+	total >>= SCHED_CAPACITY_SHIFT;
+
+	return div_u64(avg, total);
+}
+
+static unsigned int max_rq_util(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned int rt_util = scale_rt_util(cpu);
+	unsigned int cfs_util;
+	unsigned int nr_running;
+
+	cfs_util = (FULL_UTIL - rt_util) > rq->util ? rq->util
+			: (FULL_UTIL - rt_util);
+	nr_running = rq->nr_running ? rq->nr_running : 1;
+
+	return rt_util + cfs_util * nr_running;
+}
+#endif
 /*
  * Ensure that neither of the group entities corresponding to src_cpu or
  * dest_cpu are members of a throttled hierarchy when performing group

