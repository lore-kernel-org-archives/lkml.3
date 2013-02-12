Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab3BLNUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 08:20:16 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33829 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab3BLNUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 08:20:15 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] sched: fix env->src_cpu for active migration
Date: Tue, 12 Feb 2013 14:19:55 +0100
Message-Id: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need_active_balance uses env->src_cpu which is set only if there is more
than 1 task on the run queue. We must set the src_cpu field unconditionnally
otherwise the test "env->src_cpu > env->dst_cpu" will always fail if there is
only 1 task on the run queue

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81fa536..32938ea 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5044,6 +5044,10 @@ redo:
 
 	ld_moved = 0;
 	lb_iterations = 1;
+
+	env.src_cpu   = busiest->cpu;
+	env.src_rq    = busiest;
+
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -5052,8 +5056,6 @@ redo:
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.src_cpu   = busiest->cpu;
-		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
 		update_h_load(env.src_cpu);
-- 
1.7.9.5

