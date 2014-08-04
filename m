Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaHDRXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:23:47 -0400
Received: from shelob.surriel.com ([74.92.59.67]:57984 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaHDRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:23:43 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, mingo@kernel.org,
        vincent.guittot@linaro.org, Morten.Rasmussen@arm.com,
        nicolas.pitre@linaro.org, efault@gmx.de
Subject: [PATCH 1/2] sched,numa: fix off-by-one in capacity check
Date: Mon,  4 Aug 2014 13:23:27 -0400
Message-Id: <1407173008-9334-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407173008-9334-1-git-send-email-riel@redhat.com>
References: <1407173008-9334-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Commit a43455a1d572daf7b730fe12eb747d1e17411365 ensures that
task_numa_migrate will call task_numa_compare on the preferred
node all the time, even when the preferred node has no free capacity.

This could lead to a performance regression if nr_running == capacity
on both the source and the destination node. This can be avoided by
also checking for nr_running == capacity on the source node, which is
one stricter than checking .has_free_capacity.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86..678ed03 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1206,7 +1206,7 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	if (!cur) {
 		/* Is there capacity at our destination? */
-		if (env->src_stats.has_free_capacity &&
+		if (env->src_stats.nr_running <= env->src_stats.task_capacity &&
 		    !env->dst_stats.has_free_capacity)
 			goto unlock;
 
-- 
1.9.3

