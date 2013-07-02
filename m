Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3GBEn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:43:56 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37878 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3GBEnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:43:55 -0400
Message-ID: <51D25A80.8090406@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 12:43:44 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com>
In-Reply-To: <51A43B16.9080801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070204-5816-0000-0000-000008B87EE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since RFC:
	Tested again with the latest tip 3.10.0-rc7.

wake-affine stuff is always trying to pull wakee close to waker, by theory,
this will bring benefit if waker's cpu cached hot data for wakee, or the
extreme ping-pong case.

And testing show it could benefit hackbench 15% at most.

However, the whole stuff is somewhat blindly and time-consuming, some
workload therefore suffer.

And testing show it could damage pgbench 50% at most.

Thus, wake-affine stuff should be more smart, and realise when to stop
it's thankless effort.

This patch introduced 'nr_wakee_switch', which will be increased each
time the task switch it's wakee.

So a high 'nr_wakee_switch' means the task has more than one wakee, and
bigger the number, higher the wakeup frequency.

Now when making the decision on whether to pull or not, pay attention on
the wakee with a high 'nr_wakee_switch', pull such task may benefit wakee,
but also imply that waker will face cruel competition later, it could be
very cruel or very fast depends on the story behind 'nr_wakee_switch',
whatever, waker therefore suffer.

Furthermore, if waker also has a high 'nr_wakee_switch', imply that multiple
tasks rely on it, then waker's higher latency will damage all of them, pull
wakee seems to be a bad deal.

Thus, when 'waker->nr_wakee_switch / wakee->nr_wakee_switch' become higher
and higher, the deal seems to be worse and worse.

The patch therefore help wake-affine stuff to stop it's work when:

	wakee->nr_wakee_switch > factor &&
	waker->nr_wakee_switch > (factor * wakee->nr_wakee_switch)

The factor here is the online cpu number, and more cpu will lead to more pull
since the trial become more severe.

After applied the patch, pgbench show 40% improvement at most.

Test:
	Test with 12 cpu X86 server and tip 3.10.0-rc7.

			    base	smart

	| db_size | clients |  tps  |	|  tps  |
	+---------+---------+-------+   +-------+
	| 22 MB   |       1 | 10598 |   | 10693 |
	| 22 MB   |       2 | 21257 |   | 21409 |
	| 22 MB   |       4 | 41386 |   | 41517 |
	| 22 MB   |       8 | 51253 |   | 58173 |
	| 22 MB   |      12 | 48570 |   | 53817 |
	| 22 MB   |      16 | 46748 |   | 55992 | +19.77%
	| 22 MB   |      24 | 44346 |   | 56087 | +26.48%
	| 22 MB   |      32 | 43460 |   | 54781 | +26.05%
	| 7484 MB |       1 |  8951 |   |  9336 |
	| 7484 MB |       2 | 19233 |   | 19348 |
	| 7484 MB |       4 | 37239 |   | 37316 |
	| 7484 MB |       8 | 46087 |   | 49329 |
	| 7484 MB |      12 | 42054 |   | 49231 |
	| 7484 MB |      16 | 40765 |   | 51082 | +25.31%
	| 7484 MB |      24 | 37651 |   | 52740 | +40.08%
	| 7484 MB |      32 | 37056 |   | 50866 | +37.27%
	| 15 GB   |       1 |  8845 |   |  9124 |
	| 15 GB   |       2 | 19094 |   | 19187 |
	| 15 GB   |       4 | 36979 |   | 37178 |
	| 15 GB   |       8 | 46087 |   | 50075 |
	| 15 GB   |      12 | 41901 |   | 48098 |
	| 15 GB   |      16 | 40147 |   | 51463 | +28.19%
	| 15 GB   |      24 | 37250 |   | 51750 | +38.93%
	| 15 GB   |      32 | 36470 |   | 50807 | +39.31%

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    3 +++
 kernel/sched/fair.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..1c996c7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1041,6 +1041,9 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	struct llist_node wake_entry;
 	int on_cpu;
+	struct task_struct *last_wakee;
+	unsigned long nr_wakee_switch;
+	unsigned long last_switch_decay;
 #endif
 	int on_rq;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..591c113 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3109,6 +3109,45 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 #endif
 
+static void record_wakee(struct task_struct *p)
+{
+	/*
+	 * Rough decay, don't worry about the boundary, really active
+	 * task won't care the loose.
+	 */
+	if (jiffies > current->last_switch_decay + HZ) {
+		current->nr_wakee_switch = 0;
+		current->last_switch_decay = jiffies;
+	}
+
+	if (current->last_wakee != p) {
+		current->last_wakee = p;
+		current->nr_wakee_switch++;
+	}
+}
+
+static int nasty_pull(struct task_struct *p)
+{
+	int factor = cpumask_weight(cpu_online_mask);
+
+	/*
+	 * Yeah, it's the switching-frequency, could means many wakee or
+	 * rapidly switch, use factor here will just help to automatically
+	 * adjust the loose-degree, so more cpu will lead to more pull.
+	 */
+	if (p->nr_wakee_switch > factor) {
+		/*
+		 * wakee is somewhat hot, it needs certain amount of cpu
+		 * resource, so if waker is far more hot, prefer to leave
+		 * it alone.
+		 */
+		if (current->nr_wakee_switch > (factor * p->nr_wakee_switch))
+			return 1;
+	}
+
+	return 0;
+}
+
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
@@ -3118,6 +3157,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	unsigned long weight;
 	int balanced;
 
+	if (nasty_pull(p))
+		return 0;
+
 	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
@@ -3410,6 +3452,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		/* while loop will break here if sd == NULL */
 	}
 unlock:
+	if (sd_flag & SD_BALANCE_WAKE)
+		record_wakee(p);
+
 	rcu_read_unlock();
 
 	return new_cpu;
-- 
1.7.4.1

