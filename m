Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab3BTUQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:16:10 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54908 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936002Ab3BTUQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:16:06 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 27/32] tty: Replace ldisc locking with ldisc_sem
Date: Wed, 20 Feb 2013 15:03:14 -0500
Message-Id: <1361390599-15195-28-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line discipline locking was performed with a combination of
a mutex, a status bit, a count, and a waitqueue -- basically,
a rw semaphore.

Replace the existing combination with an ld_semaphore.

Fixes:
 1) the 'reference acquire after ldisc locked' bug
 2) the over-complicated halt mechanism
 3) lock order wrt. tty_lock()
 4) dropping locks while changing ldisc
 5) previously unidentified deadlock while locking ldisc from
    both linked ttys concurrently
 6) previously unidentified recursive deadlocks

Adds much-needed lockdep diagnostics.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c  |   2 +-
 drivers/tty/tty_io.c      |   7 +-
 drivers/tty/tty_ldisc.c   | 324 ++++++----------------------------------------
 include/linux/tty.h       |   4 +-
 include/linux/tty_ldisc.h |   3 +-
 5 files changed, 48 insertions(+), 292 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index bb11993..0dd35ce 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -429,7 +429,7 @@ static void flush_to_ldisc(struct work_struct *work)
 		return;
 
 	disc = tty_ldisc_ref(tty);
-	if (disc == NULL)	/*  !TTY_LDISC */
+	if (disc == NULL)
 		return;
 
 	spin_lock_irqsave(&buf->lock, flags);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 2261c21..376080d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1328,8 +1328,7 @@ static int tty_reopen(struct tty_struct *tty)
 	struct tty_driver *driver = tty->driver;
 
 	if (test_bit(TTY_CLOSING, &tty->flags) ||
-			test_bit(TTY_HUPPING, &tty->flags) ||
-			test_bit(TTY_LDISC_CHANGING, &tty->flags))
+			test_bit(TTY_HUPPING, &tty->flags))
 		return -EIO;
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY &&
@@ -1345,7 +1344,7 @@ static int tty_reopen(struct tty_struct *tty)
 	}
 	tty->count++;
 
-	WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
+	WARN_ON(!tty->ldisc);
 
 	return 0;
 }
