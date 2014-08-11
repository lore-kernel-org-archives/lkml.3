Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaHKLup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:50:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42640 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaHKLun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:50:43 -0400
Subject: [RFC PATCH V2 19/19] sched: don't do power balance on share cpu
 power domain
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
Date: Mon, 11 Aug 2014 17:20:20 +0530
Message-ID: <20140811115000.32407.53101.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811114501.32407.61304.stgit@preeti.in.ibm.com>
References: <20140811114501.32407.61304.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-0928-0000-0000-00000406ED0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

Packing tasks among such domain can't save power, just performance
losing. So no power balance on them.

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c49ee6c..adda9cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4744,7 +4744,7 @@ static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
 
 	policy = get_sd_sched_balance_policy(sd, cpu, p, sds);
 	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader) {
-		if (wakeup)
+		if (wakeup && !(sd->flags & SD_SHARE_CPUCAPACITY))
 			new_cpu = find_leader_cpu(sds->group_leader,
 							p, cpu, policy);
 		/* for fork balancing and a little busy task */
@@ -5882,8 +5882,9 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 static inline void init_sd_lb_power_stats(struct lb_env *env,
 						struct sd_lb_stats *sds)
 {
-	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE ||
-				env->idle == CPU_NOT_IDLE) {
+	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE
+			|| env->sd->flags & SD_SHARE_CPUCAPACITY
+			|| env->idle == CPU_NOT_IDLE) {
 		env->flags &= ~LBF_POWER_BAL;
 		env->flags |= LBF_PERF_BAL;
 		return;

