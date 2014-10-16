Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaJPUZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:25:53 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50066 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751928AbaJPUZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:25:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 02/27] tty: Invert tty_lock/ldisc_sem lock order
Date: Thu, 16 Oct 2014 16:25:00 -0400
Message-Id: <1413491125-20134-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropping the tty lock to acquire the tty->ldisc_sem allows several
race conditions (such as hangup while changing the ldisc) which requires
extra states and testing. The ldisc_sem->tty_lock lock order has
not been required since tty buffer ownership was moved to tty_port.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 332a622..28858eb 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -523,9 +523,11 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (IS_ERR(new_ldisc))
 		return PTR_ERR(new_ldisc);
 
+	tty_lock(tty);
 	retval = tty_ldisc_lock_pair_timeout(tty, o_tty, 5 * HZ);
 	if (retval) {
 		tty_ldisc_put(new_ldisc);
+		tty_unlock(tty);
 		return retval;
 	}
 
@@ -536,11 +538,11 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (tty->ldisc->ops->num == ldisc) {
 		tty_ldisc_enable_pair(tty, o_tty);
 		tty_ldisc_put(new_ldisc);
+		tty_unlock(tty);
 		return 0;
 	}
 
 	old_ldisc = tty->ldisc;
-	tty_lock(tty);
 
 	if (test_bit(TTY_HUPPING, &tty->flags) ||
 	    test_bit(TTY_HUPPED, &tty->flags)) {
@@ -675,8 +677,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
 	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
 
-	tty_unlock(tty);
-
 	/*
 	 * Shutdown the current line discipline, and reset it to
 	 * N_TTY if need be.
@@ -684,7 +684,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 * Avoid racing set_ldisc or tty_ldisc_release
 	 */
 	tty_ldisc_lock_pair(tty, tty->link);
-	tty_lock(tty);
 
 	if (tty->ldisc) {
 
-- 
2.1.1

