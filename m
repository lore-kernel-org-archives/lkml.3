Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3DOP1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:27:42 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45256 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab3DOP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:26:44 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 08/16] tty: Track flip buffer memory limit atomically
Date: Mon, 15 Apr 2013 11:25:59 -0400
Message-Id: <1366039567-8620-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockless flip buffers require atomically updating the bytes-in-use
watermark.

The pty driver also peeks at the watermark value to limit
memory consumption to a much lower value than the default; query
the watermark with new fn, tty_buffer_space_avail().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c        | 10 +++-------
 drivers/tty/tty_buffer.c | 37 +++++++++++++++++++++++++++++++------
 include/linux/tty.h      |  3 +--
 include/linux/tty_flip.h |  1 +
 4 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 50bec0d..ca1472b 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -89,17 +89,13 @@ static void pty_unthrottle(struct tty_struct *tty)
  *	pty_space	-	report space left for writing
  *	@to: tty we are writing into
  *
- *	The tty buffers allow 64K but we sneak a peak and clip at 8K this
- *	allows a lot of overspill room for echo and other fun messes to
- *	be handled properly
+ *	Limit the buffer space used by ptys to 8k.
  */
 
 static int pty_space(struct tty_struct *to)
 {
-	int n = 8192 - to->port->buf.memory_used;
-	if (n < 0)
-		return 0;
-	return n;
+	int n = tty_buffer_space_avail(to->port);
+	return min(n, 8192);
 }
 
 /**
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 231b7a8..5d5a564 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -22,6 +22,31 @@
 #define MIN_TTYB_SIZE	256
 #define TTYB_ALIGN_MASK	255
 
+/*
+ * Byte threshold to limit memory consumption for flip buffers.
+ * The actual memory limit is > 2x this amount.
+ */
+#define TTYB_MEM_LIMIT	65536
+
+
+/**
+ *	tty_buffer_space_avail	-	return unused buffer space
+ *	@port - tty_port owning the flip buffer
+ *
+ *	Returns the # of bytes which can be written by the driver without
+ *	reaching the buffer limit.
+ *
+ *	Note: this does not guarantee that memory is available to write
+ *	the returned # of bytes (use tty_prepare_flip_string_xxx() to
+ *	pre-allocate if memory guarantee is required).
+ */
+
+int tty_buffer_space_avail(struct tty_port *port)
+{
+	int space = TTYB_MEM_LIMIT - atomic_read(&port->buf.memory_used);
+	return max(space, 0);
+}
+
 static void tty_buffer_reset(struct tty_buffer *p, size_t size)
 {
 	p->used = 0;
@@ -59,7 +84,8 @@ void tty_buffer_free_all(struct tty_port *port)
 	tty_buffer_reset(&buf->sentinel, 0);
 	buf->head = &buf->sentinel;
 	buf->tail = &buf->sentinel;
-	buf->memory_used = 0;
+
+	atomic_set(&buf->memory_used, 0);
 }
 
 /**
@@ -92,7 +118,7 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_port *port, size_t size)
 
 	/* Should possibly check if this fails for the largest buffer we
 	   have queued and recycle that ? */
-	if (port->buf.memory_used + size > 65536)
+	if (atomic_read(&port->buf.memory_used) > TTYB_MEM_LIMIT)
 		return NULL;
 	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
 	if (p == NULL)
@@ -100,7 +126,7 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_port *port, size_t size)
 
 found:
 	tty_buffer_reset(p, size);
-	port->buf.memory_used += size;
+	atomic_add(size, &port->buf.memory_used);
 	return p;
 }
 
@@ -118,8 +144,7 @@ static void tty_buffer_free(struct tty_port *port, struct tty_buffer *b)
 	struct tty_bufhead *buf = &port->buf;
 
 	/* Dumb strategy for now - should keep some stats */
-	buf->memory_used -= b->size;
-	WARN_ON(buf->memory_used < 0);
+	WARN_ON(atomic_sub_return(b->size, &buf->memory_used) < 0);
 
 	if (b->size > MIN_TTYB_SIZE)
 		kfree(b);
@@ -525,7 +550,7 @@ void tty_buffer_init(struct tty_port *port)
 	buf->head = &buf->sentinel;
 	buf->tail = &buf->sentinel;
 	init_llist_head(&buf->free);
-	buf->memory_used = 0;
+	atomic_set(&buf->memory_used, 0);
 	INIT_WORK(&buf->work, flush_to_ldisc);
 }
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5fe2f68..260ac7af0 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -71,8 +71,7 @@ struct tty_bufhead {
 	struct tty_buffer *head;	/* Queue head */
 	struct tty_buffer *tail;	/* Active buffer */
 	struct llist_head free;		/* Free queue head */
-	int memory_used;		/* Buffer space used excluding
-								free queue */
+	atomic_t	   memory_used; /* In-use buffers excluding free list */
 };
 /*
  * When a break, frame error, or parity error happens, these codes are
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index ad03039..6944ed2 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_TTY_FLIP_H
 #define _LINUX_TTY_FLIP_H
 
+extern int tty_buffer_space_avail(struct tty_port *port);
 extern int tty_buffer_request_room(struct tty_port *port, size_t size);
 extern int tty_insert_flip_string_flags(struct tty_port *port,
 		const unsigned char *chars, const char *flags, size_t size);
-- 
1.8.1.2

