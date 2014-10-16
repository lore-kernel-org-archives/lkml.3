Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaJPUZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:25:51 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42512 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752597AbaJPUZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:25:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 01/27] tty: Don't hold tty_lock for ldisc release
Date: Thu, 16 Oct 2014 16:24:59 -0400
Message-Id: <1413491125-20134-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty->ldisc_sem write lock is sufficient for serializing changes
to tty->ldisc; holding the tty lock is not required.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 2d822aa..332a622 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -764,6 +764,8 @@ static void tty_ldisc_kill(struct tty_struct *tty)
  *	Called during the final close of a tty/pty pair in order to shut down
  *	the line discpline layer. On exit the ldisc assigned is N_TTY and the
  *	ldisc has not been opened.
+ *
+ *	Holding ldisc_sem write lock serializes tty->ldisc changes.
  */
 
 void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
@@ -776,13 +778,9 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	tty_ldisc_debug(tty, "closing ldisc: %p\n", tty->ldisc);
 
 	tty_ldisc_lock_pair(tty, o_tty);
-	tty_lock_pair(tty, o_tty);
-
 	tty_ldisc_kill(tty);
 	if (o_tty)
 		tty_ldisc_kill(o_tty);
-
-	tty_unlock_pair(tty, o_tty);
 	tty_ldisc_unlock_pair(tty, o_tty);
 
 	/* And the memory resources remaining (buffers, termios) will be
-- 
2.1.1

