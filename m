Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab3FOO3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:29:01 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40639 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3FOO17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:27:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 14/20] n_tty: Split n_tty_receive_char()
Date: Sat, 15 Jun 2013 10:21:30 -0400
Message-Id: <1371306096-5571-15-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
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
index 1f21c97..3e96828 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1253,57 +1253,12 @@ n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
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
@@ -1456,6 +1411,60 @@ handle_newline:
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

