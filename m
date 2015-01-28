Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881AbbA1B4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:56:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278AbbA1Bi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Francesco Ruggeri <fruggeri@arista.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.14 43/77] tty: Fix pty master poll() after slave closes v2
Date: Tue, 27 Jan 2015 17:27:21 -0800
Message-Id: <20150128012747.248627243@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Ruggeri <fruggeri@aristanetworks.com>

commit c4dc304677e8d566572c4738d95c48be150c6606 upstream.

Commit f95499c3030f ("n_tty: Don't wait for buffer work in read() loop")
introduces a race window where a pty master can be signalled that the pty
slave was closed before all the data that the slave wrote is delivered.
Commit f8747d4a466a ("tty: Fix pty master read() after slave closes") fixed the
problem in case of n_tty_read, but the problem still exists for n_tty_poll.
This can be seen by running 'for ((i=0; i<100;i++));do ./test.py ;done'
where test.py is:

import os, select, pty

(pid, pty_fd) = pty.fork()

if pid == 0:
   os.write(1, 'This string should be received by parent')
else:
   poller = select.epoll()
   poller.register( pty_fd, select.EPOLLIN )
   ready = poller.poll( 1 * 1000 )
   for fd, events in ready:
      if not events & select.EPOLLIN:
         print 'missed POLLIN event'
      else:
         print os.read(fd, 100)
   poller.close()

The string from the slave is missed several times.
This patch takes the same approach as the fix for read and special cases
this condition for poll.
Tested on 3.16.

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2417,12 +2417,17 @@ static unsigned int n_tty_poll(struct tt
 
 	poll_wait(file, &tty->read_wait, wait);
 	poll_wait(file, &tty->write_wait, wait);
+	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
+		mask |= POLLHUP;
 	if (input_available_p(tty, 1))
 		mask |= POLLIN | POLLRDNORM;
+	else if (mask & POLLHUP) {
+		tty_flush_to_ldisc(tty);
+		if (input_available_p(tty, 1))
+			mask |= POLLIN | POLLRDNORM;
+	}
 	if (tty->packet && tty->link->ctrl_status)
 		mask |= POLLPRI | POLLIN | POLLRDNORM;
-	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
-		mask |= POLLHUP;
 	if (tty_hung_up_p(file))
 		mask |= POLLHUP;
 	if (!(mask & (POLLHUP | POLLIN | POLLRDNORM))) {


