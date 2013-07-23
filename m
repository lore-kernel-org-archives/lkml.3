Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab3GWNPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:15:38 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:47701 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3GWNPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:15:36 -0400
X-Greylist: delayed 1660 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2013 09:15:36 EDT
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 23/24] n_tty: Special case pty flow control
Date: Tue, 23 Jul 2013 08:47:30 -0400
Message-Id: <1374583650-3853-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-24-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-24-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pty driver forces ldisc flow control on, regardless of available
receive buffer space, so the writer can be woken whenever unthrottle
is called. However, this 'forced throttle' has performance
consequences, as multiple atomic operations are necessary to
unthrottle and perform the write wakeup for every input line (in
canonical mode).

Instead, short-circuit the unthrottle if the tty is a pty and perform
the write wakeup directly.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---

v5: fix regression in unusual pty/ldisc configurations where
    i/o fails to make forward progress

 drivers/tty/n_tty.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 0e3efc1..59eb444 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -231,6 +231,8 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
 
 static inline void n_tty_check_throttle(struct tty_struct *tty)
 {
+	if (tty->driver->type == TTY_DRIVER_TYPE_PTY)
+		return;
 	/*
 	 * Check the remaining room for the input canonicalization
 	 * mode.  We don't want to throttle the driver if we're in
@@ -250,6 +252,18 @@ static inline void n_tty_check_throttle(struct tty_struct *tty)
 
 static inline void n_tty_check_unthrottle(struct tty_struct *tty)
 {
+	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
+	    tty->link->ldisc->ops->write_wakeup == n_tty_write_wakeup) {
+		if (chars_in_buffer(tty) > TTY_THRESHOLD_UNTHROTTLE)
+			return;
+		if (!tty->count)
+			return;
+		n_tty_set_room(tty);
+		n_tty_write_wakeup(tty->link);
+		wake_up_interruptible_poll(&tty->link->write_wait, POLLOUT);
+		return;
+	}
+
 	/* If there is enough space in the read buffer now, let the
 	 * low-level driver know. We use chars_in_buffer() to
 	 * check the buffer, as it now knows about canonical mode.
-- 
1.8.1.2

