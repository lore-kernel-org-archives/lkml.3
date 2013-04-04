Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762509Ab3DDO4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:56:13 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:13335 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762317Ab3DDOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:55:09 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>
Subject: [PATCH RFC 3/3] mutex: dynamically disable mutex spinning at high load
Date: Thu,  4 Apr 2013 10:54:18 -0400
Message-Id: <1365087258-7169-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux mutex code has a MUTEX_SPIN_ON_OWNER configuration
option that was enabled by default in major distributions like Red
Hat. Allowing threads waiting on mutex to spin while the mutex owner
is running will theoretically reduce latency on the acquisition of
mutex at the expense of energy efficiency as the spinning threads
are doing no useful work.

This is not a problem on a lightly loaded system where the CPU may
be idle anyway. On a highly loaded system, the spinning tasks may be
blocking other tasks from running even if they have higher priority
because the spinning was done with preemption disabled.

This patch will disable mutex spinning if the current load is high
enough. The load is considered high if there are 2 or more active tasks
waiting to run on the current CPU. If there is only one task waiting,
it will check the average load at the past minute (calc_load_tasks).
If it is more than double the number of active CPUs, the load is
considered high too.  This is a rather simple metric that does not
incur that much additional overhead.

The AIM7 benchmarks were run on 3.7.10 derived kernels to show the
performance changes with this patch on a 8-socket 80-core system
with hyperthreading off.  The table below shows the mean % change
in performance over a range of users for some AIM7 workloads with
just the less atomic operation patch (patch 1) vs the less atomic
operation patch plus this one (patches 1+3).

+--------------+-----------------+-----------------+-----------------+
|   Workload   | mean % change   | mean % change   | mean % change   |
|              | 10-100 users    | 200-1000 users  | 1100-2000 users |
+--------------+-----------------+-----------------+-----------------+
| alltests     |      0.0%       |     -0.1%       |    +5.0%        |
| five_sec     |     +1.5%       |     +1.3%       |    +1.3%        |
| fserver      |     +1.5%       |    +25.4%       |    +9.6%        |
| high_systime |     +0.1%       |      0.0%       |    +0.8%        |
| new_fserver  |     +0.2%       |    +11.9%       |   +14.1%        |
| shared       |     -1.2%       |     +0.3%       |    +1.8%        |
| short        |     +6.4%       |     +2.5%       |    +3.0%        |
+--------------+-----------------+-----------------+-----------------+

It can be seen that this patch provides some big performance
improvement for the fserver and new_fserver workloads while is still
generally positive for the other AIM7 workloads.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 kernel/sched/core.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..f667d63 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3021,9 +3021,31 @@ static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
  */
 int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
 {
+	unsigned int nrun;
+
 	if (!sched_feat(OWNER_SPIN))
 		return 0;
 
+	/*
+	 * Mutex spinning should be temporarily disabled if the load on
+	 * the current CPU is high. The load is considered high if there
+	 * are 2 or more active tasks waiting to run on this CPU. On the
+	 * other hand, if there is another task waiting and the global
+	 * load (calc_load_tasks - including uninterruptible tasks) is
+	 * bigger than 2X the # of CPUs available, it is also considered
+	 * to be high load.
+	 */
+	nrun = this_rq()->nr_running;
+	if (nrun >= 3)
+		return 0;
+	else if (nrun == 2) {
+		long active = atomic_long_read(&calc_load_tasks);
+		int  ncpu   = num_online_cpus();
+
+		if (active > 2*ncpu)
+			return 0;
+	}
+
 	rcu_read_lock();
 	while (owner_running(lock, owner)) {
 		if (need_resched())
-- 
1.7.1

