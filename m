Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3B1GsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:48:18 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55697 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3B1GsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:48:11 -0500
Message-ID: <512EFB4B.5040204@linux.vnet.ibm.com>
Date: Thu, 28 Feb 2013 14:38:03 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [RFC PATCH] sched: wakeup buddy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022806-7014-0000-0000-000002A6A466
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wake_affine() stuff is trying to bind related tasks closely, but it doesn't
work well according to the test on 'perf bench sched pipe' (thanks to Peter).

Besides, pgbench show that blindly using wake_affine() will eat a lot of
performance.

Thus, we need a new solution, it should detect the tasks related to each
other, bind them closely, take care the balance, latency and performance
at the same time.

Feature wakeup buddy seems like a good solution (thanks to Mike for the hint).

The feature introduced waker, wakee pointer and their ref count, along with
the new knob sysctl_sched_wakeup_buddy_ref.

Now in select_task_rq_fair(), when current (task B) try to wakeup p (task A),
if match:

	1. A->waker == B && A->wakee == B
	2. A->waker_ref > sysctl_sched_wakeup_buddy_ref
	3. A->wakee_ref > sysctl_sched_wakeup_buddy_ref

then A is the wakeup buddy of B, which means A and B is likely to utilize
the memory of each other.

Thus, if B is also the wakeup buddy of A, which means no other task has
destroyed their relationship, then A is likely to benefit from the cached
data of B, make them running closely is likely to gain benefit.

This patch add the feature wakeup buddy, reorganized the logical of
wake_affine() stuff with the new feature, by doing these, pgbench and
'perf bench sched pipe' perform better.

Highlight:
	Default value of sysctl_sched_wakeup_buddy_ref is 8 temporarily,
	please let me know if some number perform better on your system,
	I'd like to make it bigger to make the decision more carefully,
	so we could provide the solution when it is really needed.

	Comments are very welcomed.

Test:
	Test with a 12 cpu X86 server and tip 3.8.0-rc7.

	'perf bench sched pipe' show nearly double improvement.

	pgbench result:
					prev	post

                | db_size | clients |  tps  |   |  tps  |
                +---------+---------+-------+   +-------+
                | 22 MB   |       1 | 10794 |   | 10820 |
                | 22 MB   |       2 | 21567 |   | 21915 |
                | 22 MB   |       4 | 41621 |   | 42766 |
                | 22 MB   |       8 | 53883 |   | 60511 |       +12.30%
                | 22 MB   |      12 | 50818 |   | 57129 |       +12.42%
                | 22 MB   |      16 | 50463 |   | 59345 |       +17.60%
                | 22 MB   |      24 | 46698 |   | 63787 |       +36.59%
                | 22 MB   |      32 | 43404 |   | 62643 |       +44.33%

                | 7484 MB |       1 |  7974 |   |  8014 |
                | 7484 MB |       2 | 19341 |   | 19534 |
                | 7484 MB |       4 | 36808 |   | 38092 |
                | 7484 MB |       8 | 47821 |   | 51968 |       +8.67%
                | 7484 MB |      12 | 45913 |   | 52284 |       +13.88%
                | 7484 MB |      16 | 46478 |   | 54418 |       +17.08%
                | 7484 MB |      24 | 42793 |   | 56375 |       +31.74%
                | 7484 MB |      32 | 36329 |   | 55783 |       +53.55%
                
                | 15 GB   |       1 |  7636 |   |  7880 |       
                | 15 GB   |       2 | 19195 |   | 19477 |
                | 15 GB   |       4 | 35975 |   | 37962 |
                | 15 GB   |       8 | 47919 |   | 51558 |       +7.59%
                | 15 GB   |      12 | 45397 |   | 51163 |       +12.70%
                | 15 GB   |      16 | 45926 |   | 53912 |       +17.39%
                | 15 GB   |      24 | 42184 |   | 55343 |       +31.19%
                | 15 GB   |      32 | 35983 |   | 55358 |       +53.84%

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    8 ++++
 kernel/sched/fair.c   |   97 ++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sysctl.c       |   10 +++++
 3 files changed, 113 insertions(+), 2 deletions(-)

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
index 81fa536..d5acfd8 100644
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
+unsigned int sysctl_sched_wakeup_buddy_ref = 8UL;
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
@@ -3351,8 +3420,30 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
-			prev_cpu = cpu;
+		if (wakeup_related(p) && wake_affine(affine_sd, p, sync)) {
+			/*
+			 * current and p are wakeup related, and balance is
+			 * guaranteed, try to make them closely.
+			 */
+			if (cpu_rq(cpu)->nr_running - sync) {
+				/*
+				 * Current is not going to sleep or there
+				 * are other task on current cpu, search
+				 * an idle cpu close to the current cpu to
+				 * take care latency.
+				 */
+				new_cpu = select_idle_sibling(p, cpu);
+			} else {
+				/*
+				 * current is the only task on rq and it is
+				 * going to sleep, current cpu will be a nice
+				 * candidate for p to run on.
+				 */
+				new_cpu = cpu;
+			}
+
+			goto unlock;
+		}
 
 		new_cpu = select_idle_sibling(p, prev_cpu);
 		goto unlock;
@@ -3399,6 +3490,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 unlock:
 	rcu_read_unlock();
 
+	wakeup_ref(p);
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

