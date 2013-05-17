Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3EQQuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:50:16 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43632 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab3EQQuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:50:11 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] tty: Remove TTY_HW_COOK_IN/OUT
Date: Fri, 17 May 2013 12:49:48 -0400
Message-Id: <1368809388-6029-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130509151518.GC4120@kroah.com>
References: <20130509151518.GC4120@kroah.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No in-tree tty driver supports cooked mode in hardware; remove.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 12 +++---------
 include/linux/tty.h |  2 --
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 5d95873..f5b9211 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -746,8 +746,7 @@ static size_t __process_echoes(struct tty_struct *tty)
 			if (no_space_left)
 				break;
 		} else {
-			if (O_OPOST(tty) &&
-			    !(test_bit(TTY_HW_COOK_OUT, &tty->flags))) {
+			if (O_OPOST(tty)) {
 				int retval = do_output_char(c, tty, space);
 				if (retval < 0)
 					break;
@@ -1767,12 +1766,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		wake_up_interruptible(&tty->read_wait);
 
 	ldata->icanon = (L_ICANON(tty) != 0);
-	if (test_bit(TTY_HW_COOK_IN, &tty->flags)) {
-		ldata->raw = 1;
-		ldata->real_raw = 1;
-		n_tty_set_room(tty);
-		return;
-	}
+
 	if (I_ISTRIP(tty) || I_IUCLC(tty) || I_IGNCR(tty) ||
 	    I_ICRNL(tty) || I_INLCR(tty) || L_ICANON(tty) ||
 	    I_IXON(tty) || L_ISIG(tty) || L_ECHO(tty) ||
@@ -2312,7 +2306,7 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			retval = -EIO;
 			break;
 		}
-		if (O_OPOST(tty) && !(test_bit(TTY_HW_COOK_OUT, &tty->flags))) {
+		if (O_OPOST(tty)) {
 			while (nr > 0) {
 				ssize_t num = process_output_block(tty, b, nr);
 				if (num < 0) {
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e10846a..3efeb1b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -307,8 +307,6 @@ struct tty_file_private {
 #define TTY_DO_WRITE_WAKEUP 	5	/* Call write_wakeup after queuing new */
 #define TTY_CLOSING 		7	/* ->close() in progress */
 #define TTY_LDISC_OPEN	 	11	/* Line discipline is open */
-#define TTY_HW_COOK_OUT 	14	/* Hardware can do output cooking */
-#define TTY_HW_COOK_IN 		15	/* Hardware can do input cooking */
 #define TTY_PTY_LOCK 		16	/* pty private */
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
-- 
1.8.1.2

