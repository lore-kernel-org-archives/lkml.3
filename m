Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3C3Ogg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:36:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:7911 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256Ab3C3Ogc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:36:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568405"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 21/21] sched: don't do power balance on share cpu power domain
Date: Sat, 30 Mar 2013 22:35:08 +0800
Message-Id: <1364654108-16307-22-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Packing tasks among such domain can't save power, just performance
losing. So no power balance on them.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 430904b..88c8bd6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3513,7 +3513,7 @@ static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
 
 	policy = get_sd_sched_balance_policy(sd, cpu, p, sds);
 	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader) {
-		if (wakeup)
+		if (wakeup && !(sd->flags & SD_SHARE_CPUPOWER))
 			new_cpu = find_leader_cpu(sds->group_leader,
 							p, cpu, policy);
 		/* for fork balancing and a little busy task */
@@ -4420,8 +4420,9 @@ static unsigned long task_h_load(struct task_struct *p)
 static inline void init_sd_lb_power_stats(struct lb_env *env,
 						struct sd_lb_stats *sds)
 {
-	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE ||
-				env->idle == CPU_NOT_IDLE) {
+	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE
+			|| env->sd->flags & SD_SHARE_CPUPOWER
+			|| env->idle == CPU_NOT_IDLE) {
 		env->flags &= ~LBF_POWER_BAL;
 		env->flags |= LBF_PERF_BAL;
 		return;
-- 
1.7.12

