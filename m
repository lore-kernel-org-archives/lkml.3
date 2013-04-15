Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3DOPVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:21:40 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44734 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3DOPUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:20:05 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 06/24] n_tty: Split n_tty_chars_in_buffer() for reader-only interface
Date: Mon, 15 Apr 2013 11:19:10 -0400
Message-Id: <1366039168-8510-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_TTY .chars_in_buffer() method requires serialized access if
the current thread is not the single-consumer, n_tty_read().

Separate the internal interface; prepare for lockless read-side.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index c0a187a..c37f250 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -277,7 +277,7 @@ static void n_tty_flush_buffer(struct tty_struct *tty)
  *	Locking: read_lock
  */
 
-static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
+static ssize_t chars_in_buffer(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	unsigned long flags;
@@ -295,6 +295,11 @@ static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
 	return n;
 }
 
+static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
+{
+	return chars_in_buffer(tty);
+}
+
 /**
  *	is_utf8_continuation	-	utf8 multibyte check
  *	@c: byte to check
@@ -2030,7 +2035,7 @@ do_it_again:
 		}
 
 		/* If there is enough space in the read buffer now, let the
-		 * low-level driver know. We use n_tty_chars_in_buffer() to
+		 * low-level driver know. We use chars_in_buffer() to
 		 * check the buffer, as it now knows about canonical mode.
 		 * Otherwise, if the driver is throttled and the line is
 		 * longer than TTY_THRESHOLD_UNTHROTTLE in canonical mode,
@@ -2038,7 +2043,7 @@ do_it_again:
 		 */
 		while (1) {
 			tty_set_flow_change(tty, TTY_UNTHROTTLE_SAFE);
-			if (n_tty_chars_in_buffer(tty) > TTY_THRESHOLD_UNTHROTTLE)
+			if (chars_in_buffer(tty) > TTY_THRESHOLD_UNTHROTTLE)
 				break;
 			if (!tty->count)
 				break;
-- 
1.8.1.2

