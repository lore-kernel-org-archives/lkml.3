Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaKERNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:13:38 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48535 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755309AbaKERNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:13:36 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 09/26] tty: Remove TTY_CLOSING
Date: Wed,  5 Nov 2014 12:12:52 -0500
Message-Id: <1415207589-15967-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that re-open is not permitted for a legacy BSD pty master,
using TTY_CLOSING to indicate when a tty can be torn-down is
no longer necessary.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 14 ++------------
 include/linux/tty.h  |  1 -
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index fb74107..49167ed 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1197,7 +1197,7 @@ void tty_write_message(struct tty_struct *tty, char *msg)
 	if (tty) {
 		mutex_lock(&tty->atomic_write_lock);
 		tty_lock(tty);
-		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
+		if (tty->ops->write && tty->count > 0) {
 			tty_unlock(tty);
 			tty->ops->write(tty, msg, strlen(msg));
 		} else
@@ -1888,16 +1888,6 @@ int tty_release(struct inode *inode, struct file *filp)
 	/*
 	 * Perform some housekeeping before deciding whether to return.
 	 *
-	 * Set the TTY_CLOSING flag if this was the last open.  In the
-	 * case of a pty we may have to wait around for the other side
-	 * to close, and TTY_CLOSING makes sure we can't be reopened.
-	 */
-	if (tty_closing)
-		set_bit(TTY_CLOSING, &tty->flags);
-	if (o_tty_closing)
-		set_bit(TTY_CLOSING, &o_tty->flags);
-
-	/*
 	 * If _either_ side is closing, make sure there aren't any
 	 * processes that still think tty or o_tty is their controlling
 	 * tty.
@@ -1912,7 +1902,7 @@ int tty_release(struct inode *inode, struct file *filp)
 
 	mutex_unlock(&tty_mutex);
 	tty_unlock_pair(tty, o_tty);
-	/* At this point the TTY_CLOSING flag should ensure a dead tty
+	/* At this point, the tty->count == 0 should ensure a dead tty
 	   cannot be re-opened by a racing opener */
 
 	/* check whether both sides are closing ... */
diff --git a/include/linux/tty.h b/include/linux/tty.h
index ff0dd7a..35b29f0 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -316,7 +316,6 @@ struct tty_file_private {
 #define TTY_EXCLUSIVE 		3	/* Exclusive open mode */
 #define TTY_DEBUG 		4	/* Debugging */
 #define TTY_DO_WRITE_WAKEUP 	5	/* Call write_wakeup after queuing new */
-#define TTY_CLOSING 		7	/* ->close() in progress */
 #define TTY_LDISC_OPEN	 	11	/* Line discipline is open */
 #define TTY_PTY_LOCK 		16	/* pty private */
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
-- 
2.1.3

