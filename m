Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaBRXd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:33:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaBRWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, pjt@google.com,
        Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 15/24] sched/nohz: Fix rq->cpu_load calculations some more
Date: Tue, 18 Feb 2014 14:47:02 -0800
Message-Id: <20140218224550.657593239@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
References: <20140218224550.221535225@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 5aaa0b7a2ed5b12692c9ffb5222182bd558d3146 upstream.

Follow up on commit 556061b00 ("sched/nohz: Fix rq->cpu_load[]
calculations") since while that fixed the busy case it regressed the
mostly idle case.

Add a callback from the nohz exit to also age the rq->cpu_load[]
array. This closes the hole where either there was no nohz load
balance pass during the nohz, or there was a 'significant' amount of
idle time between the last nohz balance and the nohz exit.

So we'll update unconditionally from the tick to not insert any
accidental 0 load periods while busy, and we try and catch up from
nohz idle balance and nohz exit. Both these are still prone to missing
a jiffy, but that has always been the case.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: pjt@google.com
Cc: Venkatesh Pallipadi <venki@google.com>
Link: http://lkml.kernel.org/n/tip-kt0trz0apodbf84ucjfdbr1a@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sched.h    |    1 
 kernel/sched/core.c      |   53 ++++++++++++++++++++++++++++++++++++++---------
 kernel/time/tick-sched.c |    1 
 3 files changed, 45 insertions(+), 10 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -144,6 +144,7 @@ extern unsigned long this_cpu_load(void)
 
 
 extern void calc_global_load(unsigned long ticks);
+extern void update_cpu_load_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2649,25 +2649,32 @@ static void __update_cpu_load(struct rq
 	sched_avg_update(this_rq);
 }
 
+#ifdef CONFIG_NO_HZ
+/*
+ * There is no sane way to deal with nohz on smp when using jiffies because the
+ * cpu doing the jiffies update might drift wrt the cpu doing the jiffy reading
+ * causing off-by-one errors in observed deltas; {0,2} instead of {1,1}.
+ *
+ * Therefore we cannot use the delta approach from the regular tick since that
+ * would seriously skew the load calculation. However we'll make do for those
+ * updates happening while idle (nohz_idle_balance) or coming out of idle
+ * (tick_nohz_idle_exit).
+ *
+ * This means we might still be one tick off for nohz periods.
+ */
+
 /*
  * Called from nohz_idle_balance() to update the load ratings before doing the
  * idle balance.
  */
 void update_idle_cpu_load(struct rq *this_rq)
 {
-	unsigned long curr_jiffies = jiffies;
+	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
 	unsigned long load = this_rq->load.weight;
 	unsigned long pending_updates;
 
 	/*
-	 * Bloody broken means of dealing with nohz, but better than nothing..
-	 * jiffies is updated by one cpu, another cpu can drift wrt the jiffy
-	 * update and see 0 difference the one time and 2 the next, even though
-	 * we ticked at roughtly the same rate.
-	 *
-	 * Hence we only use this from nohz_idle_balance() and skip this
-	 * nonsense when called from the scheduler_tick() since that's
-	 * guaranteed a stable rate.
+	 * bail if there's load or we're actually up-to-date.
 	 */
 	if (load || curr_jiffies == this_rq->last_load_update_tick)
 		return;
@@ -2679,12 +2686,38 @@ void update_idle_cpu_load(struct rq *thi
 }
 
 /*
+ * Called from tick_nohz_idle_exit() -- try and fix up the ticks we missed.
+ */
+void update_cpu_load_nohz(void)
+{
+	struct rq *this_rq = this_rq();
+	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+	unsigned long pending_updates;
+
+	if (curr_jiffies == this_rq->last_load_update_tick)
+		return;
+
+	raw_spin_lock(&this_rq->lock);
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	if (pending_updates) {
+		this_rq->last_load_update_tick = curr_jiffies;
+		/*
+		 * We were idle, this means load 0, the current load might be
+		 * !0 due to remote wakeups and the sort.
+		 */
+		__update_cpu_load(this_rq, 0, pending_updates);
+	}
+	raw_spin_unlock(&this_rq->lock);
+}
+#endif /* CONFIG_NO_HZ */
+
+/*
  * Called from scheduler_tick()
  */
 static void update_cpu_load_active(struct rq *this_rq)
 {
 	/*
-	 * See the mess in update_idle_cpu_load().
+	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
 	__update_cpu_load(this_rq, this_rq->load.weight, 1);
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -582,6 +582,7 @@ void tick_nohz_idle_exit(void)
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
+	update_cpu_load_nohz();
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	/*


