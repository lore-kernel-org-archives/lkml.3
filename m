Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaL3MGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:06:24 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:55817 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaL3MGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:06:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Christian Riesch <christian.riesch@omicron.at>,
        <stable@vger.kernel.org>
Subject: [PATCH] n_tty: Fix unordered accesses to lockless read buffer
Date: Tue, 30 Dec 2014 07:05:56 -0500
Message-Id: <1419941156-5303-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add commit_head buffer index, which the producer-side publishes
after input processing. This ensures the consumer-side observes
correctly-ordered writes in raw mode (ie., the buffer data is
written before the buffer index is advanced).

Further, remove read_cnt() and expand inline, using ACCESS_ONCE()
on the relevant buffer index; read_tail from the producer-side
and canon_head/commit_head from the consumer-side, or both in shared
paths such as receive_room().

Based on work by Christian Riesch <christian.riesch@omicron.at>

NB: Exclusive access is still guaranteed with termios_rwsem write
lock, eg. by n_tty_set_termios() and in n_tty_ioctl(); in this
circumstance, commit_head is equivalent to read_head.

Cc: Christian Riesch <christian.riesch@omicron.at>
Cc: <stable@vger.kernel.org> # v3.14.x (will need backport to v3.12.x)
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 80 ++++++++++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d2b4967..a618b10 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -90,6 +90,7 @@
 struct n_tty_data {
 	/* producer-published */
 	size_t read_head;
+	size_t commit_head;	/* == read_head when not receiving */
 	size_t canon_head;
 	size_t echo_head;
 	size_t echo_commit;
@@ -127,11 +128,6 @@ struct n_tty_data {
 	struct mutex output_lock;
 };
 
-static inline size_t read_cnt(struct n_tty_data *ldata)
-{
-	return ldata->read_head - ldata->read_tail;
-}
-
 static inline unsigned char read_buf(struct n_tty_data *ldata, size_t i)
 {
 	return ldata->read_buf[i & (N_TTY_BUF_SIZE - 1)];
@@ -164,15 +160,17 @@ static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 static int receive_room(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
+	size_t head = ACCESS_ONCE(ldata->commit_head);
+	size_t tail = ACCESS_ONCE(ldata->read_tail);
 	int left;
 
 	if (I_PARMRK(tty)) {
-		/* Multiply read_cnt by 3, since each byte might take up to
+		/* Multiply count by 3, since each byte might take up to
 		 * three times as many spaces when PARMRK is set (depending on
 		 * its flags, e.g. parity error). */
-		left = N_TTY_BUF_SIZE - read_cnt(ldata) * 3 - 1;
+		left = N_TTY_BUF_SIZE - (head - tail) * 3 - 1;
 	} else
-		left = N_TTY_BUF_SIZE - read_cnt(ldata) - 1;
+		left = N_TTY_BUF_SIZE - (head - tail) - 1;
 
 	/*
 	 * If we are doing input canonicalization, and there are no
@@ -181,7 +179,7 @@ static int receive_room(struct tty_struct *tty)
 	 * characters will be beeped.
 	 */
 	if (left <= 0)
-		left = ldata->icanon && ldata->canon_head == ldata->read_tail;
+		left = ldata->icanon && ACCESS_ONCE(ldata->canon_head) == tail;
 
 	return left;
 }
@@ -224,9 +222,9 @@ static ssize_t chars_in_buffer(struct tty_struct *tty)
 	ssize_t n = 0;
 
 	if (!ldata->icanon)
-		n = read_cnt(ldata);
+		n = ACCESS_ONCE(ldata->commit_head) - ldata->read_tail;
 	else
-		n = ldata->canon_head - ldata->read_tail;
+		n = ACCESS_ONCE(ldata->canon_head) - ldata->read_tail;
 	return n;
 }
 
@@ -313,10 +311,6 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
  *
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
- *		modifies read_head
- *
- *	read_head is only considered 'published' if canonical mode is
- *	not active.
  */
 
 static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
@@ -340,6 +334,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
 {
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
 	ldata->echo_head = ldata->echo_tail = ldata->echo_commit = 0;
+	ldata->commit_head = 0;
 	ldata->echo_mark = 0;
 	ldata->line_start = 0;
 
@@ -987,10 +982,6 @@ static inline void finish_erasing(struct n_tty_data *ldata)
  *
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
- *		modifies read_head
- *
- *	Modifying the read_head is not considered a publish in this context
- *	because canonical mode is active -- only canon_head publishes
  */
 
 static void eraser(unsigned char c, struct tty_struct *tty)
@@ -1139,7 +1130,7 @@ static void isig(int sig, struct tty_struct *tty)
  *
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
- *		publishes read_head via put_tty_queue()
+ *		publishes read_head as commit_head
  *
  *	Note: may get exclusive termios_rwsem if flushing input buffer
  */
@@ -1166,6 +1157,8 @@ static void n_tty_receive_break(struct tty_struct *tty)
 		put_tty_queue('\0', ldata);
 	}
 	put_tty_queue('\0', ldata);
+	/* publish read_head to consumer */
+	smp_store_release(&ldata->commit_head, ldata->read_head);
 	if (waitqueue_active(&tty->read_wait))
 		wake_up_interruptible_poll(&tty->read_wait, POLLIN);
 }
