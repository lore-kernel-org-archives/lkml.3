Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3FYSzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:55:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3FYSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Subject: [ 88/95] tty: Fix transient pty write() EIO
Date: Tue, 25 Jun 2013 11:33:15 -0700
Message-Id: <20130625182203.590304094@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 7c61c3d8f44d5d822f758754287af644307b4af9 upstream.

Commit 699390354da6c258b65bf8fa79cfd5feaede50b6
('pty: Ignore slave pty close() if never successfully opened')
introduced a bug with ptys whereby a write() in parallel with an
open() on an existing pty could mistakenly indicate an I/O error.

Only indicate an I/O error if the condition on open() actually exists.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/pty.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -244,14 +244,9 @@ static void pty_flush_buffer(struct tty_
 
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
@@ -262,9 +257,11 @@ static int pty_open(struct tty_struct *t
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


