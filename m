Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3I0R1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:27:32 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:59626 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3I0R1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:27:30 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mikael Pettersson <mikpelinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] tty: Fix pty master read() after slave closes
Date: Fri, 27 Sep 2013 13:27:05 -0400
Message-Id: <1380302825-12539-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <524493E6.60300@hurleysoftware.com>
References: <524493E6.60300@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f95499c3030fe1bfad57745f2db1959c5b43dca8,
  n_tty: Don't wait for buffer work in read() loop
creates a race window which can cause a pty master read()
to miss the last pty slave write(s) and return -EIO instead,
thus signalling the pty slave is closed. This can happen when
the pty slave is written and immediately closed but before the
tty buffer i/o loop receives the new input; the pty master
read() is scheduled, sees its read buffer is empty and the
pty slave has been closed, and exits.

Because tty_flush_to_ldisc() has significant performance impact
for parallel i/o, rather than revert the commit, special case this
condition (ie., when the read buffer is empty and the 'other' pty
has been closed) and, only then, wait for buffer work to complete
before re-testing if the read buffer is still empty.

As before, subsequent pty master reads return any available data
until no more data is available, and then returns -EIO to
indicate the pty slave has closed.

Reported-by: Mikael Pettersson <mikpelinux@gmail.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 09505ff..4e69f3b 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2176,28 +2176,34 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 
 		if (!input_available_p(tty, 0)) {
 			if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
-				retval = -EIO;
-				break;
-			}
-			if (tty_hung_up_p(file))
-				break;
-			if (!timeout)
-				break;
-			if (file->f_flags & O_NONBLOCK) {
-				retval = -EAGAIN;
-				break;
-			}
-			if (signal_pending(current)) {
-				retval = -ERESTARTSYS;
-				break;
-			}
-			n_tty_set_room(tty);
-			up_read(&tty->termios_rwsem);
+				up_read(&tty->termios_rwsem);
+				tty_flush_to_ldisc(tty);
+				down_read(&tty->termios_rwsem);
+				if (!input_available_p(tty, 0)) {
+					retval = -EIO;
+					break;
+				}
+			} else {
+				if (tty_hung_up_p(file))
+					break;
+				if (!timeout)
+					break;
+				if (file->f_flags & O_NONBLOCK) {
+					retval = -EAGAIN;
+					break;
+				}
+				if (signal_pending(current)) {
+					retval = -ERESTARTSYS;
+					break;
+				}
+				n_tty_set_room(tty);
+				up_read(&tty->termios_rwsem);
 
-			timeout = schedule_timeout(timeout);
+				timeout = schedule_timeout(timeout);
 
-			down_read(&tty->termios_rwsem);
-			continue;
+				down_read(&tty->termios_rwsem);
+				continue;
+			}
 		}
 		__set_current_state(TASK_RUNNING);
 
-- 
1.8.1.2

