Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaAWLPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 06:15:45 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:43433 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaAWLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:15:44 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@kernel.org, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpusets: Allocate heap only when required
Date: Thu, 23 Jan 2014 16:45:34 +0530
Message-Id: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update_flag() routine uses heap only when spread_flag_changed is true. Otherwise
heap isn't used, but is allocated and freed unnecessarily.

Fix this by allocating heap only when required.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Rebased over linux-next/master

 kernel/cpuset.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4410ac6..9ccdfb2 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1326,16 +1326,18 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	if (err < 0)
 		goto out;
 
-	err = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
-	if (err < 0)
-		goto out;
-
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 				is_sched_load_balance(trialcs));
 
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
+	if (spread_flag_changed) {
+		err = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
+		if (err < 0)
+			goto out;
+	}
+
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
@@ -1343,9 +1345,10 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		rebuild_sched_domains_locked();
 
-	if (spread_flag_changed)
+	if (spread_flag_changed) {
 		update_tasks_flags(cs, &heap);
-	heap_free(&heap);
+		heap_free(&heap);
+	}
 out:
 	free_trial_cpuset(trialcs);
 	return err;
-- 
1.7.12.rc2.18.g61b472e

