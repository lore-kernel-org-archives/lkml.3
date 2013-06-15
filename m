Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab3FONV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:21:57 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43192 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3FONVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:21:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 14/24] n_tty: Make N_TTY ldisc receive path lockless
Date: Sat, 15 Jun 2013 09:14:26 -0400
Message-Id: <1371302076-4688-15-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n_tty has a single-producer/single-consumer input model;
use lockless publish instead.

Use termios_rwsem to exclude both consumer and producer while
changing or resetting buffer indices, eg., when flushing. Also,
claim exclusive termios_rwsem to safely retrieve the buffer
indices from a thread other than consumer or producer
(eg., TIOCINQ ioctl).

Note the read_tail is published _after_ clearing the newline
indicator in read_flags to avoid racing the producer.

Drop read_lock spinlock.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 173 ++++++++++++++++++++++++++++------------------------
 1 file changed, 92 insertions(+), 81 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 1098dd7..c7f71cb 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -110,7 +110,6 @@ struct n_tty_data {
 	struct mutex atomic_read_lock;
 	struct mutex output_lock;
 	struct mutex echo_lock;
-	raw_spinlock_t read_lock;
 };
 
 static inline size_t read_cnt(struct n_tty_data *ldata)
@@ -168,7 +167,10 @@ static int receive_room(struct tty_struct *tty)
  *
  *	Re-schedules the flip buffer work if space just became available.
  *
- *	Locks: Concurrent update is protected with read_lock
+ *	Caller holds exclusive termios_rwsem
+ *	   or
+ *	n_tty_read()/consumer path:
+ *		holds non-exclusive termios_rwsem
  */
 
 static void n_tty_set_room(struct tty_struct *tty)
@@ -191,34 +193,27 @@ static void n_tty_set_room(struct tty_struct *tty)
 	}
 }
 
-static void put_tty_queue_nolock(unsigned char c, struct n_tty_data *ldata)
-{
-	if (read_cnt(ldata) < N_TTY_BUF_SIZE) {
-		*read_buf_addr(ldata, ldata->read_head) = c;
-		ldata->read_head++;
-	}
-}
-
 /**
  *	put_tty_queue		-	add character to tty
  *	@c: character
  *	@ldata: n_tty data
  *
- *	Add a character to the tty read_buf queue. This is done under the
- *	read_lock to serialize character addition and also to protect us
- *	against parallel reads or flushes
+ *	Add a character to the tty read_buf queue.
+ *
+ *	n_tty_receive_buf()/producer path:
+ *		caller holds non-exclusive termios_rwsem
+ *		modifies read_head
+ *
+ *	read_head is only considered 'published' if canonical mode is
+ *	not active.
  */
 
 static void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 {
-	unsigned long flags;
-	/*
-	 *	The problem of stomping on the buffers ends here.
-	 *	Why didn't anyone see this one coming? --AJK
-	*/
-	raw_spin_lock_irqsave(&ldata->read_lock, flags);
-	put_tty_queue_nolock(c, ldata);
-	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
+	if (read_cnt(ldata) < N_TTY_BUF_SIZE) {
+		*read_buf_addr(ldata, ldata->read_head) = c;
+		ldata->read_head++;
+	}
 }
 
 /**
@@ -228,16 +223,13 @@ static void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
  *	Reset the read buffer counters and clear the flags.
  *	Called from n_tty_open() and n_tty_flush_buffer().
  *
- *	Locking: tty_read_lock for read fields.
+ *	Locking: caller holds exclusive termios_rwsem
+ *		 (or locking is not required)
  */
 
 static void reset_buffer_flags(struct n_tty_data *ldata)
 {
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ldata->read_lock, flags);
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
-	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 
 	mutex_lock(&ldata->echo_lock);
 	ldata->echo_pos = ldata->echo_cnt = ldata->echo_overrun = 0;
@@ -267,47 +259,55 @@ static void n_tty_packet_mode_flush(struct tty_struct *tty)
  *	buffer flushed (eg at hangup) or when the N_TTY line discipline
  *	internally has to clean the pending queue (for example some signals).
  *
