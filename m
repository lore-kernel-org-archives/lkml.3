Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3FOLFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:05:48 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:37104 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3FOLFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:05:13 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 1/6] tty: Fix tty_ldisc_lock name collision
Date: Sat, 15 Jun 2013 07:04:46 -0400
Message-Id: <1371294291-3807-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371294291-3807-1-git-send-email-peter@hurleysoftware.com>
References: <20130603192436.GB22733@kroah.com>
 <1371294291-3807-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file scope spinlock identifier, tty_ldisc_lock, will collide
with the file scope lock function tty_ldisc_lock() so rename it.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c    |  4 ++--
 drivers/tty/tty_ldisc.c | 46 +++++++++++++++++++++++-----------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 6464029..e7be3a5 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -603,7 +603,7 @@ static int tty_signal_session_leader(struct tty_struct *tty, int exit_session)
  *		BTM
  *		  redirect lock for undoing redirection
  *		  file list lock for manipulating list of ttys
- *		  tty_ldisc_lock from called functions
+ *		  tty_ldiscs_lock from called functions
  *		  termios_mutex resetting termios data
  *		  tasklist_lock to walk task list for hangup event
  *		    ->siglock to protect ->signal/->sighand
@@ -2199,7 +2199,7 @@ static int tty_fasync(int fd, struct file *filp, int on)
  *	FIXME: does not honour flow control ??
  *
  *	Locking:
- *		Called functions take tty_ldisc_lock
+ *		Called functions take tty_ldiscs_lock
  *		current->signal->tty check is safe without locks
  *
  *	FIXME: may race normal receive processing
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 1afe192..8166260 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -37,7 +37,7 @@
  *	callers who will do ldisc lookups and cannot sleep.
  */
 
-static DEFINE_RAW_SPINLOCK(tty_ldisc_lock);
+static DEFINE_RAW_SPINLOCK(tty_ldiscs_lock);
 static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
 /* Line disc dispatch table */
 static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
@@ -52,7 +52,7 @@ static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
  *	from this point onwards.
  *
  *	Locking:
- *		takes tty_ldisc_lock to guard against ldisc races
+ *		takes tty_ldiscs_lock to guard against ldisc races
  */
 
 int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc)
@@ -63,11 +63,11 @@ int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc)
 	if (disc < N_TTY || disc >= NR_LDISCS)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	tty_ldiscs[disc] = new_ldisc;
 	new_ldisc->num = disc;
 	new_ldisc->refcount = 0;
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 
 	return ret;
 }
@@ -82,7 +82,7 @@ EXPORT_SYMBOL(tty_register_ldisc);
  *	currently in use.
  *
  *	Locking:
- *		takes tty_ldisc_lock to guard against ldisc races
+ *		takes tty_ldiscs_lock to guard against ldisc races
  */
 
 int tty_unregister_ldisc(int disc)
@@ -93,12 +93,12 @@ int tty_unregister_ldisc(int disc)
 	if (disc < N_TTY || disc >= NR_LDISCS)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	if (tty_ldiscs[disc]->refcount)
 		ret = -EBUSY;
 	else
 		tty_ldiscs[disc] = NULL;
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 
 	return ret;
 }
@@ -109,7 +109,7 @@ static struct tty_ldisc_ops *get_ldops(int disc)
 	unsigned long flags;
 	struct tty_ldisc_ops *ldops, *ret;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	ret = ERR_PTR(-EINVAL);
 	ldops = tty_ldiscs[disc];
 	if (ldops) {
@@ -119,7 +119,7 @@ static struct tty_ldisc_ops *get_ldops(int disc)
 			ret = ldops;
 		}
 	}
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 	return ret;
 }
 
@@ -127,10 +127,10 @@ static void put_ldops(struct tty_ldisc_ops *ldops)
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	ldops->refcount--;
 	module_put(ldops->owner);
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 }
 
 /**
@@ -143,7 +143,7 @@ static void put_ldops(struct tty_ldisc_ops *ldops)
  *	available
  *
  *	Locking:
- *		takes tty_ldisc_lock to guard against ldisc races
+ *		takes tty_ldiscs_lock to guard against ldisc races
  */
 
 static struct tty_ldisc *tty_ldisc_get(int disc)
