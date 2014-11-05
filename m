Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaKERtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:49:22 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52439 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751110AbaKERtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:49:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 18/26] tty: Change tty lock order to master->slave
Date: Wed,  5 Nov 2014 12:13:01 -0500
Message-Id: <1415207589-15967-19-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When releasing the master pty, the slave pty also needs to be locked
to prevent concurrent tty count changes for the slave pty and to
ensure that only one parallel master and slave release observe the
final close, and proceed to destruct the pty pair. Conversely, when
releasing the slave pty, locking the master pty is not necessary
(since the master's state can be inferred by the slave tty count).

Introduce tty_lock_slave()/tty_unlock_slave() which acquires/releases
the tty lock of the slave pty. Remove tty_lock_pair()/tty_unlock_pair().

Dropping the tty_lock is no longer required to re-establish a stable
lock order.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c    | 10 ++++++----
 drivers/tty/tty_mutex.c | 32 +++++++++++++-------------------
 include/linux/tty.h     |  7 ++-----
 3 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index bbc940d..fabf4c0 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1792,7 +1792,9 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (tty->ops->close)
 		tty->ops->close(tty, filp);
 
-	tty_unlock(tty);
+	/* If tty is pty master, lock the slave pty (stable lock order) */
+	tty_lock_slave(o_tty);
+
 	/*
 	 * Sanity check: if tty->count is going to zero, there shouldn't be
 	 * any waiters on tty->read_wait or tty->write_wait.  We test the
@@ -1806,8 +1808,6 @@ int tty_release(struct inode *inode, struct file *filp)
 	 * Thus this test wouldn't be triggered at the time the slave closed,
 	 * so we do it now.
 	 */
-	tty_lock_pair(tty, o_tty);
-
 	while (1) {
 		do_sleep = 0;
 
@@ -1888,7 +1888,9 @@ int tty_release(struct inode *inode, struct file *filp)
 	/* check whether both sides are closing ... */
 	final = !tty->count && !(o_tty && o_tty->count);
 
-	tty_unlock_pair(tty, o_tty);
+	tty_unlock_slave(o_tty);
+	tty_unlock(tty);
+
 	/* At this point, the tty->count == 0 should ensure a dead tty
 	   cannot be re-opened by a racing opener */
 
diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 2e41abe..f43e995 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -4,6 +4,11 @@
 #include <linux/semaphore.h>
 #include <linux/sched.h>
 
+/*
+ * Nested tty locks are necessary for releasing pty pairs.
+ * The stable lock order is master pty first, then slave pty.
+ */
+
 /* Legacy tty mutex glue */
 
 enum {
@@ -45,29 +50,18 @@ void __lockfunc tty_unlock(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_unlock);
 
-/*
- * Getting the big tty mutex for a pair of ttys with lock ordering
- * On a non pty/tty pair tty2 can be NULL which is just fine.
- */
-void __lockfunc tty_lock_pair(struct tty_struct *tty,
-					struct tty_struct *tty2)
+void __lockfunc tty_lock_slave(struct tty_struct *tty)
 {
-	if (tty < tty2) {
-		tty_lock(tty);
-		tty_lock_nested(tty2, TTY_MUTEX_NESTED);
-	} else {
-		if (tty2 && tty2 != tty)
-			tty_lock(tty2);
+	if (tty && tty != tty->link) {
+		WARN_ON(!mutex_is_locked(&tty->link->legacy_mutex) ||
+			!tty->driver->type == TTY_DRIVER_TYPE_PTY ||
+			!tty->driver->type == PTY_TYPE_SLAVE);
 		tty_lock_nested(tty, TTY_MUTEX_NESTED);
 	}
 }
-EXPORT_SYMBOL(tty_lock_pair);
 
-void __lockfunc tty_unlock_pair(struct tty_struct *tty,
-						struct tty_struct *tty2)
+void __lockfunc tty_unlock_slave(struct tty_struct *tty)
 {
-	tty_unlock(tty);
-	if (tty2 && tty2 != tty)
-		tty_unlock(tty2);
+	if (tty && tty != tty->link)
+		tty_unlock(tty);
 }
-EXPORT_SYMBOL(tty_unlock_pair);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index af1a7f3..a07b4b4 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -638,11 +638,8 @@ extern long vt_compat_ioctl(struct tty_struct *tty,
 /* functions for preparation of BKL removal */
 extern void __lockfunc tty_lock(struct tty_struct *tty);
 extern void __lockfunc tty_unlock(struct tty_struct *tty);
-extern void __lockfunc tty_lock_pair(struct tty_struct *tty,
-				struct tty_struct *tty2);
-extern void __lockfunc tty_unlock_pair(struct tty_struct *tty,
-				struct tty_struct *tty2);
-
+extern void __lockfunc tty_lock_slave(struct tty_struct *tty);
+extern void __lockfunc tty_unlock_slave(struct tty_struct *tty);
 /*
  * this shall be called only from where BTM is held (like close)
  *
-- 
2.1.3

