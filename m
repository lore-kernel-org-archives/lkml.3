Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaKERtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:49:12 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38274 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751110AbaKERtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:49:10 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 10/26] tty: Don't take tty_mutex for tty count changes
Date: Wed,  5 Nov 2014 12:12:53 -0500
Message-Id: <1415207589-15967-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holding tty_mutex is no longer required to serialize changes to
the tty_count or to prevent concurrent opens of closing ttys;
tty_lock() is sufficient.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 49167ed..f1c4b07 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1806,10 +1806,6 @@ int tty_release(struct inode *inode, struct file *filp)
 	 * each iteration we avoid any problems.
 	 */
 	while (1) {
-		/* Guard against races with tty->count changes elsewhere and
-		   opens on /dev/tty */
-
-		mutex_lock(&tty_mutex);
 		tty_lock_pair(tty, o_tty);
 		tty_closing = tty->count <= 1;
 		o_tty_closing = o_tty &&
@@ -1845,7 +1841,6 @@ int tty_release(struct inode *inode, struct file *filp)
 			       __func__, tty_name(tty, buf));
 		}
 		tty_unlock_pair(tty, o_tty);
-		mutex_unlock(&tty_mutex);
 		schedule_timeout_killable(timeout);
 		if (timeout < 120 * HZ)
 			timeout = 2 * timeout + 1;
@@ -1900,7 +1895,6 @@ int tty_release(struct inode *inode, struct file *filp)
 		read_unlock(&tasklist_lock);
 	}
 
-	mutex_unlock(&tty_mutex);
 	tty_unlock_pair(tty, o_tty);
 	/* At this point, the tty->count == 0 should ensure a dead tty
 	   cannot be re-opened by a racing opener */
-- 
2.1.3