- *	Locking: ctrl_lock, read_lock.
+ *	Holds termios_rwsem to exclude producer/consumer while
+ *	buffer indices are reset.
+ *
+ *	Locking: ctrl_lock, exclusive termios_rwsem
  */
 
 static void n_tty_flush_buffer(struct tty_struct *tty)
 {
+	down_write(&tty->termios_rwsem);
 	reset_buffer_flags(tty->disc_data);
 	n_tty_set_room(tty);
 
 	if (tty->link)
 		n_tty_packet_mode_flush(tty);
+	up_write(&tty->termios_rwsem);
 }
 
-/**
- *	n_tty_chars_in_buffer	-	report available bytes
- *	@tty: tty device
- *
- *	Report the number of characters buffered to be delivered to user
- *	at this instant in time.
- *
- *	Locking: read_lock
- */
-
 static ssize_t chars_in_buffer(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	unsigned long flags;
 	ssize_t n = 0;
 
-	raw_spin_lock_irqsave(&ldata->read_lock, flags);
 	if (!ldata->icanon)
 		n = read_cnt(ldata);
 	else
 		n = ldata->canon_head - ldata->read_tail;
-	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 	return n;
 }
 
+/**
+ *	n_tty_chars_in_buffer	-	report available bytes
+ *	@tty: tty device
+ *
+ *	Report the number of characters buffered to be delivered to user
+ *	at this instant in time.
+ *
+ *	Locking: exclusive termios_rwsem
+ */
+
 static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
 {
+	ssize_t n;
+
 	WARN_ONCE(1, "%s is deprecated and scheduled for removal.", __func__);
-	return chars_in_buffer(tty);
+
+	down_write(&tty->termios_rwsem);
+	n = chars_in_buffer(tty);
+	up_write(&tty->termios_rwsem);
+	return n;
 }
 
 /**
@@ -915,7 +915,12 @@ static inline void finish_erasing(struct n_tty_data *ldata)
  *	present in the stream from the driver layer. Handles the complexities
  *	of UTF-8 multibyte symbols.
  *
- *	Locking: read_lock for tty buffers
+ *	n_tty_receive_buf()/producer path:
+ *		caller holds non-exclusive termios_rwsem
+ *		modifies read_head
+ *
+ *	Modifying the read_head is not considered a publish in this context
+ *	because canonical mode is active -- only canon_head publishes
  */
 
 static void eraser(unsigned char c, struct tty_struct *tty)
@@ -925,9 +930,7 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 	size_t head;
 	size_t cnt;
 	int seen_alnums;
-	unsigned long flags;
 
