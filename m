Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbbAQUmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 15:42:39 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:43910 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbbAQUmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 15:42:22 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3/3] n_tty: Fix signal handling flushes
Date: Sat, 17 Jan 2015 15:42:06 -0500
Message-Id: <1421527326-4368-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421527326-4368-1-git-send-email-peter@hurleysoftware.com>
References: <1421527326-4368-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BRKINT and ISIG requires input and output flush when a signal char
is received. However, the order of operations is significant since
parallel i/o may be ongoing.

Merge the signal handling for BRKINT with ISIG handling.

Process the signal first. This ensures any ongoing i/o is aborted;
without this, a waiting writer may continue writing after the flush
occurs and after the signal char has been echoed.

Write lock the termios_rwsem, which excludes parallel writers from
pushing new i/o until after the output buffers are flushed; claiming
the write lock is necessary anyway to exclude parallel readers while
the read buffer is flushed.

Subclass the termios_rwsem for ptys since the slave pty performing
the flush may appear to reorder the termios_rwsem->tty buffer lock
lock order; adding annotation clarifies that
  slave tty_buffer lock-> slave termios_rwsem -> master tty_buffer lock
is a valid lock order.

Flush the echo buffer. In this context, the echo buffer is 'output'.
Otherwise, the output will appear discontinuous because the output buffer
was cleared which contains older output than the echo buffer.

Open-code the read buffer flush since the input worker does not need
kicking (this is the input worker).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 45 ++++++++++++++++++++++++++++++---------------
 drivers/tty/pty.c   |  1 +
 include/linux/tty.h |  3 +++
 3 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 031a36b..ea26ea6 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1088,16 +1088,45 @@ static void eraser(unsigned char c, struct tty_struct *tty)
  *	Called when a signal is being sent due to terminal input.
  *	Called from the driver receive_buf path so serialized.
  *
+ *	Performs input and output flush if !NOFLSH. In this context, the echo
+ *	buffer is 'output'. The signal is processed first to alert any current
+ *	readers or writers to discontinue and exit their i/o loops.
+ *
  *	Locking: ctrl_lock
  */
 
 static void isig(int sig, struct tty_struct *tty)
 {
+	struct n_tty_data *ldata = tty->disc_data;
 	struct pid *tty_pgrp = tty_get_pgrp(tty);
 	if (tty_pgrp) {
 		kill_pgrp(tty_pgrp, sig, 1);
 		put_pid(tty_pgrp);
 	}
+
+	if (!L_NOFLSH(tty)) {
+		up_read(&tty->termios_rwsem);
+		down_write(&tty->termios_rwsem);
+
+		/* clear echo buffer */
+		mutex_lock(&ldata->output_lock);
+		ldata->echo_head = ldata->echo_tail = 0;
+		ldata->echo_mark = ldata->echo_commit = 0;
+		mutex_unlock(&ldata->output_lock);
+
+		/* clear output buffer */
+		tty_driver_flush_buffer(tty);
+
+		/* clear input buffer */
+		reset_buffer_flags(tty->disc_data);
+
+		/* notify pty master of flush */
+		if (tty->link)
+			n_tty_packet_mode_flush(tty);
+
+		up_write(&tty->termios_rwsem);
+		down_read(&tty->termios_rwsem);
+	}
 }
 
 /**
@@ -1121,13 +1150,6 @@ static void n_tty_receive_break(struct tty_struct *tty)
 		return;
 	if (I_BRKINT(tty)) {
 		isig(SIGINT, tty);
-		if (!L_NOFLSH(tty)) {
-			/* flushing needs exclusive termios_rwsem */
-			up_read(&tty->termios_rwsem);
-			n_tty_flush_buffer(tty);
-			tty_driver_flush_buffer(tty);
-			down_read(&tty->termios_rwsem);
-		}
 		return;
 	}
 	if (I_PARMRK(tty)) {
@@ -1197,13 +1219,7 @@ static void n_tty_receive_parity_error(struct tty_struct *tty, unsigned char c)
 static void
 n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
 {
-	if (!L_NOFLSH(tty)) {
-		/* flushing needs exclusive termios_rwsem */
-		up_read(&tty->termios_rwsem);
-		n_tty_flush_buffer(tty);
-		tty_driver_flush_buffer(tty);
-		down_read(&tty->termios_rwsem);
-	}
+	isig(signal, tty);
 	if (I_IXON(tty))
 		start_tty(tty);
 	if (L_ECHO(tty)) {
@@ -1211,7 +1227,6 @@ n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
 		commit_echoes(tty);
 	} else
 		process_echoes(tty);
-	isig(signal, tty);
 	return;
 }
 
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index e0007d1..ee06b77 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -392,6 +392,7 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 		goto err_put_module;
 
 	tty_set_lock_subclass(o_tty);
+	lockdep_set_subclass(&o_tty->termios_rwsem, TTY_LOCK_SLAVE);
 
 	if (legacy) {
 		/* We always use new tty termios data so we can do this
diff --git a/include/linux/tty.h b/include/linux/tty.h
index c60efad..358a337 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -25,6 +25,9 @@
  *
  * legacy_mutex - Nested tty locks are necessary for releasing pty pairs.
  *		  The stable lock order is master pty first, then slave pty.
+ * termios_rwsem - The stable lock order is tty_buffer lock->termios_rwsem.
+ *		   Subclassing this lock enables the slave pty to hold its
+ *		   termios_rwsem when claiming the master tty_buffer lock.
  * tty_buffer lock - slave ptys can claim nested buffer lock when handling
  *		     signal chars. The stable lock order is slave pty, then
  *		     master.
-- 
2.2.2

