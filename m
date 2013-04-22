Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3DVPiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:38:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41832 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab3DVPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:38:50 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        pjt@google.com, rostedt@goodmis.org, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v7] sched: fix init NOHZ_IDLE flag
Date: Mon, 22 Apr 2013 17:38:06 +0200
Message-Id: <1366645086-20345-1-git-send-email-vincent.guittot@linaro.org>
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
A new nohz_flags has been added to sched_domain so both flags and sched_domain
will share the same RCU lifecycle and will be always synchronized. This
solution is prefered to the creation of a new struct with an extra pointer
indirection.

The synchronization is done at the cost of :
 - An additional indirection and a rcu_dereference for accessing the NOHZ_IDLE
   flag.
 - We use only the nohz_flags field of the top sched_domain.

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
 include/linux/sched.h |    1 +
 kernel/sched/fair.c   |   34 ++++++++++++++++++++++++----------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..cde4f7f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -899,6 +899,7 @@ struct sched_domain {
 	unsigned int wake_idx;
 	unsigned int forkexec_idx;
 	unsigned int smt_gain;
+	unsigned long nohz_flags;	/* NOHZ_IDLE flag status */
 	int flags;			/* See SD_* */
 	int level;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..09e440f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5394,14 +5394,21 @@ static inline void set_cpu_sd_state_busy(void)
 {
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
-
-	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
-		return;
-	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
+	int first_nohz_idle = 1;
 
 	rcu_read_lock();
-	for_each_domain(cpu, sd)
+	for_each_domain(cpu, sd) {
+		if (first_nohz_idle) {
+			if (!test_bit(NOHZ_IDLE, &sd->nohz_flags))
+				goto unlock;
+
+			clear_bit(NOHZ_IDLE, &sd->nohz_flags);
+			first_nohz_idle = 0;
+		}
+
 		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+	}
+unlock:
 	rcu_read_unlock();
 }
 
@@ -5409,14 +5416,21 @@ void set_cpu_sd_state_idle(void)
 {
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
-
-	if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
-		return;
-	set_bit(NOHZ_IDLE, nohz_flags(cpu));
+	int first_nohz_idle = 1;
 
 	rcu_read_lock();
-	for_each_domain(cpu, sd)
+	for_each_domain(cpu, sd) {
+		if (first_nohz_idle) {
+			if (test_bit(NOHZ_IDLE, &sd->nohz_flags))
+				goto unlock;
+
+			set_bit(NOHZ_IDLE, &sd->nohz_flags);
+			first_nohz_idle = 0;
+		}
+
 		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+	}
+unlock:
 	rcu_read_unlock();
 }
 
-- 
1.7.9.5

