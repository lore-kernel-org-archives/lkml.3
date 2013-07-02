Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3GBPm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:42:58 -0400
Received: from cpc6-farn7-2-0-cust119.6-2.cable.virginmedia.com ([81.110.26.120]:42312
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751758Ab3GBPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:41:58 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 11:41:58 EDT
From: Dean Jenkins <Dean_Jenkins@mentor.com>
To: Andre Naujoks <nautsch2@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5/5] SLIP: Fix transmission segmentation mechanism
Date: Tue,  2 Jul 2013 16:31:34 +0100
Message-Id: <1372779094-11730-6-git-send-email-Dean_Jenkins@mentor.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
References: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Binding SLIP with a PTY/TTY can cause truncated SLIP frames to be
transmitted when the first write to the TTY fails to consume all
the characters of the SLIP frame.

Asynchronous to the write function is a wakeup event from the TTY
that indicates the TTY can accept more data. The wakeup event
calls tty_wakeup() which calls slip_write_wakeup() when
TTY_DO_WRITE_WAKEUP is set.

To complete the transmission of a SLIP frame to the TTY,
slip_write_wakeup() must run at least once. Unfortunately, pty_write()
also calls tty_wakeup() and when TTY_DO_WRITE_WAKEUP is set,
slip_write_wakeup() is called. xleft is always zero and
causes slip_write_wakeup() to complete the transmission and
clears the TTY_DO_WRITE_WAKEUP flag. This can cause a truncated
SLIP frame because any remaining characters will not get sent.

The wakeup event is unable to process the remaining characters
because the TTY_DO_WRITE_WAKEUP flag has been cleared.

The code modification fixes the transmission segmentation
mechanism by preventing pty_write() from calling
slip_write_wakeup() by clearing TTY_DO_WRITE_WAKEUP before calling
pty_write(). After pty_write() returns, TTY_DO_WRITE_WAKEUP is set
to allow the TTY wakeup event to call slip_write_wakeup() to
attempt to complete the transmission of the SLIP frame.

This may not be foolproof because a timeout is needed to
break out of the cycle of transmission attempts. Note error
codes from the TTY layer will break out of the cycle of
transmission attempts.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
---
 drivers/net/slip/slip.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index e2eff84..0ded23d 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -404,15 +404,13 @@ static void sl_encaps(struct slip *sl, unsigned char *icp, int len)
 	 */
 	sl->xleft = 0;
 
-	/* Order of next two lines is *very* important.
-	 * When we are sending a little amount of data,
-	 * the transfer may be completed inside the ops->write()
-	 * routine, because it's running with interrupts enabled.
-	 * In this case we *never* got WRITE_WAKEUP event,
-	 * if we did not request it before write operation.
-	 *       14 Oct 1994  Dmitry Gorodchanin.
+	/* ensure slip_write_wakeup() does not run due to write()
+	 * or write_wakeup event and this prevents slip_write_wakeup()
+	 * responding to an out of date xleft value.
 	 */
-	set_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+	clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+
+	/* attempt to write the SLIP frame to the TTY buffer */
 	err = sl->tty->ops->write(sl->tty, sl->xbuff, count);
 
 	if (err < 0) {
@@ -432,6 +430,11 @@ static void sl_encaps(struct slip *sl, unsigned char *icp, int len)
 	/* VSV */
 	clear_bit(SLF_OUTWAIT, &sl->flags);	/* reset outfill flag */
 #endif
+	/* xleft will be zero when all characters have been written.
+	 * if xleft is positive then additional writes are needed.
+	 * write_wakeup event is needed to complete the transmission.
+	 */
+	set_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 }
 
 /*
@@ -447,15 +450,18 @@ static void slip_write_wakeup(struct tty_struct *tty)
 	if (!sl || sl->magic != SLIP_MAGIC || !netif_running(sl->dev))
 		return;
 
+	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+
 	if (sl->xleft <= 0)  {
+		/* Whole SLIP frame has been written. */
 		/* Now serial buffer is almost free & we can start
 		 * transmission of another packet */
 		sl->dev->stats.tx_packets++;
-		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 		sl_unlock(sl);
 		return;
 	}
 
+	/* attempt to write the remaining SLIP frame characters */
 	err = tty->ops->write(tty, sl->xhead, sl->xleft);
 
 	if (err < 0) {
@@ -468,6 +474,11 @@ static void slip_write_wakeup(struct tty_struct *tty)
 
 	sl->xleft -= actual;
 	sl->xhead += actual;
+
+	/* allow the next tty wakeup event to attempt to complete
+	 * the transmission
+	 */
+	set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 }
 
 static void sl_tx_timeout(struct net_device *dev)
-- 
1.8.1.5

