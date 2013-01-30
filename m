Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3A3RrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:47:06 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:41309 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755866Ab3A3RqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:46:23 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Ilya Zykov <ilya@ilyx.ru>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 2/4] pty: Ignore slave pty close() if never successfully opened
Date: Wed, 30 Jan 2013 12:43:50 -0500
Message-Id: <1359567832-25318-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359567832-25318-1-git-send-email-peter@hurleysoftware.com>
References: <1359567832-25318-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the master and slave ptys are opened in parallel, the slave open
fails because the pty is still locked. This is as designed.
However, pty_close() is still called for the slave pty which sets
TTY_OTHER_CLOSED in the master pty. This can cause the master open
to fail as well.

Use a common pattern in other tty drivers by setting TTY_IO_ERROR
until the open is successful and only closing the pty if not set.

Note: the master pty always closes regardless of whether the open
was successful, so that proper cleanup can occur.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index b4e5769..6eb3e80 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -38,9 +38,12 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	if (tty->driver->subtype == PTY_TYPE_MASTER)
 		WARN_ON(tty->count > 1);
 	else {
+		if (test_bit(TTY_IO_ERROR, &tty->flags))
+			return;
 		if (tty->count > 2)
 			return;
 	}
+	set_bit(TTY_IO_ERROR, &tty->flags);
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
 	tty->packet = 0;
@@ -246,6 +249,8 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 	if (!tty || !tty->link)
 		goto out;
 
+	set_bit(TTY_IO_ERROR, &tty->flags);
+
 	retval = -EIO;
 	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
 		goto out;
@@ -254,6 +259,7 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 	if (tty->link->count != 1)
 		goto out;
 
+	clear_bit(TTY_IO_ERROR, &tty->flags);
 	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	set_bit(TTY_THROTTLED, &tty->flags);
 	retval = 0;
-- 
1.8.1.1

