Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaJPVCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:02:46 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55314 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753101AbaJPVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:02:44 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 20/27] tty: Refactor __tty_hangup to enable lockdep annotation
Date: Thu, 16 Oct 2014 16:25:18 -0400
Message-Id: <1413491125-20134-21-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor __tty_hangup() into:
1. __tty_hangup_common(), the portion requiring the tty lock
2. __tty_hangup(), which performs the pre- and post-lock processing
   (TIOCCONS redirect undo) and calls through a function ptr parameter
   to lock/hangup/unlock
3. __tty_hangup_standard(), which performs the lock/hangup/unlock

Allows an alternate function to lock/hangup/unlock with the
nested tty lock.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 51 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 58015b3..48c1def 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -665,32 +665,17 @@ static int tty_signal_session_leader(struct tty_struct *tty, int exit_session)
  *		  tasklist_lock to walk task list for hangup event
  *		    ->siglock to protect ->signal/->sighand
  */
-static void __tty_hangup(struct tty_struct *tty, int exit_session)
+static void __tty_hangup_common(struct tty_struct *tty, int exit_session)
 {
 	struct file *cons_filp = NULL;
-	struct file *filp, *f = NULL;
+	struct file *filp;
 	struct tty_file_private *priv;
 	int    closecount = 0, n;
 	int refs;
 
-	if (!tty)
+	if (test_bit(TTY_HUPPED, &tty->flags))
 		return;
 
-
-	spin_lock(&redirect_lock);
-	if (redirect && file_tty(redirect) == tty) {
-		f = redirect;
-		redirect = NULL;
-	}
-	spin_unlock(&redirect_lock);
-
-	tty_lock(tty);
-
-	if (test_bit(TTY_HUPPED, &tty->flags)) {
-		tty_unlock(tty);
-		return;
-	}
-
 	/* inuse_filps is protected by the single tty lock,
 	   this really needs to change if we want to flush the
 	   workqueue with the lock held */
@@ -746,7 +731,31 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
 	 * can't yet guarantee all that.
 	 */
 	set_bit(TTY_HUPPED, &tty->flags);
+}
+
+static void __tty_hangup_standard(struct tty_struct* tty, int exit_session)
+{
+	tty_lock(tty);
+	__tty_hangup_common(tty, exit_session);
 	tty_unlock(tty);
+}
+
+static void __tty_hangup(struct tty_struct *tty, int exit_session,
+			 void (*hangup)(struct tty_struct *, int))
+{
+	struct file *f = NULL;
+
+	if (!tty)
+		return;
+
+	spin_lock(&redirect_lock);
+	if (redirect && file_tty(redirect) == tty) {
+		f = redirect;
+		redirect = NULL;
+	}
+	spin_unlock(&redirect_lock);
+
+	hangup(tty, exit_session);
 
 	if (f)
 		fput(f);
@@ -757,7 +766,7 @@ static void do_tty_hangup(struct work_struct *work)
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, hangup_work);
 
-	__tty_hangup(tty, 0);
+	__tty_hangup(tty, 0, __tty_hangup_standard);
 }
 
 /**
@@ -795,7 +804,7 @@ void tty_vhangup(struct tty_struct *tty)
 
 	printk(KERN_DEBUG "%s vhangup...\n", tty_name(tty, buf));
 #endif
-	__tty_hangup(tty, 0);
+	__tty_hangup(tty, 0, __tty_hangup_standard);
 }
 
 EXPORT_SYMBOL(tty_vhangup);
@@ -836,7 +845,7 @@ static void tty_vhangup_session(struct tty_struct *tty)
 
 	printk(KERN_DEBUG "%s vhangup session...\n", tty_name(tty, buf));
 #endif
-	__tty_hangup(tty, 1);
+	__tty_hangup(tty, 1, __tty_hangup_standard);
 }
 
 /**
-- 
2.1.1

