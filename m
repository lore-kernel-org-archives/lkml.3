Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaEWSRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:17:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36399 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaEWSQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:57 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 13/16] sched: Take task wakeups into account in energy estimates
Date: Fri, 23 May 2014 19:16:40 +0100
Message-Id: <1400869003-27769-14-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:54.0994 (UTC) FILETIME=[2D665B20:01CF76B3]
X-MC-Unique: 114052319165515901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIHrlf005165

The energy cost of waking a cpu and sending it back to sleep can be
quite significant for short running frequently waking tasks if placed on
an idle cpu in a deep sleep state. By factoring task wakeups in such
tasks can be placed on cpus where the wakeup energy cost is lower. For
example, partly utilized cpus in a shallower idle state, or cpus in a
cluster/die that is already awake.

Current cpu utilization of the target cpu is factored in guess how many
task wakeups that translate into cpu wakeups (idle exits). It is a very
naive approach, but it is virtually impossible to get an accurate estimate.

wake_energy(task) = unused_util(cpu) * wakeups(task) * wakeup_energy(cpu)

There is no per cpu wakeup tracking, so we can't estimate the energy
savings when removing tasks from a cpu. It is also nearly impossible to
figure out which task is the cause of cpu wakeups if multiple tasks are
scheduled on the same cpu.

Support for multiple idle-states per sched_group (e.g. WFI and core
shutdown on ARM) is not implemented yet. wakeup_energy in struct
sched_energy needs to be a table instead and cpuidle needs to tells
what the most likely state is.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 39e9cd8..5a52467 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4271,11 +4271,13 @@ static void find_max_util(const struct cpumask *mask, int cpu, int util,
  *				+ 1-curr_util(sg) * idle_power(sg)
  *	energy_after = new_util(sg) * busy_power(sg)
  *				+ 1-new_util(sg) * idle_power(sg)
+ *				+ new_util(sg) * task_wakeups
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
@@ -4368,7 +4370,8 @@ static int energy_diff_util(int cpu, int util)
 		 * The utilization change has no impact at this level (or any
 		 * parent level).
 		 */
-		if (aff_util_bef == aff_util_aft && curr_cap_idx == new_cap_idx)
+		if (aff_util_bef == aff_util_aft && curr_cap_idx == new_cap_idx
+				&& unused_util_aft < 100)
 			goto unlock;
 
 		/* Energy before */
@@ -4380,6 +4383,13 @@ static int energy_diff_util(int cpu, int util)
 		energy_diff += (aff_util_aft*new_state->power)/new_state->cap;
 		energy_diff += (unused_util_aft * sge->idle_power)
 				/new_state->cap;
+		/*
+		 * Estimate how many of the wakeups that happens while cpu is
+		 * idle assuming they are uniformly distributed. Ignoring
+		 * wakeups caused by other tasks.
+		 */
+		energy_diff += (wakeups * sge->wakeup_energy >> 10)
+				* unused_util_aft/new_state->cap;
 	}
 
 	/*
@@ -4410,6 +4420,8 @@ static int energy_diff_util(int cpu, int util)
 		energy_diff += (aff_util_aft*new_state->power)/new_state->cap;
 		energy_diff += (unused_util_aft * sse->idle_power)
 				/new_state->cap;
+		energy_diff += (wakeups * sse->wakeup_energy >> 10)
+				* unused_util_aft/new_state->cap;
 	}
 
 unlock:
@@ -4420,7 +4432,8 @@ unlock:
 
 static int energy_diff_task(int cpu, struct task_struct *p)
 {
-	return energy_diff_util(cpu, p->se.avg.load_avg_contrib);
+	return energy_diff_util(cpu, p->se.avg.load_avg_contrib,
+			p->se.avg.wakeup_avg_sum);
 }
 
 #else
-- 
1.7.9.5


