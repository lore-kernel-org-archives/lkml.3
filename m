Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab3DOPlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:41:46 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45873 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3DOPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:32:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 12/24] n_tty: Access termios values safely
Date: Mon, 15 Apr 2013 11:19:16 -0400
Message-Id: <1366039168-8510-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use termios_rwsem to guarantee safe access to the termios values.
This is particularly important for N_TTY as changing certain termios
settings alters the mode of operation.

termios_rwsem must be dropped across throttle/unthrottle since
those functions claim the termios_rwsem exclusively (to guarantee
safe access to the termios and for mutual exclusion).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4389b6f..924a3f5 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1492,10 +1492,14 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	 * canonical mode and don't have a newline yet!
 	 */
 	while (1) {
+		int throttled;
 		tty_set_flow_change(tty, TTY_THROTTLE_SAFE);
 		if (receive_room(tty) >= TTY_THRESHOLD_THROTTLE)
 			break;
-		if (!tty_throttle_safe(tty))
+		up_read(&tty->termios_rwsem);
+		throttled = tty_throttle_safe(tty);
+		down_read(&tty->termios_rwsem);
+		if (!throttled)
 			break;
 	}
 	__tty_set_flow_change(tty, 0);
@@ -1504,7 +1508,9 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			      char *fp, int count)
 {
+	down_read(&tty->termios_rwsem);
 	__receive_buf(tty, cp, fp, count);
+	up_read(&tty->termios_rwsem);
 }
 
 static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
@@ -1513,6 +1519,8 @@ static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
 	struct n_tty_data *ldata = tty->disc_data;
 	int room;
 
+	down_read(&tty->termios_rwsem);
+
 	tty->receive_room = room = receive_room(tty);
 	if (!room)
 		ldata->no_room = 1;
@@ -1520,6 +1528,8 @@ static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
 	if (count)
 		__receive_buf(tty, cp, fp, count);
 
+	up_read(&tty->termios_rwsem);
+
 	return count;
 }
 
@@ -1932,6 +1942,8 @@ do_it_again:
 	if (c < 0)
 		return c;
 
+	down_read(&tty->termios_rwsem);
+
 	minimum = time = 0;
 	timeout = MAX_SCHEDULE_TIMEOUT;
 	if (!ldata->icanon) {
@@ -1953,11 +1965,15 @@ do_it_again:
 	 *	Internal serialization of reads.
 	 */
 	if (file->f_flags & O_NONBLOCK) {
-		if (!mutex_trylock(&ldata->atomic_read_lock))
+		if (!mutex_trylock(&ldata->atomic_read_lock)) {
+			up_read(&tty->termios_rwsem);
 			return -EAGAIN;
+		}
 	} else {
-		if (mutex_lock_interruptible(&ldata->atomic_read_lock))
+		if (mutex_lock_interruptible(&ldata->atomic_read_lock)) {
+			up_read(&tty->termios_rwsem);
 			return -ERESTARTSYS;
+		}
 	}
 	packet = tty->packet;
 
@@ -2007,7 +2023,11 @@ do_it_again:
 				break;
 			}
 			n_tty_set_room(tty);
+			up_read(&tty->termios_rwsem);
+
 			timeout = schedule_timeout(timeout);
+
+			down_read(&tty->termios_rwsem);
 			continue;
 		}
 		__set_current_state(TASK_RUNNING);
@@ -2046,13 +2066,17 @@ do_it_again:
 		 * we won't get any more characters.
 		 */
 		while (1) {
+			int unthrottled;
 			tty_set_flow_change(tty, TTY_UNTHROTTLE_SAFE);
 			if (chars_in_buffer(tty) > TTY_THRESHOLD_UNTHROTTLE)
 				break;
 			if (!tty->count)
 				break;
 			n_tty_set_room(tty);
-			if (!tty_unthrottle_safe(tty))
+			up_read(&tty->termios_rwsem);
+			unthrottled = tty_unthrottle_safe(tty);
+			down_read(&tty->termios_rwsem);
+			if (!unthrottled)
 				break;
 		}
 		__tty_set_flow_change(tty, 0);
@@ -2074,10 +2098,13 @@ do_it_again:
 		retval = size;
 		if (nr)
 			clear_bit(TTY_PUSH, &tty->flags);
-	} else if (test_and_clear_bit(TTY_PUSH, &tty->flags))
+	} else if (test_and_clear_bit(TTY_PUSH, &tty->flags)) {
+		up_read(&tty->termios_rwsem);
 		goto do_it_again;
+	}
 
 	n_tty_set_room(tty);
+	up_read(&tty->termios_rwsem);
 	return retval;
 }
 
@@ -2118,6 +2145,8 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			return retval;
 	}
 
+	down_read(&tty->termios_rwsem);
+
 	/* Write out any echoed characters that are still pending */
 	process_echoes(tty);
 
@@ -2171,13 +2200,18 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			retval = -EAGAIN;
 			break;
 		}
+		up_read(&tty->termios_rwsem);
+
 		schedule();
+
+		down_read(&tty->termios_rwsem);
 	}
 break_out:
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&tty->write_wait, &wait);
 	if (b - buf != nr && tty->fasync)
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+	up_read(&tty->termios_rwsem);
 	return (b - buf) ? b - buf : retval;
 }
 
-- 
1.8.1.2

