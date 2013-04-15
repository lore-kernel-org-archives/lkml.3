Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3DOP0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:26:52 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45259 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3DOP0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:26:49 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 09/16] tty: Make driver-side flip buffers lockless
Date: Mon, 15 Apr 2013 11:26:00 -0400
Message-Id: <1366039567-8620-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver-side flip buffer input is already single-threaded; 'publish'
the .next link as the last operation on the tail buffer so the
'consumer' sees the already-completed flip buffer.

The commit buffer index is already 'published' by driver-side functions.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 5d5a564..685757c 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -62,8 +62,6 @@ static void tty_buffer_reset(struct tty_buffer *p, size_t size)
  *
  *	Remove all the buffers pending on a tty whether queued with data
  *	or in the free ring. Must be called when the tty is no longer in use
- *
- *	Locking: none
  */
 
 void tty_buffer_free_all(struct tty_port *port)
@@ -216,29 +214,26 @@ void tty_buffer_flush(struct tty_struct *tty)
  *
  *	Make at least size bytes of linear space available for the tty
  *	buffer. If we fail return the size we managed to find.
- *
- *	Locking: Takes port->buf.lock
  */
 int tty_buffer_request_room(struct tty_port *port, size_t size)
 {
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_buffer *b, *n;
 	int left;
-	unsigned long flags;
-	spin_lock_irqsave(&buf->lock, flags);
+
 	b = buf->tail;
 	left = b->size - b->used;
 
 	if (left < size) {
 		/* This is the slow path - looking for new buffers to use */
 		if ((n = tty_buffer_alloc(port, size)) != NULL) {
-			b->next = n;
-			b->commit = b->used;
 			buf->tail = n;
+			b->commit = b->used;
+			smp_mb();
+			b->next = n;
 		} else
 			size = left;
 	}
-	spin_unlock_irqrestore(&buf->lock, flags);
 	return size;
 }
 EXPORT_SYMBOL_GPL(tty_buffer_request_room);
@@ -252,8 +247,6 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
  *
  *	Queue a series of bytes to the tty buffering. All the characters
  *	passed are marked with the supplied flag. Returns the number added.
- *
- *	Locking: Called functions may take port->buf.lock
  */
 
 int tty_insert_flip_string_fixed_flag(struct tty_port *port,
@@ -288,8 +281,6 @@ EXPORT_SYMBOL(tty_insert_flip_string_fixed_flag);
  *	Queue a series of bytes to the tty buffering. For each character
  *	the flags array indicates the status of the character. Returns the
  *	number added.
- *
- *	Locking: Called functions may take port->buf.lock
  */
 
 int tty_insert_flip_string_flags(struct tty_port *port,
@@ -324,19 +315,14 @@ EXPORT_SYMBOL(tty_insert_flip_string_flags);
  *	processing by the line discipline.
  *	Note that this function can only be used when the low_latency flag
  *	is unset. Otherwise the workqueue won't be flushed.
- *
- *	Locking: Takes port->buf.lock
  */
 
 void tty_schedule_flip(struct tty_port *port)
 {
 	struct tty_bufhead *buf = &port->buf;
-	unsigned long flags;
 	WARN_ON(port->low_latency);
 
-	spin_lock_irqsave(&buf->lock, flags);
 	buf->tail->commit = buf->tail->used;
-	spin_unlock_irqrestore(&buf->lock, flags);
 	schedule_work(&buf->work);
 }
 EXPORT_SYMBOL(tty_schedule_flip);
@@ -352,8 +338,6 @@ EXPORT_SYMBOL(tty_schedule_flip);
  *	accounted for as ready for normal characters. This is used for drivers
  *	that need their own block copy routines into the buffer. There is no
  *	guarantee the buffer is a DMA target!
- *
- *	Locking: May call functions taking port->buf.lock
  */
 
 int tty_prepare_flip_string(struct tty_port *port, unsigned char **chars,
@@ -382,8 +366,6 @@ EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
  *	accounted for as ready for characters. This is used for drivers
  *	that need their own block copy routines into the buffer. There is no
  *	guarantee the buffer is a DMA target!
- *
- *	Locking: May call functions taking port->buf.lock
  */
 
 int tty_prepare_flip_string_flags(struct tty_port *port,
@@ -511,18 +493,13 @@ void tty_flush_to_ldisc(struct tty_struct *tty)
  *
  *	In the event of the queue being busy for flipping the work will be
  *	held off and retried later.
- *
- *	Locking: tty buffer lock. Driver locks in low latency mode.
  */
 
 void tty_flip_buffer_push(struct tty_port *port)
 {
 	struct tty_bufhead *buf = &port->buf;
-	unsigned long flags;
 
-	spin_lock_irqsave(&buf->lock, flags);
 	buf->tail->commit = buf->tail->used;
-	spin_unlock_irqrestore(&buf->lock, flags);
 
 	if (port->low_latency)
 		flush_to_ldisc(&buf->work);
-- 
1.8.1.2

