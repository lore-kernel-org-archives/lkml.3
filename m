Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbaGCQ02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:26:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45941 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364AbaGCQ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:25 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 21/23] sched: Use energy model in select_idle_sibling
Date: Thu,  3 Jul 2014 17:26:08 +0100
Message-Id: <1404404770-323-22-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:23.0850 (UTC) FILETIME=[87DDD4A0:01CF96DB]
X-MC-Unique: 114070317262314501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GQZvA010627

Make select_idle_sibling() consider energy when picking an idle cpu.
This implies having to look beyond sd_llc. Otherwise, consolidating
short frequently running tasks on fewer llc domains will not happen when
that is feasible. The fix is to start select_idle_sibling() at the
highest sched_domain level. A more refined approach causing less
overhead will be considered later. That could be to only look beyond
sd_llc occasionally.

Only idle cpus are still considered. A more aggressive energy conserving
approach could go further and consider partially utilized cpus.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index aebf3e2..a32d6eb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4747,9 +4747,19 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  */
 static int select_idle_sibling(struct task_struct *p, int target)
 {
-	struct sched_domain *sd;
+	struct sched_domain *sd = NULL, *tmp;
 	struct sched_group *sg;
 	int i = task_cpu(p);
+	int target_nrg;
+	int nrg_min, nrg_cpu = -1;
+
+	if (energy_aware()) {
+		/* When energy-aware, go above sd_llc */
+		for_each_domain(target, tmp)
+			sd = tmp;
+
+		goto loop;
+	}
 
 	if (idle_cpu(target))
 		return target;
@@ -4764,6 +4774,10 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
 	sd = rcu_dereference(per_cpu(sd_llc, target));
+
+loop:
+	target_nrg = nrg_min = energy_diff_task(target, p);
+
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
@@ -4772,16 +4786,35 @@ static int select_idle_sibling(struct task_struct *p, int target)
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
+				int nrg_diff;
+				if (energy_aware()) {
+					if (!idle_cpu(i))
+						continue;
+
+					nrg_diff = energy_diff_task(i, p);
+					if (nrg_diff < nrg_min) {
+						nrg_min = nrg_diff;
+						nrg_cpu = i;
+					}
+				}
+
 				if (i == target || !idle_cpu(i))
 					goto next;
 			}
 
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
-			goto done;
+			if (!energy_aware()) {
+				target = cpumask_first_and(sched_group_cpus(sg),
+						tsk_cpus_allowed(p));
+				goto done;
+			}
 next:
 			sg = sg->next;
 		} while (sg != sd->groups);
+
+		if (nrg_cpu >= 0) {
+			target = nrg_cpu;
+			goto done;
+		}
 	}
 done:
 	return target;
-- 
1.7.9.5


