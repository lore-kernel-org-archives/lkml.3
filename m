Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3FOO2H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:28:07 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40649 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab3FOO2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:28:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 11/20] n_tty: Factor tty->closing receive_buf() into separate fn
Date: Sat, 15 Jun 2013 10:21:27 -0400
Message-Id: <1371306096-5571-12-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to modal receive_buf() processing; factor receive char
processing when tty->closing into n_tty_receive_buf_closing().

Note that EXTPROC when ISTRIP or IUCLC is set continues to be
handled by n_tty_receive_char().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 50 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 75af7f5..099b02d 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1275,17 +1275,6 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 		process_echoes(tty);
 	}
 
-	if (tty->closing) {
-		if (I_IXON(tty)) {
-			if (c == START_CHAR(tty)) {
-				start_tty(tty);
-				process_echoes(tty);
-			} else if (c == STOP_CHAR(tty))
-				stop_tty(tty);
-		}
-		return;
-	}
-
 	/*
 	 * If the previous character was LNEXT, or we know that this
 	 * character is not one of the characters that we'll have to
@@ -1462,6 +1451,27 @@ handle_newline:
 	put_tty_queue(c, ldata);
 }
 
+static inline void
+n_tty_receive_char_closing(struct tty_struct *tty, unsigned char c)
+{
+	if (I_ISTRIP(tty))
+		c &= 0x7f;
+	if (I_IUCLC(tty) && L_IEXTEN(tty))
+		c = tolower(c);
+
+	if (I_IXON(tty)) {
+		if (c == STOP_CHAR(tty))
+			stop_tty(tty);
+		else if (c == START_CHAR(tty) ||
+			 (tty->stopped && !tty->flow_stopped && I_IXANY(tty) &&
+			  c != INTR_CHAR(tty) && c != QUIT_CHAR(tty) &&
+			  c != SUSP_CHAR(tty))) {
+			start_tty(tty);
+			process_echoes(tty);
+		}
+	}
+}
+
 static void
 n_tty_receive_char_flagged(struct tty_struct *tty, unsigned char c, char flag)
 {
@@ -1541,6 +1551,22 @@ n_tty_receive_buf_raw(struct tty_struct *tty, const unsigned char *cp,
 	}
 }
 
+static void
+n_tty_receive_buf_closing(struct tty_struct *tty, const unsigned char *cp,
+			  char *fp, int count)
+{
+	char flag = TTY_NORMAL;
+
+	while (count--) {
+		if (fp)
+			flag = *fp++;
+		if (likely(flag == TTY_NORMAL))
+			n_tty_receive_char_closing(tty, *cp++);
+		else
+			n_tty_receive_char_flagged(tty, *cp++, flag);
+	}
+}
+
 static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			  char *fp, int count)
 {
@@ -1551,6 +1577,8 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		n_tty_receive_buf_real_raw(tty, cp, fp, count);
 	else if (ldata->raw || (L_EXTPROC(tty) && !preops))
 		n_tty_receive_buf_raw(tty, cp, fp, count);
+	else if (tty->closing && !L_EXTPROC(tty))
+		n_tty_receive_buf_closing(tty, cp, fp, count);
 	else {
 		char flag = TTY_NORMAL;
 
-- 
1.8.1.2

