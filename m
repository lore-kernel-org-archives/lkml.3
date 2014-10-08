Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaJHT1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:27:48 -0400
Received: from mx.aristanetworks.com ([162.210.130.12]:36266 "EHLO
	prod-mx.aristanetworks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752730AbaJHT1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:27:47 -0400
Date: Wed, 08 Oct 2014 12:27:46 -0700
To: peter@hurleysoftware.com, jslaby@suse.cz, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 1/1] tty: Fix pty master poll() after slave closes
Cc: fruggeri@arista.com
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20141008192746.5F9C8485A77@fruggeri-Arora18.sjc.aristanetworks.com>
From: fruggeri@aristanetworks.com (Francesco Ruggeri)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/tty/n_tty.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f44f1ba..cf16aeb 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2413,14 +2413,16 @@ static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
 
 	poll_wait(file, &tty->read_wait, wait);
 	poll_wait(file, &tty->write_wait, wait);
-	if (input_available_p(tty, 1))
-		mask |= POLLIN | POLLRDNORM;
 	if (tty->packet && tty->link->ctrl_status)
 		mask |= POLLPRI | POLLIN | POLLRDNORM;
 	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
 		mask |= POLLHUP;
 	if (tty_hung_up_p(file))
 		mask |= POLLHUP;
+	if (mask & POLLHUP)
+		tty_flush_to_ldisc(tty);
+	if (input_available_p(tty, 1))
+		mask |= POLLIN | POLLRDNORM;
 	if (!(mask & (POLLHUP | POLLIN | POLLRDNORM))) {
 		if (MIN_CHAR(tty) && !TIME_CHAR(tty))
 			ldata->minimum_to_wake = MIN_CHAR(tty);
-- 
1.8.1.4

