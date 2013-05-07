Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3EGOgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:36:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3EGOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:36:37 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=n_5YJPCd7rDiexmtH5QA:9 a=QEXdDO2ut3YA:10 a=XDWOtBIySrCZf81z:21 a=93bYX899mKXhzaoG:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367937395.7373.51.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.6.11.2-rt34
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Tue, 07 May 2013 10:36:35 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.6.11.2-rt34 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.6-rt
  Head SHA1: e49c8e8225d5135380b53e07d331441e55bdb0c4


Or to build 3.6.11.2-rt34 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.6.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.6.11.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.2.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11.2-rt34.patch.xz



You can also build from 3.6.11.2-rt33 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.11.2-rt33-rt34.patch.xz



Enjoy,

-- Steve


Changes from v3.6.11.2-rt33:

---

Eric Dumazet (1):
      tcp: force a dst refcount when prequeue packet

Priyanka Jain (1):
      powerpc/64bit,PREEMPT_RT: Check preempt_count before preempting

Steven Rostedt (2):
      x86/mce: Defer mce wakeups to threads for PREEMPT_RT
      swap: Use unique local lock name for swap_lock

Steven Rostedt (Red Hat) (1):
      Linux 3.6.11.2-rt34

----
 arch/powerpc/kernel/entry_64.S   |    2 +
 arch/x86/kernel/cpu/mcheck/mce.c |   78 +++++++++++++++++++++++++++++---------
 include/net/tcp.h                |    1 +
 localversion-rt                  |    2 +-
 mm/swap.c                        |   20 +++++-----
 5 files changed, 75 insertions(+), 28 deletions(-)
---------------------------
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index a9b98cc..7af1ea7 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -596,6 +596,8 @@ resume_kernel:
 #ifdef CONFIG_PREEMPT
 	/* Check if we need to preempt */
 	lwz	r8,TI_PREEMPT(r9)
+	cmpwi	0,r8,0		/* if non-zero, just restore regs and return */
+	bne	restore
 	andi.	r0,r4,_TIF_NEED_RESCHED
 	bne+	1f
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e8d8ad0..e31ea90 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -18,6 +18,7 @@
 #include <linux/rcupdate.h>
 #include <linux/kobject.h>
 #include <linux/uaccess.h>
+#include <linux/kthread.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
 #include <linux/percpu.h>
@@ -1308,6 +1309,63 @@ static void mce_do_trigger(struct work_struct *work)
 
 static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
 
+static void __mce_notify_work(void)
+{
+	/* Not more than two messages every minute */
+	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
+
+	/* wake processes polling /dev/mcelog */
+	wake_up_interruptible(&mce_chrdev_wait);
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
@@ -1315,24 +1373,8 @@ static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
  */
 int mce_notify_irq(void)
 {
-	/* Not more than two messages every minute */
-	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
-		/* wake processes polling /dev/mcelog */
-		wake_up_interruptible(&mce_chrdev_wait);
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
@@ -2375,6 +2417,8 @@ static __init int mcheck_init_device(void)
 	/* register character device /dev/mcelog */
 	misc_register(&mce_chrdev_device);
 
+	err = mce_notify_work_init();
+
 	return err;
 }
 device_initcall_sync(mcheck_init_device);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1f000ff..9297897 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1015,6 +1015,7 @@ static inline bool tcp_prequeue(struct sock *sk, struct sk_buff *skb)
 	if (sysctl_tcp_low_latency || !tp->ucopy.task)
 		return false;
 
+	skb_dst_force(skb);
 	__skb_queue_tail(&tp->ucopy.prequeue, skb);
 	tp->ucopy.memory += skb->truesize;
 	if (tp->ucopy.memory > sk->sk_rcvbuf) {
diff --git a/localversion-rt b/localversion-rt
index e1d8362..21988f9 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt33
+-rt34
diff --git a/mm/swap.c b/mm/swap.c
index 8ef0e84..0f9ad9d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -42,7 +42,7 @@ static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
 
 static DEFINE_LOCAL_IRQ_LOCK(rotate_lock);
-static DEFINE_LOCAL_IRQ_LOCK(swap_lock);
+static DEFINE_LOCAL_IRQ_LOCK(swapvec_lock);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -407,13 +407,13 @@ static void activate_page_drain(int cpu)
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
 
@@ -453,12 +453,12 @@ EXPORT_SYMBOL(mark_page_accessed);
 
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
-	struct pagevec *pvec = &get_locked_var(swap_lock, lru_add_pvecs)[lru];
+	struct pagevec *pvec = &get_locked_var(swapvec_lock, lru_add_pvecs)[lru];
 
 	page_cache_get(page);
 	if (!pagevec_add(pvec, page))
 		__pagevec_lru_add(pvec, lru);
-	put_locked_var(swap_lock, lru_add_pvecs);
+	put_locked_var(swapvec_lock, lru_add_pvecs);
 }
 EXPORT_SYMBOL(__lru_cache_add);
 
@@ -623,19 +623,19 @@ void deactivate_page(struct page *page)
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
-	lru_add_drain_cpu(local_lock_cpu(swap_lock));
-	local_unlock_cpu(swap_lock);
+	lru_add_drain_cpu(local_lock_cpu(swapvec_lock));
+	local_unlock_cpu(swapvec_lock);
 }
 
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
@@ -850,7 +850,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
 static int __init swap_init_locks(void)
 {
 	local_irq_lock_init(rotate_lock);
-	local_irq_lock_init(swap_lock);
+	local_irq_lock_init(swapvec_lock);
 	return 1;
 }
 early_initcall(swap_init_locks);


