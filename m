Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbaJPVAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:00:11 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33230 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643AbaJPVAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:00:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 23/27] pty, n_tty: Simplify input processing on final close
Date: Thu, 16 Oct 2014 16:25:21 -0400
Message-Id: <1413491125-20134-24-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When releasing one end of a pty pair, that end may just have written
to the other, which the input processing worker, flush_to_ldisc(), is
still working on but has not completed the copy to the other end's
read buffer. So input may not appear to be available to a waiting
reader but yet TTY_OTHER_CLOSED is now observed. The n_tty line
discipline has worked around this by waiting for input processing
to complete and then re-checking if input is available before
exiting with -EIO.

Since the tty/ldisc lock reordering, the wait for input processing
to complete can now occur during final close before setting
TTY_OTHER_CLOSED. In this way, a waiting reader is guaranteed to
see input available (if any) before observing TTY_OTHER_CLOSED.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 46 ++++++++++++++++++++--------------------------
 drivers/tty/pty.c   |  1 +
 2 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 38ac7b9..a8ec82d 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2197,34 +2197,28 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 
 		if (!input_available_p(tty, 0)) {
 			if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
-				up_read(&tty->termios_rwsem);
-				tty_flush_to_ldisc(tty);
-				down_read(&tty->termios_rwsem);
-				if (!input_available_p(tty, 0)) {
-					retval = -EIO;
-					break;
-				}
-			} else {
-				if (tty_hung_up_p(file))
-					break;
-				if (!timeout)
-					break;
-				if (file->f_flags & O_NONBLOCK) {
-					retval = -EAGAIN;
-					break;
-				}
-				if (signal_pending(current)) {
-					retval = -ERESTARTSYS;
-					break;
-				}
-				n_tty_set_room(tty);
-				up_read(&tty->termios_rwsem);
+				retval = -EIO;
+				break;
+			}
+			if (tty_hung_up_p(file))
+				break;
+			if (!timeout)
+				break;
+			if (file->f_flags & O_NONBLOCK) {
+				retval = -EAGAIN;
+				break;
+			}
+			if (signal_pending(current)) {
+				retval = -ERESTARTSYS;
+				break;
+			}
+			n_tty_set_room(tty);
+			up_read(&tty->termios_rwsem);
 
-				timeout = schedule_timeout(timeout);
+			timeout = schedule_timeout(timeout);
 
-				down_read(&tty->termios_rwsem);
-				continue;
-			}
+			down_read(&tty->termios_rwsem);
+			continue;
 		}
 		__set_current_state(TASK_RUNNING);
 
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 09fb513..461ca53 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -53,6 +53,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	/* Review - krefs on tty_link ?? */
 	if (!tty->link)
 		return;
+	tty_flush_to_ldisc(tty->link);
 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	wake_up_interruptible(&tty->link->read_wait);
 	wake_up_interruptible(&tty->link->write_wait);
-- 
2.1.1