@@ -2955,7 +2954,7 @@ void initialize_tty_struct(struct tty_struct *tty,
 	tty->pgrp = NULL;
 	mutex_init(&tty->legacy_mutex);
 	mutex_init(&tty->termios_mutex);
-	mutex_init(&tty->ldisc_mutex);
+	init_ldsem(&tty->ldisc_sem);
 	init_waitqueue_head(&tty->write_wait);
 	init_waitqueue_head(&tty->read_wait);
 	INIT_WORK(&tty->hangup_work, do_tty_hangup);
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index ae0287f..a150f95 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -45,7 +45,6 @@ enum {
  */
 
 static DEFINE_RAW_SPINLOCK(tty_ldisc_lock);
-static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
 /* Line disc dispatch table */
 static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 
@@ -153,7 +152,7 @@ static void put_ldops(struct tty_ldisc_ops *ldops)
  *		takes tty_ldisc_lock to guard against ldisc races
  */
 
-static struct tty_ldisc *tty_ldisc_get(int disc)
+static struct tty_ldisc *tty_ldisc_get(struct tty_struct *tty, int disc)
 {
 	struct tty_ldisc *ld;
 	struct tty_ldisc_ops *ldops;
@@ -180,8 +179,7 @@ static struct tty_ldisc *tty_ldisc_get(int disc)
 	}
 
 	ld->ops = ldops;
-	atomic_set(&ld->users, 1);
-	init_waitqueue_head(&ld->wq_idle);
+	ld->tty = tty;
 
 	return ld;
 }
@@ -193,20 +191,11 @@ static struct tty_ldisc *tty_ldisc_get(int disc)
  */
 static inline void tty_ldisc_put(struct tty_ldisc *ld)
 {
-	unsigned long flags;
-
 	if (WARN_ON_ONCE(!ld))
 		return;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
-
-	/* unreleased reader reference(s) will cause this WARN */
-	WARN_ON(!atomic_dec_and_test(&ld->users));
-
-	ld->ops->refcount--;
-	module_put(ld->ops->owner);
+	put_ldops(ld->ops);
 	kfree(ld);
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 }
 
 static void *tty_ldiscs_seq_start(struct seq_file *m, loff_t *pos)
@@ -258,34 +247,6 @@ const struct file_operations tty_ldiscs_proc_fops = {
 };
 
 /**
- *	tty_ldisc_try		-	internal helper
- *	@tty: the tty
- *
- *	Make a single attempt to grab and bump the refcount on
- *	the tty ldisc. Return 0 on failure or 1 on success. This is
- *	used to implement both the waiting and non waiting versions
- *	of tty_ldisc_ref
- *
- *	Locking: takes tty_ldisc_lock
- */
-
-static struct tty_ldisc *tty_ldisc_try(struct tty_struct *tty)
-{
-	unsigned long flags;
-	struct tty_ldisc *ld;
-
-	/* FIXME: this allows reference acquire after TTY_LDISC is cleared */
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
-	ld = NULL;
-	if (test_bit(TTY_LDISC, &tty->flags) && tty->ldisc) {
-		ld = tty->ldisc;
-		atomic_inc(&ld->users);
-	}
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	return ld;
-}
-
-/**
  *	tty_ldisc_ref_wait	-	wait for the tty ldisc
  *	@tty: tty device
  *
@@ -298,16 +259,15 @@ static struct tty_ldisc *tty_ldisc_try(struct tty_struct *tty)
  *	against a discipline change, such as an existing ldisc reference
  *	(which we check for)
  *
- *	Locking: call functions take tty_ldisc_lock
+ *	Note: only callable from a file_operations routine (which
+ *	guarantees tty->ldisc !- NULL when the lock is acquired).
  */
 
 struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *tty)
 {
-	struct tty_ldisc *ld;
-
-	/* wait_event is a macro */
-	wait_event(tty_ldisc_wait, (ld = tty_ldisc_try(tty)) != NULL);
-	return ld;
+	ldsem_down_read(&tty->ldisc_sem, MAX_SCHEDULE_TIMEOUT);
+	WARN_ON(!tty->ldisc);
+	return tty->ldisc;
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_ref_wait);
 
@@ -318,13 +278,16 @@ EXPORT_SYMBOL_GPL(tty_ldisc_ref_wait);
  *	Dereference the line discipline for the terminal and take a
  *	reference to it. If the line discipline is in flux then
  *	return NULL. Can be called from IRQ and timer functions.
- *
- *	Locking: called functions take tty_ldisc_lock
  */
 
 struct tty_ldisc *tty_ldisc_ref(struct tty_struct *tty)
 {
-	return tty_ldisc_try(tty);
+	if (ldsem_down_read_trylock(&tty->ldisc_sem)) {
+		if (!tty->ldisc)
+			ldsem_up_read(&tty->ldisc_sem);
+		return tty->ldisc;
+	}
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_ref);
 
@@ -334,27 +297,11 @@ EXPORT_SYMBOL_GPL(tty_ldisc_ref);
  *
  *	Undoes the effect of tty_ldisc_ref or tty_ldisc_ref_wait. May
  *	be called in IRQ context.
- *
- *	Locking: takes tty_ldisc_lock
  */
 
 void tty_ldisc_deref(struct tty_ldisc *ld)
 {
-	unsigned long flags;
-
-	if (WARN_ON_ONCE(!ld))
-		return;
-
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
-	/*
-	 * WARNs if one-too-many reader references were released
-	 * - the last reference must be released with tty_ldisc_put
-	 */
-	WARN_ON(atomic_dec_and_test(&ld->users));
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-
-	if (waitqueue_active(&ld->wq_idle))
-		wake_up(&ld->wq_idle);
+	ldsem_up_read(&ld->tty->ldisc_sem);
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_deref);
 
