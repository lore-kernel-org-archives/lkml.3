Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3DWPAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:00:09 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59584 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3DWPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:00:07 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        pjt@google.com, rostedt@goodmis.org, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v8] sched: fix init NOHZ_IDLE flag
Date: Tue, 23 Apr 2013 16:59:02 +0200
Message-Id: <1366729142-14662-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my smp platform which is made of 5 cores in 2 clusters, I have the
nr_busy_cpu field of sched_group_power struct that is not null when the
platform is fully idle. The root cause is:
During the boot sequence, some CPUs reach the idle loop and set their
NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
field is initialized later with the assumption that all CPUs are in the busy
state whereas some CPUs have already set their NOHZ_IDLE flag.

More generally, the NOHZ_IDLE flag must be initialized when new sched_domains
are created in order to ensure that NOHZ_IDLE and nr_busy_cpus are aligned.

This condition can be ensured by adding a synchronize_rcu between the
destruction of old sched_domains and the creation of new ones so the NOHZ_IDLE
flag will not be updated with old sched_domain once it has been initialized.
But this solution introduces a additionnal latency in the rebuild sequence
that is called during cpu hotplug.

As suggested by Frederic Weisbecker, another solution is to have the same
rcu lifecycle for both NOHZ_IDLE and sched_domain struct.
A new nohz_idle field is added to sched_domain so both status and sched_domain
will share the same RCU lifecycle and will be always synchronized.
In addition, there is no more need to protect nohz_idle against concurrent
 access as it is only modified by 2 exclusive functions called by local cpu.

This solution has been prefered to the creation of a new struct with an extra
pointer indirection for sched_domain.

The synchronization is done at the cost of :
 - An additional indirection and a rcu_dereference for accessing nohz_idle.
 - We use only the nohz_idle field of the top sched_domain.

Change since v7:
 - remove atomic access which is useless now.
 - refactor the sequence that update nohz_idle status and nr_busy_cpus.

Change since v6:
 - Add the flags in struct sched_domain instead of creating a sched_domain_rq.

Change since v5:
 - minor variable and function name change.
 - remove a useless null check before kfree
 - fix a compilation error when NO_HZ is not set.

Change since v4:
 - link both sched_domain and NOHZ_IDLE flag in one RCU object so
   their states are always synchronized.

Change since V3;
 - NOHZ flag is not cleared if a NULL domain is attached to the CPU
 - Remove patch 2/2 which becomes useless with latest modifications

Change since V2:
 - change the initialization to idle state instead of busy state so a CPU that
   enters idle during the build of the sched_domain will not corrupt the
   initialization state

Change since V1:
 - remove the patch for SCHED softirq on an idle core use case as it was
   a side effect of the other use cases.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h |    3 +++
 kernel/sched/fair.c   |   26 ++++++++++++++++----------
 kernel/sched/sched.h  |    1 -
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..22bcbe8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -899,6 +899,9 @@ struct sched_domain {
 	unsigned int wake_idx;
 	unsigned int forkexec_idx;
 	unsigned int smt_gain;
+#ifdef CONFIG_NO_HZ
+	int nohz_idle;			/* NOHZ IDLE status */
+#endif
 	int flags;			/* See SD_* */
 	int level;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..5db1817 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5395,13 +5395,16 @@ static inline void set_cpu_sd_state_busy(void)
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
 
-	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
-		return;
-	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
-
 	rcu_read_lock();
-	for_each_domain(cpu, sd)
+	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+
+	if (!sd || !sd->nohz_idle)
+		goto unlock;
+	sd->nohz_idle = 0;
+
+	for (; sd; sd = sd->parent)
 		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+unlock:
 	rcu_read_unlock();
 }
 
@@ -5410,13 +5413,16 @@ void set_cpu_sd_state_idle(void)
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
 
-	if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
-		return;
-	set_bit(NOHZ_IDLE, nohz_flags(cpu));
-
 	rcu_read_lock();
-	for_each_domain(cpu, sd)
+	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+
+	if (!sd || sd->nohz_idle)
+		goto unlock;
+	sd->nohz_idle = 1;
+
+	for (; sd; sd = sd->parent)
 		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+unlock:
 	rcu_read_unlock();
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc03cfd..03b13c8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1187,7 +1187,6 @@ extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
 enum rq_nohz_flag_bits {
 	NOHZ_TICK_STOPPED,
 	NOHZ_BALANCE_KICK,
-	NOHZ_IDLE,
 };
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
-- 
1.7.9.5

