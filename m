Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3AaO4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:56:25 -0500
Received: from forward5.mail.yandex.net ([77.88.46.21]:51992 "EHLO
	forward5.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3AaO4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:56:21 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH]sched/rt: Simplify pick_rt_task: remove next_prio() inheritance
MIME-Version: 1.0
Message-Id: <70871359644177@web16d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 31 Jan 2013 18:56:17 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function next_prio() has been removed and pull_rt_task() is the only
user of pick_next_highest_task_rt() at the moment.

pull_rt_task is not interested in p->nr_cpus_allowed, its only interest
is the fact that cpu is allowed to execute p. If nr_cpus_allowed == 1,
cpu != task_cpu(p) and cpu is allowed then it means that task p is in
the middle of the migration techniques; the task waits until it is moved
by migration thread. So, lets pull it earlier.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
---
 kernel/sched/rt.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 4e8f0f4..9aa2921 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1427,8 +1427,7 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
-	    (p->nr_cpus_allowed > 1))
+	    cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 		return 1;
 	return 0;
 }
