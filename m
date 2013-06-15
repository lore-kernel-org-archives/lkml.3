Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3FOOWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:22:32 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40490 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab3FOOWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:22:06 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 06/20] n_tty: Factor 'real raw' receive_buf into standalone fn
Date: Sat, 15 Jun 2013 10:21:22 -0400
Message-Id: <1371306096-5571-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to modal receive_buf() processing; factor real_raw
receive_buf() into n_tty_receive_buf_real_raw().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 51 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f959dc9..309d964 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -242,7 +242,7 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
 		kill_fasync(&tty->fasync, SIGIO, POLL_OUT);
 }
 
-static inline void n_tty_check_throttle(struct tty_struct *tty)
+static void n_tty_check_throttle(struct tty_struct *tty)
 {
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY)
 		return;
@@ -1480,6 +1480,28 @@ handle_newline:
  *		publishes read_head and canon_head
  */
 
+static void
+n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
+			   char *fp, int count)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+	size_t n, head;
+
+	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
+	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
+	n = min_t(size_t, count, n);
+	memcpy(read_buf_addr(ldata, head), cp, n);
+	ldata->read_head += n;
+	cp += n;
+	count -= n;
+
+	head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
+	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
+	n = min_t(size_t, count, n);
+	memcpy(read_buf_addr(ldata, head), cp, n);
+	ldata->read_head += n;
+}
+
 static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			  char *fp, int count)
 {
@@ -1487,23 +1509,9 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	char	flags = TTY_NORMAL;
 	char	buf[64];
 
-	if (ldata->real_raw) {
-		size_t n, head;
-
-		head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
-		n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
-		n = min_t(size_t, count, n);
-		memcpy(read_buf_addr(ldata, head), cp, n);
-		ldata->read_head += n;
-		cp += n;
-		count -= n;
-
-		head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
-		n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
-		n = min_t(size_t, count, n);
-		memcpy(read_buf_addr(ldata, head), cp, n);
-		ldata->read_head += n;
-	} else {
+	if (ldata->real_raw)
+		n_tty_receive_buf_real_raw(tty, cp, fp, count);
+	else {
 		while (count--) {
 			if (fp)
 				flags = *fp++;
@@ -1539,8 +1547,6 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		if (waitqueue_active(&tty->read_wait))
 			wake_up_interruptible(&tty->read_wait);
 	}
-
-	n_tty_check_throttle(tty);
 }
 
 static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
@@ -1548,6 +1554,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 {
 	down_read(&tty->termios_rwsem);
 	__receive_buf(tty, cp, fp, count);
+	n_tty_check_throttle(tty);
 	up_read(&tty->termios_rwsem);
 }
 
@@ -1563,8 +1570,10 @@ static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
 	if (!room)
 		ldata->no_room = 1;
 	count = min(count, room);
-	if (count)
+	if (count) {
 		__receive_buf(tty, cp, fp, count);
+		n_tty_check_throttle(tty);
+	}
 
 	up_read(&tty->termios_rwsem);
 
-- 
1.8.1.2

