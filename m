Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbaGVSqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:46:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405AbaGVSqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:46:46 -0400
Date: Tue, 22 Jul 2014 14:45:59 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mikey@neuling.org, mingo@kernel.org, pjt@google.com,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        nicolas.pitre@linaro.org
Subject: [PATCH] sched: make update_sd_pick_busiest return true on a busier
 sd
Message-ID: <20140722144559.382c5243@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently update_sd_pick_busiest only returns true when an sd
is overloaded, or for SD_ASYM_PACKING when a domain is busier
than average and a higher numbered domain than the target.

This breaks load balancing between domains that are not overloaded,
in the !SD_ASYM_PACKING case. This patch makes update_sd_pick_busiest
return true when the busiest sd yet is encountered.

On a 4 node system, this seems to result in the load balancer finally
putting 1 thread of a 4 thread test run of "perf bench numa mem" on
each node, where before the load was generally not spread across all
nodes.

Behaviour for SD_ASYM_PACKING does not seem to match the comment,
in that groups with below average load average are ignored, but I
have no hardware to test that so I have left the behaviour of that
code unchanged.

Cc: mikey@neuling.org
Cc: peterz@infradead.org
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d33..ff4ddba 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5942,16 +5942,20 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 * numbered CPUs in the group, therefore mark all groups
 	 * higher than ourself as busy.
 	 */
-	if ((env->sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
-	    env->dst_cpu < group_first_cpu(sg)) {
-		if (!sds->busiest)
-			return true;
+	if (env->sd->flags & SD_ASYM_PACKING) {
+		if (sgs->sum_nr_running && env->dst_cpu < group_first_cpu(sg)) {
+			if (!sds->busiest)
+				return true;
 
-		if (group_first_cpu(sds->busiest) > group_first_cpu(sg))
-			return true;
+			if (group_first_cpu(sds->busiest) > group_first_cpu(sg))
+				return true;
+		}
+
+		return false;
 	}
 
-	return false;
+	/* See above: sgs->avg_load > sds->busiest_stat.avg_load */
+	return true;
 }
 
 #ifdef CONFIG_NUMA_BALANCING

