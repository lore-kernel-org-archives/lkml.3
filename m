Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab3GXMam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:30:42 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:56243 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3GXMaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:30:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 8/9] n_tty: Factor LNEXT processing from per-char i/o path
Date: Wed, 24 Jul 2013 08:29:56 -0400
Message-Id: <1374668997-29726-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
References: <20130724001259.GA9239@kroah.com>
 <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LNEXT processing accounts for ~15% of total cpu time in end-to-end
tty i/o; factor the lnext test/clear from the per-char i/o path.

Instead, attempt to immediately handle the literal next char if not
at the end of this received buffer; otherwise, handle the first char
of the next received buffer as the literal next char, then continue
with normal i/o.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 166 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 94 insertions(+), 72 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f516247..d8cf96a 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1248,9 +1248,11 @@ n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
  *		caller holds non-exclusive termios_rwsem
  *		publishes canon_head if canonical mode is active
  *		otherwise, publishes read_head via put_tty_queue()
+ *
+ *	Returns 1 if LNEXT was received, else returns 0
  */
 
-static void
+static int
 n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 {
 	struct n_tty_data *ldata = tty->disc_data;
@@ -1260,24 +1262,24 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 		if (c == START_CHAR(tty)) {
 			start_tty(tty);
 			commit_echoes(tty);
-			return;
+			return 0;
 		}
 		if (c == STOP_CHAR(tty)) {
 			stop_tty(tty);
-			return;
+			return 0;
 		}
 	}
 
 	if (L_ISIG(tty)) {
 		if (c == INTR_CHAR(tty)) {
 			n_tty_receive_signal_char(tty, SIGINT, c);
-			return;
+			return 0;
 		} else if (c == QUIT_CHAR(tty)) {
 			n_tty_receive_signal_char(tty, SIGQUIT, c);
-			return;
+			return 0;
 		} else if (c == SUSP_CHAR(tty)) {
 			n_tty_receive_signal_char(tty, SIGTSTP, c);
-			return;
+			return 0;
 		}
 	}
 
@@ -1288,7 +1290,7 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 
 	if (c == '\r') {
 		if (I_IGNCR(tty))
-			return;
+			return 0;
 		if (I_ICRNL(tty))
 			c = '\n';
 	} else if (c == '\n' && I_INLCR(tty))
@@ -1299,7 +1301,7 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 		    (c == WERASE_CHAR(tty) && L_IEXTEN(tty))) {
 			eraser(c, tty);
 			commit_echoes(tty);
-			return;
+			return 0;
 		}
 		if (c == LNEXT_CHAR(tty) && L_IEXTEN(tty)) {
 			ldata->lnext = 1;
@@ -1311,10 +1313,9 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 					commit_echoes(tty);
 				}
 			}
-			return;
+			return 1;
 		}
-		if (c == REPRINT_CHAR(tty) && L_ECHO(tty) &&
-		    L_IEXTEN(tty)) {
+		if (c == REPRINT_CHAR(tty) && L_ECHO(tty) && L_IEXTEN(tty)) {
 			size_t tail = ldata->canon_head;
 
 			finish_erasing(ldata);
@@ -1325,7 +1326,7 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 				tail++;
 			}
 			commit_echoes(tty);
-			return;
+			return 0;
 		}
 		if (c == '\n') {
 			if (L_ECHO(tty) || L_ECHONL(tty)) {
@@ -1366,7 +1367,7 @@ handle_newline:
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 			if (waitqueue_active(&tty->read_wait))
 				wake_up_interruptible(&tty->read_wait);
-			return;
+			return 0;
 		}
 	}
 
@@ -1388,43 +1389,36 @@ handle_newline:
 		put_tty_queue(c, ldata);
 
 	put_tty_queue(c, ldata);
+	return 0;
 }
 
-static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
+static inline void
+n_tty_receive_char_inline(struct tty_struct *tty, unsigned char c)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int parmrk;
 
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
-		if (L_ECHO(tty)) {
-			finish_erasing(ldata);
-			/* Record the column of first canon char. */
-			if (ldata->canon_head == ldata->read_head)
-				echo_set_canon_col(ldata);
-			echo_char(c, tty);
-			commit_echoes(tty);
-		}
-		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
-		if (parmrk)
-			put_tty_queue(c, ldata);
-		put_tty_queue(c, ldata);
-		return;
+	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) && I_IXANY(tty)) {
+		start_tty(tty);
+		process_echoes(tty);
 	}
