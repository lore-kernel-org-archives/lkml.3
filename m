Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab3FTQT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:19:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab3FTQTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:19:24 -0400
Date: Thu, 20 Jun 2013 09:19:04 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-7ab71f3244e9f970c29566c5a67e13d1fa38c387@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, vincent.weaver@maine.edu, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, fweisbec@gmail.com, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <20130620155013.GA6337@redhat.com>
References: <20130620155013.GA6337@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw_breakpoint: Simplify the "weight"
  usage in toggle_bp_slot() paths
Git-Commit-ID: 7ab71f3244e9f970c29566c5a67e13d1fa38c387
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 09:19:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ab71f3244e9f970c29566c5a67e13d1fa38c387
Gitweb:     http://git.kernel.org/tip/7ab71f3244e9f970c29566c5a67e13d1fa38c387
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 20 Jun 2013 17:50:13 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Jun 2013 17:58:55 +0200

hw_breakpoint: Simplify the "weight" usage in toggle_bp_slot() paths

Change toggle_bp_slot() to make "weight" negative if !enable.
This way we can always use "+ weight" without additional "if
(enable)" check and toggle_bp_task_slot() no longer needs this
arg.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20130620155013.GA6337@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/hw_breakpoint.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index dee0148..5cd4f6d 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -182,7 +182,7 @@ fetch_this_slot(struct bp_busy_slots *slots, int weight)
 /*
  * Add a pinned breakpoint for the given task in our constraint table
  */
-static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
+static void toggle_bp_task_slot(struct perf_event *bp, int cpu,
 				enum bp_type_idx type, int weight)
 {
 	/* tsk_pinned[n-1] is the number of tasks having n>0 breakpoints */
@@ -190,10 +190,7 @@ static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
 	int old_idx, new_idx;
 
 	old_idx = task_bp_pinned(cpu, bp, type) - 1;
-	if (enable)
-		new_idx = old_idx + weight;
-	else
-		new_idx = old_idx - weight;
+	new_idx = old_idx + weight;
 
 	if (old_idx >= 0)
 		tsk_pinned[old_idx]--;
@@ -211,22 +208,21 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	int cpu = bp->cpu;
 	struct task_struct *tsk = bp->hw.bp_target;
 
+	if (!enable)
+		weight = -weight;
+
 	/* Pinned counter cpu profiling */
 	if (!tsk) {
-
-		if (enable)
-			per_cpu(nr_cpu_bp_pinned[type], bp->cpu) += weight;
-		else
-			per_cpu(nr_cpu_bp_pinned[type], bp->cpu) -= weight;
+		per_cpu(nr_cpu_bp_pinned[type], cpu) += weight;
 		return;
 	}
 
 	/* Pinned counter task profiling */
 	if (cpu >= 0) {
-		toggle_bp_task_slot(bp, cpu, enable, type, weight);
+		toggle_bp_task_slot(bp, cpu, type, weight);
 	} else {
 		for_each_possible_cpu(cpu)
-			toggle_bp_task_slot(bp, cpu, enable, type, weight);
+			toggle_bp_task_slot(bp, cpu, type, weight);
 	}
 
 	if (enable)
