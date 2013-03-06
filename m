Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3CFNV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:21:28 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:48792 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab3CFNVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:21:22 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Vincent Pillet <vincentx.pillet@intel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 2/3] tty: Add safe tty throttle/unthrottle functions
Date: Wed,  6 Mar 2013 08:20:52 -0500
Message-Id: <1362576053-1295-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362576053-1295-1-git-send-email-peter@hurleysoftware.com>
References: <1362576053-1295-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty driver can become stuck throttled due to race conditions
between throttle and unthrottle, when the decision to throttle
or unthrottle is conditional. The following example helps to
illustrate the race:

  CPU 0                        |  CPU 1
                               |
if (condition A)               |
                               | <processing such that A not true>
                               | if (!condition A)
                               |     unthrottle()
    throttle()                 |
                               |

Note the converse is also possible; ie.,

  CPU 0                        |  CPU 1
                               |
                               | if (!condition A)
<processing such that A true>  |
if (condition A)               |
    throttle()                 |
                               |     unthrottle()
                               |

Add new throttle/unthrottle functions based on the familiar model
of task state and schedule/wake. For example,

    while (1) {
        tty_set_flow_change(tty, TTY_THROTTLE_SAFE);
        if (!condition)
            break;
        if (!tty_throttle_safe(tty))
            break;
    }
    __tty_set_flow_change(tty, 0);

In this example, if an unthrottle occurs after the condition is
evaluated but before tty_throttle_safe(), then tty_throttle_safe()
will return non-zero, looping and forcing the re-evaluation of
condition.

Reported-by: Vincent Pillet <vincentx.pillet@intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ioctl.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/tty.h     | 18 ++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index d58b92c..132d452 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -106,6 +106,7 @@ void tty_throttle(struct tty_struct *tty)
 	if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
 	    tty->ops->throttle)
 		tty->ops->throttle(tty);
+	tty->flow_change = 0;
 	mutex_unlock(&tty->termios_mutex);
 }
 EXPORT_SYMBOL(tty_throttle);
@@ -129,11 +130,74 @@ void tty_unthrottle(struct tty_struct *tty)
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
 	    tty->ops->unthrottle)
 		tty->ops->unthrottle(tty);
+	tty->flow_change = 0;
 	mutex_unlock(&tty->termios_mutex);
 }
 EXPORT_SYMBOL(tty_unthrottle);
 
 /**
+ *	tty_throttle_safe	-	flow control
+ *	@tty: terminal
+ *
+ *	Similar to tty_throttle() but will only attempt throttle
+ *	if tty->flow_change is TTY_THROTTLE_SAFE. Prevents an accidental
+ *	throttle due to race conditions when throttling is conditional
+ *	on factors evaluated prior to throttling.
+ *
+ *	Returns 0 if tty is throttled (or was already throttled)
+ */
+
+int tty_throttle_safe(struct tty_struct *tty)
+{
+	int ret = 0;
+
+	mutex_lock(&tty->termios_mutex);
+	if (!test_bit(TTY_THROTTLED, &tty->flags)) {
+		if (tty->flow_change != TTY_THROTTLE_SAFE)
+			ret = 1;
+		else {
+			__set_bit(TTY_THROTTLED, &tty->flags);
+			if (tty->ops->throttle)
+				tty->ops->throttle(tty);
+		}
+	}
+	mutex_unlock(&tty->termios_mutex);
+
+	return ret;
+}
+
+/**
+ *	tty_unthrottle_safe	-	flow control
+ *	@tty: terminal
+ *
+ *	Similar to tty_unthrottle() but will only attempt unthrottle
+ *	if tty->flow_change is TTY_UNTHROTTLE_SAFE. Prevents an accidental
+ *	unthrottle due to race conditions when unthrottling is conditional
+ *	on factors evaluated prior to unthrottling.
+ *
+ *	Returns 0 if tty is unthrottled (or was already unthrottled)
+ */
+
+int tty_unthrottle_safe(struct tty_struct *tty)
+{
+	int ret = 0;
+
+	mutex_lock(&tty->termios_mutex);
+	if (test_bit(TTY_THROTTLED, &tty->flags)) {
+		if (tty->flow_change != TTY_UNTHROTTLE_SAFE)
+			ret = 1;
+		else {
+			__clear_bit(TTY_THROTTLED, &tty->flags);
+			if (tty->ops->unthrottle)
+				tty->ops->unthrottle(tty);
+		}
+	}
+	mutex_unlock(&tty->termios_mutex);
+
+	return ret;
+}
+
+/**
  *	tty_wait_until_sent	-	wait for I/O to finish
  *	@tty: tty we are waiting for
  *	@timeout: how long we will wait
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 2c109a3..e7a1bad 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -258,6 +258,7 @@ struct tty_struct {
 	unsigned char warned:1;
 	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */
+	int flow_change;
 
 	struct tty_struct *link;
 	struct fasync_struct *fasync;
@@ -317,6 +318,21 @@ struct tty_file_private {
 
 #define TTY_WRITE_FLUSH(tty) tty_write_flush((tty))
 
+/* Values for tty->flow_change */
+#define TTY_THROTTLE_SAFE 1
+#define TTY_UNTHROTTLE_SAFE 2
+
+static inline void __tty_set_flow_change(struct tty_struct *tty, int val)
+{
+	tty->flow_change = val;
+}
+
+static inline void tty_set_flow_change(struct tty_struct *tty, int val)
+{
+	tty->flow_change = val;
+	smp_mb();
+}
+
 #ifdef CONFIG_TTY
 extern void console_init(void);
 extern void tty_kref_put(struct tty_struct *tty);
@@ -399,6 +415,8 @@ extern int tty_write_room(struct tty_struct *tty);
 extern void tty_driver_flush_buffer(struct tty_struct *tty);
 extern void tty_throttle(struct tty_struct *tty);
 extern void tty_unthrottle(struct tty_struct *tty);
+extern int tty_throttle_safe(struct tty_struct *tty);
+extern int tty_unthrottle_safe(struct tty_struct *tty);
 extern int tty_do_resize(struct tty_struct *tty, struct winsize *ws);
 extern void tty_driver_remove_tty(struct tty_driver *driver,
 				  struct tty_struct *tty);
-- 
1.8.1.2

