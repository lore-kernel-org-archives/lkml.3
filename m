Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3FON6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:58:17 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40067 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3FON56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:57:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 11/16] tty: Only perform flip buffer flush from tty_buffer_flush()
Date: Sat, 15 Jun 2013 09:36:11 -0400
Message-Id: <1371303376-5028-12-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that dropping the buffer lock is not necessary (as result of
converting the spin lock to a mutex), the flip buffer flush no
longer needs to be handled by the buffer work.

Simply signal a flush is required; the buffer work will exit the
i/o loop, which allows tty_buffer_flush() to proceed.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 63 ++++++++++++++++--------------------------------
 include/linux/tty.h      |  1 -
 2 files changed, 21 insertions(+), 43 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index c3c606c..39cae61 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -189,19 +189,11 @@ void tty_buffer_flush(struct tty_struct *tty)
 	struct tty_port *port = tty->port;
 	struct tty_bufhead *buf = &port->buf;
 
-	mutex_lock(&buf->flush_mutex);
-	/* If the data is being pushed to the tty layer then we can't
-	   process it here. Instead set a flag and the flush_to_ldisc
-	   path will process the flush request before it exits */
-	if (test_bit(TTYP_FLUSHING, &port->iflags)) {
-		set_bit(TTYP_FLUSHPENDING, &port->iflags);
-		mutex_unlock(&buf->flush_mutex);
-		wait_event(tty->read_wait,
-				test_bit(TTYP_FLUSHPENDING, &port->iflags) == 0);
-		return;
-	}
+	set_bit(TTYP_FLUSHPENDING, &port->iflags);
 
+	mutex_lock(&buf->flush_mutex);
 	__tty_buffer_flush(port);
+	clear_bit(TTYP_FLUSHPENDING, &port->iflags);
 	mutex_unlock(&buf->flush_mutex);
 }
 
@@ -429,39 +421,26 @@ static void flush_to_ldisc(struct work_struct *work)
 
 	mutex_lock(&buf->flush_mutex);
 
-	if (!test_and_set_bit(TTYP_FLUSHING, &port->iflags)) {
-		while (1) {
-			struct tty_buffer *head = buf->head;
-			int count;
-
-			count = head->commit - head->read;
-			if (!count) {
-				if (head->next == NULL)
-					break;
-				buf->head = head->next;
-				tty_buffer_free(port, head);
-				continue;
-			}
-
-			mutex_unlock(&buf->flush_mutex);
-
-			count = receive_buf(tty, head, count);
-
-			mutex_lock(&buf->flush_mutex);
-
-			/* Ldisc or user is trying to flush the buffers.
-			   We may have a deferred request to flush the
-			   input buffer, if so pull the chain under the lock
-			   and empty the queue */
-			if (test_bit(TTYP_FLUSHPENDING, &port->iflags)) {
-				__tty_buffer_flush(port);
-				clear_bit(TTYP_FLUSHPENDING, &port->iflags);
-				wake_up(&tty->read_wait);
-				break;
-			} else if (!count)
+	while (1) {
+		struct tty_buffer *head = buf->head;
+		int count;
+
+		/* Ldisc or user is trying to flush the buffers. */
+		if (test_bit(TTYP_FLUSHPENDING, &port->iflags))
+			break;
+
+		count = head->commit - head->read;
+		if (!count) {
+			if (head->next == NULL)
 				break;
+			buf->head = head->next;
+			tty_buffer_free(port, head);
+			continue;
 		}
-		clear_bit(TTYP_FLUSHING, &port->iflags);
+
+		count = receive_buf(tty, head, count);
+		if (!count)
+			break;
 	}
 
 	mutex_unlock(&buf->flush_mutex);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1c8fef0..1d5bacc 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -213,7 +213,6 @@ struct tty_port {
 	wait_queue_head_t	delta_msr_wait;	/* Modem status change */
 	unsigned long		flags;		/* TTY flags ASY_*/
 	unsigned long		iflags;		/* TTYP_ internal flags */
-#define TTYP_FLUSHING			1  /* Flushing to ldisc in progress */
 #define TTYP_FLUSHPENDING		2  /* Queued buffer flush pending */
 	unsigned char		console:1,	/* port is a console */
 				low_latency:1;	/* direct buffer flush */
-- 
1.8.1.2

