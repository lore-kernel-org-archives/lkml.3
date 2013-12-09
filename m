Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255Ab3LIOuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:50:44 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42645 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759232Ab3LIOum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:50:42 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Margarita Manterola <margamanterola@gmail.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Stas Sergeev <stsp@users.sourceforge.net>
Cc: Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, Caylan Van Larson <i@caylan.net>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3] n_tty: Fix buffer overruns with larger-than-4k pastes
Date: Mon,  9 Dec 2013 09:50:04 -0500
Message-Id: <1386600604-5092-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <529F7B35.4050509@list.ru>
References: <529F7B35.4050509@list.ru>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readline() inadvertently triggers an error recovery path when
pastes larger than 4k overrun the line discipline buffer. The
error recovery path discards input when the line discipline buffer
is full and operating in canonical mode and no newline has been
received. Because readline() changes the termios to non-canonical
mode to read the line char-by-char, the line discipline buffer
can become full, and then when readline() restores termios back
to canonical mode for the caller, the now-full line discipline
buffer triggers the error recovery.

When changing termios from non-canon to canon mode and the read
buffer contains data, simulate an EOF push _without_ the
DISABLED_CHAR in the read buffer. canon_copy_to_read_buf()
correctly interprets this condition and will return data in the
read buffer as one line.

Importantly for the readline() problem, the termios can be
changed back to non-canonical mode without changes to the read
buffer occurring; ie., as if the previous termios change had not
happened (as long as no intervening read took place).

Patch based on original proposal and discussion here
https://bugzilla.kernel.org/show_bug.cgi?id=55991
by Stas Sergeev <stsp@users.sourceforge.net>

Reported-by: Margarita Manterola <margamanterola@gmail.com>
Cc: Maximiliano Curia <maxy@gnuservers.com.ar>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Acked-by: Stas Sergeev <stsp@users.sourceforge.net>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---

v3 - Fix false-positive end-of-file indication when an actual
     EOF push coincidentally happens to be the next input
     char (but not @ line start)

 drivers/tty/n_tty.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 0f74945..e9e3e52 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -104,6 +104,7 @@ struct n_tty_data {
 
 	/* must hold exclusive termios_rwsem to reset these */
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
+	unsigned char push:1;
 
 	/* shared by producer and consumer */
 	char read_buf[N_TTY_BUF_SIZE];
@@ -1755,7 +1756,15 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 
 	if (!old || (old->c_lflag ^ tty->termios.c_lflag) & ICANON) {
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
-		ldata->line_start = ldata->canon_head = ldata->read_tail;
+		if (!L_ICANON(tty) || !read_cnt(ldata)) {
+			ldata->line_start = ldata->canon_head = ldata->read_tail;
+			ldata->push = 0;
+		} else {
+			set_bit((ldata->read_head - 1) & (N_TTY_BUF_SIZE - 1),
+				ldata->read_flags);
+			ldata->canon_head = ldata->read_head;
+			ldata->push = 1;
+		}
 		ldata->erasing = 0;
 		ldata->lnext = 0;
 	}
@@ -1958,6 +1967,12 @@ static int copy_from_read_buf(struct tty_struct *tty,
  *	it copies one line of input up to and including the line-delimiting
  *	character into the user-space buffer.
  *
+ *	NB: When termios is changed from non-canonical to canonical mode and
+ *	the read buffer contains data, n_tty_set_termios() simulates an EOF
+ *	push (as if C-d were input) _without_ the DISABLED_CHAR in the buffer.
+ *	This causes data already processed as input to be immediately available
+ *	as input although a newline has not been received.
+ *
  *	Called under the atomic_read_lock mutex
  *
  *	n_tty_read()/consumer path:
@@ -2007,6 +2022,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	if (found && read_buf(ldata, eol) == __DISABLED_CHAR) {
 		n--;
 		eof_push = !n && ldata->read_tail != ldata->line_start;
+		ldata->push = 0;
 	}
 
 	n_tty_trace("%s: eol:%zu found:%d n:%zu c:%zu size:%zu more:%zu\n",
@@ -2031,7 +2047,10 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	ldata->read_tail += c;
 
 	if (found) {
-		ldata->line_start = ldata->read_tail;
+		if (!ldata->push)
+			ldata->line_start = ldata->read_tail;
+		else
+			ldata->push = 0;
 		tty_audit_push(tty);
 	}
 	return eof_push ? -EAGAIN : 0;
-- 
1.8.1.2

