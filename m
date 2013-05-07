Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3EGOiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:38:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13128 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3EGOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:38:14 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=n_5YJPCd7rDiexmtH5QA:9 a=QEXdDO2ut3YA:10 a=38fUrirX6W79M3Ik:21 a=Elv4oMUYekaEJX_U:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367937490.7373.54.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.0.75-rt103
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Tue, 07 May 2013 10:38:10 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.0.75-rt103 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.0-rt
  Head SHA1: 359b8b074c355e73a1223e759445a5fe7a79dd97


Or to build 3.0.75-rt103 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.75.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.75-rt103.patch.xz



You can also build from 3.0.75-rt102 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.75-rt102-rt103.patch.xz



Enjoy,

-- Steve


Changes from v3.0.75-rt102:

---

Eric Dumazet (1):
      tcp: force a dst refcount when prequeue packet

Steven Rostedt (2):
      x86/mce: Defer mce wakeups to threads for PREEMPT_RT
      swap: Use unique local lock name for swap_lock

Steven Rostedt (Red Hat) (1):
      Linux 3.0.75-rt103

----
 arch/x86/kernel/cpu/mcheck/mce.c |   76 ++++++++++++++++++++++++++++++--------
 include/net/tcp.h                |    1 +
 localversion-rt                  |    2 +-
 mm/swap.c                        |   20 +++++-----
 4 files changed, 72 insertions(+), 27 deletions(-)
---------------------------
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3d38e73..c859bb4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -16,6 +16,7 @@
 #include <linux/rcupdate.h>
 #include <linux/kobject.h>
 #include <linux/uaccess.h>
+#include <linux/kthread.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
 #include <linux/percpu.h>
@@ -1181,6 +1182,62 @@ static void mce_do_trigger(struct work_struct *work)
 
 static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
 
