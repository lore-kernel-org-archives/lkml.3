Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab3LBVM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:12:58 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:51337 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384Ab3LBVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:12:33 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 3/4] tty: Fix pty flush
Date: Mon,  2 Dec 2013 16:12:04 -0500
Message-Id: <1386018725-4781-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pty driver writes output directly to the 'other' pty's flip
buffers; ie., the pty's write buffer is the other pty's flip buffer.
Flushing the write buffer for a pty was a FIXME because flushing the
other pty's flip buffer allows for a potential deadlock:

CPU 0                                        CPU 1
flush_to_ldisc
  mutex_lock(buf->lock)  <-----------+
  receive_buf                        |
    .                                |  flush_to_ldisc
    .                             +--|--> mutex_lock(buf->lock)
    tty_driver_flush_buffer       |  |    receive_buf
      pty_flush_buffer            |  |      .
        tty_buffer_flush          |  |      .
          mutex_lock(buf->lock) --+  |      tty_buffer_flush_buffer
                                     |        pty_flush_buffer
                                     |          tty_buffer_flush
                                     +--------    mutex_lock(buf->lock)

To resolve the lock inversion deadlock:
- Add a flush_nested() method to the pty driver (which is invoked by
  the line discipline when flushing the driver write buffer in the
  receive_buf() handling).
- Add tty_buffer_flush_nested(), which relies on the caller holding
  its own buf->lock and a shared mutex to so the state of the 'other'
  CPU can be inferred where a deadlock might otherwise have occurred.

Use the port->buf_mutex (which is otherwise unused by the pty driver)
of the lowest-address tty to ensure only a single mutex is used,
regardless of which pty is performing the flush.

Annotate the mutex lock as a nested lock class for lockdep: note the
buf->lock claimed here is the 'other' pty's buf->lock.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c        | 32 ++++++++++++++++++++-
 drivers/tty/tty_buffer.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/tty_flip.h |  2 ++
 3 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 25c9bc7..54a2d6a 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -227,7 +227,33 @@ static void pty_flush_buffer(struct tty_struct *tty)
 
 	if (!to)
 		return;
