Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3BEUnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:43:50 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:33556 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756363Ab3BEUnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:43:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 15/23] tty: Don't restart ldisc on hangup if racing ldisc kill
Date: Tue,  5 Feb 2013 15:20:30 -0500
Message-Id: <1360095638-6624-16-git-send-email-peter@hurleysoftware.com>
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

Asynchronous hangups (such as from carrier loss) can race with the
final tty release. Because there is no mechanism to prevent an async
hangup from being scheduled, waiting for the hangup to complete is
insufficient to prevent racing between ldisc hangup and ldisc kill.
Eg., immediately after flush_work() returns, an async hangup
could be scheduled, thus restarting a new ldisc.

Instead, prevent hangup from restarting a new ldisc when the tty is
being destroyed.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 8a86a72..e0fdfec 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -884,7 +884,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 * Shutdown the current line discipline, and reset it to
 	 * N_TTY if need be.
 	 *
-	 * Avoid racing set_ldisc or tty_ldisc_release
+	 * Avoid racing set_ldisc or tty_ldisc_kill
 	 */
 	mutex_lock(&tty->ldisc_mutex);
 
@@ -892,7 +892,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	   reopen it. We could defer this to the next open but
 	   it means auditing a lot of other paths so this is
 	   a FIXME */
-	if (tty_ldisc_hangup_halt(tty)) {
+	if (tty_ldisc_hangup_halt(tty) && !test_bit(TTY_CLOSING, &tty->flags)) {
 		if (reset == 0) {
 
 			if (!tty_ldisc_reinit(tty, tty->termios.c_line))
-- 
1.8.1.2

