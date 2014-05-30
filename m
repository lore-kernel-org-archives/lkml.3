Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790AbaE3Ok7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:40:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:55008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933336AbaE3Ok4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:40:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548946819"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, bsegall@google.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com, yuyang.du@intel.com
Subject: [RFC PATCH 03/16 v3] How CC accrues with run queue change and time
Date: Fri, 30 May 2014 14:35:59 +0800
Message-Id: <1401431772-14320-4-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is natural to use task concurrency (running tasks in the rq) as load
indicator. We calculate CC for task concurrency by two steps:

1) Divide continuous time into periods of time, and average task concurrency
in period, for tolerating the transient bursts:

a = sum(concurrency * time) / period

2) Exponentially decay past periods, and synthesize them all, for hysteresis
to load drops or resilience to load rises (let f be decaying factor, and a_x
the xth period average since period 0):

s = a_n + f^1 * a_n-1 + f^2 * a_n-2 +, ..., + f^(n-1) * a_1 + f^n * a_0

To sum up, CPU CC is 1) decayed average run queue length, or 2) run-queue-lengh-
weighted CPU utilization.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |  255 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 255 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2c1f453..f7910cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2549,6 +2549,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
 
+static inline void update_cpu_concurrency(struct rq *rq);
+
 /*
  * Update the rq's load with the elapsed running time before entering
  * idle. if the last scheduled task is not a CFS task, idle_enter will
@@ -2582,6 +2584,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
 					      int force_update) {}
 
+static inline void update_cpu_concurrency(struct rq *rq) {}
+
 static inline int idle_balance(struct rq *rq)
 {
 	return 0;
@@ -7698,6 +7702,238 @@ __init void init_sched_fair_class(void)
  * efficiency without sacrificing performance.
  */
 
