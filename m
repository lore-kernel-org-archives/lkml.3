Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab3C0LpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:45:13 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54320 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3C0LpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:45:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Min Zhang <mzhang@mvista.com>, Ilya Zykov <linux@izyk.ru>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 09/18] n_tty: Don't wrap input buffer indices at buffer size
Date: Wed, 27 Mar 2013 07:43:59 -0400
Message-Id: <1364384648-6636-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap read_buf indices (read_head, read_tail, canon_head) at
max representable value, instead of at the N_TTY_BUF_SIZE. This step
is necessary to allow lockless reads of these shared variables
(by updating the variables atomically).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 111 ++++++++++++++++++++++++++++------------------------
 1 file changed, 60 insertions(+), 51 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 26a4514..2b38bb2 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -99,8 +99,8 @@ struct n_tty_data {
 	DECLARE_BITMAP(read_flags, N_TTY_BUF_SIZE);
 
 	char *read_buf;
-	int read_head;
-	int read_tail;
+	size_t read_head;
+	size_t read_tail;
 	int read_cnt;
 	int minimum_to_wake;
 
@@ -109,7 +109,7 @@ struct n_tty_data {
 	unsigned int echo_cnt;
 
 	int canon_data;
-	unsigned long canon_head;
+	size_t canon_head;
 	unsigned int canon_column;
 
 	struct mutex atomic_read_lock;
@@ -123,6 +123,16 @@ static inline size_t read_cnt(struct n_tty_data *ldata)
 	return ldata->read_cnt;
 }
 
+static inline unsigned char read_buf(struct n_tty_data *ldata, size_t i)
+{
+	return ldata->read_buf[i & (N_TTY_BUF_SIZE - 1)];
+}
+
+static inline unsigned char *read_buf_addr(struct n_tty_data *ldata, size_t i)
+{
+	return &ldata->read_buf[i & (N_TTY_BUF_SIZE - 1)];
+}
+
 static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 			       unsigned char __user *ptr)
 {
@@ -208,8 +218,8 @@ static ssize_t n_tty_receive_room(struct tty_struct *tty)
 static void put_tty_queue_nolock(unsigned char c, struct n_tty_data *ldata)
 {
 	if (read_cnt(ldata) < N_TTY_BUF_SIZE) {
-		ldata->read_buf[ldata->read_head] = c;
-		ldata->read_head = (ldata->read_head + 1) & (N_TTY_BUF_SIZE-1);
+		*read_buf_addr(ldata, ldata->read_head) = c;
+		ldata->read_head++;
 		ldata->read_cnt++;
 	}
 }
@@ -311,13 +321,10 @@ static ssize_t chars_in_buffer(struct tty_struct *tty)
 	ssize_t n = 0;
 
 	raw_spin_lock_irqsave(&ldata->read_lock, flags);
-	if (!ldata->icanon) {
+	if (!ldata->icanon)
 		n = read_cnt(ldata);
-	} else if (ldata->canon_data) {
-		n = (ldata->canon_head > ldata->read_tail) ?
-			ldata->canon_head - ldata->read_tail :
-			ldata->canon_head + (N_TTY_BUF_SIZE - ldata->read_tail);
-	}
+	else
+		n = ldata->canon_head - ldata->read_tail;
 	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 	return n;
 }
@@ -941,7 +948,9 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	enum { ERASE, WERASE, KILL } kill_type;
-	int head, seen_alnums, cnt;
+	size_t head;
+	size_t cnt;
+	int seen_alnums;
 	unsigned long flags;
 
 	/* FIXME: locking needed ? */
@@ -985,8 +994,8 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 
 		/* erase a single possibly multibyte character */
 		do {
-			head = (head - 1) & (N_TTY_BUF_SIZE-1);
-			c = ldata->read_buf[head];
+			head--;
+			c = read_buf(ldata, head);
 		} while (is_continuation(c, tty) && head != ldata->canon_head);
 
 		/* do not partially erase */
@@ -1000,7 +1009,7 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 			else if (seen_alnums)
 				break;
 		}
-		cnt = (ldata->read_head - head) & (N_TTY_BUF_SIZE-1);
+		cnt = ldata->read_head - head;
 		raw_spin_lock_irqsave(&ldata->read_lock, flags);
 		ldata->read_head = head;
 		ldata->read_cnt -= cnt;
