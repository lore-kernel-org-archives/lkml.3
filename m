Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbaKERXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:23:49 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:36623 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755392AbaKERNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:13:33 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 02/26] tty: Invert tty_lock/ldisc_sem lock order
Date: Wed,  5 Nov 2014 12:12:45 -0500
Message-Id: <1415207589-15967-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropping the tty lock to acquire the tty->ldisc_sem allows several
race conditions (such as hangup while changing the ldisc) which requires
extra states and testing. The ldisc_sem->tty_lock lock order has
not been required since tty buffer ownership was moved to tty_port.

Reviewed-by: Alan Cox <alan@linux.intel.com>
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
2.1.3

