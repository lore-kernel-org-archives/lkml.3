Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3DZOX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:23:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3DZOXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:23:23 -0400
Date: Fri, 26 Apr 2013 07:23:09 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-25f55d9d01ad7a7ad248fd5af1d22675ffd202c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1366729142-14662-1-git-send-email-vincent.guittot@linaro.org>
References: <1366729142-14662-1-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix init NOHZ_IDLE flag
Git-Commit-ID: 25f55d9d01ad7a7ad248fd5af1d22675ffd202c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25f55d9d01ad7a7ad248fd5af1d22675ffd202c5
Gitweb:     http://git.kernel.org/tip/25f55d9d01ad7a7ad248fd5af1d22675ffd202c5
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Tue, 23 Apr 2013 16:59:02 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 26 Apr 2013 12:13:44 +0200

sched: Fix init NOHZ_IDLE flag

On my SMP platform which is made of 5 cores in 2 clusters, I
have the nr_busy_cpu field of sched_group_power struct that is
not null when the platform is fully idle - which makes the
scheduler unhappy.

The root cause is:

During the boot sequence, some CPUs reach the idle loop and set
their NOHZ_IDLE flag while waiting for others CPUs to boot. But
the nr_busy_cpus field is initialized later with the assumption
that all CPUs are in the busy state whereas some CPUs have
already set their NOHZ_IDLE flag.

More generally, the NOHZ_IDLE flag must be initialized when new
sched_domains are created in order to ensure that NOHZ_IDLE and
nr_busy_cpus are aligned.

This condition can be ensured by adding a synchronize_rcu()
between the destruction of old sched_domains and the creation of
new ones so the NOHZ_IDLE flag will not be updated with old
sched_domain once it has been initialized. But this solution
introduces a additionnal latency in the rebuild sequence that is
called during cpu hotplug.

As suggested by Frederic Weisbecker, another solution is to have
the same rcu lifecycle for both NOHZ_IDLE and sched_domain
struct. A new nohz_idle field is added to sched_domain so both
status and sched_domain will share the same RCU lifecycle and
will be always synchronized. In addition, there is no more need
to protect nohz_idle against concurrent access as it is only
modified by 2 exclusive functions called by local cpu.

This solution has been prefered to the creation of a new struct
with an extra pointer indirection for sched_domain.

The synchronization is done at the cost of :

 - An additional indirection and a rcu_dereference for accessing nohz_idle.
 - We use only the nohz_idle field of the top sched_domain.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linaro-kernel@lists.linaro.org
Cc: peterz@infradead.org
Cc: fweisbec@gmail.com
Cc: pjt@google.com
Cc: rostedt@goodmis.org
Cc: efault@gmx.de
Link: http://lkml.kernel.org/r/1366729142-14662-1-git-send-email-vincent.guittot@linaro.org
[ Fixed !NO_HZ build bug. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  2 ++
 kernel/sched/fair.c   | 26 ++++++++++++++++----------
 kernel/sched/sched.h  |  1 -
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6bdaa73..a25168f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -808,6 +808,8 @@ struct sched_domain {
 	unsigned int wake_idx;
 	unsigned int forkexec_idx;
 	unsigned int smt_gain;
+
+	int nohz_idle;			/* NOHZ IDLE status */
 	int flags;			/* See SD_* */
 	int level;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index acaf567..8bf7081 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5420,13 +5420,16 @@ static inline void set_cpu_sd_state_busy(void)
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
 
@@ -5435,13 +5438,16 @@ void set_cpu_sd_state_idle(void)
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
index 605426a..4c225c4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1303,7 +1303,6 @@ extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
 enum rq_nohz_flag_bits {
 	NOHZ_TICK_STOPPED,
 	NOHZ_BALANCE_KICK,
-	NOHZ_IDLE,
 };
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
