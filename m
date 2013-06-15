Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3FONRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:17:23 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42765 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab3FONPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:15:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 03/24] tty: Make ldisc input flow control concurrency-friendly
Date: Sat, 15 Jun 2013 09:14:15 -0400
Message-Id: <1371302076-4688-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although line discipline receiving is single-producer/single-consumer,
using tty->receive_room to manage flow control creates unnecessary
critical regions requiring additional lock use.

Instead, introduce the optional .receive_buf2() ldisc method which
returns the # of bytes actually received. Serialization is guaranteed
by the caller.

In turn, the line discipline should schedule the buffer work item
whenever space becomes available; ie., when there is room to receive
data and receive_room() previously returned 0 (the buffer work
item stops processing if receive_buf2() returns 0). Note the
'no room' state need not be atomic despite concurrent use by two
threads because only the buffer work thread can set the state and
only the read() thread can clear the state.

Add n_tty_receive_buf2() as the receive_buf2() method for N_TTY.
Provide a public helper function, tty_ldisc_receive_buf(), to use
when directly accessing the receive_buf() methods.

Line disciplines not using input flow control can continue to set
tty->receive_room to a fixed value and only provide the receive_buf()
method.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c        | 72 +++++++++++++++++++++++++++++-----------------
 drivers/tty/tty_buffer.c   | 13 ++++++---
 drivers/tty/vt/selection.c |  4 +--
 include/linux/tty.h        | 13 +++++++++
 include/linux/tty_ldisc.h  | 13 +++++++++
 5 files changed, 82 insertions(+), 33 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4bf0fc0..eddeb78 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -79,6 +79,9 @@ struct n_tty_data {
 	unsigned long overrun_time;
 	int num_overrun;
 
+	/* non-atomic */
+	bool no_room;
+
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
 	unsigned char echo_overrun:1;
 
@@ -114,25 +117,10 @@ static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 	return put_user(x, ptr);
 }
 
-/**
- *	n_tty_set_room	-	receive space
- *	@tty: terminal
- *
- *	Updates tty->receive_room to reflect the currently available space
- *	in the input buffer, and re-schedules the flip buffer work if space
- *	just became available.
- *
- *	Locks: Concurrent update is protected with read_lock
- */
-
-static int set_room(struct tty_struct *tty)
+static int receive_room(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int left;
-	int old_left;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ldata->read_lock, flags);
 
 	if (I_PARMRK(tty)) {
 		/* Multiply read_cnt by 3, since each byte might take up to
@@ -150,18 +138,27 @@ static int set_room(struct tty_struct *tty)
 	 */
 	if (left <= 0)
 		left = ldata->icanon && !ldata->canon_data;
-	old_left = tty->receive_room;
-	tty->receive_room = left;
 
-	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
-
-	return left && !old_left;
+	return left;
 }
 
+/**
+ *	n_tty_set_room	-	receive space
+ *	@tty: terminal
+ *
+ *	Re-schedules the flip buffer work if space just became available.
+ *
+ *	Locks: Concurrent update is protected with read_lock
+ */
+
 static void n_tty_set_room(struct tty_struct *tty)
 {
+	struct n_tty_data *ldata = tty->disc_data;
+
 	/* Did this open up the receive buffer? We may need to flip */
-	if (set_room(tty)) {
+	if (unlikely(ldata->no_room) && receive_room(tty)) {
+		ldata->no_room = 0;
+
 		WARN_RATELIMIT(tty->port->itty == NULL,
 				"scheduling with invalid itty\n");
 		/* see if ldisc has been killed - if so, this means that
@@ -1408,8 +1405,8 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
  *	calls one at a time and in order (or using flush_to_ldisc)
  */
 
-static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
-			      char *fp, int count)
+static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
+			  char *fp, int count)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	const unsigned char *p;
@@ -1464,8 +1461,6 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			tty->ops->flush_chars(tty);
 	}
 