-	/* FIXME: locking needed ? */
 	if (ldata->read_head == ldata->canon_head) {
 		/* process_output('\a', tty); */ /* what do you think? */
 		return;
@@ -938,15 +941,11 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 		kill_type = WERASE;
 	else {
 		if (!L_ECHO(tty)) {
-			raw_spin_lock_irqsave(&ldata->read_lock, flags);
 			ldata->read_head = ldata->canon_head;
-			raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 			return;
 		}
 		if (!L_ECHOK(tty) || !L_ECHOKE(tty) || !L_ECHOE(tty)) {
-			raw_spin_lock_irqsave(&ldata->read_lock, flags);
 			ldata->read_head = ldata->canon_head;
-			raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 			finish_erasing(ldata);
 			echo_char(KILL_CHAR(tty), tty);
 			/* Add a newline if ECHOK is on and ECHOKE is off. */
@@ -958,7 +957,6 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 	}
 
 	seen_alnums = 0;
-	/* FIXME: Locking ?? */
 	while (ldata->read_head != ldata->canon_head) {
 		head = ldata->read_head;
 
@@ -980,9 +978,7 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 				break;
 		}
 		cnt = ldata->read_head - head;
-		raw_spin_lock_irqsave(&ldata->read_lock, flags);
 		ldata->read_head = head;
-		raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 		if (L_ECHO(tty)) {
 			if (L_ECHOPRT(tty)) {
 				if (!ldata->erasing) {
@@ -1071,7 +1067,11 @@ static inline void isig(int sig, struct tty_struct *tty)
  *	An RS232 break event has been hit in the incoming bitstream. This
  *	can cause a variety of events depending upon the termios settings.
  *
- *	Called from the receive_buf path so single threaded.
+ *	n_tty_receive_buf()/producer path:
+ *		caller holds non-exclusive termios_rwsem
+ *		publishes read_head via put_tty_queue()
+ *
+ *	Note: may get exclusive termios_rwsem if flushing input buffer
  */
 
 static inline void n_tty_receive_break(struct tty_struct *tty)
@@ -1083,8 +1083,11 @@ static inline void n_tty_receive_break(struct tty_struct *tty)
 	if (I_BRKINT(tty)) {
 		isig(SIGINT, tty);
 		if (!L_NOFLSH(tty)) {
+			/* flushing needs exclusive termios_rwsem */
+			up_read(&tty->termios_rwsem);
 			n_tty_flush_buffer(tty);
 			tty_driver_flush_buffer(tty);
+			down_read(&tty->termios_rwsem);
 		}
 		return;
 	}
@@ -1131,7 +1134,11 @@ static inline void n_tty_receive_overrun(struct tty_struct *tty)
  *	@c: character
  *
  *	Process a parity error and queue the right data to indicate
- *	the error case if necessary. Locking as per n_tty_receive_buf.
+ *	the error case if necessary.
+ *
+ *	n_tty_receive_buf()/producer path:
+ *		caller holds non-exclusive termios_rwsem
+ *		publishes read_head via put_tty_queue()
  */
 static inline void n_tty_receive_parity_error(struct tty_struct *tty,
 					      unsigned char c)
@@ -1159,12 +1166,16 @@ static inline void n_tty_receive_parity_error(struct tty_struct *tty,
  *	Process an individual character of input received from the driver.
  *	This is serialized with respect to itself by the rules for the
  *	driver above.
+ *
+ *	n_tty_receive_buf()/producer path:
+ *		caller holds non-exclusive termios_rwsem
+ *		publishes canon_head if canonical mode is active
+ *		otherwise, publishes read_head via put_tty_queue()
  */
 
 static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	unsigned long flags;
 	int parmrk;
 
 	if (ldata->raw) {
@@ -1253,8 +1264,11 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
 			if (!L_NOFLSH(tty)) {
+				/* flushing needs exclusive termios_rwsem */
+				up_read(&tty->termios_rwsem);
 				n_tty_flush_buffer(tty);
 				tty_driver_flush_buffer(tty);
+				down_read(&tty->termios_rwsem);
 			}
 			if (I_IXON(tty))
 				start_tty(tty);
@@ -1355,11 +1369,9 @@ send_signal:
 				put_tty_queue(c, ldata);
 
 handle_newline:
-			raw_spin_lock_irqsave(&ldata->read_lock, flags);
 			set_bit(ldata->read_head & (N_TTY_BUF_SIZE - 1), ldata->read_flags);
-			put_tty_queue_nolock(c, ldata);
+			put_tty_queue(c, ldata);
 			ldata->canon_head = ldata->read_head;
-			raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 			if (waitqueue_active(&tty->read_wait))
 				wake_up_interruptible(&tty->read_wait);
@@ -1420,6 +1432,10 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
  *	been received. This function must be called from soft contexts
  *	not from interrupt context. The driver is responsible for making
  *	calls one at a time and in order (or using flush_to_ldisc)
+ *
+ *	n_tty_receive_buf()/producer path:
+ *		claims non-exclusive termios_rwsem
+ *		publishes read_head and canon_head
  */
 
 static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
@@ -1430,10 +1446,8 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	char *f, flags = TTY_NORMAL;
 	int	i;
 	char	buf[64];
-	unsigned long cpuflags;
 
 	if (ldata->real_raw) {
-		raw_spin_lock_irqsave(&ldata->read_lock, cpuflags);
 		i = min(N_TTY_BUF_SIZE - read_cnt(ldata),
 			N_TTY_BUF_SIZE - (ldata->read_head & (N_TTY_BUF_SIZE - 1)));
 		i = min(count, i);
@@ -1447,7 +1461,6 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		i = min(count, i);
 		memcpy(read_buf_addr(ldata, ldata->read_head), cp, i);
 		ldata->read_head += i;
-		raw_spin_unlock_irqrestore(&ldata->read_lock, cpuflags);
 	} else {
 		for (i = count, p = cp, f = fp; i; i--, p++) {
 			if (f)
@@ -1677,7 +1690,6 @@ static int n_tty_open(struct tty_struct *tty)
 	mutex_init(&ldata->atomic_read_lock);
 	mutex_init(&ldata->output_lock);
 	mutex_init(&ldata->echo_lock);
-	raw_spin_lock_init(&ldata->read_lock);
 
 	/* These are ugly. Currently a malloc failure here can panic */
 	ldata->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
@@ -1733,6 +1745,9 @@ static inline int input_available_p(struct tty_struct *tty, int amt)
  *
  *	Called under the ldata->atomic_read_lock sem
  *
+ *	n_tty_read()/consumer path:
+ *		caller holds non-exclusive termios_rwsem
+ *		read_tail published
  */
 
 static int copy_from_read_buf(struct tty_struct *tty,
@@ -1743,27 +1758,22 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	struct n_tty_data *ldata = tty->disc_data;
 	int retval;
 	size_t n;
-	unsigned long flags;
 	bool is_eof;
 	size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 
 	retval = 0;
-	raw_spin_lock_irqsave(&ldata->read_lock, flags);
 	n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
 	n = min(*nr, n);
-	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 	if (n) {
 		retval = copy_to_user(*b, read_buf_addr(ldata, tail), n);
 		n -= retval;
 		is_eof = n == 1 && read_buf(ldata, tail) == EOF_CHAR(tty);
 		tty_audit_add_data(tty, read_buf_addr(ldata, tail), n,
 				ldata->icanon);
-		raw_spin_lock_irqsave(&ldata->read_lock, flags);
 		ldata->read_tail += n;
 		/* Turn single EOF into zero-length read */
 		if (L_EXTPROC(tty) && ldata->icanon && is_eof && !read_cnt(ldata))
 			n = 0;
-		raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 		*b += n;
 		*nr -= n;
 	}
@@ -1781,6 +1791,10 @@ static int copy_from_read_buf(struct tty_struct *tty,
  *	character into the user-space buffer.
  *
  *	Called under the atomic_read_lock mutex
+ *
+ *	n_tty_read()/consumer path:
+ *		caller holds non-exclusive termios_rwsem
+ *		read_tail published
  */
 
 static int canon_copy_from_read_buf(struct tty_struct *tty,
@@ -1788,21 +1802,15 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 				    size_t *nr)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	unsigned long flags;
 	size_t n, size, more, c;
 	size_t eol;
 	size_t tail;
 	int ret, found = 0;
 
 	/* N.B. avoid overrun if nr == 0 */
-
-	raw_spin_lock_irqsave(&ldata->read_lock, flags);
-
 	n = min(*nr, read_cnt(ldata));
-	if (!n) {
-		raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
+	if (!n)
 		return 0;
-	}
 
 	tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 	size = min_t(size_t, tail + n, N_TTY_BUF_SIZE);
@@ -1830,8 +1838,6 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	n_tty_trace("%s: eol:%zu found:%d n:%zu c:%zu size:%zu more:%zu\n",
 		    __func__, eol, found, n, c, size, more);
 
-	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
-
 	if (n > size) {
 		ret = copy_to_user(*b, read_buf_addr(ldata, tail), size);
 		if (ret)
@@ -1845,11 +1851,10 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	*b += n;
 	*nr -= n;
 
-	raw_spin_lock_irqsave(&ldata->read_lock, flags);
-	ldata->read_tail += c;
 	if (found)
-		__clear_bit(eol, ldata->read_flags);
-	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
+		clear_bit(eol, ldata->read_flags);
+	smp_mb__after_clear_bit();
+	ldata->read_tail += c;
 
 	if (found)
 		tty_audit_push(tty);
@@ -1913,6 +1918,10 @@ static int job_control(struct tty_struct *tty, struct file *file)
  *	a hangup. Always called in user context, may sleep.
  *
  *	This code must be sure never to sleep through a hangup.
+ *
+ *	n_tty_read()/consumer path:
+ *		claims non-exclusive termios_rwsem
+ *		publishes read_tail
  */
 
 static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
@@ -2279,10 +2288,12 @@ static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 	case TIOCOUTQ:
 		return put_user(tty_chars_in_buffer(tty), (int __user *) arg);
 	case TIOCINQ:
-		/* FIXME: Locking */
-		retval = read_cnt(ldata);
+		down_write(&tty->termios_rwsem);
 		if (L_ICANON(tty))
 			retval = inq_canon(ldata);
+		else
+			retval = read_cnt(ldata);
+		up_write(&tty->termios_rwsem);
 		return put_user(retval, (unsigned int __user *) arg);
 	default:
 		return n_tty_ioctl_helper(tty, file, cmd, arg);
-- 
1.8.1.2

