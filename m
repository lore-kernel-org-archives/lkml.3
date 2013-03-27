Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3C0Luh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:50:37 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54541 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab3C0LsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:48:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Min Zhang <mzhang@mvista.com>, Ilya Zykov <linux@izyk.ru>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 11/18] tty: Convert termios_mutex to termios_rwsem
Date: Wed, 27 Mar 2013 07:44:01 -0400
Message-Id: <1364384648-6636-12-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

termios is commonly accessed unsafely (especially by N_TTY)
because the existing mutex forces exclusive access.
Convert existing usage.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/net/irda/irtty-sir.c |  8 ++--
 drivers/tty/n_tty.c          |  2 +-
 drivers/tty/pty.c            |  4 +-
 drivers/tty/tty_io.c         | 14 +++----
 drivers/tty/tty_ioctl.c      | 90 ++++++++++++++++++++++----------------------
 drivers/tty/tty_ldisc.c      | 10 ++---
 drivers/tty/vt/vt.c          |  4 +-
 include/linux/tty.h          |  7 ++--
 8 files changed, 70 insertions(+), 69 deletions(-)

diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index a412671..177441a 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -123,14 +123,14 @@ static int irtty_change_speed(struct sir_dev *dev, unsigned speed)
 
 	tty = priv->tty;
 
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	old_termios = tty->termios;
 	cflag = tty->termios.c_cflag;
 	tty_encode_baud_rate(tty, speed, speed);
 	if (tty->ops->set_termios)
 		tty->ops->set_termios(tty, &old_termios);
 	priv->io.speed = speed;
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 
 	return 0;
 }
@@ -280,7 +280,7 @@ static inline void irtty_stop_receiver(struct tty_struct *tty, int stop)
 	struct ktermios old_termios;
 	int cflag;
 
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	old_termios = tty->termios;
 	cflag = tty->termios.c_cflag;
 	
@@ -292,7 +292,7 @@ static inline void irtty_stop_receiver(struct tty_struct *tty, int stop)
 	tty->termios.c_cflag = cflag;
 	if (tty->ops->set_termios)
 		tty->ops->set_termios(tty, &old_termios);
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 }
 
 /*****************************************************************/
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f777ec6..fa463a9 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1540,7 +1540,7 @@ int is_ignored(int sig)
  *	guaranteed that this function will not be re-entered or in progress
  *	when the ldisc is closed.
  *
- *	Locking: Caller holds tty->termios_mutex
+ *	Locking: Caller holds tty->termios_rwsem
  */
 
 static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index c24b4db..50bec0d 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -290,7 +290,7 @@ static int pty_resize(struct tty_struct *tty,  struct winsize *ws)
 	struct tty_struct *pty = tty->link;
 
 	/* For a PTY we need to lock the tty side */
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
 
@@ -317,7 +317,7 @@ static int pty_resize(struct tty_struct *tty,  struct winsize *ws)
 	tty->winsize = *ws;
 	pty->winsize = *ws;	/* Never used so will go away soon */
 done:
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 	return 0;
 }
 
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 9dcb2ce..30201e6 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -550,7 +550,7 @@ EXPORT_SYMBOL_GPL(tty_wakeup);
  *		  redirect lock for undoing redirection
  *		  file list lock for manipulating list of ttys
  *		  tty_ldisc_lock from called functions
- *		  termios_mutex resetting termios data
+ *		  termios_rwsem resetting termios data
  *		  tasklist_lock to walk task list for hangup event
  *		    ->siglock to protect ->signal/->sighand
  */
@@ -2166,7 +2166,7 @@ static int tiocsti(struct tty_struct *tty, char __user *p)
  *
  *	Copies the kernel idea of the window size into the user buffer.
  *
- *	Locking: tty->termios_mutex is taken to ensure the winsize data
+ *	Locking: tty->termios_rwsem is taken to ensure the winsize data
  *		is consistent.
  */
 
@@ -2174,9 +2174,9 @@ static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
 {
 	int err;
 
-	mutex_lock(&tty->termios_mutex);
+	down_read(&tty->termios_rwsem);
 	err = copy_to_user(arg, &tty->winsize, sizeof(*arg));
-	mutex_unlock(&tty->termios_mutex);
+	up_read(&tty->termios_rwsem);
 
 	return err ? -EFAULT: 0;
 }
