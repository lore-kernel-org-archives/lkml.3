Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3C0LpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:45:01 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54313 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3C0Lo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:44:57 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Min Zhang <mzhang@mvista.com>, Ilya Zykov <linux@izyk.ru>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 08/18] n_tty: Get read_cnt through accessor
Date: Wed, 27 Mar 2013 07:43:58 -0400
Message-Id: <1364384648-6636-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for replacing read_cnt field with computed value.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 446674e..26a4514 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -118,6 +118,11 @@ struct n_tty_data {
 	raw_spinlock_t read_lock;
 };
 
+static inline size_t read_cnt(struct n_tty_data *ldata)
+{
+	return ldata->read_cnt;
+}
+
 static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 			       unsigned char __user *ptr)
 {
@@ -136,9 +141,9 @@ static ssize_t receive_room(struct tty_struct *tty)
 		/* Multiply read_cnt by 3, since each byte might take up to
 		 * three times as many spaces when PARMRK is set (depending on
 		 * its flags, e.g. parity error). */
-		left = N_TTY_BUF_SIZE - ldata->read_cnt * 3 - 1;
+		left = N_TTY_BUF_SIZE - read_cnt(ldata) * 3 - 1;
 	} else
-		left = N_TTY_BUF_SIZE - ldata->read_cnt - 1;
+		left = N_TTY_BUF_SIZE - read_cnt(ldata) - 1;
 
 	/*
 	 * If we are doing input canonicalization, and there are no
@@ -202,7 +207,7 @@ static ssize_t n_tty_receive_room(struct tty_struct *tty)
 
 static void put_tty_queue_nolock(unsigned char c, struct n_tty_data *ldata)
 {
-	if (ldata->read_cnt < N_TTY_BUF_SIZE) {
+	if (read_cnt(ldata) < N_TTY_BUF_SIZE) {
 		ldata->read_buf[ldata->read_head] = c;
 		ldata->read_head = (ldata->read_head + 1) & (N_TTY_BUF_SIZE-1);
 		ldata->read_cnt++;
@@ -307,7 +312,7 @@ static ssize_t chars_in_buffer(struct tty_struct *tty)
 
 	raw_spin_lock_irqsave(&ldata->read_lock, flags);
 	if (!ldata->icanon) {
-		n = ldata->read_cnt;
+		n = read_cnt(ldata);
 	} else if (ldata->canon_data) {
 		n = (ldata->canon_head > ldata->read_tail) ?
 			ldata->canon_head - ldata->read_tail :
@@ -1227,7 +1232,7 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 	if (!test_bit(c, ldata->process_char_map) || ldata->lnext) {
 		ldata->lnext = 0;
 		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
-		if (ldata->read_cnt >= (N_TTY_BUF_SIZE - parmrk - 1)) {
+		if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk - 1)) {
 			/* beep if no space */
 			if (L_ECHO(tty))
 				process_output('\a', tty);
@@ -1327,7 +1332,7 @@ send_signal:
 			return;
 		}
 		if (c == '\n') {
-			if (ldata->read_cnt >= N_TTY_BUF_SIZE) {
+			if (read_cnt(ldata) >= N_TTY_BUF_SIZE) {
 				if (L_ECHO(tty))
 					process_output('\a', tty);
 				return;
@@ -1339,7 +1344,7 @@ send_signal:
 			goto handle_newline;
 		}
 		if (c == EOF_CHAR(tty)) {
-			if (ldata->read_cnt >= N_TTY_BUF_SIZE)
+			if (read_cnt(ldata) >= N_TTY_BUF_SIZE)
 				return;
 			if (ldata->canon_head != ldata->read_head)
 				set_bit(TTY_PUSH, &tty->flags);
@@ -1350,7 +1355,7 @@ send_signal:
 		    (c == EOL2_CHAR(tty) && L_IEXTEN(tty))) {
 			parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty))
 				 ? 1 : 0;
-			if (ldata->read_cnt >= (N_TTY_BUF_SIZE - parmrk)) {
+			if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk)) {
 				if (L_ECHO(tty))
 					process_output('\a', tty);
 				return;
@@ -1387,7 +1392,7 @@ handle_newline:
 	}
 
 	parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