-	/* tty_buffer_flush(to); FIXME */
+
+	tty_buffer_flush(to);
+
+	if (to->packet) {
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
+		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
+		wake_up_interruptible(&to->read_wait);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	}
+}
+
+static void pty_flush_buffer_nested(struct tty_struct *tty)
+{
+	struct tty_struct *to = tty->link;
+	unsigned long flags;
+	struct mutex *mutex;
+
+	if (!to)
+		return;
+
+	/* Use a single mutex for the pty pair */
+	if (tty < to)
+		mutex = &tty->port->buf_mutex;
+	else
+		mutex = &to->port->buf_mutex;
+	tty_buffer_flush_nested(to, mutex);
+
 	if (to->packet) {
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
@@ -451,6 +477,7 @@ static const struct tty_operations master_pty_ops_bsd = {
 	.write = pty_write,
 	.write_room = pty_write_room,
 	.flush_buffer = pty_flush_buffer,
+	.flush_nested = pty_flush_buffer_nested,
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
@@ -467,6 +494,7 @@ static const struct tty_operations slave_pty_ops_bsd = {
 	.write = pty_write,
 	.write_room = pty_write_room,
 	.flush_buffer = pty_flush_buffer,
+	.flush_nested = pty_flush_buffer_nested,
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
@@ -626,6 +654,7 @@ static const struct tty_operations ptm_unix98_ops = {
 	.write = pty_write,
 	.write_room = pty_write_room,
 	.flush_buffer = pty_flush_buffer,
+	.flush_nested = pty_flush_buffer_nested,
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
@@ -644,6 +673,7 @@ static const struct tty_operations pty_unix98_ops = {
 	.write = pty_write,
 	.write_room = pty_write_room,
 	.flush_buffer = pty_flush_buffer,
+	.flush_nested = pty_flush_buffer_nested,
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 2cea1ab..4d0d2ef 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -233,6 +233,81 @@ void tty_buffer_flush(struct tty_struct *tty)
 }
 
 /**
+ *	tty_buffer_flush_nested		-	flush full tty buffers
+ *	@tty: tty to flush
+ *	@mutex: lock to distinguish 1st from subsequent caller
+ *
+ *	Special-purpose buffer flush for ptys receiving data (in ldisc's
+ *	receive_buf() path). Resolves lock inversion deadlock when both
+ *	paired ptys concurrently attempt flushing the write buffer (the
+ *	other's input tty_buffers).
+ *
+ *	Locking: Caller already holds its buf->lock (@tty is the 'other' pty)
+ *
+ *	Possible lock scenarios:
+ *	1) Caller successfully claims @mutex and @tty->port->buf->lock;
+ *	   no contention, flush buffer
+ *	2) Caller successfully claims @mutex but not @tty->port->buf->lock;
+ *	   wait for @tty->port->buf->lock;
+ *	   2a) @tty->port->buf->lock owner releases lock; caller claims lock
+ *	       and completes
+ *	   2b) while caller waits, @tty->port->buf->lock owner attempts buffer
+ *	       flush of caller's pty; @tty->port->buf->lock owner executes
+ *	       scenario 3 below, and releases lock; caller claims lock and
+ *	       completes.
+ *	3) Caller cannot successfully claim @mutex
+ *	   By inference, @tty->port->buf->lock owner is waiting for caller's
+ *	   buf->lock (since caller must hold its own buf->lock to call this
+ *	   this function); because the @tty->port->buf->lock owner is waiting,
+ *	   its buffers can be flushed without danger of concurrent changes.
+ *
+ *	The buffer flush in scenario 3 cannot free the current head buffer and
+ *	cannot alter its read index: processing the head buffer is in-progress
+ *	by the @tty->port->buf->lock owner (waiting in scenario 2b).
+ *
+ *	The release order of @mutex first and @tty->port->buf->lock next is
+ *	essential; if the release order is reversed, the 1st caller creates a
+ *	race window which could allow another thread to claim the
+ *	@tty->port->buf->lock and yet observe the locked @mutex and erroneously
+ *	concluded the 1st caller is stuck waiting.
+ */
+
+void tty_buffer_flush_nested(struct tty_struct *tty, struct mutex *mutex)
+{
+	struct tty_port *port = tty->port;
+	struct tty_bufhead *buf = &port->buf;
+	struct tty_buffer *next;
+
+	if (mutex_trylock(mutex)) {
+		atomic_inc(&buf->priority);
+		mutex_lock_nested(&buf->lock, 1);
+		while ((next = buf->head->next) != NULL) {
+			tty_buffer_free(port, buf->head);
+			buf->head = next;
+		}
+		buf->head->read = buf->head->commit;
+		atomic_dec(&buf->priority);
+		mutex_unlock(mutex);
+		mutex_unlock(&buf->lock);
+	} else {
+		/* Because the buf->lock owner is in-progress processing the
+		 * head buffer, free only the buffers after head. Also,
+		 * the tail buffer may be in concurrent use by a parallel
+		 * pty write, so don't free the last buffer; only truncate.
+		 */
+		next = buf->head->next;
+		while (next != NULL) {
+			struct tty_buffer *tmp = next->next;
+			if (tmp != NULL)
+				tty_buffer_free(port, next);
+			else
+				tmp->read = tmp->commit;
+			next = tmp;
+		}
+	}
+}
+
+/**
  *	tty_buffer_request_room		-	grow tty buffer if needed
  *	@tty: tty structure
  *	@size: size desired
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index c28dd52..803e67d 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -38,4 +38,6 @@ static inline int tty_insert_flip_string(struct tty_port *port,
 extern void tty_buffer_lock_exclusive(struct tty_port *port);
 extern void tty_buffer_unlock_exclusive(struct tty_port *port);
 
+extern void tty_buffer_flush_nested(struct tty_struct *tty, struct mutex *);
+
 #endif /* _LINUX_TTY_FLIP_H */
-- 
1.8.1.2

