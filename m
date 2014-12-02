Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaLBOIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:08:51 -0500
Received: from service88.mimecast.com ([195.130.217.12]:50582 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaLBOHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:07:02 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [RFC PATCH 09/10] sched: Include blocked utilization in usage tracking
Date: Tue,  2 Dec 2014 14:06:31 +0000
Message-Id: <1417529192-11579-10-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 02 Dec 2014 14:06:59.0416 (UTC) FILETIME=[3D107D80:01D00E39]
X-MC-Unique: 114120214065916701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2E9EFl016992

Add the blocked utilization contribution to group sched_entity
utilization (se->avg.utilization_avg_contrib) and to get_cpu_usage().
With this change cpu usage now includes recent usage by currently
non-runnable tasks, hence it provides a more stable view of the cpu
usage. It does, however, also mean that the meaning of usage is changed:
A cpu may be momentarily idle while usage >0. It can no longer be
assumed that cpu usage >0 implies runnable tasks on the rq.
cfs_rq->utilization_load_avg or nr_running should be used instead to get
the current rq status.

cc: Ingo Molnar <mingo@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index adf64df..bd950b2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2764,7 +2764,8 @@ static long __update_entity_utilization_avg_contrib(struct sched_entity *se)
 		__update_task_entity_utilization(se);
 	else
 		se->avg.utilization_avg_contrib =
-					group_cfs_rq(se)->utilization_load_avg;
+				group_cfs_rq(se)->utilization_load_avg +
+				group_cfs_rq(se)->utilization_blocked_avg;
 
 	return se->avg.utilization_avg_contrib - old_contrib;
 }
@@ -4827,11 +4828,12 @@ static int select_idle_sibling(struct task_struct *p, int target)
 static int get_cpu_usage(int cpu)
 {
 	unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
+	unsigned long blocked = cpu_rq(cpu)->cfs.utilization_blocked_avg;
 
-	if (usage >= SCHED_LOAD_SCALE)
+	if (usage + blocked >= SCHED_LOAD_SCALE)
 		return capacity_orig_of(cpu);
 
-	return usage;
+	return usage + blocked;
 }
 
 /*
-- 
1.9.1


