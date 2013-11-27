Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab3K0OLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:11:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab3K0OLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:11:14 -0500
Date: Wed, 27 Nov 2013 06:10:39 -0800
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-c44f2a020072d75d6b0cbf9f139a09719cda9367@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1382097147-30088-8-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-8-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Move load idx selection in find_idlest_group
Git-Commit-ID: c44f2a020072d75d6b0cbf9f139a09719cda9367
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:10:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c44f2a020072d75d6b0cbf9f139a09719cda9367
Gitweb:     http://git.kernel.org/tip/c44f2a020072d75d6b0cbf9f139a09719cda9367
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Fri, 18 Oct 2013 13:52:21 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 13:50:54 +0100

sched/fair: Move load idx selection in find_idlest_group

load_idx is used in find_idlest_group but initialized in select_task_rq_fair
even when not used. The load_idx initialisation is moved in find_idlest_group
and the sd_flag replaces it in the function's args.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: len.brown@intel.com
Cc: amit.kucheria@linaro.org
Cc: pjt@google.com
Cc: l.majewski@samsung.com
Cc: Morten.Rasmussen@arm.com
Cc: cmetcalf@tilera.com
Cc: tony.luck@intel.com
Cc: alex.shi@intel.com
Cc: preeti@linux.vnet.ibm.com
Cc: linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl
Cc: paulmck@linux.vnet.ibm.com
Cc: corbet@lwn.net
Cc: arjan@linux.intel.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1382097147-30088-8-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e8b652e..6cb36c7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4110,12 +4110,16 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
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
 		int local_group;
@@ -4283,7 +4287,6 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	}
 
 	while (sd) {
-		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
 		int weight;
 
@@ -4292,10 +4295,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
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
