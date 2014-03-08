Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaCHVj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 16:39:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:44136 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaCHVj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 16:39:26 -0500
Date: Sat, 8 Mar 2014 22:39:23 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.13-rt21
Message-ID: <20140308213923.GA14337@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.13-rt21 patch set.

Changes since v3.12.13-rt20
- the recent change to cpu_chill() could defeat its purpose if the task
  invoking cpu_chill() had a signal pending. Noticed by Ulrich Obergfell
  and fixed by Steven Rostedt.

- David Miller coverted a few sparc serial drivers.

- the system may deadlock if a high prio process tries to shutdown a
  network device. This results in a busy loop until the interrupt
  thread has completed its work which will never happen if its priority
  is lower compared to the task that requested the shutdown. Reported
  and fixed by Marc Kleine-Budde.

- I run into a dead lock situtation in ext4 on v3.2. I couldn't
  reproduce the same lockup on v3.12 but since we keep a similar patch
  fot ext3 I decided to add one for ext4 just in case the problem is
  harder to trigger now.

Known issues:

      - bcache is disabled.

The delta patch against v3.12.13-rt20 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.13-rt20-rt21.patch.xz

The RT patch against 3.12.13 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.13-rt21.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.13-rt21.tar.xz

Sebastian

diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index cf86e72..dc697ce 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -433,13 +433,10 @@ static void sunhv_console_write_paged(struct console *con, const char *s, unsign
 	unsigned long flags;
 	int locked = 1;
 
-	local_irq_save(flags);
-	if (port->sysrq) {
-		locked = 0;
-	} else if (oops_in_progress) {
-		locked = spin_trylock(&port->lock);
-	} else
-		spin_lock(&port->lock);
+	if (port->sysrq || oops_in_progress)
+		locked = spin_trylock_irqsave(&port->lock, flags);
+	else
+		spin_lock_irqsave(&port->lock, flags);
 
 	while (n > 0) {
 		unsigned long ra = __pa(con_write_page);
@@ -470,8 +467,7 @@ static void sunhv_console_write_paged(struct console *con, const char *s, unsign
 	}
 
 	if (locked)
-		spin_unlock(&port->lock);
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static inline void sunhv_console_putchar(struct uart_port *port, char c)
@@ -492,7 +488,10 @@ static void sunhv_console_write_bychar(struct console *con, const char *s, unsig
 	unsigned long flags;
 	int i, locked = 1;
 
-	local_irq_save(flags);
+	if (port->sysrq || oops_in_progress)
+		locked = spin_trylock_irqsave(&port->lock, flags);
+	else
+		spin_lock_irqsave(&port->lock, flags);
 	if (port->sysrq) {
 		locked = 0;
 	} else if (oops_in_progress) {
@@ -507,8 +506,7 @@ static void sunhv_console_write_bychar(struct console *con, const char *s, unsig
 	}
 
 	if (locked)
-		spin_unlock(&port->lock);
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static struct console sunhv_console = {
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 5d6136b..1bf2774 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -844,20 +844,16 @@ static void sunsab_console_write(struct console *con, const char *s, unsigned n)
 	unsigned long flags;
 	int locked = 1;
 
-	local_irq_save(flags);
-	if (up->port.sysrq) {
-		locked = 0;
-	} else if (oops_in_progress) {
-		locked = spin_trylock(&up->port.lock);
-	} else
-		spin_lock(&up->port.lock);
+	if (up->port.sysrq || oops_in_progress)
+		locked = spin_trylock_irqsave(&up->port.lock, flags);
+	else
+		spin_lock_irqsave(&up->port.lock, flags);
 
 	uart_console_write(&up->port, s, n, sunsab_console_putchar);
 	sunsab_tec_wait(up);
 
 	if (locked)
-		spin_unlock(&up->port.lock);
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
 static int sunsab_console_setup(struct console *con, char *options)
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 699cc1b..d88fb63 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -1295,13 +1295,10 @@ static void sunsu_console_write(struct console *co, const char *s,
 	unsigned int ier;
 	int locked = 1;
 
-	local_irq_save(flags);
-	if (up->port.sysrq) {
-		locked = 0;
-	} else if (oops_in_progress) {
-		locked = spin_trylock(&up->port.lock);
-	} else
-		spin_lock(&up->port.lock);
+	if (up->port.sysrq || oops_in_progress)
+		locked = spin_trylock_irqsave(&up->port.lock, flags);
+	else
+		spin_lock_irqsave(&up->port.lock, flags);
 
 	/*
 	 *	First save the UER then disable the interrupts
@@ -1319,8 +1316,7 @@ static void sunsu_console_write(struct console *co, const char *s,
 	serial_out(up, UART_IER, ier);
 
 	if (locked)
-		spin_unlock(&up->port.lock);
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
 /*
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 135a152..3103c3b 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -1195,20 +1195,16 @@ sunzilog_console_write(struct console *con, const char *s, unsigned int count)
 	unsigned long flags;
 	int locked = 1;
 
-	local_irq_save(flags);
-	if (up->port.sysrq) {
-		locked = 0;
-	} else if (oops_in_progress) {
-		locked = spin_trylock(&up->port.lock);
-	} else
-		spin_lock(&up->port.lock);
+	if (up->port.sysrq || oops_in_progress)
+		locked = spin_trylock_irqsave(&up->port.lock, flags);
+	else
+		spin_lock_irqsave(&up->port.lock, flags);
 
 	uart_console_write(&up->port, s, count, sunzilog_putchar);
 	udelay(2);
 
 	if (locked)
-		spin_unlock(&up->port.lock);
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
 static int __init sunzilog_console_setup(struct console *con, char *options)
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 7f34f47..8c40400 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -125,6 +125,8 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 		if (journal->j_flags & JBD2_ABORT)
 			return;
 		write_unlock(&journal->j_state_lock);
+		if (current->plug)
+			io_schedule();
 		mutex_lock(&journal->j_checkpoint_mutex);
 
 		/*
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 083815d..c19183d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1769,12 +1769,13 @@ void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(hrtimer_init_sleeper);
 
-static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
+static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode,
+				unsigned long state)
 {
 	hrtimer_init_sleeper(t, current);
 
 	do {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(state);
 		hrtimer_start_expires(&t->timer, mode);
 		if (!hrtimer_active(&t->timer))
 			t->task = NULL;
@@ -1818,7 +1819,8 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 				HRTIMER_MODE_ABS);
 	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);
 
-	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
+	/* cpu_chill() does not care about restart state. */
+	if (do_nanosleep(&t, HRTIMER_MODE_ABS, TASK_INTERRUPTIBLE))
 		goto out;
 
 	rmtp = restart->nanosleep.rmtp;
@@ -1835,8 +1837,10 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 	return ret;
 }
 
-long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
-		       const enum hrtimer_mode mode, const clockid_t clockid)
+static long
+__hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
+		    const enum hrtimer_mode mode, const clockid_t clockid,
+		    unsigned long state)
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
@@ -1849,7 +1853,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
-	if (do_nanosleep(&t, mode))
+	if (do_nanosleep(&t, mode, state))
 		goto out;
 
 	/* Absolute timers do not update the rmtp value and restart: */
@@ -1876,6 +1880,12 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	return ret;
 }
 
+long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
+		       const enum hrtimer_mode mode, const clockid_t clockid)
+{
+	return __hrtimer_nanosleep(rqtp, rmtp, mode, clockid, TASK_INTERRUPTIBLE);
+}
+
 SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 		struct timespec __user *, rmtp)
 {
@@ -1902,7 +1912,8 @@ void cpu_chill(void)
 	unsigned int freeze_flag = current->flags & PF_NOFREEZE;
 
 	current->flags |= PF_NOFREEZE;
-	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	__hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC,
+			    TASK_UNINTERRUPTIBLE);
 	if (!freeze_flag)
 		current->flags &= ~PF_NOFREEZE;
 }
diff --git a/localversion-rt b/localversion-rt
index e095ab8..6c6cde1 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt20
+-rt21
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a74e278..1dcebc9 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -850,7 +850,7 @@ void dev_deactivate_many(struct list_head *head)
 	/* Wait for outstanding qdisc_run calls. */
 	list_for_each_entry(dev, head, unreg_list)
 		while (some_qdisc_is_busy(dev))
-			yield();
+			msleep(1);
 }
 
 void dev_deactivate(struct net_device *dev)
