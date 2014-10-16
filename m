Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaJPVA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:00:56 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:60442 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753269AbaJPVAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:00:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 25/27] tty: Fix hung task on pty hangup
Date: Thu, 16 Oct 2014 16:25:23 -0400
Message-Id: <1413491125-20134-26-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hanging up one end of a pty pair, there may be waiting
readers/writers on the other end which may not exit, preventing
tty_ldisc_lock_pair() from acquiring the other side's ldisc lock.

Only acquire this side's ldisc lock; although this will no longer
prevent the other side from writing new input, that input will not
be processing until after the ldisc hangup is complete.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 5bdc241..1dbe278 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -326,6 +326,24 @@ static inline void __tty_ldisc_unlock(struct tty_struct *tty)
 }
 
 static int __lockfunc
+tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout)
+{
+	int ret;
+
+	ret = __tty_ldisc_lock(tty, timeout);
+	if (!ret)
+		return -EBUSY;
+	set_bit(TTY_LDISC_HALTED, &tty->flags);
+	return 0;
+}
+
+static void tty_ldisc_unlock(struct tty_struct *tty)
+{
+	clear_bit(TTY_LDISC_HALTED, &tty->flags);
+	__tty_ldisc_unlock(tty);
+}
+
+static int __lockfunc
 tty_ldisc_lock_pair_timeout(struct tty_struct *tty, struct tty_struct *tty2,
 			    unsigned long timeout)
 {
@@ -682,7 +700,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 *
 	 * Avoid racing set_ldisc or tty_ldisc_release
 	 */
-	tty_ldisc_lock_pair(tty, tty->link);
+	tty_ldisc_lock(tty, MAX_SCHEDULE_TIMEOUT);
 
 	if (tty->ldisc) {
 
@@ -704,7 +722,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 			WARN_ON(tty_ldisc_open(tty, tty->ldisc));
 		}
 	}
-	tty_ldisc_enable_pair(tty, tty->link);
+	tty_ldisc_unlock(tty);
 	if (reset)
 		tty_reset_termios(tty);
 
-- 
2.1.1