+static void __mce_notify_work(void)
+{
+	/* Not more than two messages every minute */
+	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
+
+	wake_up_interruptible(&mce_wait);
+
+	/*
+	 * There is no risk of missing notifications because
+	 * work_pending is always cleared before the function is
+	 * executed.
+	 */
+	if (mce_helper[0] && !work_pending(&mce_trigger_work))
+		schedule_work(&mce_trigger_work);
+
+	if (__ratelimit(&ratelimit))
+		pr_info(HW_ERR "Machine check events logged\n");
+}
+
+#ifdef CONFIG_PREEMPT_RT_FULL
+struct task_struct *mce_notify_helper;
+
+static int mce_notify_helper_thread(void *unused)
+{
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+		if (kthread_should_stop())
+			break;
+		__mce_notify_work();
+	}
+	return 0;
+}
+
+static int mce_notify_work_init(void)
+{
+	mce_notify_helper = kthread_run(mce_notify_helper_thread, NULL,
+					   "mce-notify");
+	if (!mce_notify_helper)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void mce_notify_work(void)
+{
+	wake_up_process(mce_notify_helper);
+}
+#else
+static void mce_notify_work(void)
+{
+	__mce_notify_work();
+}
+static inline int mce_notify_work_init(void) { return 0; }
+#endif
+
 /*
  * Notify the user(s) about new machine check events.
  * Can be called from interrupt context, but not from machine check/NMI
@@ -1188,25 +1245,10 @@ static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
  */
 int mce_notify_irq(void)
 {
-	/* Not more than two messages every minute */
-	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
-
 	clear_thread_flag(TIF_MCE_NOTIFY);
 
 	if (test_and_clear_bit(0, &mce_need_notify)) {
-		wake_up_interruptible(&mce_wait);
-
-		/*
-		 * There is no risk of missing notifications because
-		 * work_pending is always cleared before the function is
-		 * executed.
-		 */
-		if (mce_helper[0] && !work_pending(&mce_trigger_work))
-			schedule_work(&mce_trigger_work);
-
-		if (__ratelimit(&ratelimit))
-			pr_info(HW_ERR "Machine check events logged\n");
-
+		mce_notify_work();
 		return 1;
 	}
 	return 0;
@@ -2136,6 +2178,8 @@ static __init int mcheck_init_device(void)
 	register_hotcpu_notifier(&mce_cpu_notifier);
 	misc_register(&mce_log_device);
 
+	err = mce_notify_work_init();
+
 	return err;
 }
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index b28a49f..4881cb6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -902,6 +902,7 @@ static inline int tcp_prequeue(struct sock *sk, struct sk_buff *skb)
 	if (sysctl_tcp_low_latency || !tp->ucopy.task)
 		return 0;
 
+	skb_dst_force(skb);
 	__skb_queue_tail(&tp->ucopy.prequeue, skb);
 	tp->ucopy.memory += skb->truesize;
 	if (tp->ucopy.memory > sk->sk_rcvbuf) {
diff --git a/localversion-rt b/localversion-rt
index 33017cd..e0a0b11 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt102
+-rt103
diff --git a/mm/swap.c b/mm/swap.c
index 662972f..ccf04d2 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -43,7 +43,7 @@ static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
 
 static DEFINE_LOCAL_IRQ_LOCK(rotate_lock);
-static DEFINE_LOCAL_IRQ_LOCK(swap_lock);
+static DEFINE_LOCAL_IRQ_LOCK(swapvec_lock);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -331,13 +331,13 @@ static void activate_page_drain(int cpu)
 void activate_page(struct page *page)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-		struct pagevec *pvec = &get_locked_var(swap_lock,
+		struct pagevec *pvec = &get_locked_var(swapvec_lock,
 						       activate_page_pvecs);
 
 		page_cache_get(page);
 		if (!pagevec_add(pvec, page))
 			pagevec_lru_move_fn(pvec, __activate_page, NULL);
-		put_locked_var(swap_lock, activate_page_pvecs);
+		put_locked_var(swapvec_lock, activate_page_pvecs);
 	}
 }
 
@@ -378,12 +378,12 @@ EXPORT_SYMBOL(mark_page_accessed);
 
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
-	struct pagevec *pvec = &get_locked_var(swap_lock, lru_add_pvecs)[lru];
+	struct pagevec *pvec = &get_locked_var(swapvec_lock, lru_add_pvecs)[lru];
 
 	page_cache_get(page);
 	if (!pagevec_add(pvec, page))
 		____pagevec_lru_add(pvec, lru);
-	put_locked_var(swap_lock, lru_add_pvecs);
+	put_locked_var(swapvec_lock, lru_add_pvecs);
 }
 EXPORT_SYMBOL(__lru_cache_add);
 
@@ -547,19 +547,19 @@ void deactivate_page(struct page *page)
 		return;
 
 	if (likely(get_page_unless_zero(page))) {
-		struct pagevec *pvec = &get_locked_var(swap_lock,
+		struct pagevec *pvec = &get_locked_var(swapvec_lock,
 						       lru_deactivate_pvecs);
 
 		if (!pagevec_add(pvec, page))
 			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
-		put_locked_var(swap_lock, lru_deactivate_pvecs);
+		put_locked_var(swapvec_lock, lru_deactivate_pvecs);
 	}
 }
 
 void lru_add_drain(void)
 {
-	drain_cpu_pagevecs(local_lock_cpu(swap_lock));
-	local_unlock_cpu(swap_lock);
+	drain_cpu_pagevecs(local_lock_cpu(swapvec_lock));
+	local_unlock_cpu(swapvec_lock);
 }
 
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
@@ -776,7 +776,7 @@ EXPORT_SYMBOL(pagevec_lookup);
 static int __init swap_init_locks(void)
 {
 	local_irq_lock_init(rotate_lock);
-	local_irq_lock_init(swap_lock);
+	local_irq_lock_init(swapvec_lock);
 	return 1;
 }
 early_initcall(swap_init_locks);


