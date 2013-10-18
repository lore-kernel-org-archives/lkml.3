Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3JRLyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:54:13 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65374 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab3JRLxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:55 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 08/14] sched: move load idx selection in find_idlest_group
Date: Fri, 18 Oct 2013 13:52:21 +0200
Message-Id: <1382097147-30088-8-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_idx is used in find_idlest_group but initialized in select_task_rq_fair
even when not used. The load_idx initialisation is moved in find_idlest_group
and the sd_flag replaces it in the function's args.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7e26f65..c258c38 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3430,12 +3430,16 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
  */
 static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p,
-		  int this_cpu, int load_idx)
+		  int this_cpu, int sd_flag)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
+	int load_idx = sd->forkexec_idx;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
+	if (sd_flag & SD_BALANCE_WAKE)
+		load_idx = sd->wake_idx;
+
 	do {
 		unsigned long load, avg_load;
 		int local_group, packing_cpus = 0;
@@ -3632,7 +3636,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	while (sd) {
-		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
 		int weight;
 
@@ -3641,10 +3644,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			continue;
 		}
 
-		if (sd_flag & SD_BALANCE_WAKE)
-			load_idx = sd->wake_idx;
-
-		group = find_idlest_group(sd, p, cpu, load_idx);
+		group = find_idlest_group(sd, p, cpu, sd_flag);
 		if (!group) {
 			sd = sd->child;
 			continue;
-- 
1.7.9.5

