Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3CTRVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:21:15 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:58567 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3CTRVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:21:12 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <linux@izyk.ru>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] tty: Fix race condition if flushing tty flip buffers
Date: Wed, 20 Mar 2013 13:20:43 -0400
Message-Id: <1363800043-21449-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <5149AFD0.8020604@izyk.ru>
References: <5149AFD0.8020604@izyk.ru>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Ilya Zykov identified in his patch 'PROBLEM: Race condition in
tty buffer's function flush_to_ldisc()', a race condition exists
which allows a parallel flush_to_ldisc() to flush and free the tty
flip buffers while those buffers are in-use. For example,

  CPU 0                         |  CPU 1                                  |  CPU 2
                                | flush_to_ldisc()                        |
                                |  grab spin lock                         |
tty_buffer_flush()              |                                         | flush_to_ldisc()
 wait for spin lock             |                                         |  wait for spin lock
                                |   if (!test_and_set_bit(TTYP_FLUSHING)) |
                                |    while (next flip buffer)             |
                                |     ...                                 |
                                |     drop spin lock                      |
  grab spin lock                |                                         |
   if (test_bit(TTYP_FLUSHING)) |                                         |
    set_bit(TTYP_FLUSHPENDING)  |      receive_buf()                      |
    drop spin lock              |                                         |
                                |                                         |   grab spin lock
                                |                                         |    if (!test_and_set_bit(TTYP_FLUSHING))
                                |                                         |    if (test_bit(TTYP_FLUSHPENDING))
                                |                                         |    __tty_buffer_flush()

CPU 2 has just flushed and freed all tty flip buffers while CPU 1 is
transferring data from the head flip buffer.

The original patch was rejected under the assumption that parallel
flush_to_ldisc() was not possible. Because of necessary changes to
the workqueue api, work items can execute in parallel on SMP.

This patch differs slightly from the original patch by testing for
a pending flush _after_ each receive_buf(), since TTYP_FLUSHPENDING
can only be set while the lock is dropped around receive_buf().

Reported-by: Ilya Zykov <linux@izyk.ru>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index bb11993..9fd8acd 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -449,11 +449,6 @@ static void flush_to_ldisc(struct work_struct *work)
 				tty_buffer_free(port, head);
 				continue;
 			}
-			/* Ldisc or user is trying to flush the buffers
-			   we are feeding to the ldisc, stop feeding the
-			   line discipline as we want to empty the queue */
-			if (test_bit(TTYP_FLUSHPENDING, &port->iflags))
-				break;
 			if (!tty->receive_room)
 				break;
 			if (count > tty->receive_room)
@@ -465,17 +460,20 @@ static void flush_to_ldisc(struct work_struct *work)
 			disc->ops->receive_buf(tty, char_buf,
 							flag_buf, count);
 			spin_lock_irqsave(&buf->lock, flags);
+			/* Ldisc or user is trying to flush the buffers.
+			   We may have a deferred request to flush the
+			   input buffer, if so pull the chain under the lock
+			   and empty the queue */
+			if (test_bit(TTYP_FLUSHPENDING, &port->iflags)) {
+				__tty_buffer_flush(port);
+				clear_bit(TTYP_FLUSHPENDING, &port->iflags);
+				wake_up(&tty->read_wait);
+				break;
+			}
 		}
 		clear_bit(TTYP_FLUSHING, &port->iflags);
 	}
 
-	/* We may have a deferred request to flush the input buffer,
-	   if so pull the chain under the lock and empty the queue */
-	if (test_bit(TTYP_FLUSHPENDING, &port->iflags)) {
-		__tty_buffer_flush(port);
-		clear_bit(TTYP_FLUSHPENDING, &port->iflags);
-		wake_up(&tty->read_wait);
-	}
 	spin_unlock_irqrestore(&buf->lock, flags);
 
 	tty_ldisc_deref(disc);
-- 
1.8.1.2

