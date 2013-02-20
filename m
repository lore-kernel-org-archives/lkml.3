Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416Ab3BTUFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:05:18 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:53994 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935190Ab3BTUFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:05:10 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 06/32] tty: Fix ldisc halt sequence on hangup
Date: Wed, 20 Feb 2013 15:02:53 -0500
Message-Id: <1361390599-15195-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flip buffer work cannot be cancelled until all outstanding ldisc
references have been released. Convert the ldisc ref wait into
a full ldisc halt with buffer work cancellation.

Note that the legacy mutex is not held while cancelling.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index fa0170e..15667c0 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -551,22 +551,30 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
 }
 
 /**
- *	tty_ldisc_hangup_wait_idle - wait for the ldisc to become idle
- *	@tty: tty to wait for
- *
- *	Wait for the line discipline to become idle. The discipline must
- *	have been halted for this to guarantee it remains idle.
+ *	tty_ldisc_hangup_halt - halt the line discipline for hangup
+ *	@tty: tty being hung up
  *
+ *	Shut down the line discipline and work queue for the tty device
+ *	being hungup. Clear the TTY_LDISC flag to ensure no further
+ *	references can be obtained, wait for remaining references to be
+ *	released, and cancel pending buffer work to ensure no more
+ *	data is fed to this ldisc.
  *	Caller must hold legacy and ->ldisc_mutex.
  *
  *	NB: tty_set_ldisc() is prevented from changing the ldisc concurrently
  *	with this function by checking the TTY_HUPPING flag.
+ *
+ *	NB: if tty->ldisc is NULL then buffer work does not need to be
+ *	cancelled because it must already have done as a precondition
+ *	of closing the ldisc and setting tty->ldisc to NULL
  */
-static bool tty_ldisc_hangup_wait_idle(struct tty_struct *tty)
+static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
 {
 	char cur_n[TASK_COMM_LEN], tty_n[64];
 	long timeout = 3 * HZ;
 
+	clear_bit(TTY_LDISC, &tty->flags);
+
 	if (tty->ldisc) {	/* Not yet closed */
 		tty_unlock(tty);
 
@@ -577,6 +585,10 @@ static bool tty_ldisc_hangup_wait_idle(struct tty_struct *tty)
 				__func__, get_task_comm(cur_n, current),
 				tty_name(tty, tty_n));
 		}
+
+		cancel_work_sync(&tty->port->buf.work);
+		set_bit(TTY_LDISC_HALTED, &tty->flags);
+
 		/* must reacquire both locks and preserve lock order */
 		mutex_unlock(&tty->ldisc_mutex);
 		tty_lock(tty);
@@ -851,24 +863,11 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 */
 	mutex_lock(&tty->ldisc_mutex);
 
-	/*
-	 * this is like tty_ldisc_halt, but we need to give up
-	 * the BTM before calling cancel_work_sync, which may
-	 * need to wait for another function taking the BTM
-	 */
-	clear_bit(TTY_LDISC, &tty->flags);
-	tty_unlock(tty);
-	cancel_work_sync(&tty->port->buf.work);
-	set_bit(TTY_LDISC_HALTED, &tty->flags);
-	mutex_unlock(&tty->ldisc_mutex);
-	tty_lock(tty);
-	mutex_lock(&tty->ldisc_mutex);
-
 	/* At this point we have a closed ldisc and we want to
 	   reopen it. We could defer this to the next open but
 	   it means auditing a lot of other paths so this is
 	   a FIXME */
-	if (tty_ldisc_hangup_wait_idle(tty)) {
+	if (tty_ldisc_hangup_halt(tty)) {
 		if (reset == 0) {
 
 			if (!tty_ldisc_reinit(tty, tty->termios.c_line))
-- 
1.8.1.2