@@ -2197,7 +2197,7 @@ int tty_do_resize(struct tty_struct *tty, struct winsize *ws)
 	unsigned long flags;
 
 	/* Lock the tty */
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
 	/* Get the PID values and reference them so we can
@@ -2212,7 +2212,7 @@ int tty_do_resize(struct tty_struct *tty, struct winsize *ws)
 
 	tty->winsize = *ws;
 done:
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 	return 0;
 }
 EXPORT_SYMBOL(tty_do_resize);
@@ -2951,7 +2951,7 @@ void initialize_tty_struct(struct tty_struct *tty,
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	mutex_init(&tty->legacy_mutex);
-	mutex_init(&tty->termios_mutex);
+	init_rwsem(&tty->termios_rwsem);
 	init_ldsem(&tty->ldisc_sem);
 	init_waitqueue_head(&tty->write_wait);
 	init_waitqueue_head(&tty->read_wait);
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 2febed5..490e499 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -94,20 +94,20 @@ EXPORT_SYMBOL(tty_driver_flush_buffer);
  *	@tty: terminal
  *
  *	Indicate that a tty should stop transmitting data down the stack.
- *	Takes the termios mutex to protect against parallel throttle/unthrottle
+ *	Takes the termios rwsem to protect against parallel throttle/unthrottle
  *	and also to ensure the driver can consistently reference its own
  *	termios data at this point when implementing software flow control.
  */
 
 void tty_throttle(struct tty_struct *tty)
 {
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	/* check TTY_THROTTLED first so it indicates our state */
 	if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
 	    tty->ops->throttle)
 		tty->ops->throttle(tty);
 	tty->flow_change = 0;
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 }
 EXPORT_SYMBOL(tty_throttle);
 
@@ -116,7 +116,7 @@ EXPORT_SYMBOL(tty_throttle);
  *	@tty: terminal
  *
  *	Indicate that a tty may continue transmitting data down the stack.
- *	Takes the termios mutex to protect against parallel throttle/unthrottle
+ *	Takes the termios rwsem to protect against parallel throttle/unthrottle
  *	and also to ensure the driver can consistently reference its own
  *	termios data at this point when implementing software flow control.
  *
@@ -126,12 +126,12 @@ EXPORT_SYMBOL(tty_throttle);
 
 void tty_unthrottle(struct tty_struct *tty)
 {
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
 	    tty->ops->unthrottle)
 		tty->ops->unthrottle(tty);
 	tty->flow_change = 0;
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 }
 EXPORT_SYMBOL(tty_unthrottle);
 
@@ -151,7 +151,7 @@ int tty_throttle_safe(struct tty_struct *tty)
 {
 	int ret = 0;
 
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	if (!test_bit(TTY_THROTTLED, &tty->flags)) {
 		if (tty->flow_change != TTY_THROTTLE_SAFE)
 			ret = 1;
@@ -161,7 +161,7 @@ int tty_throttle_safe(struct tty_struct *tty)
 				tty->ops->throttle(tty);
 		}
 	}
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 
 	return ret;
 }
@@ -182,7 +182,7 @@ int tty_unthrottle_safe(struct tty_struct *tty)
 {
 	int ret = 0;
 
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	if (test_bit(TTY_THROTTLED, &tty->flags)) {
 		if (tty->flow_change != TTY_UNTHROTTLE_SAFE)
 			ret = 1;
@@ -192,7 +192,7 @@ int tty_unthrottle_safe(struct tty_struct *tty)
 				tty->ops->unthrottle(tty);
 		}
 	}
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 
 	return ret;
 }
@@ -468,7 +468,7 @@ EXPORT_SYMBOL_GPL(tty_termios_encode_baud_rate);
  *	@obad: output baud rate
  *
  *	Update the current termios data for the tty with the new speed
- *	settings. The caller must hold the termios_mutex for the tty in
+ *	settings. The caller must hold the termios_rwsem for the tty in
  *	question.
  */
 
@@ -556,7 +556,7 @@ EXPORT_SYMBOL(tty_termios_hw_change);
  *	is a bit of layering violation here with n_tty in terms of the
  *	internal knowledge of this function.
  *
