Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3CFHHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:07:18 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:51441 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3CFHHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:07:15 -0500
Message-ID: <5136EB06.2050905@linux.vnet.ibm.com>
Date: Wed, 06 Mar 2013 15:06:46 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH] sched: wakeup buddy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030607-5490-0000-0000-00000311ECA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Log since RFC:
	1. Small fix (thanks to Namhyung).
	2. Remove the logical branch which will bind two task on
	   same cpu (thanks to Mike).

wake_affine() stuff is trying to bind related tasks closely, but it doesn't
work well according to the test on 'perf bench sched pipe' (thanks to Peter).

Besides, pgbench show that blindly using wake_affine() will eat a lot of
performance, the whole stuff need to be used more wisely.

Thus, we need a new solution, it should detect the tasks related to each
other, bind them closely, take care the balance, latency and performance.

And wakeup buddy seems like a good solution (thanks to Mike for the hint).

The feature introduced waker, wakee pointer and their ref count, along with
the new knob sysctl_sched_wakeup_buddy_ref.

So in select_task_rq_fair(), when wakeup p (task A) and current (task B) is
running, if match:

	1. A->waker == B && A->wakee == B
	2. A->waker_ref > sysctl_sched_wakeup_buddy_ref
	3. A->wakee_ref > sysctl_sched_wakeup_buddy_ref

then A is the wakeup buddy of B, which means A and B is likely to utilize
the memory of each other.

Thus, if B is also the wakeup buddy of A, which means no other task has
destroyed their relationship, make them running closely is likely to gain
benefit.

This patch add the feature wakeup buddy, reorganized the logical of
wake_affine() stuff with the new feature to make the decision more wisely,
by doing these, pgbench perform better.

Test:
	Test with 12 cpu X86 server and tip 3.8.0-rc7.

	pgbench result:
					prev	post

		| db_size | clients |  tps  |	|  tps  |
		+---------+---------+-------+   +-------+
		| 22 MB   |       1 | 10794 |   | 10842 |
		| 22 MB   |       2 | 21567 |   | 21737 |
		| 22 MB   |       4 | 41621 |   | 42844 |
		| 22 MB   |       8 | 53883 |   | 62486 |	+15.97%
		| 22 MB   |      12 | 50818 |   | 58732 |	+15.57%
		| 22 MB   |      16 | 50463 |   | 60131 |	+19.16%
		| 22 MB   |      24 | 46698 |   | 64037 |	+37.13%
		| 22 MB   |      32 | 43404 |   | 63024 |	+45.20%

		| 7484 MB |       1 |  7974 |	|  8398 |
		| 7484 MB |       2 | 19341 |   | 19686 |
		| 7484 MB |       4 | 36808 |   | 38138 |
		| 7484 MB |       8 | 47821 |   | 51944 |	+8.62%
		| 7484 MB |      12 | 45913 |   | 52011 |	+13.28%
		| 7484 MB |      16 | 46478 |   | 54891 |	+18.10%
		| 7484 MB |      24 | 42793 |   | 56756 |	+32.63%
		| 7484 MB |      32 | 36329 |   | 55300 |	+52.22%

		| 15 GB   |       1 |  7636 |	|  8221 |
		| 15 GB   |       2 | 19195 |   | 19641 |
		| 15 GB   |       4 | 35975 |   | 37562 |
		| 15 GB   |       8 | 47919 |   | 51402 |	+7.27%
		| 15 GB   |      12 | 45397 |   | 51126 |	+12.62%
		| 15 GB   |      16 | 45926 |   | 53577 |	+16.66%
		| 15 GB   |      24 | 42184 |   | 55453 |	+31.46%
		| 15 GB   |      32 | 35983 |   | 54946 |	+52.70%

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    8 +++++
 kernel/sched/fair.c   |   80 ++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sysctl.c       |   10 ++++++
 3 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d211247..c5a02b3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1235,6 +1235,10 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_sched_wakeup_buddy_ref;
+#endif
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1245,6 +1249,10 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	struct llist_node wake_entry;
 	int on_cpu;
+	struct task_struct *waker;
+	struct task_struct *wakee;
+	unsigned int waker_ref;
+	unsigned int wakee_ref;
 #endif
 	int on_rq;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81fa536..1b81cc3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3173,6 +3173,75 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 }
 
 /*
+ * Reduce sysctl_sched_wakeup_buddy_ref will reduce the preparation time
+ * to active the wakeup buddy feature, and make it agile, however, this
+ * will increase the risk of misidentify.
+ *
+ * Check wakeup_buddy() for the usage.
+ */
+unsigned int sysctl_sched_wakeup_buddy_ref = 8U;
+
+/*
+ * wakeup_buddy() help to check whether p1 is the wakeup buddy of p2.
+ *
+ * Return 1 for yes, 0 for no.
+*/
+static inline int wakeup_buddy(struct task_struct *p1, struct task_struct *p2)
+{
+	if (p1->waker != p2 || p1->wakee != p2)
+		return 0;
+
+	if (p1->waker_ref < sysctl_sched_wakeup_buddy_ref)
+		return 0;
+
+	if (p1->wakee_ref < sysctl_sched_wakeup_buddy_ref)
+		return 0;
+
+	return 1;
+}
+
+/*
+ * wakeup_related() help to check whether bind p close to current will
+ * benefit the system.
+ *
+ * If p and current are wakeup buddy of each other, usually that means
+ * they utilize the memory of each other, and current cached some data
+ * interested by p.
+ *
+ * Return 1 for yes, 0 for no.
+ */
+static inline int wakeup_related(struct task_struct *p)
+{
+	if (wakeup_buddy(p, current)) {
+		/*
+		 * Now check whether current still focus on his buddy.
+		 */
+		if (wakeup_buddy(current, p))
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * wakeup_ref() help to record the ref when current wakeup p
+ */
+static inline void wakeup_ref(struct task_struct *p)
+{
+	if (p->waker != current) {
+		p->waker_ref = 0;
+		p->waker = current;
+	} else
+		p->waker_ref++;
+
+	if (current->wakee != p) {
+		current->wakee_ref = 0;
+		current->wakee = p;
+	} else
+		current->wakee_ref++;
+}
+
+/*
  * find_idlest_group finds and returns the least busy CPU group within the
  * domain.
  */
@@ -3351,7 +3420,13 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
+		/*
+		 * If current and p are wakeup related, and balance is
+		 * guaranteed, we will try to make them running closely
+		 * to gain cache benefit.
+		 */
+		if (cpu != prev_cpu && wakeup_related(p) &&
+					wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
 
 		new_cpu = select_idle_sibling(p, prev_cpu);
@@ -3399,6 +3474,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 unlock:
 	rcu_read_unlock();
 
+	if (sd_flag & SD_BALANCE_WAKE)
+		wakeup_ref(p);
+
 	return new_cpu;
 }
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..6845d24 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -424,6 +424,16 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &one,
 	},
 #endif
+#ifdef CONFIG_SMP
+	{
+		.procname	= "sched_wakeup_buddy_ref",
+		.data		= &sysctl_sched_wakeup_buddy_ref,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
-- 
1.7.4.1

