Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaKERtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:49:32 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39065 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751110AbaKERt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:49:26 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 19/26] tty: Preset lock subclass for nested tty locks
Date: Wed,  5 Nov 2014 12:13:02 -0500
Message-Id: <1415207589-15967-20-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the requirement of specifying the tty lock nesting at
lock time; instead, set the lock subclass for slave ptys at pty
install (normal ttys and master ptys use subclass 0).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c       |  2 ++
 drivers/tty/tty_mutex.c | 19 +++++++++----------
 include/linux/tty.h     |  1 +
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index bdb8fd1..11db7dc 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -399,6 +399,8 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 	if (!o_tty)
 		goto err_put_module;
 
+	tty_set_lock_subclass(o_tty);
+
 	if (legacy) {
 		/* We always use new tty termios data so we can do this
 		   the easy way .. */
diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index f43e995..4486741 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -13,15 +13,14 @@
 
 enum {
 	TTY_MUTEX_NORMAL,
-	TTY_MUTEX_NESTED,
+	TTY_MUTEX_SLAVE,
 };
 
 /*
  * Getting the big tty mutex.
  */
 
-static void __lockfunc tty_lock_nested(struct tty_struct *tty,
-				       unsigned int subclass)
+void __lockfunc tty_lock(struct tty_struct *tty)
 {
 	if (tty->magic != TTY_MAGIC) {
 		pr_err("L Bad %p\n", tty);
@@ -29,12 +28,7 @@ static void __lockfunc tty_lock_nested(struct tty_struct *tty,
 		return;
 	}
 	tty_kref_get(tty);
-	mutex_lock_nested(&tty->legacy_mutex, subclass);
-}
-
-void __lockfunc tty_lock(struct tty_struct *tty)
-{
-	return tty_lock_nested(tty, TTY_MUTEX_NORMAL);
+	mutex_lock(&tty->legacy_mutex);
 }
 EXPORT_SYMBOL(tty_lock);
 
@@ -56,7 +50,7 @@ void __lockfunc tty_lock_slave(struct tty_struct *tty)
 		WARN_ON(!mutex_is_locked(&tty->link->legacy_mutex) ||
 			!tty->driver->type == TTY_DRIVER_TYPE_PTY ||
 			!tty->driver->type == PTY_TYPE_SLAVE);
-		tty_lock_nested(tty, TTY_MUTEX_NESTED);
+		tty_lock(tty);
 	}
 }
 
@@ -65,3 +59,8 @@ void __lockfunc tty_unlock_slave(struct tty_struct *tty)
 	if (tty && tty != tty->link)
 		tty_unlock(tty);
 }
+
+void tty_set_lock_subclass(struct tty_struct *tty)
+{
+	lockdep_set_subclass(&tty->legacy_mutex, TTY_MUTEX_SLAVE);
+}
diff --git a/include/linux/tty.h b/include/linux/tty.h
index a07b4b4..196c352 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -640,6 +640,7 @@ extern void __lockfunc tty_lock(struct tty_struct *tty);
 extern void __lockfunc tty_unlock(struct tty_struct *tty);
 extern void __lockfunc tty_lock_slave(struct tty_struct *tty);
 extern void __lockfunc tty_unlock_slave(struct tty_struct *tty);
+extern void tty_set_lock_subclass(struct tty_struct *tty);
 /*
  * this shall be called only from where BTM is held (like close)
  *
-- 
2.1.3

