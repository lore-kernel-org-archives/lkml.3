Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbbAMBsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 20:48:05 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57753 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbbAMBsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 20:48:01 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Du <dudenis2000@yahoo.ca>,
        =?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Christian Riesch <christian.riesch@omicron.at>
Subject: [PATCH v2] n_tty: Fix unordered accesses to lockless read buffer
Date: Mon, 12 Jan 2015 20:47:48 -0500
Message-Id: <1421113668-20468-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add commit_head buffer index, which the producer-side publishes
after input processing in non-canon mode. This ensures the consumer-side
observes correctly-ordered writes in non-canonical mode (ie., the buffer
data is written before the buffer index is advanced). Fix consumer-side
uses of read_cnt() to use commit_head instead.

Add required memory barriers to the tail index to guarantee
the consumer-side has completed the loads before the producer-side
begins writing new data. Open-code the producer-side receive_room()
into the i/o loop.

Based on work by Christian Riesch <christian.riesch@omicron.at>

Cc: Christian Riesch <christian.riesch@omicron.at>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---

Changes from v1:
*  Remove read_tail accesses completely from n_tty_receive_buf_real_raw().
   The computation for copy size does not require the read_cnt() since
   count is already <= available buffer space.
*  commit_head is only published in non-canonical mode. The index is
   synced if the mode is changed in n_tty_set_termios. This becomes
   relevant for a follow-on fix that must back up the read_head in
   canon mode.
*  receive_room() in the producer-side i/o loop is open-coded to
   enable smp_load_acquire() of read_tail. (see updated commit log)
*  ACCESS_ONCE()s removed according to my own review of v1. I can
   expand on the analysis of each of those if someone would like.
