Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaJPUtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:49:11 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:36271 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752274AbaJPUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:49:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 26/27] tty: Fix timeout on pty set ldisc
Date: Thu, 16 Oct 2014 16:25:24 -0400
Message-Id: <1413491125-20134-27-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When changing the ldisc on one end of a pty pair, there may be
waiting readers/writers on the other end which may not exit from
the ldisc i/o loop, preventing tty_ldisc_lock_pair_timeout() from
acquiring the other side's ldisc lock.

Only acquire this side's ldisc lock; although this will no longer
prevent the other side from writing new input, that input will not
be processed until after the ldisc change completes. This has no
effect on normal ttys; new input from the driver was never disabled.

Remove tty_ldisc_enable_pair().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 1dbe278..6368dd9 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -393,16 +393,6 @@ static void __lockfunc tty_ldisc_unlock_pair(struct tty_struct *tty,
 		__tty_ldisc_unlock(tty2);
 }
 
-static void __lockfunc tty_ldisc_enable_pair(struct tty_struct *tty,
-					     struct tty_struct *tty2)
-{
-	clear_bit(TTY_LDISC_HALTED, &tty->flags);
-	if (tty2)
-		clear_bit(TTY_LDISC_HALTED, &tty2->flags);
-
-	tty_ldisc_unlock_pair(tty, tty2);
-}
-
 /**
  *	tty_ldisc_flush	-	flush line discipline queue
  *	@tty: tty
@@ -535,14 +525,13 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 {
 	int retval;
 	struct tty_ldisc *old_ldisc, *new_ldisc;
-	struct tty_struct *o_tty = tty->link;
 
 	new_ldisc = tty_ldisc_get(tty, ldisc);
 	if (IS_ERR(new_ldisc))
 		return PTR_ERR(new_ldisc);
 
 	tty_lock(tty);
-	retval = tty_ldisc_lock_pair_timeout(tty, o_tty, 5 * HZ);
+	retval = tty_ldisc_lock(tty, 5 * HZ);
 	if (retval) {
 		tty_ldisc_put(new_ldisc);
 		tty_unlock(tty);
@@ -554,7 +543,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	 */
 
 	if (tty->ldisc->ops->num == ldisc) {
-		tty_ldisc_enable_pair(tty, o_tty);
+		tty_ldisc_unlock(tty);
 		tty_ldisc_put(new_ldisc);
 		tty_unlock(tty);
 		return 0;
@@ -565,7 +554,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
-		tty_ldisc_enable_pair(tty, o_tty);
+		tty_ldisc_unlock(tty);
 		tty_ldisc_put(new_ldisc);
 		tty_unlock(tty);
 		return -EIO;
@@ -599,13 +588,11 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	/*
 	 *	Allow ldisc referencing to occur again
 	 */
-	tty_ldisc_enable_pair(tty, o_tty);
+	tty_ldisc_unlock(tty);
 
 	/* Restart the work queue in case no characters kick it off. Safe if
 	   already running */
 	schedule_work(&tty->port->buf.work);
-	if (o_tty)
-		schedule_work(&o_tty->port->buf.work);
 
 	tty_unlock(tty);
 	return retval;
-- 
2.1.1