+	if (L_ECHO(tty)) {
+		finish_erasing(ldata);
+		/* Record the column of first canon char. */
+		if (ldata->canon_head == ldata->read_head)
+			echo_set_canon_col(ldata);
+		echo_char(c, tty);
+		commit_echoes(tty);
+	}
+	parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
+	if (parmrk)
+		put_tty_queue(c, ldata);
+	put_tty_queue(c, ldata);
+}
 
-	n_tty_receive_char_special(tty, c);
+static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
+{
+	n_tty_receive_char_inline(tty, c);
 }
 
 static inline void
@@ -1432,33 +1426,19 @@ n_tty_receive_char_fast(struct tty_struct *tty, unsigned char c)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
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
-		if (L_ECHO(tty)) {
-			finish_erasing(ldata);
-			/* Record the column of first canon char. */
-			if (ldata->canon_head == ldata->read_head)
-				echo_set_canon_col(ldata);
-			echo_char(c, tty);
-			commit_echoes(tty);
-		}
-		put_tty_queue(c, ldata);
-		return;
+	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) && I_IXANY(tty)) {
+		start_tty(tty);
+		process_echoes(tty);
 	}
-
-	n_tty_receive_char_special(tty, c);
+	if (L_ECHO(tty)) {
+		finish_erasing(ldata);
+		/* Record the column of first canon char. */
+		if (ldata->canon_head == ldata->read_head)
+			echo_set_canon_col(ldata);
+		echo_char(c, tty);
+		commit_echoes(tty);
+	}
+	put_tty_queue(c, ldata);
 }
 
 static inline void
@@ -1505,6 +1485,22 @@ n_tty_receive_char_flagged(struct tty_struct *tty, unsigned char c, char flag)
 	}
 }
 
+static void
+n_tty_receive_char_lnext(struct tty_struct *tty, unsigned char c, char flag)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+
+	ldata->lnext = 0;
+	if (likely(flag == TTY_NORMAL)) {
+		if (I_ISTRIP(tty))
+			c &= 0x7f;
+		if (I_IUCLC(tty) && L_IEXTEN(tty))
+			c = tolower(c);
+		n_tty_receive_char(tty, c);
+	} else
+		n_tty_receive_char_flagged(tty, c, flag);
+}
+
 /**
  *	n_tty_receive_buf	-	data receive
  *	@tty: terminal device
@@ -1598,7 +1594,14 @@ n_tty_receive_buf_standard(struct tty_struct *tty, const unsigned char *cp,
 				put_tty_queue(c, ldata);
 				continue;
 			}
-			n_tty_receive_char(tty, c);
+			if (!test_bit(c, ldata->char_map))
+				n_tty_receive_char_inline(tty, c);
+			else if (n_tty_receive_char_special(tty, c) && count) {
+				if (fp)
+					flag = *fp++;
+				n_tty_receive_char_lnext(tty, *cp++, flag);
+				count--;
+			}
 		} else
 			n_tty_receive_char_flagged(tty, *cp++, flag);
 	}
@@ -1608,14 +1611,24 @@ static void
 n_tty_receive_buf_fast(struct tty_struct *tty, const unsigned char *cp,
 		       char *fp, int count)
 {
+	struct n_tty_data *ldata = tty->disc_data;
 	char flag = TTY_NORMAL;
 
 	while (count--) {
 		if (fp)
 			flag = *fp++;
-		if (likely(flag == TTY_NORMAL))
-			n_tty_receive_char_fast(tty, *cp++);
-		else
+		if (likely(flag == TTY_NORMAL)) {
+			unsigned char c = *cp++;
+
+			if (!test_bit(c, ldata->char_map))
+				n_tty_receive_char_fast(tty, c);
+			else if (n_tty_receive_char_special(tty, c) && count) {
+				if (fp)
+					flag = *fp++;
+				n_tty_receive_char_lnext(tty, *cp++, flag);
+				count--;
+			}
+		} else
 			n_tty_receive_char_flagged(tty, *cp++, flag);
 	}
 }
@@ -1633,6 +1646,15 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	else if (tty->closing && !L_EXTPROC(tty))
 		n_tty_receive_buf_closing(tty, cp, fp, count);
 	else {
+		if (ldata->lnext) {
+			char flag = TTY_NORMAL;
+
+			if (fp)
+				flag = *fp++;
+			n_tty_receive_char_lnext(tty, *cp++, flag);
+			count--;
+		}
+
 		if (!preops && !I_PARMRK(tty))
 			n_tty_receive_buf_fast(tty, cp, fp, count);
 		else
-- 
1.8.1.2

