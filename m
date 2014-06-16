Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaFPNWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:22:07 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52621 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953AbaFPNWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:22:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>,
        Karsten Keil <isdn@linux-pingi.de>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH tty-next 14/22] tty: Remove tty_wait_until_sent_from_close()
Date: Mon, 16 Jun 2014 09:17:11 -0400
Message-Id: <1402924639-5164-15-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_wait_until_sent_from_close() drops the tty lock while waiting
for the tty driver to finish sending previously accepted data (ie.,
data remaining in its write buffer and transmit fifo).

However, dropping the tty lock is a hold-over from when the tty
lock was system-wide; ie., one lock for all ttys.

Since commit 89c8d91e31f267703e365593f6bfebb9f6d2ad01,
'tty: localise the lock', dropping the tty lock has not been necessary.

CC: Karsten Keil <isdn@linux-pingi.de>
CC: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/isdn/i4l/isdn_tty.c   |  2 +-
 drivers/tty/hvc/hvc_console.c |  2 +-
 drivers/tty/hvc/hvcs.c        |  2 +-
 drivers/tty/tty_port.c        | 11 ++---------
 include/linux/tty.h           | 18 ------------------
 5 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 3c5f249..732f68a 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1587,7 +1587,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	 * line status register.
 	 */
 	if (port->flags & ASYNC_INITIALIZED) {
-		tty_wait_until_sent_from_close(tty, 3000);	/* 30 seconds timeout */
+		tty_wait_until_sent(tty, 3000);	/* 30 seconds timeout */
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
 		 * has completely drained; this is especially
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 0ff7fda..2297dc7 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -417,7 +417,7 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		 * there is no buffered data otherwise sleeps on a wait queue
 		 * waking periodically to check chars_in_buffer().
 		 */
-		tty_wait_until_sent_from_close(tty, HVC_CLOSE_WAIT);
+		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
 	} else {
 		if (hp->port.count < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 81e939e..236302d 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1230,7 +1230,7 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 		irq = hvcsd->vdev->irq;
 		spin_unlock_irqrestore(&hvcsd->lock, flags);
 
-		tty_wait_until_sent_from_close(tty, HVCS_CLOSE_WAIT);
+		tty_wait_until_sent(tty, HVCS_CLOSE_WAIT);
 
 		/*
 		 * This line is important because it tells hvcs_open that this
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 1b93357..6b6214b 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -464,10 +464,7 @@ static void tty_port_drain_delay(struct tty_port *port, struct tty_struct *tty)
 	schedule_timeout_interruptible(timeout);
 }
 
-/* Caller holds tty lock.
- * NB: may drop and reacquire tty lock (in tty_wait_until_sent_from_close())
- * so tty and tty port may have changed state (but not hung up or reopened).
- */
+/* Caller holds tty lock. */
 int tty_port_close_start(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp)
 {
@@ -505,7 +502,7 @@ int tty_port_close_start(struct tty_port *port,
 		if (tty->flow_stopped)
 			tty_driver_flush_buffer(tty);
 		if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-			tty_wait_until_sent_from_close(tty, port->closing_wait);
+			tty_wait_until_sent(tty, port->closing_wait);
 		if (port->drain_delay)
 			tty_port_drain_delay(port, tty);
 	}
@@ -545,10 +542,6 @@ EXPORT_SYMBOL(tty_port_close_end);
  * tty_port_close
  *
  * Caller holds tty lock
- *
- * NB: may drop and reacquire tty lock (in tty_port_close_start()->
- * tty_wait_until_sent_from_close()) so tty and tty_port may have changed
- * state (but not hung up or reopened).
  */
 void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 							struct file *filp)
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1c3316a..f3eb70d 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -644,24 +644,6 @@ extern void __lockfunc tty_unlock_pair(struct tty_struct *tty,
 				struct tty_struct *tty2);
 
 /*
- * this shall be called only from where BTM is held (like close)
- *
- * We need this to ensure nobody waits for us to finish while we are waiting.
- * Without this we were encountering system stalls.
- *
- * This should be indeed removed with BTM removal later.
- *
- * Locking: BTM required. Nobody is allowed to hold port->mutex.
- */
-static inline void tty_wait_until_sent_from_close(struct tty_struct *tty,
-		long timeout)
-{
-	tty_unlock(tty); /* tty->ops->close holds the BTM, drop it while waiting */
-	tty_wait_until_sent(tty, timeout);
-	tty_lock(tty);
-}
-
-/*
  * wait_event_interruptible_tty -- wait for a condition with the tty lock held
  *
  * The condition we are waiting for might take a long time to
-- 
2.0.0