-	if (ldata->read_cnt >= (N_TTY_BUF_SIZE - parmrk - 1)) {
+	if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk - 1)) {
 		/* beep if no space */
 		if (L_ECHO(tty))
 			process_output('\a', tty);
@@ -1453,7 +1458,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 
 	if (ldata->real_raw) {
 		raw_spin_lock_irqsave(&ldata->read_lock, cpuflags);
-		i = min(N_TTY_BUF_SIZE - ldata->read_cnt,
+		i = min(N_TTY_BUF_SIZE - read_cnt(ldata),
 			N_TTY_BUF_SIZE - ldata->read_head);
 		i = min(count, i);
 		memcpy(ldata->read_buf + ldata->read_head, cp, i);
@@ -1462,7 +1467,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		cp += i;
 		count -= i;
 
-		i = min(N_TTY_BUF_SIZE - ldata->read_cnt,
+		i = min(N_TTY_BUF_SIZE - read_cnt(ldata),
 			N_TTY_BUF_SIZE - ldata->read_head);
 		i = min(count, i);
 		memcpy(ldata->read_buf + ldata->read_head, cp, i);
@@ -1497,7 +1502,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			tty->ops->flush_chars(tty);
 	}
 
-	if ((!ldata->icanon && (ldata->read_cnt >= ldata->minimum_to_wake)) ||
+	if ((!ldata->icanon && (read_cnt(ldata) >= ldata->minimum_to_wake)) ||
 		L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 		if (waitqueue_active(&tty->read_wait))
@@ -1553,7 +1558,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		ldata->erasing = 0;
 	}
 
-	if (canon_change && !L_ICANON(tty) && ldata->read_cnt)
+	if (canon_change && !L_ICANON(tty) && read_cnt(ldata))
 		wake_up_interruptible(&tty->read_wait);
 
 	ldata->icanon = (L_ICANON(tty) != 0);
@@ -1699,7 +1704,7 @@ static inline int input_available_p(struct tty_struct *tty, int amt)
 	if (ldata->icanon && !L_EXTPROC(tty)) {
 		if (ldata->canon_data)
 			return 1;
-	} else if (ldata->read_cnt >= (amt ? amt : 1))
+	} else if (read_cnt(ldata) >= (amt ? amt : 1))
 		return 1;
 
 	return 0;
@@ -1735,7 +1740,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
 
 	retval = 0;
 	raw_spin_lock_irqsave(&ldata->read_lock, flags);
-	n = min(ldata->read_cnt, N_TTY_BUF_SIZE - ldata->read_tail);
+	n = min(read_cnt(ldata), N_TTY_BUF_SIZE - ldata->read_tail);
 	n = min(*nr, n);
 	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 	if (n) {
@@ -1749,7 +1754,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
 		ldata->read_tail = (ldata->read_tail + n) & (N_TTY_BUF_SIZE-1);
 		ldata->read_cnt -= n;
 		/* Turn single EOF into zero-length read */
-		if (L_EXTPROC(tty) && ldata->icanon && is_eof && !ldata->read_cnt)
+		if (L_EXTPROC(tty) && ldata->icanon && is_eof && !read_cnt(ldata))
 			n = 0;
 		raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 		*b += n;
@@ -1785,7 +1790,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 
 	raw_spin_lock_irqsave(&ldata->read_lock, flags);
 
-	n = min_t(size_t, *nr, ldata->read_cnt);
+	n = min(*nr, read_cnt(ldata));
 	if (!n) {
 		raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 		return 0;
@@ -2251,7 +2256,7 @@ static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 		return put_user(tty_chars_in_buffer(tty), (int __user *) arg);
 	case TIOCINQ:
 		/* FIXME: Locking */
-		retval = ldata->read_cnt;
+		retval = read_cnt(ldata);
 		if (L_ICANON(tty))
 			retval = inq_canon(ldata);
 		return put_user(retval, (unsigned int __user *) arg);
-- 
1.8.1.2

