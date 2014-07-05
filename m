Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbaGEKrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:47:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58146 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbaGEKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:47:38 -0400
Date: Sat, 5 Jul 2014 03:46:25 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-b728ca06029d085a1585c1926610f26de93b9146@git.kernel.org>
Cc: ktkhai@parallels.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, fabf@skynet.be, todd.e.brandt@linux.intel.com,
        akpm@linux-foundation.org, wangyun@linux.vnet.ibm.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        bsegall@google.com, pjt@google.com, srivatsa.bhat@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com, khorenko@parallels.com,
        umgwanakikbuti@gmail.com, ego@linux.vnet.ibm.com,
        srikar@linux.vnet.ibm.com, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, ktkhai@parallels.com,
        torvalds@linux-foundation.org, peterz@infradead.org, fabf@skynet.be,
        todd.e.brandt@linux.intel.com, akpm@linux-foundation.org,
        wangyun@linux.vnet.ibm.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, bsegall@google.com,
        pjt@google.com, srivatsa.bhat@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, umgwanakikbuti@gmail.com,
        khorenko@parallels.com, toshi.kani@hp.com, ego@linux.vnet.ibm.com,
        srikar@linux.vnet.ibm.com, paul.gortmaker@windriver.com
In-Reply-To: <1403684395.3462.44.camel@tkhai>
References: <1403684395.3462.44.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rework check_for_tasks()
Git-Commit-ID: b728ca06029d085a1585c1926610f26de93b9146
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b728ca06029d085a1585c1926610f26de93b9146
Gitweb:     http://git.kernel.org/tip/b728ca06029d085a1585c1926610f26de93b9146
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Wed, 25 Jun 2014 12:19:55 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:45 +0200

sched: Rework check_for_tasks()

1) Iterate thru all of threads in the system.
   Check for all threads, not only for group leaders.

2) Check for p->on_rq instead of p->state and cputime.
   Preempted task in !TASK_RUNNING state  OR just
   created task may be queued, that we want to be
   reported too.

3) Use read_lock() instead of write_lock().
   This function does not change any structures, and
   read_lock() is enough.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Cc: Konstantin Khorenko <khorenko@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul Turner <pjt@google.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Todd E Brandt <todd.e.brandt@linux.intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403684395.3462.44.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/cpu.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a343bde..81e2a38 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -274,21 +274,28 @@ void clear_tasks_mm_cpumask(int cpu)
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
