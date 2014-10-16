Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaJPUux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:50:53 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43632 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753089AbaJPUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:50:51 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 16/27] tty: Simplify tty_release_checks() interface
Date: Thu, 16 Oct 2014 16:25:14 -0400
Message-Id: <1413491125-20134-17-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing the 'other' tty to tty_release_checks() only makes sense
for a pty pair; make o_tty scope local instead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 5c782dc..8fedd22 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1701,8 +1701,7 @@ static void release_tty(struct tty_struct *tty, int idx)
  *	Performs some paranoid checking before true release of the @tty.
  *	This is a no-op unless TTY_PARANOIA_CHECK is defined.
  */
-static int tty_release_checks(struct tty_struct *tty, struct tty_struct *o_tty,
-		int idx)
+static int tty_release_checks(struct tty_struct *tty, int idx)
 {
 #ifdef TTY_PARANOIA_CHECK
 	if (idx < 0 || idx >= tty->driver->num) {
@@ -1721,6 +1720,8 @@ static int tty_release_checks(struct tty_struct *tty, struct tty_struct *o_tty,
 		return -1;
 	}
 	if (tty->driver->other) {
+		struct tty_struct *o_tty = tty->link;
+
 		if (o_tty != tty->driver->other->ttys[idx]) {
 			printk(KERN_DEBUG "%s: other->table[%d] not o_tty for (%s)\n",
 					__func__, idx, tty->name);
@@ -1778,7 +1779,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	/* Review: parallel close */
 	o_tty = tty->link;
 
-	if (tty_release_checks(tty, o_tty, idx)) {
+	if (tty_release_checks(tty, idx)) {
 		tty_unlock(tty);
 		return 0;
 	}
-- 
2.1.1

