Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbbASEv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:51:58 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:42584 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbASEv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:51:56 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 2/5] sched/deadline: Remove cpu_active_mask from cpudl_find()
Date: Mon, 19 Jan 2015 04:49:37 +0000
Message-Id: <1421642980-10045-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_active_mask is rarely changeable, so remove this operation
to gain a little performance.

If there is a change in cpu_active_mask, rq_online_dl() and
rq_offline_dl() should take care of it normally, so cpudl::
free_cpus carries enough information for us.

For the rare case(causing a task put onto a dying cpu) which
rq_offline_dl() can't handle timely, then it can be handled
through _cpu_down()->...->multi_cpu_stop()->migration_call()
->migrate_tasks(), preventing the task from hanging on the
dead cpu.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 kernel/sched/cpudeadline.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index fd9d3fb..c6acb07 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -108,8 +108,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	const struct sched_dl_entity *dl_se = &p->dl;
 
 	if (later_mask &&
-	    cpumask_and(later_mask, cp->free_cpus, &p->cpus_allowed) &&
-	    cpumask_and(later_mask, later_mask, cpu_active_mask)) {
+	    cpumask_and(later_mask, cp->free_cpus, &p->cpus_allowed)) {
 		best_cpu = cpumask_any(later_mask);
 		goto out;
 	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
-- 
1.9.1

