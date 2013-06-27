Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3F0JCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:02:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3F0JCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:47 -0400
Date: Thu, 27 Jun 2013 02:02:15 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-b92486cbf2aa230d00f160664858495c81d2b37b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, alex.shi@intel.com, tglx@linutronix.de,
        guz.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, alex.shi@intel.com,
        guz.fnst@cn.fujitsu.com
In-Reply-To: <1371694737-29336-7-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-7-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Compute runnable load avg in cpu_load and cpu_avg_load_per_task
Git-Commit-ID: b92486cbf2aa230d00f160664858495c81d2b37b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:02:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b92486cbf2aa230d00f160664858495c81d2b37b
Gitweb:     http://git.kernel.org/tip/b92486cbf2aa230d00f160664858495c81d2b37b
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:50 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:35 +0200

sched: Compute runnable load avg in cpu_load and cpu_avg_load_per_task

They are the base values in load balance, update them with rq runnable
load average, then the load balance will consider runnable load avg
naturally.

We also try to include the blocked_load_avg as cpu load in balancing,
but that cause kbuild performance drop 6% on every Intel machine, and
aim7/oltp drop on some of 4 CPU sockets machines.
Or only add blocked_load_avg into get_rq_runable_load, hackbench still
drop a little on NHM EX.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-7-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |  5 +++--
 kernel/sched/proc.c | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9bbc303..e6d82ca 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2963,7 +2963,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -3008,9 +3008,10 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+	unsigned long load_avg = rq->cfs.runnable_load_avg;
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return load_avg / nr_running;
 
 	return 0;
 }
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index bb3a6a0..ce5cd48 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -501,6 +501,18 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 	sched_avg_update(this_rq);
 }
 
+#ifdef CONFIG_SMP
+unsigned long get_rq_runnable_load(struct rq *rq)
+{
+	return rq->cfs.runnable_load_avg;
+}
+#else
+unsigned long get_rq_runnable_load(struct rq *rq)
+{
+	return rq->load.weight;
+}
+#endif
+
 #ifdef CONFIG_NO_HZ_COMMON
 /*
  * There is no sane way to deal with nohz on smp when using jiffies because the
@@ -522,7 +534,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
+	unsigned long load = get_rq_runnable_load(this_rq);
 	unsigned long pending_updates;
 
 	/*
@@ -568,11 +580,12 @@ void update_cpu_load_nohz(void)
  */
 void update_cpu_load_active(struct rq *this_rq)
 {
+	unsigned long load = get_rq_runnable_load(this_rq);
 	/*
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+	__update_cpu_load(this_rq, load, 1);
 
 	calc_load_account_active(this_rq);
 }