@@ -191,7 +191,7 @@ static inline void tty_ldisc_put(struct tty_ldisc *ld)
 	if (WARN_ON_ONCE(!ld))
 		return;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 
 	/* unreleased reader reference(s) will cause this WARN */
 	WARN_ON(!atomic_dec_and_test(&ld->users));
@@ -199,7 +199,7 @@ static inline void tty_ldisc_put(struct tty_ldisc *ld)
 	ld->ops->refcount--;
 	module_put(ld->ops->owner);
 	kfree(ld);
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 }
 
 static void *tty_ldiscs_seq_start(struct seq_file *m, loff_t *pos)
@@ -259,7 +259,7 @@ const struct file_operations tty_ldiscs_proc_fops = {
  *	used to implement both the waiting and non waiting versions
  *	of tty_ldisc_ref
  *
- *	Locking: takes tty_ldisc_lock
+ *	Locking: takes tty_ldiscs_lock
  */
 
 static struct tty_ldisc *tty_ldisc_try(struct tty_struct *tty)
@@ -268,13 +268,13 @@ static struct tty_ldisc *tty_ldisc_try(struct tty_struct *tty)
 	struct tty_ldisc *ld;
 
 	/* FIXME: this allows reference acquire after TTY_LDISC is cleared */
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	ld = NULL;
 	if (test_bit(TTY_LDISC, &tty->flags) && tty->ldisc) {
 		ld = tty->ldisc;
 		atomic_inc(&ld->users);
 	}
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 	return ld;
 }
 
@@ -291,7 +291,7 @@ static struct tty_ldisc *tty_ldisc_try(struct tty_struct *tty)
  *	against a discipline change, such as an existing ldisc reference
  *	(which we check for)
  *
- *	Locking: call functions take tty_ldisc_lock
+ *	Locking: call functions take tty_ldiscs_lock
  */
 
 struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *tty)
@@ -312,7 +312,7 @@ EXPORT_SYMBOL_GPL(tty_ldisc_ref_wait);
  *	reference to it. If the line discipline is in flux then
  *	return NULL. Can be called from IRQ and timer functions.
  *
- *	Locking: called functions take tty_ldisc_lock
+ *	Locking: called functions take tty_ldiscs_lock
  */
 
 struct tty_ldisc *tty_ldisc_ref(struct tty_struct *tty)
@@ -328,7 +328,7 @@ EXPORT_SYMBOL_GPL(tty_ldisc_ref);
  *	Undoes the effect of tty_ldisc_ref or tty_ldisc_ref_wait. May
  *	be called in IRQ context.
  *
- *	Locking: takes tty_ldisc_lock
+ *	Locking: takes tty_ldiscs_lock
  */
 
 void tty_ldisc_deref(struct tty_ldisc *ld)
@@ -338,13 +338,13 @@ void tty_ldisc_deref(struct tty_ldisc *ld)
 	if (WARN_ON_ONCE(!ld))
 		return;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	/*
 	 * WARNs if one-too-many reader references were released
 	 * - the last reference must be released with tty_ldisc_put
 	 */
 	WARN_ON(atomic_dec_and_test(&ld->users));
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 
 	if (waitqueue_active(&ld->wq_idle))
 		wake_up(&ld->wq_idle);
@@ -593,7 +593,7 @@ static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
  *	overlapping ldisc change (including on the other end of pty pairs),
  *	the close of one side of a tty/pty pair, and eventually hangup.
  *
- *	Locking: takes tty_ldisc_lock, termios_mutex
+ *	Locking: takes tty_ldiscs_lock, termios_mutex
  */
 
 int tty_set_ldisc(struct tty_struct *tty, int ldisc)
-- 
1.8.1.2

