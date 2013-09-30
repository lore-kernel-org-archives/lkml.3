Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3I3JBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:01:04 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42575 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3I3JBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:01:00 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: update sched_rt_[period|runtime]_us correctly
Date: Mon, 30 Sep 2013 17:00:52 +0800
Message-Id: <1380531652-31798-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

The code fails to update tg->rt_bandwidth.[rt_period | rt_runtime]
if we have RT_GROUP_SCHED enabled. And if we lower the value of
sched_rt_runtime_us, we get error as "write error: Invalid argument".

Fix it by calling tg_set_rt_bandwidth() instead when setting
sched_rt_[period|runtime]_us.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..c77d298 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7035,11 +7035,7 @@ static int sched_rt_global_constraints(void)
 	if (runtime > period && runtime != RUNTIME_INF)
 		return -EINVAL;
 
-	mutex_lock(&rt_constraints_mutex);
-	read_lock(&tasklist_lock);
-	ret = __rt_schedulable(NULL, 0, 0);
-	read_unlock(&tasklist_lock);
-	mutex_unlock(&rt_constraints_mutex);
+	ret = tg_set_rt_bandwidth(&root_task_group, period, runtime);
 
 	return ret;
 }
-- 
1.7.9.5

