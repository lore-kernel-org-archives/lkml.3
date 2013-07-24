Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3GXMa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:30:27 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:56200 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3GXMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:30:25 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 3/9] n_tty: Split n_tty_receive_char()
Date: Wed, 24 Jul 2013 08:29:51 -0400
Message-Id: <1374668997-29726-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
References: <20130724001259.GA9239@kroah.com>
 <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor 'special' per-char processing into standalone fn,
n_tty_receive_char_special(), which handles processing for chars
marked in the char_map.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 103 ++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 47 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d3b4129..140b555 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1254,57 +1254,12 @@ n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
  *		otherwise, publishes read_head via put_tty_queue()
  */
 
-static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
+static void
+n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int parmrk;
 
-	if (I_ISTRIP(tty))
-		c &= 0x7f;
-	if (I_IUCLC(tty) && L_IEXTEN(tty))
-		c = tolower(c);
-
-	if (L_EXTPROC(tty)) {
-		put_tty_queue(c, ldata);
-		return;
-	}
-
-	/*
-	 * If the previous character was LNEXT, or we know that this
-	 * character is not one of the characters that we'll have to
-	 * handle specially, do shortcut processing to speed things
-	 * up.
-	 */
-	if (!test_bit(c, ldata->char_map) || ldata->lnext) {
-		ldata->lnext = 0;
-
-		if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
-		    I_IXANY(tty)) {
-			start_tty(tty);
-			process_echoes(tty);
-		}
-
-		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
-		if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk - 1)) {
-			/* beep if no space */
-			if (L_ECHO(tty))
-				process_output('\a', tty);
-			return;
-		}
-		if (L_ECHO(tty)) {
-			finish_erasing(ldata);
-			/* Record the column of first canon char. */
-			if (ldata->canon_head == ldata->read_head)
-				echo_set_canon_col(ldata);
-			echo_char(c, tty);
-			commit_echoes(tty);
-		}
-		if (parmrk)
-			put_tty_queue(c, ldata);
-		put_tty_queue(c, ldata);
-		return;
-	}
-
 	if (I_IXON(tty)) {
 		if (c == START_CHAR(tty)) {
 			start_tty(tty);
@@ -1457,6 +1412,60 @@ handle_newline:
 	put_tty_queue(c, ldata);
 }
 
+static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+	int parmrk;
+
+	if (I_ISTRIP(tty))
+		c &= 0x7f;
+	if (I_IUCLC(tty) && L_IEXTEN(tty))
+		c = tolower(c);
+
+	if (L_EXTPROC(tty)) {
+		put_tty_queue(c, ldata);
+		return;
+	}
+
+	/*
+	 * If the previous character was LNEXT, or we know that this
+	 * character is not one of the characters that we'll have to
+	 * handle specially, do shortcut processing to speed things
+	 * up.
+	 */
+	if (!test_bit(c, ldata->char_map) || ldata->lnext) {
+		ldata->lnext = 0;
+
+		if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
+		    I_IXANY(tty)) {
+			start_tty(tty);
+			process_echoes(tty);
+		}
+
+		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
+		if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk - 1)) {
+			/* beep if no space */
+			if (L_ECHO(tty))
+				process_output('\a', tty);
+			return;
+		}
+		if (L_ECHO(tty)) {
+			finish_erasing(ldata);
+			/* Record the column of first canon char. */
+			if (ldata->canon_head == ldata->read_head)
+				echo_set_canon_col(ldata);
+			echo_char(c, tty);
+			commit_echoes(tty);
+		}
+		if (parmrk)
+			put_tty_queue(c, ldata);
+		put_tty_queue(c, ldata);
+		return;
+	}
+
+	n_tty_receive_char_special(tty, c);
+}
+
 static inline void
 n_tty_receive_char_closing(struct tty_struct *tty, unsigned char c)
 {
-- 
1.8.1.2