*  Stuck with the read_head accesses from exclusive access functions
   like n_tty_set_termios() and n_tty_ioctl() (instead of the v1 usage
   of commit_head)

 drivers/tty/n_tty.c | 74 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 31 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4ddfa60..ccc68a5 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -90,6 +90,7 @@
 struct n_tty_data {
 	/* producer-published */
 	size_t read_head;
+	size_t commit_head;
 	size_t canon_head;
 	size_t echo_head;
 	size_t echo_commit;
@@ -164,15 +165,16 @@ static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 static int receive_room(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
+	size_t count = ldata->commit_head - ldata->read_tail;
 	int left;
 
 	if (I_PARMRK(tty)) {
-		/* Multiply read_cnt by 3, since each byte might take up to
+		/* Multiply count by 3, since each byte might take up to
 		 * three times as many spaces when PARMRK is set (depending on
 		 * its flags, e.g. parity error). */
-		left = N_TTY_BUF_SIZE - read_cnt(ldata) * 3 - 1;
+		left = N_TTY_BUF_SIZE - count * 3 - 1;
 	} else
-		left = N_TTY_BUF_SIZE - read_cnt(ldata) - 1;
+		left = N_TTY_BUF_SIZE - count - 1;
 
 	/*
 	 * If we are doing input canonicalization, and there are no
@@ -224,7 +226,7 @@ static ssize_t chars_in_buffer(struct tty_struct *tty)
 	ssize_t n = 0;
 
 	if (!ldata->icanon)
-		n = read_cnt(ldata);
+		n = ldata->commit_head - ldata->read_tail;
 	else
 		n = ldata->canon_head - ldata->read_tail;
 	return n;
@@ -313,10 +315,6 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
  *
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
- *		modifies read_head
- *
- *	read_head is only considered 'published' if canonical mode is
- *	not active.
  */
 
 static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
@@ -340,6 +338,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
 {
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
 	ldata->echo_head = ldata->echo_tail = ldata->echo_commit = 0;
+	ldata->commit_head = 0;
 	ldata->echo_mark = 0;
 	ldata->line_start = 0;
 
@@ -987,10 +986,6 @@ static inline void finish_erasing(struct n_tty_data *ldata)
  *
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
- *		modifies read_head
- *
- *	Modifying the read_head is not considered a publish in this context
- *	because canonical mode is active -- only canon_head publishes
  */
 
 static void eraser(unsigned char c, struct tty_struct *tty)
@@ -1139,7 +1134,6 @@ static void isig(int sig, struct tty_struct *tty)
  *
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
- *		publishes read_head via put_tty_queue()
  *
  *	Note: may get exclusive termios_rwsem if flushing input buffer
  */
@@ -1209,7 +1203,6 @@ static void n_tty_receive_overrun(struct tty_struct *tty)
  *
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
- *		publishes read_head via put_tty_queue()
  */
 static void n_tty_receive_parity_error(struct tty_struct *tty, unsigned char c)
 {
@@ -1263,7 +1256,6 @@ n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
  *	n_tty_receive_buf()/producer path:
  *		caller holds non-exclusive termios_rwsem
  *		publishes canon_head if canonical mode is active
- *		otherwise, publishes read_head via put_tty_queue()
  *
  *	Returns 1 if LNEXT was received, else returns 0
  */
@@ -1376,7 +1368,7 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 handle_newline:
 			set_bit(ldata->read_head & (N_TTY_BUF_SIZE - 1), ldata->read_flags);
 			put_tty_queue(c, ldata);
-			ldata->canon_head = ldata->read_head;
+			smp_store_release(&ldata->canon_head, ldata->read_head);
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 			if (waitqueue_active(&tty->read_wait))
 				wake_up_interruptible_poll(&tty->read_wait, POLLIN);
@@ -1526,7 +1518,7 @@ n_tty_receive_char_lnext(struct tty_struct *tty, unsigned char c, char flag)
  *
  *	n_tty_receive_buf()/producer path:
  *		claims non-exclusive termios_rwsem
- *		publishes read_head and canon_head
+ *		publishes commit_head or canon_head
  */
 
 static void
@@ -1537,16 +1529,14 @@ n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
 	size_t n, head;
 
 	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
-	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
-	n = min_t(size_t, count, n);
+	n = min_t(size_t, count, N_TTY_BUF_SIZE - head);
 	memcpy(read_buf_addr(ldata, head), cp, n);
 	ldata->read_head += n;
 	cp += n;
 	count -= n;
 
 	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
-	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
-	n = min_t(size_t, count, n);
+	n = min_t(size_t, count, N_TTY_BUF_SIZE - head);
 	memcpy(read_buf_addr(ldata, head), cp, n);
 	ldata->read_head += n;
 }
@@ -1676,8 +1666,13 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			tty->ops->flush_chars(tty);
 	}
 
-	if ((!ldata->icanon && (read_cnt(ldata) >= ldata->minimum_to_wake)) ||
-		L_EXTPROC(tty)) {
+	if (ldata->icanon && !L_EXTPROC(tty))
+		return;
+
+	/* publish read_head to consumer */
+	smp_store_release(&ldata->commit_head, ldata->read_head);
+
+	if ((read_cnt(ldata) >= ldata->minimum_to_wake) || L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 		if (waitqueue_active(&tty->read_wait))
 			wake_up_interruptible_poll(&tty->read_wait, POLLIN);
@@ -1694,7 +1689,22 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 	down_read(&tty->termios_rwsem);
 
 	while (1) {
-		room = receive_room(tty);
+		/*
+		 * paired with store in *_copy_from_read_buf() -- guarantees
+		 * the consumer has loaded the data in read_buf up to the new
+		 * read_tail (so this producer will not overwrite unread data)
+		 */
+		size_t tail = smp_load_acquire(&ldata->read_tail);
+		size_t head = ldata->read_head;
+
+		if (I_PARMRK(tty))
+			room = N_TTY_BUF_SIZE - (head - tail) * 3 - 1;
+		else
+			room = N_TTY_BUF_SIZE - (head - tail) - 1;
+
+		if (room <= 0)
+			room = ldata->icanon && ldata->canon_head == tail;
+
 		n = min(count, room);
 		if (!n) {
 			if (flow && !room)
@@ -1764,6 +1774,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 			ldata->canon_head = ldata->read_head;
 			ldata->push = 1;
 		}
+		ldata->commit_head = ldata->read_head;
 		ldata->erasing = 0;
 		ldata->lnext = 0;
 	}
@@ -1905,7 +1916,7 @@ static inline int input_available_p(struct tty_struct *tty, int poll)
 	if (ldata->icanon && !L_EXTPROC(tty))
 		return ldata->canon_head != ldata->read_tail;
 	else
-		return read_cnt(ldata) >= amt;
+		return ldata->commit_head - ldata->read_tail >= amt;
 }
 
 /**
@@ -1937,10 +1948,11 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	int retval;
 	size_t n;
 	bool is_eof;
+	size_t head = smp_load_acquire(&ldata->commit_head);
 	size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 
 	retval = 0;
-	n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
+	n = min(head - ldata->read_tail, N_TTY_BUF_SIZE - tail);
 	n = min(*nr, n);
 	if (n) {
 		retval = copy_to_user(*b, read_buf_addr(ldata, tail), n);
@@ -1948,9 +1960,10 @@ static int copy_from_read_buf(struct tty_struct *tty,
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
@@ -1993,7 +2006,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	bool eof_push = 0;
 
 	/* N.B. avoid overrun if nr == 0 */
-	n = min(*nr, read_cnt(ldata));
+	n = min(*nr, smp_load_acquire(&ldata->canon_head) - ldata->read_tail);
 	if (!n)
 		return 0;
 
@@ -2043,8 +2056,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 
 	if (found)
 		clear_bit(eol, ldata->read_flags);
-	smp_mb__after_atomic();
-	ldata->read_tail += c;
+	smp_store_release(&ldata->read_tail, ldata->read_tail + c);
 
 	if (found) {
 		if (!ldata->push)
-- 
2.2.1

