Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab3FMT47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:56:59 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:56192 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3FMT46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:56:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Howells <dhowells@redhat.com>,
        Mikael Pettersson <mikpe@it.uu.se>,
        Orion Poplawski <orion@cora.nwra.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] tty: Fix transient pty write() EIO
Date: Thu, 13 Jun 2013 15:56:37 -0400
Message-Id: <1371153397-3687-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <51B9F36B.6020802@hurleysoftware.com>
References: <51B9F36B.6020802@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 699390354da6c258b65bf8fa79cfd5feaede50b6
('pty: Ignore slave pty close() if never successfully opened')
introduced a bug with ptys whereby a write() in parallel with an
open() on an existing pty could mistakenly indicate an I/O error.

Only indicate an I/O error if the condition on open() actually exists.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 9c2f1bc..dd08d3d 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -238,14 +238,9 @@ static void pty_flush_buffer(struct tty_struct *tty)
 
 static int pty_open(struct tty_struct *tty, struct file *filp)
 {
-	int	retval = -ENODEV;
-
 	if (!tty || !tty->link)
-		goto out;
-
-	set_bit(TTY_IO_ERROR, &tty->flags);
+		return -ENODEV;
 
-	retval = -EIO;
 	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
 		goto out;
 	if (test_bit(TTY_PTY_LOCK, &tty->link->flags))
@@ -256,9 +251,11 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 	clear_bit(TTY_IO_ERROR, &tty->flags);
 	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	set_bit(TTY_THROTTLED, &tty->flags);
-	retval = 0;
+	return 0;
+
 out:
-	return retval;
+	set_bit(TTY_IO_ERROR, &tty->flags);
+	return -EIO;
 }
 
 static void pty_set_termios(struct tty_struct *tty,
-- 
1.8.1.2

