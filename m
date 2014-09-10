Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaIJTHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:07:46 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43852 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753361AbaIJTHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:07:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 09/14] tty: Serialize tty flow control changes with flow_lock
Date: Wed, 10 Sep 2014 15:06:31 -0400
Message-Id: <1410375996-4693-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without serialization, the flow control state can become inverted
wrt. the actual hardware state. For example,

CPU 0                          | CPU 1
stop_tty()                     |
  lock ctrl_lock               |
  tty->stopped = 1             |
  unlock ctrl_lock             |
                               | start_tty()
                               |   lock ctrl_lock
                               |   tty->stopped = 0
                               |   unlock ctrl_lock
                               |   driver->start()
  driver->stop()               |

In this case, the flow control state now indicates the tty has
been started, but the actual hardware state has actually been stopped.

Introduce tty->flow_lock spinlock to serialize tty flow control changes.
Split out unlocked __start_tty()/__stop_tty() flavors for use by
ioctl(TCXONC) in follow-on patch.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c       | 39 ++++++++++++++++++++++++++++-----------
 include/linux/tty.h        |  5 ++++-
 include/linux/tty_driver.h |  4 ++++
 3 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 714320b..b898e29 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -933,18 +933,18 @@ void no_tty(void)
  *	but not always.
  *
  *	Locking:
- *		Uses the tty control lock internally
+ *		ctrl_lock
+ *		flow_lock
  */
 
-void stop_tty(struct tty_struct *tty)
+void __stop_tty(struct tty_struct *tty)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	if (tty->stopped) {
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+	if (tty->stopped)
 		return;
-	}
 	tty->stopped = 1;
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_START;
 		tty->ctrl_status |= TIOCPKT_STOP;
@@ -955,6 +955,14 @@ void stop_tty(struct tty_struct *tty)
 		(tty->ops->stop)(tty);
 }
 
+void stop_tty(struct tty_struct *tty)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->flow_lock, flags);
+	__stop_tty(tty);
+	spin_unlock_irqrestore(&tty->flow_lock, flags);
+}
 EXPORT_SYMBOL(stop_tty);
 
 /**
@@ -968,17 +976,17 @@ EXPORT_SYMBOL(stop_tty);
  *
  *	Locking:
  *		ctrl_lock
+ *		flow_lock
  */
 
-void start_tty(struct tty_struct *tty)
+void __start_tty(struct tty_struct *tty)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	if (!tty->stopped || tty->flow_stopped) {
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+	if (!tty->stopped || tty->flow_stopped)
 		return;
-	}
 	tty->stopped = 0;
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_STOP;
 		tty->ctrl_status |= TIOCPKT_START;
@@ -991,6 +999,14 @@ void start_tty(struct tty_struct *tty)
 	tty_wakeup(tty);
 }
 
+void start_tty(struct tty_struct *tty)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->flow_lock, flags);
+	__start_tty(tty);
+	spin_unlock_irqrestore(&tty->flow_lock, flags);
+}
 EXPORT_SYMBOL(start_tty);
 
 /* We limit tty time update visibility to every 8 seconds or so. */
@@ -3031,6 +3047,7 @@ void initialize_tty_struct(struct tty_struct *tty,
 	INIT_WORK(&tty->hangup_work, do_tty_hangup);
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->ctrl_lock);
+	spin_lock_init(&tty->flow_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index a707196..af26171 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -252,6 +252,7 @@ struct tty_struct {
 	struct rw_semaphore termios_rwsem;
 	struct mutex winsize_mutex;
 	spinlock_t ctrl_lock;
+	spinlock_t flow_lock;
 	/* Termios values are protected by the termios rwsem */
 	struct ktermios termios, termios_locked;
 	struct termiox *termiox;	/* May be NULL for unsupported */
@@ -261,7 +262,7 @@ struct tty_struct {
 	unsigned long flags;
 	int count;
 	struct winsize winsize;		/* winsize_mutex */
-	int stopped;
+	int stopped;			/* flow_lock */
 	int flow_stopped;
 	int hw_stopped;
 	int packet;
@@ -400,7 +401,9 @@ extern int tty_paranoia_check(struct tty_struct *tty, struct inode *inode,
 extern char *tty_name(struct tty_struct *tty, char *buf);
 extern void tty_wait_until_sent(struct tty_struct *tty, long timeout);
 extern int tty_check_change(struct tty_struct *tty);
+extern void __stop_tty(struct tty_struct *tty);
 extern void stop_tty(struct tty_struct *tty);
+extern void __start_tty(struct tty_struct *tty);
 extern void start_tty(struct tty_struct *tty);
 extern int tty_register_driver(struct tty_driver *driver);
 extern int tty_unregister_driver(struct tty_driver *driver);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index e48c608..92e337c 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -152,6 +152,8 @@
  * 	This routine notifies the tty driver that it should stop
  * 	outputting characters to the tty device.  
  *
+ *	Called with ->flow_lock held. Serialized with start() method.
+ *
  *	Optional:
  *
  *	Note: Call stop_tty not this method.
@@ -161,6 +163,8 @@
  * 	This routine notifies the tty driver that it resume sending
  *	characters to the tty device.
  *
+ *	Called with ->flow_lock held. Serialized with stop() method.
+ *
  *	Optional:
  *
  *	Note: Call start_tty not this method.
-- 
2.1.0

