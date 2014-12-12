Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966559AbaLLGzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:55:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51754 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758717AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <johan@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.561091812@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 138/164] USB: keyspan: fix overrun-error reporting
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 855515a6d3731242d85850a206f2ec084c917338 upstream.

Fix reporting of overrun errors, which are not associated with a
character. Instead insert a null character and report only once.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
[bwh: Backported to 3.2:
 - s/\&port->port/tty/
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -437,12 +437,11 @@ static void	usa26_indat_callback(struct
 		if ((data[0] & 0x80) == 0) {
 			/* no errors on individual bytes, only
 			   possible overrun err */
-			if (data[0] & RXERROR_OVERRUN)
-				err = TTY_OVERRUN;
-			else
-				err = 0;
+			if (data[0] & RXERROR_OVERRUN) {
+				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			}
 			for (i = 1; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(tty, data[i], err);
+				tty_insert_flip_char(tty, data[i], TTY_NORMAL);
 		} else {
 			/* some bytes had errors, every byte has status */
 			dbg("%s - RX error!!!!", __func__);
@@ -982,13 +981,13 @@ static void usa90_indat_callback(struct
 			if ((data[0] & 0x80) == 0) {
 				/* no errors on individual bytes, only
 				   possible overrun err*/
-				if (data[0] & RXERROR_OVERRUN)
-					err = TTY_OVERRUN;
-				else
-					err = 0;
+				if (data[0] & RXERROR_OVERRUN) {
+					tty_insert_flip_char(tty, 0,
+							     TTY_OVERRUN);
+				}
 				for (i = 1; i < urb->actual_length ; ++i)
 					tty_insert_flip_char(tty, data[i],
-									err);
+							     TTY_NORMAL);
 			}  else {
 			/* some bytes had errors, every byte has status */
 				dbg("%s - RX error!!!!", __func__);

