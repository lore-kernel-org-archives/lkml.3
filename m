Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaEIGEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaEIGEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:04:42 -0400
Date: Fri, 9 May 2014 02:04:11 -0400
From: Rik van Riel <riel@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com,
        mingo@kernel.org, george.mccollister@gmail.com, ktkhai@parallels.com
Subject: [PATCH] sched: clean up select_task_rq_fair conditionals and
 indentation
Message-ID: <20140509020411.34adbd29@annuminas.surriel.com>
In-Reply-To: <20140509012743.67d4006d@annuminas.surriel.com>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
	<1399011219.5233.55.camel@marge.simpson.net>
	<53633B81.1080403@redhat.com>
	<1399016273.5233.94.camel@marge.simpson.net>
	<536379D0.8070306@redhat.com>
	<1399030032.5233.142.camel@marge.simpson.net>
	<5363B793.9010208@redhat.com>
	<20140506115448.GH11096@twins.programming.kicks-ass.net>
	<536943C9.4030502@redhat.com>
	<20140506203916.GQ17778@laptop.programming.kicks-ass.net>
	<536C3B69.1000208@redhat.com>
	<20140509012743.67d4006d@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleanup goes on top of the previous patch. We could also skip the
whole domain iteration if !want_affine, but that doesn't fit nicely in
80 columns and may have to be done in yet another patch (breaking that
bit of the code out into its own function?)

---8<---

Subject: sched: clean up select_task_rq_fair conditionals and indentation

The whole top half of select_task_rq_fair is only run if
sd_flag & SD_BALANCE_WAKE. The code should probably reflect
that.

Also remove the useless new_cpu = prev_cpu assignment, as the
value of new_cpu is not actually used.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5d33fb1b..844807b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4424,37 +4424,38 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
 
+	rcu_read_lock();
 	if (sd_flag & SD_BALANCE_WAKE) {
 		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 			want_affine = 1;
-		new_cpu = prev_cpu;
-	}
 
-	rcu_read_lock();
-	for_each_domain(cpu, tmp) {
-		if (!(tmp->flags & SD_LOAD_BALANCE))
-			continue;
+		for_each_domain(cpu, tmp) {
+			if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+				break;
 
-		/*
-		 * If both cpu and prev_cpu are part of this domain,
-		 * cpu is a valid SD_WAKE_AFFINE target.
-		 */
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
-			affine_sd = tmp;
-			break;
-		}
+			if (!(tmp->flags & SD_LOAD_BALANCE))
+				continue;
 
-		if (tmp->flags & sd_flag)
-			sd = tmp;
-	}
+			/*
+			 * If both cpu and prev_cpu are part of this domain,
+			 * cpu is a valid SD_WAKE_AFFINE target.
+			 */
+			if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
+			    cpumask_test_cpu(prev_cpu,
+					     sched_domain_span(tmp))) {
+				affine_sd = tmp;
+				break;
+			}
 
-	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
-			prev_cpu = cpu;
-	}
+			if (tmp->flags & sd_flag)
+				sd = tmp;
+		}
+
+		if (affine_sd) {
+			if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
+				prev_cpu = cpu;
+		}
 
-	if (sd_flag & SD_BALANCE_WAKE) {
 		new_cpu = select_idle_sibling(p, prev_cpu);
 		goto unlock;
 	}

