Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaHLOyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:54:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaHLOyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:54:09 -0400
Date: Tue, 12 Aug 2014 07:53:18 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-83d7f2424741c9dc76c21377c9d00d47abaf88df@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1407173008-9334-3-git-send-email-riel@redhat.com>
References: <1407173008-9334-3-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Fix numa capacity computation
Git-Commit-ID: 83d7f2424741c9dc76c21377c9d00d47abaf88df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83d7f2424741c9dc76c21377c9d00d47abaf88df
Gitweb:     http://git.kernel.org/tip/83d7f2424741c9dc76c21377c9d00d47abaf88df
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 4 Aug 2014 13:23:28 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 12 Aug 2014 12:48:23 +0200

sched/numa: Fix numa capacity computation

Commit c61037e9 fixes the phenomenon of 'fantom' cores due to
N*frac(smt_power) >= 1 by limiting the capacity to the actual
number of cores in the load balancing code.

This patch applies the same correction to the NUMA balancing
code.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: vincent.guittot@linaro.org
Cc: Morten.Rasmussen@arm.com
Cc: nicolas.pitre@linaro.org
Cc: efault@gmx.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1407173008-9334-3-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e1cf419..1413c44 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1038,7 +1038,8 @@ struct numa_stats {
  */
 static void update_numa_stats(struct numa_stats *ns, int nid)
 {
-	int cpu, cpus = 0;
+	int smt, cpu, cpus = 0;
+	unsigned long capacity;
 
 	memset(ns, 0, sizeof(*ns));
 	for_each_cpu(cpu, cpumask_of_node(nid)) {
@@ -1062,8 +1063,12 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 	if (!cpus)
 		return;
 
-	ns->task_capacity =
-		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_CAPACITY_SCALE);
+	/* smt := ceil(cpus / capacity), assumes: 1 < smt_power < 2 */
+	smt = DIV_ROUND_UP(SCHED_CAPACITY_SCALE * cpus, ns->compute_capacity);
+	capacity = cpus / smt; /* cores */
+
+	ns->task_capacity = min_t(unsigned, capacity,
+		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_CAPACITY_SCALE));
 	ns->has_free_capacity = (ns->nr_running < ns->task_capacity);
 }
 