- *	Locking: termios_mutex
+ *	Locking: termios_rwsem
  */
 
 int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
@@ -572,7 +572,7 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 
 	/* FIXME: we need to decide on some locking/ordering semantics
 	   for the set_termios notification eventually */
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	old_termios = tty->termios;
 	tty->termios = *new_termios;
 	unset_locked_termios(&tty->termios, &old_termios, &tty->termios_locked);
@@ -614,7 +614,7 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 			(ld->ops->set_termios)(tty, &old_termios);
 		tty_ldisc_deref(ld);
 	}
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tty_set_termios);
@@ -629,7 +629,7 @@ EXPORT_SYMBOL_GPL(tty_set_termios);
  *	functions before using tty_set_termios to do the actual changes.
  *
  *	Locking:
- *		Called functions take ldisc and termios_mutex locks
+ *		Called functions take ldisc and termios_rwsem locks
  */
 
 static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
@@ -641,9 +641,9 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 	if (retval)
 		return retval;
 
-	mutex_lock(&tty->termios_mutex);
+	down_read(&tty->termios_rwsem);
 	tmp_termios = tty->termios;
-	mutex_unlock(&tty->termios_mutex);
+	up_read(&tty->termios_rwsem);
 
 	if (opt & TERMIOS_TERMIO) {
 		if (user_termio_to_kernel_termios(&tmp_termios,
@@ -695,16 +695,16 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 
 static void copy_termios(struct tty_struct *tty, struct ktermios *kterm)
 {
-	mutex_lock(&tty->termios_mutex);
+	down_read(&tty->termios_rwsem);
 	*kterm = tty->termios;
-	mutex_unlock(&tty->termios_mutex);
+	up_read(&tty->termios_rwsem);
 }
 
 static void copy_termios_locked(struct tty_struct *tty, struct ktermios *kterm)
 {
-	mutex_lock(&tty->termios_mutex);
+	down_read(&tty->termios_rwsem);
 	*kterm = tty->termios_locked;
-	mutex_unlock(&tty->termios_mutex);
+	up_read(&tty->termios_rwsem);
 }
 
 static int get_termio(struct tty_struct *tty, struct termio __user *termio)
@@ -751,10 +751,10 @@ static int set_termiox(struct tty_struct *tty, void __user *arg, int opt)
 			return -ERESTARTSYS;
 	}
 
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	if (tty->ops->set_termiox)
 		tty->ops->set_termiox(tty, &tnew);
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 	return 0;
 }
 
@@ -789,13 +789,13 @@ static int get_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 {
 	struct sgttyb tmp;
 
-	mutex_lock(&tty->termios_mutex);
+	down_read(&tty->termios_rwsem);
 	tmp.sg_ispeed = tty->termios.c_ispeed;
 	tmp.sg_ospeed = tty->termios.c_ospeed;
 	tmp.sg_erase = tty->termios.c_cc[VERASE];
 	tmp.sg_kill = tty->termios.c_cc[VKILL];
 	tmp.sg_flags = get_sgflags(tty);
-	mutex_unlock(&tty->termios_mutex);
+	up_read(&tty->termios_rwsem);
 
 	return copy_to_user(sgttyb, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
@@ -834,7 +834,7 @@ static void set_sgflags(struct ktermios *termios, int flags)
  *	Updates a terminal from the legacy BSD style terminal information
  *	structure.
  *
- *	Locking: termios_mutex
+ *	Locking: termios_rwsem
  */
 
 static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
@@ -850,7 +850,7 @@ static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 	if (copy_from_user(&tmp, sgttyb, sizeof(tmp)))
 		return -EFAULT;
 
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	termios = tty->termios;
 	termios.c_cc[VERASE] = tmp.sg_erase;
 	termios.c_cc[VKILL] = tmp.sg_kill;
@@ -860,7 +860,7 @@ static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 	tty_termios_encode_baud_rate(&termios, termios.c_ispeed,
 						termios.c_ospeed);
 #endif
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 	tty_set_termios(tty, &termios);
 	return 0;
 }
@@ -871,14 +871,14 @@ static int get_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 {
 	struct tchars tmp;
 
-	mutex_lock(&tty->termios_mutex);
+	down_read(&tty->termios_rwsem);
 	tmp.t_intrc = tty->termios.c_cc[VINTR];
 	tmp.t_quitc = tty->termios.c_cc[VQUIT];
 	tmp.t_startc = tty->termios.c_cc[VSTART];
 	tmp.t_stopc = tty->termios.c_cc[VSTOP];
 	tmp.t_eofc = tty->termios.c_cc[VEOF];
 	tmp.t_brkc = tty->termios.c_cc[VEOL2];	/* what is brkc anyway? */
-	mutex_unlock(&tty->termios_mutex);
+	up_read(&tty->termios_rwsem);
 	return copy_to_user(tchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
@@ -888,14 +888,14 @@ static int set_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 
 	if (copy_from_user(&tmp, tchars, sizeof(tmp)))
 		return -EFAULT;
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	tty->termios.c_cc[VINTR] = tmp.t_intrc;
 	tty->termios.c_cc[VQUIT] = tmp.t_quitc;
 	tty->termios.c_cc[VSTART] = tmp.t_startc;
 	tty->termios.c_cc[VSTOP] = tmp.t_stopc;
 	tty->termios.c_cc[VEOF] = tmp.t_eofc;
 	tty->termios.c_cc[VEOL2] = tmp.t_brkc;	/* what is brkc anyway? */
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 	return 0;
 }
 #endif
@@ -905,7 +905,7 @@ static int get_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 {
 	struct ltchars tmp;
 
-	mutex_lock(&tty->termios_mutex);
+	down_read(&tty->termios_rwsem);
 	tmp.t_suspc = tty->termios.c_cc[VSUSP];
 	/* what is dsuspc anyway? */
 	tmp.t_dsuspc = tty->termios.c_cc[VSUSP];
@@ -914,7 +914,7 @@ static int get_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 	tmp.t_flushc = tty->termios.c_cc[VEOL2];
 	tmp.t_werasc = tty->termios.c_cc[VWERASE];
 	tmp.t_lnextc = tty->termios.c_cc[VLNEXT];
-	mutex_unlock(&tty->termios_mutex);
+	up_read(&tty->termios_rwsem);
 	return copy_to_user(ltchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
@@ -925,7 +925,7 @@ static int set_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 	if (copy_from_user(&tmp, ltchars, sizeof(tmp)))
 		return -EFAULT;
 
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	tty->termios.c_cc[VSUSP] = tmp.t_suspc;
 	/* what is dsuspc anyway? */
 	tty->termios.c_cc[VEOL2] = tmp.t_dsuspc;
@@ -934,7 +934,7 @@ static int set_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 	tty->termios.c_cc[VEOL2] = tmp.t_flushc;
 	tty->termios.c_cc[VWERASE] = tmp.t_werasc;
 	tty->termios.c_cc[VLNEXT] = tmp.t_lnextc;
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 	return 0;
 }
 #endif
@@ -974,7 +974,7 @@ static int send_prio_char(struct tty_struct *tty, char ch)
  *	@arg: enable/disable CLOCAL
  *
  *	Perform a change to the CLOCAL state and call into the driver
- *	layer to make it visible. All done with the termios mutex
+ *	layer to make it visible. All done with the termios rwsem
  */
 
 static int tty_change_softcar(struct tty_struct *tty, int arg)
@@ -983,7 +983,7 @@ static int tty_change_softcar(struct tty_struct *tty, int arg)
 	int bit = arg ? CLOCAL : 0;
 	struct ktermios old;
 
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	old = tty->termios;
 	tty->termios.c_cflag &= ~CLOCAL;
 	tty->termios.c_cflag |= bit;
@@ -991,7 +991,7 @@ static int tty_change_softcar(struct tty_struct *tty, int arg)
 		tty->ops->set_termios(tty, &old);
 	if ((tty->termios.c_cflag & CLOCAL) != bit)
 		ret = -EINVAL;
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 	return ret;
 }
 
@@ -1094,9 +1094,9 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		if (user_termios_to_kernel_termios(&kterm,
 					       (struct termios __user *) arg))
 			return -EFAULT;
-		mutex_lock(&real_tty->termios_mutex);
+		down_write(&real_tty->termios_rwsem);
 		real_tty->termios_locked = kterm;
-		mutex_unlock(&real_tty->termios_mutex);
+		up_write(&real_tty->termios_rwsem);
 		return 0;
 #else
 	case TIOCGLCKTRMIOS:
@@ -1111,9 +1111,9 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		if (user_termios_to_kernel_termios_1(&kterm,
 					       (struct termios __user *) arg))
 			return -EFAULT;
-		mutex_lock(&real_tty->termios_mutex);
+		down_write(&real_tty->termios_rwsem);
 		real_tty->termios_locked = kterm;
-		mutex_unlock(&real_tty->termios_mutex);
+		up_write(&real_tty->termios_rwsem);
 		return ret;
 #endif
 #ifdef TCGETX
@@ -1121,9 +1121,9 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		struct termiox ktermx;
 		if (real_tty->termiox == NULL)
 			return -EINVAL;
-		mutex_lock(&real_tty->termios_mutex);
+		down_read(&real_tty->termios_rwsem);
 		memcpy(&ktermx, real_tty->termiox, sizeof(struct termiox));
-		mutex_unlock(&real_tty->termios_mutex);
+		up_read(&real_tty->termios_rwsem);
 		if (copy_to_user(p, &ktermx, sizeof(struct termiox)))
 			ret = -EFAULT;
 		return ret;
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 5a6c43d..d7d5e6a 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -414,14 +414,14 @@ EXPORT_SYMBOL_GPL(tty_ldisc_flush);
  *	they are not on hot paths so a little discipline won't do
  *	any harm.
  *
- *	Locking: takes termios_mutex
+ *	Locking: takes termios_rwsem
  */
 
 static void tty_set_termios_ldisc(struct tty_struct *tty, int num)
 {
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	tty->termios.c_line = num;
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 }
 
 /**
@@ -599,11 +599,11 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 static void tty_reset_termios(struct tty_struct *tty)
 {
-	mutex_lock(&tty->termios_mutex);
+	down_write(&tty->termios_rwsem);
 	tty->termios = tty->driver->init_termios;
 	tty->termios.c_ispeed = tty_termios_input_baud_rate(&tty->termios);
 	tty->termios.c_ospeed = tty_termios_baud_rate(&tty->termios);
-	mutex_unlock(&tty->termios_mutex);
+	up_write(&tty->termios_rwsem);
 }
 
 
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index fbd447b..0829c02 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -829,7 +829,7 @@ static inline int resize_screen(struct vc_data *vc, int width, int height,
  *	If the caller passes a tty structure then update the termios winsize
  *	information and perform any necessary signal handling.
  *
- *	Caller must hold the console semaphore. Takes the termios mutex and
+ *	Caller must hold the console semaphore. Takes the termios rwsem and
  *	ctrl_lock of the tty IFF a tty is passed.
  */
 
@@ -973,7 +973,7 @@ int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int rows)
  *	the actual work.
  *
  *	Takes the console sem and the called methods then take the tty
- *	termios_mutex and the tty ctrl_lock in that order.
+ *	termios_rwsem and the tty ctrl_lock in that order.
  */
 static int vt_resize(struct tty_struct *tty, struct winsize *ws)
 {
diff --git a/include/linux/tty.h b/include/linux/tty.h
index b05fa7f..09a5165 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -10,6 +10,7 @@
 #include <linux/mutex.h>
 #include <linux/tty_flags.h>
 #include <uapi/linux/tty.h>
+#include <linux/rwsem.h>
 
 
 
@@ -243,9 +244,9 @@ struct tty_struct {
 
 	struct mutex atomic_write_lock;
 	struct mutex legacy_mutex;
-	struct mutex termios_mutex;
+	struct rw_semaphore termios_rwsem;
 	spinlock_t ctrl_lock;
-	/* Termios values are protected by the termios mutex */
+	/* Termios values are protected by the termios rwsem */
 	struct ktermios termios, termios_locked;
 	struct termiox *termiox;	/* May be NULL for unsupported */
 	char name[64];
@@ -253,7 +254,7 @@ struct tty_struct {
 	struct pid *session;
 	unsigned long flags;
 	int count;
-	struct winsize winsize;		/* termios mutex */
+	struct winsize winsize;		/* termios rwsem */
 	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
 	unsigned char warned:1;
 	unsigned char ctrl_status;	/* ctrl_lock */
-- 
1.8.1.2

