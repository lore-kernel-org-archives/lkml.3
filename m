Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab3BEUnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:43:11 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:36229 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755340Ab3BEUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:43:08 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 12/23] tty: Kick waiters _after_ the ldisc is locked
Date: Tue,  5 Feb 2013 15:20:27 -0500
Message-Id: <1360095638-6624-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index c903778..8a86a72 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -604,6 +604,12 @@ static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
 
 	clear_bit(TTY_LDISC, &tty->flags);
 
+	/* Wakeup waiters so they can discover the tty is hupping, abort
+	 * their i/o loops, and release their ldisc references
+	 */
+	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
+	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
+
 	if (tty->ldisc) {	/* Not yet closed */
 		tty_unlock(tty);
 
@@ -875,12 +881,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 		tty_ldisc_deref(ld);
 	}
 	/*
-	 * FIXME: Once we trust the LDISC code better we can wait here for
-	 * ldisc completion and fix the driver call race
-	 */
-	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
-	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
-	/*
 	 * Shutdown the current line discipline, and reset it to
 	 * N_TTY if need be.
 	 *
-- 
1.8.1.2

