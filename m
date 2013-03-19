Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3CSO2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:28:34 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43249 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab3CSO1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:27:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 4/7] n_tty: Encapsulate minimum_to_wake within N_TTY
Date: Tue, 19 Mar 2013 10:26:55 -0400
Message-Id: <1363703218-32333-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130319141017.GB24900@kroah.com>
References: <20130319141017.GB24900@kroah.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minimum_to_wake is unique to N_TTY processing, and belongs in
per-ldisc data.

Add the ldisc method, ldisc_ops::fasync(), to notify line disciplines
when signal-driven I/O is enabled or disabled. When enabled for N_TTY
(by fcntl(F_SETFL, O_ASYNC)), blocking reader/polls will be woken
for any readable input. When disabled, blocking reader/polls are not
woken until the read buffer is full.

Canonical mode (L_ICANON(tty), n_tty_data::icanon) is not affected by
the minimum_to_wake setting.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c       | 39 +++++++++++++++++++++++++++------------
 drivers/tty/tty_io.c      | 17 +++++++++--------
 include/linux/tty.h       |  1 -
 include/linux/tty_ldisc.h |  6 ++++++
 4 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 61797c4..3fd657b 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -89,6 +89,7 @@ struct n_tty_data {
 	int read_head;
 	int read_tail;
 	int read_cnt;
+	int minimum_to_wake;
 
 	unsigned char *echo_buf;
 	unsigned int echo_pos;
@@ -1471,7 +1472,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 
 	n_tty_set_room(tty);
 
-	if ((!ldata->icanon && (ldata->read_cnt >= tty->minimum_to_wake)) ||
+	if ((!ldata->icanon && (ldata->read_cnt >= ldata->minimum_to_wake)) ||
 		L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 		if (waitqueue_active(&tty->read_wait))
@@ -1649,7 +1650,7 @@ static int n_tty_open(struct tty_struct *tty)
 	tty->disc_data = ldata;
 	reset_buffer_flags(tty->disc_data);
 	ldata->column = 0;
-	tty->minimum_to_wake = 1;
+	ldata->minimum_to_wake = 1;
 	tty->closing = 0;
 	/* indicate buffer work may resume */
 	clear_bit(TTY_LDISC_HALTED, &tty->flags);
@@ -1817,17 +1818,17 @@ do_it_again:
 		minimum = MIN_CHAR(tty);
 		if (minimum) {
 			if (time)
-				tty->minimum_to_wake = 1;
+				ldata->minimum_to_wake = 1;
 			else if (!waitqueue_active(&tty->read_wait) ||
-				 (tty->minimum_to_wake > minimum))
-				tty->minimum_to_wake = minimum;
+				 (ldata->minimum_to_wake > minimum))
+				ldata->minimum_to_wake = minimum;
 		} else {
 			timeout = 0;
 			if (time) {
 				timeout = time;
 				time = 0;
 			}
-			tty->minimum_to_wake = minimum = 1;
+			ldata->minimum_to_wake = minimum = 1;
 		}
 	}
 
@@ -1867,9 +1868,9 @@ do_it_again:
 		   TASK_RUNNING. */
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		if (((minimum - (b - buf)) < tty->minimum_to_wake) &&
+		if (((minimum - (b - buf)) < ldata->minimum_to_wake) &&
 		    ((minimum - (b - buf)) >= 1))
-			tty->minimum_to_wake = (minimum - (b - buf));
+			ldata->minimum_to_wake = (minimum - (b - buf));
 
 		if (!input_available_p(tty, 0)) {
 			if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
@@ -1979,7 +1980,7 @@ do_it_again:
 	remove_wait_queue(&tty->read_wait, &wait);
 
 	if (!waitqueue_active(&tty->read_wait))
-		tty->minimum_to_wake = minimum;
+		ldata->minimum_to_wake = minimum;
 
 	__set_current_state(TASK_RUNNING);
 	size = b - buf;
@@ -2111,6 +2112,7 @@ break_out:
 static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
 							poll_table *wait)
 {
+	struct n_tty_data *ldata = tty->disc_data;
 	unsigned int mask = 0;
 
 	poll_wait(file, &tty->read_wait, wait);
@@ -2125,9 +2127,9 @@ static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
 		mask |= POLLHUP;
 	if (!(mask & (POLLHUP | POLLIN | POLLRDNORM))) {
 		if (MIN_CHAR(tty) && !TIME_CHAR(tty))
-			tty->minimum_to_wake = MIN_CHAR(tty);
+			ldata->minimum_to_wake = MIN_CHAR(tty);
 		else
-			tty->minimum_to_wake = 1;
+			ldata->minimum_to_wake = 1;
 	}
 	if (tty->ops->write && !tty_is_writelocked(tty) &&
 			tty_chars_in_buffer(tty) < WAKEUP_CHARS &&
@@ -2175,6 +2177,18 @@ static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 	}
 }
 
+static void n_tty_fasync(struct tty_struct *tty, int on)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+
+	if (!waitqueue_active(&tty->read_wait)) {
+		if (on)
+			ldata->minimum_to_wake = 1;
+		else if (!tty->fasync)
+			ldata->minimum_to_wake = N_TTY_BUF_SIZE;
+	}
+}
+
 struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.magic           = TTY_LDISC_MAGIC,
 	.name            = "n_tty",
@@ -2188,7 +2202,8 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.set_termios     = n_tty_set_termios,
 	.poll            = n_tty_poll,
 	.receive_buf     = n_tty_receive_buf,
-	.write_wakeup    = n_tty_write_wakeup
+	.write_wakeup    = n_tty_write_wakeup,
+	.fasync		 = n_tty_fasync,
 };
 
 /**
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index adc1d01..525c915 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2077,6 +2077,7 @@ static unsigned int tty_poll(struct file *filp, poll_table *wait)
 static int __tty_fasync(int fd, struct file *filp, int on)
 {
 	struct tty_struct *tty = file_tty(filp);
+	struct tty_ldisc *ldisc;
 	unsigned long flags;
 	int retval = 0;
 
@@ -2087,11 +2088,17 @@ static int __tty_fasync(int fd, struct file *filp, int on)
 	if (retval <= 0)
 		goto out;
 
+	ldisc = tty_ldisc_ref(tty);
+	if (ldisc) {
+		if (ldisc->ops->fasync)
+			ldisc->ops->fasync(tty, on);
+		tty_ldisc_deref(ldisc);
+	}
+
 	if (on) {
 		enum pid_type type;
 		struct pid *pid;
-		if (!waitqueue_active(&tty->read_wait))
-			tty->minimum_to_wake = 1;
+
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		if (tty->pgrp) {
 			pid = tty->pgrp;
@@ -2104,13 +2111,7 @@ static int __tty_fasync(int fd, struct file *filp, int on)
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
 		put_pid(pid);
-		if (retval)
-			goto out;
-	} else {
-		if (!tty->fasync && !waitqueue_active(&tty->read_wait))
-			tty->minimum_to_wake = N_TTY_BUF_SIZE;
 	}
-	retval = 0;
 out:
 	return retval;
 }
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 2c109a3..39f0317 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -272,7 +272,6 @@ struct tty_struct {
 #define N_TTY_BUF_SIZE 4096
 
 	unsigned char closing:1;
-	unsigned short minimum_to_wake;
 	unsigned char *write_buf;
 	int write_cnt;
 	/* If the tty has a pending do_SAK, queue it here - akpm */
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 1ef449e..44584d9 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -100,6 +100,11 @@
  *	seek to perform this action quickly but should wait until
  *	any pending driver I/O is completed.
  *
+ * void (*fasync)(struct tty_struct *, int on)
+ *
+ *	Notify line discipline when signal-driven I/O is enabled or
+ *	disabled.
+ *
  * void (*dcd_change)(struct tty_struct *tty, unsigned int status)
  *
  *	Tells the discipline that the DCD pin has changed its status.
@@ -190,6 +195,7 @@ struct tty_ldisc_ops {
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
 	void	(*dcd_change)(struct tty_struct *, unsigned int);
+	void	(*fasync)(struct tty_struct *tty, int on);
 
 	struct  module *owner;
 
-- 
1.8.1.2

