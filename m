Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaKERuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:50:05 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43856 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609AbaKERuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:50:00 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 14/26] tty: Fold pty pair handling into tty_flush_works()
Date: Wed,  5 Nov 2014 12:12:57 -0500
Message-Id: <1415207589-15967-15-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform work flush for both ends of a pty pair within tty_flush_works(),
rather than calling twice.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 7b91007..563ab37 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1584,15 +1584,19 @@ void tty_free_termios(struct tty_struct *tty)
 EXPORT_SYMBOL(tty_free_termios);
 
 /**
- *	tty_flush_works		-	flush all works of a tty
- *	@tty: tty device to flush works for
+ *	tty_flush_works		-	flush all works of a tty/pty pair
+ *	@tty: tty device to flush works for (or either end of a pty pair)
  *
- *	Sync flush all works belonging to @tty.
+ *	Sync flush all works belonging to @tty (and the 'other' tty).
  */
 static void tty_flush_works(struct tty_struct *tty)
 {
 	flush_work(&tty->SAK_work);
 	flush_work(&tty->hangup_work);
+	if (tty->link) {
+		flush_work(&tty->link->SAK_work);
+		flush_work(&tty->link->hangup_work);
+	}
 }
 
 /**
@@ -1901,8 +1905,6 @@ int tty_release(struct inode *inode, struct file *filp)
 
 	/* Wait for pending work before tty destruction commmences */
 	tty_flush_works(tty);
-	if (o_tty)
-		tty_flush_works(o_tty);
 
 #ifdef TTY_DEBUG_HANGUP
 	printk(KERN_DEBUG "%s: %s: freeing structure...\n", __func__, tty_name(tty, buf));
-- 
2.1.3

