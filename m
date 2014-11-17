Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaKQMpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:45:16 -0500
Received: from ns.omicron.at ([212.183.10.25]:41024 "EHLO ns.omicron.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaKQMpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:45:15 -0500
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2014 07:45:14 EST
From: Christian Riesch <christian.riesch@omicron.at>
To: <linux-kernel@vger.kernel.org>
CC: Christian Riesch <christian.riesch@omicron.at>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [RFC PATCH] n_tty: Add memory barriers where required for lock-less circular buffer
Date: Mon, 17 Nov 2014 13:27:20 +0100
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <2a3a5417-48fb-4d4f-a410-566783d2283c@EXC01-ATKLA.omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
Cc: Peter Hurley <peter@hurleysoftware.com>
---

Hi all,

This patch adds memory barriers to the lock-less circular buffer in the n_tty
driver to fix the race condition described in [1] and [2] for SMP machines.

The patch is based on the instructions in Documentation/circular-buffers.txt.

Currently, this is only compile-tested. Peter, could you please have a look
at this and the documentation mentioned above, and tell me what you
think about this?

Prerequisites:
- The patch in [2]

Thanks!
Christian

[1] https://lkml.org/lkml/2014/11/6/216
[2] https://lkml.org/lkml/2014/11/11/77

 drivers/tty/n_tty.c |   93 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 64 insertions(+), 29 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 47ca0f3..656d868 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -127,9 +127,24 @@ struct n_tty_data {
 	struct mutex output_lock;
 };
 
-static inline size_t read_cnt(struct n_tty_data *ldata)
+static inline size_t data_available(size_t head, size_t tail)
 {
-	return ldata->read_head - ldata->read_tail;
+	return head - tail;
+}
+
+static inline size_t room_available(size_t head, size_t tail)
+{
+	return N_TTY_BUF_SIZE - data_available(head, tail);
+}
+
+static inline size_t contiguous_data_available(size_t head, size_t tail)
+{
+	return min(head - tail, N_TTY_BUF_SIZE - (tail & (N_TTY_BUF_SIZE - 1)));
+}
+
+static inline size_t contiguous_room_available(size_t head, size_t tail)
+{
+	return N_TTY_BUF_SIZE - max(head - tail, head & (N_TTY_BUF_SIZE - 1));
 }
 
 static inline unsigned char read_buf(struct n_tty_data *ldata, size_t i)
@@ -165,14 +180,18 @@ static int receive_room(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int left;
+	size_t head, tail;
+
+	head = ldata->read_head;
+	tail = ACCESS_ONCE(ldata->read_tail);
 
 	if (I_PARMRK(tty)) {
-		/* Multiply read_cnt by 3, since each byte might take up to
-		 * three times as many spaces when PARMRK is set (depending on
-		 * its flags, e.g. parity error). */
-		left = N_TTY_BUF_SIZE - read_cnt(ldata) * 3 - 1;
+		/* Multiply available data by 3, since each byte might take up
+		 * to three times as many spaces when PARMRK is set (depending
+		 * on its flags, e.g. parity error). */
+		left = N_TTY_BUF_SIZE - data_available(head, tail) * 3 - 1;
 	} else
-		left = N_TTY_BUF_SIZE - read_cnt(ldata) - 1;
+		left = N_TTY_BUF_SIZE - data_available(head, tail) - 1;
 
 	/*
 	 * If we are doing input canonicalization, and there are no
@@ -181,7 +200,7 @@ static int receive_room(struct tty_struct *tty)
 	 * characters will be beeped.
 	 */
 	if (left <= 0)
-		left = ldata->icanon && ldata->canon_head == ldata->read_tail;
+		left = ldata->icanon && ldata->canon_head == tail;
 
 	return left;
 }
@@ -222,11 +241,15 @@ static ssize_t chars_in_buffer(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	ssize_t n = 0;
+	size_t head, tail;
+
+	head = ACCESS_ONCE(ldata->read_head);
+	tail = ldata->read_tail;
 
 	if (!ldata->icanon)
-		n = read_cnt(ldata);
+		n = data_available(head, tail);
 	else
-		n = ldata->canon_head - ldata->read_tail;
+		n = ldata->canon_head - tail;
 	return n;
 }
 
@@ -322,7 +345,7 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
 static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 {
 	*read_buf_addr(ldata, ldata->read_head) = c;
-	ldata->read_head++;
+	smp_store_release(&ldata->read_head, ldata->read_head + 1);
 }
 
 /**
@@ -1534,21 +1557,23 @@ n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
 			   char *fp, int count)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	size_t n, head;
+	size_t n, head, tail;
+
+	head = ldata->read_head;
+	tail = ACCESS_ONCE(ldata->read_tail);
 
-	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
-	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
+	n = contiguous_room_available(head, tail);
 	n = min_t(size_t, count, n);
 	memcpy(read_buf_addr(ldata, head), cp, n);
-	ldata->read_head += n;
+	smp_store_release(&ldata->read_head, ldata->read_head + n);
 	cp += n;
 	count -= n;
 
-	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
-	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
+	head = ldata->read_head;
+	n = contiguous_room_available(head, tail);
 	n = min_t(size_t, count, n);
 	memcpy(read_buf_addr(ldata, head), cp, n);
-	ldata->read_head += n;
+	smp_store_release(&ldata->read_head, ldata->read_head + n);
 }
 
 static void
@@ -1648,6 +1673,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			  char *fp, int count)
 {
 	struct n_tty_data *ldata = tty->disc_data;
+	size_t tail;
 	bool preops = I_ISTRIP(tty) || (I_IUCLC(tty) && L_IEXTEN(tty));
 
 	if (ldata->real_raw)
@@ -1676,8 +1702,9 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			tty->ops->flush_chars(tty);
 	}
 
-	if ((!ldata->icanon && (read_cnt(ldata) >= ldata->minimum_to_wake)) ||
-		L_EXTPROC(tty)) {
+	tail = ACCESS_ONCE(ldata->read_tail);
+	if ((!ldata->icanon && (data_available(ldata->read_head, tail) >=
+				ldata->minimum_to_wake)) || L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 		if (waitqueue_active(&tty->read_wait))
 			wake_up_interruptible_poll(&tty->read_wait, POLLIN);
@@ -1751,11 +1778,13 @@ int is_ignored(int sig)
 static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct n_tty_data *ldata = tty->disc_data;
+	size_t head;
 
 	if (!old || (old->c_lflag ^ tty->termios.c_lflag) & ICANON) {
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
 		ldata->line_start = ldata->read_tail;
-		if (!L_ICANON(tty) || !read_cnt(ldata)) {
+		head = ACCESS_ONCE(ldata->read_head);
+		if (!L_ICANON(tty) || !data_available(head, ldata->read_tail)) {
 			ldata->canon_head = ldata->read_tail;
 			ldata->push = 0;
 		} else {
@@ -1901,11 +1930,12 @@ static inline int input_available_p(struct tty_struct *tty, int poll)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int amt = poll && !TIME_CHAR(tty) && MIN_CHAR(tty) ? MIN_CHAR(tty) : 1;
+	size_t head = smp_load_acquire(&ldata->read_head);
 
 	if (ldata->icanon && !L_EXTPROC(tty))
 		return ldata->canon_head != ldata->read_tail;
 	else
-		return read_cnt(ldata) >= amt;
+		return data_available(head, ldata->read_tail) >= amt;
 }
 
 /**
@@ -1937,10 +1967,11 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	int retval;
 	size_t n;
 	bool is_eof;
-	size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
+	size_t head = smp_load_acquire(&ldata->read_head);
+	size_t tail = ldata->read_tail;
 
 	retval = 0;
-	n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
+	n = contiguous_data_available(head, tail);
 	n = min(*nr, n);
 	if (n) {
 		retval = copy_to_user(*b, read_buf_addr(ldata, tail), n);
@@ -1948,9 +1979,10 @@ static int copy_from_read_buf(struct tty_struct *tty,
 		is_eof = n == 1 && read_buf(ldata, tail) == EOF_CHAR(tty);
 		tty_audit_add_data(tty, read_buf_addr(ldata, tail), n,
 				ldata->icanon);
-		ldata->read_tail += n;
+		smp_store_release(&ldata->read_tail, ldata->read_tail + n);
 		/* Turn single EOF into zero-length read */
-		if (L_EXTPROC(tty) && ldata->icanon && is_eof && !read_cnt(ldata))
+		if (L_EXTPROC(tty) && ldata->icanon && is_eof &&
+		    !data_available(head, ldata->read_tail))
 			n = 0;
 		*b += n;
 		*nr -= n;
@@ -1988,12 +2020,14 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	struct n_tty_data *ldata = tty->disc_data;
 	size_t n, size, more, c;
 	size_t eol;
-	size_t tail;
+	size_t head, tail;
 	int ret, found = 0;
 	bool eof_push = 0;
 
+	head = smp_load_acquire(&ldata->read_head);
+
 	/* N.B. avoid overrun if nr == 0 */
-	n = min(*nr, read_cnt(ldata));
+	n = min(*nr, data_available(head, ldata->read_tail));
 	if (!n)
 		return 0;
 
@@ -2473,7 +2507,8 @@ static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 		if (L_ICANON(tty))
 			retval = inq_canon(ldata);
 		else
-			retval = read_cnt(ldata);
+			retval = data_available(ACCESS_ONCE(ldata->read_head),
+						ldata->read_tail);
 		up_write(&tty->termios_rwsem);
 		return put_user(retval, (unsigned int __user *) arg);
 	default:
-- 
1.7.9.5

