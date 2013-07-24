Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3GXMag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:30:36 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:56219 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3GXMad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:30:33 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 6/9] n_tty: Remove overflow tests from receive_buf() path
Date: Wed, 24 Jul 2013 08:29:54 -0400
Message-Id: <1374668997-29726-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
References: <20130724001259.GA9239@kroah.com>
 <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always pre-figure the space available in the read_buf and limit
the inbound receive request to that amount.

For compatibility reasons with the non-flow-controlled interface,
n_tty_receive_buf() will continue filling read_buf until all data
has been received or receive_room() returns 0.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 85 +++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 48 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index aed1e94..0f33e0c 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -315,12 +315,9 @@ static inline void n_tty_check_unthrottle(struct tty_struct *tty)
  *	not active.
  */
 
-static void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
+static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 {
-	if (read_cnt(ldata) < N_TTY_BUF_SIZE) {
-		*read_buf_addr(ldata, ldata->read_head) = c;
-		ldata->read_head++;
-	}
+	*read_buf_addr(ldata, ldata->read_head++) = c;
 }
 
 /**
@@ -1332,11 +1329,6 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 			return;
 		}
 		if (c == '\n') {
-			if (read_cnt(ldata) >= N_TTY_BUF_SIZE) {
-				if (L_ECHO(tty))
-					process_output('\a', tty);
-				return;
-			}
 			if (L_ECHO(tty) || L_ECHONL(tty)) {
 				echo_char_raw('\n', ldata);
 				commit_echoes(tty);
@@ -1344,8 +1336,6 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 			goto handle_newline;
 		}
 		if (c == EOF_CHAR(tty)) {
-			if (read_cnt(ldata) >= N_TTY_BUF_SIZE)
-				return;
 			c = __DISABLED_CHAR;
 			goto handle_newline;
 		}
@@ -1353,11 +1343,6 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 		    (c == EOL2_CHAR(tty) && L_IEXTEN(tty))) {
 			parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty))
 				 ? 1 : 0;
-			if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk)) {
-				if (L_ECHO(tty))
-					process_output('\a', tty);
-				return;
-			}
 			/*
 			 * XXX are EOL_CHAR and EOL2_CHAR echoed?!?
 			 */
@@ -1387,12 +1372,6 @@ handle_newline:
 	}
 
 	parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
-	if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk - 1)) {
-		/* beep if no space */
-		if (L_ECHO(tty))
-			process_output('\a', tty);
-		return;
-	}
 	if (L_ECHO(tty)) {
 		finish_erasing(ldata);
 		if (c == '\n')
@@ -1431,14 +1410,6 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 			start_tty(tty);
 			process_echoes(tty);
 		}
-
-		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
-		if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk - 1)) {
-			/* beep if no space */
-			if (L_ECHO(tty))
-				process_output('\a', tty);
-			return;
-		}
 		if (L_ECHO(tty)) {
 			finish_erasing(ldata);
 			/* Record the column of first canon char. */
@@ -1447,6 +1418,7 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 			echo_char(c, tty);
 			commit_echoes(tty);
 		}
+		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
 		if (parmrk)
 			put_tty_queue(c, ldata);
 		put_tty_queue(c, ldata);
@@ -1475,13 +1447,6 @@ n_tty_receive_char_fast(struct tty_struct *tty, unsigned char c)
 			start_tty(tty);
 			process_echoes(tty);
 		}
-
-		if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - 1)) {
-			/* beep if no space */
-			if (L_ECHO(tty))
-				process_output('\a', tty);
-			return;
-		}
 		if (L_ECHO(tty)) {
 			finish_erasing(ldata);
 			/* Record the column of first canon char. */
@@ -1690,8 +1655,23 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			      char *fp, int count)
 {
+	int room, n;
+
 	down_read(&tty->termios_rwsem);
-	__receive_buf(tty, cp, fp, count);
+
+	while (1) {
+		room = receive_room(tty);
+		n = min(count, room);
+		if (!n)
+			break;
+		__receive_buf(tty, cp, fp, n);
+		cp += n;
+		if (fp)
+			fp += n;
+		count -= n;
+	}
+
+	tty->receive_room = room;
 	n_tty_check_throttle(tty);
 	up_read(&tty->termios_rwsem);
 }
@@ -1700,22 +1680,31 @@ static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
 			      char *fp, int count)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int room;
+	int room, n, rcvd = 0;
 
 	down_read(&tty->termios_rwsem);
 
-	tty->receive_room = room = receive_room(tty);
-	if (!room)
-		ldata->no_room = 1;
-	count = min(count, room);
-	if (count) {
-		__receive_buf(tty, cp, fp, count);
-		n_tty_check_throttle(tty);
+	while (1) {
+		room = receive_room(tty);
+		n = min(count, room);
+		if (!n) {
+			if (!room)
+				ldata->no_room = 1;
+			break;
+		}
+		__receive_buf(tty, cp, fp, n);
+		cp += n;
+		if (fp)
+			fp += n;
+		count -= n;
+		rcvd += n;
 	}
 
+	tty->receive_room = room;
+	n_tty_check_throttle(tty);
 	up_read(&tty->termios_rwsem);
 
-	return count;
+	return rcvd;
 }
 
 int is_ignored(int sig)
-- 
1.8.1.2

