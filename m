Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaIJTpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:45:47 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40499 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753498AbaIJTpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:45:30 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 10/14] tty: Move packet mode flow control notifications to pty driver
Date: Wed, 10 Sep 2014 15:06:32 -0400
Message-Id: <1410375996-4693-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a master pty is set to packet mode, flow control changes to
the slave pty cause notifications to the master pty via reads and
polls. However, these tests are occurring for all ttys, not
just ptys.

Implement flow control packet mode notifications in the pty driver.
Only the slave side implements the flow control handlers since
packet mode is asymmetric; the master pty receives notifications
for slave-side changes, but not vice versa.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c    | 41 +++++++++++++++++++++++++++++++++++++++++
 drivers/tty/tty_io.c | 31 ++++---------------------------
 2 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 25c9bc7..c344de0 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -24,6 +24,7 @@
 #include <linux/devpts_fs.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
+#include <linux/poll.h>
 
 
 #ifdef CONFIG_UNIX98_PTYS
@@ -313,6 +314,42 @@ done:
 }
 
 /**
+ *	pty_start - start() handler
+ *	pty_stop  - stop() handler
+ *	@tty: tty being flow-controlled
+ *
+ *	Propagates the TIOCPKT status to the master pty.
+ *
+ *	NB: only the master pty can be in packet mode so only the slave
+ *	    needs start()/stop() handlers
+ */
+static void pty_start(struct tty_struct *tty)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	if (tty->link && tty->link->packet) {
+		tty->ctrl_status &= ~TIOCPKT_STOP;
+		tty->ctrl_status |= TIOCPKT_START;
+		wake_up_interruptible_poll(&tty->link->read_wait, POLLIN);
+	}
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+}
+
+static void pty_stop(struct tty_struct *tty)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	if (tty->link && tty->link->packet) {
+		tty->ctrl_status &= ~TIOCPKT_START;
+		tty->ctrl_status |= TIOCPKT_STOP;
+		wake_up_interruptible_poll(&tty->link->read_wait, POLLIN);
+	}
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+}
+
+/**
  *	pty_common_install		-	set up the pty pair
  *	@driver: the pty driver
  *	@tty: the tty being instantiated
@@ -472,6 +509,8 @@ static const struct tty_operations slave_pty_ops_bsd = {
 	.set_termios = pty_set_termios,
 	.cleanup = pty_cleanup,
 	.resize = pty_resize,
+	.start = pty_start,
+	.stop = pty_stop,
 	.remove = pty_remove
 };
 
@@ -647,6 +686,8 @@ static const struct tty_operations pty_unix98_ops = {
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
+	.start = pty_start,
+	.stop = pty_stop,
 	.shutdown = pty_unix98_shutdown,
 	.cleanup = pty_cleanup,
 };
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b898e29..55b9103 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -922,8 +922,7 @@ void no_tty(void)
  *	stop_tty	-	propagate flow control
  *	@tty: tty to stop
  *
- *	Perform flow control to the driver. For PTY/TTY pairs we
- *	must also propagate the TIOCKPKT status. May be called
+ *	Perform flow control to the driver. May be called
  *	on an already stopped device and will not re-call the driver
  *	method.
  *
@@ -933,24 +932,14 @@ void no_tty(void)
  *	but not always.
  *
  *	Locking:
- *		ctrl_lock
  *		flow_lock
  */
 
 void __stop_tty(struct tty_struct *tty)
 {
-	unsigned long flags;
-
 	if (tty->stopped)
 		return;
 	tty->stopped = 1;
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	if (tty->link && tty->link->packet) {
-		tty->ctrl_status &= ~TIOCPKT_START;
-		tty->ctrl_status |= TIOCPKT_STOP;
-		wake_up_interruptible_poll(&tty->link->read_wait, POLLIN);
-	}
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->ops->stop)
 		(tty->ops->stop)(tty);
 }
@@ -969,33 +958,21 @@ EXPORT_SYMBOL(stop_tty);
  *	start_tty	-	propagate flow control
  *	@tty: tty to start
  *
- *	Start a tty that has been stopped if at all possible. Perform
- *	any necessary wakeups and propagate the TIOCPKT status. If this
- *	is the tty was previous stopped and is being started then the
- *	driver start method is invoked and the line discipline woken.
+ *	Start a tty that has been stopped if at all possible. If this
+ *	tty was previous stopped and is now being started, the driver
+ *	start method is invoked and the line discipline woken.
  *
  *	Locking:
- *		ctrl_lock
  *		flow_lock
  */
 
 void __start_tty(struct tty_struct *tty)
 {
-	unsigned long flags;
-
 	if (!tty->stopped || tty->flow_stopped)
 		return;
 	tty->stopped = 0;
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	if (tty->link && tty->link->packet) {
-		tty->ctrl_status &= ~TIOCPKT_STOP;
-		tty->ctrl_status |= TIOCPKT_START;
-		wake_up_interruptible_poll(&tty->link->read_wait, POLLIN);
-	}
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->ops->start)
 		(tty->ops->start)(tty);
-	/* If we have a running line discipline it may need kicking */
 	tty_wakeup(tty);
 }
 
-- 
2.1.0

