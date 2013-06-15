Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3FON5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:57:52 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40049 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3FON5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:57:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 10/16] tty: Ensure single-threaded flip buffer consumer with mutex
Date: Sat, 15 Jun 2013 09:36:10 -0400
Message-Id: <1371303376-5028-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buffer work may race with parallel tty_buffer_flush. Use a
mutex to guarantee exclusive modify access to the head flip
buffer.

Remove the unneeded spin lock.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/dgrp/dgrp_tty.c |  2 ++
 drivers/tty/tty_buffer.c        | 40 +++++++++++++++++++---------------------
 include/linux/tty.h             |  2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index 654f601..0d52de3 100644
--- a/drivers/staging/dgrp/dgrp_tty.c
+++ b/drivers/staging/dgrp/dgrp_tty.c
@@ -1120,7 +1120,9 @@ static void dgrp_tty_close(struct tty_struct *tty, struct file *file)
 				if (!sent_printer_offstr)
 					dgrp_tty_flush_buffer(tty);
 
+				spin_unlock_irqrestore(&nd->nd_lock, lock_flags);
 				tty_ldisc_flush(tty);
+				spin_lock_irqsave(&nd->nd_lock, lock_flags);
 				break;
 		}
 
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 685757c..c3c606c 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -157,8 +157,6 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
  *	flush all the buffers containing receive data. Caller must
  *	hold the buffer lock and must have ensured no parallel flush to
  *	ldisc is running.
- *
- *	Locking: Caller must hold tty->buf.lock
  */
 
 static void __tty_buffer_flush(struct tty_port *port)
@@ -182,29 +180,29 @@ static void __tty_buffer_flush(struct tty_port *port)
  *	being processed by flush_to_ldisc then we defer the processing
  *	to that function
  *
- *	Locking: none
+ *	Locking: takes flush_mutex to ensure single-threaded flip buffer
+ *		 'consumer'
  */
 
 void tty_buffer_flush(struct tty_struct *tty)
 {
 	struct tty_port *port = tty->port;
 	struct tty_bufhead *buf = &port->buf;
-	unsigned long flags;
-
-	spin_lock_irqsave(&buf->lock, flags);
 
+	mutex_lock(&buf->flush_mutex);
 	/* If the data is being pushed to the tty layer then we can't
 	   process it here. Instead set a flag and the flush_to_ldisc
 	   path will process the flush request before it exits */
 	if (test_bit(TTYP_FLUSHING, &port->iflags)) {
 		set_bit(TTYP_FLUSHPENDING, &port->iflags);
-		spin_unlock_irqrestore(&buf->lock, flags);
+		mutex_unlock(&buf->flush_mutex);
 		wait_event(tty->read_wait,
 				test_bit(TTYP_FLUSHPENDING, &port->iflags) == 0);
 		return;
-	} else
-		__tty_buffer_flush(port);
-	spin_unlock_irqrestore(&buf->lock, flags);
+	}
+
+	__tty_buffer_flush(port);
+	mutex_unlock(&buf->flush_mutex);
 }
 
 /**
@@ -408,9 +406,10 @@ receive_buf(struct tty_struct *tty, struct tty_buffer *head, int count)
  *	This routine is called out of the software interrupt to flush data
  *	from the buffer chain to the line discipline.
  *
- *	Locking: holds tty->buf.lock to guard buffer list. Drops the lock
- *	while invoking the line discipline receive_buf method. The
- *	receive_buf method is single threaded for each tty instance.
+ *	The receive_buf method is single threaded for each tty instance.
+ *
+ *	Locking: takes flush_mutex to ensure single-threaded flip buffer
+ *		 'consumer'
  */
 
 static void flush_to_ldisc(struct work_struct *work)
@@ -418,7 +417,6 @@ static void flush_to_ldisc(struct work_struct *work)
 	struct tty_port *port = container_of(work, struct tty_port, buf.work);
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_struct *tty;
-	unsigned long 	flags;
 	struct tty_ldisc *disc;
 
 	tty = port->itty;
@@ -429,7 +427,7 @@ static void flush_to_ldisc(struct work_struct *work)
 	if (disc == NULL)
 		return;
 
-	spin_lock_irqsave(&buf->lock, flags);
+	mutex_lock(&buf->flush_mutex);
 
 	if (!test_and_set_bit(TTYP_FLUSHING, &port->iflags)) {
 		while (1) {
@@ -444,11 +442,13 @@ static void flush_to_ldisc(struct work_struct *work)
 				tty_buffer_free(port, head);
 				continue;
 			}
-			spin_unlock_irqrestore(&buf->lock, flags);
+
+			mutex_unlock(&buf->flush_mutex);
 
 			count = receive_buf(tty, head, count);
 
-			spin_lock_irqsave(&buf->lock, flags);
+			mutex_lock(&buf->flush_mutex);
+
 			/* Ldisc or user is trying to flush the buffers.
 			   We may have a deferred request to flush the
 			   input buffer, if so pull the chain under the lock
@@ -464,7 +464,7 @@ static void flush_to_ldisc(struct work_struct *work)
 		clear_bit(TTYP_FLUSHING, &port->iflags);
 	}
 
-	spin_unlock_irqrestore(&buf->lock, flags);
+	mutex_unlock(&buf->flush_mutex);
 
 	tty_ldisc_deref(disc);
 }
@@ -514,15 +514,13 @@ EXPORT_SYMBOL(tty_flip_buffer_push);
  *
  *	Set up the initial state of the buffer management for a tty device.
  *	Must be called before the other tty buffer functions are used.
- *
- *	Locking: none
  */
 
 void tty_buffer_init(struct tty_port *port)
 {
 	struct tty_bufhead *buf = &port->buf;
 
-	spin_lock_init(&buf->lock);
+	mutex_init(&buf->flush_mutex);
 	tty_buffer_reset(&buf->sentinel, 0);
 	buf->head = &buf->sentinel;
 	buf->tail = &buf->sentinel;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 7c12454..1c8fef0 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -66,7 +66,7 @@ static inline char *flag_buf_ptr(struct tty_buffer *b, int ofs)
 
 struct tty_bufhead {
 	struct work_struct work;
-	spinlock_t lock;
+	struct mutex flush_mutex;
 	struct tty_buffer sentinel;
 	struct tty_buffer *head;	/* Queue head */
 	struct tty_buffer *tail;	/* Active buffer */
-- 
1.8.1.2

