Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935461Ab3BTUF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:05:28 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54021 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934928Ab3BTUFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:05:22 -0500
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
Subject: [PATCH v4 09/32] tty: Halt both ldiscs concurrently
Date: Wed, 20 Feb 2013 15:02:56 -0500
Message-Id: <1361390599-15195-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pty driver does not obtain an ldisc reference to the linked
tty when writing. When the ldiscs are sequentially halted, it
is possible for one ldisc to be halted, and before the second
ldisc can be halted, a concurrent write schedules buffer work on
the first ldisc. This can lead to an access-after-free error when
the scheduled buffer work starts on the closed ldisc.

Prevent subsequent use after halt by performing each stage
of the halt on both ttys.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 525ee53..7712091 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -530,14 +530,17 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
 /**
  *	tty_ldisc_halt		-	shut down the line discipline
  *	@tty: tty device
+ *	@o_tty: paired pty device (can be NULL)
  *	@pending: returns true if work was scheduled when cancelled
  *		  (can be set to NULL)
+ *	@o_pending: returns true if work was scheduled when cancelled
+ *		    (can be set to NULL)
  *	@timeout: # of jiffies to wait for ldisc refs to be released
  *
- *	Shut down the line discipline and work queue for this tty device.
- *	The TTY_LDISC flag being cleared ensures no further references can
- *	be obtained while the delayed work queue halt ensures that no more
- *	data is fed to the ldisc.
+ *	Shut down the line discipline and work queue for this tty device and
+ *	its paired pty (if exists). Clearing the TTY_LDISC flag ensures
+ *	no further references can be obtained while the work queue halt
+ *	ensures that no more data is fed to the ldisc.
  *
  *	Furthermore, guarantee that existing ldisc references have been
  *	released, which in turn, guarantees that no future buffer work
@@ -548,19 +551,32 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
  *	flushed.
  */
 
-static int tty_ldisc_halt(struct tty_struct *tty, int *pending, long timeout)
+static int tty_ldisc_halt(struct tty_struct *tty, struct tty_struct *o_tty,
+			  int *pending, int *o_pending, long timeout)
 {
-	int scheduled, retval;
+	int scheduled, o_scheduled, retval;
 
 	clear_bit(TTY_LDISC, &tty->flags);
+	if (o_tty)
+		clear_bit(TTY_LDISC, &o_tty->flags);
+
 	retval = tty_ldisc_wait_idle(tty, timeout);
+	if (!retval && o_tty)
+		retval = tty_ldisc_wait_idle(o_tty, timeout);
 	if (retval)
 		return retval;
 
 	scheduled = cancel_work_sync(&tty->port->buf.work);
 	set_bit(TTY_LDISC_HALTED, &tty->flags);
+	if (o_tty) {
+		o_scheduled = cancel_work_sync(&o_tty->port->buf.work);
+		set_bit(TTY_LDISC_HALTED, &o_tty->flags);
+	}
+
 	if (pending)
 		*pending = scheduled;
+	if (o_tty && o_pending)
+		*o_pending = o_scheduled;
 	return 0;
 }
 
@@ -702,9 +718,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	 *	parallel to the change and re-referencing the tty.
 	 */
 
-	retval = tty_ldisc_halt(tty, &work, 5 * HZ);
-	if (!retval && o_tty)
-		retval = tty_ldisc_halt(o_tty, &o_work, 5 * HZ);
+	retval = tty_ldisc_halt(tty, o_tty, &work, &o_work, 5 * HZ);
 
 	/*
 	 * Wait for ->hangup_work and ->buf.work handlers to terminate.
@@ -965,12 +979,10 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 * race with the set_ldisc code path.
 	 */
 
-	tty_ldisc_halt(tty, NULL, MAX_SCHEDULE_TIMEOUT);
+	tty_ldisc_halt(tty, o_tty, NULL, NULL, MAX_SCHEDULE_TIMEOUT);
 	tty_ldisc_flush_works(tty);
-	if (o_tty) {
-		tty_ldisc_halt(o_tty, NULL, MAX_SCHEDULE_TIMEOUT);
+	if (o_tty)
 		tty_ldisc_flush_works(o_tty);
-	}
 
 	tty_lock_pair(tty, o_tty);
 	/* This will need doing differently if we need to lock */
-- 
1.8.1.2

