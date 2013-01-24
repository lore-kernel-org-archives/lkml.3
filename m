Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3AXPRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:17:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33324 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab3AXPRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:17:23 -0500
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        ccross@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Glauber Costa <glommer@parallels.com>,
        Mike Galbraith <mgalbraith@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v6 01/12] don't call cpuacct_charge in stop_task.c
Date: Thu, 24 Jan 2013 19:17:31 +0400
Message-Id: <1359040662-8055-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359040662-8055-1-git-send-email-glommer@parallels.com>
References: <1359040662-8055-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>

Commit 8f618968 changed stop_task to do the same bookkeping as the
other classes. However, the call to cpuacct_charge() doesn't affect
the scheduler decisions at all, and doesn't need to be moved over.

Moreover, being a kthread, the migration thread won't belong to any
cgroup anyway, rendering this call quite useless.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Mike Galbraith <mgalbraith@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/stop_task.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index da5eb5b..fda1cbe 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -68,7 +68,6 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq->clock_task;
-	cpuacct_charge(curr, delta_exec);
 }
 
 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
-- 
1.8.1

