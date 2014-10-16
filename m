Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaJPTAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:00:50 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:56899 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752482AbaJPTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:00:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 09/10] tty: Serialize proc_set_tty() with tty_lock
Date: Thu, 16 Oct 2014 14:59:49 -0400
Message-Id: <1413485990-16855-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
References: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the controlling terminal for a session occurs with either
the first open of a non-pty master tty or with ioctl(TIOCSCTTY).
Since only the session leader can set the controlling terminal for
a session (and the session leader cannot change), it is not
necessary to prevent a process from attempting to set different
ttys as the controlling terminal concurrently.

So it's only necessary to prevent the same tty from becoming the
controlling terminal for different session leaders. The tty_lock()
is sufficient to prevent concurrent proc_set_tty() for the same
tty.

Remove the tty_mutex lock region; add tty_lock() to tiocsctty().

While this may appear to allow a race condition between opening
the controlling tty via tty_open_current_tty() and stealing the
controlling tty via ioctl(TIOCSCTTY, 1), that race condition already
existed. Even if the tty_mutex prevented stealing the controlling tty
while tty_open_current_tty() returned the original controlling tty,
it cannot prevent stealing the controlling tty before tty_open() returns.
Thus, tty_open() could already return a no-longer-controlling tty when
opening /dev/tty.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c15421df..7def510 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -508,7 +508,8 @@ void proc_clear_tty(struct task_struct *p)
  * Only callable by the session leader and only if it does not already have
  * a controlling terminal.
  *
- * Caller must hold:  a readlock on tasklist_lock
+ * Caller must hold:  tty_lock()
+ *		      a readlock on tasklist_lock
  *		      sighand lock
  */
 static void __proc_set_tty(struct tty_struct *tty)
@@ -2160,11 +2161,8 @@ retry_open:
 		goto retry_open;
 	}
 	clear_bit(TTY_HUPPED, &tty->flags);
-	tty_unlock(tty);
 
 
-	mutex_lock(&tty_mutex);
-	tty_lock(tty);
 	read_lock(&tasklist_lock);
 	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
@@ -2175,7 +2173,6 @@ retry_open:
 	spin_unlock_irq(&current->sighand->siglock);
 	read_unlock(&tasklist_lock);
 	tty_unlock(tty);
-	mutex_unlock(&tty_mutex);
 	return 0;
 err_unlock:
 	mutex_unlock(&tty_mutex);
@@ -2455,7 +2452,7 @@ static int fionbio(struct file *file, int __user *p)
  *	leader to set this tty as the controlling tty for the session.
  *
  *	Locking:
- *		Takes tty_mutex() to protect tty instance
+ *		Takes tty_lock() to serialize proc_set_tty() for this tty
  *		Takes tasklist_lock internally to walk sessions
  *		Takes ->siglock() when updating signal->tty
  */
@@ -2464,7 +2461,7 @@ static int tiocsctty(struct tty_struct *tty, int arg)
 {
 	int ret = 0;
 
-	mutex_lock(&tty_mutex);
+	tty_lock(tty);
 	read_lock(&tasklist_lock);
 
 	if (current->signal->leader && (task_session(current) == tty->session))
@@ -2497,7 +2494,7 @@ static int tiocsctty(struct tty_struct *tty, int arg)
 	proc_set_tty(tty);
 unlock:
 	read_unlock(&tasklist_lock);
-	mutex_unlock(&tty_mutex);
+	tty_unlock(tty);
 	return ret;
 }
 
-- 
2.1.1

