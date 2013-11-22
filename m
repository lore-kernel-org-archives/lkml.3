Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3KVQAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:00:11 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54760 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3KVQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:00:00 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 7/7] n_tty: trace input/read flow control
Date: Fri, 22 Nov 2013 10:59:25 -0500
Message-Id: <1385135965-4235-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrument .receive_buf() and read() paths with trace_printk's
to aid in debugging flow control changes.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 76 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index aae28a6..68fa3a4 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -83,9 +83,14 @@
 
 #undef N_TTY_TRACE
 #ifdef N_TTY_TRACE
-# define n_tty_trace(f, args...)	trace_printk(f, ##args)
+# define n_tty_trace(tty, f, args...)					\
+	do {								\
+		char buf[64];						\
+		trace_printk("[%s] " f, tty_name(tty, buf), ##args);	\
+	} while (0)
 #else
-# define n_tty_trace(f, args...)
+# define n_tty_trace(tty, f, args...)	\
+	do { } while (0)
 #endif
 
 struct n_tty_data {
@@ -179,8 +184,13 @@ static int receive_room(struct tty_struct *tty)
 	 * that erase characters will be handled.  Other excess
 	 * characters will be beeped.
 	 */
-	if (left <= 0)
+	if (left <= 0) {
 		left = ldata->icanon && ldata->canon_head == ldata->read_tail;
+		if (left) {
+			n_tty_trace(tty, "overflow, head:%zu tail:%zu\n",
+				    ldata->read_head, ldata->read_tail);
+		}
+	}
 
 	return left;
 }
@@ -200,11 +210,14 @@ static int receive_room(struct tty_struct *tty)
 static void n_tty_set_room(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
+	int avail;
 
 	/* Did this open up the receive buffer? We may need to flip */
-	if (unlikely(ldata->no_room) && receive_room(tty)) {
+	if (unlikely(ldata->no_room) && (avail = receive_room(tty))) {
 		ldata->no_room = 0;
 
+		n_tty_trace(tty, "restart worker (avail = %d)\n", avail);
+
 		WARN_RATELIMIT(tty->port->itty == NULL,
 				"scheduling with invalid itty\n");
 		/* see if ldisc has been killed - if so, this means that
@@ -240,6 +253,8 @@ static ssize_t chars_in_buffer(struct tty_struct *tty)
 
 static void n_tty_write_wakeup(struct tty_struct *tty)
 {
+	n_tty_trace(tty, "\n");
+
 	if (tty->fasync && test_and_clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags))
 		kill_fasync(&tty->fasync, SIGIO, POLL_OUT);
 }
@@ -254,13 +269,16 @@ static void n_tty_check_throttle(struct tty_struct *tty)
 	 * canonical mode and don't have a newline yet!
 	 */
 	while (1) {
-		int throttled;
+		int throttled, avail;
 		tty_set_flow_change(tty, TTY_THROTTLE_SAFE);
-		if (receive_room(tty) >= TTY_THRESHOLD_THROTTLE)
+		avail = receive_room(tty);
+		if (avail >= TTY_THRESHOLD_THROTTLE)
 			break;
 		throttled = tty_throttle_safe(tty);
-		if (!throttled)
+		if (!throttled) {
+			n_tty_trace(tty, "throttled (avail = %d)/n", avail);
 			break;
+		}
 	}
 	__tty_set_flow_change(tty, 0);
 }
@@ -289,16 +307,19 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
 	 */
 
 	while (1) {
-		int unthrottled;
+		int unthrottled, used;
 		tty_set_flow_change(tty, TTY_UNTHROTTLE_SAFE);
-		if (chars_in_buffer(tty) > TTY_THRESHOLD_UNTHROTTLE)
+		used = chars_in_buffer(tty);
+		if (used > TTY_THRESHOLD_UNTHROTTLE)
 			break;
 		if (!tty->count)
 			break;
 		n_tty_set_room(tty);
 		unthrottled = tty_unthrottle_safe(tty);
-		if (!unthrottled)
+		if (!unthrottled) {
+			n_tty_trace(tty, "unthrottled (used = %d)\n", used);
 			break;
+		}
 	}
 	__tty_set_flow_change(tty, 0);
 }
@@ -374,6 +395,9 @@ static void n_tty_packet_mode_flush(struct tty_struct *tty)
 static void n_tty_flush_buffer(struct tty_struct *tty)
 {
 	down_write(&tty->termios_rwsem);
+
+	n_tty_trace(tty, "\n");
+
 	reset_buffer_flags(tty->disc_data);
 	n_tty_set_room(tty);
 
@@ -770,6 +794,10 @@ static size_t __process_echoes(struct tty_struct *tty)
 	 * of echo overrun before the next commit), then discard enough
 	 * data at the tail to prevent a subsequent overrun */
 	while (ldata->echo_commit - tail >= ECHO_DISCARD_WATERMARK) {
+
+		n_tty_trace(tty, "discard echoes (%zu - %zu > %d)\n",
+			    ldata->echo_commit, tail, ECHO_DISCARD_WATERMARK);
+
 		if (echo_buf(ldata, tail) == ECHO_OP_START) {
 			if (echo_buf(ldata, tail + 1) == ECHO_OP_ERASE_TAB)
 				tail += 3;
@@ -1367,6 +1395,7 @@ handle_newline:
 			set_bit(ldata->read_head & (N_TTY_BUF_SIZE - 1), ldata->read_flags);
 			put_tty_queue(c, ldata);
 			ldata->canon_head = ldata->read_head;
+			n_tty_trace(tty, "canon_head:%zu\n", ldata->canon_head);
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 			if (waitqueue_active(&tty->read_wait))
 				wake_up_interruptible(&tty->read_wait);
@@ -1668,6 +1697,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 
 	if ((!ldata->icanon && (read_cnt(ldata) >= ldata->minimum_to_wake)) ||
 		L_EXTPROC(tty)) {
+		n_tty_trace(tty, "reader wakeup, count:%zd\n", read_cnt(ldata));
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 		if (waitqueue_active(&tty->read_wait))
 			wake_up_interruptible(&tty->read_wait);
@@ -1687,6 +1717,8 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 		room = receive_room(tty);
 		n = min(count, room);
 		if (!n) {
+			if (!room)
+				n_tty_trace(tty, "buffer full\n");
 			if (flow && !room)
 				ldata->no_room = 1;
 			break;
@@ -1703,6 +1735,8 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 	n_tty_check_throttle(tty);
 	up_read(&tty->termios_rwsem);
 
+	n_tty_trace(tty, "rcvd:%d\n", rcvd);
+
 	return rcvd;
 }
 
@@ -1811,6 +1845,8 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 	if (!I_IXON(tty) && old && (old->c_iflag & IXON) && !tty->flow_stopped)
 		start_tty(tty);
 
+	n_tty_trace(tty, "canon:%d\n", ldata->icanon);
+
 	/* The termios change make the tty ready for I/O */
 	if (waitqueue_active(&tty->write_wait))
 		wake_up_interruptible(&tty->write_wait);
@@ -1890,10 +1926,14 @@ static inline int input_available_p(struct tty_struct *tty, int poll)
 	int amt = poll && !TIME_CHAR(tty) ? MIN_CHAR(tty) : 1;
 
 	if (ldata->icanon && !L_EXTPROC(tty)) {
-		if (ldata->canon_head != ldata->read_tail)
+		if (ldata->canon_head != ldata->read_tail) {
+			n_tty_trace(tty, "line avail\n");
 			return 1;
-	} else if (read_cnt(ldata) >= amt)
+		}
+	} else if (read_cnt(ldata) >= amt) {
+		n_tty_trace(tty, "avail:%zu amt:%d\n", read_cnt(ldata), amt);
 		return 1;
+	}
 
 	return 0;
 }
@@ -1984,8 +2024,8 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 	size = min_t(size_t, tail + n, N_TTY_BUF_SIZE);
 
-	n_tty_trace("%s: nr:%zu tail:%zu n:%zu size:%zu\n",
-		    __func__, *nr, tail, n, size);
+	n_tty_trace(tty, "nr:%zu tail:%zu n:%zu size:%zu\n",
+		    *nr, tail, n, size);
 
 	eol = find_next_bit(ldata->read_flags, size, tail);
 	more = n - (size - tail);
@@ -2009,8 +2049,8 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 		eof_push = !n && ldata->read_tail != ldata->line_start;
 	}
 
-	n_tty_trace("%s: eol:%zu found:%d n:%zu c:%zu size:%zu more:%zu\n",
-		    __func__, eol, found, n, c, size, more);
+	n_tty_trace(tty, "eol:%zu found:%d n:%zu c:%zu size:%zu more:%zu\n",
+		    eol, found, n, c, size, more);
 
 	if (n > size) {
 		ret = copy_to_user(*b, read_buf_addr(ldata, tail), size);
@@ -2202,6 +2242,8 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 				n_tty_set_room(tty);
 				up_read(&tty->termios_rwsem);
 
+				n_tty_trace(tty, "blocking\n");
+
 				timeout = schedule_timeout(timeout);
 
 				down_read(&tty->termios_rwsem);
@@ -2259,6 +2301,8 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	if (b - buf)
 		retval = b - buf;
 
+	n_tty_trace(tty, "ret:%zd\n", retval);
+
 	return retval;
 }
 
-- 
1.8.1.2

