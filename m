Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaBKTLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:11:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaBKTIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 24/30] sched/rt: Fix SCHED_RR across cgroups
Date: Tue, 11 Feb 2014 11:06:24 -0800
Message-Id: <20140211184647.830125364@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit 454c79999f7eaedcdf4c15c449e43902980cbdf5 upstream.

task_tick_rt() has an optimization to only reschedule SCHED_RR tasks
if they were the only element on their rq.  However, with cgroups
a SCHED_RR task could be the only element on its per-cgroup rq but
still be competing with other SCHED_RR tasks in its parent's
cgroup.  In this case, the SCHED_RR task in the child cgroup would
never yield at the end of its timeslice.  If the child cgroup
rt_runtime_us was the same as the parent cgroup rt_runtime_us,
the task in the parent cgroup would starve completely.

Modify task_tick_rt() to check that the task is the only task on its
rq, and that the each of the scheduling entities of its ancestors
is also the only entity on its rq.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337229266-15798-1-git-send-email-ccross@android.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/rt.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1997,6 +1997,8 @@ static void watchdog(struct rq *rq, stru
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
+	struct sched_rt_entity *rt_se = &p->rt;
+
 	update_curr_rt(rq);
 
 	watchdog(rq, p);
@@ -2014,12 +2016,15 @@ static void task_tick_rt(struct rq *rq,
 	p->rt.time_slice = RR_TIMESLICE;
 
 	/*
-	 * Requeue to the end of queue if we are not the only element
-	 * on the queue:
+	 * Requeue to the end of queue if we (and all of our ancestors) are the
+	 * only element on the queue
 	 */
-	if (p->rt.run_list.prev != p->rt.run_list.next) {
-		requeue_task_rt(rq, p, 0);
-		set_tsk_need_resched(p);
+	for_each_sched_rt_entity(rt_se) {
+		if (rt_se->run_list.prev != rt_se->run_list.next) {
+			requeue_task_rt(rq, p, 0);
+			set_tsk_need_resched(p);
+			return;
+		}
 	}
 }
 