-	set_room(tty);
-
 	if ((!ldata->icanon && (ldata->read_cnt >= ldata->minimum_to_wake)) ||
 		L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
@@ -1480,7 +1475,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	 */
 	while (1) {
 		tty_set_flow_change(tty, TTY_THROTTLE_SAFE);
-		if (tty->receive_room >= TTY_THRESHOLD_THROTTLE)
+		if (receive_room(tty) >= TTY_THRESHOLD_THROTTLE)
 			break;
 		if (!tty_throttle_safe(tty))
 			break;
@@ -1488,6 +1483,28 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	__tty_set_flow_change(tty, 0);
 }
 
+static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
+			      char *fp, int count)
+{
+	__receive_buf(tty, cp, fp, count);
+}
+
+static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
+			      char *fp, int count)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+	int room;
+
+	tty->receive_room = room = receive_room(tty);
+	if (!room)
+		ldata->no_room = 1;
+	count = min(count, room);
+	if (count)
+		__receive_buf(tty, cp, fp, count);
+
+	return count;
+}
+
 int is_ignored(int sig)
 {
 	return (sigismember(&current->blocked, sig) ||
@@ -2203,6 +2220,7 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup,
 	.fasync		 = n_tty_fasync,
+	.receive_buf2	 = n_tty_receive_buf2,
 };
 
 /**
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 6c7a1d0..ff1b2e3 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -407,11 +407,16 @@ static int
 receive_buf(struct tty_struct *tty, struct tty_buffer *head, int count)
 {
 	struct tty_ldisc *disc = tty->ldisc;
+	char 	      *p = head->char_buf_ptr + head->read;
+	unsigned char *f = head->flag_buf_ptr + head->read;
 
-	count = min_t(int, count, tty->receive_room);
-	if (count)
-		disc->ops->receive_buf(tty, head->char_buf_ptr + head->read,
-				       head->flag_buf_ptr + head->read, count);
+	if (disc->ops->receive_buf2)
+		count = disc->ops->receive_buf2(tty, p, f, count);
+	else {
+		count = min_t(int, count, tty->receive_room);
+		if (count)
+			disc->ops->receive_buf(tty, p, f, count);
+	}
 	head->read += count;
 	return count;
 }
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 60b7b69..2ca8d6b 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -356,8 +356,8 @@ int paste_selection(struct tty_struct *tty)
 			continue;
 		}
 		count = sel_buffer_lth - pasted;
-		count = min(count, tty->receive_room);
-		ld->ops->receive_buf(tty, sel_buffer + pasted, NULL, count);
+		count = tty_ldisc_receive_buf(ld, sel_buffer + pasted, NULL,
+					      count);
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 7269daf..8323ee4 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -557,6 +557,19 @@ extern void tty_ldisc_init(struct tty_struct *tty);
 extern void tty_ldisc_deinit(struct tty_struct *tty);
 extern void tty_ldisc_begin(void);
 
+static inline int tty_ldisc_receive_buf(struct tty_ldisc *ld, unsigned char *p,
+					char *f, int count)
+{
+	if (ld->ops->receive_buf2)
+		count = ld->ops->receive_buf2(ld->tty, p, f, count);
+	else {
+		count = min_t(int, count, ld->tty->receive_room);
+		if (count)
+			ld->ops->receive_buf(ld->tty, p, f, count);
+	}
+	return count;
+}
+
 
 /* n_tty.c */
 extern struct tty_ldisc_ops tty_ldisc_N_TTY;
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 23bdd9d..f15c898 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -109,6 +109,17 @@
  *
  *	Tells the discipline that the DCD pin has changed its status.
  *	Used exclusively by the N_PPS (Pulse-Per-Second) line discipline.
+ *
+ * int	(*receive_buf2)(struct tty_struct *, const unsigned char *cp,
+ *			char *fp, int count);
+ *
+ *	This function is called by the low-level tty driver to send
+ *	characters received by the hardware to the line discpline for
+ *	processing.  <cp> is a pointer to the buffer of input
+ *	character received by the device.  <fp> is a pointer to a
+ *	pointer of flag bytes which indicate whether a character was
+ *	received with a parity error, etc.
+ *	If assigned, prefer this function for automatic flow control.
  */
 
 #include <linux/fs.h>
@@ -195,6 +206,8 @@ struct tty_ldisc_ops {
 	void	(*write_wakeup)(struct tty_struct *);
 	void	(*dcd_change)(struct tty_struct *, unsigned int);
 	void	(*fasync)(struct tty_struct *tty, int on);
+	int	(*receive_buf2)(struct tty_struct *, const unsigned char *cp,
+				char *fp, int count);
 
 	struct  module *owner;
 
-- 
1.8.1.2

