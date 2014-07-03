Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbaGCQgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:36:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51076 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaGCQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:36:11 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 20/23] sched: Take task wakeups into account in energy estimates
Date: Thu,  3 Jul 2014 17:26:07 +0100
Message-Id: <1404404770-323-21-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:22.0865 (UTC) FILETIME=[87478810:01CF96DB]
X-MC-Unique: 114070317262209401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GaGdJ010800

The energy cost of waking a cpu and sending it back to sleep can be
quite significant for short running frequently waking tasks if placed on
an idle cpu in a deep sleep state. By factoring task wakeups in such
tasks can be placed on cpus where the wakeup energy cost is lower. For
example, partly utilized cpus in a shallower idle state, or cpus in a
cluster/die that is already awake.

Current cpu utilization of the target cpu is factored in to guess how
many task wakeups translate into cpu wakeups (idle exits). It is a
very naive approach, but it is virtually impossible to get an accurate
estimate.

wake_energy(task) = unused_util(cpu) * wakeups(task) * wakeup_energy(cpu)

There is no per cpu wakeup tracking, so we can't estimate the energy
savings when removing tasks from a cpu. It is also nearly impossible to
figure out which task is the cause of cpu wakeups if multiple tasks are
scheduled on the same cpu.

wakeup_energy for each idle-state is obtained from the idle_states array.
A prediction of the most likely idle-state is needed. cpuidle is best
placed to provide that. It is not implemented yet.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6da8e2b..aebf3e2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4367,11 +4367,13 @@ static inline unsigned long get_curr_capacity(int cpu);
  *				+ (1-curr_util(sg)) * idle_power(sg)
  *	energy_after = new_util(sg) * busy_power(sg)
  *				+ (1-new_util(sg)) * idle_power(sg)
+ *				+ (1-new_util(sg)) * task_wakeups
+ *							* wakeup_energy(sg)
  *	energy_diff += energy_before - energy_after
  * }
  *
  */
-static int energy_diff_util(int cpu, int util)
+static int energy_diff_util(int cpu, int util, int wakeups)
 {
 	struct sched_domain *sd;
 	int i;
@@ -4476,7 +4478,8 @@ static int energy_diff_util(int cpu, int util)
 		 * The utilization change has no impact at this level (or any
 		 * parent level).
 		 */
-		if (aff_util_bef == aff_util_aft && curr_cap_idx == new_cap_idx)
+		if (aff_util_bef == aff_util_aft && curr_cap_idx == new_cap_idx
+				&& unused_util_aft < 100)
 			goto unlock;
 
 		/* Energy before */
@@ -4486,6 +4489,14 @@ static int energy_diff_util(int cpu, int util)
 		/* Energy after */
 		nrg_diff += (aff_util_aft*new_state->power)/new_state->cap;
 		nrg_diff += (unused_util_aft * is->power)/new_state->cap;
+
+		/*
+		 * Estimate how many of the wakeups that happens while cpu is
+		 * idle assuming they are uniformly distributed. Ignoring
+		 * wakeups caused by other tasks.
+		 */
+		nrg_diff += (wakeups * is->wu_energy >> 10)
+				* unused_util_aft/new_state->cap;
 	}
 
 	/*
@@ -4516,6 +4527,8 @@ static int energy_diff_util(int cpu, int util)
 		/* Energy after */
 		nrg_diff += (aff_util_aft*new_state->power)/new_state->cap;
 		nrg_diff += (unused_util_aft * is->power)/new_state->cap;
+		nrg_diff += (wakeups * is->wu_energy >> 10)
+				* unused_util_aft/new_state->cap;
 	}
 
 unlock:
@@ -4532,8 +4545,8 @@ static int energy_diff_task(int cpu, struct task_struct *p)
 	if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 		return INT_MAX;
 
-	return energy_diff_util(cpu, p->se.avg.uw_load_avg_contrib);
-
+	return energy_diff_util(cpu, p->se.avg.uw_load_avg_contrib,
+			p->se.avg.wakeup_avg_sum);
 }
 
 static int wake_wide(struct task_struct *p)
-- 
1.7.9.5


