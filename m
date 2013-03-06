Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3CFNkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:40:53 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:50330 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab3CFNix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:38:53 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 1/7] n_tty: Fix unsafe driver-side signals
Date: Wed,  6 Mar 2013 08:38:19 -0500
Message-Id: <1362577105-19757-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362577105-19757-1-git-send-email-peter@hurleysoftware.com>
References: <1362577105-19757-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An ldisc reference is insufficient guarantee the foreground process
group is not in the process of being signalled from a hangup.

1) Reads of tty->pgrp must be locked with ctrl_lock
2) The group pid must be referenced for the duration of signalling.
   Because the driver-side is not process-context, a pid reference
   must be acquired.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 66ce178..cd9ba3d 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1038,23 +1038,19 @@ static void eraser(unsigned char c, struct tty_struct *tty)
  *	isig		-	handle the ISIG optio
  *	@sig: signal
  *	@tty: terminal
- *	@flush: force flush
  *
- *	Called when a signal is being sent due to terminal input. This
- *	may caus terminal flushing to take place according to the termios
- *	settings and character used. Called from the driver receive_buf
- *	path so serialized.
+ *	Called when a signal is being sent due to terminal input.
+ *	Called from the driver receive_buf path so serialized.
  *
- *	Locking: ctrl_lock, read_lock (both via flush buffer)
+ *	Locking: ctrl_lock
  */
 
-static inline void isig(int sig, struct tty_struct *tty, int flush)
+static inline void isig(int sig, struct tty_struct *tty)
 {
-	if (tty->pgrp)
-		kill_pgrp(tty->pgrp, sig, 1);
-	if (flush || !L_NOFLSH(tty)) {
-		n_tty_flush_buffer(tty);
-		tty_driver_flush_buffer(tty);
+	struct pid *tty_pgrp = tty_get_pgrp(tty);
+	if (tty_pgrp) {
+		kill_pgrp(tty_pgrp, sig, 1);
+		put_pid(tty_pgrp);
 	}
 }
 
@@ -1075,7 +1071,11 @@ static inline void n_tty_receive_break(struct tty_struct *tty)
 	if (I_IGNBRK(tty))
 		return;
 	if (I_BRKINT(tty)) {
-		isig(SIGINT, tty, 1);
+		isig(SIGINT, tty);
+		if (!L_NOFLSH(tty)) {
+			n_tty_flush_buffer(tty);
+			tty_driver_flush_buffer(tty);
+		}
 		return;
 	}
 	if (I_PARMRK(tty)) {
@@ -1242,11 +1242,6 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 		signal = SIGTSTP;
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
-			/*
-			 * Note that we do not use isig() here because we want
-			 * the order to be:
-			 * 1) flush, 2) echo, 3) signal
-			 */
 			if (!L_NOFLSH(tty)) {
 				n_tty_flush_buffer(tty);
 				tty_driver_flush_buffer(tty);
@@ -1257,8 +1252,7 @@ send_signal:
 				echo_char(c, tty);
 				process_echoes(tty);
 			}
-			if (tty->pgrp)
-				kill_pgrp(tty->pgrp, signal, 1);
+			isig(signal, tty);
 			return;
 		}
 	}
-- 
1.8.1.2

