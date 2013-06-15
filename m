Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3FOOWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:22:34 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40493 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab3FOOWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:22:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 07/20] n_tty: Factor signal char handling into separate fn
Date: Sat, 15 Jun 2013 10:21:23 -0400
Message-Id: <1371306096-5571-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the monolithic n_tty_receive_char() complexity; factor the
handling of INTR_CHAR, QUIT_CHAR and SUSP_CHAR into
n_tty_receive_signal_char().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 52 ++++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 309d964..be5ef56 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1218,6 +1218,26 @@ static inline void n_tty_receive_parity_error(struct tty_struct *tty,
 	wake_up_interruptible(&tty->read_wait);
 }
 
+static void
+n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
+{
+	if (!L_NOFLSH(tty)) {
+		/* flushing needs exclusive termios_rwsem */
+		up_read(&tty->termios_rwsem);
+		n_tty_flush_buffer(tty);
+		tty_driver_flush_buffer(tty);
+		down_read(&tty->termios_rwsem);
+	}
+	if (I_IXON(tty))
+		start_tty(tty);
+	if (L_ECHO(tty)) {
+		echo_char(c, tty);
+		commit_echoes(tty);
+	}
+	isig(signal, tty);
+	return;
+}
+
 /**
  *	n_tty_receive_char	-	perform processing
  *	@tty: terminal device
@@ -1313,30 +1333,14 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 	}
 
 	if (L_ISIG(tty)) {
-		int signal;
-		signal = SIGINT;
-		if (c == INTR_CHAR(tty))
-			goto send_signal;
-		signal = SIGQUIT;
-		if (c == QUIT_CHAR(tty))
-			goto send_signal;
-		signal = SIGTSTP;
-		if (c == SUSP_CHAR(tty)) {
-send_signal:
-			if (!L_NOFLSH(tty)) {
-				/* flushing needs exclusive termios_rwsem */
-				up_read(&tty->termios_rwsem);
-				n_tty_flush_buffer(tty);
-				tty_driver_flush_buffer(tty);
-				down_read(&tty->termios_rwsem);
-			}
-			if (I_IXON(tty))
-				start_tty(tty);
-			if (L_ECHO(tty)) {
-				echo_char(c, tty);
-				commit_echoes(tty);
-			}
-			isig(signal, tty);
+		if (c == INTR_CHAR(tty)) {
+			n_tty_receive_signal_char(tty, SIGINT, c);
+			return;
+		} else if (c == QUIT_CHAR(tty)) {
+			n_tty_receive_signal_char(tty, SIGQUIT, c);
+			return;
+		} else if (c == SUSP_CHAR(tty)) {
+			n_tty_receive_signal_char(tty, SIGTSTP, c);
 			return;
 		}
 	}
-- 
1.8.1.2

