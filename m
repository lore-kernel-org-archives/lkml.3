Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409Ab3CHEh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:37:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60550 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759647Ab3CHEhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:37:23 -0500
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/5] kernel: use tasklist_read_lock_any() when locking tasklist in irq context
Date: Thu,  7 Mar 2013 20:37:14 -0800
Message-Id: <1362717437-1729-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362717437-1729-1-git-send-email-walken@google.com>
References: <1362717437-1729-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following locations may acquire tasklist_lock in either process or
irq/softirq contexts:

- send_sigio(): may be called in any context from kill_fasync()
  (examples: process context from pipe_read(), softirq context from
   n_tty_receive_buf(), hardirq context from rtc_interrupt())

- send_sigurg(): may be called from process or softirq context
  (network receive is typically processed in softirq, but packets can be
   queued up while sockets are being locked and the backlog processed from
   process context as the socket gets unlocked)

- kill_pgrp(): called in process context from job_control(), pty_resize()
  or in softirq context through n_tty_receive_buf()
  or even in hardirq context from arch/um/drivers/line.c winch_interrupt()

- posix_cpu_timer_schedule(): called through cpu_timer_fire(),
  in process context (from posix_cpu_timer_set()) or
  in hardirq context (from run_posix_cpu_timers())

- sysrq debugging features: handle_sysrq() runs in multiple contexts and
  calls into send_sig_all(), debug_show_all_locks(), normalize_rt_tasks(),
  print_rq().

- arch/blackfin/kernel/trace.c decode_address(): another debugging feature,
  may be called from any contexts.

Annotate such locations with tasklist_read_{lock,unlock}_any().

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 arch/blackfin/kernel/trace.c | 4 ++--
 drivers/tty/sysrq.c          | 4 ++--
 fs/fcntl.c                   | 8 ++++----
 kernel/lockdep.c             | 6 +++---
 kernel/posix-cpu-timers.c    | 6 +++---
 kernel/sched/core.c          | 5 ++---
 kernel/sched/debug.c         | 5 ++---
 kernel/signal.c              | 4 ++--
 8 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/blackfin/kernel/trace.c b/arch/blackfin/kernel/trace.c
index f7f7a18abca9..40a748e7019c 100644
--- a/arch/blackfin/kernel/trace.c
+++ b/arch/blackfin/kernel/trace.c
@@ -113,7 +113,7 @@ void decode_address(char *buf, unsigned long address)
 	 * mappings of all our processes and see if we can't be a whee
 	 * bit more specific
 	 */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock_any();
 	for_each_process(p) {
 		struct task_struct *t;
 
@@ -186,7 +186,7 @@ __continue:
 	sprintf(buf, "/* kernel dynamic memory */");
 
 done:
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock_any();
 }
 
 #define EXPAND_LEN ((1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN) * 256 - 1)
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 3687f0cad642..36b84f89bccb 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -322,7 +322,7 @@ static void send_sig_all(int sig)
 {
 	struct task_struct *p;
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock_any();
 	for_each_process(p) {
 		if (p->flags & PF_KTHREAD)
 			continue;
@@ -331,7 +331,7 @@ static void send_sig_all(int sig)
 
 		do_send_sig_info(sig, SEND_SIG_FORCED, p, true);
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock_any();
 }
 
 static void sysrq_handle_term(int key)
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 6599222536eb..b254a86d7330 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -496,11 +496,11 @@ void send_sigio(struct fown_struct *fown, int fd, int band)
 	if (!pid)
 		goto out_unlock_fown;
 	
-	read_lock(&tasklist_lock);
+	tasklist_read_lock_any();
 	do_each_pid_task(pid, type, p) {
 		send_sigio_to_task(p, fown, fd, band, group);
 	} while_each_pid_task(pid, type, p);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock_any();
  out_unlock_fown:
 	read_unlock(&fown->lock);
 }
