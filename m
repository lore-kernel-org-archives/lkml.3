Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab3DDCDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:03:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:29737 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881Ab3DDCC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534608"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v7 20/21] sched: don't do power balance on share cpu power domain
Date: Thu,  4 Apr 2013 10:01:01 +0800
Message-Id: <1365040862-8390-21-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
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
index 047a1b3..3a0284b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3503,7 +3503,7 @@ static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
 
 	policy = get_sd_sched_balance_policy(sd, cpu, p, sds);
 	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader) {
-		if (wakeup)
+		if (wakeup && !(sd->flags & SD_SHARE_CPUPOWER))
 			new_cpu = find_leader_cpu(sds->group_leader,
 							p, cpu, policy);
 		/* for fork balancing and a little busy task */
@@ -4410,8 +4410,9 @@ static unsigned long task_h_load(struct task_struct *p)
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

