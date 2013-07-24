Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3GXMbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:31:41 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:56212 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3GXMaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:30:30 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 5/9] n_tty: Factor PARMRK from normal per-char i/o
Date: Wed, 24 Jul 2013 08:29:53 -0400
Message-Id: <1374668997-29726-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
References: <20130724001259.GA9239@kroah.com>
 <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle PARMRK processing on the slow per-char i/o path.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 99bbee4..aed1e94 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1457,6 +1457,47 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 }
 
 static inline void
+n_tty_receive_char_fast(struct tty_struct *tty, unsigned char c)
+{
+	struct n_tty_data *ldata = tty->disc_data;
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
+		if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - 1)) {
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
+		put_tty_queue(c, ldata);
+		return;
+	}
+
+	n_tty_receive_char_special(tty, c);
+}
+
+static inline void
 n_tty_receive_char_closing(struct tty_struct *tty, unsigned char c)
 {
 	if (I_ISTRIP(tty))
@@ -1609,7 +1650,7 @@ n_tty_receive_buf_fast(struct tty_struct *tty, const unsigned char *cp,
 		if (fp)
 			flag = *fp++;
 		if (likely(flag == TTY_NORMAL))
-			n_tty_receive_char(tty, *cp++);
+			n_tty_receive_char_fast(tty, *cp++);
 		else
 			n_tty_receive_char_flagged(tty, *cp++, flag);
 	}
@@ -1628,7 +1669,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	else if (tty->closing && !L_EXTPROC(tty))
 		n_tty_receive_buf_closing(tty, cp, fp, count);
 	else {
-		if (!preops)
+		if (!preops && !I_PARMRK(tty))
 			n_tty_receive_buf_fast(tty, cp, fp, count);
 		else
 			n_tty_receive_buf_standard(tty, cp, fp, count);
-- 
1.8.1.2