@@ -534,11 +534,11 @@ int send_sigurg(struct fown_struct *fown)
 
 	ret = 1;
 	
-	read_lock(&tasklist_lock);
+	tasklist_read_lock_any();
 	do_each_pid_task(pid, type, p) {
 		send_sigurg_to_task(p, fown, group);
 	} while_each_pid_task(pid, type, p);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock_any();
  out_unlock_fown:
 	read_unlock(&fown->lock);
 	return ret;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 259db207b5d9..2b2004d05bb7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4132,7 +4132,7 @@ void debug_show_all_locks(void)
 	 * tasklist_lock-holding task deadlocks or crashes.
 	 */
 retry:
-	if (!read_trylock(&tasklist_lock)) {
+	if (!tasklist_read_trylock_any()) {
 		if (count == 10)
 			printk("hm, tasklist_lock locked, retrying... ");
 		if (count) {
@@ -4159,7 +4159,7 @@ retry:
 		if (p->lockdep_depth)
 			lockdep_print_held_locks(p);
 		if (!unlock)
-			if (read_trylock(&tasklist_lock))
+			if (tasklist_read_trylock_any())
 				unlock = 1;
 	} while_each_thread(g, p);
 
@@ -4167,7 +4167,7 @@ retry:
 	printk("=============================================\n\n");
 
 	if (unlock)
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock_any();
 }
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8fd709c9bb58..2f1caac51a7e 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1159,10 +1159,10 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			clear_dead_task(timer, now);
 			goto out;
 		}
-		read_lock(&tasklist_lock); /* arm_timer needs it.  */
+		tasklist_read_lock_any();	/* arm_timer needs it.  */
 		spin_lock(&p->sighand->siglock);
 	} else {
-		read_lock(&tasklist_lock);
+		tasklist_read_lock_any();
 		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * The process has been reaped.
@@ -1195,7 +1195,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	spin_unlock(&p->sighand->siglock);
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock_any();
 
 out:
 	timer->it_overrun_last = timer->it_overrun;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4c0b8c333034..8d87d7ae80a5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7106,10 +7106,9 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 void normalize_rt_tasks(void)
 {
 	struct task_struct *g, *p;
-	unsigned long flags;
 	struct rq *rq;
 
-	read_lock_irqsave(&tasklist_lock, flags);
+	tasklist_read_lock_any();
 	do_each_thread(g, p) {
 		/*
 		 * Only normalize user tasks:
@@ -7143,7 +7142,7 @@ void normalize_rt_tasks(void)
 		raw_spin_unlock(&p->pi_lock);
 	} while_each_thread(g, p);
 
-	read_unlock_irqrestore(&tasklist_lock, flags);
+	tasklist_read_unlock_any();
 }
 
 #endif /* CONFIG_MAGIC_SYSRQ */
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 75024a673520..a98d6b94ad55 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -147,7 +147,6 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 {
 	struct task_struct *g, *p;
-	unsigned long flags;
 
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
@@ -156,7 +155,7 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	"------------------------------------------------------"
 	"----------------------------------------------------\n");
 
-	read_lock_irqsave(&tasklist_lock, flags);
+	tasklist_read_lock_any();
 
 	do_each_thread(g, p) {
 		if (!p->on_rq || task_cpu(p) != rq_cpu)
@@ -165,7 +164,7 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 		print_task(m, rq, p);
 	} while_each_thread(g, p);
 
-	read_unlock_irqrestore(&tasklist_lock, flags);
+	tasklist_read_unlock_any();
 }
 
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
diff --git a/kernel/signal.c b/kernel/signal.c
index 2ec870a4c3c4..9d2b7a4b2a0b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1517,9 +1517,9 @@ int kill_pgrp(struct pid *pid, int sig, int priv)
 {
 	int ret;
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock_any();
 	ret = __kill_pgrp_info(sig, __si_special(priv), pid);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock_any();
 
 	return ret;
 }
-- 
1.8.1.3