+/*
+ * the sum period of time is 2^26 ns (~64) by default
+ */
+unsigned int sysctl_sched_cc_sum_period = 26UL;
+
+/*
+ * the number of sum periods, after which the original
+ * will be reduced/decayed to half. we now make it
+ * unchangeable.
+ */
+static const unsigned int cc_decay_rate = 1UL;
+
+/*
+ * the contrib period of time is 2^10 (~1us) by default,
+ * us has better precision than ms, and
+ * 1024 makes use of faster shift than div
+ */
+static unsigned int cc_contrib_period = 10UL;
+
+/*
+ * the concurrency is scaled up for decaying,
+ * thus, concurrency 1 is effectively 2^cc_resolution (1024),
+ * which can be halved by 10 half-life periods
+ */
+static unsigned int cc_resolution = 10UL;
+
+/*
+ * after this number of half-life periods, even
+ * (1>>32)-1 (which is sufficiently large) is less than 1
+ */
+static unsigned int cc_decay_max_pds = 32UL;
+
+static inline u32 cc_scale_up(unsigned int c)
+{
+	return c << cc_resolution;
+}
+
+static inline u32 cc_scale_down(unsigned int c)
+{
+	return c >> cc_resolution;
+}
+
+/* from nanoseconds to sum periods */
+static inline u64 cc_sum_pds(u64 n)
+{
+	return n >> sysctl_sched_cc_sum_period;
+}
+
+/* from sum period to timestamp in ns */
+static inline u64 cc_timestamp(u64 p)
+{
+	return p << sysctl_sched_cc_sum_period;
+}
+
+/*
+ * from nanoseconds to contrib periods, because
+ * ns so risky that can overflow cc->contrib
+ */
+static inline u64 cc_contrib_pds(u64 n)
+{
+	return n >> cc_contrib_period;
+}
+
+/*
+ * cc_decay_factor only works for 32bit integer,
+ * cc_decay_factor_x, x indicates the number of periods
+ * as half-life (cc_decay_rate)
+ */
+static const u32 cc_decay_factor[] = {
+	0xFFFFFFFF,
+};
+
+/*
+ * cc_decayed_sum depends on cc_resolution (fixed 10),
+ * and cc_decay_rate (half-life)
+ */
+static const u32 cc_decayed_sum[] = {
+	0, 512, 768, 896, 960, 992,
+	1008, 1016, 1020, 1022, 1023,
+};
+
+/*
+ * the last index of cc_decayed_sum array
+ */
+static u32 cc_decayed_sum_len =
+	sizeof(cc_decayed_sum) / sizeof(cc_decayed_sum[0]) - 1;
+
+/*
+ * decay concurrency at some decay rate
+ */
+static inline u64 decay_cc(u64 cc, u64 periods)
+{
+	u32 periods_l;
+
+	if (periods <= 0)
+		return cc;
+
+	if (unlikely(periods >= cc_decay_max_pds))
+		return 0;
+
+	/* now period is not too large */
+	periods_l = (u32)periods;
+	if (periods_l >= cc_decay_rate) {
+		cc >>= periods_l / cc_decay_rate;
+		periods_l %= cc_decay_rate;
+	}
+
+	if (!periods_l)
+		return cc;
+
+	/* since cc_decay_rate is 1, we never get here */
+	cc *= cc_decay_factor[periods_l];
+
+	return cc >> 32;
+}
+
+/*
+ * add missed periods by predefined constants
+ */
+static inline u64 cc_missed_pds(u64 periods)
+{
+	if (periods <= 0)
+		return 0;
+
+	if (periods > cc_decayed_sum_len)
+		periods = cc_decayed_sum_len;
+
+	return cc_decayed_sum[periods];
+}
+
+/*
+ * scale up nr_running, because we decay
+ */
+static inline u32 cc_weight(unsigned int nr_running)
+{
+	/*
+	 * scaling factor, this should be tunable
+	 */
+	return cc_scale_up(nr_running);
+}
+
+static inline void
+__update_concurrency(struct rq *rq, u64 now, struct cpu_concurrency_t *cc)
+{
+	u64 sum_pds, sum_pds_s, sum_pds_e;
+	u64 contrib_pds, ts_contrib, contrib_pds_one;
+	u64 sum_now = 0;
+	u32 weight;
+	int updated = 0;
+
+	/*
+	 * guarantee contrib_timestamp always >= sum_timestamp,
+	 * and sum_timestamp is at period boundary
+	 */
+	if (now <= cc->sum_timestamp) {
+		cc->sum_timestamp = cc_timestamp(cc_sum_pds(now));
+		cc->contrib_timestamp = now;
+		return;
+	}
+
+	weight = cc_weight(cc->nr_running);
+
+	/* start and end of sum periods */
+	sum_pds_s = cc_sum_pds(cc->sum_timestamp);
+	sum_pds_e = cc_sum_pds(now);
+	sum_pds = sum_pds_e - sum_pds_s;
+	/* number of contrib periods in one sum period */
+	contrib_pds_one = cc_contrib_pds(cc_timestamp(1));
+
+	/*
+	 * if we have passed at least one period,
+	 * we need to do four things:
+	 */
+	if (sum_pds) {
+		/* 1) complete the last period */
+		ts_contrib = cc_timestamp(sum_pds_s + 1);
+		contrib_pds = cc_contrib_pds(ts_contrib);
+		contrib_pds -= cc_contrib_pds(cc->contrib_timestamp);
+
+		if (likely(contrib_pds))
+			cc->contrib += weight * contrib_pds;
+
+		cc->contrib = div64_u64(cc->contrib, contrib_pds_one);
+
+		cc->sum += cc->contrib;
+		cc->contrib = 0;
+
+		/* 2) update/decay them */
+		cc->sum = decay_cc(cc->sum, sum_pds);
+		sum_now = decay_cc(cc->sum, sum_pds - 1);
+
+		/* 3) compensate missed periods if any */
+		sum_pds -= 1;
+		cc->sum += cc->nr_running * cc_missed_pds(sum_pds);
+		sum_now += cc->nr_running * cc_missed_pds(sum_pds - 1);
+		updated = 1;
+
+		/* 4) update contrib timestamp to period boundary */
+		ts_contrib = cc_timestamp(sum_pds_e);
+
+		cc->sum_timestamp = ts_contrib;
+		cc->contrib_timestamp = ts_contrib;
+	}
+
+	/* current period */
+	contrib_pds = cc_contrib_pds(now);
+	contrib_pds -= cc_contrib_pds(cc->contrib_timestamp);
+
+	if (likely(contrib_pds))
+		cc->contrib += weight * contrib_pds;
+
+	/* new nr_running for next update */
+	cc->nr_running = rq->nr_running;
+
+	/*
+	 * we need to account for the current sum period,
+	 * if now has passed 1/2 of sum period, we contribute,
+	 * otherwise, we use the last complete sum period
+	 */
+	contrib_pds = cc_contrib_pds(now - cc->sum_timestamp);
+
+	if (contrib_pds > contrib_pds_one / 2) {
+		sum_now = div64_u64(cc->contrib, contrib_pds);
+		sum_now += cc->sum;
+		updated = 1;
+	}
+
+	if (updated == 1)
+		cc->sum_now = sum_now;
+	cc->contrib_timestamp = now;
+}
+
 void init_cpu_concurrency(struct rq *rq)
 {
 	rq->concurrency.sum = 0;
@@ -7709,4 +7945,23 @@ void init_cpu_concurrency(struct rq *rq)
 	rq->concurrency.unload = 0;
 }
 
+/*
+ * we update cpu concurrency at:
+ * 1) enqueue task, which increases concurrency
+ * 2) dequeue task, which decreases concurrency
+ * 3) periodic scheduler tick, in case no en/dequeue for long
+ * 4) enter and exit idle
+ * 5) update_blocked_averages
+ */
+static void update_cpu_concurrency(struct rq *rq)
+{
+	/*
+	 * protected under rq->lock
+	 */
+	struct cpu_concurrency_t *cc = &rq->concurrency;
+	u64 now = rq->clock;
+
+	__update_concurrency(rq, now, cc);
+}
+
 #endif /* CONFIG_SMP */
-- 
1.7.9.5