@@ -1209,7 +1202,7 @@ static void n_tty_receive_overrun(struct tty_struct *tty)
  *
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
- *		publishes read_head via put_tty_queue()
+ *		publishes read_head as commit_head
  */
 static void n_tty_receive_parity_error(struct tty_struct *tty, unsigned char c)
 {
@@ -1226,6 +1219,8 @@ static void n_tty_receive_parity_error(struct tty_struct *tty, unsigned char c)
 			put_tty_queue('\0', ldata);
 	} else
 		put_tty_queue(c, ldata);
+	/* publish read_head to consumer */
+	smp_store_release(&ldata->commit_head, ldata->read_head);
 	if (waitqueue_active(&tty->read_wait))
 		wake_up_interruptible_poll(&tty->read_wait, POLLIN);
 }
@@ -1263,7 +1258,6 @@ n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
  *		publishes canon_head if canonical mode is active
- *		otherwise, publishes read_head via put_tty_queue()
  *
  *	Returns 1 if LNEXT was received, else returns 0
  */
@@ -1376,7 +1370,7 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 handle_newline:
 			set_bit(ldata->read_head & (N_TTY_BUF_SIZE - 1), ldata->read_flags);
 			put_tty_queue(c, ldata);
-			ldata->canon_head = ldata->read_head;
+			smp_store_release(&ldata->canon_head, ldata->read_head);
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 			if (waitqueue_active(&tty->read_wait))
 				wake_up_interruptible_poll(&tty->read_wait, POLLIN);
@@ -1526,7 +1520,7 @@ n_tty_receive_char_lnext(struct tty_struct *tty, unsigned char c, char flag)
  *
  *	n_tty_receive_buf()/producer path:
  *		claims non-exclusive termios_rwsem
- *		publishes read_head and canon_head
+ *		publishes canon_head or commit_head
  */
 
 static void
@@ -1534,10 +1528,11 @@ n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
 			   char *fp, int count)
 {
 	struct n_tty_data *ldata = tty->disc_data;
+	size_t tail = ACCESS_ONCE(ldata->read_tail);
 	size_t n, head;
 
 	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
-	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
+	n = N_TTY_BUF_SIZE - max(ldata->read_head - tail, head);
 	n = min_t(size_t, count, n);
 	memcpy(read_buf_addr(ldata, head), cp, n);
 	ldata->read_head += n;
@@ -1545,7 +1540,7 @@ n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
 	count -= n;
 
 	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
-	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
+	n = N_TTY_BUF_SIZE - max(ldata->read_head - tail, head);
 	n = min_t(size_t, count, n);
 	memcpy(read_buf_addr(ldata, head), cp, n);
 	ldata->read_head += n;
@@ -1649,6 +1644,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	bool preops = I_ISTRIP(tty) || (I_IUCLC(tty) && L_IEXTEN(tty));
+	size_t c;
 
 	if (ldata->real_raw)
 		n_tty_receive_buf_real_raw(tty, cp, fp, count);
@@ -1676,8 +1672,11 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			tty->ops->flush_chars(tty);
 	}
 
