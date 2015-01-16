Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbbAPUF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:05:57 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:42659 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbbAPUFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:05:52 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Christian Riesch <christian.riesch@omicron.at>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Denis Du <dudenis2000@yahoo.ca>,
        =?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 1/6] n_tty: Eliminate receive_room() from consumer/exclusive paths
Date: Fri, 16 Jan 2015 15:05:34 -0500
Message-Id: <1421438739-29672-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421438739-29672-1-git-send-email-peter@hurleysoftware.com>
References: <1421113668-20468-1-git-send-email-peter@hurleysoftware.com>
 <1421438739-29672-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The input worker never reschedules itself; it only processes input until
either there is no more input or the read buffer is full. So the reader
is responsible for restarting the input worker only if the read buffer
was previously full (no_room == 1) _and_ space is now available to process
more input because the reader has consumed data from the read buffer.

However, computing the actual space available is not required to determine
if the reader has consumed data from the read buffer. This condition is
evaluated in 5 situations, each of which the space avail is already known:
1. n_tty_flush_buffer() - the read buffer is empty; kick the worker
2. n_tty_set_termios() - no data has been consumed; do not kick the worker
       (although it may have kicked the reader so data _will be_ consumed)
3. n_tty_check_unthrottle - avail space > 3968; kick the worker
4. n_tty_read, before leaving - only kick the worker if the reader has
       moved the tail. This prevents unnecessarily kicking the worker
       when timeout-style reading is used.
5. n_tty_read, before sleeping - although it is possible for the read
       buffer to be full and input_available_p() to be false, this can
       only happen when the input worker is racing the reader, in which
       case the reader will have been woken and won't sleep.

Rename n_tty_set_room() to n_tty_kick_worker() to reflect what the
function actually does.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4ddfa60..b60b043 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -187,10 +187,10 @@ static int receive_room(struct tty_struct *tty)
 }
 
 /**
- *	n_tty_set_room	-	receive space
+ *	n_tty_kick_worker - start input worker (if required)
  *	@tty: terminal
  *
- *	Re-schedules the flip buffer work if space just became available.
+ *	Re-schedules the flip buffer work if it may have stopped
  *
  *	Caller holds exclusive termios_rwsem
  *	   or
@@ -198,12 +198,12 @@ static int receive_room(struct tty_struct *tty)
  *		holds non-exclusive termios_rwsem
  */
 
-static void n_tty_set_room(struct tty_struct *tty)
+static void n_tty_kick_worker(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
-	/* Did this open up the receive buffer? We may need to flip */
-	if (unlikely(ldata->no_room) && receive_room(tty)) {
+	/* Did the input worker stop? Restart it */
+	if (unlikely(ldata->no_room)) {
 		ldata->no_room = 0;
 
 		WARN_RATELIMIT(tty->port->itty == NULL,
@@ -274,7 +274,7 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
 			return;
 		if (!tty->count)
 			return;
-		n_tty_set_room(tty);
+		n_tty_kick_worker(tty);
 		n_tty_write_wakeup(tty->link);
 		if (waitqueue_active(&tty->link->write_wait))
 			wake_up_interruptible_poll(&tty->link->write_wait, POLLOUT);
@@ -296,7 +296,7 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
 			break;
 		if (!tty->count)
 			break;
-		n_tty_set_room(tty);
+		n_tty_kick_worker(tty);
 		unthrottled = tty_unthrottle_safe(tty);
 		if (!unthrottled)
 			break;
@@ -379,7 +379,7 @@ static void n_tty_flush_buffer(struct tty_struct *tty)
 {
 	down_write(&tty->termios_rwsem);
 	reset_buffer_flags(tty->disc_data);
-	n_tty_set_room(tty);
+	n_tty_kick_worker(tty);
 
 	if (tty->link)
 		n_tty_packet_mode_flush(tty);
@@ -1817,7 +1817,6 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		else
 			ldata->real_raw = 0;
 	}
-	n_tty_set_room(tty);
 	/*
 	 * Fix tty hang when I_IXON(tty) is cleared, but the tty
 	 * been stopped by STOP_CHAR(tty) before it.
@@ -2130,6 +2129,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	ssize_t retval = 0;
 	long timeout;
 	int packet;
+	size_t tail;
 
 	c = job_control(tty, file);
 	if (c < 0)
@@ -2166,6 +2166,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	}
 
 	packet = tty->packet;
+	tail = ldata->read_tail;
 
 	add_wait_queue(&tty->read_wait, &wait);
 	while (nr) {
@@ -2208,7 +2209,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 				retval = -ERESTARTSYS;
 				break;
 			}
-			n_tty_set_room(tty);
 			up_read(&tty->termios_rwsem);
 
 			timeout = wait_woken(&wait, TASK_INTERRUPTIBLE,
@@ -2253,7 +2253,8 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 		if (time)
 			timeout = time;
 	}
-	n_tty_set_room(tty);
+	if (tail != ldata->read_tail)
+		n_tty_kick_worker(tty);
 	up_read(&tty->termios_rwsem);
 
 	remove_wait_queue(&tty->read_wait, &wait);
-- 
2.2.2

