Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3ILSG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:06:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab3ILSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:06:22 -0400
Date: Thu, 12 Sep 2013 11:05:45 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mikey@neuling.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mikey@neuling.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Fix group power_orig computation
Git-Commit-ID: 863bffc80898b8df295ebac111af2335ec05f85d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:05:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  863bffc80898b8df295ebac111af2335ec05f85d
Gitweb:     http://git.kernel.org/tip/863bffc80898b8df295ebac111af2335ec05f85d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 28 Aug 2013 11:44:39 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:14:43 +0200

sched/fair: Fix group power_orig computation

When looking at the code I noticed we don't actually compute
sgp->power_orig correctly for groups, fix that.

Currently the only consumer of that value is fix_small_capacity()
which is only used on POWER7+ and that code excludes this case by
being limited to SD_SHARE_CPUPOWER which is only ever set on the SMT
domain which must be the lowest domain and this has singleton groups.

So nothing should be affected by this change.

Cc: Michael Neuling <mikey@neuling.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-db2pe0vxwunv37plc7onnugj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f9f4385..baba313 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4450,7 +4450,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
-	unsigned long power;
+	unsigned long power, power_orig;
 	unsigned long interval;
 
 	interval = msecs_to_jiffies(sd->balance_interval);
@@ -4462,7 +4462,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		return;
 	}
 
-	power = 0;
+	power_orig = power = 0;
 
 	if (child->flags & SD_OVERLAP) {
 		/*
@@ -4470,8 +4470,12 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		 * span the current group.
 		 */
 
-		for_each_cpu(cpu, sched_group_cpus(sdg))
-			power += power_of(cpu);
+		for_each_cpu(cpu, sched_group_cpus(sdg)) {
+			struct sched_group *sg = cpu_rq(cpu)->sd->groups;
+
+			power_orig += sg->sgp->power_orig;
+			power += sg->sgp->power;
+		}
 	} else  {
 		/*
 		 * !SD_OVERLAP domains can assume that child groups
@@ -4480,12 +4484,14 @@ void update_group_power(struct sched_domain *sd, int cpu)
 
 		group = child->groups;
 		do {
+			power_orig += group->sgp->power_orig;
 			power += group->sgp->power;
 			group = group->next;
 		} while (group != child->groups);
 	}
 
-	sdg->sgp->power_orig = sdg->sgp->power = power;
+	sdg->sgp->power_orig = power_orig;
+	sdg->sgp->power = power;
 }
 
 /*
