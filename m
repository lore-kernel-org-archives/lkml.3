Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaIJVKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:10:45 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54385 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752282AbaIJVKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:10:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [RFC] tty: Override and virtualize flow control for tty_send_xchar()
Date: Wed, 10 Sep 2014 17:10:31 -0400
Message-Id: <1410383431-4578-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm offering this patch as an RFC rather than a PATCH because I think
it's added complexity is not worth the hassle, given that it is only
needed for drivers which don't support the send_xchar() method.

But it does complete the flow control patch series, by fixing a
problem with flow control where a driver that does not support the
send_xchar() method can accidentally restore a stopped terminal,
even though other flow control has restarted the terminal.

Regards,
Peter Hurley

--- >% ---
Subject: [RFC] tty: Override and virtualize flow control for
 tty_send_xchar()

When sending START/STOP from tcflow(TCIxxx), if the tty driver does
not support the send_xchar() method, tty_send_xchar() uses the
normal driver write() routine. Because the tty may stopped,
tty_send_xchar() must override the flow control state and restore
it after START/STOP has been written.

Add file-scope helper, force_start_tty(), which saves the current
flow control state, and starts the tty if necessary (but not if
the output flow has been stopped by tcflow(TCOOFF)). While the
flow control state is overridden, stop_tty() and start_tty()
continue to track the virtual flow control state without notifying
the driver (so the actual flow state does not change).

If, while the override is on, tcflow(TCOOFF) turns off flow control,
the override is ended and the actual flow control is stopped.

Also, add file-scope helper, restore_tty_stopped(), which restores
the actual flow control state to the tracked virtual flow control
state, stopping the tty if necessary.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++------
 include/linux/tty.h  |  4 +++-
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 54e359b..11461ba 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -937,6 +937,13 @@ void no_tty(void)
 
 void __stop_tty(struct tty_struct *tty)
 {
+	if (tty->override_stopped) {
+		if (!tty->flow_stopped) {
+			tty->virt_stopped = 1;
+			return;
+		}
+		tty->override_stopped = 0;
+	}
 	if (tty->stopped)
 		return;
 	tty->stopped = 1;
@@ -968,6 +975,13 @@ EXPORT_SYMBOL(stop_tty);
 
 void __start_tty(struct tty_struct *tty)
 {
+	if (tty->override_stopped) {
+		if (!tty->flow_stopped) {
+			tty->virt_stopped = 0;
+			return;
+		}
+		tty->override_stopped = 0;
+	}
 	if (!tty->stopped || tty->flow_stopped)
 		return;
 	tty->stopped = 0;
@@ -986,6 +1000,35 @@ void start_tty(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(start_tty);
 
+/* Used by tty_send_xchar() to force the tty to start */
+static void force_start_tty(struct tty_struct *tty)
+{
+	spin_lock_irq(&tty->flow_lock);
+	if (!tty->flow_stopped) {
+		tty->override_stopped = 1;
+		tty->virt_stopped = tty->stopped;
+		if (tty->stopped) {
+			tty->stopped = 0;
+			if (tty->ops->start)
+				tty->ops->start(tty);
+			tty_wakeup(tty);
+		}
+	}
+	spin_unlock_irq(&tty->flow_lock);
+}
+
+static void restore_tty_stopped(struct tty_struct *tty)
+{
+	spin_lock_irq(&tty->flow_lock);
+	if (tty->override_stopped) {
+		tty->override_stopped = 0;
+		tty->stopped = tty->virt_stopped;
+		if (tty->stopped && tty->ops->stop)
+			tty->ops->stop(tty);
+	}
+	spin_unlock_irq(&tty->flow_lock);
+}
+
 /* We limit tty time update visibility to every 8 seconds or so. */
 static void tty_update_time(struct timespec *time)
 {
@@ -1241,8 +1284,6 @@ ssize_t redirected_tty_write(struct file *file, const char __user *buf,
 
 int tty_send_xchar(struct tty_struct *tty, char ch)
 {
-	int	was_stopped = tty->stopped;
-
 	if (tty->ops->send_xchar) {
 		tty->ops->send_xchar(tty, ch);
 		return 0;
@@ -1251,11 +1292,10 @@ int tty_send_xchar(struct tty_struct *tty, char ch)
 	if (tty_write_lock(tty, 0) < 0)
 		return -ERESTARTSYS;
 
-	if (was_stopped)
-		start_tty(tty);
+	force_start_tty(tty);
 	tty->ops->write(tty, &ch, 1);
-	if (was_stopped)
-		stop_tty(tty);
+	restore_tty_stopped(tty);
+
 	tty_write_unlock(tty);
 	return 0;
 }
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 7a0a796..9c79497 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -264,7 +264,9 @@ struct tty_struct {
 	struct winsize winsize;		/* winsize_mutex */
 	unsigned long stopped:1,	/* flow_lock */
 		      flow_stopped:1,
-		      unused:62;
+		      virt_stopped:1,
+		      override_stopped:1,
+		      unused:60;
 	int hw_stopped;
 	unsigned long ctrl_status:8,	/* ctrl_lock */
 		      packet:1,
-- 
2.1.0