@@ -439,26 +386,6 @@ static void __lockfunc tty_ldisc_enable_pair(struct tty_struct *tty,
 
 
 /**
- *	tty_ldisc_enable	-	allow ldisc use
- *	@tty: terminal to activate ldisc on
- *
- *	Set the TTY_LDISC flag when the line discipline can be called
- *	again. Do necessary wakeups for existing sleepers. Clear the LDISC
- *	changing flag to indicate any ldisc change is now over.
- *
- *	Note: nobody should set the TTY_LDISC bit except via this function.
- *	Clearing directly is allowed.
- */
-
-static void tty_ldisc_enable(struct tty_struct *tty)
-{
-	clear_bit(TTY_LDISC_HALTED, &tty->flags);
-	set_bit(TTY_LDISC, &tty->flags);
-	clear_bit(TTY_LDISC_CHANGING, &tty->flags);
-	wake_up(&tty_ldisc_wait);
-}
-
-/**
  *	tty_ldisc_flush	-	flush line discipline queue
  *	@tty: tty
  *
@@ -555,14 +482,14 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 	int r;
 
 	/* There is an outstanding reference here so this is safe */
-	old = tty_ldisc_get(old->ops->num);
+	old = tty_ldisc_get(tty, old->ops->num);
 	WARN_ON(IS_ERR(old));
 	tty->ldisc = old;
 	tty_set_termios_ldisc(tty, old->ops->num);
 	if (tty_ldisc_open(tty, old) < 0) {
 		tty_ldisc_put(old);
 		/* This driver is always present */
-		new_ldisc = tty_ldisc_get(N_TTY);
+		new_ldisc = tty_ldisc_get(tty, N_TTY);
 		if (IS_ERR(new_ldisc))
 			panic("n_tty: get");
 		tty->ldisc = new_ldisc;
@@ -576,101 +503,6 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 }
 
 /**
- *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
- *	@tty: tty to wait for
- *	@timeout: for how long to wait at most
- *
- *	Wait for the line discipline to become idle. The discipline must
- *	have been halted for this to guarantee it remains idle.
- */
-static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
-{
-	long ret;
-	ret = wait_event_timeout(tty->ldisc->wq_idle,
-			atomic_read(&tty->ldisc->users) == 1, timeout);
-	return ret > 0 ? 0 : -EBUSY;
-}
-
-/**
- *	tty_ldisc_halt		-	shut down the line discipline
- *	@tty: tty device
- *	@o_tty: paired pty device (can be NULL)
- *	@timeout: # of jiffies to wait for ldisc refs to be released
- *
- *	Shut down the line discipline and work queue for this tty device and
- *	its paired pty (if exists). Clearing the TTY_LDISC flag ensures
- *	no further references can be obtained, while waiting for existing
- *	references to be released ensures no more data is fed to the ldisc.
- *
- *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
- *	in order to make sure any currently executing ldisc work is also
- *	flushed.
- */
-
-static int tty_ldisc_halt(struct tty_struct *tty, struct tty_struct *o_tty,
-			  long timeout)
-{
-	int retval;
-
-	clear_bit(TTY_LDISC, &tty->flags);
-	if (o_tty)
-		clear_bit(TTY_LDISC, &o_tty->flags);
-
-	retval = tty_ldisc_wait_idle(tty, timeout);
-	if (!retval && o_tty)
-		retval = tty_ldisc_wait_idle(o_tty, timeout);
-	if (retval)
-		return retval;
-
-	set_bit(TTY_LDISC_HALTED, &tty->flags);
-	if (o_tty)
-		set_bit(TTY_LDISC_HALTED, &o_tty->flags);
-
-	return 0;
-}
-
-/**
- *	tty_ldisc_hangup_halt - halt the line discipline for hangup
- *	@tty: tty being hung up
- *
- *	Shut down the line discipline and work queue for the tty device
- *	being hungup. Clear the TTY_LDISC flag to ensure no further
- *	references can be obtained and wait for remaining references to be
- *	released to ensure no more data is fed to this ldisc.
- *	Caller must hold legacy and ->ldisc_mutex.
- *
- *	NB: tty_set_ldisc() is prevented from changing the ldisc concurrently
- *	with this function by checking the TTY_HUPPING flag.
- */
-static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
-{
-	char cur_n[TASK_COMM_LEN], tty_n[64];
-	long timeout = 3 * HZ;
-
-	clear_bit(TTY_LDISC, &tty->flags);
-
-	if (tty->ldisc) {	/* Not yet closed */
-		tty_unlock(tty);
-
-		while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
-			timeout = MAX_SCHEDULE_TIMEOUT;
-			printk_ratelimited(KERN_WARNING
-				"%s: waiting (%s) for %s took too long, but we keep waiting...\n",
-				__func__, get_task_comm(cur_n, current),
-				tty_name(tty, tty_n));
-		}
-
-		set_bit(TTY_LDISC_HALTED, &tty->flags);
-
-		/* must reacquire both locks and preserve lock order */
-		mutex_unlock(&tty->ldisc_mutex);
-		tty_lock(tty);
-		mutex_lock(&tty->ldisc_mutex);
-	}
-	return !!tty->ldisc;
-}
-
-/**
  *	tty_set_ldisc		-	set line discipline
  *	@tty: the terminal to set
  *	@ldisc: the line discipline
@@ -679,103 +511,45 @@ static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
  *	context. The ldisc change logic has to protect itself against any
  *	overlapping ldisc change (including on the other end of pty pairs),
  *	the close of one side of a tty/pty pair, and eventually hangup.
- *
- *	Locking: takes tty_ldisc_lock, termios_mutex
  */
 
 int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 {
 	int retval;
 	struct tty_ldisc *o_ldisc, *new_ldisc;
-	struct tty_struct *o_tty;
+	struct tty_struct *o_tty = tty->link;
 
-	new_ldisc = tty_ldisc_get(ldisc);
+	new_ldisc = tty_ldisc_get(tty, ldisc);
 	if (IS_ERR(new_ldisc))
 		return PTR_ERR(new_ldisc);
 
-	tty_lock(tty);
-	/*
-	 *	We need to look at the tty locking here for pty/tty pairs
-	 *	when both sides try to change in parallel.
-	 */
-
-	o_tty = tty->link;	/* o_tty is the pty side or NULL */
-
+	retval = tty_ldisc_lock_pair_timeout(tty, o_tty, 5 * HZ);
+	if (retval)
+		return retval;
 
 	/*
 	 *	Check the no-op case
 	 */
 
 	if (tty->ldisc->ops->num == ldisc) {
-		tty_unlock(tty);
+		tty_ldisc_enable_pair(tty, o_tty);
 		tty_ldisc_put(new_ldisc);
 		return 0;
 	}
 
-	mutex_lock(&tty->ldisc_mutex);
-
-	/*
-	 *	We could be midstream of another ldisc change which has
-	 *	dropped the lock during processing. If so we need to wait.
-	 */
-
-	while (test_bit(TTY_LDISC_CHANGING, &tty->flags)) {
-		mutex_unlock(&tty->ldisc_mutex);
-		tty_unlock(tty);
-		wait_event(tty_ldisc_wait,
-			test_bit(TTY_LDISC_CHANGING, &tty->flags) == 0);
-		tty_lock(tty);
-		mutex_lock(&tty->ldisc_mutex);
-	}
-
-	set_bit(TTY_LDISC_CHANGING, &tty->flags);
-
-	/*
-	 *	No more input please, we are switching. The new ldisc
-	 *	will update this value in the ldisc open function
-	 */
-
+	/* FIXME: why 'shutoff' input if the ldisc is locked? */
 	tty->receive_room = 0;
 
 	o_ldisc = tty->ldisc;
-
-	tty_unlock(tty);
-	/*
-	 *	Make sure we don't change while someone holds a
-	 *	reference to the line discipline. The TTY_LDISC bit
-	 *	prevents anyone taking a reference once it is clear.
-	 *	We need the lock to avoid racing reference takers.
-	 *
-	 *	We must clear the TTY_LDISC bit here to avoid a livelock
-	 *	with a userspace app continually trying to use the tty in
-	 *	parallel to the change and re-referencing the tty.
-	 */
-
-	retval = tty_ldisc_halt(tty, o_tty, 5 * HZ);
-
-	/*
-	 * Wait for hangup to complete, if pending.
-	 * We must drop the mutex here in case a hangup is also in process.
-	 */
-
-	mutex_unlock(&tty->ldisc_mutex);
-
-	flush_work(&tty->hangup_work);
-
 	tty_lock(tty);
-	mutex_lock(&tty->ldisc_mutex);
 
-	/* handle wait idle failure locked */
-	if (retval) {
-		tty_ldisc_put(new_ldisc);
-		goto enable;
-	}
+	/* FIXME: for testing only */
+	WARN_ON(test_bit(TTY_HUPPED, &tty->flags));
 
 	if (test_bit(TTY_HUPPING, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
-		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
-		mutex_unlock(&tty->ldisc_mutex);
+		tty_ldisc_enable_pair(tty, o_tty);
 		tty_ldisc_put(new_ldisc);
 		tty_unlock(tty);
 		return -EIO;
@@ -804,14 +578,10 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_ldisc_put(o_ldisc);
 
-enable:
 	/*
 	 *	Allow ldisc referencing to occur again
 	 */
-
-	tty_ldisc_enable(tty);
-	if (o_tty)
-		tty_ldisc_enable(o_tty);
+	tty_ldisc_enable_pair(tty, o_tty);
 
 	/* Restart the work queue in case no characters kick it off. Safe if
 	   already running */
@@ -819,7 +589,6 @@ enable:
 	if (o_tty)
 		schedule_work(&o_tty->port->buf.work);
 
-	mutex_unlock(&tty->ldisc_mutex);
 	tty_unlock(tty);
 	return retval;
 }
@@ -852,7 +621,7 @@ static void tty_reset_termios(struct tty_struct *tty)
 
 static int tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 {
-	struct tty_ldisc *ld = tty_ldisc_get(ldisc);
+	struct tty_ldisc *ld = tty_ldisc_get(tty, ldisc);
 
 	if (IS_ERR(ld))
 		return -1;
@@ -891,14 +660,8 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 
 	tty_ldisc_debug(tty, "closing ldisc: %p\n", tty->ldisc);
 
-	/*
-	 * FIXME! What are the locking issues here? This may me overdoing
-	 * things... This question is especially important now that we've
-	 * removed the irqlock.
-	 */
 	ld = tty_ldisc_ref(tty);
 	if (ld != NULL) {
-		/* We may have no line discipline at this point */
 		if (ld->ops->flush_buffer)
 			ld->ops->flush_buffer(tty);
 		tty_driver_flush_buffer(tty);
@@ -909,21 +672,22 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 			ld->ops->hangup(tty);
 		tty_ldisc_deref(ld);
 	}
-	/*
-	 * FIXME: Once we trust the LDISC code better we can wait here for
-	 * ldisc completion and fix the driver call race
-	 */
+
 	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
 	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
+
+	tty_unlock(tty);
+
 	/*
 	 * Shutdown the current line discipline, and reset it to
 	 * N_TTY if need be.
 	 *
 	 * Avoid racing set_ldisc or tty_ldisc_release
 	 */
-	mutex_lock(&tty->ldisc_mutex);
+	tty_ldisc_lock_pair(tty, tty->link);
+	tty_lock(tty);
 
-	if (tty_ldisc_hangup_halt(tty)) {
+	if (tty->ldisc) {
 
 		/* At this point we have a halted ldisc; we want to close it and
 		   reopen a new ldisc. We could defer the reopen to the next
@@ -942,9 +706,8 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 			BUG_ON(tty_ldisc_reinit(tty, N_TTY));
 			WARN_ON(tty_ldisc_open(tty, tty->ldisc));
 		}
-		tty_ldisc_enable(tty);
 	}
-	mutex_unlock(&tty->ldisc_mutex);
+	tty_ldisc_enable_pair(tty, tty->link);
 	if (reset)
 		tty_reset_termios(tty);
 
@@ -976,15 +739,12 @@ int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty)
 			tty_ldisc_close(tty, ld);
 			return retval;
 		}
-		tty_ldisc_enable(o_tty);
 	}
-	tty_ldisc_enable(tty);
 	return 0;
 }
 
 static void tty_ldisc_kill(struct tty_struct *tty)
 {
-	mutex_lock(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
 	 */
@@ -995,7 +755,6 @@ static void tty_ldisc_kill(struct tty_struct *tty)
 
 	/* Ensure the next open requests the N_TTY ldisc */
 	tty_set_termios_ldisc(tty, N_TTY);
-	mutex_unlock(&tty->ldisc_mutex);
 }
 
 /**
@@ -1017,15 +776,16 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 
 	tty_ldisc_debug(tty, "closing ldisc: %p\n", tty->ldisc);
 
-	tty_ldisc_halt(tty, o_tty, MAX_SCHEDULE_TIMEOUT);
-
+	tty_ldisc_lock_pair(tty, o_tty);
 	tty_lock_pair(tty, o_tty);
-	/* This will need doing differently if we need to lock */
+
 	tty_ldisc_kill(tty);
 	if (o_tty)
 		tty_ldisc_kill(o_tty);
 
 	tty_unlock_pair(tty, o_tty);
+	tty_ldisc_unlock_pair(tty, o_tty);
+
 	/* And the memory resources remaining (buffers, termios) will be
 	   disposed of when the kref hits zero */
 
@@ -1042,7 +802,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 
 void tty_ldisc_init(struct tty_struct *tty)
 {
-	struct tty_ldisc *ld = tty_ldisc_get(N_TTY);
+	struct tty_ldisc *ld = tty_ldisc_get(tty, N_TTY);
 	if (IS_ERR(ld))
 		panic("n_tty: init_tty");
 	tty->ldisc = ld;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index bfa6fca..2c109a3 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -238,7 +238,7 @@ struct tty_struct {
 	int index;
 
 	/* Protects ldisc changes: Lock tty not pty */
-	struct mutex ldisc_mutex;
+	struct ld_semaphore ldisc_sem;
 	struct tty_ldisc *ldisc;
 
 	struct mutex atomic_write_lock;
@@ -306,8 +306,6 @@ struct tty_file_private {
 #define TTY_DO_WRITE_WAKEUP 	5	/* Call write_wakeup after queuing new */
 #define TTY_PUSH 		6	/* n_tty private */
 #define TTY_CLOSING 		7	/* ->close() in progress */
-#define TTY_LDISC 		9	/* Line discipline attached */
-#define TTY_LDISC_CHANGING 	10	/* Line discipline changing */
 #define TTY_LDISC_OPEN	 	11	/* Line discipline is open */
 #define TTY_HW_COOK_OUT 	14	/* Hardware can do output cooking */
 #define TTY_HW_COOK_IN 		15	/* Hardware can do input cooking */
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index bbefe71..a8c58c2 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -198,8 +198,7 @@ struct tty_ldisc_ops {
 
 struct tty_ldisc {
 	struct tty_ldisc_ops *ops;
-	atomic_t users;
-	wait_queue_head_t wq_idle;
+	struct tty_struct *tty;
 };
 
 #define TTY_LDISC_MAGIC	0x5403
-- 
1.8.1.2