@@ -1014,9 +1023,8 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 				/* if cnt > 1, output a multi-byte character */
 				echo_char(c, tty);
 				while (--cnt > 0) {
-					head = (head+1) & (N_TTY_BUF_SIZE-1);
-					echo_char_raw(ldata->read_buf[head],
-							ldata);
+					head++;
+					echo_char_raw(read_buf(ldata, head), ldata);
 					echo_move_back_col(ldata);
 				}
 			} else if (kill_type == ERASE && !L_ECHOE(tty)) {
@@ -1024,7 +1032,7 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 			} else if (c == '\t') {
 				unsigned int num_chars = 0;
 				int after_tab = 0;
-				unsigned long tail = ldata->read_head;
+				size_t tail = ldata->read_head;
 
 				/*
 				 * Count the columns used for characters
@@ -1034,8 +1042,8 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 				 * number of columns.
 				 */
 				while (tail != ldata->canon_head) {
-					tail = (tail-1) & (N_TTY_BUF_SIZE-1);
-					c = ldata->read_buf[tail];
+					tail--;
+					c = read_buf(ldata, tail);
 					if (c == '\t') {
 						after_tab = 1;
 						break;
@@ -1319,14 +1327,14 @@ send_signal:
 		}
 		if (c == REPRINT_CHAR(tty) && L_ECHO(tty) &&
 		    L_IEXTEN(tty)) {
-			unsigned long tail = ldata->canon_head;
+			size_t tail = ldata->canon_head;
 
 			finish_erasing(ldata);
 			echo_char(c, tty);
 			echo_char_raw('\n', ldata);
 			while (tail != ldata->read_head) {
-				echo_char(ldata->read_buf[tail], tty);
-				tail = (tail+1) & (N_TTY_BUF_SIZE-1);
+				echo_char(read_buf(ldata, tail), tty);
+				tail++;
 			}
 			process_echoes(tty);
 			return;
@@ -1379,7 +1387,7 @@ send_signal:
 
 handle_newline:
 			raw_spin_lock_irqsave(&ldata->read_lock, flags);
-			set_bit(ldata->read_head, ldata->read_flags);
+			set_bit(ldata->read_head & (N_TTY_BUF_SIZE - 1), ldata->read_flags);
 			put_tty_queue_nolock(c, ldata);
 			ldata->canon_head = ldata->read_head;
 			ldata->canon_data++;
@@ -1459,19 +1467,19 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	if (ldata->real_raw) {
 		raw_spin_lock_irqsave(&ldata->read_lock, cpuflags);
 		i = min(N_TTY_BUF_SIZE - read_cnt(ldata),
-			N_TTY_BUF_SIZE - ldata->read_head);
+			N_TTY_BUF_SIZE - (ldata->read_head & (N_TTY_BUF_SIZE - 1)));
 		i = min(count, i);
-		memcpy(ldata->read_buf + ldata->read_head, cp, i);
-		ldata->read_head = (ldata->read_head + i) & (N_TTY_BUF_SIZE-1);
+		memcpy(read_buf_addr(ldata, ldata->read_head), cp, i);
+		ldata->read_head += i;
 		ldata->read_cnt += i;
 		cp += i;
 		count -= i;
 
 		i = min(N_TTY_BUF_SIZE - read_cnt(ldata),
-			N_TTY_BUF_SIZE - ldata->read_head);
+			N_TTY_BUF_SIZE - (ldata->read_head & (N_TTY_BUF_SIZE - 1)));
 		i = min(count, i);
-		memcpy(ldata->read_buf + ldata->read_head, cp, i);
-		ldata->read_head = (ldata->read_head + i) & (N_TTY_BUF_SIZE-1);
+		memcpy(read_buf_addr(ldata, ldata->read_head), cp, i);
+		ldata->read_head += i;
 		ldata->read_cnt += i;
 		raw_spin_unlock_irqrestore(&ldata->read_lock, cpuflags);
 	} else {
@@ -1737,21 +1745,21 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	size_t n;
 	unsigned long flags;
 	bool is_eof;
+	size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 
 	retval = 0;
 	raw_spin_lock_irqsave(&ldata->read_lock, flags);
-	n = min(read_cnt(ldata), N_TTY_BUF_SIZE - ldata->read_tail);
+	n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
 	n = min(*nr, n);
 	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 	if (n) {
-		retval = copy_to_user(*b, &ldata->read_buf[ldata->read_tail], n);
+		retval = copy_to_user(*b, read_buf_addr(ldata, tail), n);
 		n -= retval;
-		is_eof = n == 1 &&
-			ldata->read_buf[ldata->read_tail] == EOF_CHAR(tty);
-		tty_audit_add_data(tty, &ldata->read_buf[ldata->read_tail], n,
+		is_eof = n == 1 && read_buf(ldata, tail) == EOF_CHAR(tty);
+		tty_audit_add_data(tty, read_buf_addr(ldata, tail), n,
 				ldata->icanon);
 		raw_spin_lock_irqsave(&ldata->read_lock, flags);
-		ldata->read_tail = (ldata->read_tail + n) & (N_TTY_BUF_SIZE-1);
+		ldata->read_tail += n;
 		ldata->read_cnt -= n;
 		/* Turn single EOF into zero-length read */
 		if (L_EXTPROC(tty) && ldata->icanon && is_eof && !read_cnt(ldata))
@@ -1783,8 +1791,9 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	struct n_tty_data *ldata = tty->disc_data;
 	unsigned long flags;
 	size_t n, size, more, c;
-	unsigned long eol;
-	int ret, tail, found = 0;
+	size_t eol;
+	size_t tail;
+	int ret, found = 0;
 
 	/* N.B. avoid overrun if nr == 0 */
 
@@ -1796,10 +1805,10 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 		return 0;
 	}
 
-	tail = ldata->read_tail;
+	tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 	size = min_t(size_t, tail + n, N_TTY_BUF_SIZE);
 
-	n_tty_trace("%s: nr:%zu tail:%d n:%zu size:%zu\n",
+	n_tty_trace("%s: nr:%zu tail:%zu n:%zu size:%zu\n",
 		    __func__, *nr, tail, n, size);
 
 	eol = find_next_bit(ldata->read_flags, size, tail);
@@ -1816,21 +1825,21 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	n = (found + eol + size) & (N_TTY_BUF_SIZE - 1);
 	c = n;
 
-	if (found && ldata->read_buf[eol] == __DISABLED_CHAR)
+	if (found && read_buf(ldata, eol) == __DISABLED_CHAR)
 		n--;
 
-	n_tty_trace("%s: eol:%lu found:%d n:%zu c:%zu size:%zu more:%zu\n",
+	n_tty_trace("%s: eol:%zu found:%d n:%zu c:%zu size:%zu more:%zu\n",
 		    __func__, eol, found, n, c, size, more);
 
 	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 
 	if (n > size) {
-		ret = copy_to_user(*b, &ldata->read_buf[tail], size);
+		ret = copy_to_user(*b, read_buf_addr(ldata, tail), size);
 		if (ret)
 			return -EFAULT;
 		ret = copy_to_user(*b + size, ldata->read_buf, n - size);
 	} else
-		ret = copy_to_user(*b, &ldata->read_buf[tail], n);
+		ret = copy_to_user(*b, read_buf_addr(ldata, tail), n);
 
 	if (ret)
 		return -EFAULT;
@@ -1838,7 +1847,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	*nr -= n;
 
 	raw_spin_lock_irqsave(&ldata->read_lock, flags);
-	ldata->read_tail = (ldata->read_tail + c) & (N_TTY_BUF_SIZE - 1);
+	ldata->read_tail += c;
 	ldata->read_cnt -= c;
 	if (found) {
 		__clear_bit(eol, ldata->read_flags);
@@ -2228,19 +2237,19 @@ static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
 
 static unsigned long inq_canon(struct n_tty_data *ldata)
 {
-	int nr, head, tail;
+	size_t nr, head, tail;
 
 	if (!ldata->canon_data)
 		return 0;
 	head = ldata->canon_head;
 	tail = ldata->read_tail;
-	nr = (head - tail) & (N_TTY_BUF_SIZE-1);
+	nr = head - tail;
 	/* Skip EOF-chars.. */
 	while (head != tail) {
-		if (test_bit(tail, ldata->read_flags) &&
-		    ldata->read_buf[tail] == __DISABLED_CHAR)
+		if (test_bit(tail & (N_TTY_BUF_SIZE - 1), ldata->read_flags) &&
+		    read_buf(ldata, tail) == __DISABLED_CHAR)
 			nr--;
-		tail = (tail+1) & (N_TTY_BUF_SIZE-1);
+		tail++;
 	}
 	return nr;
 }
-- 
1.8.1.2

