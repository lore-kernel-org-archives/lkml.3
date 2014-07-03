Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbaGCQbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:31:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45416 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268AbaGCQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:17 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 11/23] sched: Introduce an unweighted cpu_load array
Date: Thu,  3 Jul 2014 17:25:58 +0100
Message-Id: <1404404770-323-12-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:15.0084 (UTC) FILETIME=[82A43EC0:01CF96DB]
X-MC-Unique: 114070317261510801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GVgDd010728

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Maintain an unweighted (uw) cpu_load array as the uw counterpart
of rq.cpu_load[].

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c  |    4 +++-
 kernel/sched/proc.c  |   22 ++++++++++++++++++----
 kernel/sched/sched.h |    1 +
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d7544a..d814064 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7114,8 +7114,10 @@ void __init sched_init(void)
 		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
 #endif
 
-		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
+		for (j = 0; j < CPU_LOAD_IDX_MAX; j++) {
 			rq->cpu_load[j] = 0;
+			rq->uw_cpu_load[j] = 0;
+		}
 
 		rq->last_load_update_tick = jiffies;
 
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 16f5a30..2260092 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -471,6 +471,7 @@ decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
  * every tick. We fix it up based on jiffies.
  */
 static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
+			      unsigned long uw_this_load,
 			      unsigned long pending_updates)
 {
 	int i, scale;
@@ -479,14 +480,20 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 
 	/* Update our load: */
 	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
+	this_rq->uw_cpu_load[0] = uw_this_load; /* Fasttrack for idx 0 */
 	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
-		unsigned long old_load, new_load;
+		unsigned long old_load, new_load, uw_old_load, uw_new_load;
 
 		/* scale is effectively 1 << i now, and >> i divides by scale */
 
 		old_load = this_rq->cpu_load[i];
 		old_load = decay_load_missed(old_load, pending_updates - 1, i);
 		new_load = this_load;
+
+		uw_old_load = this_rq->uw_cpu_load[i];
+		uw_old_load = decay_load_missed(uw_old_load,
+				pending_updates - 1, i);
+		uw_new_load = uw_this_load;
 		/*
 		 * Round up the averaging division if load is increasing. This
 		 * prevents us from getting stuck on 9 if the load is 10, for
@@ -494,8 +501,12 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 		 */
 		if (new_load > old_load)
 			new_load += scale - 1;
+		if (uw_new_load > uw_old_load)
+			uw_new_load += scale - 1;
 
 		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
+		this_rq->uw_cpu_load[i] = (uw_old_load * (scale - 1) +
+						uw_new_load) >> i;
 	}
 
 	sched_avg_update(this_rq);
@@ -535,6 +546,7 @@ void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
 	unsigned long load = get_rq_runnable_load(this_rq);
+	unsigned long uw_load = this_rq->cfs.uw_runnable_load_avg;
 	unsigned long pending_updates;
 
 	/*
@@ -546,7 +558,7 @@ void update_idle_cpu_load(struct rq *this_rq)
 	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
 	this_rq->last_load_update_tick = curr_jiffies;
 
-	__update_cpu_load(this_rq, load, pending_updates);
+	__update_cpu_load(this_rq, load, uw_load, pending_updates);
 }
 
 /*
@@ -569,7 +581,7 @@ void update_cpu_load_nohz(void)
 		 * We were idle, this means load 0, the current load might be
 		 * !0 due to remote wakeups and the sort.
 		 */
-		__update_cpu_load(this_rq, 0, pending_updates);
+		__update_cpu_load(this_rq, 0, 0, pending_updates);
 	}
 	raw_spin_unlock(&this_rq->lock);
 }
@@ -581,11 +593,13 @@ void update_cpu_load_nohz(void)
 void update_cpu_load_active(struct rq *this_rq)
 {
 	unsigned long load = get_rq_runnable_load(this_rq);
+	unsigned long uw_load = this_rq->cfs.uw_runnable_load_avg;
+
 	/*
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, load, 1);
+	__update_cpu_load(this_rq, load, uw_load, 1);
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d7d2ee2..455d152 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -521,6 +521,7 @@ struct rq {
 #endif
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+	unsigned long uw_cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ_COMMON
 	u64 nohz_stamp;
-- 
1.7.9.5


