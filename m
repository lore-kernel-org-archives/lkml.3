Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3C0LsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:48:22 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54586 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3C0LsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:48:18 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Min Zhang <mzhang@mvista.com>, Ilya Zykov <linux@izyk.ru>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 12/18] n_tty: Access termios values safely
Date: Wed, 27 Mar 2013 07:44:02 -0400
Message-Id: <1364384648-6636-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
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
 drivers/tty/n_tty.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index fa463a9..985e0a3 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1457,6 +1457,8 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	char	buf[64];
 	unsigned long cpuflags;
 
+	down_read(&tty->termios_rwsem);
+
 	if (ldata->real_raw) {
 		raw_spin_lock_irqsave(&ldata->read_lock, cpuflags);
 		i = min(N_TTY_BUF_SIZE - read_cnt(ldata),
@@ -1514,13 +1516,19 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
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
+
+	up_read(&tty->termios_rwsem);
 }
 
 int is_ignored(int sig)
@@ -1932,6 +1940,8 @@ do_it_again:
 	if (c < 0)
 		return c;
 
+	down_read(&tty->termios_rwsem);
+
 	minimum = time = 0;
 	timeout = MAX_SCHEDULE_TIMEOUT;
 	if (!ldata->icanon) {
@@ -1953,11 +1963,15 @@ do_it_again:
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
 
@@ -2007,7 +2021,11 @@ do_it_again:
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
@@ -2046,13 +2064,17 @@ do_it_again:
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
@@ -2074,9 +2096,12 @@ do_it_again:
 		retval = size;
 		if (nr)
 			clear_bit(TTY_PUSH, &tty->flags);
-	} else if (test_and_clear_bit(TTY_PUSH, &tty->flags))
+	} else if (test_and_clear_bit(TTY_PUSH, &tty->flags)) {
+		up_read(&tty->termios_rwsem);
 		goto do_it_again;
+	}
 
+	up_read(&tty->termios_rwsem);
 	n_tty_set_room(tty);
 	return retval;
 }
-- 
1.8.1.2

