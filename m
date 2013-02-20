Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794Ab3BTUWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:22:35 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54701 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935935Ab3BTUPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:15:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 15/32] tty: Make core responsible for synchronizing its work
Date: Wed, 20 Feb 2013 15:03:02 -0500
Message-Id: <1361390599-15195-16-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty core relies on the ldisc layer for synchronizing destruction
of the tty. Instead, the final tty release must wait for any pending tty
work to complete prior to tty destruction.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c    | 17 +++++++++++++++++
 drivers/tty/tty_ldisc.c | 24 ++++--------------------
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 198b345..f1303da 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1464,6 +1464,17 @@ void tty_free_termios(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_free_termios);
 
+/**
+ *	tty_flush_works		-	flush all works of a tty
+ *	@tty: tty device to flush works for
+ *
+ *	Sync flush all works belonging to @tty.
+ */
+static void tty_flush_works(struct tty_struct *tty)
+{
+	flush_work(&tty->SAK_work);
+	flush_work(&tty->hangup_work);
+}
 
 /**
  *	release_one_tty		-	release tty structure memory
@@ -1785,6 +1796,12 @@ int tty_release(struct inode *inode, struct file *filp)
 	 * Ask the line discipline code to release its structures
 	 */
 	tty_ldisc_release(tty, o_tty);
+
+	/* Wait for pending work before tty destruction commmences */
+	tty_flush_works(tty);
+	if (o_tty)
+		tty_flush_works(o_tty);
+
 	/*
 	 * The release_tty function takes care of the details of clearing
 	 * the slots and preserving the termios structure. The tty_unlock_pair
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index cbb945b..7f7e1a3 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -499,18 +499,6 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 }
 
 /**
- *	tty_ldisc_flush_works	-	flush all works of a tty
- *	@tty: tty device to flush works for
- *
- *	Sync flush all works belonging to @tty.
- */
-static void tty_ldisc_flush_works(struct tty_struct *tty)
-{
-	flush_work(&tty->SAK_work);
-	flush_work(&tty->hangup_work);
-}
-
-/**
  *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
  *	@tty: tty to wait for
  *	@timeout: for how long to wait at most
@@ -698,13 +686,13 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	retval = tty_ldisc_halt(tty, o_tty, 5 * HZ);
 
 	/*
-	 * Wait for ->hangup_work and ->buf.work handlers to terminate.
+	 * Wait for hangup to complete, if pending.
 	 * We must drop the mutex here in case a hangup is also in process.
 	 */
 
 	mutex_unlock(&tty->ldisc_mutex);
 
-	tty_ldisc_flush_works(tty);
+	flush_work(&tty->hangup_work);
 
 	tty_lock(tty);
 	mutex_lock(&tty->ldisc_mutex);
@@ -951,15 +939,11 @@ static void tty_ldisc_kill(struct tty_struct *tty)
 void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 {
 	/*
-	 * Prevent flush_to_ldisc() from rescheduling the work for later.  Then
-	 * kill any delayed work. As this is the final close it does not
-	 * race with the set_ldisc code path.
+	 * Shutdown this line discipline. As this is the final close,
+	 * it does not race with the set_ldisc code path.
 	 */
 
 	tty_ldisc_halt(tty, o_tty, MAX_SCHEDULE_TIMEOUT);
-	tty_ldisc_flush_works(tty);
-	if (o_tty)
-		tty_ldisc_flush_works(o_tty);
 
 	tty_lock_pair(tty, o_tty);
 	/* This will need doing differently if we need to lock */
-- 
1.8.1.2

