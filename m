Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965762Ab3E2LDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:03:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:4770 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965728Ab3E2LDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:03:07 -0400
From: Glauber Costa <glommer@openvz.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>,
        Glauber Costa <glommer@openvz.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v7 01/11] don't call cpuacct_charge in stop_task.c
Date: Wed, 29 May 2013 15:03:12 +0400
Message-Id: <1369825402-31046-2-git-send-email-glommer@openvz.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369825402-31046-1-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8f618968 changed stop_task to do the same bookkeping as the
other classes. However, the call to cpuacct_charge() doesn't affect
the scheduler decisions at all, and doesn't need to be moved over.

Moreover, being a kthread, the migration thread won't belong to any
cgroup anyway, rendering this call quite useless.

Signed-off-by: Glauber Costa <glommer@openvz.org>
CC: Mike Galbraith <mgalbraith@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/stop_task.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index e08fbee..4142d7e 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -68,7 +68,6 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq_clock_task(rq);
-	cpuacct_charge(curr, delta_exec);
 }
 
 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
-- 
1.8.1.4

