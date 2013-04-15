Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934564Ab3DOPgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:36:32 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45974 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226Ab3DOPdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:33:21 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 01/20] n_tty: Fix EOF push handling
Date: Mon, 15 Apr 2013 11:32:32 -0400
Message-Id: <1366039971-8770-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
References: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
 <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In canonical mode, an EOF which is not the first character of the line
causes read() to complete and return the number of characters read so
far (commonly referred to as EOF push). However, if the previous read()
returned because the user buffer was full _and_ the next character
is an EOF not at the beginning of the line, read() must not return 0,
thus mistakenly indicating the end-of-file condition.

The TTY_PUSH flag is used to indicate an EOF was received which is not
at the beginning of the line. Because the EOF push condition is
evaluated by a thread other than the read(), multiple EOF pushes can
cause a premature end-of-file to be indicated.

Instead, discover the 'EOF push as first read character' condition
from the read() thread itself, and restart the i/o loop if detected.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c  | 34 +++++++++++++++++-----------------
 drivers/tty/tty_io.c |  1 -
 include/linux/tty.h  |  1 -
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index aa63cd3..4dbebc8 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -113,6 +113,7 @@ struct n_tty_data {
 
 	/* consumer-published */
 	size_t read_tail;
+	size_t line_start;
 
 	/* protected by output lock */
 	unsigned int column;
@@ -336,6 +337,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
 {
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
 	ldata->echo_head = ldata->echo_tail = ldata->echo_commit = 0;
+	ldata->line_start = 0;
 
 	ldata->erasing = 0;
 	bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
@@ -1396,8 +1398,6 @@ send_signal:
 		if (c == EOF_CHAR(tty)) {
 			if (read_cnt(ldata) >= N_TTY_BUF_SIZE)
 				return;
-			if (ldata->canon_head != ldata->read_head)
-				set_bit(TTY_PUSH, &tty->flags);
 			c = __DISABLED_CHAR;
 			goto handle_newline;
 		}
@@ -1604,6 +1604,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		canon_change = (old->c_lflag ^ tty->termios.c_lflag) & ICANON;
 	if (canon_change) {
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
+		ldata->line_start = 0;
 		ldata->canon_head = ldata->read_tail;
 		ldata->erasing = 0;
 		ldata->lnext = 0;
@@ -1834,6 +1835,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	size_t eol;
 	size_t tail;
 	int ret, found = 0;
+	bool eof_push = 0;
 
 	/* N.B. avoid overrun if nr == 0 */
 	n = min(*nr, read_cnt(ldata));
@@ -1860,8 +1862,10 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	n = (found + eol + size) & (N_TTY_BUF_SIZE - 1);
 	c = n;
 
-	if (found && read_buf(ldata, eol) == __DISABLED_CHAR)
+	if (found && read_buf(ldata, eol) == __DISABLED_CHAR) {
 		n--;
+		eof_push = !n && ldata->read_tail != ldata->line_start;
+	}
 
 	n_tty_trace("%s: eol:%zu found:%d n:%zu c:%zu size:%zu more:%zu\n",
 		    __func__, eol, found, n, c, size, more);
@@ -1884,9 +1888,11 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	smp_mb__after_clear_bit();
 	ldata->read_tail += c;
 
-	if (found)
+	if (found) {
+		ldata->line_start = ldata->read_tail;
 		tty_audit_push(tty);
-	return 0;
+	}
+	return eof_push ? -EAGAIN : 0;
 }
 
 extern ssize_t redirected_tty_write(struct file *, const char __user *,
@@ -1961,12 +1967,10 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	int c;
 	int minimum, time;
 	ssize_t retval = 0;
-	ssize_t size;
 	long timeout;
 	unsigned long flags;
 	int packet;
 
-do_it_again:
 	c = job_control(tty, file);
 	if (c < 0)
 		return c;
@@ -2073,7 +2077,10 @@ do_it_again:
 
 		if (ldata->icanon && !L_EXTPROC(tty)) {
 			retval = canon_copy_from_read_buf(tty, &b, &nr);
-			if (retval)
+			if (retval == -EAGAIN) {
+				retval = 0;
+				continue;
+			} else if (retval)
 				break;
 		} else {
 			int uncopied;
@@ -2101,15 +2108,8 @@ do_it_again:
 		ldata->minimum_to_wake = minimum;
 
 	__set_current_state(TASK_RUNNING);
-	size = b - buf;
-	if (size) {
-		retval = size;
-		if (nr)
-			clear_bit(TTY_PUSH, &tty->flags);
-	} else if (test_and_clear_bit(TTY_PUSH, &tty->flags)) {
-		up_read(&tty->termios_rwsem);
-		goto do_it_again;
-	}
+	if (b - buf)
+		retval = b - buf;
 
 	n_tty_set_room(tty);
 	up_read(&tty->termios_rwsem);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 7be6cf0..2e01d3c 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -664,7 +664,6 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
 
 	spin_lock_irq(&tty->ctrl_lock);
 	clear_bit(TTY_THROTTLED, &tty->flags);
-	clear_bit(TTY_PUSH, &tty->flags);
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	put_pid(tty->session);
 	put_pid(tty->pgrp);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 747c9e2..e10846a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -305,7 +305,6 @@ struct tty_file_private {
 #define TTY_EXCLUSIVE 		3	/* Exclusive open mode */
 #define TTY_DEBUG 		4	/* Debugging */
 #define TTY_DO_WRITE_WAKEUP 	5	/* Call write_wakeup after queuing new */
-#define TTY_PUSH 		6	/* n_tty private */
 #define TTY_CLOSING 		7	/* ->close() in progress */
 #define TTY_LDISC_OPEN	 	11	/* Line discipline is open */
 #define TTY_HW_COOK_OUT 	14	/* Hardware can do output cooking */
-- 
1.8.1.2

