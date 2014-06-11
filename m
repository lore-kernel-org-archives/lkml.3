Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaFKJwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:52:22 -0400
Received: from relay.parallels.com ([195.214.232.42]:34141 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaFKJwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:52:20 -0400
Message-ID: <1402480337.32126.15.camel@tkhai>
Subject: [PATCH 2/2] sched: Rework check_for_tasks()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>
Date: Wed, 11 Jun 2014 13:52:17 +0400
In-Reply-To: <20140611093417.27807.2288.stgit@tkhai>
References: <20140611093417.27807.2288.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1)Iterate throw all of threads in the system.
  Check for all threads, not only for group leaders.

2)Check for p->on_rq instead of p->state and cputime.
  Preempted task in !TASK_RUNNING state  OR just
  created task may be queued, that we want to be
  reported too.

3)Use read_lock() instead of write_lock().
  This function does not change any structures, and
  read_lock() is enough.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/cpu.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index acf791c..c72ba84 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -273,21 +273,28 @@ void clear_tasks_mm_cpumask(int cpu)
 	rcu_read_unlock();
 }
 
-static inline void check_for_tasks(int cpu)
+static inline void check_for_tasks(int dead_cpu)
 {
-	struct task_struct *p;
-	cputime_t utime, stime;
+	struct task_struct *g, *p;
 
-	write_lock_irq(&tasklist_lock);
-	for_each_process(p) {
-		task_cputime(p, &utime, &stime);
-		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
-		    (utime || stime))
-			pr_warn("Task %s (pid = %d) is on cpu %d (state = %ld, flags = %x)\n",
-				p->comm, task_pid_nr(p), cpu,
-				p->state, p->flags);
-	}
-	write_unlock_irq(&tasklist_lock);
+	read_lock_irq(&tasklist_lock);
+	do_each_thread(g, p) {
+		if (!p->on_rq)
+			continue;
+		/*
+		 * We do the check with unlocked task_rq(p)->lock.
+		 * Order the reading to do not warn about a task,
+		 * which was running on this cpu in the past, and
+		 * it's just been woken on another cpu.
+		 */
+		rmb();
+		if (task_cpu(p) != dead_cpu)
+			continue;
+
+		pr_warn("Task %s (pid=%d) is on cpu %d (state=%ld, flags=%x)\n",
+			p->comm, task_pid_nr(p), dead_cpu, p->state, p->flags);
+	} while_each_thread(g, p);
+	read_unlock_irq(&tasklist_lock);
 }
 
 struct take_cpu_down_param {



