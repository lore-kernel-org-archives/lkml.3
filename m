Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaKERuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:50:11 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57560 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751692AbaKERuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:50:08 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 22/26] pty, n_tty: Simplify input processing on final close
Date: Wed,  5 Nov 2014 12:13:05 -0500
Message-Id: <1415207589-15967-23-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
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

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 46 ++++++++++++++++++++--------------------------
 drivers/tty/pty.c   |  1 +
 2 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 0cb0e12..112eda7 100644
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
index bee9776..a9d256d 100644
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
2.1.3

