Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3BUI3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:29:33 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63388 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3BUI3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:29:31 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v4] sched: fix init NOHZ_IDLE flag
Date: Thu, 21 Feb 2013 09:29:16 +0100
Message-Id: <1361435356-28466-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my smp platform which is made of 5 cores in 2 clusters, I have the
nr_busy_cpu field of sched_group_power struct that is not null when the
platform is fully idle. The root cause seems to be:
During the boot sequence, some CPUs reach the idle loop and set their
NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
field is initialized later with the assumption that all CPUs are in the busy
state whereas some CPUs have already set their NOHZ_IDLE flag.
During the initialization of the sched_domain, we set the NOHZ_IDLE flag when
nr_busy_cpus is initialized to 0 in order to have a coherent configuration.
If a CPU enters idle and call set_cpu_sd_state_idle during the build of the
new sched_domain it will not corrupt the initial state
set_cpu_sd_state_busy is modified and clears the NOHZ_IDLE only if a non NULL
sched_domain is attached to the CPU (which is the case during the rebuild)

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
 kernel/sched/core.c |    4 +++-
 kernel/sched/fair.c |    9 +++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..c730a4e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5884,7 +5884,9 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 		return;
 
 	update_group_power(sd, cpu);
-	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
+	atomic_set(&sg->sgp->nr_busy_cpus, 0);
+	set_bit(NOHZ_IDLE, nohz_flags(cpu));
+
 }
 
 int __weak arch_sd_sibling_asym_packing(void)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81fa536..2701a92 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5403,15 +5403,20 @@ static inline void set_cpu_sd_state_busy(void)
 {
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
+	int clear = 0;
 
 	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
 		return;
-	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
 
 	rcu_read_lock();
-	for_each_domain(cpu, sd)
+	for_each_domain(cpu, sd) {
 		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+		clear = 1;
+	}
 	rcu_read_unlock();
+
+	if (likely(clear))
+		clear_bit(NOHZ_IDLE, nohz_flags(cpu));
 }
 
 void set_cpu_sd_state_idle(void)
-- 
1.7.9.5

