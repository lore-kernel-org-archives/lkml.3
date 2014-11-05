Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaKERtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:49:43 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55259 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751110AbaKERtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:49:41 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 17/26] tty: Simplify tty_release() state checks
Date: Wed,  5 Nov 2014 12:13:00 -0500
Message-Id: <1415207589-15967-18-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local o_tty variable in tty_release() is now accessed only
when closing the pty master.

Set o_tty to slave pty when closing pty master, otherwise NULL;
use o_tty != NULL as replacement for pty_master.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c765260..bbc940d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1759,8 +1759,8 @@ static int tty_release_checks(struct tty_struct *tty, int idx)
 int tty_release(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty = file_tty(filp);
-	struct tty_struct *o_tty;
-	int	pty_master, do_sleep, final;
+	struct tty_struct *o_tty = NULL;
+	int	do_sleep, final;
 	int	idx;
 	char	buf[64];
 	long	timeout = 0;
@@ -1775,10 +1775,9 @@ int tty_release(struct inode *inode, struct file *filp)
 	__tty_fasync(-1, filp, 0);
 
 	idx = tty->index;
-	pty_master = (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
-		      tty->driver->subtype == PTY_TYPE_MASTER);
-	/* Review: parallel close */
-	o_tty = tty->link;
+	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
+	    tty->driver->subtype == PTY_TYPE_MASTER)
+		o_tty = tty->link;
 
 	if (tty_release_checks(tty, idx)) {
 		tty_unlock(tty);
@@ -1822,7 +1821,7 @@ int tty_release(struct inode *inode, struct file *filp)
 				do_sleep++;
 			}
 		}
-		if (pty_master && o_tty->count <= 1) {
+		if (o_tty && o_tty->count <= 1) {
 			if (waitqueue_active(&o_tty->read_wait)) {
 				wake_up_poll(&o_tty->read_wait, POLLIN);
 				do_sleep++;
@@ -1847,7 +1846,7 @@ int tty_release(struct inode *inode, struct file *filp)
 			timeout = MAX_SCHEDULE_TIMEOUT;
 	}
 
-	if (pty_master) {
+	if (o_tty) {
 		if (--o_tty->count < 0) {
 			printk(KERN_WARNING "%s: bad pty slave count (%d) for %s\n",
 				__func__, o_tty->count, tty_name(o_tty, buf));
@@ -1881,13 +1880,13 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (!tty->count) {
 		read_lock(&tasklist_lock);
 		session_clear_tty(tty->session);
-		if (pty_master)
+		if (o_tty)
 			session_clear_tty(o_tty->session);
 		read_unlock(&tasklist_lock);
 	}
 
 	/* check whether both sides are closing ... */
-	final = !tty->count && !(pty_master && o_tty->count);
+	final = !tty->count && !(o_tty && o_tty->count);
 
 	tty_unlock_pair(tty, o_tty);
 	/* At this point, the tty->count == 0 should ensure a dead tty
-- 
2.1.3

