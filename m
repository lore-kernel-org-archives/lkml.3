Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab3LJWM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:12:27 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:57961 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3LJWM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:12:26 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stas Sergeev <stsp@list.ru>,
        Margarita Manterola <margamanterola@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Caylan Van Larson <i@caylan.net>,
        Peter Hurley <peter@hurleysoftware.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Pavel Machek <pavel@ucw.cz>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: [PATCH v4] n_tty: Fix buffer overruns with larger-than-4k pastes
Date: Tue, 10 Dec 2013 17:12:02 -0500
Message-Id: <1386713522-6959-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <52A79030.9090403@hurleysoftware.com>
References: <52A79030.9090403@hurleysoftware.com>
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
DISABLED_CHAR in the read buffer.

Importantly for the readline() problem, the termios can be
changed back to non-canonical mode without changes to the read
buffer occurring; ie., as if the previous termios change had not
happened (as long as no intervening read took place).

Preserve existing userspace behavior which allows '\0's already
received in non-canon mode to be read as '\0's in canon mode
(rather than trigger add'l EOF pushes or an actual EOF).

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

v4 - Always reset line_start to read_tail when changing icanon
   - Reset 'fake' EOF push status when flushing buffers
   - Allow '\0' written in non-canon to be read in canon
     (preserves existing userspace-visible behavior)

 drivers/tty/n_tty.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 669a507..1a25552 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -105,6 +105,7 @@ struct n_tty_data {
 
 	/* must hold exclusive termios_rwsem to reset these */
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
+	unsigned char push:1;
 
 	/* shared by producer and consumer */
 	char read_buf[N_TTY_BUF_SIZE];
@@ -341,6 +342,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
 
 	ldata->erasing = 0;
 	bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
+	ldata->push = 0;
 }
 
 static void n_tty_packet_mode_flush(struct tty_struct *tty)
@@ -1758,7 +1760,16 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 
 	if (!old || (old->c_lflag ^ tty->termios.c_lflag) & ICANON) {
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
-		ldata->line_start = ldata->canon_head = ldata->read_tail;
+		ldata->line_start = ldata->read_tail;
+		if (!L_ICANON(tty) || !read_cnt(ldata)) {
+			ldata->canon_head = ldata->read_tail;
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
@@ -1964,6 +1975,12 @@ static int copy_from_read_buf(struct tty_struct *tty,
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
@@ -2010,7 +2027,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	n += found;
 	c = n;
 
-	if (found && read_buf(ldata, eol) == __DISABLED_CHAR) {
+	if (found && !ldata->push && read_buf(ldata, eol) == __DISABLED_CHAR) {
 		n--;
 		eof_push = !n && ldata->read_tail != ldata->line_start;
 	}
@@ -2037,7 +2054,10 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
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