-	if ((!ldata->icanon && (read_cnt(ldata) >= ldata->minimum_to_wake)) ||
-		L_EXTPROC(tty)) {
+	/* publish read_head to consumer */
+	smp_store_release(&ldata->commit_head, ldata->read_head);
+	c = ldata->read_head - ACCESS_ONCE(ldata->read_tail);
+
+	if ((!ldata->icanon && c >= ldata->minimum_to_wake) || L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 		if (waitqueue_active(&tty->read_wait))
 			wake_up_interruptible_poll(&tty->read_wait, POLLIN);
@@ -1755,13 +1754,13 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 	if (!old || (old->c_lflag ^ tty->termios.c_lflag) & ICANON) {
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
 		ldata->line_start = ldata->read_tail;
-		if (!L_ICANON(tty) || !read_cnt(ldata)) {
+		if (!L_ICANON(tty) || ldata->commit_head == ldata->read_tail) {
 			ldata->canon_head = ldata->read_tail;
 			ldata->push = 0;
 		} else {
-			set_bit((ldata->read_head - 1) & (N_TTY_BUF_SIZE - 1),
+			set_bit((ldata->commit_head - 1) & (N_TTY_BUF_SIZE - 1),
 				ldata->read_flags);
-			ldata->canon_head = ldata->read_head;
+			ldata->canon_head = ldata->commit_head;
 			ldata->push = 1;
 		}
 		ldata->erasing = 0;
@@ -1903,9 +1902,9 @@ static inline int input_available_p(struct tty_struct *tty, int poll)
 	int amt = poll && !TIME_CHAR(tty) && MIN_CHAR(tty) ? MIN_CHAR(tty) : 1;
 
 	if (ldata->icanon && !L_EXTPROC(tty))
-		return ldata->canon_head != ldata->read_tail;
+		return ACCESS_ONCE(ldata->canon_head) != ldata->read_tail;
 	else
-		return read_cnt(ldata) >= amt;
+		return ACCESS_ONCE(ldata->commit_head) - ldata->read_tail >= amt;
 }
 
 /**
@@ -1938,9 +1937,10 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	size_t n;
 	bool is_eof;
 	size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
+	size_t head = smp_load_acquire(&ldata->commit_head);
 
 	retval = 0;
-	n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
+	n = min(head - ldata->read_tail, N_TTY_BUF_SIZE - tail);
 	n = min(*nr, n);
 	if (n) {
 		retval = copy_to_user(*b, read_buf_addr(ldata, tail), n);
@@ -1948,9 +1948,10 @@ static int copy_from_read_buf(struct tty_struct *tty,
 		is_eof = n == 1 && read_buf(ldata, tail) == EOF_CHAR(tty);
 		tty_audit_add_data(tty, read_buf_addr(ldata, tail), n,
 				ldata->icanon);
-		ldata->read_tail += n;
+		smp_store_release(&ldata->read_tail, ldata->read_tail + n);
 		/* Turn single EOF into zero-length read */
-		if (L_EXTPROC(tty) && ldata->icanon && is_eof && !read_cnt(ldata))
+		if (L_EXTPROC(tty) && ldata->icanon && is_eof &&
+		    (head == ldata->read_tail))
 			n = 0;
 		*b += n;
 		*nr -= n;
@@ -1993,7 +1994,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	bool eof_push = 0;
 
 	/* N.B. avoid overrun if nr == 0 */
-	n = min(*nr, read_cnt(ldata));
+	n = min(*nr, smp_load_acquire(&ldata->canon_head) - ldata->read_tail);
 	if (!n)
 		return 0;
 
@@ -2043,8 +2044,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 
 	if (found)
 		clear_bit(eol, ldata->read_flags);
-	smp_mb__after_atomic();
-	ldata->read_tail += c;
+	smp_store_release(&ldata->read_tail, ldata->read_tail + c);
 
 	if (found) {
 		if (!ldata->push)
@@ -2458,7 +2458,7 @@ static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 		if (L_ICANON(tty))
 			retval = inq_canon(ldata);
 		else
-			retval = read_cnt(ldata);
+			retval = ldata->commit_head - ldata->read_tail;
 		up_write(&tty->termios_rwsem);
 		return put_user(retval, (unsigned int __user *) arg);
 	default:
-- 
2.2.1

